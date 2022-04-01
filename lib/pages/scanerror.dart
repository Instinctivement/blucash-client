import 'package:blucash_client/pages/homepage.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:flutter/material.dart';

class ScanError extends StatelessWidget {
  const ScanError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                color: grey,
                onPressed: () {}),
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ), //set minimum height equal to 100% of VH

        width: MediaQuery.of(context).size.width,
        //make width of outer wrapper to 100%
        decoration: BoxDecoration(
          color: white,
        ), //show linear gradient background of page
        padding:
            const EdgeInsets.only(top: 15.0, bottom: 10, left: 32, right: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.38,
              // padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/scanerror.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(
                color: container,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Qr code incorrect'.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 36,
              decoration: BoxDecoration(
                color: container,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text(
                    'Accueil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
