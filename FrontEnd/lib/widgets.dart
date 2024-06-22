import 'package:flutter/material.dart';

class ColorChangeButton extends StatefulWidget {
  final String text;
  final Color color;
  final Function onTap;

  const ColorChangeButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  _ColorChangeButtonState createState() => _ColorChangeButtonState();
}

class _ColorChangeButtonState extends State<ColorChangeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        width: 175,
        height: 105,
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey.withOpacity(0.6) : widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isPressed ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
