import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/forms/add_patient.dart';
import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:healthcare_app_flutter/screens/patient_details.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:healthcare_app_flutter/widgets/filter_button.dart';
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

  List<Patient> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  _fetchPatients() async {
    try {
      var fetchedPatients = await PatientsDatabaseManager().getAllPatients();
      setState(() {
        patients = fetchedPatients;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Failed to fetch patients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/ambulance.png",
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 15),
            Text(
              "Health Care",
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return const AddNewPatientScreen();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SvgPicture.asset(
                "assets/images/patient_add.svg",
                width: 35,
                height: 35,
                color: Colors.blueAccent,
              ),
            ),
          )
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Form(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              controller: controller,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              decoration: const InputDecoration(
                                labelText: "search for patients by name...",
                                labelStyle: TextStyle(
                                  fontSize: 13,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              "assets/images/patient_search.svg",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];

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
  }
}
