import 'package:tuple/tuple.dart';

import '../models/user_model.dart';
import 'client.dart';
import '../utils/storage.dart';

class AuthService {
  final Network _client = Network();

  Future<bool> signUp({required UserModel newUser}) async {
    try {
      String endPoint = "/auth/signUp";
      Response response =
          await _client.post(endPoint: endPoint, data: newUser.toMap());
      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.data != null && response.data['msg'] != null) {
          throw "${response.data['msg']}";
        } else {
          throw "Error during Reset Password";
        }
      }
    } catch (e) {
      throw "Error during signup: $e";
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      String endPoint = "/auth/login";
      Map<String, dynamic> data = {"email": email, "password": password};

      Response response = await _client.post(endPoint: endPoint, data: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        data.forEach((key, value) async {
          await SecureStorage.instance.write(key: key, value: value);
        });

        return true;
      } else {
        if (response.data != null && response.data['msg'] != null) {
          throw "${response.data['msg']}";
        } else {
          throw "Error during Reset Password";
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> getUserData() async {
    try {
      String endPoint = "/auth/getUserData";
      String? token = await SecureStorage.instance.read("token");

      if (token == null) {
        throw "No authentication token found.";
      }

      Map<String, dynamic> headers = {"auth_token": token};
      Response response =
          await _client.get(endPoint: endPoint, headerData: headers);

      if (response.statusCode == 200) {
        return UserModel.fromMap(response.data);
      } else {
        if (response.data != null && response.data['msg'] != null) {
          throw "${response.data['msg']}";
        } else {
          throw "Error during Reset Password";
        }
      }
    } catch (e) {
      throw "Error fetching user data: $e";
    }
  }

  Future<bool> signOut() async {
    try {
      await SecureStorage.instance.deleteAll();
      return true;
    } catch (e) {
      throw "Error during sign out: $e";
    }
  }

  Future<Tuple2<bool, String>> forgotPassword({required String email}) async {
    try {
      String endPoint = "/auth/forgotPassword";
      Map<String, dynamic> data = {"email": email};
      Response response = await _client.post(endPoint: endPoint, data: data);
      if (response.statusCode == 200) {
        return Tuple2(true, response.data['otp'].toString());
      } else {
        if (response.data != null && response.data['msg'] != null) {
          throw response.data['msg'];
        }
        throw "Error during Forgot Password";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword(
      {required String email, required String newPassword}) async {
    try {
      String endPoint = "/auth/resetPassword";
      Map<String, dynamic> data = {"email": email, "newPassword": newPassword};
      Response response = await _client.post(endPoint: endPoint, data: data);
      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.data != null && response.data['msg'] != null) {
          throw "${response.data['msg']}";
        } else {
          throw "Error during Reset Password";
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
