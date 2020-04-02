


import 'package:news_mya/src/providers/db_provider.dart';
import 'package:dio/dio.dart';
import 'package:news_mya/src/models/employee_model.dart';

import 'db_provider.dart';

class EmployeeApiProvider {
  Future<List<Employee>> getAllEmployees() async {
    var url = "http://demo8161595.mockable.io/employee";
    Response response = await Dio().get(url);

    return (response.data as List).map((employee) {
      print('Inserting $employee');
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}