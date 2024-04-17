// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_crud_operation/controller/home_screen_controller.dart';
import 'package:flutter_crud_operation/model/employee_api_response_model.dart';
import 'package:provider/provider.dart';

class HomeBottomSheetController extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  Employee employee;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  HomeBottomSheetController({
    required this.employee,
  }) {
    nameController.text = employee.name;
    designationController.text = employee.role;
  }

  updateEmployee(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    await context.read<HomeScreenController>().updateEmployee(
          id: employee.id,
          name: nameController.text,
          designation: designationController.text,
        );
    isLoading = false;
    notifyListeners();
  }
}
