import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/manager/navigator_manager.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/options_pages/user_follow/feature/error_not_found.dart';
import 'package:codingo/views/options_pages/user_nots/model/nots_model.dart';
import 'package:codingo/views/options_pages/user_nots/service/user_nots_service.dart';

class UserNotsView extends StatefulWidget {
  const UserNotsView({super.key});

  @override
  State<UserNotsView> createState() => _UserNotsView();
}

class _UserNotsView extends State<UserNotsView> with NavigatorMixin{
  final _currentPage = NavigatorRoutesPaths.userNots;
  String _initialUsername = '';
  late final UserNotsService _service;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = UserNotsService();
    _getNots();
  }

  Future<List<NotsModel>> _getNots() async{
    return await _service.getNotsList(_initialUsername);
  }

  @override
Widget build(BuildContext context) {
  final device = MediaQuery.of(context).size;
  return Scaffold(
    appBar: CustomAppBar(
      context: context, 
      mainTitle: 'Notlarım',
      hasArrow: true,
      backPage: NavigatorRoutesPaths.menu,
    ),
    body: Column(
      children: [
        Expanded(
          child: FutureBuilder<List<NotsModel>?>(
            future: _getNots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _progress();
              } else if (snapshot.hasError) {
                return Center(child: Text('Hata: ${snapshot.error}'));
              } else {
                final notList = snapshot.data ?? [];
                if (notList.isNotEmpty) {
                  return ListView.builder(
                  itemCount: notList.length,
                  itemBuilder: (context, index) {
                    final not = notList[index];
                    return _NotTile(device: device, router: router, not: not);
                  },
                );
                }
                else{
                  return ErrorNotFound(device: device,text: 'Hiç notun bulunamadı.',);
                }
                
              }
            },
          ),
        ),
      ]
    ),
    bottomNavigationBar: CustomBottomBar(activePage: _currentPage),
  );
  }
  
  Center _progress() => const Center(
        child: CircularProgressIndicator(
          color: Color.fromRGBO(92, 74, 203, 1),
        ),
      );
}

class _NotTile extends StatelessWidget {
  const _NotTile({
    Key? key,
    required this.device,
    required this.router,
    required this.not,
  }) : super(key: key);

  final Size device;
  final NavigatorManager router;
  final NotsModel not;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: device.height *.05),
      child: InkWell(
        onTap: () {
          router.pushReplacementToPage(NavigatorRoutesPaths.userNotDetail, arguments: {
            'content' : not.contentList,
            'notTitle' : '${not.lessonName} - ${not.lessonNumber}. Ders'
          });
        },
        child: ListTile(
          title: Text(
            '${not.lessonName} - ${not.lessonNumber}. Ders Detayı',
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily,
              fontSize: FontTheme.bxfontSize,
              fontWeight: FontTheme.rfontWeight,
              color: FontTheme.lightNormalColor
            ),
          ),
          trailing: const Icon(Icons.chevron_right_outlined, size: 32,color: FontTheme.lightNormalColor,),
        ),
      ),
    );
  }
}
