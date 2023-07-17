import 'package:codingo/product/cache/user_cache.dart';
import 'package:codingo/product/global/user_context.dart';
import 'package:codingo/views/login/service/login_g_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  final googleSignIn = GoogleSignIn();
  // ignore: unused_field
  final UserNotifier _notifier;
  final LoginByGoogleService _googleService;

  GoogleSignInApi(this._notifier)
      : _googleService = LoginByGoogleService(UserCacheController(_notifier));

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<bool> login() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return false;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final result = await _googleService.createLoginModel(_user!.email);
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    return result;
  }
}
