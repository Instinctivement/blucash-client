import 'package:blucash_client/pages/homepage.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:flutter/material.dart';

class ScanSuccess extends StatefulWidget {
  const ScanSuccess({Key? key}) : super(key: key);

  @override
  State<ScanSuccess> createState() => _ScanSuccessState();
}

class _ScanSuccessState extends State<ScanSuccess> {
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
            const CircleAvatar(
                radius: 110,
                backgroundColor: container,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      "https://s3.o7planning.com/images/boy-128.png"),
                ),),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                color: container,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text(
                      'Nom agent: Stanley',
                      style: TextStyle(
                          fontSize: 20,
                          color: secondary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Date d'assignation: 27 mai 2022",
                      style: TextStyle(
                          fontSize: 20,
                          color: secondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Accueil'.toUpperCase(),
                      style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage()));
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
                      'Confirmer'.toUpperCase(),
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        // Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
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
    );
  }
}
