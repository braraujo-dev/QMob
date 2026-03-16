import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nomeController = TextEditingController(text: "Ricardo Silva Santos");
  final _emailController = TextEditingController(text: "ricardo.silva@email.com");
  final _telefoneController = TextEditingController(text: "(11) 98765-4321");
  final _modeloController = TextEditingController(text: "Toyota Corolla");
  final _placaController = TextEditingController(text: "BRA-2E19");
  final _corController = TextEditingController(text: "Prata");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar com Badge de Câmera
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFFFD1BA),
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Alterar foto do perfil',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              label: 'Nome Completo',
              controller: _nomeController,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'E-mail',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              suffixIcon: Icons.lock_outline,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Telefone',
              controller: _telefoneController,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 35),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DADOS DO VEÍCULO',
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Modelo',
              controller: _modeloController,
              prefixIcon: Icons.directions_car_outlined,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(label: 'Placa', controller: _placaController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(label: 'Cor', controller: _corController),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Usei 'text' para seguir o padrão do seu PrimaryButton original
            PrimaryButton(
              text: 'Salvar Alterações',
              onPressed: () {
                // Lógica de salvar
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
