import 'package:shared_preferences/shared_preferences.dart';

class SPApp {
  // SP means Shared Preference
  static String sPUserLoggedInKey = 'isLoggedIn';
  static String sPUserNameKey = 'userNameKey';
  static String sPUserIdKey = 'userIdKey';
  static String sPUserEmailKey = 'userEmailKey';
  static String sPUserImageUrlKey = 'userImageUrlKey';
  static String sPUserRole = 'userRole';
  static String sPUtoken= 'token';

  //saving data to shared preference

  static Future<bool> saveUserLoggedInSP(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sPUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSP(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sPUserNameKey, userName);
  }

  static Future<void> saveUserIdSP(String userIdKey) async {
    print('Saving saveUserIdSP: $userIdKey');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sPUserIdKey, userIdKey);
  }

  static Future<void> saveUserEmailSP(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sPUserEmailKey, userEmail);
  }

  static Future<void> saveUserImageUrlSP(String userImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sPUserImageUrlKey, userImage);
  }
  static Future<void> saveToken(String token) async {
    // print('Saving token: $token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sPUtoken, token);
  }

//getting data from shared preference
  static Future<bool> getUserLoggedInSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sPUserLoggedInKey);
  }

  static Future<String> getUserNameSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sPUserNameKey);
  }

  static Future<String> getUserIdSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sPUserIdKey);
  }

  static Future<String> getUserEmailSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sPUserEmailKey);
  }

  static Future<String> getUserImageUrlSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sPUserImageUrlKey);
  }
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('Getting token');

    // print('Get token: ${prefs.getString(sPUtoken)}');
    return prefs.getString(sPUtoken);
  }
}
