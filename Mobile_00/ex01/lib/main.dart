import 'package:flutter/material.dart';

// Punto de entrada de la aplicación.
void main() {
  runApp(const MyApp());
}

// Widget raíz de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex01',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(), // Define la pantalla principal
    );
  }
}

// MyHomePage es ahora un StatefulWidget. Esto es necesario porque la pantalla 
// debe reaccionar y redibujarse cuando su "estado" interno cambia (ej. al pulsar un botón).
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // Crea y asocia la clase de estado (_MyHomePageState) a este widget.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Esta clase contiene el "estado" de MyHomePage. 
class _MyHomePageState extends State<MyHomePage> {
  // Variable de estado que guarda si el botón ha sido presionado (alterna entre true/false)
  bool _isToggled = false;

  // Función que se ejecuta al presionar el botón.
  void _onButtonPressed() {
    // setState() le dice a Flutter que una variable del estado ha cambiado y que 
    // debe volver a ejecutar el método build() para actualizar la pantalla.
    setState(() {
      _isToggled = !_isToggled; // Invierte el valor (de false a true, o viceversa)
    });
    print('Button pressed'); // Imprime en consola
  }

  // Dibuja la interfaz visual. Se vuelve a ejecutar cada vez que llamamos a setState().
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Muestra un texto u otro dependiendo del valor de la variable de estado (_isToggled)
            Text(
              _isToggled ? 'Hello World!' : 'A simple text',
              style: const TextStyle(fontSize: 24),
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
