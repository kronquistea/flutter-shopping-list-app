import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/data/dummy_items.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
        ),
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ColoredBox(
                color: groceryItems[index].category.boxColor,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                ),
              ),
              title: Text(
                groceryItems[index].name,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Text(
                groceryItems[index].quantity.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
