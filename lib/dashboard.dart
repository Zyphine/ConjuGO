import 'package:conjugo/publish_activity.dart';
import 'package:flutter/material.dart';
import 'list_activity.dart';
import 'user_list.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.dashboard,
              size: 100.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Gérer les Publications',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
              ),
              onPressed: () {
                Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => const PublishArticlePage()));
              },
              child: const Text('Ajouter une Publication'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
              ),
              onPressed: () {
                Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) =>  const ListViewHomeLayout()));
              },
              child: const Text('Voir les Publications'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                maximumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
                minimumSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width * 0.8, 30,)),
              ),
              onPressed: () {
                Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) =>  const UserListPage()));
              },
              child: const Text('Voir les Utilisateurs'),
            ),

          ],
        ),
      ),
    );
  }
}
