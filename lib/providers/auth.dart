import 'dart:convert';
import 'dart:async';
import 'package:academind_api_rest/utils/constants.dart';

import '../utils/shared_preferences.dart';
import '../widgets/toast/toast.dart';
import 'package:intl/intl.dart';
import '../utils/api_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token, _role, _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get role {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    //TODO добавить защитный механизм для аутентификации приложения =>
    //TODO '${APIConstants
    //TODO     .mainUrl}$urlSegment?key=AIzaSyC13spCwP_f_SalxEbkB-wjedoF8iYENlQ');
    //
    final url = Uri.parse('$urlSegment');
    print('Authenticating');
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      print(url);
      print(email);
      print(password);
      flutterToast('TRYING Authenticating');

      final response = await http.post(url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              //TODO check if it is needed
              // 'returnSecureToken': true,
            },
          ),
          headers: headers);
      final responseData = json.decode(response.body);
      if (response.statusCode != 200) {
        //TODO: handle exceptions
        flutterToast(responseData['message']);
        // throw HttpException(responseData['message']);
        return;
      }
      flutterToast('Success');
      _token = responseData['token'];
      _userId = responseData['userId'];
      var jwt = JsonWebToken.unverified(_token);
      print('1');
      Constants.role = jwt.claims['role'];
      print('USER ROLE: ${Constants.role}');
      _expiryDate =
          DateTime.fromMillisecondsSinceEpoch(jwt.claims['exp'] * 1000);
      // print('EXPIRY: ${_expiryDate}');
      _autoLogout();
      //TODO: add expire date, and user ROLE
      // SPApp.saveUserIdSP(_userId);
      notifyListeners();
      flutterToast('Access Granted');
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      SPApp.saveToken(_token);
      SPApp.saveUserIdSP(_userId);

      await prefs.setString('userData', userData);

      final String userdata = prefs.getString('userData');

      print('LAST STEP, is to check userData: $userData');
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, '${APIConstants.createUser}');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, '${APIConstants.authenticate}');
  }

  Future<bool> tryAutoLogin() async {
    //TODO: delete userData and handle in another way
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    // print('prefs.containsKey = TRUE');
    print(json.decode(prefs.getString('userData')) as Map<String, Object>);
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    // print(extractedUserData['userId']);
    // print("TOKEN IS: $_token");
    var jwt = JsonWebToken.unverified(extractedUserData['token']);
    // print('claims: ${jwt.claims['role']}');
    // print('claims: ${jwt.claims}');
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry =
        _expiryDate.difference(DateTime.now()).inSeconds / 86400;
    final int exp = timeToExpiry.toInt();
    if (exp >= 10) {
      final expires = 10;
      _authTimer = Timer(Duration(days: expires), logout);
    } else {
      _authTimer = Timer(Duration(days: exp), logout);
    }
  }
}
