import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/views/register/model/register_error.dart';
import 'package:flutter/material.dart';

import 'package:codingo/product/enum/dropdown_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_dropdown.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';
import 'package:codingo/views/register/feature/register_bottom_area.dart';
import 'package:codingo/views/register/feature/theme/register_theme.dart';
import 'package:codingo/views/register/model/register_model.dart';
import 'package:codingo/views/register/service/register_service.dart';
import 'package:provider/provider.dart';

class SecondRegisterView extends StatefulWidget {
  const SecondRegisterView({super.key});

  @override
  State<SecondRegisterView> createState() => _SecondRegisterViewState();
}

class _SecondRegisterViewState extends State<SecondRegisterView> with NavigatorMixin{
  final int pageNo = 2;
  RegisterService? _service;
  late RegisterUserModel _educationLevelModel;
  late RegisterUserModel _provinceModel;
  late RegisterUserModel _schoolModel;
  bool _hasEmpty = false;
  
  late final String _name;
  late final String _email;
  late final String _password;
  late final RegisterError _error;
  @override
  void initState() {
    super.initState();
    _error = RegisterError();
    _initializeValues();
    _educationLevelModel = RegisterUserModel();
    _provinceModel = RegisterUserModel();
    _schoolModel = RegisterUserModel();
  }
  Future<void> _initializeValues() async {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if(modelArgs is Map){
          _name = modelArgs['name'];
          _email = modelArgs['email'];
          _password = modelArgs['password'];
        }
      });
    });
  }
  Future<bool> _registerUser(BuildContext context) async{
    _service = RegisterService(UserCacheController(Provider.of<UserNotifier>(context, listen: false)));
    final response = await _service!.registerUser(
      _name, _email, _password, _educationLevelModel.educationLevel!, _provinceModel.province!, _schoolModel.school ?? '', SignTypeEnums.Email
    );
    if(response['status'] == false){
      _error.message = response['errorMsg'];
      _error.status = true;
      return true;
    }
    else{
      _error.status = false;
      _error.message = '';
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        mainTitle: 'Codingo',
        hasArrow: true,
        changeableTitle: 'Kaydı Tamamla',
        backPage: NavigatorRoutesPaths.register,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomDropdown(
                    inputAction: TextInputAction.next,
                    hint: 'Eğitim Seviyesi',
                    type: DropdownTypes.education,
                    onSelected: (String value) {
                      _educationLevelModel.educationLevel = value;
                    },
                    onChangedSelected: () {
                      _educationLevelModel.educationLevel = null;
                    },
                  ),
                  CustomDropdown(
                    inputAction: TextInputAction.next,
                    hint: 'Şehir',
                    type: DropdownTypes.province,
                    onSelected: (String value) {
                      _provinceModel.province = value;
                    },
                    onChangedSelected: () {
                      _provinceModel.province = null;
                    },
                  ),
                  if (_educationLevelModel.educationLevel != null &&
                      _educationLevelModel.educationLevel !=
                          CustomEduLevelEnums.Mezun.name &&
                      _provinceModel.province != null)
                    CustomDropdown(
                    inputAction: TextInputAction.done,
                      hint: 'Okul',
                      type: DropdownTypes.school,
                      onSelected: (String value) {
                        _schoolModel.school = value;
                      },
                      onChangedSelected: () {
                        _schoolModel.school = null;
                      },
                      provinceAndEduLevel: {
                        'province': _provinceModel.province,
                        'eduLevel': _educationLevelModel.educationLevel
                      },
                    )
                  else
                    const SizedBox.shrink(),

                  _hasEmpty ? const Text(
                    'Tüm Alanlar Doldurulmalıdır !',
                    style: TextStyle(
                      fontSize: FontTheme.nbfontSize,
                      color: RegisterTheme.errorColor,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ) : const SizedBox.shrink(),

                  _error.status ? Text(
                    _error.message,
                    style: const TextStyle(
                      fontSize: FontTheme.nbfontSize,
                      color: RegisterTheme.errorColor,
                      fontWeight: FontTheme.rfontWeight,
                    ),
                  ) : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          BottomArea(
            buttonIcon: const Icon(Icons.done_rounded),
            buttonText: 'Kaydı Tamamla',
            currentPageNo: pageNo,
            onTap: () async{
              if(
                _educationLevelModel.educationLevel != null 
                && _provinceModel.province != null
                && _educationLevelModel.educationLevel == 'Mezun' 
                ? _schoolModel.school == null 
                : _schoolModel.school != null
                ){
                setState(() {
                  _hasEmpty = false;
                });
                final value = await _registerUser(context);
                if(value) router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
              }
              else{
                setState(() {
                  _hasEmpty = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

