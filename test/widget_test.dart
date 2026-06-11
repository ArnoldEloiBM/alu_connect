// Smoke tests for ALU Connect (feed, discovery, and RSVP/events).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alu_connect/main.dart';
import 'package:alu_connect/services/event_service.dart';
import 'package:alu_connect/services/user_session.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await UserSession.instance.init();
    await UserSession.instance.setDisplayName('Kwame');
    await EventService.instance.init();
  });

  testWidgets('Home screen renders greeting and trending feed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ALUConnectApp());
    await tester.pump();

    // Above-the-fold content on the home feed.
    expect(find.text('Welcome back, Kwame!'), findsOneWidget);
    expect(find.text('Trending Now'), findsOneWidget);
    // Filter chips.
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Hackathons'), findsOneWidget);
  });

  testWidgets('Bottom nav switches to the Discover/Search tab',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ALUConnectApp());
    await tester.pump();

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // The search field and Categories section are at the top of Discover.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
  });

  testWidgets('Typing a query shows search results',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ALUConnectApp());
    await tester.pump();

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'hackathon');
    await tester.pump();

    // Results header appears and at least one matching opportunity is shown.
    expect(find.textContaining('Results ('), findsOneWidget);
    expect(find.text('ALU Innovators Hackathon'), findsWidgets);
  });

  testWidgets('My Events tab renders RSVP management hub',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ALUConnectApp());
    await tester.pump();

    await tester.tap(find.text('My Events'));
    await tester.pumpAndSettle();

    expect(find.text('Attending'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Organizing'), findsOneWidget);
  });
}
