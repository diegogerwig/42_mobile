import 'package:flutter/material.dart';

// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

// Widget principal que configura el diseño base de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex00',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

// Interfaz gráfica de la página principal (Stateless)
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Función ejecutada al presionar el botón principal
  void _onButtonPressed() {
    print('Button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'A simple text',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onButtonPressed,
              child: const Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }
}



