import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_13/helpers/sql_helper.dart';
import 'package:task_13/models/category_data.dart';

class DropDownCat extends StatefulWidget {
  const DropDownCat(
      {required this.onChanged, this.selectedValue, super.key});
  final int? selectedValue;
  final void Function(int?)? onChanged;

  @override
  State<DropDownCat> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<DropDownCat> {
  List<CategoryData>? categories;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('Categories');

      if (data.isNotEmpty) {
        categories = [];
        for (var item in data) {
          categories?.add(CategoryData.fromJson(item));
        }
      } else {
        categories = [];
      }
    } catch (e) {
      categories = [];
      log('Error in get Categories $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return categories == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (categories?.isEmpty ?? false)
            ? const Center(
                child: Text('No Categories'),
              )
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: DropdownButton(
                            value: widget.selectedValue,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text('Select Category'),
                            items: [
                              for (var category in categories!)
                                DropdownMenuItem(
                                  value: category.id,
                                  child: Text(category.name ?? 'No Name'),
                                ),
                            ],
                            onChanged: widget.onChanged),
                      ),
                    ),
                  ),
                ],
              );
  }
}
