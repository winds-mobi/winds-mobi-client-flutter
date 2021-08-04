import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:winds_mobi_client/models/station.dart';

class GeoLocation {
  final double latitude, longitude;

  GeoLocation(this.latitude, this.longitude);
}

class StationService {
  final baseUrl = 'https://winds.mobi/api/2.2';
  final _client = http.Client();

  Future<List<Station>> getStationList({GeoLocation? location}) async {
    String queryPath = path.join(baseUrl, 'stations/');
    if (location != null) {
      queryPath += '?near-lat=${location.latitude}&near-lon=${location.longitude}';
    }
    var stationListJson = json.decode(await _client.read(Uri.parse(queryPath))) as List;
    return stationListJson.map((stationJson) => Station.fromJson(stationJson)).toList();
  }
}
