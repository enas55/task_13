import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_13/add_product.dart';
import 'package:task_13/helpers/sql_helper.dart';
import 'package:task_13/models/products_data.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({this.product, super.key});
  final ProductsData? product;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<ProductsData> products = [];
  @override
  void initState() {
    getProducts();
    super.initState();
  }

  void getProducts() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.rawQuery("""
  Select P.*,C.name as categoryName,C.description as categoryDescription from products P
  Inner JOIN categories C
  On P.categoryId = C.id
  """);

      if (data.isNotEmpty) {
        products = [];
        for (var item in data) {
          products.add(ProductsData.fromJson(item));
        }
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
      log('Error : $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 98, 175),
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddProduct(),
                ),
              );
              if (res ?? false) {
                getProducts();
              }
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text('No data'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var result = products[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(result.name!),
                      subtitle: Text(result.description!),
                    ),
                    Text(result.price.toString()),
                    Text(result.stock.toString()),
                    Text(result.image.toString()),
                    Text(result.categoryId.toString()),
                    Text(result.categoryName.toString()),
                    Text(result.categoryDescription.toString()),
                  ],
                );
              },
            ),
    );
  }
}
