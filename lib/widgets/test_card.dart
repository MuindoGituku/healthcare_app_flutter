import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/models/test.dart';
import 'package:healthcare_app_flutter/services/database_manager.dart';
import 'package:svg_flutter/svg.dart';

class SingleTestCard extends StatelessWidget {
  const SingleTestCard(
      {super.key, required this.test, required this.isLatestTest});

  final Test test;
  final bool isLatestTest;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.category,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Nurse: ${test.nurseName}",
                      style: const TextStyle(),
                    ),
                    Text(
                      "Date: ${test.date}",
                      style: const TextStyle(),
                    ),
                  ],
                ),
                Text(
                  test.readings.toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isLatestTest)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to update test screen
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      icon: SvgPicture.asset(
                        "assets/images/edit_note.svg",
                        width: 20,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Update Test",
                        style: TextStyle(),
                      ),
                    ),
                  ),
                if (!isLatestTest)
                  ElevatedButton.icon(
                    onPressed: () async {
                      await PatientsDatabaseManager()
                          .deleteTest(test.patientID, test.id);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: SvgPicture.asset(
                      "assets/images/scan_delete.svg",
                      width: 20,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Delete Test",
                      style: TextStyle(),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
