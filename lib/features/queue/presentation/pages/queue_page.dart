import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/queue_controller.dart';
import '../controllers/queue_state.dart';
import '../../domain/entities/driver_queue_entity.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  late final QueueController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<QueueController>();
    _controller.fetchQueue();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fila de Espera', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'AO VIVO',
                  style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<QueueState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          if (state is QueueLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QueueEmptyState) {
            return _buildEmptyState();
          }

          if (state is QueueLoadedState) {
            return _buildBody(state);
          }

          if (state is QueueErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Erro ao carregar fila', style: TextStyle(color: Colors.white)),
                  TextButton(onPressed: () => _controller.fetchQueue(), child: const Text('Tentar novamente')),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.group_off_outlined, size: 80, color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          const Text(
            'Nenhum motorista na fila no momento',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Seja o primeiro a fazer check-in e iniciar a fila de volta para sua cidade.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.slate400, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(QueueLoadedState state) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _controller.fetchQueue(),
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                if (state.currentUser != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFF0A3EB3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Sua posição atual', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text('${state.currentUser!.position}º Lugar', 
                                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person_pin_outlined, size: 32, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Progresso na fila', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('${state.currentUser!.position - 1} motoristas à frente', 
                              style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: state.queue.isEmpty ? 0 : (1 - (state.currentUser!.position / state.queue.length)), 
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Próximos da Vez', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Total: ${state.queue.length} motoristas', style: const TextStyle(color: AppColors.slate500, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.queue.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final driver = state.queue[index];
                    return _buildDriverCard(driver);
                  },
                ),
              ],
            ),
          ),
        ),
        if (state.currentUser != null)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: () => _showCheckoutDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 4,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout, size: 24),
              label: const Text('Sair da fila (Checkout)', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ),
          ),
      ],
    );
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.inputBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sair da Fila?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Você perderá sua posição atual e precisará fazer um novo check-in quando retornar.', style: TextStyle(color: AppColors.slate400)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: AppColors.slate400)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.checkout();
            },
            child: const Text('SAIR AGORA', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(DriverQueueEntity driver) {
    final bool isMe = driver.isCurrentUser;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe ? AppColors.primary : AppColors.border,
          width: isMe ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isMe ? AppColors.primary : AppColors.slate500.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('${driver.position}', 
              style: TextStyle(color: isMe ? Colors.white : AppColors.slate400, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(driver.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                        child: const Text('VOCÊ', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                Text('${driver.vehicle} • ${driver.color}', style: const TextStyle(color: AppColors.slate500, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Chegada', style: TextStyle(color: AppColors.slate500, fontSize: 10)),
              Text(driver.arrivalTime, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
