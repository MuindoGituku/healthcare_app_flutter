import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/screens/patient_details.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:healthcare_app_flutter/widgets/error_screen.dart';
import 'package:healthcare_app_flutter/widgets/loading_screen.dart';
import 'package:healthcare_app_flutter/widgets/patient_card.dart';

class PatientsSearchListScreen extends StatefulWidget {
  const PatientsSearchListScreen({super.key});

  @override
  State<PatientsSearchListScreen> createState() =>
      _PatientsSearchListScreenState();
}

class _PatientsSearchListScreenState extends State<PatientsSearchListScreen> {
  TextEditingController controller = TextEditingController();

  final PatientsDatabaseManager _databaseManager = PatientsDatabaseManager();

  @override
  void initState() {
    super.initState();
    _databaseManager.fetchAllPatients();
  }

  @override
  void dispose() {
    _databaseManager.patientsDispose();
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
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                "Search For Patients".toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async => await _databaseManager.fetchAllPatients(),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Form(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: controller,
                          onChanged: (value) async {
                            await _databaseManager.searchPatientsByName(value);
                          },
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
                    ),
                  ),
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
