import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:khen_project/app.dart';

void main() {
  testWidgets('Login first, Sign In opens the home dashboard',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartTrackApp());

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign in to SmartTrack'), findsOneWidget);

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Juan Dela Cruz!'), findsOneWidget);
  });
}
