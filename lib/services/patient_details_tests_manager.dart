import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:rxdart/rxdart.dart';

class PatientAndTests {
  final Patient patient;
  final List<Test> tests;

  PatientAndTests({required this.patient, required this.tests});
}

class PatientDetailsManager {
  final PatientsDatabaseManager _databaseManager;

  PatientDetailsManager(this._databaseManager);

  Stream<PatientAndTests> getPatientAndTests(String patientId) {
    // Ensure you have fetched the necessary data before combining the streams
    _databaseManager.getPatientById(patientId);
    _databaseManager.getAllTestsForPatient(patientId);

    return Rx.combineLatest2(
      _databaseManager.patientStream,
      _databaseManager.testsStream,
      (Patient patient, List<Test> tests) =>
          PatientAndTests(patient: patient, tests: tests),
    ).where((patAndTests) =>
        patAndTests.patient.id ==
        patientId); // Filter to ensure matching patient ID
  }
}
