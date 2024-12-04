import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Choose Theme Color"),
              trailing: Icon(Icons.color_lens),
              onTap: () {
                showColorPicker(context); // Show color picker on tap
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show color picker dialog
  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Theme Color"),
          content: SingleChildScrollView(
            child: ColorPickerWidget(),
          ),
        );
      },
    );
  }
}

class ColorPickerWidget extends StatelessWidget {
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
  ];

   ColorPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Update theme color when a color is selected
            Provider.of<ThemeNotifier>(context, listen: false)
                .updateThemeColor(colors[index]);
            Navigator.pop(context); // Close the color picker dialog
          },
          child: Container(
            margin: EdgeInsets.all(8.0),
            color: colors[index], // Display color swatches
          ),
        );
      },
    );
  }
}
