import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sekaijin_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SekaijinApp(),
      ),
    );

    expect(find.text('Home - Coming Soon'), findsOneWidget);
  });
}
