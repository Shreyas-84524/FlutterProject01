import 'package:flutter/material.dart';

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

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      Input = "0";
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if (buttonText == "DEL") {
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
      Input = "0";
    } else if (buttonText == ".") {
      // PREVENT MULTIPLE DECIMALS
      if (Input.contains(".")) {
        return;
      } else {
        Input = Input + buttonText;
      }
    } else if (buttonText == "=") {
      // EXECUTE THE MATH
      num2 = double.parse(display);

      if (operand == "+") Input = (num1 + num2).toString();
      if (operand == "-") Input = (num1 - num2).toString();
      if (operand == "x") Input = (num1 * num2).toString();
      if (operand == "%") Input = (num1 % num2).toString();
      if (operand == "/") {
        Input = num2 == 0 ? "Error" : (num1 / num2).toString();
      }

      // Reset state for chain calculations
      num1 = 0;
      num2 = 0;
      operand = "";
    } else {
      // APPEND NUMBERS
      if (Input == "0") {
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
    double buttonHeight = 0.085;
    double buttonWidth = 0.21;
    int buttonColor = 0xFFFFC81E;
    int mainColor = 0xFFE87F24;
    int buttonTexteq = 0xFF000000;
    String multiply = '\u{00D7}';
    String divide = '\u{00F7}';
    return Center(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFEFDDF),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),

            height: screenHeight * 1.0,
            width: screenWidth * 1.0,
            child: Column(
              children: [
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
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: screenHeight * 0.35,
                        width: screenWidth * 0.92,

                        // Added styling to make the display readable
                        child: Padding(
                          padding: EdgeInsetsGeometry.directional(
                            top: 5,
                            start: 5,
                            end: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            display,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("AC"),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Icon(Icons.backspace_outlined),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("%"),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("+"),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("1"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("2"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("3"),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("-"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("4"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("5"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("6"),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("\u{00D7}"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("7"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("8"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("9"),
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
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("\u{00F7}"),
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
                              onPressed: () => _buttonPressed("."),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("."),
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
                              onPressed: () => _buttonPressed("00"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("00"),
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
                                backgroundColor: Color.fromARGB(
                                  229,
                                  255,
                                  198,
                                  29,
                                ), // Background color
                                foregroundColor:
                                    Colors.black, // Text and Icon color
                                // Color of the shadow
                                // Inner spacing
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ), // How round the corners are
                                ),
                              ),
                              child: const Text("0"),
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
                              child: const Text("="),
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
