// ignore_for_file: use_build_context_synchronously

import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/views/user_profile/feature/theme/user_profile_theme.dart';
import 'package:codingo/views/user_profile/feature/widget/biography_widget.dart';
import 'package:codingo/views/user_profile/feature/widget/contact_widget.dart';
import 'package:codingo/views/user_profile/feature/widget/degress_widget.dart';
import 'package:codingo/views/user_profile/feature/widget/follow_widget.dart';
import 'package:codingo/views/user_profile/feature/widget/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/Navigator_mixin.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/views/user_profile/model/user_profile_model.dart';
import 'package:codingo/views/user_profile/service/user_profile_service.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> with NavigatorMixin{
  String _initialUsername = '';
  late String _requestedProfilName = '';
  final _currentPage = NavigatorRoutesPaths.userProfile;
  late final UserProfileService _service;

  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
    _service = UserProfileService();
    _initializeValue();
  }
  
  Future<UserProfileModel?> _fetchProfileData() async{
    if (_requestedProfilName.isNotEmpty) {
      final response = await _service.getProfileValues(_requestedProfilName);
      if(response != null){
        return response;
      }
      else{
        return null;
      }
    }
    else{
      return null;
    }
    
  }
  
  void _initializeValue() {
    Future.microtask(() {
      final modelArgs = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if (modelArgs != null && modelArgs is Map) {
          _requestedProfilName = modelArgs['username'];
        } else {
          _requestedProfilName = _initialUsername;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: '@$_requestedProfilName',
        changeableTitle: 'Profil Sayfası',
        hasMenu: _requestedProfilName == _initialUsername,
        onTap: () { 
          router.pushReplacementToPage(NavigatorRoutesPaths.menu,arguments: {'backPage':NavigatorRoutesPaths.userProfile});
        },
      ),
      body: FutureBuilder<UserProfileModel?>(
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _progress();
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            return _UserProfileInformations(userData: userData, isMyProfile: userData.username == _initialUsername,username: _initialUsername,);
          }
        },
      ),
      bottomNavigationBar: CustomBottomBar(activePage: _currentPage,)
    );
  }
  Center _progress() => const Center(child: CircularProgressIndicator(
    color: UserProfileTheme.progressColor,
  ));
}

class _UserProfileInformations extends StatefulWidget {
  const _UserProfileInformations({
    Key? key,
    required this.userData, required this.isMyProfile, required this.username,
  }) : super(key: key);

  final UserProfileModel userData;
  final bool isMyProfile;
  final String username;

  @override
  State<_UserProfileInformations> createState() => _UserProfileInformationsState();
}

class _UserProfileInformationsState extends State<_UserProfileInformations> {
  late final UserProfileService _service;

  @override
  void initState() {
    super.initState();
    _service = UserProfileService();
  }
  
  Future<void> _doAction(ActionType actionType,username,actionedUsername,BuildContext context) async{
    final response = await _service.setAction(actionType, username, actionedUsername);
    if (response['status']) {
    } else {
      
      String errorText = response['errorMessage'] == 'You already like this profile.' &&  actionType == ActionType.like 
      ? 'Bu profili zaten beğendin' 
      : response['errorMessage'] == 'You already followed this profile.' &&  actionType == ActionType.follow
      ? 'Bu profili zaten takip ediyorsun'
      : 'Sistemsel bir hata oluştu !';

      _alertDialog(context, errorText);
    }
  }

  Future<dynamic> _alertDialog(BuildContext context, String errorText) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Hata Mesajı',
                style: TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontWeight: FontTheme.xfontWeight,
                  fontSize: FontTheme.bfontSize
                ),
            ),
            content: Text(
              'Hata Sebebi : $errorText',
              style: const TextStyle(
                  fontFamily: FontTheme.fontFamily,
                  fontWeight: FontTheme.rfontWeight,
                  fontSize: FontTheme.nbfontSize
                ),
              ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Kapat',
                  style: TextStyle(
                    fontFamily: FontTheme.fontFamily,
                    fontWeight: FontTheme.xfontWeight,
                    fontSize: FontTheme.fontSize
                  ),

                ),
              ),
            ],
          );
      });
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    var sizedBox = SizedBox(height: device.height* .025,);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: device.width * .05),
        child: Column(
          children: [
            UserInfoWidget(
              imagePath: widget.userData.picture,
              realname: widget.userData.realname,
              username: widget.userData.username,
              isSecurity: widget.userData.security == 1,
            ),
            sizedBox,
            FollowWidget(followCount: widget.userData.followed,followerCount: widget.userData.follower, profileOwner: widget.isMyProfile,username: widget.userData.username),
            !widget.isMyProfile ? Column(
              children: [
                ContactWidget(
                  onLiked: () async{
                    await _doAction(ActionType.like,widget.username,widget.userData.username,context);
                  }, 
                  onFollowed: () async{ 
                    await _doAction(ActionType.follow,widget.username,widget.userData.username,context);
                  }, 
                  name: widget.userData.username,
                ),
                sizedBox
              ],
            ) : sizedBox,

            BiographyWidget(biographyTitle: widget.userData.biographyTitle, biographyContent: widget.userData.biographyContent),
            sizedBox,
            DegressWidget(
              score: widget.userData.score,
              like: widget.userData.likeCount,
              province: widget.userData.province,
              school: widget.userData.school,
              eduLevel: widget.userData.eduLevel,
              levelOfSchool: widget.userData.orderInSchool,
              levelOfProvince: widget.userData.orderInProvince,
              lastTenDay: widget.userData.lastTenDayScore,
            )
          ],
        ),
      ),
    );
  }
}
