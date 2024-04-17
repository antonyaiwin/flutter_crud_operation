// To parse this JSON data, do
//
//     final employeeApiResponseModel = employeeApiResponseModelFromJson(jsonString);

import 'dart:convert';

EmployeeApiResponseModel employeeApiResponseModelFromJson(String str) =>
    EmployeeApiResponseModel.fromJson(json.decode(str));

String employeeApiResponseModelToJson(EmployeeApiResponseModel data) =>
    json.encode(data.toJson());

class EmployeeApiResponseModel {
  int status;
  String message;
  List<Employee> employeeList;

  EmployeeApiResponseModel({
    required this.status,
    required this.message,
    required this.employeeList,
  });

  factory EmployeeApiResponseModel.fromJson(Map<String, dynamic> json) =>
      EmployeeApiResponseModel(
        status: json["status"],
        message: json["message"],
        employeeList:
            List<Employee>.from(json["data"].map((x) => Employee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(employeeList.map((x) => x.toJson())),
      };
}

class Employee {
  int id;
  String name;
  String role;

  Employee({
    required this.id,
    required this.name,
    required this.role,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
      };
}
