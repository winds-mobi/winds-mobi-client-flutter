import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winds_mobi_client/models/search.dart';

class AppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Image.asset(
          'assets/images/windmobile.png',
          fit: BoxFit.contain,
          height: 32,
        ),
      ),
    );
  }
}

class SearchTextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var search = Provider.of<SearchModel>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextFormField(
          decoration: InputDecoration(border: InputBorder.none, hintText: 'Search'),
          initialValue: search.text,
          onChanged: (v) => search.text = v,
        ),
      ),
    );
  }
}

createAppBar(SearchModel search, buttons) {
  return AppBar(
    leading: AppIcon(),
    title: search.isEnabled() ? SearchTextBox() : Text('Map'),
    titleSpacing: 0,
    actions: <Widget>[
      IconButton(
          icon: Icon(search.isEnabled() ? Icons.cancel : Icons.search),
          onPressed: () => search.isEnabled() ? search.clear() : search.text = ''
      )
    ] + buttons,
  );
}
