// Mocks generated by Mockito 5.0.13 from annotations
// in winds_mobi_client/test/widget_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:winds_mobi_client/models/station.dart' as _i4;
import 'package:winds_mobi_client/services/station_service.dart' as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [StationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockStationService extends _i1.Mock implements _i2.StationService {
  MockStationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get baseUrl =>
      (super.noSuchMethod(Invocation.getter(#baseUrl), returnValue: '')
          as String);
  @override
  _i3.Future<List<_i4.Station>> getStationList({_i2.GeoLocation? location}) =>
      (super.noSuchMethod(
              Invocation.method(#getStationList, [], {#location: location}),
              returnValue: Future<List<_i4.Station>>.value(<_i4.Station>[]))
          as _i3.Future<List<_i4.Station>>);
  @override
  String toString() => super.toString();
}
