import 'package:annapurna_finance/AppImages.dart';
import 'package:annapurna_finance/api_factory/prefs/pref_utils.dart';
import 'package:annapurna_finance/login/login_view.dart';
import 'package:annapurna_finance/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/providers.dart';
import '../widgets/ab_button.dart';
import '../widgets/ab_text_input.dart';

class ResetPassword extends ConsumerStatefulWidget {
  String userName;
  ResetPassword(this.userName);

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  String? inputtedValue;
  String? inputtedValue1;
  bool userInteracts() => inputtedValue != null;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidht = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView(),));
        return Future.value(false);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Image.asset(AppImages.waveOne, width: 300),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Image.asset(AppImages.waveTwo),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Image.asset(AppImages.logo, width: 250)),
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                            height: 440,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20))),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        top: 25.0, left: 15, bottom: 20),
                                    child: Text('Reset Password',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 15, bottom: 15),
                                    child: Text(
                                      "Please enter a minimum 8-character password with at least 1 upper case, 1 lower case and 1 special character ",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ABTextInput(

                                    autoValidator: AutovalidateMode.onUserInteraction,
                                    titleText: 'New Password',
                                    isPassword: _isObscure1,
                                    suffix: IconButton(
                                      color: ThemeColor.primary,
                                      icon: Icon(_isObscure1
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure1 = !_isObscure1;
                                        });
                                      },
                                    ),
                                    onChange: (value) => setState(() {
                                      inputtedValue = value;
                                      inputtedValue1 = value;
                                    } ),
                                    controller: _newPassController,
                                    hintText: 'Enter New Password',
                                  ),
                                  Padding(

                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: ABTextInput(
                                      autoValidator: AutovalidateMode.onUserInteraction,
                                      titleText: 'Confirm Password',
                                      isPassword: _isObscure2,
                                      suffix: IconButton(
                                        color: ThemeColor.primary,
                                        icon: Icon(_isObscure2
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure2 = !_isObscure2;
                                          });
                                        },
                                      ),
                                      validator: (value) {
                                        RegExp regex = RegExp(
                                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                        // if (inputtedValue != null && (value == null || value.isEmpty || inputtedValue1!.isEmpty)) {
                                        //   return 'Please enter password';
                                        // }
                                        // else if(inputtedValue != null &&_newPassController.text != value)
                                        // {
                                        //   return "Both password are not same";
                                        // }else
                                        //inputtedValue != null && (!regex.hasMatch(value!)) ||
                                          if (inputtedValue1 != null && (!regex.hasMatch(inputtedValue1!))) {
                                          return "Please enter a minimum 8-character password with at least 1 upper case, 1 lower case and 1 special character";
                                        } else if(inputtedValue != null &&_newPassController.text != value)
                                            {
                                              return "Your password doesn't match. Please re-enter";
                                            }
                                        return null;
                                      },
                                      onChange: (value) => setState(() => inputtedValue = value),
                                      controller: _confirmPassController,
                                      hintText: 'Enter Confirmed Password',
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 15.0),
                                  //   child: Row(
                                  //     children: [
                                  //       ref.watch(authenticationProvider).loginresult?SizedBox():Icon(Icons.error_outline,color: Colors.red),
                                  //       ref.watch(authenticationProvider).loginresult?SizedBox():Text("Please enter a minimum 8-character password with at least 1 upper case, 1 lower case and 1 special character",style: TextStyle(color: Colors.red)),
                                  //     ],
                                  //   ),
                                  // ),
                                  // (_newPassController.text != _confirmPassController.text) ?
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //       "Please enter a minimum 8-character password with at least 1 upper case, 1 lower case and 1 special character ",
                                  //       style: TextStyle(fontSize: 12,color: Colors.red)),
                                  // )
                                  //     : SizedBox(),
                                  ABButton(
                                    paddingTop:
                                        MediaQuery.of(context).size.height * 0.0225,
                                    paddingBottom: 15.0,
                                    paddingLeft: 20.0,
                                    paddingRight: 20.0,
                                    text: 'Save Password',
                                    onPressed: (!userInteracts() || _formKey.currentState == null || !_formKey.currentState!.validate()) ? null :() async {
                                      ref.watch(authenticationProvider).ForgotPasswordUpdateAPI(
                                        context: context,
                                        NewPassword: _newPassController.text,
                                        UserID: widget.userName,
                                      );
                                    },
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
