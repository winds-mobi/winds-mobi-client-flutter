class Settings {
  static const URL_STRATEGY = String.fromEnvironment('APP_URL_STRATEGY', defaultValue: 'hash');
  static const MAPBOX_ACCESS_TOKEN = String.fromEnvironment('MAPBOX_ACCESS_TOKEN');
}
