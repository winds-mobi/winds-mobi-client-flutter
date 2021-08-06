import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:winds_mobi_client/app.dart';
import 'package:winds_mobi_client/screens/list.dart';
import 'package:winds_mobi_client/services/station_service.dart';
import 'package:winds_mobi_client/services/user_service.dart';

class MockUserService extends Mock implements UserService {}

class MockStationService extends Mock implements StationService {}

void main() {
  testWidgets('renders WindsApp', (WidgetTester tester) async {
    final userService = MockUserService();
    final stationService = MockStationService();
    await tester.pumpWidget(WindsApp(userService: userService, stationService: stationService));
    expect(find.byType(ListScreen), findsOneWidget);
    expect(find.text('List'), findsOneWidget);
  });
}
