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

  void _onFieldsChanged() {
    _controller.validateForm(_emailController.text, _passwordController.text);
  }

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
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      _controller.resetState();
    } else if (state is AuthSuccessState) {
      if (state.user.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/tracks.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.slate500.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: AppColors.slate400,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Bem-vindo',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate50,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Digite suas credencias para\nprosseguir',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),

                    CustomTextField(
                      label: 'Email',
                      hintText: 'Digite seu email',
                      prefixIcon: Icons.person_outline,
                      controller: _emailController,
                      errorText: _controller.emailError,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Senha',
                      hintText: 'Mínimo 8 caracteres',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      errorText: _controller.passwordError,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _controller.rememberMe,
                                onChanged: (value) => _controller.toggleRememberMe(value),
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _controller.toggleRememberMe(!_controller.rememberMe),
                              child: const Text(
                                'Lembrar-me',
                                style: TextStyle(color: AppColors.slate400),
                              ),
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
                    const SizedBox(height: 28),

                    ValueListenableBuilder<AuthState>(
                      valueListenable: _controller,
                      builder: (context, state, child) {
                        final isLoading = state is AuthLoadingState;

                        return PrimaryButton(
                          text: isLoading ? 'Entrando...' : 'Entrar',
                          icon: isLoading ? null : Icons.login,
                          // onPressed: (_controller.isFormValid && !isLoading)
                          //     ? () => _controller.signIn(
                          //           _emailController.text,
                          //           _passwordController.text,
                          //         )
                          //     : null,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.adminHome);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
