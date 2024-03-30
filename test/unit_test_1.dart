import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthcare_app_flutter/forms/add_patient.dart';

void main() {
  testWidgets('Add New Patient Button Widget Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddNewPatientScreen(),
    ));

    expect(find.text('Add New Patient'), findsOneWidget);
  });
}
