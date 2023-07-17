import 'package:codingo/core/widget/image_network_widget.dart';
import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/options_pages/user_order/model/order_model.dart';
import 'package:codingo/views/options_pages/user_order/service/user_order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserOrderView extends StatefulWidget {
  const UserOrderView({super.key});

  @override
  State<UserOrderView> createState() => _UserOrderViewState();
}

class _UserOrderViewState extends State<UserOrderView> {
  final _currentPage = NavigatorRoutesPaths.userOrder;
  OrderType _currentMode = OrderType.local;
  String _initialUsername = '';
  List<OrderModel> _orderedList = [];
  late final UserOrderService _service;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = UserOrderService();
    _getOrderList(_currentMode);
  }

  Future<void> _getOrderList(OrderType type) async{
    final list = await _service.getOrder(_initialUsername, type);
    setState(() {
      _currentMode = type;
      _orderedList = list;
    });
  }

  @override
Widget build(BuildContext context) {
  final device = MediaQuery.of(context).size;
  return Scaffold(
    appBar: CustomAppBar(
      context: context, 
      mainTitle: 'Sıralamam',
      hasArrow: true,
      backPage: NavigatorRoutesPaths.menu,
    ),
    body: Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: device.height*.05),
          width: device.width *.65,
          child: Column(
            children: [
              CustomButton(
                buttonText: 'Modu Değiştir', 
                foregroundColor: Colors.white, 
                backgroundColor: Colors.black,
                borderRadius: BorderRadius.circular(20), 
                horizontalPadding: 15, 
                verticalPadding: 20, 
                fontSize: FontTheme.nbfontSize, 
                onPressed: () async{
                  if (_currentMode == OrderType.local) {
                    await _getOrderList(OrderType.global);
                    return true;
                  }
                  else{
                    await _getOrderList(OrderType.local);
                    return true;
                  }
                },
              ),
              SizedBox(height: device.height*.025,),
              Text(
                _currentMode == OrderType.local ? 'Okul / Şehir Sıralaması' : 'Uygulama Sıralaması',
                style: const TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontSize: FontTheme.nbfontSize,
                  fontWeight: FontTheme.xfontWeight,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: _orderedList.map((item) {
                return ListTile(
                  leading: SizedBox(
                    width: device.width * .25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          item.rank.toString(),
                          style: const TextStyle(
                            fontFamily: FontTheme.fontFamily,
                            fontSize: FontTheme.nbfontSize,
                            fontWeight: FontTheme.xfontWeight,
                          ),
                        ),
                        item.picture == '' ? ImagePaths.unknown.toWidget() : ImageNetworkWidget(pictureSrc: item.picture),
                      ],
                    ),
                  ),
                  title: Text(
                    item.realName,
                    style: const TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontSize: FontTheme.bfontSize,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ),
                  subtitle: Text(
                    '@${item.username}',
                    style: const TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontSize: FontTheme.fontSize,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ),
                  trailing: Text(
                    '${item.score} puan',
                    style: const TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontSize: FontTheme.fontSize,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: CustomBottomBar(activePage: _currentPage),
  );
}

}