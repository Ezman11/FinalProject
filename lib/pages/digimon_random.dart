import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/models/digimon.dart';
import 'package:project/services/api.dart';

class DigimonRandomPage extends StatefulWidget {
  static const routeName = '/digimon_random';

  const DigimonRandomPage({Key? key}) : super(key: key);

  @override
  _DigimonRandomPageState createState() => _DigimonRandomPageState();
}

class _DigimonRandomPageState extends State<DigimonRandomPage> {
  late Future<List<Digimon>> _digimonList;
  var _random = 0;

  Widget _loadingPage() {
    _digimonList = _loadDigimon();
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.gif",),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.black12,
        ),
        Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/loadingImage2.gif",width: 125,height: 125,),
                SizedBox(height: 35.0),
                const SizedBox(
                  width: 35.0,
                  height: 35.0,
                  child: CircularProgressIndicator(color: Colors.white,strokeWidth: 7.0,),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _listDigimonPage();
  }

  Widget _errorPage() {
    return Stack(
      children: [
        Container(
          color: Colors.black54,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No connect',
                style: GoogleFonts.orbitron(
                    fontSize: 35.0,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 5.0,
                        color: Colors.black,
                        offset: Offset(1.0, 2.0),
                      ),
                    ]),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _digimonList = _loadDigimon();
                  });
                },
                child: Text(
                  'Retry',
                  style:
                      GoogleFonts.orbitron(fontSize: 25.0, color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  FutureBuilder _listDigimonPage() {
    return FutureBuilder<List<Digimon>>(
      future: _digimonList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage();
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return _loadingPage();
        }
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black54,
              title: Text(
                snapshot.data![_random].name,
                style: GoogleFonts.orbitron(fontSize: 25.0, shadows: [
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
                    image: AssetImage("assets/images/bg3.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              width: 300.0,
                            ),
                            _digimonCard(snapshot.data![_random]),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _digimonList = _loadDigimon();
                                });
                              },
                              child: Text(
                                'Random',
                                style:
                                GoogleFonts.orbitron(fontSize: 25.0, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )),
                )),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _digimonCard(Digimon digimon) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/digivice.gif",
                  image: digimon.picture,
                  imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Stack(
                      children: [
                        Image.asset(
                          "assets/images/imageNotLoad.gif",
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                        const Icon(
                          Icons.warning_rounded,
                          size: 130.0,
                          color: Colors.yellow,
                        ),
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 131.0,
                          color: Colors.black,
                        ),
                      ],
                    );
                  },
                  height: 300.0,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(
                height: 80.0,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      digimon.name,
                      style: GoogleFonts.orbitron(fontSize: 26.0, shadows: [
                        const Shadow(
                          blurRadius: 5.0,
                          color: Colors.white,
                          offset: Offset(1.0, 2.0),
                        ),
                      ]),
                    ),
                    Text(
                      '\nLevel : ${digimon.level}',
                      style: GoogleFonts.orbitron(
                          fontSize: 18.0,
                          color: Colors.white,
                          shadows: [
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

  Future<List<Digimon>> _loadDigimon() async {
    List list = await Api().fetch('digimon');
    var digimonList = list.map((item) => Digimon.fromJson(item)).toList();
    _random = Random().nextInt(digimonList.length+1);
    return digimonList;
  }

  @override
  initState() {
    super.initState();
    _digimonList = _loadDigimon();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
