import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super(InternetInitial()) {
    StreamSubscription? stream;
    on<InternetEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(const ConnectedState(
         internetState: true,
        ));
      } else if (event is NotConnectedEvent) {
        emit(const NotConnectedState(
          internetState: true,
        ));
      }
      
    });

    stream=Connectivity().onConnectivityChanged.listen((event) {
        if (event == ConnectivityResult.mobile || event == ConnectivityResult.wifi) {
          add(ConnectedEvent());
        }else {
          add(NotConnectedEvent());
        }
      });
  }
}
