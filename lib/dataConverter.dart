import 'package:flutter/material.dart';
import 'theme_data.dart';

class DataConverterScreen extends StatefulWidget {
  const DataConverterScreen({super.key});

  @override
  State<DataConverterScreen> createState() => _DataConverterScreenState();
}

class _DataConverterScreenState extends State<DataConverterScreen> {
  // Calculator Logic Variables
  String display = "1";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  String Input = "1";

  // Selected areas
  String data1 = "Megabyte MB";
  String data2 = "Kilobyte KB";
  int activeRowIndex = 0;

  // Conversion rates (In Bytes)
  final Map<String, double> dataRates = {
    "Byte B": 1.0,
    "Kilobyte KB": 1024.0,
    "Megabyte MB": 1048576.0,
    "Gigabyte GB": 1073741824.0,
    "Terabyte TB": 1099511627776.0,
    "Petabyte PB": 1125899906842624.0,
  };

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      Input = "0";
      num1 = 0;
      num2 = 0;
      operand = "";
    } else if (buttonText == "DEL") {
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
      num1 = double.tryParse(display) ?? 0;
      operand = buttonText;
      Input = "0";
    } else if (buttonText == ".") {
      if (Input.contains(".")) {
        return;
      } else {
        Input = Input + buttonText;
      }
    } else if (buttonText == "=") {
      num2 = double.tryParse(display) ?? 0;

      if (operand == "+") Input = (num1 + num2).toString();
      if (operand == "-") Input = (num1 - num2).toString();
      if (operand == "x") Input = (num1 * num2).toString();
      if (operand == "%") Input = (num1 % num2).toString();
      if (operand == "/") {
        Input = num2 == 0 ? "Error" : (num1 / num2).toString();
      }

      num1 = 0;
      num2 = 0;
      operand = "";
    } else {
      if (Input == "0") {
        Input = buttonText;
      } else {
        Input = Input + buttonText;
      }
    }

    setState(() {
      if (Input == "Error") {
        display = Input;
      } else if (Input.endsWith(".0")) {
        display = Input.replaceAll(".0", "");
      } else {
        display = Input;
      }
    });
  }

  Widget _buildDataRow(
    String currentUnit,
    String valueStr,
    ValueChanged<String?> onChanged, {
    bool isActive = false,
    required VoidCallback onTapValue,
  }) {
    return GestureDetector(
      onTap: onTapValue,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentUnit,
                icon: Icon(
                  Icons.unfold_more,
                  color: currentTheme.textColor.withOpacity(0.54),
                  size: 20,
                ),
                dropdownColor: currentTheme.secondaryBackground,
                style: TextStyle(
                  color: currentTheme.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: onChanged,
                items: dataRates.keys.map<DropdownMenuItem<String>>((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Text(
              valueStr,
              style: TextStyle(
                color: isActive
                    ? currentTheme.actionButtonColor
                    : currentTheme.textColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadButton(
    String text,
    double screenWidth,
    double screenHeight,
    int bgColor, {
    IconData? icon,
  }) {
    return SizedBox(
      height: screenHeight * 0.075,
      width: screenWidth * 0.21,
      child: ElevatedButton(
        onPressed: () => _buttonPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(bgColor),
          // foregroundcolor: currentTheme.textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: icon != null
            ? Icon(icon, size: 25.0, color: currentTheme.textColor)
            : Text(
                text,
                style: TextStyle(fontSize: 25, color: currentTheme.textColor),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int buttonColor = currentTheme.numberButtonColor.value; // Yellow
    int mainColor = currentTheme.actionButtonColor.value; // Orange

    double activeRate = dataRates[activeRowIndex == 0 ? data1 : data2] ?? 1.0;

    double currentVal = double.tryParse(display) ?? 0;

    // Normalize to Bytes
    double normalizedValInB = currentVal * activeRate;

    // Convert to targets
    double val1 = normalizedValInB / (dataRates[data1] ?? 1.0);
    double val2 = normalizedValInB / (dataRates[data2] ?? 1.0);

    String formatStr(double val) {
      String s = val.toStringAsFixed(8);
      if (s.contains('.')) {
        s = s.replaceAll(RegExp(r'0*$'), '');
        if (s.endsWith('.')) s = s.substring(0, s.length - 1);
      }
      return s;
    }

    String val1Str = activeRowIndex == 0 ? display : formatStr(val1);
    String val2Str = activeRowIndex == 1 ? display : formatStr(val2);

    return Scaffold(
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
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.05,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        'Data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24), // Balance the row
                  ],
                ),
              ),

              // Data List
              Expanded(
                child: Column(
                  children: [
                    _buildDataRow(
                      data1,
                      val1Str,
                      (val) {
                        if (val != null) setState(() => data1 = val);
                      },
                      isActive: activeRowIndex == 0,
                      onTapValue: () {
                        setState(() {
                          if (activeRowIndex != 0) {
                            activeRowIndex = 0;
                            Input = val1Str;
                            display = val1Str;
                          }
                        });
                      },
                    ),
                    _buildDataRow(
                      data2,
                      val2Str,
                      (val) {
                        if (val != null) setState(() => data2 = val);
                      },
                      isActive: activeRowIndex == 1,
                      onTapValue: () {
                        setState(() {
                          if (activeRowIndex != 1) {
                            activeRowIndex = 1;
                            Input = val2Str;
                            display = val2Str;
                          }
                        });
                      },
                    ),

                    const Spacer(),
                  ],
                ),
              ),

              // Keypad section (Mimicking Calscreen2 exactly)
              Container(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.02,
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.03,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton(
                          "C",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                        _buildKeypadButton(
                          "DEL",
                          screenWidth,
                          screenHeight,
                          mainColor,
                          icon: Icons.backspace_outlined,
                        ),
                        _buildKeypadButton(
                          "%",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                        _buildKeypadButton(
                          "/",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton(
                          "7",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "8",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "9",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "x",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton(
                          "4",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "5",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "6",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "-",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton(
                          "1",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "2",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "3",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "+",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton(
                          "00",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "0",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          ".",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        _buildKeypadButton(
                          "=",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
