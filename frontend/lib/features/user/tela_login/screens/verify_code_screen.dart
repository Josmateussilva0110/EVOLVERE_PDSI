import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
  String code = '';
  bool _isLoading = false;
  bool _isResending = false;
  late Timer _timer;
  int _secondsRemaining = 120; 

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> _handleVerifyCode() async {
    if (code.length != 4) {
      _showSnackbar('Digite o código de 4 dígitos');
      return;
    }

    if (_secondsRemaining == 0) {
      _showSnackbar('O código expirou. Solicite um novo.');
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.verifyRecoveryCode(widget.token, code);

    setState(() => _isLoading = false);

    if (result['success']) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(token: widget.token),
        ),
      );
    } else {
      _showSnackbar(result['message'], isError: true);
    }
  }

  Future<void> _handleResendCode() async {
    setState(() => _isResending = true);

    final result = await AuthService.sendRecoveryEmail(widget.email);

    setState(() => _isResending = false);

    if (result['success']) {
      _showSnackbar('Novo código enviado para seu e-mail');
      _startTimer();
    } else {
      _showSnackbar(result['message'], isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Código'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Digite o código enviado para:',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            widget.email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),

          /// Cronômetro
          Column(
            children: [
              Text(
                _secondsRemaining > 0
                    ? 'O código expira em:'
                    : 'O código expirou',
                style: TextStyle(
                  color: _secondsRemaining == 0
                      ? Colors.red
                      : (_secondsRemaining <= 30 ? Colors.red : Colors.black),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _secondsRemaining > 0 ? _formatTime(_secondsRemaining) : '--:--',
                style: TextStyle(
                  fontSize: 32,
                  color: _secondsRemaining == 0
                      ? Colors.red
                      : (_secondsRemaining <= 30 ? Colors.red : Colors.blue),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),


          const SizedBox(height: 20),

          /// Input de código
          PinCodeTextField(
            appContext: context,
            length: 4,
            onChanged: (value) {
              setState(() {
                code = value;
              });
            },
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 60,
              fieldWidth: 50,
              activeFillColor: Colors.white,
              selectedColor: Colors.blue,
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
            ),
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: false,
          ),

          const SizedBox(height: 24),

          /// Botão Verificar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: (_isLoading || _secondsRemaining == 0)
                ? null
                : _handleVerifyCode,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Verificar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
          ),

          const SizedBox(height: 12),

          /// Botão Reenviar código
          if (_secondsRemaining == 0) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: _isResending ? null : _handleResendCode,
              child: _isResending
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Reenviar código',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
