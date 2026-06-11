import 'package:alternative/routes/app_routes_manager.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/mask_formatters.dart';
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
      final user = state.user;

      if (user.mustChangePassword) {
        Navigator.pushReplacementNamed(context, AppRoutes.changePassword, arguments: true);
      } else {
        final nextRoute = user.role == 'admin' ? AppRoutes.adminHome : AppRoutes.driverHome;
        Navigator.pushReplacementNamed(context, nextRoute);
      }
    }
  }

  Future<void> _requestUnionAccess() async {
    final nomeSindicatoController = TextEditingController();
    final cnpjController = TextEditingController();
    final responsavelController = TextEditingController();
    final telefoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Solicitar Cadastro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Preencha os dados da sua entidade sindical.',
                      style: TextStyle(color: AppColors.slate400, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Nome do Sindicato',
                      hintText: 'Digite o nome',
                      prefixIcon: Icons.business_outlined,
                      controller: nomeSindicatoController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'CNPJ',
                      hintText: '00.000.000/0000-00',
                      prefixIcon: Icons.description_outlined,
                      controller: cnpjController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [CnpjInputFormatter()],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Nome do Responsável',
                      hintText: 'Nome do gestor',
                      prefixIcon: Icons.person_outline_rounded,
                      controller: responsavelController,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Telefone/WhatsApp',
                      hintText: '(00) 00000-0000',
                      prefixIcon: Icons.phone_android_rounded,
                      controller: telefoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [PhoneInputFormatter()],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'Enviar Solicitação',
                      onPressed: () async {
                        final nome = nomeSindicatoController.text;
                        final cnpj = cnpjController.text;
                        final resp = responsavelController.text;
                        final tel = telefoneController.text;

                        if (nome.isEmpty || cnpj.isEmpty || resp.isEmpty || tel.isEmpty) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(content: Text('Preencha todos os campos.')),
                          );
                          return;
                        }

                        final success = await _controller.sendSindicatoRequest(
                          nome: nome,
                          cnpj: cnpj,
                          responsavel: resp,
                          telefone: tel,
                        );

                        if (!dialogContext.mounted) return;

                        if (success) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Solicitação enviada com sucesso! Analisaremos os dados.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.slate400, size: 22),
                onPressed: () => Navigator.pop(dialogContext),
              ),
            ),
          ],
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
                    hintText: 'Digite a senha',
                    prefixIcon: Icons.lock_open_rounded,
                    isPassword: true,
                    controller: _passwordController,
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
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.forgotPassword);
                          },
                          child: const Text(
                            'Esqueci a Senha',
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
                        onPressed: _requestUnionAccess,
                        child: const Text(
                          'Solicite seu Cadastro Aqui',
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
