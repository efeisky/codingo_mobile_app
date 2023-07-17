import 'package:codingo/product/enum/dio_paths.dart';
import 'package:codingo/product/global/project_dio.dart';
import 'package:codingo/views/options_pages/user_order/model/order_model.dart';

enum OrderType{
  local, global
}

abstract class IUserOrderService {
  Future<List<OrderModel>> getOrder(String username, OrderType type);
}

class UserOrderService with ProjectDio implements IUserOrderService {
  Future<List?> _getOrderListFromDatabase(String username, OrderType type) async{
    final result = await backService.get(
      DioPaths.getOrder.name,
      queryParameters: {
        "username" : username,
        "type" : type.name
      }
    );
    return result.data['status'] == 1 ? result.data['result'] : null;
  }

  @override
  Future<List<OrderModel>> getOrder(String username, OrderType type) async{
    final list =  await _getOrderListFromDatabase(username, type);
    if (list != null) {
      return _tidyList(list);
    }
    return [];
  }
  
  List<OrderModel> _tidyList(List datas) {
     return datas.map((data) => OrderModel(
      username : data['username'],
      realName : data['realName'],
      picture : data['pictureSrc'],
      rank : data['rank'],
      score : data['userScore'],
    )).toList();
  }
  
}