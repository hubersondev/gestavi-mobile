import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_exception.dart';
import 'auth_repository.dart';
import 'models.dart';

/// État de session : chargement initial, déconnecté, ou connecté avec le profil et le contexte
/// de travail. L'organisation est celle de l'utilisateur (une seule par compte aujourd'hui) ;
/// seule la ferme se choisit, et uniquement quand il y en a plusieurs.
sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Unauthenticated extends AuthState {
  const Unauthenticated({this.error});

  final String? error;
}

class Authenticated extends AuthState {
  const Authenticated({
    required this.profile,
    this.membership,
    this.farmId,
    this.farmResolved = false,
  });

  final UserProfile profile;
  final Membership? membership;

  /// Ferme de travail, null = toutes les fermes
  final int? farmId;

  /// Vrai quand la ferme a été choisie (ou déduite) pour cette session
  final bool farmResolved;

  bool get hasOrganisation => membership != null;

  bool get needsFarmChoice => hasOrganisation && !farmResolved;

  Authenticated copyWith({
    Membership? membership,
    int? farmId,
    bool? farmResolved,
  }) => Authenticated(
    profile: profile,
    membership: membership ?? this.membership,
    farmId: farmId,
    farmResolved: farmResolved ?? this.farmResolved,
  );
}

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final repository = ref.read(authRepositoryProvider);
    final stored = await repository.storedProfile();

    if (stored == null) {
      return const Unauthenticated();
    }

    final profile = await repository.refreshProfile() ?? stored;
    final membership = await _resolveMembership(repository, profile);

    if (membership == null) {
      return Authenticated(profile: profile);
    }

    final farm = await repository.selectedFarm();

    return Authenticated(
      profile: profile,
      membership: membership,
      farmId: farm.farmId,
      farmResolved: farm.resolved,
    );
  }

  Future<void> login({required String email, required String password}) async {
    final repository = ref.read(authRepositoryProvider);
    state = const AsyncValue.data(AuthLoading());

    try {
      final profile = await repository.login(email: email, password: password);
      final membership = await _resolveMembership(repository, profile);

      state = AsyncValue.data(
        Authenticated(profile: profile, membership: membership),
      );
    } on ApiException catch (e) {
      state = AsyncValue.data(
        Unauthenticated(error: e.firstErrorFor('email') ?? e.message),
      );
    }
  }

  /// Organisation de l'utilisateur : celle mémorisée si elle est toujours valable, sinon la première.
  Future<Membership?> _resolveMembership(
    AuthRepository repository,
    UserProfile profile,
  ) async {
    if (profile.memberships.isEmpty) {
      return null;
    }

    final storedId = await repository.selectedOrganisationId();
    final membership =
        (storedId == null ? null : profile.membershipFor(storedId)) ??
        profile.memberships.first;

    if (storedId != membership.organisationId) {
      await repository.selectOrganisation(membership.organisationId);
      await repository.forgetFarm();
    }

    return membership;
  }

  /// Ferme choisie par l'utilisateur, ou null pour toutes les fermes.
  Future<void> selectFarm(int? farmId) async {
    final current = state.value;

    if (current is! Authenticated) {
      return;
    }

    await ref.read(authRepositoryProvider).selectFarm(farmId);
    state = AsyncValue.data(
      current.copyWith(farmId: farmId, farmResolved: true),
    );
  }

  /// Permet de revenir au choix de la ferme depuis l'accueil.
  Future<void> changeFarm() async {
    final current = state.value;

    if (current is! Authenticated) {
      return;
    }

    await ref.read(authRepositoryProvider).forgetFarm();
    state = AsyncValue.data(
      current.copyWith(farmId: null, farmResolved: false),
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(Unauthenticated());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
