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
    return GestureDetector(
      onTap: onTapPatientCard,
      child: Container(
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    department,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: iscritical ? Colors.redAccent : Colors.blueAccent,
                    ),
                  ),
                  Text(
                    doctorName,
                  ),
                ],
              ),
              GestureDetector(
                onTap: onTapPatientCard,
                child: Container(
                  decoration: BoxDecoration(
                    color: iscritical ? Colors.redAccent : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
