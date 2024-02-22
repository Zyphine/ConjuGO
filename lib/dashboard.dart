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
        title: const Text('Publication Dashboard'),
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
              onPressed: () {
                Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => const PublishArticlePage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Ajouter une Publication'),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) =>  const ListViewHomeLayout()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Voir les Publications'),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) =>  const UserListPage()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Voir les Utilisateurs'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
