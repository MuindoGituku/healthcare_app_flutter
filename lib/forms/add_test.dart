import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/patients_provider.dart';
import 'package:healthcare_app_flutter/widgets/loading_widget.dart';
import 'package:healthcare_app_flutter/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

class AddTestToPatientScreen extends StatefulWidget {
  const AddTestToPatientScreen({super.key, required this.patientID});

  final String patientID;

  @override
  State<AddTestToPatientScreen> createState() => _AddTestToPatientScreenState();
}

class _AddTestToPatientScreenState extends State<AddTestToPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nurseName = TextEditingController();
  TextEditingController testReading = TextEditingController();
  DateTime testDate = DateTime.now();
  TextEditingController testDateString = TextEditingController();
  String selectedType = "";
  String selectedCategory = "";

  Future pickDate({required BuildContext context}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: testDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (selectedDate == null) return;
    setState(() {
      testDate = selectedDate;
      testDateString.text = DateFormat.yMMMEd().format(selectedDate);
    });
  }

  bool isUploadingPatient = false;

  List<String> typeOptions = [
    'Test',
  ];
  List<String> categoryOptions = [
    "Blood Pressure",
    "Blood Oxygen Level",
    "Respiratory Rate",
    "Heart Beat Rate",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Add New Test".toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nurseName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the name of the attending nurse!!";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 12,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Nurse Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => pickDate(context: context),
                child: TextFormField(
                  controller: testDateString,
                  enabled: false,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Test Date",
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownSearch(
                items: typeOptions,
                selectedItem: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select the test type!!";
                  }
                  return null;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Test Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              DropdownSearch(
                items: categoryOptions,
                selectedItem: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select the category of test!!";
                  }
                  return null;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Test Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: testReading,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the reading from the test!!";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 12,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Test Reading",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              isUploadingPatient
                  ? const LoadingWidget(
                      loadingAnimationText:
                          "Uploading new test record to the database...",
                    )
                  : GestureDetector(
                      onTap: () async {
                        setState(() {
                          isUploadingPatient = true;
                        });

                        if (_formKey.currentState!.validate()) {
                          final newTest = Test(
                            patientID: widget.patientID,
                            date: testDateString.text,
                            nurseName: nurseName.text,
                            type: selectedType,
                            category: selectedCategory,
                            readings: testReading.text,
                          );

                          await Provider.of<PatientsProvider>(context,
                                  listen: false)
                              .addNewTest(newTest)
                              .then((value) => isUploadingPatient = false)
                              .then(
                                (value) => showFeedbackSnack(
                                  context,
                                  "New Test, $selectedCategory, has been uploaded successfully!!",
                                  Colors.green,
                                ),
                              )
                              .then((value) => Navigator.pop(context));
                        } else {
                          setState(() {
                            isUploadingPatient = false;
                          });
                          showFeedbackSnack(
                            context,
                            "There are some errors in your input please check it!!",
                            Colors.red,
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/cloud_upload.svg",
                                width: 20,
                                height: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Upload New Test",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
