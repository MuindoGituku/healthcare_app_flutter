import 'dart:convert';

import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:http/http.dart' as http;

class PatientsDatabaseManager {
  final String _baseUrl = "https://nodejs-healthcare-api-server.onrender.com";

  // Fetch all patients
  Future<List<Patient>> getAllPatients() async {
    final response = await http.get(Uri.parse('$_baseUrl/patients'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Patient> patients = body
          .map((dynamic item) => Patient.fromJson(item as Map<String, dynamic>))
          .toList();
      return patients;
    } else {
      throw Exception('Failed to load patients');
    }
  }

  //Fetch patient by ID
  Future<Patient> getPatientById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/patients/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Patient.fromJson(body);
    } else {
      throw Exception('Failed to load patient');
    }
  }

  //add new patient
  Future<Patient> addPatient(Patient patient) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/patients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 201) {
      return Patient.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to add patient. Status code: ${response.statusCode}');
    }
  }
}
