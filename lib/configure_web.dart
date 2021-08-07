import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:winds_mobi_client/settings.dart';

void configureApp() {
  var urlStrategy;
  switch (Settings.URL_STRATEGY) {
    case 'hash':
      urlStrategy = HashUrlStrategy();
      break;
    case 'path':
      urlStrategy = PathUrlStrategy();
      break;
    default:
      throw "Invalid urlStrategy '$urlStrategy'";
  }
  setUrlStrategy(urlStrategy);
}
