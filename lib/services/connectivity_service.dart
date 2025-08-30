
// lib/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool> connectivityController = StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => connectivityController.stream;

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final hasConnection = result != ConnectivityResult.none;
      connectivityController.add(hasConnection);
    });
  }

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    connectivityController.close();
  }
}
