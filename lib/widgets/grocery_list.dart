import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/models/grocery_item.dart';
import 'package:flutter_shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No groceries found. Start adding some!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (_groceryItems.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(
            _groceryItems[index].name,
            style: const TextStyle(fontSize: 16),
          ),
          leading: Container(
            width: 24,
            height: 24,
            color: _groceryItems[index].category.color,
          ),
          trailing: Text(
            _groceryItems[index].quantity.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: mainContent,
    );
  }
}
