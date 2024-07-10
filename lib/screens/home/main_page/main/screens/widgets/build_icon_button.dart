import 'package:flutter/material.dart';

Container buildIconButton(IconData icon, VoidCallback onPressed) {
  return Container(
    margin: const EdgeInsets.all(10),
    height: 35,
    width: 35,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
    ),
    child: IconButton(
      icon: Icon(
        icon,
        size: 18,
        color: Colors.black,
      ),
      onPressed: onPressed,
    ),
  );
}
