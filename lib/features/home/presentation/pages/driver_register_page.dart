import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
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

  // Controllers dos campos
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _baseCityController = TextEditingController();
  final _plateController = TextEditingController();
  final _capitalController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _controller = sl<DriverController>();
    _controller.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (_controller.value is DriverSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Motorista cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (_controller.value is DriverErrorState) {
      final state = _controller.value as DriverErrorState;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _plateController.dispose();
    _capitalController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    _controller.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      vehicleModel: _modelController.text,
      vehicleColor: _colorController.text,
      vehiclePlate: _plateController.text,
      baseCity: _baseCityController.text,
      assignedCapital: double.tryParse(_capitalController.text) ?? 0.0,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Cadastro de Motorista', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<DriverState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CustomTextField(
                  label: "Nome Completo",
                  controller: _nameController,
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Email",
                  controller: _emailController,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Telefone",
                  controller: _phoneController,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Veículo",
                        hintText: "Modelo",
                        controller: _modelController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(label: "Cor", controller: _colorController),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(label: "Placa", controller: _plateController),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: "Capital (R\$)",
                        controller: _capitalController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Senha",
                  controller: _passwordController,
                  prefixIcon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 24),

                CheckboxListTile(
                  title: const Text(
                    "Aceito os termos",
                    style: TextStyle(color: AppColors.slate400, fontSize: 12),
                  ),
                  value: _agreedToTerms,
                  onChanged: (val) => setState(() => _agreedToTerms = val!),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                PrimaryButton(
                  text: state is DriverLoadingState ? 'Processando...' : 'Cadastrar',
                  onPressed: (_agreedToTerms && state is! DriverLoadingState)
                      ? _handleRegister
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
