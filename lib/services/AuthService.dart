import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static Future<auth.User> getSignedInUser() async {
    auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
    return firebaseUser;
  }

  static Future<auth.User> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
  }
}
