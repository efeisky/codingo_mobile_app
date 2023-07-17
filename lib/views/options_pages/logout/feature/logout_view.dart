import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/enum/navigator_enums.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/product/mixin/navigator_mixin.dart';
import 'package:codingo/views/options_pages/logout/cache/logout_cache.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogOutView extends StatefulWidget {
  const LogOutView({super.key});

  @override
  State<LogOutView> createState() => _LogOutViewState();
}

class _LogOutViewState extends State<LogOutView> with NavigatorMixin {
  late final LogOutCacheController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LogOutCacheController(UserCacheController(Provider.of<UserNotifier>(context, listen: false)));
    _logoutProcess();
  }

  Future<void> _logoutProcess() async{
    final response = await _controller.logout();
    if(response){
      router.pushReplacementToPage(NavigatorRoutesPaths.home);
    }
    else{
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title:  const Text('Sistem Hatası'),
            content: const  Text('Hesap çıkış işleminde hata gerçekleşmiştir'),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  router.pushReplacementToPage(NavigatorRoutesPaths.login);
                },
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .2,
          height: MediaQuery.of(context).size.width * .2,
          child: const CircularProgressIndicator(
            color: _LogOutTheme.progressClor,
          ),
        ),
      ),
    );
  }
}

class _LogOutTheme {
  static const Color progressClor = Color.fromRGBO(92, 74, 203, 1);
}