import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blucash_client/pages/homepage.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:blucash_client/tools/header.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//import http package manually
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  late String errormsg;
  late bool error, showprogress;
  late String phone, pin;

  final _phone = TextEditingController();
  final _pin = TextEditingController();

  void saveSession(String name, String phone, String code, String business, String balance, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", json.encode(name));
    prefs.setString("phone", json.encode(phone));
    prefs.setString("code", json.encode(code));
    prefs.setString("business", json.encode(business));
    prefs.setString("balance", json.encode(balance));
    prefs.setString("login", json.encode(token));
    prefs.setBool("agent", false);
  }

  void login() async {
    if (_phone.text.isNotEmpty && _pin.text.isNotEmpty) {
      // String apiurl = "http://192.168.8.110"; //api url
      //dont use http://localhost , because emulator don't get that business
      var url = Uri.parse('https://www.blucash.net/client/connect');
      try {
        var response = await http
            .post(url, headers: header, body: {'phone': phone, 'pin': pin});

        final jsondata = json.decode(response.body);

        if (jsondata["status"] != 'true') {
          setState(() {
            showprogress = false; //don't show progress indicator
            error = true;
            errormsg = jsondata["error"];
          });
        } else {
          setState(() {
            error = false;
            showprogress = false;
          });
          pageroute(jsondata["name"], jsondata["phone"], jsondata["code"],
              jsondata["business"], jsondata["balance"], jsondata['token']);
        }
      } catch (e) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Pas de connexion internet !";
        });
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Remplir le formulaire !";
      });
    }
  }

  void pageroute(String name, String phone, String code, String business,
      String balance, String token) async {
    saveSession(name, phone, code, business, balance, token);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

   @override
   void initState() {
     super.initState();
     phone = "";
     pin = "";
     errormsg = "";
     error = false;
     showprogress = false;
   }

  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: primary));

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context)
                .size
                .height), //set minimum height equal to 100% of VH
        width: MediaQuery.of(context).size.width,
        //make width of outer wrapper to 100%
        decoration: BoxDecoration(
          color: white,
        ), //show linear gradient background of page
        padding: const EdgeInsets.all(32.0),
        child: Column(children: [
          Center(
            child: SizedBox(
                width: 200,
                height: 120,
                child: Hero(
                  tag: "logo",
                  child: Image.asset(
                    'assets/img/blucash.png',
                    width: 150,
                    height: 1,
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Connectez vous",
              style: TextStyle(
                  color: dark, fontSize: 30, fontWeight: FontWeight.bold),
            ), //title text
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const Text(
              "Utilisez les informations fournies par votre partenaire",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: dark, fontSize: 18, fontWeight: FontWeight.w400),
            ), //subtitle text
          ),
          Container(
            //show error message here
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: error ? errmsg(errormsg) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: const EdgeInsets.only(top: 10),
            child: TextField(
              autofocus: true,
              controller: _phone, //set phone controller
              maxLength: 32,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],

              style: const TextStyle(color: Colors.black45, fontSize: 20),
              decoration: myInputDecoration(
                label: "Numéro de téléphone",
                icon: Icons.person,
              ),
              onChanged: (value) {
                //set phone  text on change
                phone = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: TextField(
              controller: _pin, //set pin controller
              style: const TextStyle(color: Colors.black45, fontSize: 20),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              obscureText: _obscureText,
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
                filled: true,
                suffixIcon: IconButton(
                  icon: _obscureText
                      ? const Icon(
                          Icons.visibility,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.visibility_off,
                          color: Colors.black,
                        ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ), //set true if you want to show input background
              ),
              onChanged: (value) {
                // change pin text
                pin = value;
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
                color: dark, borderRadius: BorderRadius.circular(50)),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  primary: dark,
                ),
                onPressed: () async {
                  setState(() {
                    //show progress indicator on click
                    showprogress = true;
                  });
                  // await Future.delayed(const Duration(seconds: 2));
                  // setState(() {
                  //   showprogress = false;
                  // });
                  // _showSnackBarMsgDeleted(context);
                  login();
                },
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
                    : const Text(
                        "Connexion",
                        style: TextStyle(fontSize: 24),
                      ),
                // if showprogress == true then show progress indicator
                // else show "LOGIN NOW" text

                //button corner radius
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(bottom: 50, top: 10),
            child: InkResponse(
                onTap: () {
                  _showDialog(context);
                  //action on tap
                },
                child: const Text(
                  "Code PIN oublié?",
                  style: TextStyle(color: dark, fontSize: 18),
                )),
          ),
          const Text(
            "Blucash Solutions v1.125 — OPENXTECH SARL.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ]),
      )),
    );
  }

  InputDecoration myInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      hintText: label, //show label as placeholder
      hintStyle:
          TextStyle(color: Colors.grey[500], fontSize: 20), //hint text style
      prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Icon(
            icon,
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
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: const EdgeInsets.all(15.00),
      margin: const EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: alert,
          border: Border.all(color: Colors.yellowAccent, width: 2)),
      child: Row(children: [
        Container(
          margin: const EdgeInsets.only(right: 0.00),
          child: const Icon(Icons.info, color: dark),
        ), // icon for error message

        Text(text, style: const TextStyle(color: dark, fontSize: 18)),
        //show error message text
      ]),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("PIN oublié ?"),
          content: const Text(
              "Merci de contacter votre partenaire afin d'obtenir de l'assistance."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBarMsgDeleted(BuildContext context) {
    // Create a SnackBar.
    const snackBar = SnackBar(
      backgroundColor: primary,
      content: Text(
          "Désolé ! Nous n'avons pas pu procéder à l'authentification. Merci de vérifier votre connexion internet.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
      padding: EdgeInsets.all(20),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
