import 'package:annapurna_finance/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerScreen extends StatefulWidget {
  @override
  _PermissionHandlerScreenState createState() =>
      _PermissionHandlerScreenState();
}

class _PermissionHandlerScreenState extends State<PermissionHandlerScreen> {
  @override
  void initState() {
    super.initState();
    permissionServiceCall();
  }

  permissionServiceCall() async {
    await permissionServices().then(
          (value) {
        if (value != null) {
          if (
              value[Permission.camera]!.isGranted ) {
            /* ========= New Screen Added  ============= */

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SplashView()),
            );
          }
        }
      },
    );
  }

  /*Permission services*/
  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      //add more permission to request here.
    ].request();



    if (statuses[Permission.camera]!.isPermanentlyDenied) {
      await openAppSettings().then(
            (value) async {
          if (value) {
            if (await Permission.camera.status.isPermanentlyDenied == true &&
                await Permission.camera.status.isGranted == false) {
              openAppSettings();
              // permissionServiceCall(); /* opens app settings until permission is granted */
            }
          }
        },
      );
      //openAppSettings();
      //setState(() {});
    } else {
      if (statuses[Permission.camera]!.isDenied) {
        permissionServiceCall();
      }
    }
    /*{Permission.camera: PermissionStatus.granted, Permission.storage: PermissionStatus.granted}*/
    return statuses;
  }

  @override
  Widget build(BuildContext context) {
    permissionServiceCall();
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          child: Center(
            child: InkWell(
                onTap: () {
                  permissionServiceCall();
                },
                child: Text("Click here to enable Enable Permission Screen")),
          ),
        ),
      ),
    );
  }
}