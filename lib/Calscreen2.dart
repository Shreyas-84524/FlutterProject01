import 'package:flutter/material.dart';
import 'converterScreen.dart';
import 'settingsScreen.dart';
import 'theme_data.dart';

class Calscreen extends StatefulWidget {
  const Calscreen({super.key});

  @override
  State<Calscreen> createState() => _CalscreenState();
}

class _CalscreenState extends State<Calscreen> {
  // The string currently shown on the display
  String display = "0";

  // Variables to hold the math logic
  double num1 = 0;
  double num2 = 0;

  String operand = "";

  // Internal string to build the current number
  String Input = "0";

  // New variables for expression display
  String expression = "";
  bool isFinalResult = false;
  String _format(double val) {
    String s = val.toString();
    if (s.endsWith(".0")) {
      return s.substring(0, s.length - 2);
    }
    return s;
  }

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      Input = "0";
      num1 = 0;
      num2 = 0;
      operand = "";
      expression = "";
      isFinalResult = false;
    } else if (buttonText == "DEL") {
      if (isFinalResult) {
        expression = "";
        isFinalResult = false;
      }
      // PREVENT CRASHES AND HANDLE SINGLE DIGITS
      if (Input.length > 1) {
        Input = Input.substring(0, Input.length - 1);
      } else {
        Input = "0";
      }
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "x" ||
        buttonText == "%" ||
        buttonText == "/") {
      // STORE FIRST NUMBER AND OPERATOR
      num1 = double.parse(display);
      operand = buttonText;

      String displaySymbol = operand;
      if (operand == "x") displaySymbol = "\u{00D7}";
      if (operand == "/") displaySymbol = "\u{00F7}";

      expression = "${_format(num1)} $displaySymbol";
      isFinalResult = false;
      Input = "0";
    } else if (buttonText == ".") {
      if (isFinalResult) {
        Input = "0.";
        expression = "";
        isFinalResult = false;
        setState(() {
          display = Input;
        });
        return;
      }
      // PREVENT MULTIPLE DECIMALS
      if (Input.contains(".")) {
        return;
      } else {
        Input = Input + buttonText;
      }
    } else if (buttonText == "=") {
      // EXECUTE THE MATH
      num2 = double.parse(display);
      double result = 0;

      if (operand == "") return;

      if (operand == "+") result = num1 + num2;
      if (operand == "-") result = num1 - num2;
      if (operand == "x") result = num1 * num2;
      if (operand == "%") result = num1 % num2;
      if (operand == "/") {
        if (num2 == 0) {
          Input = "Error";
        } else {
          result = num1 / num2;
        }
      }

      if (Input != "Error") {
        String displaySymbol = operand;
        if (operand == "x") displaySymbol = "\u{00D7}";
        if (operand == "/") displaySymbol = "\u{00F7}";

        expression = "${_format(num1)} $displaySymbol ${_format(num2)} =";
        Input = _format(result);
      } else {
        expression = "";
      }

      // Reset state for chain calculations (but keep for expression)
      num1 = 0;
      num2 = 0;
      operand = "";
      isFinalResult = true;
    } else {
      // APPEND NUMBERS
      if (isFinalResult) {
        Input = buttonText;
        expression = "";
        isFinalResult = false;
      } else if (Input == "0") {
        Input = buttonText; // Replace initial 0
      } else {
        Input = Input + buttonText;
      }
    }

    // UPDATE THE UI
    setState(() {
      // Prevent crash if "Error" is returned from divide by zero
      if (Input == "Error") {
        display = Input;
      }
      // Clean up the display
      else if (Input.endsWith(".0")) {
        display = Input.replaceAll(".0", "");
      } else {
        display = Input;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingHeight = 0.03;
    double paddingWidth = 0.03;
    double buttonHeight = 0.075;
    double buttonWidth = 0.21;
    int buttonColor = currentTheme.numberButtonColor.value;
    int mainColor = currentTheme.actionButtonColor.value;
    int buttonTexteq =
        currentTheme.textColor.value; // Use text color from theme
    int buttinTexteqColor = currentTheme.actionButtonColor.value;
    double buttonFontSize = 25;
    String multiply = '\u{00D7}';
    String divide = '\u{00F7}';
    return Center(
      child: Scaffold(
        backgroundColor: currentTheme.mainBackground,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: currentTheme.secondaryBackground,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),

            height: screenHeight * 1.0,
            width: screenWidth * 1.0,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 24,
                      ), // to balance the 24px icon on the right
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'CALCULATOR',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: currentTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 2,
                                width: 30,
                                color: Color(mainColor),
                              ),
                            ],
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const converterScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Text(
                                  "CONVERTER",
                                  style: TextStyle(
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 2,
                                  width: 30,
                                  color: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const settingsScreen(),
                            ),
                          ).then((_) {
                            setState(() {}); // Rebuild to apply new theme
                          });
                        },
                        child: Icon(Icons.more_vert, color: Color(mainColor)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.directional(
                        top: screenHeight * 0.034,
                        bottom: screenHeight * 0.01,
                        start: screenWidth * 0.03806,
                        end: screenWidth * 0.03806,
                      ),

                      child: Container(
                        height: screenHeight * 0.27,
                        width: screenWidth * 0.92,
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (expression.isNotEmpty)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  expression,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: currentTheme.textColor.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                display,
                                style: TextStyle(
                                  fontSize: display.length > 8 ? 50 : 70,
                                  fontWeight: FontWeight.bold,
                                  color: currentTheme.textColor,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("C"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text(
                                "AC",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("DEL"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Icon(
                                Icons.backspace_outlined,
                                size: 25.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("%"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text(
                                "%",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("+"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text(
                                "+",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("1"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "1",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("2"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "2",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("3"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorolor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "3",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("-"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text(
                                "-",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("4"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "4",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("5"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorolor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "5",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("6"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorlor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "6",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("x"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text(
                                "\u{00D7}",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("7"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorcolor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "7",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("8"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorcolor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "8",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("9"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorr
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "9",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("/"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text(
                                "\u{00F7}",
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("00"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorolor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "00",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("0"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background colorlor
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                "0",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("."),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  buttonColor,
                                ), // Background color
                                foregroundColor: currentTheme
                                    .textColor, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text(
                                ".",
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * paddingHeight,
                            top: screenHeight * paddingWidth,
                          ),
                          child: SizedBox(
                            height: screenHeight * buttonHeight,
                            width: screenWidth * buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => _buttonPressed("="),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                  mainColor,
                                ), // Background color
                                foregroundColor: Color(
                                  buttonTexteq,
                                ), // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: Text("=", style: TextStyle(fontSize: 25)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Converter"),
      ),
      body: const Center(
        child: Text(
          "Future Converter Content",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
