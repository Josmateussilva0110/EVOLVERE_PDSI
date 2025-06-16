import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo ao EVOLVERE!',
              style: TextStyle(
                color: Colors.white,
                fontSize: math.max(
                  28.0,
                  MediaQuery.of(context).size.width * 0.08,
                ),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Seu guia para construir hábitos reais e duradouros.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: math.max(
                  16.0,
                  MediaQuery.of(context).size.width * 0.045,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildInfoSection(
              context: context,
              icon: Icons.track_changes,
              title: 'Acompanhe seu Progresso',
              description:
                  'Monitore seus hábitos diários e veja sua evolução de forma clara e intuitiva.',
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              context: context,
              icon: Icons.lightbulb_outline,
              title: 'Inspire-se e Motive-se',
              description:
                  'Receba dicas e insights para manter o foco e superar desafios.',
            ),
            const SizedBox(height: 20),
            _buildInfoSection(
              context: context,
              icon: Icons.emoji_events_outlined,
              title: 'Metas e Conquistas',
              description:
                  'Estabeleça objetivos claros e celebre cada conquista em sua jornada de transformação!',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Comece hoje mesmo sua jornada de transformação!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: math.max(
                    18.0,
                    MediaQuery.of(context).size.width * 0.055,
                  ),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Entendi!',
                  style: TextStyle(
                    fontSize: math.max(
                      16.0,
                      MediaQuery.of(context).size.width * 0.045,
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(
        math.max(16.0, MediaQuery.of(context).size.width * 0.04),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(
              math.max(10.0, MediaQuery.of(context).size.width * 0.025),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: math.max(24.0, MediaQuery.of(context).size.width * 0.07),
            ),
          ),
          SizedBox(
            width: math.max(12.0, MediaQuery.of(context).size.width * 0.03),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: math.max(
                      16.0,
                      MediaQuery.of(context).size.width * 0.048,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: math.max(
                      12.0,
                      MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
