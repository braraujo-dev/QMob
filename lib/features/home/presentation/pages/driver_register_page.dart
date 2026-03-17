// lib/features/driver_register/presentation/pages/driver_register_page.dart
import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart'; // Ajuste conforme seu DI
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/driver_controller.dart';
import '../controllers/driver_state.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  late final DriverController _controller;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _controller = sl<DriverController>();

    // Escutar mudanças de estado para mostrar SnackBars ou navegar
    _controller.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    final state = _controller.value;
    if (state is DriverErrorState) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
    } else if (state is DriverSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Motorista cadastrado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    _controller.register(
      name: _nameController.text,
      email: _emailController.text,
      city: _cityController.text,
      cpf: _cpfController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(/* ... mesmo código anterior ... */),
      body: ValueListenableBuilder<DriverState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          final isLoading = state is DriverLoadingState;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // ... Seus CustomTextFields anteriores ...
                const SizedBox(height: 32),
                PrimaryButton(
                  text: isLoading ? 'Processando...' : 'Cadastrar Motorista',
                  icon: isLoading ? null : Icons.arrow_forward,
                  onPressed: (_agreedToTerms && !isLoading) ? _handleRegister : null,
                ),
                // ... Resto da UI ...
              ],
            ),
          );
        },
      ),
    );
  }
}
