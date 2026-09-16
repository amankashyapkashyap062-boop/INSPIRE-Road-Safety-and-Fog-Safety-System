class UserProfile {
  final String fullName;
  final String mobileNumber;
  final String age;
  final String state;
  final String district;
  final String guardianName;
  final String guardianMobile;
  final String emergencyContact;
  final String bloodGroup;
  final String allergy;
  final String medicalInformation;

  const UserProfile({
    required this.fullName,
    required this.mobileNumber,
    required this.age,
    required this.state,
    required this.district,
    required this.guardianName,
    required this.guardianMobile,
    this.emergencyContact = '',
    this.bloodGroup = '',
    this.allergy = '',
    this.medicalInformation = '',
  });
}
