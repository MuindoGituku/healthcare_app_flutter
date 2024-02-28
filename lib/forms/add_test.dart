import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/widgets/back_arrow.dart';
import 'package:svg_flutter/svg.dart';

class AddTestToPatientScreen extends StatefulWidget {
  const AddTestToPatientScreen({super.key});

  @override
  State<AddTestToPatientScreen> createState() => _AddTestToPatientScreenState();
}

class _AddTestToPatientScreenState extends State<AddTestToPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  String nurseName = "";
  String testReading = "";
  DateTime testDate = DateTime.now();
  String selectedType = "";
  String selectedCategory = "";

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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CustomBackArrow(),
            const SizedBox(width: 15),
            Text(
              "Add New Test".toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: nurseName,
                onChanged: (value) {
                  setState(() => nurseName = value);
                },
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
                onTap: () {},
                child: TextFormField(
                  initialValue: nurseName,
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
                initialValue: testReading,
                onChanged: (value) {
                  setState(() => testReading = value);
                },
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
                onTap: () {
                  if (_formKey.currentState!.validate()) {}
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
