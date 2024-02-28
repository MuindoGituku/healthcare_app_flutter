class Patient {
  String id;
  String firstName;
  String lastName;
  String address;
  String dateOfBirth;
  String department;
  String doctor;
  String status;

  Patient({
    this.id = "",
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.dateOfBirth,
    required this.department,
    required this.doctor,
    required this.status,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      address: json['address'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      department: json['department'] as String,
      doctor: json['doctor'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'date_of_birth': dateOfBirth,
      'department': department,
      'doctor': doctor,
      'status': status,
    };
  }
}
