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
import 'package:annapurna_finance/constants.dart';
import 'package:annapurna_finance/forgot_password/forgotPasswordPage.dart';
import 'package:annapurna_finance/login/login_view.dart';
import 'package:annapurna_finance/reset_password/resetPassword.dart';
import 'package:annapurna_finance/utils/theme_config.dart';
import 'package:annapurna_finance/utils/utils.dart';
import 'package:flutter/material.dart';


class AuthenticationViewModel extends ChangeNotifier {
  UserModel? _kCurrentUser;

  bool otpsend=false;
  String _otperror="";
  int noofotpsend=30;
  UserModel? get kCurrentUser => _kCurrentUser;

  String get otperror => _otperror;

  set otperror(String value) {
    _otperror = value;
  }

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
  bool resetloginresult=true;
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

        if(response['RestPasswordOTPsendDetails'][0]['status']!="False")
          {
            myDialog(context, AppImages.done, "OTP Sent Successfully!","Okay", 200, 200,press:(){
              otpsend=true;
              print(response);
              if(noofotpsend>=1)
              {
                noofotpsend=noofotpsend-1;
              }
              notifyListeners();
              Navigator.pop(context);
            });

          }
        else
          {
            otperror=response['RestPasswordOTPsendDetails'][0]['Message'];
            otpsend=false;

          }
        notifyListeners();
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
      "OTP" : OTPNO,

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
            myDialog(context,"assets/Done.png", "${response['ForgotPasswordOTPVerificagtionData'][0]['Message']}","Okay", 270, 200,press:(){
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ResetPassword(userName);
                    },
                  ), (route) => false);
            });


          }
        else
          {
            myDialog(context,"assets/alert.png", "${response['ForgotPasswordOTPVerificagtionData'][0]['Message']}","Okay", 270, 200,press:(){
              Navigator.pop(context);
            });
            // Navigator.push(context,
            //           MaterialPageRoute(
            //             builder: (context) {
            //               return ResetPassword();
            //             },
            //           ));
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
        //   Navigator.pushAndRemoveUntil(context,
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
    required String OldPassword,
    required String NewPassword,
  }) {
    var params = {
      "UserID": kCurrentUser!.userid,
      "OldPassword": OldPassword,
      "NewPassword": NewPassword
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.ChangePassword,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        if(response['ChangePasswordData'][0]['status']!="False")
          {
            resetloginresult=true;
            showDialog(context: context, builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Container(
                  height: 270,
                  width: 150,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(AppImages.done,height: 70,width: 70,),
                      Padding(
                        padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                        child: Text("Your Password has been updated successfully",textAlign: TextAlign.center,),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                              child: ElevatedButton(onPressed: () async {
                                PrefUtils.clearPrefs();

                                // String url = await PrefUtils.getUrl() ?? '';
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginView(),
                                    ),(route) => false);
                              }, style:  ElevatedButton.styleFrom(
                                backgroundColor: ThemeColor.primary,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: ThemeColor.primary),
                              ),child: Text("Back to Home",)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },);
          }
        else
          {
            resetloginresult=false;
            showDialog(context: context, builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Container(
                  height: 270,
                  width: 150,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/alert.png",height: 70,width: 70,),
                      Padding(
                        padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                        child: Text("${response['ChangePasswordData'][0]['Message']}",textAlign: TextAlign.center,),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                              child: ElevatedButton(onPressed: () {
                                Navigator.pop(context);
                              }, style:  ElevatedButton.styleFrom(
                                backgroundColor: ThemeColor.primary,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: ThemeColor.primary),
                              ),child: Text("Please Try Again",)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },);
          }
        notifyListeners();


      },
    );
  }
  void ForgotPasswordUpdateAPI({
    required BuildContext context,
    required String UserID,
    required String NewPassword,
  }) {
    var params = {
      "UserID": UserID,
      "NewPassword": NewPassword
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.ForgotPasswordUpdate,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {

        print(response);
        if(response['ForgotPasswordUpdateDetails'][0]['status']!="False")
          {
            resetloginresult=true;
            showDialog(context: context, builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Container(
                  height: 270,
                  width: 150,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(AppImages.done,height: 70,width: 70,),
                      Padding(
                        padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                        child: Text("Your Password has been updated successfully",textAlign: TextAlign.center,),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                              child: ElevatedButton(onPressed: () async {
                                // String url = await PrefUtils.getUrl() ?? '';
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginView(),
                                    ),(route) => false,);
                              }, style:  ElevatedButton.styleFrom(
                                backgroundColor: ThemeColor.primary,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: ThemeColor.primary),
                              ),child: Text("Ok",)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },);
          }
        else
          {
            resetloginresult=false;
            showDialog(context: context, builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Container(
                  height: 270,
                  width: 150,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset("assets/alert.png",height: 70,width: 70,),
                      Padding(
                        padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                        child: Text("${response['ForgotPasswordUpdateDetails'][0]['Message']}",textAlign: TextAlign.center,),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: defaultPadding,right: defaultPadding),
                              child: ElevatedButton(onPressed: () {
                                Navigator.pop(context);
                              }, style:  ElevatedButton.styleFrom(
                                backgroundColor: ThemeColor.primary,
                                foregroundColor: Colors.white,
                                side: BorderSide(color: ThemeColor.primary),
                              ),child: Text("Please Try Again",)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },);
          }
        notifyListeners();


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

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => CommonWebView(url: url),
              ),(route) => false);

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
