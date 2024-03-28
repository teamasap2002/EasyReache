import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//sign in
bool isLogin = false;
Future<void> checkLogin()async {
  _auth.authStateChanges().listen((User? user) {
    if(user !=null){
      isLogin = true;
    }
  });
}

Future<User?> signInWithGoogle() async{
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
  );

  final userCredential = await _auth.signInWithCredential(credential);

  final User? user = userCredential.user;
  if(user!=null){
    if(userCredential.additionalUserInfo!.isNewUser){
      await _firestore.collection('Users').doc(user.uid).set(
        {
            'uid': user.uid,
            'name': user.displayName,
            'phoneno' : user.phoneNumber??"+91xxxxxxxxxx",
            'email': user.email,
            'profilePhoto' : user.photoURL??"https://cdn-icons-png.flaticon.com/128/1144/1144760.png",
            'gender': ""
        }
      );
    }
    checkLogin();
  }

  assert(!user!.isAnonymous);
  assert(await user!.getIdToken()!=null);

  final User? currentUser = await _auth.currentUser;

  assert(currentUser!.uid == user?.uid);
  // print(user);
  return user;
}

void signOut() async
{
  await googleSignIn.signOut();
  await _auth.signOut();
}