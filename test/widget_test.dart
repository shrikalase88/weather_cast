import 'package:flutter_test/flutter_test.dart';
import 'package:weather_cast/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WeatherApp());
    expect(find.text('Weather Cast'), findsOneWidget);
  });
}
