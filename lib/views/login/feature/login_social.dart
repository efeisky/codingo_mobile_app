part of 'login_page.dart';

// ignore: must_be_immutable
class _SocialAreaForLogin extends StatelessWidget {

  _SocialAreaForLogin({
    Key? key,
    required this.router,
  }) : super(key: key);

  final NavigatorManager router;
  GoogleSignInApi? _googleSignIn;

  Future<void> _signInWithGoogle(BuildContext context) async {
    _googleSignIn = GoogleSignInApi(Provider.of<UserNotifier>(context, listen: false));
    final methodResult = await _googleSignIn!.login();
    if (methodResult) {
      router.pushReplacementToPage(NavigatorRoutesPaths.userHome);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SocialButton(
          socialType: ImagePaths.google,
          onTap: () async {
            await _signInWithGoogle(context);
            return true;
          },
        ),
        SocialButton(
          socialType: ImagePaths.apple,
          onTap: () async {
            _signInWithApple(context);
            return true;
          },
        ),
      ],
    );
  }

  Future<dynamic> _alertDialog(
      BuildContext context, String title, String content, String actionChild) {
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
