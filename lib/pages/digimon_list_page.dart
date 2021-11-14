import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/models/digimon.dart';
import 'package:project/pages/digimon_detail.dart';
import 'package:project/pages/digimon_random.dart';
import 'package:project/services/api.dart';

class DigimonListPage extends StatefulWidget {
  static const routeName = '/digimon_list_page';

  const DigimonListPage({Key? key}) : super(key: key);

  @override
  _DigimonListPageState createState() => _DigimonListPageState();
}

class _DigimonListPageState extends State<DigimonListPage> {
  late Future<List<Digimon>> _digimonList;

  Widget _loadingPage() {
    _digimonList = _loadDigimon();
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loadingBg.gif"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.black26,
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Text(
            'DigimonList',
            style: GoogleFonts.orbitron(fontSize: 25.0),
          ),
        ),
        body: SafeArea(
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg2.gif"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: _listDigimonPage(),
              ),
            )));
  }

  Widget _errorPage(){
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
                  style: GoogleFonts.orbitron(
                      fontSize: 25.0, color: Colors.white),
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
        }if (snapshot.connectionState != ConnectionState.done) {
          return _loadingPage();
        }if (snapshot.hasData) {
          return Scaffold(
              floatingActionButton: _digivice(),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg2.gif"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    var digimon = snapshot.data![index];
                    return ClipRRect(borderRadius: BorderRadius.circular(45.0),
                      child:  Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5.0,
                        shadowColor: Colors.black.withOpacity(0.2),
                        child: InkWell(
                          onTap: () => _digimonDetail(digimon),
                          child: Container(
                              color: Colors.grey,
                              child: Row(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Card(
                                      margin: const EdgeInsets.all(8.0),
                                      color: Colors.white,
                                      child: FadeInImage.assetNetwork(
                                        width: 80.0,
                                        height: 80.0,
                                        fit: BoxFit.cover,
                                        placeholder: "assets/images/loadingImage.gif",
                                        image: digimon.picture,
                                        imageErrorBuilder: (BuildContext context,
                                            Object exception, StackTrace? stackTrace) {
                                          return Stack(
                                            children: [
                                              Image.asset(
                                                "assets/images/imageNotLoad.gif",
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                              const Icon(
                                                Icons.warning_rounded,
                                                size: 35.0,
                                                color: Colors.yellow,
                                              ),
                                              const Icon(
                                                Icons.warning_amber_rounded,
                                                size: 36.0,
                                                color: Colors.black,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width:10.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          digimon.name,
                                          style:
                                          GoogleFonts.orbitron(fontSize: 22.0,color: Colors.black,shadows: [
                                            const Shadow(
                                              blurRadius: 5.0,
                                              offset: Offset(1.0, 2.0),
                                            ),
                                          ]),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'Level : ${digimon.level}',
                                          style:
                                          GoogleFonts.orbitron(fontSize: 15.0,color: Colors.white,shadows: [
                                            const Shadow(
                                              blurRadius: 5.0,
                                              offset: Offset(1.0, 2.0),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
                      ,);
                  },
                ),
              ),
            );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _digivice(){
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.cyanAccent,
        onTap: ()  {
          _RandomPage();
          },
        child: Stack(
          children: [
            Image.asset(
              "assets/images/digivice.gif",
              width: 85,
              color: Colors.black,
              fit: BoxFit.cover,
            ),
            Image.asset(
              "assets/images/digivice.gif",
              width: 80,
              fit: BoxFit.cover,
            ),
          ],
        )
      ),
    );
  }

  Future<List<Digimon>> _loadDigimon() async {
    List list = await Api().fetch('digimon');
    var digimonList = list.map((item) => Digimon.fromJson(item)).toList();

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


  _RandomPage(){
    Navigator.pushNamed(
      context,
      DigimonRandomPage.routeName,
    );
  }

  _digimonDetail(Digimon digimon) {
    Navigator.pushNamed(
      context,
      DigimonDetailPage.routeName,
      arguments: digimon,
    );
  }
}
