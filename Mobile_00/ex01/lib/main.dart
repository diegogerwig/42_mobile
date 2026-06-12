import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

// Main widget that sets up the base design of the app
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
      home: const MyHomePage(),
    );
  }
}

// Main graphical interface (Stateful to allow UI updates)
class MyHomePage extends StatefulWidget {  // Dynamic widget
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();  // Connects the state to the widget
}

// Class that manages the state and visual changes of MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  bool _isToggled = false;

  // Toggles the text state and updates the screen
  void _onButtonPressed() {
    setState(() {
      _isToggled = !_isToggled;
    });
    // Print to debug console
    print('Button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
