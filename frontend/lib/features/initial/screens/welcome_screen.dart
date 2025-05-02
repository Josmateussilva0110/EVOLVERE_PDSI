import 'package:flutter/material.dart';
//import '../widgets/logo_header.dart';
import '../widgets/welcome_buttons.dart';
//import '../widgets/welcome_footer.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171D), // cor escura de fundo
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                //LogoHeader(),
                SizedBox(height: 30),
                Text(
                  'BEM VINDO(A)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                WelcomeButtons(),
                SizedBox(height: 30),
                //WelcomeFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
