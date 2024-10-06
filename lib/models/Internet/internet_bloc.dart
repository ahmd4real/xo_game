import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? subscription;
  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) {
      if (event is ConnectedEvent) {
        emit(ConnectedState(internetState: true));
      } else if (event is DisconnectedEvent) {
        emit(DisconnectedState(
          internetState: true,
        ));
      }
      
    });

    subscription =Connectivity().onConnectivityChanged.listen((event  ) {
      // sameh solve it here , event retuen as list so we access it with [0]
        if (event[0] == ConnectivityResult.wifi || event[0] == ConnectivityResult.mobile) {
          add(ConnectedEvent());
          
        } else {
          add(DisconnectedEvent());
        }
        print(event.toString());
      }
     
      );
    
  }
}