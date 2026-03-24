import 'dart:io';
import 'package:alternative/features/home/domain/entities/profile_result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _vehicleModelController;
  late final TextEditingController _vehiclePlateController;
  late final TextEditingController _vehicleColorController;

  late final ProfileController _controller;
  ProfileResult? _profile;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _controller = sl<ProfileController>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehiclePlateController = TextEditingController();
    _vehicleColorController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_profile == null) {
      _profile = ModalRoute.of(context)!.settings.arguments as ProfileResult;

      final res = _profile;
      if (res is AdminProfile) {
        _nameController.text = res.admin.name;
        _emailController.text = res.admin.email;
        _phoneController.text = res.admin.phone ?? '';
      } else if (res is DriverProfile) {
        _nameController.text = res.driver.name;
        _emailController.text = res.driver.email;
        _phoneController.text = res.driver.phone;
        _vehicleModelController.text = res.driver.vehicleModel;
        _vehiclePlateController.text = res.driver.vehiclePlate;
        _vehicleColorController.text = res.driver.vehicleColor;
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _vehicleModelController.dispose();
    _vehiclePlateController.dispose();
    _vehicleColorController.dispose();
    super.dispose();
  }

  void _onSave() async {
    final res = _profile;
    Object? updatedEntity;

    if (res is AdminProfile) {
      updatedEntity = res.admin.copyWith(name: _nameController.text, phone: _phoneController.text);
    } else if (res is DriverProfile) {
      updatedEntity = res.driver.copyWith(
        name: _nameController.text,
        phone: _phoneController.text,
        vehicleModel: _vehicleModelController.text,
        vehiclePlate: _vehiclePlateController.text,
        vehicleColor: _vehicleColorController.text,
      );
    }

    if (updatedEntity != null) {
      await _controller.updateProfile(updatedEntity, imageFile: _imageFile);

      if (mounted && _controller.value is! ProfileErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) return const Scaffold();
    final isDriver = _profile is DriverProfile;
    final photoUrl = (_profile is DriverProfile)
        ? (_profile as DriverProfile).driver.photoUrl
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<ProfileState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          final isLoading = state is ProfileLoadingState;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDriver) ...[
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: AppColors.primary.withAlpha(50),
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : (photoUrl != null ? NetworkImage(photoUrl) : null)
                                          as ImageProvider?,
                                child: (_imageFile == null && photoUrl == null)
                                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Alterar foto do perfil',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Campos Comuns
                CustomTextField(
                  label: "Nome Completo",
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "E-mail",
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Telefone",
                  prefixIcon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),

                if (isDriver) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'DADOS DO VEÍCULO',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: "Modelo",
                    prefixIcon: Icons.directions_car_outlined,
                    controller: _vehicleModelController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(label: "Placa", controller: _vehiclePlateController),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(label: "Cor", controller: _vehicleColorController),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 40),
                PrimaryButton(
                  text: isLoading ? 'Salvando...' : 'Salvar Alterações',
                  icon: isLoading ? null : Icons.save_outlined,
                  onPressed: isLoading ? null : _onSave,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
