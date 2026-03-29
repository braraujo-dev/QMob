import 'package:alternative/core/di/injection_container.dart';
import 'package:alternative/features/root/presentation/controllers/splash_controller.dart';
import 'package:alternative/features/root/presentation/controllers/splash_state.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = sl<SplashController>();
    _controller.addListener(_onStateChanged);
    _controller.decideInitialRoute();
  }

  void _onStateChanged() {
    if (_controller.value is SplashSuccessState) {
      final state = _controller.value as SplashSuccessState;
      Navigator.pushReplacementNamed(context, state.route);
    }

    if (_controller.value is SplashErrorState) {
      final state = _controller.value as SplashErrorState;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bus, size: 80, color: Colors.blueAccent),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
