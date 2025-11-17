import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mind_insight/firebase_options.dart';
import 'package:mind_insight/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Mind Insight loads Login Screen successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MindInsightApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
