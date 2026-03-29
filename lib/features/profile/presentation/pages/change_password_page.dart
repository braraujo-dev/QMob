import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../routes/app_routes_manager.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/domain/usecases/auth_usecase.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profile_state.dart';

class ChangePasswordPage extends StatefulWidget {
  final bool isFirstAccess;
  const ChangePasswordPage({super.key, this.isFirstAccess = false});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final ProfileController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = sl<ProfileController>();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChange() async {
    setState(() => _error = null);

    if (_newPasswordController.text.length < 8) {
      setState(() => _error = "A senha deve ter no mínimo 8 caracteres.");
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _error = "As senhas não coincidem.");
      return;
    }

    final success = await _controller.changePassword(_newPasswordController.text);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!'), backgroundColor: Colors.green),
      );

      if (widget.isFirstAccess) {
        final user = await sl<AuthUseCase>().getCurrentUser();
        
        if (mounted) {
          final targetRoute = user?.isAdmin == true ? AppRoutes.adminHome : AppRoutes.driverHome;
          debugPrint('Redirecionando para a rota: $targetRoute');
          
          Navigator.pushNamedAndRemoveUntil(
            context, 
            targetRoute, 
            (route) => false,
          );
        }
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Alterar Senha', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: widget.isFirstAccess ? null : const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isFirstAccess) ...[
              const Text(
                'Defina sua senha',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Por segurança, você precisa alterar a senha provisória definida pelo administrador.',
                style: TextStyle(color: AppColors.slate400, fontSize: 14),
              ),
              const SizedBox(height: 32),
            ],
            
            CustomTextField(
              label: "Nova Senha",
              hintText: "Mínimo 8 caracteres",
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: _newPasswordController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "Confirmar Nova Senha",
              hintText: "Repita a senha",
              prefixIcon: Icons.lock_reset,
              isPassword: true,
              controller: _confirmPasswordController,
            ),
            
            ValueListenableBuilder<ProfileState>(
              valueListenable: _controller,
              builder: (context, state, child) {
                String? errorMessage = _error;
                if (state is ProfileErrorState) errorMessage = state.message;

                return Column(
                  children: [
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ],
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: state is ProfileLoadingState ? 'Alterando...' : 'Salvar nova senha',
                      onPressed: state is ProfileLoadingState ? null : _handleChange,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
