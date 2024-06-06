import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_13/drop_down_widget.dart';
import 'package:task_13/helpers/sql_helper.dart';
import 'package:task_13/models/products_data.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({this.product, super.key});
  final ProductsData? product;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController? nameTextEditingController;
  TextEditingController? describtionTextEditingController;
  TextEditingController? priceTextEditingController;
  TextEditingController? stockTextEditingController;
  TextEditingController? imageTextEditingController;
  var formKey = GlobalKey<FormState>();
  int? selectedCategoryId;
  bool? isAvailable;
  
  @override
  void initState() {
    nameTextEditingController =
        TextEditingController(text: widget.product?.name ?? '');
    describtionTextEditingController =
        TextEditingController(text: widget.product?.description ?? '');
    priceTextEditingController =
        TextEditingController(text: '${widget.product?.price ?? ''}');
    stockTextEditingController =
        TextEditingController(text: '${widget.product?.stock ?? ''}');
    imageTextEditingController =
        TextEditingController(text: widget.product?.image ?? '');
    selectedCategoryId = widget.product?.categoryId;
    isAvailable = widget.product?.isAvaliable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                getTextField(
                  label: 'Name',
                  controller: nameTextEditingController,
                ),
                const SizedBox(
                  height: 20,
                ),
                getTextField(
                  label: 'Description',
                  controller: describtionTextEditingController,
                ),
                const SizedBox(
                  height: 20,
                ),
                getTextField(
                  label: 'Img Url',
                  controller: imageTextEditingController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: getTextField(
                        label: 'Price',
                        controller: priceTextEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: getTextField(
                        label: 'Stock',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: stockTextEditingController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownCat(
                  selectedValue: selectedCategoryId,
                  onChanged: (value) {
                    selectedCategoryId = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('is Product Avaliable'),
                    const SizedBox(
                      width: 10,
                    ),
                    Switch(
                        value: isAvailable ?? false,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        }),
                    
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 5, 98, 175),
                        fixedSize: const Size(double.maxFinite, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          if (formKey.currentState!.validate()) {
                            var sqlHelper = GetIt.I.get<SqlHelper>();
                            ConflictAlgorithm.replace;
                            await sqlHelper.db!.insert(
                              'Categories',
                              {
                                'name': nameTextEditingController?.text,
                                'description':
                                    describtionTextEditingController?.text,
                              },
                            );
                            log(nameTextEditingController!.text);
                            log(describtionTextEditingController!.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  'Item added',
                                ),
                              ),
                            );
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('error : $e'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    try {
      if (formKey.currentState!.validate()) {
        var sqlHelper = GetIt.I.get<SqlHelper>();

        if (widget.product == null) {
          await sqlHelper.db!.insert(
              'products',
              conflictAlgorithm: ConflictAlgorithm.replace,
              {
                'name': nameTextEditingController?.text,
                'description': describtionTextEditingController?.text,
                'price':
                    double.parse(priceTextEditingController?.text ?? '0.0'),
                'stock': int.parse(stockTextEditingController?.text ?? '0'),
                'image': imageTextEditingController?.text,
                'categoryId': selectedCategoryId,
                'isAvaliable': isAvailable ?? false,
              });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              widget.product == null
                  ? 'Category added Successfully'
                  : 'Category Updated Successfully',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error : $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}

Widget getTextField({
  TextInputType? keyboardType,
  List<TextInputFormatter>? inputFormatters,
  required String label,
  required TextEditingController? controller,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: (value) {
      if (value!.isEmpty) {
        return 'This field is required';
      }
      return null;
    },
    controller: controller,
    decoration: InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    ),
  );
}
