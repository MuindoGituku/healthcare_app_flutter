import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/forms/add_patient.dart';
import 'package:healthcare_app_flutter/screens/patient_details.dart';
import 'package:healthcare_app_flutter/screens/patients_search_list.dart';
import 'package:healthcare_app_flutter/services/patients_provider.dart';
import 'package:healthcare_app_flutter/widgets/empty_state.dart';
import 'package:healthcare_app_flutter/widgets/filter_button.dart';
import 'package:healthcare_app_flutter/widgets/loading_screen.dart';
import 'package:healthcare_app_flutter/widgets/patient_card.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({Key? key}) : super(key: key);

  @override
  State<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  var selectedFilter = "All Patients";
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PatientsProvider>(context, listen: false).fetchAllPatients();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
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
      body: FutureBuilder(
        future: selectedFilter == "All Patients"
            ? Provider.of<PatientsProvider>(context, listen: false)
                .fetchAllPatients()
            : Provider.of<PatientsProvider>(context, listen: false)
                .fetchCriticalPatients(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? LoadingFullScreen(
                loadingAnimationText: selectedFilter == "All Patients"
                    ? "Fetching patients from our database records..."
                    : "Fetching critical patients from our database records...",
              )
            : Consumer<PatientsProvider>(
                child: const EmptyStateScreen(
                  emptySateMessage:
                      "Fetching patients from our database records...",
                ),
                builder: (context, patientsProvider, child) => patientsProvider
                        .patients.isEmpty
                    ? child!
                    : RefreshIndicator(
                        onRefresh: () async {
                          selectedFilter == "All Patients"
                              ? await Provider.of<PatientsProvider>(context,
                                      listen: false)
                                  .fetchAllPatients()
                              : await Provider.of<PatientsProvider>(context,
                                      listen: false)
                                  .fetchCriticalPatients();
                        },
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 63,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                children: [
                                  CustomRadioButton(
                                    radioText: "All Patients",
                                    textColor: Colors.black,
                                    radioActiveColor: Colors.blueAccent,
                                    radioInactiveColor: Colors.transparent,
                                    isRadioSelected:
                                        selectedFilter == "All Patients",
                                    onTapRadio: () async {
                                      setState(() {
                                        selectedFilter = "All Patients";
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  CustomRadioButton(
                                    radioText: "Critical Condition",
                                    textColor: Colors.redAccent,
                                    radioActiveColor: Colors.redAccent,
                                    radioInactiveColor: Colors.transparent,
                                    isRadioSelected:
                                        selectedFilter == "Critical Condition",
                                    onTapRadio: () async {
                                      setState(() {
                                        selectedFilter = "Critical Condition";
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 80),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: patientsProvider.patients.length,
                                itemBuilder: (context, index) {
                                  final patient =
                                      patientsProvider.patients[index];
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 10),
                                    child: CustomPatientCard(
                                      iscritical: patient.status == "Critical",
                                      patientName:
                                          "${patient.firstName} ${patient.lastName}",
                                      doctorName: patient.doctor,
                                      department: patient.department,
                                      onTapPatientCard: () {
                                        Navigator.push(context,
                                            CupertinoPageRoute(
                                                builder: (context) {
                                          return PatientRecordsScreen(
                                            patientID: patient.id,
                                          );
                                        }));
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
