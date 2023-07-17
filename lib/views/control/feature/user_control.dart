import 'package:codingo/product/enum/image_enums.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/extensions/image_extension.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/manager/shared_manager.dart';
import 'package:codingo/product/mixin/Navigator_mixin.dart';
import 'package:codingo/views/control/cache/login_cache.dart';
import 'package:codingo/product/cache/user_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserControl extends StatefulWidget {
  const UserControl({Key? key}) : super(key: key);


  @override
  State<UserControl> createState() => _UserControlState();
}

class _UserControlState extends State<UserControl> with SingleTickerProviderStateMixin, NavigatorMixin {

  late AnimationController  _animationController;
  late Animation<double> _scaleAnimation;
  late final SharedManager _manager;
  late final LoginCacheController _loginCacheController;
  late final UserCacheController _userCacheController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));   
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(_animationController);
    _animationController.repeat(reverse: true);
    _manager = SharedManager();
    initialize();
  }

  Future<void> initialize() async {
    await _manager.init();
    _loginCacheController = LoginCacheController(_manager);
    checkUser();
  }

  Future<void> checkUser() async {
    final status = _loginCacheController.checkLoginStatus();
    if(status){
      _userCacheController = UserCacheController(Provider.of<UserNotifier>(context,listen: false));
      await _userCacheController.getUserCache();
      
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
    }
    else{
      router.pushReplacementToPage(NavigatorRoutesPaths.home);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
                scale: _scaleAnimation.value,
                child: ImagePaths.codingo.toWidget(),
            );
          },
        )
      ),
    );
  }
}