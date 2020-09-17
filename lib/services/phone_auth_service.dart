import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virusmapbr/helpers/logger.dart';

// Phone Authentication Service
// Uses Firebase to authenticate users with phone number and OTP code.
class PhoneAuthService {
  String verificationId;
  String smsCode;
  bool codeSent = false;

  Future<void> verifyPhone(
    String phoneNo, {
    onTimeout: VoidCallback,
    onCodeSent: VoidCallback,
    onFailed: VoidCallback,
  }) async {
    Logger.yellow("PhoneAuthService >> Verifying phone...");

    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      Logger.yellow("PhoneAuthService >> .. phone verification complete.");
      PhoneAuthService.signIn(authResult);
    };

    final PhoneVerificationFailed failed = (FirebaseAuthException authException) {
      Logger.red("PhoneAuthService >> .. phone verification failed.");
      Logger.red("PhoneAuthService >> .. error: ${authException.message}");
      if (onFailed != null) onFailed();
    };

    final PhoneCodeSent sent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      this.codeSent = true;
      Logger.yellow("PhoneAuthService >> .. verification code send.");
      Logger.yellow("PhoneAuthService >> .. verificationId: ${this.verificationId}");
      if (onCodeSent != null) onCodeSent();
    };

    final PhoneCodeAutoRetrievalTimeout timeout = (String verId) {
      this.verificationId = verId;
      Logger.red("PhoneAuthService >> .. code auto retrieval timed out.");
      if (onTimeout != null) onTimeout();
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verified,
      verificationFailed: failed,
      codeSent: sent,
      codeAutoRetrievalTimeout: timeout,
    );
  }

  Future<void> verifyOTP({onFailed: VoidCallback}) async {
    Logger.yellow("PhoneAuthService >> Verifying OTP...");
    try {
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      await signIn(authCreds);
    } catch (e) {
      Logger.red("PhoneAuthService >> .. OTP verification failed...");
      Logger.red("PhoneAuthService >> .. error: ${e.toString()}");
      if (onFailed != null) onFailed();
    }
  }

  static signIn(AuthCredential authCreds) async {
    Logger.yellow("PhoneAuthService >> .. signing int with phone...");
    await FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  static bool isPhoneNumberValid(String number) {
    String patttern = r'(^[+]\d{7,15})';
    RegExp regExp = new RegExp(patttern);
    if (number.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(number)) {
      return false;
    }
    return true;
  }

}
