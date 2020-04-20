import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winds_mobi_client/models/search.dart';
import 'package:winds_mobi_client/widgets/app_bar.dart';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var search = Provider.of<SearchModel>(context);

    return Scaffold(
      appBar: createAppBar(
        search,
        [IconButton(icon: Icon(Icons.map), onPressed: () => Navigator.pushNamed(context, '/map'))],
      ),
      body: Center(child: Text('List view')),
    );
  }
}
