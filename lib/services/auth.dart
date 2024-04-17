import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

bool isLogin = false;

// Listen to authentication state changes to determine if user is logged in
Future<void> checkLogin() async {
  _auth.authStateChanges().listen((User? user) {
    isLogin = user != null;
  });
}

// Sign in with Google
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      throw FirebaseAuthException(
          code: 'sign_in_canceled',
          message: 'User canceled sign-in process');
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final UserCredential userCredential =
    await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      // Check if it's a new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Store user data in Firestore
        await _firestore.collection('Users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName,
          'phoneno': user.phoneNumber ?? "+91xxxxxxxxxx",
          'email': user.email,
          'profilePhoto': user.photoURL ??
              "https://cdn-icons-png.flaticon.com/128/1144/1144760.png",
          'gender': "",
        });
      }
      await checkLogin(); // Update login status after successful sign-in
    }

    return user;
  } catch (e) {
    print('Error signing in with Google: $e');
    rethrow; // Rethrow the error for higher level handling
  }
}

// Sign out
Future<void> signOut() async {
  try {
    await googleSignIn.signOut();
    await _auth.signOut();
  } catch (e) {
    print('Error signing out: $e');
    rethrow; // Rethrow the error for higher level handling
  }
}
