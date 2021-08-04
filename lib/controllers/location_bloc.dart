import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

// Events
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class LocationStarted extends LocationEvent {}

class LocationChanged extends LocationEvent {
  final LocationData locationData;

  const LocationChanged(this.locationData);

  @override
  List<Object> get props => [locationData];
}

// States
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationInProgress extends LocationState {}

class LocationSuccess extends LocationState {
  final LocationData locationData;

  const LocationSuccess(this.locationData);

  @override
  List<Object> get props => [locationData];
}

// BLoC
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  late Location location;
  StreamSubscription? _locationSubscription;

  LocationBloc() : super(LocationInitial());

  init() async {
    location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is LocationStarted) {
      yield LocationInProgress();
      _locationSubscription?.cancel();
      _locationSubscription = location.onLocationChanged.listen((LocationData locationData) => add(
            LocationChanged(locationData),
          ));
    } else if (event is LocationChanged) {
      yield LocationSuccess(event.locationData);
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
