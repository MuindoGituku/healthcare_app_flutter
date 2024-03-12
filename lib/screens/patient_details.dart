import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/forms/add_test.dart';
import 'package:healthcare_app_flutter/forms/update_patient.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:healthcare_app_flutter/widgets/error_screen.dart';
import 'package:healthcare_app_flutter/widgets/loading_screen.dart';
import 'package:svg_flutter/svg.dart';

class PatientRecordsScreen extends StatefulWidget {
  const PatientRecordsScreen({super.key, required this.patientID});

  final String patientID;

  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  final PatientsDatabaseManager _databaseManager = PatientsDatabaseManager();

  @override
  void initState() {
    super.initState();
    _databaseManager.getPatientById(widget.patientID).then(
        (value) => _databaseManager.getAllTestsForPatient(widget.patientID));
  }

  @override
  void dispose() {
    _databaseManager.patientDispose();
    _databaseManager.testsDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseManager.patientStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingFullScreen(
            loadingAnimationText:
                "Fetching patient profile from our database records...",
          );
        } else if (snapshot.hasError) {
          return ErrorFullScreen(
            errorAnimationText:
                '${snapshot.error.toString()} Please try again!',
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return AddTestToPatientScreen(
                    patientID: snapshot.data!.id,
                  );
                }));
              },
              icon: SvgPicture.asset(
                "assets/images/note_add.svg",
                width: 20,
                color: Colors.white,
              ),
              label: Text(
                "Add New Test",
                style: TextStyle(),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "${snapshot.data!.firstName} ${snapshot.data!.lastName}"
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: PopupMenuButton(
                    surfaceTintColor: Colors.transparent,
                    child: SvgPicture.asset(
                      "assets/images/more_vert.svg",
                      width: 35,
                      color: Colors.white,
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return UpdatePatientProfileScreen(
                                patient: snapshot.data!,
                              );
                            }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/person_edit.svg",
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Update Patient Profile",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return AddTestToPatientScreen(
                                patientID: snapshot.data!.id,
                              );
                            }));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/note_add.svg",
                                width: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Add Test to Patient",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(child: PopupMenuDivider()),
                        PopupMenuItem(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/person_remove.svg",
                                width: 20,
                                color: Colors.redAccent,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Delete Patient Profile",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient details
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('Status: Normal'),
                        const Text('Date of Birth: 01/01/1990'),
                        const Text(
                            'Address: 941 Progress Avenune, Scarborough ON'),
                        const Text('Department: Cardiology'),
                        const Text('Doctor: Luke White'),
                      ],
                    ),
                  ),

                  // Test Records title and Add Test Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Test Records',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return AddTestToPatientScreen(
                                patientID: snapshot.data!.id,
                              );
                            }));
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),

                  // List of Tests
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 15.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category: Blood Oxygen Level',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Nurse: Megan Jenny'),
                                Text('Date Tested: 02/01/2024'),
                                Text('Reading: 94'),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category: Blood Pressure',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Nurse: Megan Jennigs'),
                                Text('Date Tested: 01/20/2024'),
                                Text('Reading: 79'),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
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
