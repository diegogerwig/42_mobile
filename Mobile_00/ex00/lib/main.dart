import 'package:flutter/material.dart';

// Punto de entrada de la aplicación.
void main() {
  // runApp lanza la aplicación dibujando el widget raíz (MyApp).
  runApp(const MyApp());
}

// MyApp es el widget raíz de la aplicación. Es un StatelessWidget porque su
// configuración general (tema, título) no cambia durante la ejecución.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // El método build describe cómo se ve este widget en la pantalla.
  @override
  Widget build(BuildContext context) {
    // MaterialApp es el contenedor principal que provee la estructura de diseño Material.
    return MaterialApp(
      title: 'ex00', // Título interno de la app
      theme: ThemeData(
        // Genera una paleta de colores a partir del color morado
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Oculta la etiqueta de "DEBUG" en la esquina superior derecha
      debugShowCheckedModeBanner: false,
      // Define la pantalla principal (Home) de la aplicación
      home: const MyHomePage(),
    );
  }
}

// MyHomePage es la pantalla principal. Para el ex00, es un StatelessWidget 
// porque su contenido en pantalla no cambia dinámicamente.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Función que se ejecuta cuando se presiona el botón.
  void _onButtonPressed() {
    // Imprime texto en la consola de depuración (debug console)
    print('Button pressed');
  }

  // Define la interfaz gráfica de esta pantalla.
  @override
  Widget build(BuildContext context) {
    // Scaffold provee la estructura visual básica (fondo, barras de navegación).
    return Scaffold(
      // Center centra vertical y horizontalmente a su widget hijo.
      body: Center(
        // Column organiza a sus hijos de arriba hacia abajo (en vertical).
        child: Column(
          // Centra los hijos dentro de la columna.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Widget de texto estático
            const Text(
              'A simple text',
              style: TextStyle(fontSize: 24),
            ),
            // Widget invisible usado para dar 16 píxeles de espacio vertical
            const SizedBox(height: 16),
            // Botón con relieve
            ElevatedButton(
              // Al pulsarlo, llama a la función _onButtonPressed
              onPressed: _onButtonPressed,
              child: const Text('Click me'),
            ),
          ],
        ),
      ),
    );
  }
}
