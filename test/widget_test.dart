import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khen_project/app.dart';
import 'package:khen_project/screens/report_form_screen.dart';

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

    expect(find.text('Khen L. Lumindas'), findsOneWidget);
  });

  testWidgets('Quick action "File a Report" opens the Report Form',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartTrackApp());
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('File a Report'));
    await tester.tap(find.text('File a Report'));
    await tester.pumpAndSettle();

    expect(find.byType(ReportFormScreen), findsOneWidget);
    expect(find.text('Report Details'), findsOneWidget);
  });

  testWidgets('Empty report form shows field-level validation errors',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartTrackApp());
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('File a Report'));
    await tester.tap(find.text('File a Report'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Submit Report'));
    await tester.tap(find.text('Submit Report'));
    await tester.pumpAndSettle();

    expect(find.text('Report title is required.'), findsOneWidget);
    expect(find.text('Destination / location is required.'), findsOneWidget);
    expect(find.text('Description is required.'), findsOneWidget);
  });

  testWidgets('Valid submit enters Loading then Success state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartTrackApp());
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('File a Report'));
    await tester.tap(find.text('File a Report'));
    await tester.pumpAndSettle();

    await _enterTextAt(tester, 0, 'Missing clearance form');
    await _enterTextAt(tester, 1, 'Japan, Tokyo Tech');
    await _enterTextAt(
      tester,
      2,
      'The faculty clearance form was not issued before departure.',
    );

    await tester.ensureVisible(find.text('Submit Report'));
    await tester.tap(find.text('Submit Report'));
    await tester.pump();

    expect(find.text('Submitting report'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Submitting...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Report submitted'), findsOneWidget);
    expect(find.text('Submitted Reports'), findsOneWidget);
  });

  testWidgets('Simulated failure shows Error state with Retry',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartTrackApp());
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('File a Report'));
    await tester.tap(find.text('File a Report'));
    await tester.pumpAndSettle();

    await _enterTextAt(tester, 0, 'Missing clearance form');
    await _enterTextAt(tester, 1, 'Japan, Tokyo Tech');
    await _enterTextAt(
      tester,
      2,
      'The faculty clearance form failed to issue before departure.',
    );

    await tester.ensureVisible(find.text('Submit Report'));
    await tester.tap(find.text('Submit Report'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Submission failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Submission failed'), findsOneWidget);
  });

  testWidgets('Preview with no records shows Empty state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1440, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const SmartTrackApp());
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('File a Report'));
    await tester.tap(find.text('File a Report'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Preview Reports'));
    await tester.tap(find.text('Preview Reports'));
    await tester.pump();

    expect(find.text('Loading reports'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('No reports available'), findsOneWidget);
    expect(find.text('Create a Report'), findsOneWidget);
  });
}

Future<void> _enterTextAt(
  WidgetTester tester,
  int fieldIndex,
  String text,
) async {
  final Finder finder = find.descendant(
    of: find.byType(ReportFormScreen),
    matching: find.byType(TextFormField),
  );
  expect(finder, findsNWidgets(3));
  final Finder target = finder.at(fieldIndex);
  await tester.ensureVisible(target);
  await tester.enterText(target, text);
  await tester.pump();
}
