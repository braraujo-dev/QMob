import 'package:alternative/core/di/injection_container.dart';
import 'package:alternative/features/home/domain/entities/driver_entity.dart';
import 'package:alternative/features/home/presentation/controllers/driver_controller.dart';
import 'package:alternative/features/home/presentation/controllers/driver_state.dart';
import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key}); // Construtor limpo

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  // Buscamos a instância aqui
  final controller = sl<DriverController>();
  bool _temMotoristas = false;

  @override
  void initState() {
    super.initState();
    // Inicia a busca dos dados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDrivers();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color(0xFF0F172A);
    const Color accentBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: _buildAppBar(bgDark, accentBlue, _temMotoristas),
      body: ValueListenableBuilder<DriverState>(
        valueListenable: controller,
        builder: (context, state, child) {
          if (state is DriverLoadingState && controller.drivers.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: accentBlue));
          }

          if (state is DriverErrorState) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          final motoristas = controller.drivers;

          // Atualiza o estado da AppBar para mostrar/esconder o ícone de busca
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _temMotoristas != motoristas.isNotEmpty) {
              setState(() => _temMotoristas = motoristas.isNotEmpty);
            }
          });

          if (motoristas.isEmpty) {
            return _buildEmptyState(accentBlue);
          }

          return _buildListView(motoristas);
        },
      ),
      bottomNavigationBar: _buildBottomNav(accentBlue),
    );
  }

  PreferredSizeWidget _buildAppBar(Color bg, Color accent, bool mostrarBusca) {
    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      title: const Text(
        'Motoristas',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (mostrarBusca)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          icon: const Icon(Icons.settings, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildListView(List<DriverEntity> motoristas) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchDrivers(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "MOTORISTAS REGISTRADOS",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              "Gestão de ${motoristas.length} condutores ativos",
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: motoristas.length,
                itemBuilder: (context, index) {
                  return _buildDriverCard(motoristas[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(DriverEntity m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildAvatar(null, 'ativo'),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${m.vehicleModel} • ${m.vehiclePlate}",
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 14, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      m.phone,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? url, String? status) {
    Color statusColor = status == 'ativo' ? Colors.green : Colors.grey;

    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white10,
          backgroundImage: url != null ? NetworkImage(url) : null,
          child: url == null ? const Icon(Icons.person, color: Colors.white24) : null,
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E293B), width: 2.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Color accentBlue) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: const Color(0xFF1E293B),
                child: Icon(Icons.person_search_outlined, size: 70, color: accentBlue),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Ainda sem motoristas?",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Cadastre seu primeiro aqui para começar a gerenciar sua frota.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 15),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.driverRegister),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text("Cadastrar Motorista"),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color accentBlue) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F172A),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: accentBlue,
        unselectedItemColor: Colors.white38,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Início"),
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta), label: "Motoristas"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Relatórios"),
        ],
      ),
    );
  }
}
