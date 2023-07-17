part of 'first_register.dart';


class _SocialButtonAreaForRegister extends StatefulWidget {
  const _SocialButtonAreaForRegister({
    Key? key,
    required this.router,
  }) : super(key: key);

  final NavigatorManager router;

  @override
  State<_SocialButtonAreaForRegister> createState() => _SocialButtonAreaForRegisterState();
}

class _SocialButtonAreaForRegisterState extends State<_SocialButtonAreaForRegister> with NavigatorMixin {
  final GoogleSignInApiForRegister _googleSignIn = GoogleSignInApiForRegister();

  Future<void> _signInWithGoogle(BuildContext context) async {
    final methodResult = await _googleSignIn.register();
    if(methodResult['status'] == false){
      const String title = 'Google Kayıt Hatası';
      String content = methodResult['errorMsg'];
      const String actionChild = 'Tamam';

      _alertDialog(context, title , content, actionChild);
    }
    else
    {
      router.pushReplacementToPage(NavigatorRoutesPaths.completeRegister, arguments: methodResult["username"]);
    }
  }

  void _signInWithApple(BuildContext context) {

    const String title = 'Sistem Uyarısı';
    const String content = 'Hizmet şu anda devre dışıdır.';
    const String actionChild = 'Tamam';

    _alertDialog(context, title, content, actionChild);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SocialButton(socialType: ImagePaths.google,onTap: () async{
              await _signInWithGoogle(context);
              return true;
          },),
          SocialButton(socialType: ImagePaths.apple,onTap: () async{
              _signInWithApple(context);
            return true;          
          },),
        ],
        ),
      ],
    );
    
  }

  Future<dynamic> _alertDialog(BuildContext context, String title, String content, String actionChild) {
    return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text(actionChild),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }
}
