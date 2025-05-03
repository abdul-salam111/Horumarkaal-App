import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String language;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color? color;


  const LanguageButton({super.key, 
    required this.language,
    required this.isSelected,
    required this.onPressed,
   required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(

      onPressed: onPressed,
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: color!)),
        backgroundColor:
            isSelected ? WidgetStateProperty.all(Colors.blue) : null,
      ),
      child: Text(language,style: TextStyle(color: color),),
    );
  }
}
