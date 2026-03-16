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
    const Color scaffoldBg = Color(0xFF0F172A);
    const Color accentBlue = Color(0xFF1D4ED8);
    const Color textColor = Colors.white70;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cadastro de Motorista',
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
              'Preencha os dados abaixo para registrar seu veículo e começar a operar.',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // --- CAMPOS DO FORMULÁRIO ---
            _buildLabel("Nome Completo"),
            _buildTextField(hint: "Seu nome completo", icon: Icons.person_outline),

            _buildLabel("Email"),
            _buildTextField(
              hint: "exemplo@email.com",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            _buildLabel("Telefone"),
            _buildTextField(
              hint: "(00) 00000-0000",
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white10, thickness: 1),
            ),

            const Text(
              "Informações do Veículo",
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),

            _buildLabel("Modelo do Veículo"),
            _buildTextField(hint: "Ex: Toyota Corolla", icon: Icons.directions_car_filled_outlined),

            _buildLabel("Cor do Veículo"),
            _buildTextField(hint: "Ex: Prata", icon: Icons.palette_outlined),

            _buildLabel("Placa"),
            _buildTextField(hint: "ABC-1234", icon: Icons.featured_play_list_outlined),

            _buildLabel("Capital Atribuída"),
            _buildTextField(
              hint: "Valor investido (R\$)",
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white10, thickness: 1),
            ),

            _buildLabel("Senha"),
            _buildTextField(
              hint: "Crie uma senha forte",
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: _obscureText,
              onSuffixTap: () => setState(() => _obscureText = !_obscureText),
            ),

            const SizedBox(height: 16),

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
                      text: 'Ao registrar-se, você aceita nossos ',
                      style: TextStyle(color: textColor, fontSize: 12),
                      children: [
                        TextSpan(
                          text: 'Termos de Uso',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        TextSpan(text: ' e '),
                        TextSpan(
                          text: 'Políticas de Privacidade',
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
                onPressed: _agreedToTerms
                    ? () {
                        // Lógica de cadastro aqui
                      }
                    : null, // Desabilitado se não aceitar termos
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Finalizar Cadastro',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle_outline, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onSuffixTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        keyboardType: keyboardType,
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
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        ),
      ),
    );
  }
}
