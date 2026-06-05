import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  late final AuthController _controller;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _controller = sl<AuthController>();
    _emailController.addListener(_validate);
  }

  void _validate() {
    final email = _emailController.text;
    final emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
    setState(() {
      _isFormValid = emailValid;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.lock_reset, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Esqueci minha Senha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Insira seu e-mail de usuário. Enviaremos um link com as instruções para recuperar sua conta e criar uma nova senha.',
                        style: TextStyle(color: AppColors.slate400, fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: 'E-mail',
                        hintText: 'seu@email.com',
                        prefixIcon: Icons.email_outlined,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 32),
                      ValueListenableBuilder<AuthState>(
                        valueListenable: _controller,
                        builder: (context, state, child) {
                          final isLoading = state is AuthLoadingState;
                          return PrimaryButton(
                            text: isLoading ? 'Enviando...' : 'Enviar Link de Recuperação',
                            icon: isLoading ? null : Icons.send,
                            onPressed: (_isFormValid && !isLoading)
                                ? () => _controller.sendPasswordResetEmail(_emailController.text)
                                : null,
                          );
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ainda está com problemas? ',
                              style: TextStyle(color: AppColors.slate500, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Contatar Suporte',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
