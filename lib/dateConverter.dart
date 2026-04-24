import 'package:flutter/material.dart';
import 'theme_data.dart';

class DateConverterScreen extends StatefulWidget {
  const DateConverterScreen({super.key});

  @override
  State<DateConverterScreen> createState() => _DateConverterScreenState();
}

class _DateConverterScreenState extends State<DateConverterScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  int activeRowIndex = 0; // 0 for 'From', 1 for 'To'

  String formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${d.day} ${months[d.month - 1]} ${d.year}";
  }

  void _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE87F24), // mainColor
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
          activeRowIndex = 0;
        } else {
          toDate = picked;
          activeRowIndex = 1;
        }
      });
    }
  }

  Map<String, int> _calculateDifference() {
    DateTime start = fromDate;
    DateTime end = toDate;

    if (start.isAfter(end)) {
      start = toDate;
      end = fromDate;
    }

    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;

    if (days < 0) {
      months--;
      final previousMonth = DateTime(end.year, end.month, 0);
      days += previousMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    return {"years": years, "months": months, "days": days};
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int mainColor = currentTheme.actionButtonColor.value; // Orange

    Map<String, int> diff = _calculateDifference();

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
                        'Date',
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

              // Date Selectors
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "From",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.textColor,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  formatDate(fromDate),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: activeRowIndex == 0
                                        ? Color(mainColor)
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.unfold_more,
                                  color: currentTheme.textColor.withOpacity(
                                    0.54,
                                  ),
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "To",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: currentTheme.textColor,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  formatDate(toDate),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: activeRowIndex == 1
                                        ? Color(mainColor)
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.unfold_more,
                                  color: currentTheme.textColor.withOpacity(
                                    0.54,
                                  ),
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Difference Card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white, // Contrasting the cream background
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Text(
                          "Difference",
                          style: TextStyle(
                            color: Color(mainColor),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Years",
                                  style: TextStyle(
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${diff['years']}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Months",
                                  style: TextStyle(
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${diff['months']}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Days",
                                  style: TextStyle(
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${diff['days']}",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "From",
                                  style: TextStyle(
                                    color: Color(mainColor),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatDate(fromDate),
                                  style: TextStyle(
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "To",
                                  style: TextStyle(
                                    color: Color(mainColor),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatDate(toDate),
                                  style: TextStyle(
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
                                    fontSize: 14,
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
            ],
          ),
        ),
      ),
    );
  }
}
