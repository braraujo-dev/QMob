import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                'assets/images/tracks.svg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 32),
              const CustomTextField(
                label: 'Email',
                hintText: 'Digite seu email',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                label: 'Senha',
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
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
                          value: false,
                          onChanged: (value) {},
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Lembrar-me',
                        style: TextStyle(color: AppColors.slate400),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueci a senha',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Entrar',
                icon: Icons.login,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'Admin Access',
                icon: Icons.admin_panel_settings_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Precisa de ajuda? ',
                    style: TextStyle(color: AppColors.slate500),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Contato',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.security, size: 16, color: AppColors.slate400),
                  SizedBox(width: 8),
                  Text(
                    'SECURE CONNECTION',
                    style: TextStyle(
                      color: AppColors.slate400,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
