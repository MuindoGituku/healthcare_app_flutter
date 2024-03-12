import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/patient.dart';

class PatientProfileCard extends StatelessWidget {
  const PatientProfileCard({super.key, required this.patient});

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: patient.status == "Normal"
            ? Colors.lightBlueAccent.withOpacity(0.3)
            : Colors.redAccent.withOpacity(0.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "DoB:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    patient.dateOfBirth,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Address:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    patient.address,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Doctor:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    patient.doctor,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Department:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    patient.department,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Status:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    patient.status,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
