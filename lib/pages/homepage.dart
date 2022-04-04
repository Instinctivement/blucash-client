import 'dart:convert';

import 'package:blucash_client/method/creditation.dart';
import 'package:blucash_client/pages/scanerror.dart';
import 'package:blucash_client/pages/scansuccess.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blucash_client/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:blucash_client/pages/scanner.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool showAgent = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name = "",
      phone = "",
      code = "",
      business = "",
      balance = "",
      token = "";

  bool isVisible = true;
  late String imgAgent, agent = "", date = "";

  @override
  void initState() {
    super.initState();
    showAgent = false;
    getCred();
    getAgent();
    checkAgent();
  }

  void getCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!.replaceAll("\"", "");
      phone = prefs.getString("phone")!.replaceAll("\"", "");
      code = prefs.getString("code")!.replaceAll("\"", "");
      business = prefs.getString("business")!.replaceAll("\"", "");
      balance = prefs.getString("balance")!.replaceAll("\"", "");
      token = prefs.getString("login")!.replaceAll("\"", "");
    });
  }

  void getAgent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imgAgent = prefs.getString("imgAgent")!.replaceAll("\"", "");
      agent = prefs.getString("agent")!.replaceAll("\"", "");
      date = prefs.getString("date")!.replaceAll("\"", "");
    });
  }

  void checkAgent() async {
    //here we will check if the user is alrady login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString("imgAgent");
    if (val != null) {
      showAgent = true;
    } else {
      showAgent = false;
    }
  }

  final TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                'Entrer code agent',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: primary,
                ),
              ),
            ),
            content: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: TextField(
                controller: _textFieldController, //set pin controller
                style: const TextStyle(color: Colors.black45, fontSize: 20),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                obscureText: true,
                maxLength: 32,
                decoration: InputDecoration(
                  hintText: 'PIN', //show label as placeholder
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
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Annuler'.toUpperCase(),
                      style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Valider'.toUpperCase(),
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  String valueText = "";

  void _showDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const Text('AlertDialog description'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: primary));
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Hero(
                tag: "logo",
                child: Image.asset(
                  'assets/white.png',
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                color: Colors.white,
                onPressed: () {}),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: TextButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
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
                  },
                  child: const Text(
                    "Quitter",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400),
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ), //set minimum height equal to 100% of VH
        
            width: MediaQuery.of(context).size.width,
            //make width of outer wrapper to 100%
            decoration: BoxDecoration(
              color: white,
            ), //show linear gradient background of page
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
                  // height: MediaQuery.of(context).size.height * 0.22,
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
                              "Solde courant".toUpperCase(),
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
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         const ScanSuccess()));
                                  enterCode(context);
                                  //  _displayTextInputDialog(context);
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
                const Center(
                  child: SizedBox(
                    child: Text(
                      "Dernière Identification",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
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
                    "Blucash Solutions v1.125 — OPENXTECH SARL.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> enterCode(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
            onPressed: () async {},
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('code');
    await prefs.remove('phone');
    await prefs.remove('business');
    await prefs.remove('balance');
    await prefs.remove('login');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  Padding defaultAgent(BuildContext context) {
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
              radius: 110,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imgAgent,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 100,
                  color: Colors.red,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    agent,
                    style: const TextStyle(
                        fontSize: 26,
                        color: secondary,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Identifié le $date",
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
}
