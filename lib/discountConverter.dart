import 'package:flutter/material.dart';
import 'theme_data.dart';

class DiscountConverterScreen extends StatefulWidget {
  const DiscountConverterScreen({super.key});

  @override
  State<DiscountConverterScreen> createState() =>
      _DiscountConverterScreenState();
}

class _DiscountConverterScreenState extends State<DiscountConverterScreen> {
  // Logic Variables
  String originalPriceStr = "100";
  String discountStr = "10";
  int activeRowIndex = 0; // 0 for Original Price, 1 for Discount

  void _buttonPressed(String buttonText) {
    String currentInput = activeRowIndex == 0 ? originalPriceStr : discountStr;

    if (buttonText == "C") {
      currentInput = "0";
    } else if (buttonText == "DEL") {
      if (currentInput.length > 1) {
        currentInput = currentInput.substring(0, currentInput.length - 1);
      } else {
        currentInput = "0";
      }
    } else if (buttonText == ".") {
      if (!currentInput.contains(".")) {
        currentInput = currentInput + buttonText;
      }
    } else {
      if (currentInput == "0") {
        currentInput = buttonText;
      } else {
        currentInput = currentInput + buttonText;
      }
    }

    setState(() {
      if (activeRowIndex == 0) {
        originalPriceStr = currentInput;
      } else {
        discountStr = currentInput;
      }
    });
  }

  Widget _buildDiscountRow(
    String title,
    String valueStr, {
    bool isActive = false,
    VoidCallback? onTapValue,
  }) {
    return GestureDetector(
      onTap: onTapValue,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: currentTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
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

    // Calculations
    double originalPrice = double.tryParse(originalPriceStr) ?? 0;
    double discount = double.tryParse(discountStr) ?? 0;

    double saveAmt = originalPrice * (discount / 100);
    double finalPrice = originalPrice - saveAmt;

    String formatStr(double val) {
      String s = val.toStringAsFixed(2);
      if (s.contains('.')) {
        s = s.replaceAll(RegExp(r'0*$'), '');
        if (s.endsWith('.')) s = s.substring(0, s.length - 1);
      }
      return s;
    }

    String finalPriceStr = formatStr(finalPrice);
    String saveAmtStr = formatStr(saveAmt);

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
                        'Discount',
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

              // Rows
              Expanded(
                child: Column(
                  children: [
                    _buildDiscountRow(
                      "Original price",
                      originalPriceStr,
                      isActive: activeRowIndex == 0,
                      onTapValue: () {
                        setState(() {
                          activeRowIndex = 0;
                        });
                      },
                    ),
                    _buildDiscountRow(
                      "Discount (%)",
                      discountStr,
                      isActive: activeRowIndex == 1,
                      onTapValue: () {
                        setState(() {
                          activeRowIndex = 1;
                        });
                      },
                    ),
                    _buildDiscountRow(
                      "Final price",
                      finalPriceStr,
                      isActive: false,
                    ),
                  ],
                ),
              ),

              // You Save Text
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "You save $saveAmtStr",
                  style: TextStyle(
                    color: currentTheme.textColor.withOpacity(0.54),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
                    // Col 4 (C [Tall], DEL [Tall])
                    Column(
                      children: [
                        _buildKeypadButton(
                          "C",
                          screenWidth,
                          screenHeight,
                          mainColor,
                          customHeight: (screenHeight * 0.075 * 2) + 10,
                        ),
                        const SizedBox(height: 10),
                        _buildKeypadButton(
                          "DEL",
                          screenWidth,
                          screenHeight,
                          mainColor,
                          icon: Icons.backspace_outlined,
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
