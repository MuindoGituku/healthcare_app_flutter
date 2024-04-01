import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';

class PatientsProvider extends ChangeNotifier {
  final PatientsDatabaseManager _databaseManager = PatientsDatabaseManager();

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  Patient? _currentPatient;
  Patient? get currentPatient => _currentPatient;

  List<Test> _tests = [];
  List<Test> get tests => _tests;

  Test? _currentTest;
  Test? get currentTest => _currentTest;

  Future<void> fetchAllPatients() async {
    await _databaseManager.fetchAllPatients();
    _databaseManager.patientsStream.listen((patients) {
      _patients = patients;
      notifyListeners();
    });
  }

  Future<void> fetchCriticalPatients() async {
    await _databaseManager.getAllCriticalPatients();
    _databaseManager.patientsStream.listen((patients) {
      _patients = patients;
      notifyListeners();
    });
  }

  Future<void> searchPatients(String searchTerm) async {
    await _databaseManager.searchPatientsByName(searchTerm);
    _databaseManager.patientsStream.listen((patients) {
      _patients = patients;
      notifyListeners();
    });
  }

  Future<void> addNewPatient(Patient patient) async {
    await _databaseManager.addPatient(patient);
    _databaseManager.patientsStream.listen((patients) {
      _patients = patients;
      notifyListeners();
    });
  }

  Future<void> updateSelectedPatient(Patient patient) async {
    await _databaseManager.updatePatient(patient);
    _databaseManager.patientStream.listen((patient) {
      _currentPatient = patient;
      notifyListeners();
    });
  }

  Future<void> deleteCurrentPatient(String patientID) async {
    await _databaseManager.deletePatient(patientID);
    _databaseManager.patientsStream.listen((patients) {
      _patients = patients;
      notifyListeners();
    });
  }

  Future<void> fetchSinglePatient(String id) async {
    await _databaseManager.getPatientById(id);
    _databaseManager.patientStream.listen((patient) {
      _currentPatient = patient;
      notifyListeners();
    });
  }

  Future<void> getAllTestsForPatient(String id) async {
    await _databaseManager.getAllTestsForPatient(id);
    _databaseManager.testsStream.listen((tests) {
      _tests = tests;
      notifyListeners();
    });
  }

  Future<void> fetchSingleTest(String id) async {
    await _databaseManager.getTestById(id);
    _databaseManager.testStream.listen((test) {
      _currentTest = test;
      notifyListeners();
    });
  }

  Future<void> addNewTest(Test test) async {
    await _databaseManager.addTestToPatient(test);
    await fetchSinglePatient(test.patientID).then((value) {
      _databaseManager.testsStream.listen((tests) {
        _tests = tests;
        notifyListeners();
      });
    });
  }

  Future<void> updateSelectedTest(Test test) async {
    await _databaseManager.updateTest(test);
    await fetchSinglePatient(test.patientID).then((value) {
      _databaseManager.testsStream.listen((tests) {
        _tests = tests;
        notifyListeners();
      });
    });
  }

  Future<void> deleteCurrentTest(String patientID, String testID) async {
    await _databaseManager.deleteTest(patientID, testID);
    _databaseManager.testStream.listen((test) {
      _currentTest = test;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _databaseManager.dispose();
    super.dispose();
  }
}
