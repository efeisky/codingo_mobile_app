import 'package:codingo/views/register/service/register_g_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApiForRegister{
  final googleSignIn = GoogleSignIn();
  final googleService = RegisterByGoogleService();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;
  Future<Map> register() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) {
      return {
      "status" : false,
      "errorMsg" : 'Sistemsel bir hata meydana geldi, Elle kayıt deneyiniz !'
    };
    }
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final result = await googleService.createRegisterModel(_user!.email, _user!.displayName ?? '', _user!.photoUrl);
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    
    return result;
  }
}