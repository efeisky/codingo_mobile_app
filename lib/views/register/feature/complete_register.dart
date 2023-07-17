import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/dropdown_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_dropdown.dart';
import 'package:codingo/product/widgets/custom_text_field.dart';
import 'package:codingo/views/login/service/enum/signtype_enums.dart';
import 'package:codingo/views/register/feature/register_bottom_area.dart';
import 'package:codingo/views/register/feature/theme/register_theme.dart';
import 'package:codingo/views/register/model/register_error.dart';
import 'package:codingo/views/register/model/register_model.dart';
import 'package:codingo/views/register/service/register_complete_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompleteRegisterView extends StatefulWidget {
  const CompleteRegisterView({super.key});

  @override
  State<CompleteRegisterView> createState() => _CompleteRegisterViewState();
}

class _CompleteRegisterViewState extends State<CompleteRegisterView> with NavigatorMixin {
  late RegisterUserModel _model; 
  RegisterCompleteService? _service;
  late final String _name;
  bool _hasEmpty = false;
  late final RegisterError _error;
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _initializeValue();
    _controller = TextEditingController();
    _error = RegisterError();
    _model = RegisterUserModel();
  }
  Future<void> _initializeValue() async {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if(modelArgs is String){
          _name = modelArgs;
        }
      });
    });
  }

  Future<void> _completeRegister() async{
    _service = RegisterCompleteService(UserCacheController(Provider.of<UserNotifier>(context, listen: false)));
    var password = _controller.text;
    final response = await _service!.completeRegister(_name,password,_model.educationLevel!,_model.province!,_model.school ?? '',SignTypeEnums.Google);
    if(response['status'] == false){
      _error.message = response['errorMsg'];
      _error.status = true;
    }
    else{
      _error.status = false;
      _error.message = '';
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(context: context, mainTitle: 'Kaydı Tamamla'),
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
                      _model.educationLevel = value;
                    },
                    onChangedSelected: () {
                      _model.educationLevel = null;
                    },
                  ),
                  CustomDropdown(
                    inputAction: TextInputAction.next,
                    hint: 'Şehir',
                    type: DropdownTypes.province,
                    onSelected: (String value) {
                      _model.province = value;
                    },
                    onChangedSelected: () {
                      _model.province = null;
                    },
                  ),
                  if (_model.educationLevel != null &&
                      _model.educationLevel !=
                          CustomEduLevelEnums.Mezun.name &&
                      _model.province != null)
                    CustomDropdown(
                    inputAction: TextInputAction.next,
                      hint: 'Okul',
                      type: DropdownTypes.school,
                      onSelected: (String value) {
                        _model.school = value;
                      },
                      onChangedSelected: () {
                        _model.school = null;
                      },
                      provinceAndEduLevel: {
                        'province': _model.province,
                        'eduLevel': _model.educationLevel
                      },
                    )
                  else
                    const SizedBox.shrink(),
          
                    
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: device.width *.05),
                        child:  const Text(
                          '( Şifre isteğe bağlıdır. )',
                          style: TextStyle(
                            fontFamily: FontTheme.fontFamily,
                            fontSize: FontTheme.fontSize,
                            color: RegisterTheme.dropdownUpperHintTextColor
                          ),
                        ),
                      ),
                      CustomTextField(
                        controller: _controller,
                        hintText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock),
                        hasSuffixIcon: true,
                        inputAction: TextInputAction.done,
                        autoFillHints: const [AutofillHints.newPassword],
                        textInputType: TextInputType.visiblePassword,
                        beObsecure: true,
                      ),
                    ],
                  ),
          
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
          _bottomWidget()
        ],
      ),
    );
  }

  BottomArea _bottomWidget() {
    return BottomArea(
          currentPageNo: 0, 
          onTap: () async{
            if(
                _model.educationLevel != null 
                && _model.province != null
                && _model.educationLevel == 'Mezun' 
                ? _model.school == null 
                : _model.school != null
                ){
                setState(() {
                  _hasEmpty = false;
                });
                await _completeRegister();
              }
              else{
                setState(() {
                  _hasEmpty = true;
                });
              }
          }, 
          buttonIcon: const Icon(Icons.done_rounded),
          buttonText: 'Kaydı Tamamla',
        );
  }
}