import 'package:flutter/material.dart';

class HistoricPage extends StatelessWidget {
  const HistoricPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResumoMesCard(quantidadeViagens: 45),
          const SizedBox(height: 25),
          // Substitua sua Row por isso:
          // Substitua sua Row por isso:
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Habilita o scroll lateral
            child: Row(
              children: [
                FilterButton(text: 'Este Mês', icon: Icons.keyboard_arrow_down, isSelected: true),
                const SizedBox(width: 10),
                FilterButton(
                  text: 'Últimos 7 dias',
                  icon: Icons.keyboard_arrow_down,
                  isSelected: false,
                ),
                const SizedBox(width: 10),
                FilterButton(
                  text: 'Personalizado',
                  icon: Icons.keyboard_arrow_down,
                  isSelected: false,
                  isCut: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          Text(
            'VIAGENS RECENTES',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          const TripCard(
            origem: 'São Paulo',
            destino: 'Campinas',
            data: '12 Out',
            hora: '14:30',
            status: TripStatus.concluida,
          ),
          const TripCard(
            origem: 'São Paulo',
            destino: 'Santos',
            data: '11 Out',
            hora: '09:15',
            status: TripStatus.concluida,
          ),
          const TripCard(
            origem: 'Barueri',
            destino: 'Jundiaí',
            data: '10 Out',
            hora: '18:45',
            status: TripStatus.cancelada,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ResumoMesCard extends StatelessWidget {
  final int quantidadeViagens;

  const ResumoMesCard({super.key, required this.quantidadeViagens});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('VIAGENS NO MÊS', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Text('$quantidadeViagens', style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final bool isCut;

  const FilterButton({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    this.isCut = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1E51D3) : const Color(0xFF1E2432),
        borderRadius: isCut
            ? const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
            : BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white.withOpacity(isSelected ? 1.0 : 0.8), fontSize: 15),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

enum TripStatus { concluida, cancelada }

class TripCard extends StatelessWidget {
  final String origem;
  final String destino;
  final String data;
  final String hora;
  final TripStatus status;

  const TripCard({
    super.key,
    required this.origem,
    required this.destino,
    required this.data,
    required this.hora,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF262C3A),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.directions_car_filled_outlined,
              color: Color(0xFF3469E2),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: origem),
                      const TextSpan(
                        text: ' ➔ ',
                        style: TextStyle(color: Color(0xFF3469E2)),
                      ),
                      TextSpan(text: destino),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text('$data, $hora', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _buildStatusTag(status),
        ],
      ),
    );
  }

  Widget _buildStatusTag(TripStatus status) {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case TripStatus.concluida:
        text = 'CONCLUÍDA';
        bgColor = const Color(0xFF13362A);
        textColor = const Color(0xFF2DC489);
        break;
      case TripStatus.cancelada:
        text = 'CANCELADA';
        bgColor = const Color(0xFF3A2D1F);
        textColor = const Color(0xFFD49C4A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
