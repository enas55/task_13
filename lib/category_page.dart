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
    getInfo ();
    super.initState();
  }

  Future<void> getData() async {
  GetIt.I.get<SqlHelper>().createTables();
  }

  Future<void> getInfo () async{
    var sqlHelper = GetIt.I.get<SqlHelper>();
    await sqlHelper.db!.query('Categories');
    setState(() {
    });
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
      body: ListView.builder(
        itemCount: cat.length,
        itemBuilder: (context, index) {
        var result = cat[index];
        return ListTile(
          title: Text(result.name ?? 'No name found'),
          subtitle: Text(result.description ?? 'No description found'),
        );
      })
    );
  }
}
