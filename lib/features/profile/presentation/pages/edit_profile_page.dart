import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/profile_entity.dart';
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
  ProfileEntity? _profile;
  File? _imageFile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_profile == null) {
      _profile = ModalRoute.of(context)!.settings.arguments as ProfileEntity;
      _nameController = TextEditingController(text: _profile!.name);
      _emailController = TextEditingController(text: _profile!.email);
      _phoneController = TextEditingController(text: _profile!.phone);
      _vehicleModelController = TextEditingController(text: _profile!.vehicleModel);
      _vehiclePlateController = TextEditingController(text: _profile!.vehiclePlate);
      _vehicleColorController = TextEditingController(text: _profile!.vehicleColor);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = sl<ProfileController>();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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

  @override
  Widget build(BuildContext context) {
    if (_profile == null) return const Scaffold();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                              backgroundImage: _imageFile != null 
                                  ? FileImage(_imageFile!) 
                                  : (_profile!.photoUrl != null ? NetworkImage(_profile!.photoUrl!) : null) as ImageProvider?,
                              child: (_imageFile == null && _profile!.photoUrl == null) 
                                  ? const Icon(Icons.person, size: 60, color: AppColors.slate400) 
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Alterar foto do perfil', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  label: "Nome Completo",
                  hintText: "Seu nome",
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "E-mail",
                  hintText: "seu@email.com",
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Telefone",
                  hintText: "(00) 00000-0000",
                  prefixIcon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 32),
                const Text('DADOS DO VEÍCULO', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                const SizedBox(height: 20),

                CustomTextField(
                  label: "Modelo",
                  hintText: "Ex: Toyota Corolla",
                  prefixIcon: Icons.directions_car_outlined,
                  controller: _vehicleModelController,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Placa",
                        hintText: "BRA-2E19",
                        controller: _vehiclePlateController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: "Cor",
                        hintText: "Prata",
                        controller: _vehicleColorController,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                PrimaryButton(
                  text: isLoading ? 'Salvando...' : 'Salvar Alterações',
                  icon: isLoading ? null : Icons.save_outlined,
                  onPressed: isLoading ? null : () async {
                    final updatedProfile = ProfileEntity(
                      id: _profile!.id,
                      email: _profile!.email,
                      name: _nameController.text,
                      phone: _phoneController.text,
                      vehicleModel: _vehicleModelController.text,
                      vehiclePlate: _vehiclePlateController.text,
                      vehicleColor: _vehicleColorController.text,
                      photoUrl: _profile!.photoUrl,
                      nomeSindicato: _profile!.nomeSindicato,
                    );
                    
                    await _controller.updateProfile(updatedProfile, imageFile: _imageFile);
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    }
                  },
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
