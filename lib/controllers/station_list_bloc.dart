import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:winds_mobi_client/models/station.dart';
import 'package:winds_mobi_client/services/station_service.dart';

// Events
abstract class StationListEvent extends Equatable {
  const StationListEvent();
}

class FetchStationList extends StationListEvent {
  final GeoLocation? location;

  const FetchStationList({this.location});

  @override
  List<Object?> get props => [location];
}

class RefreshStationList extends StationListEvent {
  final GeoLocation? location;

  const RefreshStationList({this.location});

  @override
  List<Object?> get props => [location];
}

// States
abstract class StationListState extends Equatable {
  const StationListState();

  @override
  List<Object> get props => [];
}

class StationListLoading extends StationListState {}

class StationListLoaded extends StationListState {
  final List<Station> stationList;
  final lastUpdated = DateTime.now();

  StationListLoaded(this.stationList);

  @override
  List<Object> get props => [stationList, lastUpdated];

  @override
  String toString() {
    return '$runtimeType(${stationList.length})';
  }
}

class StationListError extends StationListState {}

// BLoC
class StationListBloc extends Bloc<StationListEvent, StationListState> {
  final StationService stationService;

  StationListBloc(this.stationService) : super(StationListLoading());

  @override
  Stream<StationListState> mapEventToState(StationListEvent event) async* {
    if (event is FetchStationList) {
      yield* _mapFetchStationListToState(event);
    } else if (event is RefreshStationList) {
      yield* _mapRefreshStationListToState(event);
    }
  }

  Stream<StationListState> _mapFetchStationListToState(FetchStationList event) async* {
    yield StationListLoading();
    try {
      final List<Station> stationList = await stationService.getStationList(location: event.location);
      yield StationListLoaded(stationList);
    } catch (_) {
      yield StationListError();
    }
  }

  Stream<StationListState> _mapRefreshStationListToState(RefreshStationList event) async* {
    try {
      final List<Station> stationList = await stationService.getStationList(location: event.location);
      yield StationListLoaded(stationList);
    } catch (_) {
      yield state;
    }
  }
}
