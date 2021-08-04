import 'package:equatable/equatable.dart';

class Station extends Equatable {
  final String id;
  final String shortName;
  final String name;
  final String providerName;
  final StationStatus status;
  final Location location;
  final bool isPeak;
  final String timezone;
  final int altitude;
  final Measure? lastMeasure;

  const Station(
      {required this.id,
      required this.shortName,
      required this.name,
      required this.providerName,
      required this.status,
      required this.location,
      required this.altitude,
      required this.isPeak,
      required this.timezone,
      this.lastMeasure});

  @override
  List<Object?> get props => [id];

  factory Station.fromJson(dynamic json) {
    return Station(
      id: json['_id'],
      shortName: json['short'],
      name: json['name'],
      providerName: json['pv-name'],
      status: StationStatus.values.firstWhere((e) => e.toString() == 'StationStatus.${json['status']}'),
      location: Location.fromJson(json['loc']),
      altitude: json['alt'],
      isPeak: json['peak'],
      timezone: json['tz'],
    );
  }
}

enum StationStatus {
  green,
  orange,
  red,
}

class Location extends Equatable {
  final String type;
  final List<double> coordinates;

  const Location({
    required this.type,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [type, coordinates];

  factory Location.fromJson(dynamic json) {
    return Location(
      type: json['type'],
      coordinates: json['coordinates'].cast<double>(),
    );
  }
}

class Measure {}
