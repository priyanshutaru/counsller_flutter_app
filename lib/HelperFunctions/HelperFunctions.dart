import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = 'LOGGEDIN';
  static String saveUserID = 'UserId';
  static String saveUserNumber = 'UserNumber';
  static String saveUserEmail = 'UserEmail';
  static String saveUserName = 'UserName';
  static String saveCounter = 'cartCount';
  static String userCity = 'City';

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isuserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isuserLoggedIn);
  }

  static Future saveuserID(String isuserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(saveUserID, isuserId);
  }

  static Future savedNumber(String isuserNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(saveUserNumber, isuserNumber);
  }

  static Future savedEmail(String isuserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(saveUserEmail, isuserEmail);
  }

  static Future savedName(String isuserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(saveUserName, isuserName);
  }

  static Future CartCount(String cartCounter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(saveCounter, cartCounter);
  }

  static Future SaveCity(String City) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userCity, City);
  }

  //getting data
  static Future<bool?> getuserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(saveUserID);
  }

  static Future<String?> getUserNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(saveUserNumber);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(saveUserEmail);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(saveUserName);
  }

  static Future getCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(saveCounter);
  }

  static Future getCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userCity);
  }
}
