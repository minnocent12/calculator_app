import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 58, 81, 183),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = '0'; // Current display on the calculator screen
  double? _firstOperand; // Stores the first operand
  double? _secondOperand; // Stores the second operand
  String? _operator; // Stores the operator (+, -, *, /)
  bool _isSecondOperand = false; // Flag for inputting the second operand
  bool _isResultCalculated = false; // Flag to track if a result is calculated

  // Function to handle number button presses
  void _onNumberPressed(String number) {
    setState(() {
      // If a result was just calculated, reset everything and start fresh with the new number
      if (_isResultCalculated) {
        _display = number;
        _firstOperand = null;
        _secondOperand = null;
        _operator = null;
        _isResultCalculated = false; // Clear the result flag after input
      } else if (_isSecondOperand) {
        // If expecting second operand, start fresh with the second number
        _display = number;
        _isSecondOperand = false;
      } else {
        _display = _display == '0' ? number : _display + number;
      }
    });
  }

  // Function to handle operator button presses
  void _onOperatorPressed(String operator) {
    setState(() {
      if (_firstOperand == null || _isResultCalculated) {
        _firstOperand = double.tryParse(
            _display); // Use the current display as the first operand
        _isResultCalculated = false; // Reset result flag after new operator
      } else if (_operator != null && !_isSecondOperand) {
        // If already an operator, calculate with current number before storing new operator
        _secondOperand = double.tryParse(_display);
        _calculateResult();
      }
      _operator = operator;
      _isSecondOperand = true;
    });
  }

  // Function to handle equal button press and calculate the result
  void _onEqualPressed() {
    setState(() {
      if (_firstOperand != null && _operator != null) {
        _secondOperand = double.tryParse(_display);
        _calculateResult();
        _operator = null; // Reset operator after result
        _isResultCalculated = true; // Set flag to indicate result is calculated
      }
    });
  }

  // Function to perform the calculation based on the operator
  void _calculateResult() {
    if (_firstOperand != null && _secondOperand != null && _operator != null) {
      double result;
      switch (_operator) {
        case '+':
          result = _firstOperand! + _secondOperand!;
          break;
        case '-':
          result = _firstOperand! - _secondOperand!;
          break;
        case '*':
          result = _firstOperand! * _secondOperand!;
          break;
        case '/':
          result = _secondOperand! != 0
              ? _firstOperand! / _secondOperand!
              : double.nan; // Handle division by zero
          break;
        default:
          return;
      }
      _display = result.toString();
      _firstOperand = result;
      _secondOperand = null;
    }
  }

  // Function to handle the "Clear" button press
  void _onClearPressed() {
    setState(() {
      _display = '0';
      _firstOperand = null;
      _secondOperand = null;
      _operator = null;
      _isSecondOperand = false;
      _isResultCalculated = false;
    });
  }

  // Function to build the calculator buttons (numbers, operators, etc.)
  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  // Widget to build the UI layout using Rows and Columns
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Display area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          // Number and operator buttons in rows
          _buildButtonRow(
              ['7', '8', '9', '/'], const Color.fromARGB(255, 58, 93, 183)),
          _buildButtonRow(
              ['4', '5', '6', '*'], const Color.fromARGB(255, 58, 93, 183)),
          _buildButtonRow(
              ['1', '2', '3', '-'], const Color.fromARGB(255, 58, 93, 183)),
          _buildButtonRow(
              ['0', 'C', '=', '+'], const Color.fromARGB(255, 58, 93, 183)),
        ],
      ),
    );
  }

  // Helper function to create rows of buttons
  Widget _buildButtonRow(List<String> buttons, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonLabel) {
        // Define button actions based on its label
        VoidCallback onPressed;
        Color buttonColor = color;

        // Change color for operation buttons
        if (['+', '-', '*', '/'].contains(buttonLabel)) {
          buttonColor = Colors.orange; // Set a different color for operators
        }

        if (buttonLabel == 'C') {
          onPressed = _onClearPressed;
        } else if (buttonLabel == '=') {
          onPressed = _onEqualPressed;
        } else if (['+', '-', '*', '/'].contains(buttonLabel)) {
          onPressed = () => _onOperatorPressed(buttonLabel);
        } else {
          onPressed = () => _onNumberPressed(buttonLabel);
        }
        return _buildButton(buttonLabel, buttonColor, onPressed);
      }).toList(),
    );
  }
}
