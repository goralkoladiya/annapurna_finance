import 'package:annapurna_finance/AppImages.dart';
import 'package:annapurna_finance/api_factory/prefs/pref_utils.dart';
import 'package:annapurna_finance/utils/theme_config.dart';
import 'package:annapurna_finance/utils/utils.dart';
import 'package:annapurna_finance/widgets/ab_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../notifier/providers.dart';
import '../widgets/ab_text_input.dart';

class changePassword extends ConsumerStatefulWidget {
  const changePassword({Key? key}) : super(key: key);

  @override
  ConsumerState<changePassword> createState() => _changePasswordState();
}

class _changePasswordState extends ConsumerState<changePassword> {
  TextEditingController oldpass=TextEditingController();
  TextEditingController newpass=TextEditingController();
  TextEditingController confirmpass=TextEditingController();
  bool isObsecure = true;
  bool isObsecure2 = true;
  bool isObsecure3 = true;
  final _formKey = GlobalKey<FormState>();
  // recording fieldInput
  String? inputtedValue;

  // you can add more fields if needed
  bool userInteracts() => inputtedValue != null;
  @override
  Widget build(BuildContext context) {
    double theight=MediaQuery.of(context).size.height;
    double twidth=MediaQuery.of(context).size.width;
    double statusbar=MediaQuery.of(context).padding.top;
    double navbar=MediaQuery.of(context).padding.bottom;
    double bheight=theight-statusbar-navbar;
    return Scaffold(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:Icon(Icons.arrow_back,color: Colors.black),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    Center(child: Image.asset(AppImages.logo, width: 250)),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                          height: 510,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 25.0, left: 15, bottom: 20),
                                child: Text('Change Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15, bottom: 15),
                                child: Text(
                                  "Please enter a minimum 8-character password with at least 1 upper case, 1 lower case, and 1 special character",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              ABTextInput(
                                iserror: ref.watch(authenticationProvider).loginresult?null:Colors.red,
                                onChange: (value) => setState(() => inputtedValue = value),
                                controller: oldpass,
                                titleText: 'Old Password',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter old password';
                                  }
                                  return null;
                                },
                                hintText: 'Enter Old Password',
                                isPassword: isObsecure,
                                suffix: IconButton(
                                  color: ThemeColor.primary,
                                  icon: Icon(isObsecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isObsecure = !isObsecure;
                                    });
                                  },
                                ),
                              ),
                              ABTextInput(
                                iserror: ref.watch(authenticationProvider).loginresult?null:Colors.red,
                                onChange: (value) => setState(() => inputtedValue = value),
                                controller: newpass,
                                autoValidator: AutovalidateMode.onUserInteraction,
                                titleText: 'New Password',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter new password';
                                  }
                                  return null;
                                },
                                isPassword: isObsecure2,
                                suffix: IconButton(
                                  color: ThemeColor.primary,
                                  icon: Icon(isObsecure2
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isObsecure2 = !isObsecure2;
                                    });
                                  },
                                ),
                                hintText: 'Enter New Password',
                              ),
                              ABTextInput(
                                iserror: ref.watch(authenticationProvider).loginresult?null:Colors.red,
                                onChange: (value) => setState(() => inputtedValue = value),
                                controller: confirmpass,
                                autoValidator: AutovalidateMode.onUserInteraction,
                                titleText: 'Confirm Password',
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please Confirm password";
                                  }
                                  else if(val == null || val.isEmpty || val!=newpass.text)
                                    {
                                      return "New Password and Confirm Password should be same";
                                    }
                                  return null;
                                },
                                hintText: 'Enter New Password',
                                isPassword: isObsecure3,
                                suffix: IconButton(
                                  color: ThemeColor.primary,
                                  icon: Icon(isObsecure3
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isObsecure3 = !isObsecure3;
                                    });
                                  },
                                ),
                              ),
                              ABButton(
                                paddingTop:
                                MediaQuery.of(context).size.height * 0.0225,
                                paddingBottom: 15.0,
                                paddingLeft: 16.0,
                                paddingRight: 16.0,
                                text: 'Update',
                                onPressed: (!userInteracts() || _formKey.currentState == null || !_formKey.currentState!.validate()) ? null :() async {

                                  FocusManager.instance.primaryFocus?.unfocus();
                                  String userid=await PrefUtils.getUserId()??'';
                                  ref.watch(authenticationProvider).changePasswordAPI(
                                    context: context,
                                    // userName: userid,
                                    OldPassword: oldpass.text,
                                    NewPassword: newpass.text,
                                  );
                                },
                              )
                            ],
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
