import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:annapurna_finance/api_factory/api.dart';
import 'package:annapurna_finance/api_factory/api_end_points.dart';
import 'package:annapurna_finance/api_factory/base_view_model.dart';
import 'package:annapurna_finance/api_factory/prefs/pref_utils.dart';
import 'package:annapurna_finance/api_factory/user_model.dart';
import 'package:annapurna_finance/common_webview.dart';
import 'package:annapurna_finance/login/login_view.dart';
import 'package:annapurna_finance/utils/utils.dart';
import 'package:flutter/material.dart';


class AuthenticationViewModel extends ChangeNotifier {
  UserModel? _kCurrentUser;


  UserModel? get kCurrentUser => _kCurrentUser;

  set kCurrentUser(UserModel? value) {
    _kCurrentUser = value;
    notifyListeners();
  }


  void onInit() async {
    kCurrentUser = await PrefUtils.getUser();
  }


  clearUser() {
    kCurrentUser = null;
    notifyListeners();
  }

  void loginAPI({
    required BuildContext context,
    required String userName,
    required String password,
  }) {
    var params = {
      "UserID": userName,
      "Password": password,
      "MACID":"451236786",
      "Version":"4.0",
      "Flag":"C"
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.login,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {
        print(response);
        if (response['status'] != false) {
          showSuccessSnackbar(response['message'], context);
          PrefUtils.setUserid(userName);
          userDetail(context: context, userName: userName);

        }else{

          handleApiError(response['message'], context);

        }

      },
    );
  }
  void forgotPasswordAPI({
    required BuildContext context,
    required String userName,
    required String MobileNumber,

  }) {
    var params = {
      "UserID": userName,
      "MoblieNumber": MobileNumber,

    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.ForgotPassword,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        if (response['status'] != false) {
          showSuccessSnackbar(response['message'], context);

          PrefUtils.clearPrefs();
          Navigator.pop(context);
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(
          //       builder: (context) {
          //         return LoginView();
          //       },
          //     ));
        }else{

          handleApiError(response['message'], context);

        }

      },
    );
  }
  void OTPVerificationAPI({
    required BuildContext context,
    required String userName,
    required String Phoneno,
    required String OTPNO,
  }) {
    var params = {
      "UserID": userName,
      "MoblieNumber": Phoneno,
      "OTPNO" : OTPNO,

    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.OTP,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        if (response['status'] != false) {
          showSuccessSnackbar(response['message'], context);

          PrefUtils.setUserid(userName);
          PrefUtils.setMobileNumber(Phoneno);
          PrefUtils.setOTP(OTPNO);

          PrefUtils.clearPrefs();
          // Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginView();
                },
              ));
        }else{

          handleApiError(response['message'], context);

        }

      },
    );
  }

  void userDetail({
    required BuildContext context,
    required String userName
  }) {
    var params = {
      "UserID": userName,
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.userDetail,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        if (response['status'] != "False") {
          var userModel = UserModel.fromJson(response);
          print(userModel);
          PrefUtils.setUser(jsonEncode(userModel));
          kCurrentUser=userModel;
          notifyListeners();
          //
          String userID = response['USERID'];
          String url = '';

          if (response['UserRole'] == 'STAFF') {
            url = 'http://maximoglobalsystems.com/landing/staff/$userID';
          } else if (response['UserRole'] == 'BM') {
            url = 'http://maximoglobalsystems.com/landing/bm/$userID';
          } else if (response['UserRole'] == 'ZM') {
            url = 'http://maximoglobalsystems.com/landing/zm/$userID';
          } else {
            url = 'http://maximoglobalsystems.com/landing/zm/$userID';
          }

          log('------------------------------$url       ${response['UserRole']}');
          PrefUtils.setIsLoggedIn(true);
          PrefUtils.setUrl(url);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CommonWebView(url: url),
              ));

        } else {
          handleApiError(response['message'], context);
        }

        notifyListeners();

      },
    );
  }


  void logout({
    required BuildContext context,
    required String userName
  }) {
    var params = {
      "UserId": userName,
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.logout,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {


      },
    );
  }


}
