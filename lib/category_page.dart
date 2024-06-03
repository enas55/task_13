import 'package:flutter/material.dart';
import 'package:task_13/add_items.dart';
import 'package:task_13/models/category_data.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({this.categories,super.key});
  final CategoryData? categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: const Color.fromARGB(255, 5, 98, 175),
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddItems(),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
