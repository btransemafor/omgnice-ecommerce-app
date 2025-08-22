// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../../auth_export.dart'; 
abstract class AuthService {
  Future<LoginResponseModel?> signInWithGoogle();
  Future<void> signOut();
}

class GoogleServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleServiceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

@override
Future<LoginResponseModel?> signInWithGoogle() async {
  try {
    await _googleSignIn.signOut();
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      print("User cancelled sign-in");
      return null;
    }
    
    final googleAuth = await googleUser.authentication;
    print("googleAuth.idToken = ${googleAuth.idToken}");
    print("googleAuth.accessToken = ${googleAuth.accessToken}");
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    print("Firebase sign-in successful!");
    
    final firebaseIdToken = await userCredential.user!.getIdToken();
    print("🔐 firebaseIdToken (SEND TO BACKEND) = $firebaseIdToken");
    
    if (firebaseIdToken != null) {
      // Send token to backend
      final response = await verifyTokenWithBackend(firebaseIdToken);
      if (response == null) {
        print("Failed to verify token with backend");
        return null;
      }
      
      final data = json.decode(response.body);
      if (!data['success']) {
        print("Backend error: ${data['message']}");
        return null;
      }
      
      final userData = data['data'];
      if (userData == null) {
        print("No user data in response");
        return null;
      }
      print("User data from backend: $userData");

      print('pwRandom: ${userData['pwRandom']}');

      // Create user model
      UserModel userInfo = UserModel(
        pwRandom: userData['pwRandom'] ?? '',
        isActive: userData['is_active'],
        id: userData['id'] ?? '', 
        name: userData['name'] ?? '', 
        avatar: userData['avatar'],
        email: userData['email'] ?? '', 
        phone: userData['phone'],
        active: userData['active'] ?? false, 
        point: userData['point'] ?? 0,

      );

      print(userInfo); 

      
      return LoginResponseModel(
        is_active: userData['is_active'] ,
        accessToken: userData['accessToken'] ?? '', 
        refreshToken: userData['refreshToken'] ?? '', 
        user: userInfo
      );
    }
    return null;
  } catch (e) {
    print("Google sign in error: $e");
    return null;
  }
}

Future<http.Response?> verifyTokenWithBackend(String firebaseIdToken) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.11:8081/api/auth/google/verify'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': firebaseIdToken}),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print("HTTP error: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Verification API error: $e");
    return null;
  }
}
  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}

