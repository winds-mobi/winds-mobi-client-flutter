import 'package:flutter_test/flutter_test.dart';
import 'package:winds_mobi_client/main.dart';

void main() {
  testWidgets('Test home page', (WidgetTester tester) async {
    await tester.pumpWidget(WindsMobiApp());
    expect(find.text('Map view'), findsOneWidget);
  });
}
