import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() => runApp(MyApp());

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _userData;
  AccessToken _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  _printCredentials(LoginResult result) {
    _accessToken = result.accessToken;
    print("userId: ${result.accessToken.userId}");
    print("token: ${prettyPrint(_accessToken.toJson())}");
    print("expires: ${result.accessToken.expires}");
    print("grantedPermission: ${result.accessToken.grantedPermissions}");
    print("declinedPermissions: ${result.accessToken.declinedPermissions}");
  }

  _checkIfIsLogged() async {
    final AccessToken accessToken = await FacebookAuth.instance.isLogged;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields:"email,birthday");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  _login() async {
    setState(() {
      _checking = true;
    });
    final result = await FacebookAuth.instance.login();
    // final result = await FacebookAuth.instance.login(permissions:['email','user_birthday']);

    _checking = false;
    switch (result.status) {
      case FacebookAuthLoginResponse.ok:
        _printCredentials(result);
        // get the user data
        final userData = await FacebookAuth.instance.getUserData();
        // final userData = await _fb.getUserData(fields:"email,birthday");
        _userData = userData;
        break;
      case FacebookAuthLoginResponse.cancelled:
        print("login cancelled");
        break;
      default:
        print("login failed");
    }

    setState(() {});
  }

  _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    setState(() {
      _userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Auth Example'),
        ),
        body: _checking
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _userData != null
                            ? prettyPrint(_userData)
                            : "NO LOGGED",
                      ),
                      SizedBox(height: 20),
                      _accessToken != null
                          ? Text(
                              prettyPrint(_accessToken.toJson()),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      CupertinoButton(
                        color: Colors.blue,
                        child: Text(
                          _userData != null ? "LOGOUT" : "LOGIN",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _userData != null ? _logOut : _login,
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
