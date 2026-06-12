import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late TextEditingController _expressionController;
  late TextEditingController _resultController;

  @override
  void initState() {
    super.initState();
    // Initially display "0" in both text fields as requested
    _expressionController = TextEditingController(text: '0');
    _resultController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _expressionController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  // Debug feature: print the button text to console
  void _onButtonPressed(String buttonText) {
    print('button pressed :$buttonText');
  }

  // Helper widget to build each button inside the grid uniformly
  Widget _buildButton(String text) {
    // Make the "=" button span 2 columns like in the screenshot
    int flex = (text == '=') ? 2 : 1;
    
    // Set specific colors for special buttons
    Color textColor = Colors.white;
    if (text == 'C' || text == 'AC') {
      textColor = Colors.redAccent;
    } else if (text == '+' || text == '-' || text == '*' || text == '/') {
      textColor = Colors.white54;
    }

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => _onButtonPressed(text),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        children: [
          // Top section: Display areas (occupies 2/5 of vertical space)
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.blueGrey[700],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _expressionController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 28, color: Colors.white70),
                    decoration: const InputDecoration(border: InputBorder.none),
                    readOnly: true,
                  ),
                  TextField(
                    controller: _resultController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    readOnly: true,
                  ),
                ],
              ),
            ),
          ),
          // Bottom section: Keypad (occupies 3/5 of vertical space)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('C'), _buildButton('AC'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('+'), _buildButton('-'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('*'), _buildButton('/'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildButton('0'), _buildButton('.'), _buildButton('00'), _buildButton('='),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
