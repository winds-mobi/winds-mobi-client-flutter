import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winds_mobi_client/models/search.dart';
import 'package:winds_mobi_client/screens/list.dart';
import 'package:winds_mobi_client/screens/map.dart';

class WindsMobiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchModel(),
        child: MaterialApp(
          title: 'Winds.mobi',
          initialRoute: '/map',
          routes: {
            '/map': (context) => MapScreen(),
            '/list': (context) => ListScreen(),
          },
        ));
  }
}

void main() {
  runApp(WindsMobiApp());
}
