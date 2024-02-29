import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/forms/add_test.dart';
import 'package:healthcare_app_flutter/forms/update_test.dart';
import 'package:healthcare_app_flutter/forms/update_patient.dart';
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
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient details
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Status: Normal'),
                          Text('Date of Birth: 01/01/1990'),
                          Text('Address: 941 Progress Avenune, Scarborough ON'),
                          Text('Department: Cardiology'),
                          Text('Doctor: Luke White'),
                        ],
                      ),
                    ),

                    // Update Patient and Delete Patient Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.refresh),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              onPrimary: Colors.white,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return const UpdatePatientProfileScreen();
                            }));
                          },
                          child: Text('Update Patient'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              onPrimary: Colors.white,
                              textStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {},
                          child: Text('Delete Patient'),
                        ),
                      ],
                    ),

                    // Test Records title and Add Test Button
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Test Records',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return const AddTestToPatientScreen();
                              }));
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),

                    // List of Tests
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: Blood Oxygen Level',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Nurse: Megan Jenny'),
                                  Text('Date Tested: 02/01/2024'),
                                  Text('Reading: 94'),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Category: Blood Pressure',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Nurse: Megan Jennigs'),
                                  Text('Date Tested: 01/20/2024'),
                                  Text('Reading: 79'),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
