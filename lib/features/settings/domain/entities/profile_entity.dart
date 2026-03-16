class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isAdmin;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.isAdmin,
  });
}
