import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winds_mobi_client/print_bloc_observer.dart';
import 'package:winds_mobi_client/services/station_service.dart';
import 'package:winds_mobi_client/services/user_service.dart';

import 'app.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

void main() async {
  configureApp();
  Bloc.observer = PrintBlocObserver();
  runApp(WindsApp(userService: UserService(), stationService: StationService()));
}
