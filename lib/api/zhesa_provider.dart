import 'api_data_model.dart';
import 'package:zhebsa_assistant/database/za_darabase.dart';
import 'package:dio/dio.dart';

class ZhesaProvider {
  Future<List> getAllZhesa() async {
    var url = "http://zhebsa.herokuapp.com/webapp/zhebsa";
    Response response = await Dio().get(url);

    return (response.data as List).map((zhesa) {
      print('Inserting $zhesa');
      // DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}
