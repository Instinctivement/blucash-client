import 'dart:convert';

import 'package:blucash_client/pages/scanerror.dart';
import 'package:blucash_client/tools/error.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blucash_client/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:blucash_client/pages/scanner.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool showAgent = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name = "", phone = "", code = "", business = "", balance = "", support = "", token = "";
  late String image = "", user = "", dateof = "", role = "", scanerror = "";
  String valueText = "";
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    showAgent = false;
    getCred();
    checkAgent();
    checkErrorScan();
  }

  void getCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!.replaceAll("\"", "");
      phone = prefs.getString("phone")!.replaceAll("\"", "");
      code = prefs.getString("code")!.replaceAll("\"", "");
      business = prefs.getString("business")!.replaceAll("\"", "");
      balance = prefs.getString("balance")!.replaceAll("\"", "");
      support = prefs.getString("support")!.replaceAll("\"", "");
      token = prefs.getString("login")!.replaceAll("\"", "");
    });
  }

  void getAgent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      image = prefs.getString("image")!.replaceAll("\"", "");
      user = prefs.getString("user")!.replaceAll("\"", "");
      dateof = prefs.getString("dateof")!.replaceAll("\"", "");
      role = prefs.getString("role")!.replaceAll("\"", "");
    });
  }

  void checkAgent() async {
    //here we will check if the user is alrady login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString("image");
    if (val != null) {
      getAgent();
      showAgent = true;
    } else {
      showAgent = false;
    }
  }

  void checkErrorScan() async {
    //here we will check if the user is alrady login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString("scanerror");
    if (val != null) {
      getErrorScan();
      _errorScanDialog(context);
      showAgent = false;
    }
  }

  void getErrorScan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      scanerror = prefs.getString("scanerror")!.replaceAll("\"", "");
    });
  }

  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: primary));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: primary,
          title: SizedBox(
            height: 70,
            width: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                'assets/icon/logo.png',
              ),
            ),
          ),
          actions: [
            IconButton(
          icon: const Icon(Icons.autorenew_rounded),
          tooltip: 'Rafraîchir',
          onPressed: () {
            setState(() {
              print('object');
            });
          },
        ),
          Theme(
            data: Theme.of(context).copyWith(
                // textTheme: const TextTheme().apply(),
                dividerColor: Colors.grey,
                iconTheme: const IconThemeData(color: Colors.white)),
            child: PopupMenuButton<int>(
              color: Colors.white,
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children:const [
                        Icon(
                          Icons.phone,
                          color: dark,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Assistance")
                      ],
                    ),
                ),
                PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children:const [
                        Icon(
                          Icons.help,
                          color: dark,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Aide")
                      ],
                    ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children:const [
                        Icon(
                          Icons.logout,
                          color: dark,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text("Déconnexion")
                      ],
                    ),
                ),
              ],
              onSelected: (item) => selectedItem(context, item),
            ),
          ),
        ],
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: white,
          ),
          padding:
              const EdgeInsets.only(top: 15.0, bottom: 10, left: 24, right: 24),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.work,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        business,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: container,
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Dette courante".toUpperCase(),
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                          Text(
                            balance,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.qr_code,
                                color: Colors.white,
                                size: 15.0,
                              ),
                              label: Text(
                                'Scanner'.toUpperCase(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const QrScanPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: primary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: Text(
                                'Saisir code'.toUpperCase(),
                                style: TextStyle(fontSize: 18, color: white),
                              ),
                              onPressed: () {
                                enterCode(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: secondary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
               Center(
                child: SizedBox(
                  child: showAgent ?
                  role == "agent" ? 
                  const Text(
                    "Agent Commercial",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                  :
                  const Text(
                    "Gestionnaire",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ):
                  const Text(
                    "Identification",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                  
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 120.0, vertical: 8),
                child: Container(
                  color: Colors.grey[100],
                  height: 2,
                ),
              ),
              showAgent ? isAgent(context) : defaultAgent(context),
              Container(
                height: 35,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                decoration: BoxDecoration(
                  color: container,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Vous êtes connecté en tant que :',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isVisible ? Colors.black : Colors.black,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isVisible ? Colors.black : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  "Blucash Client v1.125 — OPENXTECH SARL.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> enterCode(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        title: const Text('Entrer code agent'),
        content: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: TextField(
            controller: _textFieldController, //set pin controller
            style: const TextStyle(color: Colors.black45, fontSize: 20),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: 32,
            decoration: InputDecoration(
              hintText: 'Code...', //show label as placeholder
              hintStyle: TextStyle(
                  color: Colors.grey[500], fontSize: 20), //hint text style
              prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Icon(
                    Icons.lock,
                    color: Colors.grey[300],
                  )
                  //padding and icon for prefix
                  ),
              counter: const Offstage(),

              contentPadding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: const BorderSide(
                      color: dark, width: 1)), //default border of input

              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                  borderSide: const BorderSide(
                      color: Colors.blueAccent, width: 1)), //focus border

              fillColor: white,
              filled: true, //set true if you want to show input background
            ),
            onChanged: (value) {
              // change pin text
              setState(() {
                valueText = value;
              });
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Annuler'),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              verifyCode(valueText);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void verifyCode(String? code) async {
      if (_textFieldController.text.isNotEmpty) {
      var url = Uri.parse('https://www.blucash.net/client/identify/code');
        try {
          var response = await http.post(url, body: {'st': token, 'code': code});
          final jsondata = json.decode(response.body);
          if (jsondata["status"] == true) {
            String? val = image;
            if (val != "") {
              CachedNetworkImage.evictFromCache(image);
            }
            pageroute(jsondata["image"], jsondata["user"], jsondata["dateof"], jsondata["role"]);
          } else {
              String? errorM = errorMap[jsondata["error"]];
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (errorM != null) {
                prefs.setString("scanerror", json.encode(errorM));
              }
            Navigator.pop(context, 'Error');
          }
        } catch (e) {
          _internetDialog(context);
        }
      } else {
        emptyForm();
      }
  }

  Future<String?> emptyForm() {
    return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            title: const Text('Erreur'),
            content: const Text(
                'Remplir le formulaire !'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Annuler'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
  }
  

  void pageroute(String image, String user, String dateof, String role) async {
    saveSession(image, user, dateof, role);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  void saveSession(String image, String user, String dateof, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", json.encode(image));
    prefs.setString("user", json.encode(user));
    prefs.setString("dateof", json.encode(dateof));
    prefs.setString("role", json.encode(role));
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  static const String toLaunch = 'https://blucash.net';
  String phoneSuper = '+237656541861';
  Future<void>? launched;

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            title: const Text('Confirmation'),
            content: const Text(
                'Vous allez être redirigé.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Annuler'),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                    setState(() {
                          launched = _makePhoneCall(support);
                        });
                },
                child: const Text('Allez'),
              ),
            ],
          ),
        );
        break;
      case 1:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            title: const Text('Confirmation'),
            content: const Text(
                'Vous allez être redirigé.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Annuler'),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                    launched = _launchInBrowser(toLaunch);
                },
                child: const Text('Allez'),
              ),
            ],
          ),
        );
        break;
      case 2:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(0.0))),
            title: const Text('Confirmation'),
            content: const Text(
                'Vous êtes sur le point de vous déconnecter.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Annuler'),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () async {
                  await logOut(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;
    }
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    String? val = image;
    if (val != "") {
      CachedNetworkImage.evictFromCache(image);
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  Padding defaultAgent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 110,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 250, 249, 249),
                radius: 110,
                child: Icon(
                  Icons.qr_code,
                  size: 100,
                  color: Color.fromARGB(255, 224, 223, 223),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding isAgent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: container,
              radius: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(110.0),
                child: CachedNetworkImage(
                  // fit: BoxFit.contain,
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 110,
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 250, 249, 249),
                      radius: 110,
                      child: Icon(
                        Icons.error_outline_sharp,
                        size: 100,
                        color: Color.fromARGB(255, 189, 187, 187),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user,
                          style: const TextStyle(
                              fontSize: 26,
                              color: secondary,
                              fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.verified_rounded, size: 20, color: primary,),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Authentifié le $dateof",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _errorScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(scanerror),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('scanerror');
                  Navigator.pop(context, 'Annuler');
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
            title: const Text("Erreur de connexion"),
            content: const Text(
                "Vérifier votre connexion puis réessayer."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context, 'Annuler');
                },
              ),
            ],
          );
        },
      );
    }

}
