import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        // Proporções relativas
        double titleFontSize = screenWidth * 0.1;
        double subtitleFontSize = screenWidth * 0.025;
        double logoHeight = screenWidth * 0.25;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Image.asset(
                  'assets/images/initial/logo.png',
                  height: logoHeight,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: screenWidth * 0.09),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EVOLVERE',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Transforme sua rotina com propósito.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
