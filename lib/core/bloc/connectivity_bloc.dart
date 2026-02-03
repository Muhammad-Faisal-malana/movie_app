import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  ConnectivityChanged(this.isConnected);
}

abstract class ConnectivityState {}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {}

class ConnectivityDisconnected extends ConnectivityState {}

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription? _connectivitySubscription;
  final InternetConnection _internetConnection = InternetConnection();

  ConnectivityBloc() : super(ConnectivityInitial()) {
    on<ConnectivityChanged>((event, emit) {
      if (event.isConnected) {
        emit(ConnectivityConnected());
      } else {
        emit(ConnectivityDisconnected());
      }
    });

    _checkInitialStatus();
    _connectivitySubscription = _internetConnection.onStatusChange.listen((
      status,
    ) {
      add(ConnectivityChanged(status == InternetStatus.connected));
    });
  }

  Future<void> _checkInitialStatus() async {
    final status = await _internetConnection.internetStatus;
    add(ConnectivityChanged(status == InternetStatus.connected));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
