import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';

class UpdateTestScreen extends StatefulWidget {
  const UpdateTestScreen({super.key, required this.test});

  final Test test;

  @override
  State<UpdateTestScreen> createState() => _UpdateTestScreenState();
}

class _UpdateTestScreenState extends State<UpdateTestScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientsDatabaseManager _databaseManager = PatientsDatabaseManager();

  TextEditingController nurseName = TextEditingController();
  TextEditingController testReading = TextEditingController();
  TextEditingController selectedTestDate = TextEditingController();
  DateTime testDate = DateTime.now();
  String selectedType = "";
  String selectedCategory = "";

  bool isUploadingPatient = false;

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
      selectedTestDate.text = DateFormat.yMMMEd().format(selectedDate);
    });
  }

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
  void initState() {
    super.initState();

    nurseName.text = widget.test.nurseName;
    testReading.text = widget.test.readings;
    selectedTestDate.text = widget.test.date;
    selectedType = widget.test.type;
    selectedCategory = widget.test.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Update Test Details".toUpperCase(),
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
                  controller: selectedTestDate,
                  enabled: false,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Test Date",
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
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedTest = Test(
                      id: widget.test.id,
                      patientID: widget.test.patientID,
                      date: selectedTestDate.text,
                      nurseName: nurseName.text,
                      type: selectedType,
                      category: selectedCategory,
                      readings: testReading.text,
                    );
                    await _databaseManager
                        .updateTest(updatedTest)
                        .then((value) => Navigator.pop(context));
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
                          "Update Selected Test",
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
