import 'package:flutter/material.dart';
import 'LandingPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLandingPage();
  }

  // Función que navega a la LandingPage después de 3 segundos
  void _navigateToLandingPage() {
    Future.delayed(const Duration(seconds: 3), () {
      // Cambiar la pantalla a LandingPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LandingPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Catbreeds', // Título de la aplicación
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Imagen del splash
            Image.asset('assets/images/splash.jpg'),
            const SizedBox(height: 20),
            // Opcional: Agregar un indicador de carga mientras se hace la transición
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
