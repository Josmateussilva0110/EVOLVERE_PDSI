import 'dart:io';
import 'package:flutter/material.dart';


class IconPicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPickImage;

  const IconPicker({
    super.key,
    required this.image,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ícone',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: onPickImage,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: const Color(0xFF2C2C2C),
              backgroundImage: image != null ? FileImage(image!) : null,
              child: image == null
                  ? const Icon(
                      Icons.add_a_photo,
                      size: 28,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
