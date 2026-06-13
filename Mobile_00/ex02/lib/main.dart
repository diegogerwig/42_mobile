import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  runApp(const CalculatorApp());
}

// Main widget that sets up the base design of the app
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
      ),
      home: const CalculatorScreen(),
    );
  }
}

// Main graphical interface (Stateful to allow UI updates)
class CalculatorScreen extends StatefulWidget { // Dynamic widget
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState(); // Connects the state to the widget
}

// Class that manages the state and visual changes of CalculatorScreen
class _CalculatorScreenState extends State<CalculatorScreen> {
  late TextEditingController _expressionController;
  late TextEditingController _resultController;

  // Initialize the text controllers with default values
  @override
  void initState() {
    super.initState();  // super.initState() is called to ensure that the parent class's initialization logic is executed before adding custom initialization logic for this state.
    // Initially display "0" in both text fields
    _expressionController = TextEditingController(text: '0');
    _resultController = TextEditingController(text: '0');
  }

  // Dispose of the controllers to free up resources when the widget is removed from the widget tree
  @override
  void dispose() {
    _expressionController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  // Toggles the text state and updates the screen
  void _onButtonPressed(String buttonText) {
    // Print to debug console
    print('button pressed :$buttonText');
  }

  // Helper widget to build each button inside the grid uniformly
  Widget _buildButton(String text) {
    
    // Set specific colors for special buttons
    Color textColor = Colors.white;
    if (text == 'C' || text == 'AC') {
      textColor = Colors.redAccent;
    } else if (text == '+' || text == '-' || text == '*' || text == '/') {
      textColor = Colors.white70;
    }

    // Make the "=" button span 2 columns
    int flex = (text == '=') ? 2 : 1;

    return Expanded(
      flex: flex,
      child: InkWell(  // InkWell provides a visual feedback when the button is tapped
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
    // Check if the device is in horizontal/landscape mode
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    // Adjust sizes based on orientation to prevent overflow
    double expressionFontSize = isLandscape ? 16 : 28;
    double resultFontSize = isLandscape ? 24 : 40;
    double topPadding = isLandscape ? 2.0 : 8.0;
    double gapHeight = isLandscape ? 2.0 : 8.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
        toolbarHeight: isLandscape ? 35 : 56, 
      ),
      backgroundColor: Colors.blueGrey[900],
      // Wrap the entire Column in a SafeArea to respect system bars/notches
      body: SafeArea(  // SafeArea ensures that the content is not obscured by system UI elements like the notch or status bar
        child: Column(
          children: [
            // Top section: Display areas
            Expanded(
              flex: 2,  // The top section takes up 2/5 of the available vertical space
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: topPadding),
                color: Colors.blueGrey[700],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _expressionController,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: expressionFontSize, color: Colors.white70),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      readOnly: true,
                    ),
                    SizedBox(height: gapHeight), // Dynamic visual gap
                    TextField(
                      controller: _resultController,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: resultFontSize, color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom section: Keypad
            Expanded(
              flex: 3,  // The bottom section takes up 3/5 of the available vertical space
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
      ),
    );
  }
}
