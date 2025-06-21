import 'package:flutter/material.dart';
import 'reset_password_screen.dart';
import '../service/login_service.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String token;

    const VerifyCodeScreen({
    Key? key,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyCode() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Digite o código enviado por email')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.verifyRecoveryCode(widget.token, code);

    setState(() => _isLoading = false);

    if (result['success']) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => ResetPasswordScreen(token: widget.token,),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verificar Código')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Digite o código enviado para ${widget.email}'),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Código de 4 dígitos',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleVerifyCode,
              child:
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}
