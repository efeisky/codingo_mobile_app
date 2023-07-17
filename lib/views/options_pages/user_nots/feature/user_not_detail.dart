import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/views/options_pages/user_nots/model/not_content_model.dart';
import 'package:flutter/material.dart';

class UserNotContentDetail extends StatefulWidget {
  const UserNotContentDetail({super.key});

  @override
  State<UserNotContentDetail> createState() => _UserNotContentDetailState();
}

class _UserNotContentDetailState extends State<UserNotContentDetail> {
  
  String? _notTitle;
  List<NotContentModel> _notContent = [];
  @override
  void initState() {
    super.initState();
    ()async{
      await _initializeValues();
    }();
  }

  Future<void> _initializeValues() async {
      Future.microtask(() {
        final modelArgs = ModalRoute.of(context)?.settings.arguments;
        if (modelArgs is Map) {
          setState(() {
            _notContent = modelArgs['content'];
            _notTitle = modelArgs['notTitle'];
          });
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Seçilen Not',
        changeableTitle: _notTitle,
        hasArrow: true,
        backPage: NavigatorRoutesPaths.userNots,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _notContent.length,
              itemBuilder: (context, index) {
                final content = _notContent[index].content;
                return Padding(
                  padding: EdgeInsets.only(bottom: device.height * .01, top: index == 0 ? device.height * .01 : 0),
                  child: ListTile(
                    title: Text(
                      content,
                      style: const TextStyle(
                        fontFamily: FontTheme.fontFamily,
                        fontSize: FontTheme.nbfontSize
                      ),
                    ),
                    leading: ImagePaths.not_star.toWidget(),
                  ),
                );
              },
            ),
          ]
        ),
      ),
    );
  }
}