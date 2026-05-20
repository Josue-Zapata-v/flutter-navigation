class Student {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  String get fullName => '$firstName $lastName';

  /// Edad calculada a partir de la fecha de nacimiento
  int get age {
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    return years;
  }
}