import 'package:flutter/material.dart';

void main() {
  runApp(const FilloraApp());
}

class FilloraApp extends StatelessWidget {
  const FilloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fillora.in - AI Form Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Fillora.in'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.document_scanner,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Fillora.in',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The AI Form Assistant',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.upload_file, color: Colors.green),
                      title: Text('Document Upload'),
                      subtitle: Text('Scan and upload your documents'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.chat, color: Colors.orange),
                      title: Text('AI Assistant'),
                      subtitle: Text('Get help filling your forms'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.language, color: Colors.purple),
                      title: Text('Multilingual Support'),
                      subtitle: Text('Available in 4 languages'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feature coming soon!')),
          );
        },
        tooltip: 'Start Form Assistant',
        child: const Icon(Icons.add),
      ),
    );
  }
}