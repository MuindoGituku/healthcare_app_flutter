import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_app_flutter/forms/update_test.dart';
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
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.category,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Nurse: ${test.nurseName}",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date: ${test.date}",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  test.readings.toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: isLatestTest
                      ? () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return UpdateTestScreen(test: test);
                          }));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    "Update Test",
                    style: TextStyle(),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: !isLatestTest
                      ? () async {
                          bool confirmDelete =
                              await _showDeleteConfirmationDialog(context);
                          if (confirmDelete) {
                            await PatientsDatabaseManager()
                                .deleteTest(test.patientID, test.id);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
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

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this test?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
