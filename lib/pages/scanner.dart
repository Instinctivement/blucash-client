import 'dart:convert';
import 'dart:io';
import 'package:blucash_client/pages/homepage.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:blucash_client/tools/error.dart';
import 'package:blucash_client/tools/size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  Barcode? result;
  QRViewController? controller;
  late String token = "";
  late String imageS = "";
  late bool showprogress;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    showprogress = false;
    getCred();
  }

  void getCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("login")!.replaceAll("\"", "");
      imageS = prefs.getString("imageS")!.replaceAll("\"", "");
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void sendcode(String? code) async {
    var url = Uri.parse('https://www.blucash.net/client/identify/qr');
     try {
       var response = await http.post(url, body: {'st': token, 'code': code});

       final jsondata = json.decode(response.body);
       if (jsondata["status"] == 'true') {
         String? val = imageS;
         if (val != "") {
           CachedNetworkImage.evictFromCache(imageS);
         }
         pageroute(jsondata["image"], jsondata["user"], jsondata["dateof"], jsondata["role"], jsondata["assigned"]);
       } 
       else {
         String? errorM = errorMap[jsondata["error"]];
         SharedPreferences prefs = await SharedPreferences.getInstance();
         if (errorM != null) {
          prefs.setString("scanerror", json.encode(errorM));
         }
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()),(route) => false);
       }
     } catch (e) {
       _internetDialog(context);
     }
  }

  void pageroute(String imageS, String userS, String dateofS, String roleS, String assignedS) async {
    saveSession(imageS, userS, dateofS, roleS, assignedS);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomePage()),(route) => false);
  }

  void saveSession(String imageS, String userS, String dateofS, String roleS, String assignedS) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("imageS", json.encode(imageS));
    prefs.setString("userS", json.encode(userS));
    prefs.setString("dateofS", json.encode(dateofS));
    prefs.setString("roleS", json.encode(roleS));
    prefs.setString("assignedS", json.encode(assignedS));
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQr() async {
    if (result != null) {
      String? code = result!.code;
      if (checkcode(code)) {
        showprogress = true;
        Vibration.vibrate(duration: 100);
        controller!.pauseCamera();
        controller!.dispose();
        sendcode(code);
      } else {
        showprogress = true;
        Vibration.vibrate(duration: 100);
        controller!.pauseCamera();
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _showDialog(context);
        });
      }
        controller!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    readQr();
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.passthrough,
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
              top: 5,
              left: 10,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white70,
                  size: SizeConfig.devicePixelRatio > 3.0 ? 20.0 : 25.0,
                ),
                label: const Text(
                  'Retour',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
              ),
            ),
            Positioned(
              top: SizeConfig.devicePixelRatio > 3.0 ? MediaQuery.of(context).size.height * 0.15 : MediaQuery.of(context).size.height * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Scanner le code QR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.devicePixelRatio > 3.0 ? 18.0 : 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Demandez à l'agent de présenter",
                    style: TextStyle(color: Colors.white70, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 12.0 : 18.0,),
                  ),
                 Text(
                   "son code d'identification",
                   style: TextStyle(color: Colors.white70, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 12.0 : 15.0,),
                 ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              child: buildControlButtons(),
            ),
            Positioned(
              bottom: 10,
              child: buildResult(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 2,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: SizeConfig.devicePixelRatio > 3.0 ? MediaQuery.of(context).size.width * 0.66 : MediaQuery.of(context).size.width * 0.7,
      ),
    );
  }

  Widget buildControlButtons() {
    return Container(
      height: SizeConfig.devicePixelRatio > 3.0 ? 60.0 : 70.0,
      width: SizeConfig.devicePixelRatio > 3.0 ? 60.0 : 70.0,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white24,
      ),
      child: IconButton(
        onPressed: () async {
          await controller?.toggleFlash();
          setState(() {});
        },
        icon: FutureBuilder<bool?>(
          future: controller?.getFlashStatus(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return snapshot.data!
                  ?  Icon(Icons.flash_on, size: SizeConfig.devicePixelRatio > 3.0 ? 30.0 : 40.0, color: Colors.white54)
                  :  Icon(
                      Icons.flash_off,
                      size: SizeConfig.devicePixelRatio > 3.0 ? 30.0 : 40.0,
                      color: Colors.white24,
                    );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget buildResult() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white24,
      ),
      child: showprogress
          ? SizedBox(
              height: SizeConfig.devicePixelRatio > 3.0 ? 20.0 : 24.0,
              width: SizeConfig.devicePixelRatio > 3.0 ? 20.0 : 24.0,
              child: const CircularProgressIndicator(
                strokeWidth: 2.0,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(white),
              ),
            )
          : Text(
              result != null
                  ? "role: ${describeEnum(result!.format)}"
                  : "Rapprochez la camera du Code",
                  style: TextStyle(fontSize: SizeConfig.devicePixelRatio > 3.0 ? 10.0 : 14.0,),
            ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          title: const Text("Qr Code Erroné"),
          content: const Text(
              "Ceci n'est pas un Qr Code valide, merci de réessayer."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _internetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          title: const Text("Erreur de connexion"),
          content: const Text(
              "Vérifier votre connexion puis réessayer."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
