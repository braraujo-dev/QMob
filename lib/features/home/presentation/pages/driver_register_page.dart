import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/driver_register_controller.dart';
import '../controllers/driver_state.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  late final DriverTegisterController _controller;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _modelController = TextEditingController();
  final _colorController = TextEditingController();
  final _plateController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedBaseCity;
  final List<String> _capitals = [];
  final bool _isLoadingCapitals = true;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _controller = sl<DriverTegisterController>();
    _controller.addListener(_onStateChanged);
    _controller.fetchCapitals();
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
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_selectedBaseCity == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Por favor, selecione uma cidade base.")));
      return;
    }

    _controller.register(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      vehicleModel: _modelController.text,
      vehicleColor: _colorController.text,
      vehiclePlate: _plateController.text,
      baseCity: _selectedBaseCity!,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cadastro de Motorista', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<DriverState>(
        valueListenable: _controller,
        builder: (context, state, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                const Text("Cidade Base", style: TextStyle(color: AppColors.white, fontSize: 14)),
                const SizedBox(height: 8),
                _buildCitySpinner(),

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
                CustomTextField(
                  label: "Placa",
                  controller: _plateController,
                  prefixIcon: Icons.directions_car,
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
                  activeColor: AppColors.primary,
                ),

                const SizedBox(height: 16),
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

  Widget _buildCitySpinner() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, state, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBaseCity,
              items: _controller.capitals.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (val) => setState(() => _selectedBaseCity = val),
            ),
          ),
        );
      },
    );
  }
}
