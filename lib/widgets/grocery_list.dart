import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/data/categories.dart';
import 'package:flutter_shopping_list_app/models/grocery_item.dart';
import 'package:flutter_shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-shopping-list-ap-aa48b-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    final Map<String, dynamic> listData = jsonDecode(
      response.body,
    );
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (categoryItem) =>
                categoryItem.value.title == item.value['category'],
          )
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
      isLoading = false;
    });
  }

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

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
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

    if (isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
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
