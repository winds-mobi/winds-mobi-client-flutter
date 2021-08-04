import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class SetFilter extends FilterEvent {
  final String text;
  
  const SetFilter(this.text);

  @override
  List<Object> get props => [text];
}

class ClearFilter extends FilterEvent {}

// States
abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class TextFilter extends FilterState {
  final String text;

  const TextFilter(this.text);

  @override
  List<Object> get props => [text];
}

class NoFilter extends FilterState {}

// BLoC
class FilterBloc extends Bloc<FilterEvent, FilterState> {

  FilterBloc() : super(NoFilter());

  @override
  Stream<FilterState> mapEventToState(FilterEvent event) async* {
    if (event is SetFilter) {
      yield TextFilter(event.text);
    } else if (event is ClearFilter) {
      yield NoFilter();
    }
  }
}
