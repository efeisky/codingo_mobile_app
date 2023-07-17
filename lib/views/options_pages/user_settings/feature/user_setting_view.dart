import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/options_pages/user_settings/feature/enum/image_enum.dart';
import 'package:codingo/views/options_pages/user_settings/feature/enum/user_enum.dart';
import 'package:codingo/views/options_pages/user_settings/feature/widgets/photo_widget.dart';
import 'package:codingo/views/options_pages/user_settings/feature/widgets/user_info_widget.dart';
import 'package:codingo/views/options_pages/user_settings/feature/widgets/user_theme_widget.dart';
import 'package:codingo/views/options_pages/user_settings/feature/widgets/user_verify_widget.dart';
import 'package:codingo/views/options_pages/user_settings/model/user_setting_model.dart';
import 'package:codingo/views/options_pages/user_settings/service/user_setting_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingView extends StatefulWidget {
  const UserSettingView({super.key});

  @override
  State<UserSettingView> createState() => _UserSettingViewState();
}

class _UserSettingViewState extends State<UserSettingView> with NavigatorMixin{

  String _initialUsername = '';
  UserSettingService _service = UserSettingService();
  UserSettingModel _model = UserSettingModel(realname: '...', username: '...', school: '...', pictureSrc: '', userScore: 0, userEducation: '...', userProvince: '...', isVerified: false, phoneNumber: '...', isPhoneVerified: false, biographyTitle: '...', biographyContent: '...');
  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = UserSettingService();
    ()async{
      await _getSettingValue();
    }();
  }
  
  Future<void> _getSettingValue() async{
    final response = await _service.getSetting(_initialUsername);
    if (response != null) {
      setState(() {
        _model = response;
      });
    }
    else{
      _showAlert('Veriler düzgün yüklenemedi');
    }
  }

  Future<void> _saveThemeChanges(String title, String content) async{
    final response = await _service.setThemeChanges(title, content, _initialUsername);
    if (response) {
      router.pushReplacementToPage(NavigatorRoutesPaths.userProfile);
    }
    else{
      _showAlert('Bir hata oluştu !');
    }
  }
  
  Future<dynamic> _showAlert(String text) {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title:  const Text('Sistem Hatası'),
          content:  Text(text),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                router.pushReplacementToPage(NavigatorRoutesPaths.menu);
              },
            ),
          ],
        );
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    var navigationPage = NavigatorRoutesPaths.userProfile;
    const sizedBox = SizedBox(height: 25,);
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Ayarlar',
        hasArrow: true,
        backPage: NavigatorRoutesPaths.menu,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserPhotoWidget(
              pictureSrc: _model.pictureSrc, 
              onTap: (PictureActionTypes type) { 
                _showAlert('Bu servis geçici olarak kullanılamamaktadır.');
               }
            ),
            UserSettingInfoWidget(infoHeader: 'Kişisel Bilgiler',settingModel: _model,),
            UserVerifyWidget(
              infoHeader: 'Güvenlik Bilgileri',
              settingModel: _model, 
              onTap: (UserVerifyType verifyType) async{ 
                switch (verifyType) {
                  case UserVerifyType.account:
                    router.pushReplacementToPage(NavigatorRoutesPaths.verifyEmail);
                  case UserVerifyType.phone:
                    await _showAlert('Bu sistem hizmet dışı');
                    router.pushReplacementToPage(NavigatorRoutesPaths.userSettings);
                }
              },
            ),
            _model.biographyTitle != '...' 
            ? UserThemeWidget(model: _model, onTap: (String title, String content) async{ 
              await _saveThemeChanges(title, content);
             },) 
            : const SizedBox.shrink(),
            RichText(
              text: TextSpan(
                text: 'Codingo üyeliğini silmek için, ',
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: FontTheme.fontFamily,
                  fontSize: FontTheme.nbfontSize,
                ),
                children: [
                  TextSpan(
                    text: 'Hesabı Sil',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    // Hesabı silme işlevini buraya ekleyin
                    recognizer: TapGestureRecognizer()..onTap = () {
                      router.pushReplacementToPage(NavigatorRoutesPaths.deleteAccount);
                    },
                  ),
                ],
              ),
            ),
            sizedBox
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(activePage: navigationPage,),
    );
  }
}