import 'package:flutter/material.dart';

class PatientRecordsScreen extends StatefulWidget {
  const PatientRecordsScreen({super.key, required this.patientID});

  final String patientID;

  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}
