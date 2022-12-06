import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../others/strings.dart';
import '../../model/user.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<MyUser?> getCurrentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      debugPrint("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  MyUser? _userFromFirebase(User? user, {String? displayName}) {
    if (user == null) {
      return null;
    } else {
      MyUser _myUser = MyUser();
      _myUser.userID = user.uid;
      _myUser.email = user.email!;
      _myUser.isTheAccountConfirmed = user.emailVerified;
      _myUser.profileURL = user.photoURL ?? '';
      _myUser.displayName = user.displayName ?? '';
      if (displayName != null) _myUser.displayName = displayName;
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
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.delete();
      }
      return true;
    } catch (e) {
      debugPrint("delete hata:" + e.toString());
      return false;
    }
  }

  Future<String?> recreateCustomToken(String email) async {
    try {
      final response = await http.post(Uri.parse(Strings.recreateCustomTokenUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'emailAddress': email}));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonReceived = json.decode(response.body);
        return jsonReceived["custom_token"];
      } else {
        debugPrint("recreate status code: " + response.statusCode.toString());
        return null;
      }
    } catch (e) {
      debugPrint("recreate custom token hata:" + e.toString());
      return null;
    }
  }

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
      await _firebaseAuth.currentUser!.sendEmailVerification().whenComplete(() => _firebaseAuth.currentUser!.reload());
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

  Future<MyUser?> signInWithEmailAndPassword(String email, String password) async {
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

  Future<MyUser?> signInWithApple() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential result = await _firebaseAuth.signInWithCredential(oauthCredential);
      User? user = result.user;
      String displayName = "${appleCredential.givenName} ${appleCredential.familyName}";
      return _userFromFirebase(user, displayName: displayName);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
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
}
