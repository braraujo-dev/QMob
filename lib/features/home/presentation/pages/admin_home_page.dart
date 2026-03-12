import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _motoristasStream;

  @override
  void initState() {
    super.initState();
    _motoristasStream = supabase.from('motoristas').stream(primaryKey: ['id']).order('nome');
  }

  @override
  Widget build(BuildContext context) {
    const Color bgDark = Color(0xFF0F172A);
    const Color accentBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: _buildAppBar(bgDark, accentBlue),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _motoristasStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentBlue));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(accentBlue);
          }

          final motoristas = snapshot.data!;
          return _buildListView(motoristas);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cadastro'),
        backgroundColor: accentBlue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: _buildBottomNav(accentBlue),
    );
  }

  PreferredSizeWidget _buildAppBar(Color bg, Color accent) {
    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      leading: const Icon(Icons.menu, color: Colors.white),
      title: const Text(
        'Motoristas',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> motoristas) {
    return Padding(
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
                final m = motoristas[index];
                return _buildDriverCard(m);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .1)),
      ),
      child: Row(
        children: [
          _buildAvatar(m['foto_url'], m['status']),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['nome'] ?? 'Sem nome',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${m['idade'] ?? '--'} anos • ${m['modelo_veiculo'] ?? 'N/A'}",
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      "${m['km_rodados'] ?? '0'} KM rodados",
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
    Color statusColor = status == 'ativo'
        ? Colors.green
        : (status == 'ocupado' ? Colors.orange : Colors.grey);

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
              "Cadastre seu primeiro aqui para começar a gerenciar sua frota e rotas de forma eficiente.",
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "INÍCIO"),
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta), label: "MOTORISTAS"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "RELATÓRIOS"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "AJUSTES"),
        ],
      ),
    );
  }
}
