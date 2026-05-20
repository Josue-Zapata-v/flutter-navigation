class UserProfile {
  final String username;
  final String firstName;
  final String lastName;
  final String role;

  const UserProfile({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  String get fullName => '$firstName $lastName';
}