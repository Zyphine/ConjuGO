import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PublishArticlePage extends StatefulWidget {
  const PublishArticlePage({Key? key}) : super(key: key);

  @override
  _PublishArticlePageState createState() => _PublishArticlePageState();
}

class _PublishArticlePageState extends State<PublishArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une publication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  //On transforme la date au format souhaité
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    _dateController.text = formattedDate;
                  } //else {
                  //  print("Vous n'avez pas sélectionné de date");
                  //}
                }),
            const SizedBox(height: 10),
            TextField(
              controller: _placeController,
              decoration: const InputDecoration(labelText: 'Lieu'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberController,
              decoration: const InputDecoration(labelText: 'Nombre de places'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onSubmit();
              },
              child: const Text('Publier'),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    // Retrieve values from text controllers
    String title = _titleController.text;
    String description = _descriptionController.text;
    String date = _dateController.text;
    String place = _placeController.text;

    // Perform actions with the article data
    // For example, you can send the data to an API or perform other actions.
    
    // Reset text controllers after submission (optional)
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
    _placeController.clear();

    // Optionally, you can navigate to another page or show a success message
    // Navigator.push(context, MaterialPageRoute(builder: (context) => NextPage()));
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Article published successfully')));
  }
}

// To use this page, you can call it from another widget like a button press:

// ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => PublishArticlePage()),
//     );
//   },
//   child: Text('Open Publish Article Page'),
// )
