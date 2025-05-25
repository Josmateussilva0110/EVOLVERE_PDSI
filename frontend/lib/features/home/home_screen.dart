import 'package:flutter/material.dart';
import 'package:front/features/home/tela_perfil.dart';
import 'package:front/features/listHabits/pages/habits_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showDrawer = false;

  void _toggleDrawer() {
    setState(() {
      _showDrawer = !_showDrawer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Olá, Gabriel (Jesus)',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle, color: Colors.white),
                        onPressed: _toggleDrawer,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _statCard('Sequência Diária', '3', height: 100, topPadding: 21)),
                      SizedBox(width: 15),
                      Expanded(child: _statCard('Hábitos Completados', '6')),
                    ],
                  ),
                  SizedBox(height: 10),
                  _statCard('Pontuação Total', '246', width: double.infinity),
                  SizedBox(height: 10),
                  Text('Progresso Diário', style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: 6 / 8,
                    color: Colors.white,
                    backgroundColor: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Text('6 de 8 hábitos completados', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hoje', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamed(context, '/cadastrar_habito',);
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  _habitTile('Exercício Matinal', Icons.directions_run, Colors.red),
                  _habitTile('Ler 30 Minutos', Icons.menu_book, Colors.lightBlue),
                  _habitTile('Meditar', Icons.favorite, Color.fromARGB(255, 251, 192, 45)),
                ],
              ),
            ),
          ),
          if (_showDrawer)
            GestureDetector(
              onTap: _toggleDrawer,
              child: Container(
                color: Colors.black54,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 280,
                    margin: EdgeInsets.only(top: 80, right: 10),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Gabriel (Jesus)', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        Divider(color: Colors.white24),
                        _drawerItem(Icons.person, 'Conta', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TelaPerfil()));
                        }),
                        _drawerItem(Icons.category, 'Categorias', () {
                            //tela não criada
                        }),
                        
                        _drawerItem(Icons.check_box, 'Hábitos', () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => HabitsListPage()));
                        }),
                        _drawerItem(Icons.settings, 'Configurações', () {
                          //tela não criada
                        }),
                        _drawerItem(Icons.person, 'Sair', () {
                          Navigator.pushNamed(context, '/',);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900], // tom de cinza escuro como no exemplo enviado
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Relatórios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notificações',
            ),
          ],
      ),

    );
  }

  Widget _statCard(String title, String value, {double width = 160, double? height, double topPadding = 0}) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white70)),
          SizedBox(height: topPadding),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _habitTile(String title, IconData icon, Color iconColor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 10),
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        _toggleDrawer();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}