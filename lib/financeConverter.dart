import 'package:flutter/material.dart';
import 'theme_data.dart';
import 'dart:math';

class FinanceConverterScreen extends StatefulWidget {
  const FinanceConverterScreen({super.key});

  @override
  State<FinanceConverterScreen> createState() => _FinanceConverterScreenState();
}

class _FinanceConverterScreenState extends State<FinanceConverterScreen> {
  bool isLoan = true;
  TextEditingController principalController = TextEditingController();
  TextEditingController interestController = TextEditingController(
    text: "4.85",
  );
  int years = 1;
  int months = 0;

  void _selectDuration() {
    showDialog(
      context: context,
      builder: (context) {
        int tempYears = years;
        int tempMonths = months;
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              backgroundColor: currentTheme.secondaryBackground,
              title: Text(
                "Duration",
                style: TextStyle(
                  color: currentTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Years",
                        style: TextStyle(
                          color: currentTheme.textColor,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (tempYears > 0) setStateSB(() => tempYears--);
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Color(0xFFE87F24),
                            ),
                          ),
                          Text(
                            "$tempYears",
                            style: TextStyle(
                              color: currentTheme.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setStateSB(() => tempYears++),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFE87F24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Months",
                        style: TextStyle(
                          color: currentTheme.textColor,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (tempMonths > 0)
                                setStateSB(() => tempMonths--);
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Color(0xFFE87F24),
                            ),
                          ),
                          Text(
                            "$tempMonths",
                            style: TextStyle(
                              color: currentTheme.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (tempMonths < 11)
                                setStateSB(() => tempMonths++);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFFE87F24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      years = tempYears;
                      months = tempMonths;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Color(0xFFE87F24),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _calculate() {
    double principal = double.tryParse(principalController.text) ?? 0;
    double interestRate = double.tryParse(interestController.text) ?? 0;
    int totalMonths = (years * 12) + months;

    if (principal <= 0 || totalMonths <= 0) return;

    double result1 = 0;
    double result2 = 0;
    String label1 = "";
    String label2 = "";

    if (isLoan) {
      // EMI Calculation
      double r = interestRate / 12 / 100;
      double emi =
          principal *
          r *
          pow(1 + r, totalMonths) /
          (pow(1 + r, totalMonths) - 1);
      double totalPayment = emi * totalMonths;
      double totalInterest = totalPayment - principal;

      label1 = "Monthly EMI";
      result1 = emi;
      label2 = "Total Interest";
      result2 = totalInterest;
    } else {
      // Simple Compound Investment Calculation (compounded annually for simplicity)
      double r = interestRate / 100;
      double totalYears = totalMonths / 12.0;
      double amount = principal * pow(1 + r, totalYears);
      double totalInterest = amount - principal;

      label1 = "Total Balance";
      result1 = amount;
      label2 = "Total Interest Earned";
      result2 = totalInterest;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: currentTheme.secondaryBackground,
          title: Text(
            isLoan ? "Loan Details" : "Investment Details",
            style: TextStyle(
              color: currentTheme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  color: currentTheme.textColor.withOpacity(0.54),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                result1.toStringAsFixed(2),
                style: TextStyle(
                  color: currentTheme.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                label2,
                style: TextStyle(
                  color: currentTheme.textColor.withOpacity(0.54),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                result2.toStringAsFixed(2),
                style: TextStyle(
                  color: currentTheme.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CLOSE",
                style: TextStyle(
                  color: Color(0xFFE87F24),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int mainColor = currentTheme.actionButtonColor.value; // Orange

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Finance',
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

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Principal",
                          style: TextStyle(
                            color: currentTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: principalController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: currentTheme.textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter amount",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 24,
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFE87F24),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Toggle Buttons (Loan vs Investment)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLoan = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isLoan
                                          ? Color(mainColor)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Loan",
                                        style: TextStyle(
                                          color: isLoan
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLoan = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !isLoan
                                          ? Color(mainColor)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Investment",
                                        style: TextStyle(
                                          color: !isLoan
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Interest Rate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Interest rate (%)",
                              style: TextStyle(
                                color: currentTheme.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: interestController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: currentTheme.textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),

                        // Duration
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Duration",
                              style: TextStyle(
                                color: currentTheme.textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: _selectDuration,
                              child: Row(
                                children: [
                                  Text(
                                    "$years year and $months months",
                                    style: TextStyle(
                                      color: currentTheme.textColor.withOpacity(
                                        0.54,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Calculate Button
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  bottom: screenHeight * 0.03,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Calculate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
