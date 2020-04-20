import 'package:flutter/foundation.dart';

class SearchModel extends ChangeNotifier {
  String _text;

  bool isEnabled() => _text != null;

  String get text => _text;

  set text(String searchText) {
    _text = searchText;
    notifyListeners();
  }

  void clear() {
    _text = null;
    notifyListeners();
  }
}
