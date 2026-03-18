import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.email,
    super.name,
    super.photoUrl,
    super.phone,
    super.vehicleModel,
    super.vehiclePlate,
    super.vehicleColor,
    super.nomeSindicato,
    super.cnpj,
    super.responsavel,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json, String email) {
    return ProfileModel(
      id: json['id'],
      email: email,
      name: json['full_name'],
      photoUrl: json['photo_url'],
      phone: json['phone'],
      vehicleModel: json['vehicle_model'],
      vehiclePlate: json['vehicle_plate'],
      vehicleColor: json['vehicle_color'],
      nomeSindicato: json['nome_sindicato'],
      cnpj: json['cnpj'],
      responsavel: json['responsavel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'photo_url': photoUrl,
      'phone': phone,
      'vehicle_model': vehicleModel,
      'vehicle_plate': vehiclePlate,
      'vehicle_color': vehicleColor,
    };
  }
}
