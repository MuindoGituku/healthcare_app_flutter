// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:healthcare_app_flutter/forms/add_test.dart';
import 'package:healthcare_app_flutter/forms/update_patient.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:healthcare_app_flutter/services/patients_provider.dart';
import 'package:healthcare_app_flutter/widgets/empty_state.dart';
import 'package:healthcare_app_flutter/widgets/error_screen.dart';
import 'package:healthcare_app_flutter/widgets/loading_screen.dart';
import 'package:healthcare_app_flutter/widgets/patient_profile_card.dart';
import 'package:healthcare_app_flutter/widgets/snack_bar.dart';
import 'package:healthcare_app_flutter/widgets/test_card.dart';
import 'package:provider/provider.dart';
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
    Provider.of<PatientsProvider>(context, listen: false)
        .fetchSinglePatient(widget.patientID);
    Provider.of<PatientsProvider>(context, listen: false)
        .getAllTestsForPatient(widget.patientID);
  }

  @override
  void dispose() {
    _databaseManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<PatientsProvider>(context, listen: false)
          .fetchSinglePatient(widget.patientID),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const LoadingFullScreen(
              loadingAnimationText:
                  "Fetching patient profile from our database records...",
            )
          : Consumer<PatientsProvider>(
              child: ErrorFullScreen(
                errorAnimationText:
                    '${snapshot.error.toString()} Please try again!',
              ),
              builder: (context, patientProvider, child) => patientProvider
                          .currentPatient ==
                      null
                  ? child!
                  : Scaffold(
                      floatingActionButton: FloatingActionButton.extended(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return AddTestToPatientScreen(
                              patientID: patientProvider.currentPatient!.id,
                            );
                          }));
                        },
                        icon: SvgPicture.asset(
                          "assets/images/note_add.svg",
                          width: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Add New Test",
                          style: TextStyle(),
                        ),
                      ),
                      appBar: AppBar(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        centerTitle: true,
                        title: Text(
                          "${patientProvider.currentPatient!.firstName} ${patientProvider.currentPatient!.lastName}"
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
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return UpdatePatientProfileScreen(
                                          patient:
                                              patientProvider.currentPatient!,
                                        );
                                      }));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/person_edit.svg",
                                          width: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Update Patient Profile",
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return AddTestToPatientScreen(
                                          patientID: patientProvider
                                              .currentPatient!.id,
                                        );
                                      }));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/note_add.svg",
                                          width: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Add Test to Patient",
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                      child: PopupMenuDivider()),
                                  PopupMenuItem(
                                    onTap: () {
                                      _showDeleteConfirmationDialog(
                                        context,
                                        patientProvider.currentPatient!.id,
                                        patientProvider
                                            .currentPatient!.firstName,
                                        patientProvider
                                            .currentPatient!.lastName,
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/person_remove.svg",
                                          width: 20,
                                          color: Colors.redAccent,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Delete Patient",
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
                      body: RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<PatientsProvider>(context,
                                  listen: false)
                              .fetchSinglePatient(widget.patientID);
                          await Provider.of<PatientsProvider>(context,
                                  listen: false)
                              .getAllTestsForPatient(widget.patientID);
                        },
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                          children: [
                            PatientProfileCard(
                                patient: patientProvider.currentPatient!),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Test Records',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          CupertinoPageRoute(
                                              builder: (context) {
                                        return AddTestToPatientScreen(
                                          patientID: patientProvider
                                              .currentPatient!.id,
                                        );
                                      }));
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                            patientProvider.tests.isEmpty
                                ? EmptyStateScreen(
                                    emptySateMessage:
                                        "There are not tests in the database recorded for ${patientProvider.currentPatient!.firstName} ${patientProvider.currentPatient!.lastName}!!")
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: patientProvider.tests.length,
                                    itemBuilder: (context, index) {
                                      return SingleTestCard(
                                        test: patientProvider.tests[index],
                                        isLatestTest: index == 0,
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }
}

void _showDeleteConfirmationDialog(
    BuildContext context, String patientID, String firstName, String lastName) {
  showDialog(
    context: context,
    builder: (context) => Platform.isIOS
        ? CupertinoAlertDialog(
            title: const Text("Confirm Delete"),
            content:
                const Text("Are you sure you want to delete this patient?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await Provider.of<PatientsProvider>(context, listen: false)
                      .deleteCurrentPatient(patientID)
                      .then(
                        (value) => showFeedbackSnack(
                          context,
                          "Patient data for $firstName $lastName, has been deleted successfully!!",
                          Colors.green,
                        ),
                      )
                      .then((value) => Navigator.pop(context))
                      .then((value) => Navigator.pop(context));
                },
                child: const Text("Delete"),
              ),
            ],
          )
        : AlertDialog(
            title: const Text("Confirm Delete"),
            content:
                const Text("Are you sure you want to delete this patient?"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await Provider.of<PatientsProvider>(context, listen: false)
                      .deleteCurrentPatient(patientID)
                      .then(
                        (value) => showFeedbackSnack(
                          context,
                          "Patient data for $firstName $lastName, has been deleted successfully!!",
                          Colors.green,
                        ),
                      )
                      .then((value) => Navigator.pop(context))
                      .then((value) => Navigator.pop(context));
                },
                child: const Text("Delete"),
              ),
            ],
          ),
  );
}
