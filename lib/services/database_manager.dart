import 'dart:async';

import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/api_service.dart';

class PatientsDatabaseManager {
  final ApiService _apiService = ApiService();

  final _patientsStreamController = StreamController<List<Patient>>.broadcast();
  Stream<List<Patient>> get patientsStream => _patientsStreamController.stream;

  final _patientStreamController = StreamController<Patient>.broadcast();
  Stream<Patient> get patientStream => _patientStreamController.stream;

  final _testsStreamController = StreamController<List<Test>>.broadcast();
  Stream<List<Test>> get testsStream => _testsStreamController.stream;

  final _testStreamController = StreamController<Test>.broadcast();
  Stream<Test> get testStream => _testStreamController.stream;

  // Fetch all patients and add them to the stream
  Future<void> fetchAllPatients() async {
    final result = await _apiService.getRequest('patients');

    if (result.isSuccess) {
      List<Patient> patients = (result.data as List)
          .map((item) => Patient.fromJson(item))
          .toList()
          .reversed
          .toList();
      _patientsStreamController.add(patients);
    } else {
      _patientsStreamController.addError(result.error!);
    }
  }

  // Fetch all critical patients
  Future<void> getAllCriticalPatients() async {
    final result = await _apiService.getRequest('patients/critical');

    if (result.isSuccess) {
      List<Patient> patients = (result.data as List)
          .map((item) => Patient.fromJson(item))
          .toList()
          .reversed
          .toList();
      _patientsStreamController.add(patients);
    } else {
      _patientsStreamController.addError(result.error!);
    }
  }

  // Search patients by name
  Future<void> searchPatientsByName(String searchTerm) async {
    final result = await _apiService.getRequest('patients/search/$searchTerm');

    if (result.isSuccess) {
      List<Patient> patients = (result.data as List)
          .map((item) => Patient.fromJson(item))
          .toList()
          .reversed
          .toList();
      _patientsStreamController.add(patients);
    } else {
      _patientsStreamController.addError(result.error!);
    }
  }

  //Fetch patient by ID
  Future<void> getPatientById(String id) async {
    final result = await _apiService.getRequest('patients/$id');

    if (result.isSuccess) {
      Patient patient = Patient.fromJson(result.data);
      _patientStreamController.add(patient);
    } else {
      _patientStreamController.addError(result.error!);
    }
  }

  // Add new patient and refresh the patients stream
  Future<void> addPatient(Patient patient) async {
    final result = await _apiService.postRequest('patients', patient.toJson());
    if (result.isSuccess) {
      await fetchAllPatients();
    } else {
      print('Error adding patient: ${result.error}');
    }
  }

// Update selected patient and refresh the patients stream
  Future<void> updatePatient(Patient patient) async {
    final result = await _apiService.putRequest(
        'patients/${patient.id}', patient.toJson());
    if (result.isSuccess) {
      await getPatientById(patient.id);
    } else {
      print('Error updating patient: ${result.error}');
    }
  }

  // Fetch all tests for a patient
  Future<void> getAllTestsForPatient(String id) async {
    final result = await _apiService.getRequest('patients/$id/tests');
    if (result.isSuccess) {
      List<dynamic> body = result.data;
      List<Test> tests = body
          .map((dynamic item) => Test.fromJson(item))
          .toList()
          .reversed
          .toList();
      _testsStreamController.add(tests);
    } else {
      print('Error loading tests for patient $id: ${result.error}');
    }
  }

  //Fetch test by ID
  Future<void> getTestById(String id) async {
    final result = await _apiService.getRequest('tests/$id');

    if (result.isSuccess) {
      Test test = Test.fromJson(result.data);
      _testStreamController.add(test);
    } else {
      _testStreamController.addError(result.error!);
    }
  }

  // Add new test to a patient
  Future<void> addTestToPatient(Test test) async {
    final result = await _apiService.postRequest(
      'patients/${test.patientID}/tests',
      test.toJson(),
    );

    if (result.isSuccess) {
      await getAllTestsForPatient(test.patientID);
    } else {
      print('Failed to add test to patient. Error: ${result.error}');
    }
  }

  // Update selected test
  Future<void> updateTest(Test test) async {
    final result = await _apiService.putRequest(
      'patients/${test.patientID}/tests/${test.id}',
      test.toJson(),
    );

    if (result.isSuccess) {
      await getAllTestsForPatient(test.patientID);
    } else {
      print('Failed to update test. Error: ${result.error}');
    }
  }

// delete a test
  Future<void> deleteTest(String patientID, String testID) async {
    final result = await _apiService.deleteRequest('tests/$testID');

    if (result.isSuccess) {
      // Fetch updated tests after deletion
      await getAllTestsForPatient(patientID);
    } else {
      print('Failed to delete test. Error: ${result.error}');
    }
  }

  // delete a patient
  Future<void> deletePatient(String patientID) async {
    final result = await _apiService.deleteRequest('patients/$patientID');

    if (result.isSuccess) {
      // Fetch updated tests after deletion
      await fetchAllPatients();
    } else {
      print('Failed to delete patient. Error: ${result.error}');
    }
  }

  void dispose() {
    _patientsStreamController.close();
    _patientStreamController.close();
    _testsStreamController.close();
  }
}
