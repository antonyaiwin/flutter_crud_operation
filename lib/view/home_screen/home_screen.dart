import 'package:flutter/material.dart';
import 'package:flutter_crud_operation/controller/home_screen_controller.dart';
import 'package:flutter_crud_operation/model/employee_api_response_model.dart';
import 'package:provider/provider.dart';

import '../../controller/home_bottom_sheet_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<HomeScreenController>().getEmployees();
      },
    );
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: context.read<HomeScreenController>().formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller:
                        context.read<HomeScreenController>().nameController,
                    decoration:
                        const InputDecoration(hintText: 'Employee name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: context
                        .read<HomeScreenController>()
                        .designationController,
                    decoration: const InputDecoration(hintText: 'Designation'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter designation';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (context
                          .read<HomeScreenController>()
                          .formKey
                          .currentState!
                          .validate()) {
                        context.read<HomeScreenController>().addEmployee();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeScreenController>().getEmployees();
                    },
                    child: const Text('Refresh'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<HomeScreenController>(
                builder: (context, value, child) {
                  if (value.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (value.employees.isEmpty) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<HomeScreenController>().getEmployees();
                    },
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Color.fromARGB(255, 143, 203, 174),
                          title: Text(value.employees[index].name),
                          subtitle: Text(value.employees[index].role),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _editClicked(context, value.employees[index]);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  value.deleteEmployee(
                                      value.employees[index].id);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: value.employees.length,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _editClicked(BuildContext context, Employee employee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangeNotifierProvider<HomeBottomSheetController>(
        create: (BuildContext context) {
          return HomeBottomSheetController(employee: employee);
        },
        child: Builder(builder: (context) {
          return Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: context.read<HomeBottomSheetController>().formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: context
                            .read<HomeBottomSheetController>()
                            .nameController,
                        decoration:
                            const InputDecoration(hintText: 'Employee name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: context
                            .read<HomeBottomSheetController>()
                            .designationController,
                        decoration:
                            const InputDecoration(hintText: 'Designation'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter designation';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<HomeBottomSheetController>(
                        builder: (context, value, child) {
                          return ElevatedButton(
                            onPressed: value.isLoading
                                ? null
                                : () async {
                                    await context
                                        .read<HomeBottomSheetController>()
                                        .updateEmployee(context);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (value.isLoading) ...[
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                                const Text('Update'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
