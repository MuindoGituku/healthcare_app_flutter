import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/patient.dart';
import 'package:svg_flutter/svg.dart';

class UpdatePatientProfileScreen extends StatefulWidget {
  const UpdatePatientProfileScreen({super.key, required this.patient});

  final Patient patient;

  @override
  State<UpdatePatientProfileScreen> createState() =>
      _UpdatePatientProfileScreenState();
}

class _UpdatePatientProfileScreenState
    extends State<UpdatePatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String firstName = "";
  String lastName = "";
  String homeAddress = "";
  DateTime dateOfBirth = DateTime.now();
  String selectedDoctor = "";
  String selectedDepartment = "";

  List<String> doctorOptions = [
    'Megan Garner',
    'Luke White',
    'George Smith',
    'Melinda Binder',
    'Waldo Cross',
    'Lawrence Shortle',
    'Laura Castro',
  ];
  List<String> departmentOptions = [
    'Emergency',
    'Cardiology',
    'Psychiatry',
    'Hematology',
    'Neurology',
    'Oncology',
    'Orthopedics',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Update Patient Details".toUpperCase(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                      initialValue: firstName,
                      onChanged: (value) {
                        setState(() => firstName = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your first name!!";
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "First Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                      initialValue: lastName,
                      onChanged: (value) {
                        setState(() => lastName = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your last name!!";
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: homeAddress,
                onChanged: (value) {
                  setState(() => homeAddress = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your home address!!";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 12,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Home Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {},
                child: TextFormField(
                  initialValue: homeAddress,
                  enabled: false,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
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
                items: doctorOptions,
                selectedItem: selectedDoctor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select the attending doctor!!";
                  }
                  return null;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Attending Doctor",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              DropdownSearch(
                items: departmentOptions,
                selectedItem: selectedDepartment,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Select the receiving department!!";
                  }
                  return null;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Receiving Department",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
                          "Update Patient Details",
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
