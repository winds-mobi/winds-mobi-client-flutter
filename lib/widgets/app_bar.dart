import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:winds_mobi_client/controllers/filter_bloc.dart';
import 'package:winds_mobi_client/controllers/location_bloc.dart';

class AppIcon extends StatelessWidget {
  @override
  Widget build(context) {
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
  Widget build(context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: BlocBuilder<FilterBloc, FilterState>(builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextFormField(
              decoration: InputDecoration(border: InputBorder.none, hintText: 'Search'),
              initialValue: (state as TextFilter).text,
              onChanged: (v) => BlocProvider.of<FilterBloc>(context).add(SetFilter(v)),
            ),
          );
        }));
  }
}

buildAppBar(title, buttons) {
  return AppBar(
    leading: AppIcon(),
    title: BlocBuilder<FilterBloc, FilterState>(builder: (context, state) {
      return state is TextFilter ? SearchTextBox() : Text(title);
    }),
    titleSpacing: 0,
    actions: <Widget>[
          BlocBuilder<FilterBloc, FilterState>(builder: (context, state) {
            final filterBloc = BlocProvider.of<FilterBloc>(context);
            return IconButton(
                icon: Icon(state is TextFilter ? Icons.cancel : Icons.search),
                onPressed: () => state is TextFilter ? filterBloc.add(ClearFilter()) : filterBloc.add(SetFilter('')));
          }),
          BlocBuilder<LocationBloc, LocationState>(builder: (context, state) {
            final locationBloc = BlocProvider.of<LocationBloc>(context);
            if (state is LocationInitial) {
              return IconButton(icon: Icon(Icons.location_off), onPressed: () => {});
            } else if (state is LocationSuccess) {
              return IconButton(icon: Icon(Icons.location_on), onPressed: () => locationBloc.add(LocationStarted()));
            }
            return IconButton(icon: Icon(Icons.location_searching), onPressed: () => {});
          })
        ] +
        buttons,
  );
}
