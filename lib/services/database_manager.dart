import 'dart:async';
import 'dart:convert';

import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class PatientsDatabaseManager {
  final String _baseUrl = "https://nodejs-healthcare-api-server.onrender.com";
  final ApiService _apiService = ApiService();

  final _patientsStreamController = StreamController<List<Patient>>.broadcast();
  Stream<List<Patient>> get patientsStream => _patientsStreamController.stream;

  final _patientStreamController = StreamController<Patient>.broadcast();
  Stream<Patient> get patientStream => _patientStreamController.stream;

  final _testsStreamController = StreamController<List<Test>>.broadcast();
  Stream<List<Test>> get testsStream => _testsStreamController.stream;

  // Fetch all patients and add them to the stream
  Future<void> fetchAllPatients() async {
    final result = await _apiService.getRequest('patients');

    if (result.isSuccess) {
      List<Patient> patients =
          (result.data as List).map((item) => Patient.fromJson(item)).toList();
      _patientsStreamController.add(patients);
    } else {
      _patientsStreamController.addError(result.error!);
    }
  }

  // Fetch all critical patients
  Future<void> getAllCriticalPatients() async {
    final result = await _apiService.getRequest('patients/critical');

    if (result.isSuccess) {
      List<Patient> patients =
          (result.data as List).map((item) => Patient.fromJson(item)).toList();
      _patientsStreamController.add(patients);
    } else {
      _patientsStreamController.addError(result.error!);
    }
  }

  // Search patients by name
  Future<void> searchPatientsByName(String searchTerm) async {
    final result = await _apiService.getRequest('patients/search/$searchTerm');

    if (result.isSuccess) {
      List<Patient> patients =
          (result.data as List).map((item) => Patient.fromJson(item)).toList();
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
      List<Test> tests =
          body.map((dynamic item) => Test.fromJson(item)).toList();
      _testsStreamController.add(tests);
    } else {
      print('Error loading tests for patient $id: ${result.error}');
    }
  }

  //Fetch test by ID
  Future<Test> getTestById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/tests/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Test.fromJson(body);
    } else {
      throw Exception('Failed to load test');
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

  void dispose() {
    _patientsStreamController.close();
    _patientStreamController.close();
    _testsStreamController.close();
  }
}
