import 'package:flutter/material.dart';

class CustomPatientCard extends StatelessWidget {
  const CustomPatientCard({
    super.key,
    required this.iscritical,
    required this.patientName,
    required this.doctorName,
    required this.department,
    required this.onTapPatientCard,
  });

  final bool iscritical;
  final String patientName;
  final String doctorName;
  final String department;
  final void Function() onTapPatientCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: iscritical ? Colors.redAccent : Colors.blueAccent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  department,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  doctorName,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: iscritical ? Colors.redAccent : Colors.blueAccent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "View Details",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
