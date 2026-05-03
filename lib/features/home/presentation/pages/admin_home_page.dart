import 'package:alternative/core/di/injection_container.dart';
import 'package:alternative/features/historic/presentation/pages/historic_page.dart';
import 'package:alternative/features/home/domain/entities/driver_entity.dart';
import 'package:alternative/features/home/presentation/controllers/driver_register_controller.dart';
import 'package:alternative/features/home/presentation/controllers/driver_state.dart';
import 'package:alternative/features/profile/presentation/pages/profile_page.dart';
import 'package:alternative/features/queue/presentation/pages/queue_page.dart';
import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final controller = sl<DriverRegisterController>();
  int _currentIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [buildDriverListBody(), const QueuePage(), const HistoricPage(), const ProfilePage()];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDrivers();
    });

    controller.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (controller.value is DriverErrorState) {
      final state = controller.value as DriverErrorState;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color(0xFF0F172A);
    const Color accentBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: buildAppBar(bgDark, accentBlue),
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, AppRoutes.driverRegister);
                controller.fetchDrivers();
              },
              backgroundColor: accentBlue,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
      bottomNavigationBar: buildBottomNav(accentBlue),
    );
  }

  PreferredSizeWidget buildAppBar(Color bg, Color accent) {
    if (_isSearching && _currentIndex == 0) {
      return AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              controller.searchDrivers('');
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Buscar por nome ou placa...',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
          onChanged: (value) => controller.searchDrivers(value),
        ),
      );
    }

    String title;
    switch (_currentIndex) {
      case 0:
        title = 'Motoristas';
        break;
      case 1:
        title = 'Fila';
        break;
      case 2:
        title = 'Relatório';
        break;
      case 3:
        title = 'Ajustes';
        break;
      default:
        title = 'Alternative';
    }

    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (_currentIndex == 0)
          IconButton(
            onPressed: () => setState(() => _isSearching = true),
            icon: const Icon(Icons.search, color: Colors.white),
          ),
      ],
    );
  }

  Widget buildDriverListBody() {
    return ValueListenableBuilder<DriverState>(
      valueListenable: controller,
      builder: (context, state, child) {
        if (state is DriverLoadingState && controller.filteredDrivers.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF1D4ED8)));
        }

        final driverList = controller.filteredDrivers;
        if (driverList.isEmpty) {
          return _isSearching
              ? const Center(
                  child: Text(
                    "Nenhum motorista encontrado",
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : buildEmptyState(const Color(0xFF1D4ED8));
        }
        return buildListView(driverList);
      },
    );
  }

  Widget buildListView(List<DriverEntity> motoristas) {
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
              "Gestão de ${motoristas.length} condutores",
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: motoristas.length,
                itemBuilder: (context, index) => buildDriverCard(motoristas[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDriverDetails(DriverEntity m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildDetailRow(Icons.email_outlined, "E-mail", m.email),
              _buildDetailRow(Icons.phone_outlined, "Telefone", m.phone),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showDeleteConfirmation(m),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.redAccent, width: 1),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("EXCLUIR MOTORISTA", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(DriverEntity m) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Excluir Motorista", style: TextStyle(color: Colors.white)),
        content: Text("Tem certeza que deseja excluir o motorista ${m.name}? Esta ação não pode ser desfeita.", 
          style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha dialog
              Navigator.pop(context); // Fecha bottom sheet
              controller.deleteDriver(m.id);
            },
            child: const Text("EXCLUIR", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _phoneFormat(String value) {
    String numeros = value.replaceAll(RegExp(r'\D'), '');
    if (numeros.length == 11) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7)}';
    } else if (numeros.length == 10) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6)}';
    }
    return value;
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    final String displayValue = label == "Telefone" ? _phoneFormat(value) : value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              Text(
                displayValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDriverCard(DriverEntity m) {
    return InkWell(
      onTap: () => _showDriverDetails(m),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            buildAvatar(m.photoUrl, 'ativo'),
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
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  Widget buildAvatar(String? url, String? status) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white10,
          backgroundImage: (url != null && url.isNotEmpty) ? NetworkImage(url) : null,
          child: (url == null || url.isEmpty)
              ? const Icon(Icons.person, color: Colors.white24)
              : null,
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: status == 'ativo' ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1E293B), width: 2.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmptyState(Color accentBlue) {
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
              "Use o botão (+) para cadastrar seu primeiro motorista.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomNav(Color accentBlue) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F172A),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: accentBlue,
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _isSearching = false;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta), label: "Motoristas"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Fila"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Relatório"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        ],
      ),
    );
  }
}
