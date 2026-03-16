import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AuthController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<AuthController>();
    _controller.addListener(_onStateChanged);
    _emailController.addListener(_onFieldsChanged);
    _passwordController.addListener(_onFieldsChanged);
    _initAsync();
  }

  void _onFieldsChanged() =>
      _controller.validateForm(_emailController.text, _passwordController.text);

  Future<void> _initAsync() async {
    final savedEmail = await _controller.getSavedEmail();
    if (savedEmail != null) {
      _emailController.text = savedEmail;
      _controller.validateForm(_emailController.text, _passwordController.text);
    }
  }

  void _onStateChanged() {
    final state = _controller.value;
    if (state is AuthErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _controller.resetState();
    } else if (state is AuthSuccessState) {
      Navigator.pushReplacementNamed(
        context,
        state.user.isAdmin ? AppRoutes.adminHome : AppRoutes.main,
      );
    }
  }

  Future<void> _requestSindicatoAccess() async {
    final nomeSindicatoController = TextEditingController();
    final cnpjController = TextEditingController();
    final responsavelController = TextEditingController();
    final telefoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Solicitar Cadastro', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Preencha os dados da sua entidade sindical.',
                style: TextStyle(color: AppColors.slate400, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _buildDialogField('Nome do Sindicato', nomeSindicatoController),
              _buildDialogField('CNPJ', cnpjController, keyboardType: TextInputType.number),
              _buildDialogField('Nome do Responsável', responsavelController),
              _buildDialogField(
                'Telefone/WhatsApp',
                telefoneController,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              final success = await _controller.sendSindicatoRequest(
                nome: nomeSindicatoController.text,
                cnpj: cnpjController.text,
                responsavel: responsavelController.text,
                telefone: telefoneController.text,
              );

              if (!success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Não encontramos um app de e-mail configurado.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Enviar Solicitação'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.slate400),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.slate400),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/tracks.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Bem-vindo',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Digite suas credencias para prosseguir',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.slate400, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'E-mail',
                    hintText: 'exemplo@email.com',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    label: 'Senha',
                    hintText: 'Sua senha secreta',
                    prefixIcon: Icons.lock_open_rounded,
                    isPassword: true,
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _controller.isFormValid
                        ? _controller.signIn(_emailController.text, _passwordController.text)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _controller.rememberMe,
                              onChanged: (v) => _controller.toggleRememberMe(v),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            const Text(
                              'Lembrar-me',
                              style: TextStyle(color: AppColors.slate400, fontSize: 13),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Esqueci a senha',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder<AuthState>(
                    valueListenable: _controller,
                    builder: (context, state, child) {
                      final isLoading = state is AuthLoadingState;
                      return PrimaryButton(
                        text: isLoading ? 'Autenticando...' : 'Entrar',
                        onPressed: (_controller.isFormValid && !isLoading)
                            ? () => _controller.signIn(
                                _emailController.text,
                                _passwordController.text,
                              )
                            : null,
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'É um sindicato? ',
                        style: TextStyle(color: AppColors.slate400, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: _requestSindicatoAccess,
                        child: const Text(
                          'Solicite seu cadastro aqui',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
