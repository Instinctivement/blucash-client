import 'dart:convert';
import 'package:blucash_client/tools/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blucash_client/pages/homepage.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:blucash_client/tools/size.dart';
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
  var _obscureText = true;

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
           errormsg = "Vérifiez votre connexion internet";
         });
       }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Renseignez vos identifiants";
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primary));
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        Center(
          child: SizedBox(
            width: SizeConfig.devicePixelRatio > 3.0 ? 70.0 : 80.0,
            height: SizeConfig.devicePixelRatio > 3.0 ? 70.0 : 80.0,  
            child: Image.asset(
              'assets/icon/icon.png',
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.devicePixelRatio > 3.0 ? 10.0 : 15.0,
        ),
        Text(
          "Connectez vous",
          style: TextStyle(
              color: dark, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 25.0 : 30.0, fontWeight: FontWeight.bold,),
        ),
        SizedBox(
          height: SizeConfig.devicePixelRatio > 3.0 ? 10.0 : 15.0,
        ),
        Text(
          "Utilisez les informations fournies par votre partenaire",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: dark, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 15.0 : 18.0, fontWeight: FontWeight.w400),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: error ? errmsg(errormsg!) : Container(),
        ),
        TextField(
          autofocus: true,
          controller: _phone, //set phone controller
          maxLength: 32,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],

          style: TextStyle(color: Colors.black45, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0,),
          decoration: 
          InputDecoration(
        hintText: "Numéro de téléphone", //show label as placeholder
        hintStyle:
            TextStyle(color: Colors.grey[500], fontSize: SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0,), //hint text style
        prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Icon(
              Icons.person,
              color: Colors.grey[300],
            )
            //padding and icon for prefix
            ),
        counter: const Offstage(),

        contentPadding: EdgeInsets.fromLTRB(30, SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0, 30, SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0,),
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
          //set phone  text on change
          phone = value;
        },
      ),
      SizedBox(
          height: SizeConfig.devicePixelRatio > 3.0 ? 10.0 : 16.0,
        ),
      TextField(
        controller: _pin, //set pin controller
        style: TextStyle(color: Colors.black45, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0,),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        obscureText: _obscureText,
        maxLength: 32,
        decoration: InputDecoration(
          hintText: 'PIN', //show label as placeholder
          hintStyle: TextStyle(
              color: Colors.grey[500], fontSize: SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0,), //hint text style
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Icon(
                Icons.lock,
                color: Colors.grey[300],
              )
              //padding and icon for prefix
              ),
          counter: const Offstage(),

          contentPadding: EdgeInsets.fromLTRB(30, SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0, 30, SizeConfig.devicePixelRatio > 3.0 ? 16.0 : 20.0,),
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
       SizedBox(
          height: SizeConfig.devicePixelRatio > 3.0 ? 18.0 : 24.0,
        ),
      SizedBox(
        height: SizeConfig.devicePixelRatio > 3.0 ? 50.0 : 60.0,
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
              : Text(
                  "Connexion",
                  style: TextStyle(fontSize: SizeConfig.devicePixelRatio > 3.0 ? 20.0 : 24.0,),
                ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 50, top: 10),
        child: InkResponse(
            onTap: () {
              _showDialog(context);
            },
            child: Text(
              "Code PIN oublié?",
              style: TextStyle(color: dark, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 14.0 : 18.0,),
            ),
          ),
      ),
      Text(
        "Blucash Client — OPENXTECH SARL.",
        style: TextStyle(color: Colors.grey, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 10.0 : 12.0,),
      ),
        ]),
      ),
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: const EdgeInsets.all(10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: alert,
          ),
      child: Row(children: [
        const Icon(Icons.info, color: dark), // icon for error message
        const SizedBox(
          width: 10,
        ),

        Text(text, maxLines: 1, style: TextStyle(color: dark, fontSize: SizeConfig.devicePixelRatio > 3.0 ? 14.0 : 18.0, )),
        //show error message text
      ]),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
          title: Text("PIN oublié ?", style: TextStyle(fontSize: SizeConfig.devicePixelRatio > 3.0 ? 12.0 : 16.0, fontWeight: FontWeight.bold),),
          content: Text(
              "Merci de contacter votre partenaire afin d'obtenir de l'assistance.",
              style: TextStyle(fontSize: SizeConfig.devicePixelRatio > 3.0 ? 12.0 : 16.0,),),
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
