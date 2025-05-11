import 'package:flutter/material.dart';
import '../../user/components/custom_top_curve.dart';
import '../components/register_category_form.dart';

class RegisterCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Nova Categoria"),
              SizedBox(height: 2),
              RegisterFormCategory(),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
