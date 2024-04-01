import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/screens/patient_details.dart';
import 'package:healthcare_app_flutter/services/patients_provider.dart';
import 'package:healthcare_app_flutter/widgets/empty_state.dart';
import 'package:healthcare_app_flutter/widgets/loading_screen.dart';
import 'package:healthcare_app_flutter/widgets/patient_card.dart';
import 'package:provider/provider.dart';

class PatientsSearchListScreen extends StatefulWidget {
  const PatientsSearchListScreen({super.key});

  @override
  State<PatientsSearchListScreen> createState() =>
      _PatientsSearchListScreenState();
}

class _PatientsSearchListScreenState extends State<PatientsSearchListScreen> {
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
      body: FutureBuilder(
        future: Provider.of<PatientsProvider>(context, listen: false)
            .fetchAllPatients(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? LoadingFullScreen(
                loadingAnimationText:
                    "Searching for patients matching ${controller.text} from our database records...",
              )
            : Consumer<PatientsProvider>(
                child: const LoadingFullScreen(
                  loadingAnimationText:
                      "Fetching patients from our database records...",
                ),
                builder: (context, patientsProvider, child) => patientsProvider
                        .patients.isEmpty
                    ? child!
                    : RefreshIndicator(
                        onRefresh: () async =>
                            await Provider.of<PatientsProvider>(context,
                                    listen: false)
                                .searchPatients(controller.text),
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Form(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: TextFormField(
                                    controller: controller,
                                    onChanged: (value) async {
                                      await Provider.of<PatientsProvider>(
                                              context,
                                              listen: false)
                                          .searchPatients(value);
                                    },
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText:
                                          "search for patients by name...",
                                      labelStyle: TextStyle(
                                        fontSize: 13,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            patientsProvider.patients.isEmpty
                                ? const EmptyStateScreen(
                                    emptySateMessage:
                                        "There are no patients ecorded in our database at the moment. You can upload a patient from the button below")
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: patientsProvider.patients.length,
                                    itemBuilder: (context, index) {
                                      final patient =
                                          patientsProvider.patients[index];

                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: CustomPatientCard(
                                          iscritical:
                                              patient.status == "Critical",
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
                                  )
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
