import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winds_mobi_client/controllers/authentication_bloc.dart';
import 'package:winds_mobi_client/print_bloc_observer.dart';
import 'package:winds_mobi_client/screens/list.dart';
import 'package:winds_mobi_client/screens/map.dart';
import 'package:winds_mobi_client/services/station_service.dart';
import 'package:winds_mobi_client/services/user_service.dart';

import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';
import 'controllers/filter_bloc.dart';
import 'controllers/location_bloc.dart';
import 'controllers/station_list_bloc.dart';


void main() {
  final userService = UserService();
  final stationService = StationService();

  Bloc.observer = PrintBlocObserver();

  configureApp();
  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
            AuthenticationBloc(userService)
              ..add(AppStarted()),
          ),
          BlocProvider(
              create: (context) {
                var locationBloc = LocationBloc();
                locationBloc.init();
                locationBloc.add(LocationStarted());
                return locationBloc;
              }
          ),
        ],
        child: App(stationService: stationService),
      )
  );
}

class App extends StatelessWidget {
  final StationService stationService;

  App({Key? key, required this.stationService}): super(key: key);
  
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Winds.mobi',
          home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => FilterBloc(),
                ),
                BlocProvider(
                  create: (context) => StationListBloc(stationService)..add(FetchStationList())
                ),
              ],
            child: MaterialApp(
                title: 'Winds.mobi',
                initialRoute: '/list',
                routes: {
                  '/list': (context) => ListScreen(),
                  '/map': (context) => MapScreen(),
                }
            )
          ),
        );
  }
}
