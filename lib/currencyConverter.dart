import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'theme_data.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  // Calculator Logic Variables
  String display = "1";
  double num1 = 0;
  double num2 = 0;
  String operand = "";
  String Input = "1";

  // Selected currencies
  String baseCurrency = "India INR";
  String outCurrency1 = "USA USD";
  String outCurrency2 = "Euro EUR";
  int activeRowIndex = 0;

  // Manual conversion rates (Relative to 1.0 INR) - will be updated via API
  final Map<String, double> exchangeRates = {
    "India INR": 1.0,
    "China CNY": 0.086,
    "USA USD": 0.012,
    "Russia RUB": 1.11,
    "Georgia GEL": 0.032,
    "France EUR": 0.011,
    "Euro EUR": 0.011,
    "Sri Lanka LKR": 3.65,
    "Bangladesh BDT": 1.31,
    "Nepal NPR": 1.60,
    "Bhutan BTN": 1.00,
  };

  @override
  void initState() {
    super.initState();
    _fetchRealTimeRates();
  }

  Future<void> _fetchRealTimeRates() async {
    try {
      final response = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/bc6535ea75a1dabdc9a7e419/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['conversion_rates'] as Map<String, dynamic>;
        
        final inrRate = (rates['INR'] ?? 1.0).toDouble();

        setState(() {
          if (rates.containsKey('INR')) exchangeRates["India INR"] = rates['INR'] / inrRate;
          if (rates.containsKey('CNY')) exchangeRates["China CNY"] = rates['CNY'] / inrRate;
          if (rates.containsKey('USD')) exchangeRates["USA USD"] = rates['USD'] / inrRate;
          if (rates.containsKey('RUB')) exchangeRates["Russia RUB"] = rates['RUB'] / inrRate;
          if (rates.containsKey('GEL')) exchangeRates["Georgia GEL"] = rates['GEL'] / inrRate;
          if (rates.containsKey('EUR')) exchangeRates["France EUR"] = rates['EUR'] / inrRate;
          if (rates.containsKey('EUR')) exchangeRates["Euro EUR"] = rates['EUR'] / inrRate;
          if (rates.containsKey('LKR')) exchangeRates["Sri Lanka LKR"] = rates['LKR'] / inrRate;
          if (rates.containsKey('BDT')) exchangeRates["Bangladesh BDT"] = rates['BDT'] / inrRate;
          if (rates.containsKey('NPR')) exchangeRates["Nepal NPR"] = rates['NPR'] / inrRate;
          if (rates.containsKey('BTN')) exchangeRates["Bhutan BTN"] = rates['BTN'] / inrRate;
        });
      }
    } catch (e) {
      // Fallback to initial manual rates if API fails
      debugPrint("Failed to fetch exchange rates: $e");
    }
  }

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

  Widget _buildCurrencyRow(
    String currentCurrency,
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
                value: currentCurrency,
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
                items: exchangeRates.keys.map<DropdownMenuItem<String>>((
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

    double activeRate =
        exchangeRates[activeRowIndex == 0
            ? baseCurrency
            : activeRowIndex == 1
            ? outCurrency1
            : outCurrency2] ??
        1.0;

    double currentVal = double.tryParse(display) ?? 0;

    // Normalize to INR
    double normalizedValInINR = currentVal / activeRate;

    // Convert back up for all rows
    double val0 = normalizedValInINR * (exchangeRates[baseCurrency] ?? 1.0);
    double val1 = normalizedValInINR * (exchangeRates[outCurrency1] ?? 1.0);
    double val2 = normalizedValInINR * (exchangeRates[outCurrency2] ?? 1.0);

    String formatStr(double val) {
      String s = val.toStringAsFixed(5);
      if (s.contains('.')) {
        s = s.replaceAll(RegExp(r'0*$'), '');
        if (s.endsWith('.')) s = s.substring(0, s.length - 1);
      }
      return s;
    }

    String val0Str = activeRowIndex == 0 ? display : formatStr(val0);
    String val1Str = activeRowIndex == 1 ? display : formatStr(val1);
    String val2Str = activeRowIndex == 2 ? display : formatStr(val2);

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
                        'Currency',
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

              // Currency List
              Expanded(
                child: Column(
                  children: [
                    _buildCurrencyRow(
                      baseCurrency,
                      val0Str,
                      (val) {
                        if (val != null) setState(() => baseCurrency = val);
                      },
                      isActive: activeRowIndex == 0,
                      onTapValue: () {
                        setState(() {
                          if (activeRowIndex != 0) {
                            activeRowIndex = 0;
                            Input = val0Str;
                            display = val0Str;
                          }
                        });
                      },
                    ),
                    _buildCurrencyRow(
                      outCurrency1,
                      val1Str,
                      (val) {
                        if (val != null) setState(() => outCurrency1 = val);
                      },
                      isActive: activeRowIndex == 1,
                      onTapValue: () {
                        setState(() {
                          if (activeRowIndex != 1) {
                            activeRowIndex = 1;
                            Input = val1Str;
                            display = val1Str;
                          }
                        });
                      },
                    ),
                    _buildCurrencyRow(
                      outCurrency2,
                      val2Str,
                      (val) {
                        if (val != null) setState(() => outCurrency2 = val);
                      },
                      isActive: activeRowIndex == 2,
                      onTapValue: () {
                        setState(() {
                          if (activeRowIndex != 2) {
                            activeRowIndex = 2;
                            Input = val2Str;
                            display = val2Str;
                          }
                        });
                      },
                    ),

                    const Spacer(),

                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Exchange rates updated in real-time.",
                        style: TextStyle(
                          color: currentTheme.textColor.withOpacity(0.54),
                          fontSize: 12,
                        ),
                      ),
                    ),
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
                          icon: (Icons.backspace_outlined),
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
