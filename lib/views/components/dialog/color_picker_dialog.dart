import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  final List<Color> colors;

  const ColorPickerDialog({super.key, this.colors = Colors.primaries});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a Color"),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              colors.map((color) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, color),
                  child: CircleAvatar(backgroundColor: color, radius: 18),
                );
              }).toList(),
        ),
      ),
    );
  }
}
