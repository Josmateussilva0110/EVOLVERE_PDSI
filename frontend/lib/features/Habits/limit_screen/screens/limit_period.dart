import 'package:flutter/material.dart';
import '../../components/habits_app_bar.dart';
import '../../components/app_header.dart';
import '../../components/navigation.dart';
import '../components/limit_period_form.dart';

class TelaPrazo extends StatefulWidget {
  @override
  _TelaPrazoState createState() => _TelaPrazoState();
}

class _TelaPrazoState extends State<TelaPrazo> {
  bool dataAlvoEnabled = false;
  String prioridade = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121217),
      appBar: HeaderAppBar(title: 'Definir Prazo'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Appbody(title: 'Quando você quer fazer isso ?'),
                  SizedBox(height: 24),
                  LimitPeriodForm(
                    dataAlvoEnabled: dataAlvoEnabled,
                    onDataAlvoChanged: (value) {
                      setState(() {
                        dataAlvoEnabled = value;
                      });
                    },
                    prioridade: prioridade,
                    onSelecionarDataInicio: () {
                      // lógica da data de início
                    },
                    onSelecionarLembretes: () {
                      // lógica dos lembretes
                    },
                    onSelecionarPrioridade: () {
                      // lógica da prioridade
                    },
                  ),
                ],
              ),
            ),
          ),
          FrequencyBottomNavigation(
            onPrevious:
                () => Navigator.pushReplacementNamed(
                  context,
                  '/cadastrar_frequencia',
                ),
            onNext: () => Navigator.pushReplacementNamed(context, '/'),
            previousLabel: 'Anterior',
            nextLabel: 'Criar Hábito',
            currentIndex: 2,
          ),
        ],
      ),
    );
  }
}
