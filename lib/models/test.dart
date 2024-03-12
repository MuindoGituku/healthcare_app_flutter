class Test {
  String id;
  String patientID;
  String date;
  String nurseName;
  String type;
  String category;
  double readings;

  Test({
    required this.id,
    required this.patientID,
    required this.date,
    required this.nurseName,
    required this.type,
    required this.category,
    required this.readings,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['_id'] as String,
      patientID: json['patient_id'] as String,
      date: json['date'] as String,
      nurseName: json['nurse_name'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      readings: json['readings'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientID,
      'date': date,
      'nurse_name': nurseName,
      'type': type,
      'category': category,
      'readings': readings,
    };
  }
}
