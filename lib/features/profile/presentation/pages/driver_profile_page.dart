// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
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
      backgroundColor: const Color(0xFF0F172A),
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, state, child) {
          if (state is ProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileSuccessState) {
            return _buildContent(state.profile);
          }
          return const Center(
            child: Text("Erro ao carregar", style: TextStyle(color: Colors.white)),
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
          CircleAvatar(
            radius: 60,
            backgroundImage: profile.photoUrl != null
                ? NetworkImage(profile.photoUrl!)
                : const AssetImage('assets/images/avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            profile.name ?? 'Motorista',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(profile.email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 32),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () async {
          await _controller.signOut();
          if (mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.auth, (route) => false);
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.1)),
        child: const Text("Encerrar Sessão", style: TextStyle(color: Colors.redAccent)),
      ),
    );
  }
}
