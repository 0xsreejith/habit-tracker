import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/presentation/widgets/my_habit_tile.dart';

void main() {
  testWidgets('MyHabitTile renders habit text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyHabitTile(
            text: 'Read 10 pages',
            isCompleted: false,
            onChanged: (_) {},
            editHabit: (_) {},
            deleteHabit: (_) {},
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Read 10 pages'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });

  testWidgets('MyHabitTile triggers checkbox and tap callbacks', (
    WidgetTester tester,
  ) async {
    bool? checkboxValue;
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MyHabitTile(
            text: 'Meditate',
            isCompleted: false,
            onChanged: (value) => checkboxValue = value,
            editHabit: (_) {},
            deleteHabit: (_) {},
            onTap: () => tapCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(checkboxValue, isTrue);

    await tester.tap(find.text('Meditate'));
    await tester.pumpAndSettle();
    expect(tapCount, 1);
  });
}
