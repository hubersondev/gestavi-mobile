import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestavi_mobile/core/api/api_exception.dart';
import 'package:gestavi_mobile/features/auth/auth_controller.dart';
import 'package:gestavi_mobile/features/auth/auth_repository.dart';
import 'package:gestavi_mobile/features/auth/models.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AuthRepository {}

final _membership = Membership(
  organisationId: 1,
  slug: 'ferme-demo',
  name: 'Fermes Kouassi & Fils',
  role: 'owner',
  roleLabel: 'Propriétaire',
  allFarms: true,
  farmIds: const [1, 2],
  permissions: const {'sales.create'},
);

final _profile = UserProfile(
  id: 1,
  name: 'Jean',
  email: 'jean@ferme-demo.ci',
  memberships: [_membership],
);

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    when(() => repository.selectOrganisation(any())).thenAnswer((_) async {});
    when(() => repository.forgetFarm()).thenAnswer((_) async {});
    when(() => repository.selectFarm(any())).thenAnswer((_) async {});
  });

  tearDown(() => container.dispose());

  test('sans jeton mémorisé, la session est déconnectée', () async {
    when(() => repository.storedProfile()).thenAnswer((_) async => null);

    final state = await container.read(authControllerProvider.future);

    expect(state, isA<Unauthenticated>());
  });

  test('la connexion choisit l\'organisation de l\'utilisateur et attend le choix de la ferme', () async {
    when(() => repository.storedProfile()).thenAnswer((_) async => null);
    when(
      () => repository.login(email: 'jean@ferme-demo.ci', password: 'password'),
    ).thenAnswer((_) async => _profile);
    when(() => repository.selectedOrganisationId())
        .thenAnswer((_) async => null);

    await container.read(authControllerProvider.future);
    await container
        .read(authControllerProvider.notifier)
        .login(email: 'jean@ferme-demo.ci', password: 'password');

    final state = container.read(authControllerProvider).value;

    expect(state, isA<Authenticated>());
    final session = state! as Authenticated;
    expect(session.membership?.slug, 'ferme-demo');
    expect(session.needsFarmChoice, isTrue);
    verify(() => repository.selectOrganisation(1)).called(1);

    await container.read(authControllerProvider.notifier).selectFarm(2);
    final after =
        container.read(authControllerProvider).value! as Authenticated;
    expect(after.farmId, 2);
    expect(after.needsFarmChoice, isFalse);
  });

  test('un refus de l\'API laisse la session déconnectée avec le message du serveur', () async {
    when(() => repository.storedProfile()).thenAnswer((_) async => null);
    when(
      () => repository.login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(
      const ApiException(
        'Identifiants incorrects.',
        statusCode: 422,
        fieldErrors: {
          'email': ['Identifiants incorrects.'],
        },
      ),
    );

    await container.read(authControllerProvider.future);
    await container
        .read(authControllerProvider.notifier)
        .login(email: 'x@y.z', password: 'faux');

    final state = container.read(authControllerProvider).value;

    expect(
      state,
      isA<Unauthenticated>().having(
        (s) => s.error,
        'error',
        'Identifiants incorrects.',
      ),
    );
  });

  test(
    'au démarrage, le profil mémorisé et la ferme choisie sont repris',
    () async {
      when(() => repository.storedProfile()).thenAnswer((_) async => _profile);
      when(() => repository.refreshProfile()).thenAnswer((_) async => _profile);
      when(() => repository.selectedOrganisationId())
          .thenAnswer((_) async => 1);
      when(() => repository.selectedFarm())
          .thenAnswer((_) async => (resolved: true, farmId: null));

      final state =
          await container.read(authControllerProvider.future) as Authenticated;

      expect(state.membership?.organisationId, 1);
      expect(state.farmResolved, isTrue);
      expect(state.farmId, isNull);
      verifyNever(() => repository.forgetFarm());
    },
  );
}
