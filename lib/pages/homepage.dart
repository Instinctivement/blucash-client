import 'dart:convert';
import 'package:blucash_client/tools/size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blucash_client/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:blucash_client/pages/scanner.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

bool showAgent = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name = "", business = "", balance = "", support = "", bonus = "", token = "";
  late String image = "", user = "", dateof = "", scanerror = "", id = "";
  late String imageS = "", userS = "", dateofS = "", roleS = "", assignedS = "";
  String valueText = "";
  bool isVisible = true;
  bool rated = false;

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
      business = prefs.getString("business")!.replaceAll("\"", "");
      balance = prefs.getString("balance")!.replaceAll("\"", "");
      support = prefs.getString("support")!.replaceAll("\"", "");
      bonus = prefs.getString("bonus")!.replaceAll("\"", "");
      token = prefs.getString("login")!.replaceAll("\"", "");
    });
  }

  void getAgent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("id")!.replaceAll("\"", "");
      image = prefs.getString("image")!.replaceAll("\"", "");
      user = prefs.getString("user")!.replaceAll("\"", "");
      dateof = prefs.getString("dateof")!.replaceAll("\"", "");
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
    String? valS = prefs.getString("roleS");
    if (val != null) {
      getErrorScan();
      _errorScanDialog(context);
    }
    if (valS != null) {
      setState(() {
        imageS = prefs.getString("imageS")!.replaceAll("\"", "");
        userS = prefs.getString("userS")!.replaceAll("\"", "");
        dateofS = prefs.getString("dateofS")!.replaceAll("\"", "");
        roleS = prefs.getString("roleS")!.replaceAll("\"", "");
        assignedS = prefs.getString("assignedS")!.replaceAll("\"", "");
      });
      _managerScanDialog(context);
    }
  }

  void getErrorScan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      scanerror = prefs.getString("scanerror")!.replaceAll("\"", "");
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: white));
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: primary,
          title: SizedBox(
            height: SizeConfig.deviceRelatifRatio < 1.8 ? 60.0 : 70.0,
            width: SizeConfig.deviceRelatifRatio < 1.8 ? 115.0 : 130.0,
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
                  _onLoading();
                });
              },
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  dividerColor: Colors.grey,
                  iconTheme: const IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                color: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: support != ""
                        ? Row(
                            children: const [
                              Icon(
                                Icons.phone,
                                color: dark,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text("Assistance")
                            ],
                          )
                        : Container(),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: const [
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
                      children: const [
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
                  padding: EdgeInsets.only(
                    top: SizeConfig.deviceRelatifRatio < 1.8 ? 2.0 : 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        width: 05,
                      ),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                ? 14.0
                                : 18.0,
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
                padding: EdgeInsets.all(
                    SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 20.0),
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
                            style: TextStyle(
                                fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                    ? 10.0
                                    : 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                          Text(
                            balance,
                            style: TextStyle(
                              fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                  ? 18.0
                                  : 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: bonus != 'false' ? 8.0: 0.0,
                      ),
                      bonus != 'false' ?
                      Column(
                        children: [
                          Text(
                            "Bonus Fidelite".toUpperCase(),
                            style: TextStyle(
                                fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                    ? 10.0
                                    : 14.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                          ),
                          Text(
                            bonus,
                            style: TextStyle(
                              fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                  ? 12.0
                                  : 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ): Container(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  child: GestureDetector(
                      child: Row(
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Consulter mon historique",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                  ? 12.0
                                  : 16.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.black54,
                          )
                        ],
                      ),
                      onTap: () {
                        record();
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        SizeConfig.deviceRelatifRatio < 1.8 ? 110.0 : 120.0,
                    vertical: 8),
                child: Container(
                  color: Colors.grey[100],
                  height: 2,
                ),
              ),
              showAgent ? isAgent(context) : defaultAgent(context),
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
                        style: TextStyle(
                          fontSize:
                              SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 18.0,
                        ),
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.deviceRelatifRatio < 1.8 ? 20.0 : 25.0),
                child: Text(
                  business,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.deviceRelatifRatio < 1.8 ? 5.0 : 5.0),
                child: Text(
                  "Blucash Client — OPENXTECH SARL.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 9.0 : 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() async {
    var url = Uri.parse('https://www.blucash.net/client/refresh');
    try {
      var response = await http.post(url, body: {'st': token});
      final jsondata = json.decode(response.body);
      if (jsondata["status"] == "true") {
        String? val = image;
        if (val != "") {
          CachedNetworkImage.evictFromCache(image);
        }
        var agent = jsondata["agent"];
        if (agent.isEmpty) {
          pagerouteRefreshS(
              jsondata["name"], jsondata["balance"], jsondata["bonus"], jsondata["support"]);
          Navigator.pop(context, 'Annuler');
        } else {
          pagerouteRefresh(
              jsondata["name"],
              jsondata["balance"],
              jsondata["support"],
              jsondata["bonus"],
              agent['image'],
              agent['user'],
              agent['dateof']);
        }
      } else {
        Future.delayed(const Duration(seconds: 2), () async {
          Navigator.pop(context, 'Annuler');
          await logOut(context);
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2), () {
        //pop dialog
        Navigator.pop(context, 'Annuler');
        _internetDialog(context);
      });
    }
  }

  void pagerouteRefreshS(String nameR, String balanceR, String bonusR, String supportR) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('image');
    await prefs.remove('user');
    await prefs.remove('dateof');
    prefs.setString("name", json.encode(nameR));
    prefs.setString("balance", json.encode(balanceR));
    prefs.setString("support", json.encode(supportR));
    prefs.setString("bonus", json.encode(bonusR));
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }

  void pagerouteRefresh(String nameR, String balanceR, String supportR, String bonusR, String imageR, String userR, String dateofR) async {
    saveSessionRefresh(nameR, balanceR, supportR, bonusR, imageR, userR, dateofR);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    });
  }

  void saveSessionRefresh(String nameR, String balanceR, String supportR, String bonusR, String imageR, String userR, String dateofR) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", json.encode(nameR));
    prefs.setString("balance", json.encode(balanceR));
    prefs.setString("support", json.encode(supportR));
    prefs.setString("bonus", json.encode(bonusR));
    prefs.setString("image", json.encode(imageR));
    prefs.setString("user", json.encode(userR));
    prefs.setString("dateof", json.encode(dateofR));
  }

  void _onLoading() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceRelatifRatio < 1.8 ? 120.0 : 130.0,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        title: SizedBox(
          height: 80,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  strokeWidth: 2.0,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    refresh();
  }

  Future<String?> emptyForm() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        title: const Text('Erreur'),
        content: const Text('Remplir le formulaire !'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Annuler'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void pageroute(String image, String user, String dateof) async {
    saveSession(image, user, dateof);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  void saveSession(String image, String user, String dateof) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", json.encode(image));
    prefs.setString("user", json.encode(user));
    prefs.setString("dateof", json.encode(dateof));
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
  Future<void>? launched;

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.pop(context, 'Annuler');
        setState(() {
          launched = _makePhoneCall(support);
        });
        break;
      case 1:
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            title: Text(
              'Confirmation',
              style: TextStyle(
                  fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0,
                  fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Vous allez être redirigé.',
              style: TextStyle(
                  fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Annuler'),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Annuler');
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
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            title: const Text('Confirmation'),
            content: const Text('Vous êtes sur le point de vous déconnecter.'),
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
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: SizeConfig.deviceRelatifRatio < 1.8 ? 80.0 : 110.0,
              child: CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 250, 249, 249),
                radius: SizeConfig.deviceRelatifRatio < 1.8 ? 80.0 : 110.0,
                child: Icon(
                  Icons.qr_code,
                  size: SizeConfig.deviceRelatifRatio < 1.8 ? 80.0 : 100.0,
                  color: const Color.fromARGB(255, 224, 223, 223),
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
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.deviceRelatifRatio < 1.8 ? 0.0 : 8.0,
      ),
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
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: container,
                  radius: SizeConfig.deviceRelatifRatio < 1.8 ? 95.0 : 110.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      SizeConfig.deviceRelatifRatio < 1.8 ? 95.0 : 110.0,
                    ),
                    child: CircleAvatar(
                      backgroundColor: container,
                      radius:
                          SizeConfig.deviceRelatifRatio < 1.8 ? 92.0 : 108.0,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: SizeConfig.deviceRelatifRatio < 1.8
                              ? 98.0
                              : 110.0,
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 250, 249, 249),
                            radius: SizeConfig.deviceRelatifRatio < 1.8
                                ? 95.0
                                : 110.0,
                            child: Icon(
                              Icons.error_outline_sharp,
                              size: SizeConfig.deviceRelatifRatio < 1.8
                                  ? 95.0
                                  : 100.0,
                              color: const Color.fromARGB(255, 189, 187, 187),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: SizeConfig.deviceRelatifRatio < 1.8 ? -5 : 0,
                  child: RawMaterialButton(
                    onPressed: () {
                      _showRatingDialog(context);
                    },
                    elevation: 4.0,
                    fillColor: const Color(0xFFF5F6F9),
                    child: const Icon(
                      Icons.star_half,
                      color: dark,
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(0.0),
                    shape: const CircleBorder(),
                  ),
                ),
              ],
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
                          style: TextStyle(
                              fontSize: SizeConfig.deviceRelatifRatio < 1.8
                                  ? 20.0
                                  : 26.0,
                              color: primary,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.verified_rounded,
                          size:
                              SizeConfig.deviceRelatifRatio < 1.8 ? 16.0 : 20.0,
                          color: primary,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      "Assigné le $dateof",
                      style: TextStyle(
                          fontSize:
                              SizeConfig.deviceRelatifRatio < 1.8 ? 10.0 : 14.0,
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          title: Text(
            "Message",
            style: TextStyle(
                fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            scanerror,
            style: TextStyle(
                fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0),
          ),
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

  void _managerScanDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          content: SizedBox(
            height: roleS == "admin"
                ? MediaQuery.of(context).size.height * 0.42
                : MediaQuery.of(context).size.height * 0.48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: container,
                  radius: SizeConfig.deviceRelatifRatio < 1.8 ? 90.0 : 110.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(110.0),
                    child: CachedNetworkImage(
                      imageUrl: imageS,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.white,
                        radius:
                            SizeConfig.deviceRelatifRatio < 1.8 ? 90.0 : 110.0,
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 250, 249, 249),
                          radius: SizeConfig.deviceRelatifRatio < 1.8
                              ? 90.0
                              : 110.0,
                          child: const Icon(
                            Icons.error_outline_sharp,
                            size: 100,
                            color: Color.fromARGB(255, 189, 187, 187),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userS,
                              style: const TextStyle(
                                  fontSize: 26,
                                  color: primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.verified_rounded,
                              size: 20,
                              color: primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            roleS == "admin"
                                ? Column(
                                    children: [
                                      const Text(
                                        "Gestionnaire",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        business,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const Text(
                                        "Agent Commercial",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        business,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      assignedS == 'true'
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.green.shade100,
                                              ),
                                              child: const Text(
                                                "Cet agent vous a été assigné",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: dark,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ))
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.yellow.shade100,
                                              ),
                                              child: const Text(
                                                "Vous n'êtes pas lié à cet agent",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: dark,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  primary: primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "OK",
                  ),
                ),
                onPressed: () async {
                  CachedNetworkImage.evictFromCache(imageS);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('imageS');
                  await prefs.remove('userS');
                  await prefs.remove('dateofS');
                  await prefs.remove('roleS');
                  await prefs.remove('assignedS');
                  Navigator.pop(context, 'Annuler');
                },
              ),
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
          title: Text(
            "Erreur de connexion",
            style: TextStyle(
                fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Vérifier votre connexion puis réessayer.",
            style: TextStyle(
                fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0),
          ),
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

  void _showRatingDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RatingDialog(
          initialRating: 1.0,
          title: Text(
            "Notez votre agent",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 20.0 : 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          starSize: SizeConfig.deviceRelatifRatio < 1.8 ? 30.0 : 40.0,
          showCloseButton: true,
          starColor: primary,
          message: Text(
            'Appuyez sur une étoile pour définir votre niveau de satisfaction.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 11.0 : 15.0,
            ),
          ),
          image: CircleAvatar(
            backgroundColor: container,
            radius: SizeConfig.deviceRelatifRatio < 1.8 ? 70.0 : 90.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                SizeConfig.deviceRelatifRatio < 1.8 ? 70.0 : 90.0,
              ),
              child: CircleAvatar(
                radius: SizeConfig.deviceRelatifRatio < 1.8 ? 68.0 : 88.0,
                child: CachedNetworkImage(
                  imageUrl: image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: SizeConfig.deviceRelatifRatio < 1.8 ? 70.0 : 90.0,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
                      radius: SizeConfig.deviceRelatifRatio < 1.8 ? 70.0 : 90.0,
                      child: const Icon(
                        Icons.error_outline_sharp,
                        size: 100,
                        color: Color.fromARGB(255, 189, 187, 187),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          submitButtonText: 'Envoyer',
          submitButtonTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 14.0 : 17.0,
          ),
          commentHint: 'Ajoutez un commentaire...',
          onSubmitted: (response) {
            _onLoadingRate(response.rating.toInt(), response.comment);
          },
        );
      },
      animationType: DialogTransitionType.fade,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _onLoadingRate(int star, String comment) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceRelatifRatio < 1.8 ? 120.0 : 130.0,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))),
        title: SizedBox(
          height: 80,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  strokeWidth: 2.0,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    rate(star, comment);
  }

  void rate(int star, String comment) async {
    var url = Uri.parse('https://www.blucash.net/client/review');
    try {
      var response = await http.post(url, body: {
        'st': token,
        'agent': id,
        'star': star.toString(),
        'comment': comment
      });
      final jsondata = json.decode(response.body);
      if (jsondata["status"] == "true") {
        Navigator.pop(context, 'Annuler');
        Future.delayed(const Duration(seconds: 1), () {
          _rateResult(context, 'Merci pour votre avis');
        });
      } else {
        Navigator.pop(context, 'Annuler');
        Future.delayed(const Duration(seconds: 1), () {
          _rateResult(context,
              "Une erreur s'est produite merci de reéssayer plus tard");
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2), () {
        _internetDialog(context);
      });
    }
  }

  void _rateResult(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          title: Text(
            "Message",
            style: TextStyle(
                fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            style: TextStyle(
                fontSize: SizeConfig.deviceRelatifRatio < 1.8 ? 12.0 : 16.0),
          ),
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

  void record() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.deviceRelatifRatio < 1.8 ? 120.0 : 130.0,
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0),),),
        title: SizedBox(
          height: 80,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(
                  strokeWidth: 2.0,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context, 'Annuler');
      recordlink();
    });
  }

  void recordlink() async {
     var url = Uri.parse('https://www.blucash.net/client/record');
     try {
       var response = await http.post(url, body: {'st': token});
       final jsondata = json.decode(response.body);
       if (jsondata["status"] == "true") {
          launched = _launchInBrowser(jsondata["link"]);
       } else {
          Future.delayed(const Duration(seconds: 1), () {
            _rateResult(context,
                "Une erreur s'est produite merci de reéssayer plus tard");
          });
       }
     } catch (e) {
       Future.delayed(const Duration(seconds: 2), () {
         _internetDialog(context);
       });
     }
  }
}
