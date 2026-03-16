// lib/features/profile/presentation/pages/admin_profile_page.dart
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/profile_entity.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profile_state.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<ProfileController>();
    _controller.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color(0xFF0F172A);
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(title: const Text("Dados do Sindicato"), backgroundColor: bgDark),
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, state, child) {
          if (state is ProfileLoadingState) return const Center(child: CircularProgressIndicator());
          if (state is ProfileSuccessState) return _buildBody(state.profile);
          return const Center(child: Text("Erro ao carregar"));
        },
      ),
    );
  }

  Widget _buildBody(ProfileEntity dados) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoCard("DADOS DA INSTITUIÇÃO", [
            _buildTile(Icons.business, "Sindicato", dados.nomeSindicato ?? 'N/A'),
            _buildTile(Icons.description, "CNPJ", dados.cnpj ?? 'N/A'),
          ]),
          const SizedBox(height: 20),
          _buildInfoCard("CONTATO", [
            _buildTile(Icons.person, "Responsável", dados.responsavel ?? 'N/A'),
            _buildTile(Icons.phone, "Telefone", dados.telefone ?? 'N/A'),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white54),
      title: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
