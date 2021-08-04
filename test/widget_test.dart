import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:winds_mobi_client/main.dart';
import 'package:winds_mobi_client/services/station_service.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([StationService])
void main() {
  testWidgets('Test home page', (WidgetTester tester) async {
    var stationService = MockStationService();
    await tester.pumpWidget(App(stationService: stationService));
    expect(find.text('Winds.mobi'), findsOneWidget);
  });
}
