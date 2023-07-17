import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/button/custom_button.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/views/user_profile/service/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportProfileView extends StatefulWidget {
  const ReportProfileView({super.key});

  @override
  State<ReportProfileView> createState() => _ReportProfileViewState();
}

class _ReportProfileViewState extends State<ReportProfileView> with NavigatorMixin {
  String _initialUsername = '';
  late final TextEditingController _controller;
  late final UserProfileService _service;
  String _username = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _controller = TextEditingController();
    _service = UserProfileService();
    _initializeValue();
  }
  Future<void> _reportUser() async{
    final response = await _service.setReport(_initialUsername, _username, _controller.text);
    if (response) {
      setState(() {
        _hasError = false;
      });
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }
  void _initializeValue() {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if (modelArgs != null && modelArgs is String) {
          _username = modelArgs;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Şikayet Et',
        changeableTitle: 'Şikayet Edilen Kullanıcı : $_username',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: device.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _controller,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    labelText: 'Şikayet İçeriği',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(242, 242, 242, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(65, 65, 65, 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelStyle: TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontWeight: FontTheme.xfontWeight,
                      fontSize: FontTheme.fontSize,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: device.height * 0.05),
                _hasError ? const Text(
                  'Hatalı Kod',
                  style: TextStyle(
                    color: Color.fromRGBO(234, 67, 53, 1),
                    fontFamily: FontTheme.fontFamily,
                    fontSize: FontTheme.bfontSize,
                    fontWeight: FontWeight.bold
                  ),
                ) : SizedBox(height: device.height * 0.05),
                CustomButton(
                  buttonText: 'Şikayet Et',
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  horizontalPadding: 15,
                  verticalPadding: 20,
                  fontSize: FontTheme.nbfontSize,
                  onPressed: () async {
                    _reportUser();
                    return true;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
