import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cadastro de Motorista',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insira os detalhes abaixo para gerenciar a frota de transporte e operações.',
              style: TextStyle(color: AppColors.slate400, fontSize: 16),
            ),
            const SizedBox(height: 32),

            CustomTextField(
              label: "Nome Completo",
              hintText: "Digite o nome completo",
              prefixIcon: Icons.person_outline,
              controller: _nameController,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: "Email",
              hintText: "motorista@exemplo.com",
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: "Cidade Base",
              hintText: "Ex: João Pessoa",
              prefixIcon: Icons.location_on_outlined,
              controller: _cityController,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: "CPF",
              hintText: "000.000.000-00",
              prefixIcon: Icons.badge_outlined,
              controller: _cpfController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: "Senha Inicial",
              hintText: "........",
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 24),

            // Checkbox de Termos
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (val) => setState(() => _agreedToTerms = val!),
                  activeColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Ao registrar, você concorda com nossos ',
                      style: TextStyle(color: AppColors.slate400, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Termos de Serviço',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Política de Privacidade',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Cadastrar Motorista',
              icon: Icons.arrow_forward,
              onPressed: _agreedToTerms ? () {} : null,
            ),

            const SizedBox(height: 24),

            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    text: 'Já tem uma conta? ',
                    style: TextStyle(color: AppColors.slate400),
                    children: [
                      TextSpan(
                        text: 'Voltar ao Login',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
