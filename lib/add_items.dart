import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_13/helpers/sql_helper.dart';
import 'package:task_13/models/category_data.dart';

class AddItems extends StatefulWidget {
  const AddItems({this.categories, super.key});
  final CategoryData? categories;

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var keyItem = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 5, 98, 175),
        title: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: keyItem,
          child: Column(
            children: [
              getTextField(
                controller: nameController,
                label: 'Name',
              ),
              const SizedBox(
                height: 20,
              ),
              getTextField(
                controller: descriptionController,
                label: 'Description',
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
                    if (keyItem.currentState != null) {
                      var sqlHelper = GetIt.I.get<SqlHelper>();
                      await sqlHelper.db!.insert(
                        'Categories',
                        {
                          'name': nameController.text,
                          'description': descriptionController.text,
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            'Item added',
                          ),
                        ),
                      );
                      Navigator.pop(context);
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
    );
  }
}

Widget getTextField({
  required String label,
  required TextEditingController? controller,
}) {
  return TextFormField(
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
