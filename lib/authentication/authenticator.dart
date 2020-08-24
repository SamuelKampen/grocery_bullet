import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;

  Authenticator() {
    this._firebaseAuth = FirebaseAuth.instance;
    this._googleSignIn = GoogleSignIn();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    return user;
  }
}
