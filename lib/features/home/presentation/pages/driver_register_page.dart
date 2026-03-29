import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("A senha deve ter no mínimo 8 caracteres.")));
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
        title: const Text(
          'Novo Motorista',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
                  prefixIcon: Icons.person_outline,
                  hintText: "Ex: João Silva",
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Email de Acesso",
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "motorista@empresa.com",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Telefone / WhatsApp",
                  controller: _phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  hintText: "(00) 00000-0000",
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Cidade Base",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCitySelector(),
                const SizedBox(height: 24),
                const Text(
                  'DADOS DO VEÍCULO',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: "Modelo do Carro",
                  controller: _modelController,
                  prefixIcon: Icons.directions_car_outlined,
                  hintText: "Ex: Toyota Corolla",
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: "Placa",
                        controller: _plateController,
                        hintText: "BRA-2E19",
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [UpperCaseTextFormatter()],
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: "Cor",
                        controller: _colorController,
                        hintText: "Prata",
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: "Senha Inicial",
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  hintText: "Digite sua senha",
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) => setState(() => _agreedToTerms = val!),
                      activeColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    const Expanded(
                      child: Text(
                        "Confirmo que os dados acima estão corretos para o cadastro operacional.",
                        style: TextStyle(color: AppColors.slate400, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: state is DriverLoadingState ? 'Cadastrando...' : 'Cadastrar motorista',
                  onPressed: (_agreedToTerms && state is! DriverLoadingState)
                      ? _handleRegister
                      : null,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCitySelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.slate500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBaseCity,
          hint: const Text(
            "Selecione a capital",
            style: TextStyle(color: AppColors.slate400, fontSize: 14),
          ),
          dropdownColor: AppColors.inputBackground,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.slate400),
          isExpanded: true,
          style: const TextStyle(color: AppColors.white, fontSize: 15),
          items: _controller.capitals.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
          onChanged: (val) => setState(() => _selectedBaseCity = val),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
