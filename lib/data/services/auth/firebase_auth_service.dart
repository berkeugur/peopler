import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../model/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  
  Future<MyUser?> getCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      await user?.reload();
      return _userFromFirebase(user);
    } catch (e) {
      debugPrint("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      MyUser _myUser = MyUser();
      _myUser.userID = user.uid;
      _myUser.email = user.email!;
      _myUser.isTheAccountConfirmed = user.emailVerified;
      _myUser.profileURL = user.photoURL ?? '';
      _myUser.displayName = user.displayName ?? '';
      return _myUser;
    }
  }

  
  Future<bool> signOut() async {
    try {
      // await GoogleSignIn().signOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("sign out hata:" + e.toString());
      return false;
    }
  }

  Future<bool> deleteUser() async {
    try {
      if(_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.delete();
      }
      return true;
    } catch (e) {
      debugPrint("sign out hata:" + e.toString());
      return false;
    }
  }

  /*
  
  Future<MyUser?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
   */

  Future<MyUser?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential? sonuc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(sonuc.user);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser!
          .sendEmailVerification()
          .whenComplete(() => _firebaseAuth.currentUser!.reload());
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  
  Future<bool> listenForEmailVerification() async {
    await _firebaseAuth.currentUser!.reload();
    return _firebaseAuth.currentUser!.emailVerified;
  }

  
  Future<MyUser?> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(sonuc.user);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  
  Future<MyUser?> signInWithCustomToken(String customToken) async {
    try {
      UserCredential _result = await _firebaseAuth.signInWithCustomToken(customToken);
      return _userFromFirebase(_result.user);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  
  Future<void> resetPassword(String email) async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /*
  Future<MyUser?> signInWithLinkedIn(String token) async {
    // For this code to be work, Firebase Functions must be enabled and this costs a billing.
    // https://stackoverflow.com/questions/60724002/setting-custom-claims-for-firebase-auth-from-flutter
  }
   */
}
