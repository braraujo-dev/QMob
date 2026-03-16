import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/checkin_controller.dart';
import '../controllers/checkin_state.dart';
import '../../domain/entities/capital_entity.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  late final CheckinController _controller;

  @override
  void initState() {
    super.initState();

    final destination = CapitalEntity(
      cityName: 'Limoeiro do Norte',
      coords: const LatLng(-5.141232776415835, -38.09332926435016),
      radius: 7000,
    );

    _controller = sl<CheckinController>(param1: destination);
    _controller.startTracking();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CheckinState>(
      valueListenable: _controller,
      builder: (context, state, child) {
        final destination = state.destination;
        final distanceToGeofence = state.distanceToCenter - destination.radius;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(target: destination.coords, zoom: 11),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        circles: {
                          Circle(
                            circleId: const CircleId('geofence'),
                            center: destination.coords,
                            radius: destination.radius,
                            fillColor: AppColors.primary.withValues(alpha: 0.15),
                            strokeColor: AppColors.primary.withValues(alpha: 0.4),
                            strokeWidth: 1,
                          ),
                        },
                        markers: {
                          Marker(markerId: const MarkerId('dest'), position: destination.coords),
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination.cityName,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow('Status Atual', state.status),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Distância',
                            state.isInsideGeofence
                                ? '0 metros'
                                : (state.distanceToCenter >= 1000
                                      ? '${(state.distanceToCenter / 1000).toStringAsFixed(1)} km'
                                      : '${state.distanceToCenter.toInt()} metros'),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Previsão de Chegada', state.arrivalTime),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    PrimaryButton(
                      text: state.isAlreadyInQueue
                          ? 'Você já está na fila'
                          : (state.isLoading ? 'Enviando...' : 'Realizar Check-in'),
                      icon: state.isAlreadyInQueue ? Icons.check_circle : Icons.location_on,
                      onPressed:
                          (state.isInsideGeofence && !state.isAlreadyInQueue && !state.isLoading)
                          ? () => _controller.performCheckin()
                          : null,
                    ),
                    const SizedBox(height: 8),

                    if (!state.isInsideGeofence &&
                        !state.isAlreadyInQueue &&
                        distanceToGeofence < 1000)
                      Text(
                        'Aproxime-se mais ${distanceToGeofence.toInt()} metros para habilitar o check-in.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.slate400, fontSize: 12),
                      ),
                    if (state.isInsideGeofence && !state.isAlreadyInQueue)
                      const Text(
                        'Você já chegou ao destino! Faça seu check-in.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (state.isAlreadyInQueue)
                      const Text(
                        'Check-in realizado. Acompanhe sua posição na aba Fila.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.slate400, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
