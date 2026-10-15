import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_queue.dart';

/// Synchronisation de fond : dès que le réseau revient, les saisies en attente partent
/// sans intervention. Un seul envoi à la fois.
class SyncService {
  SyncService({required SyncQueueRepository queue, Connectivity? connectivity})
    : _queue = queue,
      _connectivity = connectivity ?? Connectivity();

  final SyncQueueRepository _queue;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _running = false;

  void start({required int organisationId, required String organisationSlug}) {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        unawaited(
          pushNow(
            organisationId: organisationId,
            organisationSlug: organisationSlug,
          ),
        );
      }
    });
  }

  Future<int> pushNow({
    required int organisationId,
    required String organisationSlug,
  }) async {
    if (_running) {
      return 0;
    }

    _running = true;

    try {
      return await _queue.pushQuietly(
        organisationId: organisationId,
        organisationSlug: organisationSlug,
      );
    } catch (_) {
      // Une erreur non réseau (jeton révoqué, données refusées) est visible dans la file, pas ici
      return 0;
    } finally {
      _running = false;
    }
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final service = SyncService(queue: ref.watch(syncQueueProvider));
  ref.onDispose(service.stop);

  return service;
});
