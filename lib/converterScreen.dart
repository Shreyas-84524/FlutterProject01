import 'package:flutter/material.dart';
import 'settingsScreen.dart';
import 'theme_data.dart';
import 'currencyConverter.dart';
import 'lengthConverter.dart';
import 'massConverter.dart';
import 'areaConverter.dart';
import 'dataConverter.dart';
import 'timeConverter.dart';
import 'dateConverter.dart';
import 'speedConverter.dart';
import 'temperatureConverter.dart';
import 'discountConverter.dart';
import 'financeConverter.dart';
import 'volumeConverter.dart';

class converterScreen extends StatefulWidget {
  const converterScreen({super.key});

  @override
  State<converterScreen> createState() => _converterScreenState();
}

class _converterScreenState extends State<converterScreen> {
  Widget _buildGridItem(
    String title,
    IconData icon,
    int bgColor, {
    Widget? destination,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              if (destination != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(bgColor),
              foregroundColor: currentTheme.textColor, // adapt to theme
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: Icon(icon, size: 32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: currentTheme.textColor, // adapt to theme
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int buttonColor = currentTheme.numberButtonColor.value;
    int mainColor = currentTheme.actionButtonColor.value;

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
                    vertical:
                        screenHeight * 0.05, // Adjusted to pad top area nicely
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Also act as 'go back'
                            },
                            child: Column(
                              children: [
                                Text(
                                  'CALCULATOR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: currentTheme.textColor.withOpacity(
                                      0.54,
                                    ),
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
                          const SizedBox(width: 30),
                          Column(
                            children: [
                              Text(
                                'CONVERTER',
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
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildGridItem(
                        'Currency',
                        Icons.currency_exchange,
                        buttonColor,
                        destination: const CurrencyConverterScreen(),
                      ),
                      _buildGridItem(
                        'Length',
                        Icons.straighten,
                        buttonColor,
                        destination: const LengthConverterScreen(),
                      ),
                      _buildGridItem(
                        'Mass',
                        Icons.monitor_weight,
                        buttonColor,
                        destination: const MassConverterScreen(),
                      ),
                      _buildGridItem(
                        'Area',
                        Icons.square_foot,
                        buttonColor,
                        destination: const AreaConverterScreen(),
                      ),
                      _buildGridItem(
                        'Time',
                        Icons.access_time,
                        buttonColor,
                        destination: const TimeConverterScreen(),
                      ),
                      _buildGridItem(
                        'Finance',
                        Icons.account_balance_wallet,
                        buttonColor,
                        destination: const FinanceConverterScreen(),
                      ),
                      _buildGridItem(
                        'Data',
                        Icons.data_usage,
                        buttonColor,
                        destination: const DataConverterScreen(),
                      ),
                      _buildGridItem(
                        'Date',
                        Icons.calendar_today,
                        buttonColor,
                        destination: const DateConverterScreen(),
                      ),
                      _buildGridItem(
                        'Discount',
                        Icons.local_offer,
                        buttonColor,
                        destination: const DiscountConverterScreen(),
                      ),
                      _buildGridItem(
                        'Volume',
                        Icons.view_in_ar,
                        buttonColor,
                        destination: const VolumeConverterScreen(),
                      ),

                      _buildGridItem(
                        'Speed',
                        Icons.speed,
                        buttonColor,
                        destination: const SpeedConverterScreen(),
                      ),
                      _buildGridItem(
                        'Temperature',
                        Icons.thermostat,
                        buttonColor,
                        destination: const TemperatureConverterScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
