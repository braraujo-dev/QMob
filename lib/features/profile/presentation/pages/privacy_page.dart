import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Política de Privacidade",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivacySection(
              "1. Coleta de Dados",
              "Coletamos informações básicas como nome, e-mail e localização em tempo real para possibilitar a conexão entre motoristas e passageiros de forma eficiente.",
            ),

            _buildPrivacySection(
              "2. Uso da Localização",
              "Sua localização é utilizada apenas enquanto o aplicativo está em uso ou em segundo plano durante uma viagem ativa, garantindo a segurança de todos os envolvidos.",
            ),

            _buildPrivacySection(
              "3. Compartilhamento de Informações",
              "Não vendemos seus dados para terceiros. Suas informações são compartilhadas apenas com os usuários necessários para a conclusão do serviço solicitado.",
            ),

            _buildPrivacySection(
              "4. Seus Direitos",
              "Você pode solicitar a exclusão total da sua conta e de todos os dados associados a qualquer momento através da nossa central de suporte.",
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Dúvidas sobre como tratamos seus dados? Entre em contato com nosso DPO pelo e-mail suporte@alternative.com",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(color: AppColors.slate400, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}
