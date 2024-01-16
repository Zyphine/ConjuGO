import 'package:conjugo/publishActivity.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
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
              'Manage Publications',
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
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('View Publications'),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add your navigation logic or actions here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Add Publication'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
