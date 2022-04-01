import 'dart:io';
import 'package:blucash_client/tools/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final qrKey = GlobalKey(debugLabel: "QR");
  Barcode? barcode;
  QRViewController? controller;
  late String token = "";
  late bool showprogress;
  bool gotValidQR = false;

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
    });
  }

  void sendcode(String? code) async {
    var url = Uri.parse('https://www.blucash.net/client/identify');
    try {
      var response = await http.post(url, body: {'st': token, 'code': code});

      final jsondata = json.decode(response.body);
      print(jsondata);
      //         if (jsondata["status"] != 'true') {
      //           print('true');
      // print(jsondata);
      //           // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ScanResult(status: jsondata["status"])));
      //         } else {
      //            print('false');
      // print(jsondata);
      //             // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ScanResult(status: jsondata["status"])));
      //         }
    } catch (e) {
      print('cash error');
      //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScanResult(status: 'invalid')));
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white70,
                  size: 25.0,
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
              top: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Scanner le code QR',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Allez sur blucash.net/client/gerer ou",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  Text(
                    "web.blucash.net pour obtenir le code QR.",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.20,
              child: buildControlButtons(),
            ),
            Positioned(
              bottom: 10,
              child: buildResult(),
            ),
            // Positioned(top: 10, child: buildControlButtons()),
            // buildQrView(context),
            // Positioned(bottom: 10, child: buildResult()),
          ],
        ),
      ),
    );
  }

  Widget buildControlButtons() {
    return Container(
      height: 70,
      width: 70,
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
                  ? const Icon(Icons.flash_on, size: 40, color: Colors.white54)
                  : const Icon(
                      Icons.flash_off,
                      size: 40,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: showprogress
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(white),
              ),
            )
          : Text(
              barcode != null
                  ? "Résult : ${barcode!.code} \n Barcode Type: ${describeEnum(barcode!.format)}"
                  : "Scan a code !",
              maxLines: 3,
            ),
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 2,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.7,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        if (gotValidQR) {
          return;
        }
        gotValidQR = true;
        this.barcode = barcode;
        String? code = this.barcode!.code;
        if (checkcode(code)) {
          // print('true');
          // print(code);
          showprogress = true;
          //  await Future.delayed(const Duration(seconds: 2));
          // showprogress = false;
          sendcode(code);
        } else {
          // print('false');
          // print(code);
          showprogress = false;
        }
        gotValidQR = false;
      });
    });
  }
}
