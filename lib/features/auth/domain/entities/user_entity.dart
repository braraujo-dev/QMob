class UserEntity {
  final String id;
  final String email;
  final bool isAdmin;
  final String? baseCity;

  UserEntity({
    required this.id, 
    required this.email,
    this.isAdmin = false,
    this.baseCity,
  });
}
