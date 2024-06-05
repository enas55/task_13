import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_13/add_items.dart';
import 'package:task_13/helpers/sql_helper.dart';
import 'package:task_13/models/category_data.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    this.categories,
    super.key,
  });
  final CategoryData? categories;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    getData();
    getInfo();
    super.initState();
  }

  Future<void> getData() async {
    await GetIt.I.get<SqlHelper>().createTables();
  }

  Future<void> getInfo() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      final results = await sqlHelper.db!.query('Categories');
      List<CategoryData> cat = [];
      for (var item in results) {
        cat.add(
          CategoryData.fromJson(
            {
              'name': item['name'],
              'description': item['description'],
            },
          ),
        );
      }
      setState(() {});
    } catch (e) {
      log("Error : $e");
    }
  }

  List<CategoryData> cat = [];

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
        body: cat.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: cat.length,
                itemBuilder: (context, index) {
                  var result = cat[index];
                  return ListTile(
                    title: Text(result.name ?? 'No name found'),
                    subtitle:
                        Text(result.description ?? 'No description found'),
                  );
                }));
  }
}
