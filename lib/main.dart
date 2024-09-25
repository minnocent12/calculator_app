import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Calculator'),
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
  String _display = '0';
  String _operator = '';
  double _firstOperand = 0;
  double _secondOperand = 0;
  bool _waitingForSecondOperand = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_display == '0' || _waitingForSecondOperand) {
        _display = number;
        _waitingForSecondOperand = false;
      } else {
        _display += number;
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      _firstOperand = double.parse(_display);
      _operator = operator;
      _waitingForSecondOperand = true;
    });
  }

  void _onEqualPressed() {
    setState(() {
      _secondOperand = double.parse(_display);
      switch (_operator) {
        case '+':
          _display = (_firstOperand + _secondOperand).toString();
          break;
        case '-':
          _display = (_firstOperand - _secondOperand).toString();
          break;
        case '*':
          _display = (_firstOperand * _secondOperand).toString();
          break;
        case '/':
          _display = (_firstOperand / _secondOperand).toString();
          break;
      }
      _waitingForSecondOperand = false;
    });
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _firstOperand = 0;
      _secondOperand = 0;
      _operator = '';
      _waitingForSecondOperand = false;
    });
  }

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
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['0', 'C', '=', '+']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonText) {
        return ElevatedButton(
          onPressed: () {
            if (buttonText == 'C') {
              _onClearPressed();
            } else if (buttonText == '=') {
              _onEqualPressed();
            } else if (['+', '-', '*', '/'].contains(buttonText)) {
              _onOperatorPressed(buttonText);
            } else {
              _onNumberPressed(buttonText);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24.0),
            shape: const CircleBorder(),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}
