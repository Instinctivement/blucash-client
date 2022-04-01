import 'dart:io';
import 'package:blucash_client/pages/scanresult.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:blucash_client/tools/header.dart';
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
  late String token="";
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
            var response = await http.post(url, body: {'st':token, 'code': code});
          
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
          alignment: Alignment.center,
          children: [
            Positioned(top: 10, child: buildControlButtons()),
            buildQrView(context),
            Positioned(bottom: 10, child: buildResult()),
          ],
        ),
      ),
    );
  }

  Widget buildControlButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Container(
        color: Colors.yellow,
        height: 100,
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return snapshot.data!
                        ? const Icon(Icons.flash_on)
                        : const Icon(Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return const Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
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
      child:showprogress
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
        barcode != null ? "Résult : ${barcode!.code} \n Barcode Type: ${describeEnum(barcode!.format)}"    : "Scan a code !",
        maxLines: 3,
        
      ),
      
      
       
    );
  }

  Widget buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.greenAccent,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {  
      
      setState(()  {  
        if(gotValidQR) {
      return;
    }
    gotValidQR = true;
        this.barcode = barcode;
        String? code= this.barcode!.code;
        if (checkcode(code)) {
          // print('true');
          // print(code);
            showprogress = true;
          //  await Future.delayed(const Duration(seconds: 2));
            // showprogress = false;
           sendcode(code);
        }else{
          // print('false');
          // print(code);
          showprogress = false;
        }
        gotValidQR  = false;
      });
    });
  }
}
