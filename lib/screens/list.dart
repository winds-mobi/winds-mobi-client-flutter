import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winds_mobi_client/controllers/location_bloc.dart';
import 'package:winds_mobi_client/controllers/station_list_bloc.dart';
import 'package:winds_mobi_client/models/station.dart';
import 'package:winds_mobi_client/services/station_service.dart';
import 'package:winds_mobi_client/widgets/app_bar.dart';

class ListScreen extends StatefulWidget {
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(
          'List',
          [IconButton(icon: Icon(Icons.map), onPressed: () => Navigator.pushNamed(context, '/map'))],
        ),
        body: BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
          final stationListBloc = BlocProvider.of<StationListBloc>(context);

          GeoLocation? location;
          if (state is LocationSuccess) {
            double? latitude = state.locationData.latitude;
            double? longitude = state.locationData.longitude;
            if (longitude != null && latitude != null) {
              location = GeoLocation(latitude, longitude);
            }
            stationListBloc.add(FetchStationList(location: location));
          }

          return BlocConsumer<StationListBloc, StationListState>(listener: (context, state) {
            if (state is StationListLoaded) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          }, builder: (context, state) {
            if (state is StationListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StationListLoaded) {
              return RefreshIndicator(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 1,
                    children: List.generate(state.stationList.length, (i) {
                      return buildStation(state.stationList[i]);
                    }),
                  ),
                  onRefresh: () {
                    stationListBloc.add(RefreshStationList(location: location));
                    return _refreshCompleter.future;
                  });
            } else {
              throw Exception('Unknown state: $state');
            }
          });
        }));
  }
}

buildStation(Station station) {
  return Container(
    margin: EdgeInsets.all(5.0),
    padding: EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(children: [
      Row(children: [Text("Short name"), Text(station.shortName)]),
      Row(children: [Text("Name"), Text(station.name)]),
    ]),
  );
}
