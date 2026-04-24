import 'package:flutter/material.dart';
import 'theme_data.dart';

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  // Logic Variables
  String display = "1";
  String Input = "1";

  // Selected temperatures
  String temp1 = "Celsius \u00B0C";
  String temp2 = "Fahrenheit \u00B0F";
  int activeRowIndex = 0;

  final List<String> tempUnits = [
    "Celsius \u00B0C",
    "Fahrenheit \u00B0F",
    "Kelvin K",
  ];

  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      Input = "0";
    } else if (buttonText == "DEL") {
      if (Input.length > 1) {
        Input = Input.substring(0, Input.length - 1);
        if (Input == "-") Input = "0";
      } else {
        Input = "0";
      }
    } else if (buttonText == "+/-") {
      if (Input != "0") {
        if (Input.startsWith("-")) {
          Input = Input.substring(1);
        } else {
          Input = "-$Input";
        }
      }
    } else if (buttonText == ".") {
      if (!Input.contains(".")) {
        Input = Input + buttonText;
      }
    } else {
      if (Input == "0") {
        Input = buttonText;
      } else if (Input == "-0") {
        Input = "-$buttonText";
      } else {
        Input = Input + buttonText;
      }
    }

    setState(() {
      display = Input;
    });
  }

  double convertTemp(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;

    double tempInC;
    // Step 1: Convert to Celsius first
    if (fromUnit == "Fahrenheit \u00B0F") {
      tempInC = (value - 32) * 5 / 9;
    } else if (fromUnit == "Kelvin K") {
      tempInC = value - 273.15;
    } else {
      tempInC = value;
    }

    // Step 2: Convert Celsius to Target Unit
    if (toUnit == "Fahrenheit \u00B0F") {
      return tempInC * 9 / 5 + 32;
    } else if (toUnit == "Kelvin K") {
      return tempInC + 273.15;
    } else {
      return tempInC;
    }
  }

  Widget _buildTempRow(
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
                dropdownColor: currentTheme.secondaryBackground,
                icon: Icon(
                  Icons.unfold_more,
                  color: currentTheme.textColor.withOpacity(0.54),
                  size: 20,
                ),
                // dropdowncolor: currentTheme.secondaryBackground,
                style: TextStyle(
                  color: currentTheme.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: onChanged,
                items: tempUnits.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Text(
              // value
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
    double? customHeight,
  }) {
    return SizedBox(
      height: customHeight ?? screenHeight * 0.075,
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
                style: TextStyle(color: currentTheme.textColor, fontSize: 25),
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

    double currentVal = double.tryParse(display) ?? 0;

    String activeUnit = activeRowIndex == 0 ? temp1 : temp2;

    double val1 = convertTemp(currentVal, activeUnit, temp1);
    double val2 = convertTemp(currentVal, activeUnit, temp2);

    String formatStr(double val) {
      String s = val.toStringAsFixed(5);
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
                        'Temperature',
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

              // Temperature List
              Expanded(
                child: Column(
                  children: [
                    _buildTempRow(
                      temp1,
                      val1Str,
                      (val) {
                        if (val != null) setState(() => temp1 = val);
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
                    _buildTempRow(
                      temp2,
                      val2Str,
                      (val) {
                        if (val != null) setState(() => temp2 = val);
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

              // Keypad section (Custom mapping based on columns!)
              Container(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.02,
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Col 1 (7, 4, 1, 00)
                    Column(
                      children: [
                        _buildKeypadButton(
                          "7",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "4",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "1",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "00",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                      ],
                    ),
                    // Col 2 (8, 5, 2, 0)
                    Column(
                      children: [
                        _buildKeypadButton(
                          "8",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "5",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "2",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "0",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                      ],
                    ),
                    // Col 3 (9, 6, 3, .)
                    Column(
                      children: [
                        _buildKeypadButton(
                          "9",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "6",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "3",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          ".",
                          screenWidth,
                          screenHeight,
                          buttonColor,
                        ),
                      ],
                    ),
                    // Col 4 (C, DEL, +/- [Tall])
                    Column(
                      children: [
                        _buildKeypadButton(
                          "C",
                          screenWidth,
                          screenHeight,
                          mainColor,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "DEL",
                          screenWidth,
                          screenHeight,
                          mainColor,
                          icon: Icons.backspace_outlined,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "+/-",
                          screenWidth,
                          screenHeight,
                          mainColor,
                          customHeight: (screenHeight * 0.075 * 2) + 10,
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
