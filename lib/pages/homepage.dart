import 'dart:convert';

import 'package:blucash_client/method/creditation.dart';
import 'package:blucash_client/pages/scanerror.dart';
import 'package:blucash_client/pages/scansuccess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blucash_client/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:blucash_client/pages/scanner.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    getCred();
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

  Future<List<Credit>> getRequest() async {
    //replace your restFull API here.
    var url = Uri.parse('https://www.blucash.net/client/connect');
    final response = await http.get(url);
    var responseData = json.decode(response.body);

    //Creating a list to store input data;
    List<Credit> credits = [];
    for (var singleCredit in responseData) {
      Credit credit = Credit(
          status: singleCredit["status"],
          balance: singleCredit["balance"],
          date: singleCredit["date"]);

      //Adding user to the list.
      credits.add(credit);
    }
    return credits;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: false,
          backgroundColor: white,
          title: SizedBox(
            height: 80,
            width: 150,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Hero(
                tag: "logo",
                child: Image.asset(
                  'assets/img/blucash.png',
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                color: grey,
                onPressed: () {}),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('id');
                    await prefs.remove('name');
                    await prefs.remove('code');
                    await prefs.remove('phone');
                    await prefs.remove('business');
                    await prefs.remove('balance');
                    await prefs.remove('login');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false);
                  },
                  child: const Text(
                    "Quitter",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black45,
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
            padding: const EdgeInsets.only(
                top: 15.0, bottom: 10, left: 32, right: 32),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home_work),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          business,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 20,
                              color: dark,
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
                    borderRadius: BorderRadius.circular(10.0),
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
                                fontSize: 30,
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
                                  style: const TextStyle(fontSize: 13),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const QrScanPage()));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: primary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Saisir code'.toUpperCase(),
                                  style: TextStyle(fontSize: 13, color: white),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ScanSuccess()));
                                  //  _displayTextInputDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: secondary,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
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
                    child: Text(
                      "Activités".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 36,
                      decoration: BoxDecoration(
                          color: isVisible ? container : Colors.transparent,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              isVisible = true;
                            });
                          },
                          style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Text(
                            'Créditations',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: isVisible ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 36,
                      decoration: BoxDecoration(
                          color: isVisible ? Colors.transparent : container,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            setState(() {
                              isVisible = false;
                            });
                          },
                          style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: const Text(
                            'Transactions',
                            style: TextStyle(
                                fontSize: 15,
                                color: dark,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Visibility(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.40,
                      decoration: BoxDecoration(
                        color: container,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade400,
                              ),
                            ),
                            subtitle: const Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_upward,
                                color: Colors.red.shade400, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          const ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_downward,
                                color: Colors.green, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade400,
                              ),
                            ),
                            subtitle: const Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_upward,
                                color: Colors.red.shade400, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          const ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_downward,
                                color: Colors.green, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade400,
                              ),
                            ),
                            subtitle: const Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_upward,
                                color: Colors.red.shade400, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          const ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_downward,
                                color: Colors.green, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade400,
                              ),
                            ),
                            subtitle: const Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_upward,
                                color: Colors.red.shade400, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          const ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_downward,
                                color: Colors.green, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                        ],
                      ),
                    ),
                    visible: isVisible,
                    replacement: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                      ),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.40,
                      decoration: BoxDecoration(
                        color: container,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade400,
                              ),
                            ),
                            subtitle: const Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_upward,
                                color: Colors.red.shade400, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                          const ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 2),
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            title: Text(
                              "50,000,000 FCFA",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text("2022-03-28 18:55:00",
                                style: TextStyle(fontSize: 18)),
                            leading: Icon(Icons.arrow_downward,
                                color: Colors.green, size: 30),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.only(top: 8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: container,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Vous etes connecté en tant que :',
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
                          fontWeight: FontWeight.w400,
                          color: isVisible ? Colors.black : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
