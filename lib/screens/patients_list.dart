import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/forms/add_patient.dart';
import 'package:healthcare_app_flutter/screens/patient_details.dart';
import 'package:healthcare_app_flutter/screens/patients_search_list.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:healthcare_app_flutter/widgets/error_screen.dart';
import 'package:healthcare_app_flutter/widgets/filter_button.dart';
import 'package:healthcare_app_flutter/widgets/loading_screen.dart';
import 'package:healthcare_app_flutter/widgets/patient_card.dart';
import 'package:svg_flutter/svg.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  var selectedFilter = "All Patients";
  TextEditingController controller = TextEditingController();

  final PatientsDatabaseManager _databaseManager = PatientsDatabaseManager();

  @override
  void initState() {
    super.initState();
    _databaseManager.fetchAllPatients();
  }

  @override
  void dispose() {
    _databaseManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseManager.patientsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingFullScreen(
            loadingAnimationText:
                "Fetching patients from our database records...",
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
                  return const AddNewPatientScreen();
                }));
              },
              label: const Text(
                "Add New Patient",
              ),
            ),
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "Health Care",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return const PatientsSearchListScreen();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset(
                      "assets/images/patient_search.svg",
                      width: 35,
                      height: 35,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async => await _databaseManager.fetchAllPatients(),
              child: ListView(
                children: [
                  SizedBox(
                    height: 63,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      children: [
                        CustomRadioButton(
                          radioText: "All Patients",
                          textColor: Colors.black,
                          radioActiveColor: Colors.blueAccent,
                          radioInactiveColor: Colors.transparent,
                          isRadioSelected: selectedFilter == "All Patients",
                          onTapRadio: () =>
                              setState(() => selectedFilter == "All Patients"),
                        ),
                        const SizedBox(width: 15),
                        CustomRadioButton(
                          radioText: "Critical Condition",
                          textColor: Colors.redAccent,
                          radioActiveColor: Colors.redAccent,
                          radioInactiveColor: Colors.transparent,
                          isRadioSelected:
                              selectedFilter == "Critical Condition",
                          onTapRadio: () => setState(
                              () => selectedFilter == "Critical Condition"),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //   child: Form(
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.8,
                  //           child: TextFormField(
                  //             controller: controller,
                  //             style: const TextStyle(
                  //               fontSize: 12,
                  //             ),
                  //             decoration: const InputDecoration(
                  //               labelText: "search for patients by name...",
                  //               labelStyle: TextStyle(
                  //                 fontSize: 13,
                  //               ),
                  //               border: OutlineInputBorder(),
                  //             ),
                  //           ),
                  //         ),
                  //         IconButton(
                  //           onPressed: () {},
                  //           icon: SvgPicture.asset(
                  //             "assets/images/patient_search.svg",
                  //             width: 30,
                  //             height: 30,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final patient = snapshot.data![index];

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: CustomPatientCard(
                          iscritical: patient.status == "Critical",
                          patientName:
                              "${patient.firstName} ${patient.lastName}",
                          doctorName: patient.doctor,
                          department: patient.department,
                          onTapPatientCard: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) {
                              return PatientRecordsScreen(
                                patientID: patient.id,
                              );
                            }));
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          return const ErrorFullScreen(
            errorAnimationText:
                'No patients data has been found in our archives. Please try again!',
          );
        }
      },
    );
  }
}
