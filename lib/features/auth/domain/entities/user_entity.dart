class UserEntity {
  final String id;
  final String email;
  final String role;
  final String? baseCity;
  final bool mustChangePassword;

  UserEntity({
    required this.id,
    required this.email,
    required this.role,
    this.baseCity,
    this.mustChangePassword = false,
  });

  bool get isAdmin => role == 'admin';
}
