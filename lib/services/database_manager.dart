import 'dart:async';
import 'dart:convert';

import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:http/http.dart' as http;

class PatientsDatabaseManager {
  final String _baseUrl = "https://nodejs-healthcare-api-server.onrender.com";

  final _patientsStreamController = StreamController<List<Patient>>.broadcast();
  Stream<List<Patient>> get patientsStream => _patientsStreamController.stream;

  final _patientStreamController = StreamController<Patient>.broadcast();
  Stream<Patient> get patientStream => _patientStreamController.stream;

  final _testsStreamController = StreamController<List<Test>>.broadcast();
  Stream<List<Test>> get testsStream => _testsStreamController.stream;

  // Fetch all patients and add them to the stream
  Future<void> fetchAllPatients() async {
    final response = await http.get(Uri.parse('$_baseUrl/patients'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Patient> patients = body
          .map((dynamic item) => Patient.fromJson(item as Map<String, dynamic>))
          .toList();
      _patientsStreamController.add(patients); // Add patients to the stream
    } else {
      throw Exception('Failed to load patients');
    }
  }

  // Fetch all critical patients
  Future<void> getAllCriticalPatients() async {
    final response = await http.get(Uri.parse('$_baseUrl/patients/critical'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Patient> patients = body
          .map((dynamic item) => Patient.fromJson(item as Map<String, dynamic>))
          .toList();
      _patientsStreamController
          .add(patients); // Add critical patients to the stream
    } else {
      throw Exception('Failed to load patients');
    }
  }

  // Search patients by name
  Future<void> searchPatientsByName(String searchTerm) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/patients/search/$searchTerm'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Patient> patients = body
          .map((dynamic item) => Patient.fromJson(item as Map<String, dynamic>))
          .toList();
      _patientsStreamController
          .add(patients); // Add matching patients to the stream
    } else {
      throw Exception('Failed to load patients');
    }
  }

  //Fetch patient by ID
  Future<void> getPatientById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/patients/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      Patient patient = Patient.fromJson(body);
      _patientStreamController.add(patient);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  // Add new patient and refresh the patients stream
  Future<void> addPatient(Patient patient) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/patients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 201) {
      await fetchAllPatients(); // Refresh the patients stream
    } else {
      throw Exception(
          'Failed to add patient. Status code: ${response.statusCode}');
    }
  }

  // Update selected patient and refresh the patients stream
  Future<void> updatePatient(Patient patient) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/patients/${patient.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      await fetchAllPatients(); // Refresh the patients stream
    } else {
      throw Exception(
          'Failed to update patient. Status code: ${response.statusCode}');
    }
  }

  //fetch all tests for a patient
  Future<void> getAllTestsForPatient(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/patients/$id/tests'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Test> tests = body
          .map((dynamic item) => Test.fromJson(item as Map<String, dynamic>))
          .toList();
      _testsStreamController.add(tests); // Add tests to the stream
    } else {
      throw Exception('Failed to load tests for this patient');
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

  //add new test to patient
  Future<void> addTestToPatient(Test test) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/patients/${test.patientID}/tests'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(test.toJson()),
    );

    if (response.statusCode == 201) {
      await getAllTestsForPatient(test.patientID);
    } else {
      throw Exception(
          'Failed to add test to patient. Status code: ${response.statusCode}');
    }
  }

  //update selected test
  Future<void> updateTest(Test test) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/patients/${test.patientID}/tests/${test.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(test.toJson()),
    );

    if (response.statusCode == 201) {
      await getAllTestsForPatient(test.patientID);
    } else {
      throw Exception(
          'Failed to update test. Status code: ${response.statusCode}');
    }
  }

  void patientsDispose() {
    _patientsStreamController.close();
  }

  void patientDispose() {
    _patientStreamController.close();
  }

  void testsDispose() {
    _testsStreamController.close();
  }
}
