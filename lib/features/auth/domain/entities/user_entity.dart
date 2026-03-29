class UserEntity {
  final String id;
  final String email;
  final String role;
  final String? baseCity;

  UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.baseCity,
  });

  bool get isAdmin => role == 'admin';
}
