import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_crud_operation/model/employee_api_response_model.dart';
import 'package:http/http.dart' as http;

class HomeScreenController extends ChangeNotifier {
  String baseUrl = 'http://3.93.46.140/employees/';
  bool isLoading = false;
  EmployeeApiResponseModel? _apiResponseModel;

  List<Employee> get employees => _apiResponseModel?.employeeList ?? [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();

// get all data
  Future<void> getEmployees() async {
    isLoading = true;
    notifyListeners();
    Uri uri = Uri.parse(baseUrl);
    var res = await http.get(uri);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      _apiResponseModel =
          EmployeeApiResponseModel.fromJson(jsonDecode(res.body));
    } else {
      log('failed get data');
    }

    isLoading = false;
    notifyListeners();
  }

  // delete a data
  Future<void> deleteEmployee(var id) async {
    isLoading = true;
    notifyListeners();
    Uri uri = Uri.parse('$baseUrl$id/');
    var response = await http.delete(uri);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await getEmployees();
    } else {
      log('failed delete');
    }
    isLoading = false;
    notifyListeners();
  }

//  add an employee
  Future<void> addEmployee() async {
    isLoading = true;
    notifyListeners();
    Uri uri = Uri.parse('${baseUrl}create/');
    var response = await http.post(uri, body: {
      "name": nameController.text,
      "role": designationController.text
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await getEmployees();
    } else {
      log('failed adding data : \n ${response.body}');
    }
    isLoading = false;
    notifyListeners();
  }

  // edit an employee
  Future<void> updateEmployee({
    required int id,
    required String name,
    required String designation,
  }) async {
    Uri uri = Uri.parse('${baseUrl}update/$id/');
    var response = await http.put(uri, body: {
      "name": name,
      "role": designation,
    });
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await getEmployees();
    } else {
      log('failed updating data : \n ${response.body}');
    }
  }
}
