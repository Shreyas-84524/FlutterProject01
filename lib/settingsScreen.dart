import 'package:flutter/material.dart';
import 'theme_data.dart';

class settingsScreen extends StatefulWidget {
  const settingsScreen({super.key});

  @override
  State<settingsScreen> createState() => _settingsScreenState();
}

class _settingsScreenState extends State<settingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.mainBackground,
      appBar: AppBar(
        title: Text(
          'Themes',
          style: TextStyle(
            color: currentTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: currentTheme.secondaryBackground,
        iconTheme: IconThemeData(color: currentTheme.textColor),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Select Palette',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: currentTheme.textColor,
            ),
          ),
          const SizedBox(height: 10),
          ...appThemes.map((theme) {
            return RadioListTile<AppTheme>(
              title: Text(
                theme.name,
                style: TextStyle(
                  color: currentTheme.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: theme,
              groupValue: currentTheme,
              activeColor: currentTheme.actionButtonColor,
              onChanged: (AppTheme? value) {
                if (value != null) {
                  setState(() {
                    currentTheme = value;
                  });
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
