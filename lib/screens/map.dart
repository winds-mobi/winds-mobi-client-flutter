import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:winds_mobi_client/controllers/location_bloc.dart';
import 'package:winds_mobi_client/controllers/station_list_bloc.dart';
import 'package:winds_mobi_client/services/station_service.dart';
import 'package:winds_mobi_client/widgets/app_bar.dart';

import '../settings.dart';

class MapScreen extends StatefulWidget {
  @override
  MapControllerState createState() {
    return MapControllerState();
  }
}

class MapControllerState extends State<MapScreen> {
  final controller = MapController(
    location: LatLng(35.68, 51.41),
  );

  @override
  void initState() {
    controller.addListener(refresh);
    super.initState();
  }

  void refresh() {
    EasyDebounce.debounce('refresh-debouncer', Duration(milliseconds: 500), () {
      final stationListBloc = BlocProvider.of<StationListBloc>(context);
      stationListBloc
          .add(FetchStationList(location: GeoLocation(controller.center.latitude, controller.center.longitude)));
    });
  }

  @override
  void dispose() {
    controller.removeListener(refresh);
    super.dispose();
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

  bool didCenter = false;

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color, title, [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(title),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(
          'Map',
          [IconButton(icon: Icon(Icons.list), onPressed: () => Navigator.pushNamed(context, '/list'))],
        ),
        body: BlocConsumer<LocationBloc, LocationState>(listener: (context, locationState) {
          final stationListBloc = BlocProvider.of<StationListBloc>(context);
          if (locationState is LocationSuccess) {
            double? latitude = locationState.locationData.latitude;
            double? longitude = locationState.locationData.longitude;
            if (longitude != null && latitude != null) {
              controller.center = LatLng(latitude, longitude);
              stationListBloc.add(FetchStationList(location: GeoLocation(latitude, longitude)));
            }
          }
        }, builder: (context, locationState) {
          return BlocBuilder<StationListBloc, StationListState>(builder: (context, stationListState) {
            final stationListBloc = BlocProvider.of<StationListBloc>(context);
            if (!didCenter && locationState is LocationSuccess) {
              didCenter = true;
              double? latitude = locationState.locationData.latitude;
              double? longitude = locationState.locationData.longitude;
              if (longitude != null && latitude != null) {
                controller.center = LatLng(latitude, longitude);
                stationListBloc.add(FetchStationList(location: GeoLocation(latitude, longitude)));
              }
            }
            return MapLayoutBuilder(
                controller: controller,
                builder: (context, transformer) {
                  List<Widget> markerWidgets = [];
                  if (stationListState is StationListLoaded) {
                    markerWidgets = stationListState.stationList.map((station) {
                      return _buildMarkerWidget(
                        transformer.fromLatLngToXYCoords(
                            LatLng(station.location.coordinates[1], station.location.coordinates[0])),
                        Colors.blue,
                        station.name,
                      );
                    }).toList();
                  }
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onDoubleTap: _onDoubleTap,
                    onScaleStart: _onScaleStart,
                    onScaleUpdate: _onScaleUpdate,
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerSignal: (event) {
                        if (event is PointerScrollEvent) {
                          final delta = event.scrollDelta;

                          controller.zoom -= delta.dy / 1000.0;
                          setState(() {});
                        }
                      },
                      child: Stack(
                        children: [
                          Map(
                            controller: controller,
                            builder: (context, x, y, z) {
                              final url = 'https://api.mapbox.com/styles/v1/'
                                  'ysavary/ckrxfjdxsb1u717o0d0spgqa0/tiles/256/$z/$x/$y'
                                  '?access_token=${Settings.MAPBOX_ACCESS_TOKEN}';
                              return CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          ...markerWidgets,
                        ],
                      ),
                    ),
                  );
                });
          });
        }));
  }
}
