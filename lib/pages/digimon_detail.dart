import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/models/digimon.dart';

class DigimonDetailPage extends StatefulWidget {
  static const routeName = '/digimon_detail_page';

  const DigimonDetailPage({Key? key}) : super(key: key);

  @override
  _DigimonDetailPageState createState() => _DigimonDetailPageState();
}

class _DigimonDetailPageState extends State<DigimonDetailPage> {
  late int digimonCount;

  Widget _digimonCard(Digimon digimon) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              FadeInImage.assetNetwork(
                placeholder: "assets/images/digivice.gif",
                image: digimon.picture,
                height: 300.0,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 80.0,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      digimon.name,
                      style: GoogleFonts.orbitron(
                        fontSize: 25.0,
                        shadows: [
                        const Shadow(
                        blurRadius: 5.0,
                        color: Colors.white,
                        offset: Offset(1.0, 2.0),
                      ),
                        ]
                      ),
                    ),
                    Text(
                      '\nLevel : ${digimon.level}',
                      style: GoogleFonts.orbitron(fontSize: 18.0,color: Colors.white,shadows: [
                        const Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(1.0, 2.0),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final digimon = ModalRoute.of(context)!.settings.arguments as Digimon;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text(
          digimon.name,
          style: GoogleFonts.orbitron(fontSize: 25.0,shadows: [
            const Shadow(
              blurRadius: 5.0,
              color: Colors.black12,
              offset: Offset(1.0, 2.0),
            ),
          ]),
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg4.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        width: 300.0,
                      ),
                      _digimonCard(digimon),
                    ],
                  ),
                )),
          )),
    );
  }
}
