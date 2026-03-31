import 'package:alternative/core/utils/enum_class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/historic_entity.dart';
import '../controllers/historic_controller.dart';
import '../controllers/historic_state.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({super.key});

  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  late final HistoricController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<HistoricController>();
    _controller.fetchHistoric();
  }

  String _getPeriodLabel(HistoricFilter filter) {
    switch (filter) {
      case HistoricFilter.week:
        return 'Últimos 7 dias';
      case HistoricFilter.older:
        return 'Mais de 30 dias';
      case HistoricFilter.month:
        return 'Este Mês';
      case HistoricFilter.custom:
        return 'Personalizado';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.inputBackground,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _controller.setFilter(HistoricFilter.custom, date: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meu Histórico', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
      ),
      body: ValueListenableBuilder<HistoricState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          if (state is HistoricLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoricSuccessState) {
            return _buildBody(state);
          }
          return const Center(child: Text('Erro ao carregar histórico'));
        },
      ),
    );
  }

  Widget _buildBody(HistoricSuccessState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getPeriodLabel(_controller.selectedFilter).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.slate500,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.historic.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(child: _buildTimeRangeSpinner()),
              const SizedBox(width: 12),
              _buildFilterButton(
                icon: Icons.calendar_month_outlined,
                isSelected: _controller.selectedFilter == HistoricFilter.custom,
                onTap: _selectDate,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'VIAGENS RECENTES',
            style: TextStyle(color: AppColors.slate500, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: state.historic.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma viagem encontrada.',
                    style: TextStyle(color: AppColors.slate400),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: state.historic.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _buildHistoricCard(state.historic[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSpinner() {
    final bool isTimeFilter = _controller.selectedFilter != HistoricFilter.custom;

    return PopupMenuButton<HistoricFilter>(
      offset: const Offset(0, 45),
      color: AppColors.inputBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (filter) => _controller.setFilter(filter),
      itemBuilder: (context) => [
        _buildPopupItem('Últimos 7 dias', HistoricFilter.week),
        _buildPopupItem('Este Mês', HistoricFilter.month),
        _buildPopupItem('Mais de 30 dias', HistoricFilter.older),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isTimeFilter ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isTimeFilter ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isTimeFilter ? _getPeriodLabel(_controller.selectedFilter) : 'Selecionar Período',
              style: TextStyle(
                color: isTimeFilter ? Colors.white : AppColors.slate400,
                fontWeight: isTimeFilter ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isTimeFilter ? Colors.white : AppColors.slate400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<HistoricFilter> _buildPopupItem(String text, HistoricFilter value) {
    return PopupMenuItem(
      value: value,
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : AppColors.slate400, size: 20),
      ),
    );
  }

  Widget _buildHistoricCard(HistoricEntity item) {
    final bool isEntry = item.status.toLowerCase() == 'chegada';
    final Color statusColor = isEntry ? Colors.green : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(isEntry ? Icons.login : Icons.logout, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '${item.origin} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '→ ',
                        style: TextStyle(color: statusColor),
                      ),
                      TextSpan(text: item.destination),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM, HH:mm', 'pt_BR').format(item.date),
                  style: const TextStyle(color: AppColors.slate500, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.status.toUpperCase(),
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
