import 'package:flutter/material.dart';

class DriverRegisterPage extends StatefulWidget {
  const DriverRegisterPage({super.key});

  @override
  State<DriverRegisterPage> createState() => _DriverRegisterPageState();
}

class _DriverRegisterPageState extends State<DriverRegisterPage> {
  bool _obscureText = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    // Cores baseadas na imagem
    const Color scaffoldBg = Color(0xFF0F172A);
    const Color accentBlue = Color(0xFF1D4ED8);
    const Color textColor = Colors.white70;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.blueAccent),
        title: const Text(
          'Cadastro Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your details to manage the transport fleet and operations.',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Campos de Formulário
            _buildLabel("Nome Completo"),
            _buildTextField(hint: "Digite seu nome completo", icon: Icons.person_outline),

            _buildLabel("Email"),
            _buildTextField(hint: "admin@example.com", icon: Icons.email_outlined),

            _buildLabel("Cidade"),
            _buildTextField(
              hint: "Cidade",
              icon: Icons.location_on_outlined,
              suffixIcon: Icons.keyboard_arrow_down,
            ),

            _buildLabel("CPF"),
            _buildTextField(hint: "000.000.000-00", icon: Icons.badge_outlined),

            _buildLabel("Senha"),
            _buildTextField(
              hint: "........",
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: _obscureText,
              onSuffixTap: () => setState(() => _obscureText = !_obscureText),
            ),

            // Checkbox de Termos
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (val) => setState(() => _agreedToTerms = val!),
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'By registering, you agree to our ',
                      style: TextStyle(color: textColor, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Botão Criar Conta
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Admin Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Footer
            Center(
              child: Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: textColor),
                  children: [
                    TextSpan(
                      text: 'Back to Login',
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para Labels
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Widget auxiliar para Campos de Texto
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white38),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white38,
                  ),
                  onPressed: onSuffixTap,
                )
              : (suffixIcon != null ? Icon(suffixIcon, color: Colors.white38) : null),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
