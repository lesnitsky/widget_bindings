import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:widget_bindings/widget_bindings.dart';

void main() {
  group('StreamBinding', () {
    testWidgets('works', (tester) async {
      final ctrl = StreamController<String>();
      final stream = ctrl.stream;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: stream.$bind(
              successBuilder: (context, data, child) => Text(data),
              loadingBuilder: (context, progress) {
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error) {
                return Text(error.toString());
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      ctrl.add('Hello');
      await tester.pumpAndSettle();
      expect(find.text('Hello'), findsOneWidget);

      ctrl.addError(Exception('error'));
      await tester.pumpAndSettle();
      expect(find.text('Exception: error'), findsOneWidget);
    });
  });

  group('FutureBinding', () {
    testWidgets('works when future is resolved', (tester) async {
      final future = Future<String>.delayed(
        const Duration(seconds: 1),
        () => 'Hello',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: future.$bind(
              successBuilder: (context, data, child) => Text(data),
              loadingBuilder: (context, progress) {
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error) {
                return Text(error.toString());
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('works when future is rejected', (tester) async {
      final future = Future<String>.delayed(
        const Duration(seconds: 1),
        () => throw Exception('error'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: future.$bind(
              successBuilder: (context, data, child) => Text(data),
              loadingBuilder: (context, progress) {
                return const CircularProgressIndicator();
              },
              errorBuilder: (context, error) {
                return Text(error.toString());
              },
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Exception: error'), findsOneWidget);
    });
  });

  group('ValueNotifierBinding', () {
    testWidgets('works', (tester) async {
      final notifier = ValueNotifier<String>('Hello');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.$bind(
              builder: (context, data, child) => Text(data),
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);

      notifier.value = 'World';
      await tester.pumpAndSettle();
      expect(find.text('World'), findsOneWidget);
    });
  });

  group('ListenableBinding', () {
    testWidgets('works', (tester) async {
      final notifier = ChangeNotifier();
      var callCount = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: notifier.$bind(
              builder: (context, child) => Text('${callCount++}'),
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);

      notifier.notifyListeners();
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });
  });
}
