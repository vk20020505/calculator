import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(title: 'Calculator'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<Home> {
  String userInput = '';
  String result = '0';

  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C',
    '0',
    '.',
    '='
  ];
  Widget customButton(text) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(bgColor(text))),
        onPressed: () {
          setState(() {
            handleButtons(text);
          });
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 25),
        ));
  }

  handleButtons(String text) {
    if (text == 'AC') {
      userInput = '';
      result = '0';
      return;
    }
    if (text == 'C') {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);
        return;
      } else {
        return;
      }
    }
    if (text == '=') {
      result = calculate();
      // userInput = result;

      // if (userInput.endsWith('.0')) {
      //   userInput = userInput.replaceAll('.0', '');
      //   return;
      // }
      if (result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
        return;
      }
    }
    userInput = userInput + text;
  }

  String calculate() {
    try {
      var exp = Parser().parse(userInput);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return 'Error';
    }
  }

  bgColor(String text) {
    if (text == 'AC' || text == 'C') {
      return Colors.redAccent;
    }
    if (text == '=') {
      return Colors.greenAccent;
    } else {
      return Colors.blueAccent.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: const Alignment(1, 1),
              padding: const EdgeInsets.only(right: 12),
              child: Text(userInput,
                  style: const TextStyle(fontSize: 25, color: Colors.grey)),
            ),
            Container(
              alignment: const Alignment(1, 1),
              padding: const EdgeInsets.all(12),
              child: Text(
                result.replaceAll('.0', ''),
                style: const TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 15),
              itemCount: buttonList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return customButton(buttonList[index]);
              },
            )
          ],
        ),
      ),
    );
  }
}
