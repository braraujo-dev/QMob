<p align="center">
  <img src="assets/images/app_banner.png" alt="QMob Logo" width="400">
</p>

![Flutter](https://img.shields.io/badge/Flutter-3.22.0-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.4.0-blue?logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-2.0-green?logo=supabase)

---

## 📃 Descrição

O **QMob** é um aplicativo Flutter desenvolvido em Dart para gestão de filas de motoristas, focado em sindicatos e administradores de transporte. A aplicação permite que motoristas realizem check-in em uma região geográfica (geofencing), entrem em uma fila virtual e acompanhem sua posição em tempo real. Administradores podem gerenciar motoristas, visualizar a fila e acessar histórico de viagens.

---

## 🗂️ Arquitetura e Estrutura do Projeto

O projeto segue os princípios da **Clean Architecture**, separando o código em três camadas principais:
- **Data**: Implementações de repositórios, fontes de dados remotas (Supabase) e modelos.
- **Domain**: Entidades, casos de uso e interfaces de repositórios.
- **Presentation**: Interfaces de usuário (Flutter widgets) e controladores (ValueNotifier) que gerenciam estados e interagem com os casos de uso.

A injeção de dependências é feita com **GetIt**, e o estado da UI é gerenciado com **ValueNotifier** e listeners, garantindo reatividade simples e eficiente.

---

## 💻 Tecnologias Utilizadas

- **Dart 3.4+**: Linguagem principal.
- **Flutter 3.22+**: Framework UI multiplataforma.
- **Supabase**: Backend como serviço (autenticação, banco de dados relacional, storage, realtime).
- **Geolocator + Geocoding**: Captura de localização e geocodificação reversa.
- **Google Maps Flutter**: Exibição de mapas e geofence.
- **GetIt**: Injeção de dependências.
- **Dartz**: Programação funcional (Either para tratamento de erros).
- **SharedPreferences**: Persistência local (lembrar e-mail, biometria).
- **Local Auth**: Autenticação biométrica.
- **URL Launcher**: Envio de e-mails via aplicativo externo.
- **Image Picker**: Seleção de fotos para perfil.
- **Intl**: Formatação de datas e números.
- **Flutter Dotenv**: Gerenciamento de variáveis de ambiente.

---

## 🛎️ Funcionalidades

### Autenticação
- Login com e-mail e senha.
- Recuperação de senha por e-mail (reset via Supabase).
- Salvar credenciais ("Lembrar-me").
- Autenticação biométrica (impressão digital/face).
- Cadastro de novos sindicatos via envio de e-mail com dados.

### Gerenciamento de Motoristas (Admin)
- Listagem de motoristas registrados (nome, veículo, placa).
- Cadastro de motoristas (criação automática de usuário no Supabase).
- Exclusão de motoristas (remove da fila, histórico e drivers).
- Busca por nome ou placa.

### Check-in e Geofence
- Definição de cidade base (capital) para cada motorista.
- Cálculo de distância até o centro da cidade.
- Verificação de geofencing (dentro do raio + nome da cidade).
- Status: *Aguardando*, *Em Rota*, *No Local*.
- Previsão de chegada (ETA).
- Realização de check-in apenas quando dentro da área permitida.

### Fila Virtual (Realtime)
- Motoristas entram na fila ao fazer check-in.
- Posição atual em tempo real, ordenada por horário de chegada.
- Atualização automática via stream do Supabase.
- Check-out voluntário (sair da fila).
- Administradores visualizam toda a fila; motoristas veem sua posição e os demais.

### Histórico de Viagens
- Registro automático de chegadas (check-in) e saídas (check-out).
- Filtros: últimos 7 dias, este mês, mais de 30 dias, data personalizada.
- Exibição de lista com origem, destino, data/hora e status.

### Perfil do Usuário
- Visualização e edição de dados pessoais (nome, telefone, foto).
- Motoristas podem alterar dados do veículo.
- Alteração de senha (com validação).
- Ativação/desativação da biometria.
- Termos de privacidade e suporte (envio de e-mail).

### Interface e Experiência
- Tema escuro consistente (cores primárias azul, fundo escuro).
- BottomNavigationBar para navegação principal.
- Feedback visual com SnackBars, AlertDialogs e indicadores de loading.
- Máscaras de entrada (CNPJ, telefone, placa em maiúsculas).

---

## 🧪 Fluxos do aplicativo

### Administrador

1. Login com credenciais de admin.
2. Cadastra novos motoristas (cria usuário no Auth e registra na tabela drivers).
3. Visualiza lista de motoristas, busca e exclui.
4. Acompanha a fila em tempo real (atualização automática).
5. Visualiza histórico de todas as viagens dos motoristas.

### Motorista

1. Login com e-mail e senha fornecidos pelo admin.
2. Se for primeiro acesso, altera a senha.
3. Na tela principal, visualiza o mapa com o geofence da sua cidade base.
4. Ao entrar na área permitida, o botão "Realizar Check-in" é ativado.
5. Ao clicar, entra na fila e é redirecionado para a fila (ou permanece na tela).
6. Na fila, visualiza sua posição e o horário previsto de chegada (calculado dinamicamente).
7. Quando desejar, pode sair da fila (check-out), registrando o fim da viagem no histórico.

## ▶️ Como Rodar o Projeto

### Pré-requisitos

- Flutter 3.22+ (com Dart 3.4+)
- Visual Studio Code (recomendado) ou Android Studio
- Conta no [Supabase](https://supabase.com/)
- Dispositivo físico ou emulador (Android/iOS) com Google Play Services (para mapas)

### Etapas para Execução

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/QMob.git
   cd QMob

2. Configure o Supabase:
- Crie um projeto no Supabase.
- Execute os scripts SQL (disponíveis em /database/schema.sql)
- Habilite a autenticação com e-mail/senha e desabilite a confirmação de e-mail (para testes).
- Configure as políticas de segurança (RLS) conforme necessário.
- Obtenha a URL do projeto e a chave anônima (anon key).

3. Configure o ambiente:
- Crie um arquivo .env na raiz do projeto com o seguinte conteúdo:
  ```env
  SUPABASE_URL=sua_url_do_supabase
  SUPABASE_ANON_KEY=sua_chave_anonima

- Instale as dependências:
  ```bash
  flutter pub get

- Configure um emulador ou dispositivo
  - Emulador: No Visual Sudio Code, clique em Run > Start Debugging (F5) e selecione um emulador Android ou iOS).[
  - Dispositivo físico: Conecte via USB com Modo Desenvolvedor e Depuração USB habilitados ou use Depuração sem fio (em Opções do desenvolvedor no dispositivo).

4. Execute o aplicativo:
    ```bash
    flutter run
  
> ⚠️ **Administrador**: Você precisa criar manualmente um usuário administrador na tabela `admins` com o campo `must_change_password = true`. Use o UUID do usuário criado via Authentication → Users.

## 🎥 Apresentação do Aplicativo

Confira a apresentação do aplicativo [aqui](https://youtu.be/fVcrupcBonA).
