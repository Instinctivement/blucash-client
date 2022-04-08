import 'dart:convert';
import 'package:blucash_client/tools/error.dart';
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
  late String? errormsg;
  late bool error, showprogress;
  late String phone, pin;

  final _phone = TextEditingController();
  final _pin = TextEditingController();

  void saveSession(String name, String phone, String business, String balance, String support, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", json.encode(name));
    prefs.setString("phone", json.encode(phone));
    prefs.setString("business", json.encode(business));
    prefs.setString("balance", json.encode(balance));
    prefs.setString("support", json.encode(support));
    prefs.setString("login", json.encode(token));
  }

  void saveSessionWithAgent(String name, String phone,String business, String balance, String support, String token, String image, String user, String dateof) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", json.encode(name));
    prefs.setString("phone", json.encode(phone));
    prefs.setString("business", json.encode(business));
    prefs.setString("balance", json.encode(balance));
    prefs.setString("support", json.encode(support));
    prefs.setString("login", json.encode(token));
    prefs.setString("image", json.encode(image));
    prefs.setString("user", json.encode(user));
    prefs.setString("dateof", json.encode(dateof));
  }

  void login() async {
    if (_phone.text.isNotEmpty && _pin.text.isNotEmpty) {
      var url = Uri.parse('https://www.blucash.net/client/connect');
       try {
         var response = await http
             .post(url, headers: header, body: {'phone': phone, 'pin': pin});

         final jsondata = json.decode(response.body);

         if (jsondata["status"] != 'true') {
           String? errorM = jsondata["error"];
           setState(() {
             showprogress = false; //don't show progress indicator
             error = true;
             errormsg = errorMap[errorM];
           });
         } else {
           setState(() {
             error = false;
             showprogress = false;
           });
          var agent = jsondata["agent"];
           if (agent.isEmpty) {
             pageroute(jsondata["name"], jsondata["phone"],jsondata["business"], jsondata["balance"], jsondata["support"], jsondata['token']);
           } else {
             pageRouteWithAgent(jsondata["name"], jsondata["phone"], jsondata["business"], jsondata["balance"], jsondata["support"], jsondata['token'], agent['image'], agent['user'], agent['dateof']);
           }
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

  void pageroute(String name, String phone,String business, String balance, String support, String token) async {
      saveSession(name, phone, business, balance, support, token);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
  }
  
  void pageRouteWithAgent(String name, String phone,String business, String balance, String support, String token, String image, String user, String dateof) async {
      saveSessionWithAgent(name, phone, business, balance, support, token, image, user, dateof);
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
                .height),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: white,
        ), 
        padding: const EdgeInsets.all(32.0),
        child: Column(children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 20),   
              child: Image.asset(
                'assets/icon/icon.png',
              ),
            ),
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
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: error ? errmsg(errormsg!) : Container(),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: const EdgeInsets.only(top: 0.0),
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
            padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                    showprogress = true;
                  });
                  login();
                },
                child: showprogress
                    ? const SizedBox(
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
        const SizedBox(
          width: 10,
        ),

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

}
