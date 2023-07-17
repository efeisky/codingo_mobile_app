import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/product/theme/font_theme.dart';
import 'package:codingo/product/widgets/custom_app_bar.dart';
import 'package:codingo/product/widgets/custom_bottom_bar.dart';
import 'package:codingo/product/widgets/custom_search_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDiscoverView extends StatefulWidget {
  const UserDiscoverView({super.key});

  @override
  State<UserDiscoverView> createState() => _UserDiscoverViewState();
}

class _UserDiscoverViewState extends State<UserDiscoverView> with NavigatorMixin {
  String _initialUsername = '';
  final _currentPage = NavigatorRoutesPaths.userDiscover;
  @override
  void initState() {
    super.initState();
    _initialUsername = context.read<UserNotifier>().currentUsername;
  }

  void goToProfile(String selectedName) {
    if (_initialUsername == selectedName) {
      router.pushReplacementToPage(NavigatorRoutesPaths.userProfile);
    }
    else{
      router.pushReplacementToPage(NavigatorRoutesPaths.userProfile,arguments: {'username' : selectedName});
    }
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    var sizedBox = SizedBox(height: device.height*.025,);
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        mainTitle: 'Keşfet',
      ),
      bottomNavigationBar: CustomBottomBar(activePage: _currentPage,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchDropdown(
              onTap: (username) {
                goToProfile(username);
              },
            ),
            SizedBox(
              height: device.height *.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Karekod ile hesabı bul',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FontTheme.fontFamily,
                      fontSize: FontTheme.bfontSize,
                      fontWeight: FontTheme.rfontWeight
                    ),
                  ),
                  sizedBox,
                  ElevatedButton(
                    onPressed: () {
                      router.pushReplacementToPage(NavigatorRoutesPaths.scanQrCode);
                    }, 
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Kamerayı Aç',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FontTheme.fontFamily,
                        fontSize: FontTheme.nbfontSize,
                        fontWeight: FontTheme.rfontWeight
                      ),
                    ),
                  )
                ],
              )
              )
          ],
        ),
      ),
    );
  }
}