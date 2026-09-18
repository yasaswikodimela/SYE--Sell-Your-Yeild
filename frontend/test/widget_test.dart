import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('SYE App pump smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SYEApp());

    // Verify that title/splash appears
    expect(find.text('SYE - Sell Your Yield'), findsOneWidget);
  });
}
