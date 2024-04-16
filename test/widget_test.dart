// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthcare_app_flutter/forms/add_patient.dart';
import 'package:healthcare_app_flutter/forms/add_test.dart';
import 'package:healthcare_app_flutter/forms/update_patient.dart';
import 'package:healthcare_app_flutter/models/patient.dart';

void main() {
  testWidgets('Add New Patient Button Widget Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddNewPatientScreen(),
    ));

    expect(find.text('Upload New Patient'), findsOneWidget);
  });

  testWidgets('Add Test Page Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddTestToPatientScreen(
        patientID: "",
      ),
    ));

    expect(find.byType(DropdownSearch<String>).hitTestable(), findsWidgets);
    expect(find.byType(TextFormField).hitTestable(), findsWidgets);
  });

  testWidgets('Page Widgets Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: UpdatePatientProfileScreen(
        patient: Patient(
          firstName: "firstName",
          lastName: "lastName",
          address: "address",
          dateOfBirth: "dateOfBirth",
          department: "department",
          doctor: "doctor",
          status: "status",
        ),
      ),
    ));

    expect(find.text('Update Patient Details'), findsOneWidget);
    expect(find.byType(DropdownSearch<String>).hitTestable(), findsWidgets);
    expect(find.byType(TextFormField).hitTestable(), findsWidgets);
  });
}
