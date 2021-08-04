import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum TemperatureUnits { fahrenheit, celsius }

// Events
abstract class SettingsEvent extends Equatable {}

class TemperatureUnitsToggled extends SettingsEvent {
  @override
  List<Object> get props => [];
}

// States
class SettingsState extends Equatable {
  final TemperatureUnits temperatureUnits;

  const SettingsState(this.temperatureUnits);

  @override
  List<Object> get props => [temperatureUnits];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(TemperatureUnits.celsius));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is TemperatureUnitsToggled) {
      yield SettingsState(
        state.temperatureUnits == TemperatureUnits.celsius ? TemperatureUnits.fahrenheit : TemperatureUnits.celsius,
      );
    }
  }
}
