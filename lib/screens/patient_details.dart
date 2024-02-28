import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';

class PatientRecordsScreen extends StatefulWidget {
  const PatientRecordsScreen({super.key, required this.patientID});

  final String patientID;

  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  late Future<Patient> patient;

  @override
  void initState() {
    super.initState();
    patient = PatientsDatabaseManager().getPatientById(widget.patientID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: patient,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
              ),
            ),
            body: Column(
              children: [],
            ),
          );
        } else {
          return Scaffold(
            body: const Center(
              child: Text(
                'No patient data available',
              ),
            ),
          );
        }
      },
    );
  }
}
