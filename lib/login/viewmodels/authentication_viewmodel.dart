import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:annapurna_finance/AppImages.dart';
import 'package:annapurna_finance/api_factory/api.dart';
import 'package:annapurna_finance/api_factory/api_end_points.dart';
import 'package:annapurna_finance/api_factory/base_view_model.dart';
import 'package:annapurna_finance/api_factory/prefs/pref_utils.dart';
import 'package:annapurna_finance/api_factory/user_model.dart';
import 'package:annapurna_finance/common_webview.dart';
import 'package:annapurna_finance/forgot_password/forgotPasswordPage.dart';
import 'package:annapurna_finance/login/login_view.dart';
import 'package:annapurna_finance/reset_password/resetPassword.dart';
import 'package:annapurna_finance/utils/utils.dart';
import 'package:flutter/material.dart';


class AuthenticationViewModel extends ChangeNotifier {
  UserModel? _kCurrentUser;

  int noofotpsend=3;
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

  bool loginresult=true;
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
          loginresult=true;
        }else{
          loginresult=false;
          // handleApiError(response['message'], context);
        }
        notifyListeners();

      },
    );
  }
  void sendotpAPI({
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
      path: ApiEndPoints.sendotp,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {
        myDialog(context, AppImages.done, "OTP Sent Successfully!","Okay", 200, 200,press:(){
          Navigator.pop(context);
        });
        print(response);
        if(noofotpsend<1)
          {
            noofotpsend=noofotpsend-1;
          }
        notifyListeners();
        // if (response['status'] != false) {
        //   showSuccessSnackbar(response['message'], context);
        //
        //   PrefUtils.clearPrefs();
        //   Navigator.pop(context);
        //   // Navigator.pushReplacement(context,
        //   //     MaterialPageRoute(
        //   //       builder: (context) {
        //   //         return LoginView();
        //   //       },
        //   //     ));
        // }else{
        //
        //   handleApiError(response['message'], context);
        //
        // }

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
      path: ApiEndPoints.ForgotPasswordOTPVerificagtion,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        if(response['ForgotPasswordOTPVerificagtionData'][0]['status']!="False")
          {
            Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResetPassword();
                        },
                      ));
          }
        else
          {
            Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResetPassword();
                        },
                      ));
          }
        // if (response['status'] != false) {
        //   showSuccessSnackbar(response['message'], context);
        //
        //   PrefUtils.setUserid(userName);
        //   PrefUtils.setMobileNumber(Phoneno);
        //   PrefUtils.setOTP(OTPNO);
        //
        //   PrefUtils.clearPrefs();
        //   // Navigator.pop(context);
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return LoginView();
        //         },
        //       ));
        // }else{
        //
        //   handleApiError(response['message'], context);
        //
        // }

      },
    );
  }
  void changePasswordAPI({
    required BuildContext context,
    required String userName,
    required String ConfirmPassword,
    required String NewPassword,
  }) {
    var params = {
      "UserID": userName,
      "NewPassword": NewPassword,
      "ConfirmPassword" : ConfirmPassword,

    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.ForgotPasswordUpdate,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        // if (response['status'] != false) {
        //   showSuccessSnackbar(response['message'], context);
        //
        //   PrefUtils.setUserid(userName);
        //   PrefUtils.setMobileNumber(Phoneno);
        //   PrefUtils.setOTP(OTPNO);
        //
        //   PrefUtils.clearPrefs();
        //   // Navigator.pop(context);
        //   Navigator.pushReplacement(context,
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return LoginView();
        //         },
        //       ));
        // }else{
        //
        //   handleApiError(response['message'], context);
        //
        // }

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
