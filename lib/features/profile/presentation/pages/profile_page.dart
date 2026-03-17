import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_routes_manager.dart';
import '../../domain/entities/profile_entity.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<ProfileController>();
    _controller.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<ProfileState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileSuccessState) {
            return _buildContent(state.profile);
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Erro ao carregar ajustes", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 16),
                TextButton(onPressed: () => _controller.fetchProfile(), child: const Text("Tentar novamente")),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ProfileEntity profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header Perfil - SEM O ÍCONE DE CÂMERA
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.border,
              backgroundImage: profile.photoUrl != null
                  ? NetworkImage(profile.photoUrl!)
                  : null,
              child: profile.photoUrl == null
                  ? const Icon(Icons.person, size: 50, color: AppColors.slate400)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name ?? 'Usuário',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            profile.email,
            style: const TextStyle(color: AppColors.slate400, fontSize: 14),
          ),
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile, arguments: profile),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Editar perfil', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          
          const SizedBox(height: 32),
          
          _buildSectionTitle('SEGURANÇA'),
          _buildOptionTile(Icons.lock_outline, 'Alterar senha'),
          _buildOptionTile(Icons.fingerprint, 'Autenticação biométrica'),
          
          const SizedBox(height: 24),
          _buildSectionTitle('AJUDA E SUPORTE'),
          _buildOptionTile(Icons.help_outline, 'Dúvidas'),
          _buildOptionTile(Icons.headset_mic_outlined, 'Suporte'),
          _buildOptionTile(Icons.description_outlined, 'Termos de Privacidade'),
          
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: () async {
              await _controller.signOut();
              if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.auth);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              foregroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Encerrar sessão', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          
          const SizedBox(height: 16),
          const Text(
            'Versão 1.0.0 (Build 1)',
            style: TextStyle(color: AppColors.slate500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: const TextStyle(color: AppColors.slate400, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.inputBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.slate500),
        onTap: () {},
      ),
    );
  }
}
