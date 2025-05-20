import 'package:flutter/material.dart';
import '../../user/components/custom_top_curve.dart';
import '../components/edit_category_form.dart';
import '../models/category.dart';

class EditCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)?.settings.arguments as Category?;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTopCurve(label: "Editar Categoria"),
              SizedBox(height: 2),
              EditCategoryForm(category: category),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
