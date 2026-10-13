import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brazier/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(const BrazierApp());
    await tester.pumpAndSettle();

    // Verify that the app title is displayed.
    expect(find.textContaining('Brazier'), findsWidgets);
  });
}
