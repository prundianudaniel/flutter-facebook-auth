import 'dart:async';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'src/access_token.dart';
import 'src/login_result.dart';
export 'src/login_result.dart';
export 'src/access_token.dart';

class FacebookAuthLoginResponse {
  static const ok = 200;
  static const cancelled = 403;
  static const error = 500;
}

/// class used to login with facebook
class FacebookAuth {
  FacebookAuth._internal(); // private constructor for singletons
  final MethodChannel _channel = MethodChannel('ec.dina/flutter_facebook_auth');
  static FacebookAuth _instance = FacebookAuth._internal();

  static FacebookAuth get instance =>
      _instance; // return the same instance of FacebookAuth

  /// [permissions] permissions like ["email","public_profile"]
  Future<LoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
  }) async {
    final result =
        await _channel.invokeMethod("login", {"permissions": permissions});

    return LoginResult.fromJson(
      Map<String, dynamic>.from(result),
    ); // accessToken
  }

  /// [fields] string of fields like birthday,email,hometown
  Future<dynamic> getUserData({String fields = "name,email,picture"}) async {
    final result =
        await _channel.invokeMethod("getUserData", {"fields": fields});
    return Platform.isAndroid
        ? jsonDecode(result)
        : Map<String, dynamic>.from(result); //null  or dynamic data
  }

  /// Sign Out
  Future<void> logOut() async {
    await _channel.invokeMethod("logOut");
  }

  /// if the user is logged return one instance of AccessToken
  Future<AccessToken> get isLogged async {
    try {
      final result = await _channel.invokeMethod("isLogged");
      if (result != null) {
        return AccessToken.fromJson(Map<String, dynamic>.from(result));
      }
      return null;
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }
}
