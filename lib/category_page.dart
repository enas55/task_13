import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_13/add_items.dart';
import 'package:task_13/helpers/sql_helper.dart';
import 'package:task_13/models/category_data.dart';
import 'package:task_13/products_page.dart';

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
          CategoryData.fromJson(item),
        );
      }
    } catch (e) {
      log("Error : $e");
    }
    setState(() {});
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
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const AddItems(),
                  ),
                );
                if (res ?? false) {
                  getInfo();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            cat.isEmpty
                ? const Center(child :Text('No data'))
                : ListView.builder(
                    itemCount: cat.length,
                    itemBuilder: (context, index) {
                      var result = cat[index];
                      return ListTile(
                        title: Text(result.name!),
                        subtitle:
                            Text(result.description!),
                      );
                    }),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return const ProductsPage();
                      },
                    ),
                  );
                },
                child: const Text('Products Page'))
          ],
        ));
  }
}
