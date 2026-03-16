import 'package:alternative/features/settings/domain/entities/profile_entity.dart';
import 'package:alternative/features/settings/presentation/controllers/profile_state.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../routes/app_routes_manager.dart';
import '../controllers/profile_controller.dart';

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
    _controller.fetchProfile(); // Busca os dados do script que você inseriu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, state, child) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileSuccessState) {
            final profile = state.profile;
            return _buildContent(profile);
          }

          return const Center(
            child: Text("Erro ao carregar perfil", style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _buildContent(ProfileEntity profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Avatar dinâmico
          CircleAvatar(
            radius: 60,
            backgroundImage: profile.photoUrl != null
                ? NetworkImage(profile.photoUrl!)
                : const AssetImage('assets/images/avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(profile.email, style: const TextStyle(color: Colors.grey, fontSize: 14)),

          const SizedBox(height: 32),

          // Botão Logout usando o controller
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () async {
                await _controller.signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.1)),
              child: const Text("Encerrar Sessão", style: TextStyle(color: Colors.redAccent)),
            ),
          ),
        ],
      ),
    );
  }
}
