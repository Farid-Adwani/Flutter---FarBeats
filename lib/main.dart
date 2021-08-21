import 'dart:async';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:particles_flutter/particles_flutter.dart';

void main(List<String> args) {
  ErrorWidget.builder = (FlutterErrorDetails e) {
    return Center(child: Image.asset("images/error.png"));
  };
  print('TakTouka');
  runApp(Taktouka());
}

class Taktouka extends StatefulWidget {
  const Taktouka({Key? key}) : super(key: key);

  @override
  _TaktoukaState createState() => _TaktoukaState();
}

class _TaktoukaState extends State<Taktouka> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Taktouka",
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(
          gradientBackground: LinearGradient(
            colors: [Colors.pink, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          seconds: 4,
          navigateAfterSeconds: new Home(),
          title: new Text(
            'FarBeats',
            style: new TextStyle(
              color: Colors.white,
              fontFamily: 'pacifico',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          image: new Image.asset(
            'images/FarBeats.png',
            alignment: Alignment.center,
          ),
          loadingText: Text(
            "Loading",
            style: TextStyle(color: Colors.white),
          ),
          photoSize: 50,
          loaderColor: Colors.white),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var longeur = MediaQuery.of(context).size.height;
    return Scaffold(
        body: InteractiveViewer(
      panEnabled: true,
      constrained: true,
      child: Body(
        largeur: largeur,
        longeur: longeur,
      ),
    )
        // floatingActionButton: FloatingActionButton(
        //   onPressed: null,
        //   backgroundColor: Colors.pink,
        //   child: Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        // bottomNavigationBar: BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   clipBehavior: Clip.antiAlias,
        //   notchMargin: 10,
        //   elevation: 40,
        //   child: BottomNavigationBar(
        //     backgroundColor: Colors.pinkAccent,
        //     elevation: 50,
        //     iconSize: 30,
        //     currentIndex: 1,
        //     items: [
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.music_note), label: "Music"),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        //     ],
        //   ),
        // ),
        );
  }
}

class Body extends StatefulWidget {
  Body({Key? key, required this.largeur, required this.longeur})
      : super(key: key);
  double largeur = 0;
  double longeur = 0;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var couleur = [
    Colors.pink,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.blue,
    Colors.amber,
    Colors.deepOrange,
    Colors.cyan,
    Colors.indigo,
    Colors.lightBlue,
    Colors.teal,
    Colors.yellow
  ];

  var couleurAccent = [
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.amberAccent,
    Colors.deepOrangeAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.lightBlueAccent,
    Colors.tealAccent,
    Colors.yellowAccent
  ];
  int indexColor = 0;
  List<PairItem> playlistSongs = [];
  bool playlistShow = false;
  int indexSong = 0;
  Timer t = Timer(Duration(seconds: 0), () {});
  Duration faya9a = Duration(seconds: 0);
  List files = [];
  List<Card> cards = [];
  var covers = [];
  List<String> gifs = [
    "images/0.gif",
    "images/1.gif",
    "images/2.gif",
    "images/3.gif",
    "images/4.gif",
    "images/5.gif",
    "images/6.gif",
    "images/7.gif",
    "images/8.gif",
    "images/9.gif",
    "images/10.gif",
    "images/11.gif",
    "images/12.gif",
    "images/13.gif",
    "images/14.gif",
    "images/15.gif",
    "images/16.gif",
    "images/17.gif",
    "images/18.gif",
    "images/19.gif",
    "images/20.gif",
    "images/21.gif",
    "images/22.gif",
    "images/23.gif",
    "images/24.gif",
    "images/25.gif"
  ];
  String recherche = "";
  int indexGif = 0;
  double volume = 0.5;
  DateTime finishTime = DateTime.now();
  bool playing = false;
  int indexWheel = 0;
  bool stateStar = false;
  AudioPlayer _player = new AudioPlayer();
  AudioCache cache = new AudioCache();
  String afterSong = "repeatall";
  Duration position = new Duration(seconds: 0);
  Icon afterIcon = Icon(
    Icons.repeat,
    color: Colors.pink,
  );
  FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songsinfo = [];

  void songsQuery() async {
    var largeur = this.widget.largeur;
    var longeur = this.widget.longeur;
    List<SongInfo> songsinfos = await audioQuery.getSongs();
    int i = -1;
    songsinfos.forEach((element) {
      i++;
      if (element.albumArtwork != null) {
        var value = CircleAvatar(
          backgroundImage: FileImage(File(element.albumArtwork)),
          radius: longeur / 6.5,
          child: CircleAvatar(
            backgroundImage: AssetImage(gifs[indexGif]),
            radius: longeur / 25,
          ),
          backgroundColor: Colors.grey,
        );
      }
      var value = FutureBuilder<Uint8List>(
        future: audioQuery.getArtwork(type: ResourceType.SONG, id: element.id),
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return CircleAvatar(
              backgroundImage: AssetImage("images/cd.jpg"),
              radius: longeur / 6.5,
              child: CircleAvatar(
                backgroundImage: AssetImage(gifs[indexGif]),
                radius: longeur / 25,
              ),
              backgroundColor: Colors.grey,
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return CircleAvatar(
                backgroundImage: AssetImage("images/cd.jpg"),
                radius: longeur / 6.5,
                child: CircleAvatar(
                  backgroundImage: AssetImage(gifs[indexGif]),
                  radius: longeur / 25,
                ),
                backgroundColor: Colors.grey,
              );
            } else {
              return CircleAvatar(
                backgroundImage: MemoryImage(snapshot.data!),
                radius: longeur / 6.5,
                child: CircleAvatar(
                  backgroundImage: AssetImage(gifs[indexGif]),
                  radius: longeur / 25,
                ),
                backgroundColor: Colors.grey,
              );
            }
          }
          return Text("FarBeats");
        },
      );

      setState(() {
        playlistSongs.add(PairItem(i, element));
        covers.add(value);
      });
    });
    setState(() {
      songsinfo = songsinfos;
    });

//cover

    //print(cards);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    afterIcon = Icon(Icons.repeat,
        color: couleurAccent[(indexColor + 1) % couleurAccent.length][700]);

    Timer r = Timer.periodic(Duration(seconds: 1), (timer) {
      //print("yallaa");
      setState(() {});
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat();
    //print('Done init1');
    songsQuery();
    //print('Done init2');
    //print(songsinfo);
    _controller.stop();
    _player = AudioPlayer();
    _player.onDurationChanged.listen((Duration d) {
      position = Duration(seconds: 0);
    });
    _player.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        if (d.inMilliseconds.toDouble() >
            double.parse(songsinfo[indexSong].duration)) {
          position = Duration(
              milliseconds:
                  double.parse(songsinfo[indexSong].duration).toInt());
        } else {
          position = d;
        }
      });
    });

    _player.onPlayerCompletion.listen((event) {
      setState(() {
        position = Duration(milliseconds: 0);
      });

      if (afterSong == "repeat") {
        repeat();
      } else {
        nextSong();
      }
    });
  }

  void faye9ni() {
    setState(() {
      faya9a = Duration(seconds: 0);
      playing = false;
      _controller.stop();
      _player.pause();
    });
    //print("tiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiit");
  }

  void volumeSet(double vol) {
    setState(() {
      volume = vol;
      _player.setVolume(volume);
    });
  }

  void repeat() {
    _controller.repeat();
    setState(() {
      playing = true;
      indexGif = math.Random().nextInt(gifs.length);
    });
    _player.stop();
    _player.play(songsinfo[indexSong].filePath, isLocal: true);
    _player.setVolume(volume);
  }

  void nextSong() {
    _controller.repeat();
    setState(() {
      position = Duration(seconds: 0);
      indexGif = math.Random().nextInt(gifs.length);
      playing = true;
      if (afterSong == "random") {
        indexSong = math.Random().nextInt(songsinfo.length);
      } else {
        indexSong = (indexSong + 1) % songsinfo.length;
      }
    });
    _player.stop();
    _player.play(songsinfo[indexSong].filePath, isLocal: true);
    _player.setVolume(volume);
  }

  void previousSong() {
    _controller.repeat();

    setState(() {
      position = Duration(seconds: 0);

      indexGif = math.Random().nextInt(gifs.length);

      playing = true;
      if (afterSong == "random") {
        indexSong = math.Random().nextInt(songsinfo.length);
      } else {
        indexSong = ((indexSong + -1) % songsinfo.length).abs();
      }
    });
    _player.stop();

    _player.play(songsinfo[indexSong].filePath, isLocal: true);
    _player.setVolume(volume);
  }

  void star() {
    setState(() {
      stateStar = !stateStar;
    });
  }

  Shader linearGradient(List<Color> colorslist) {
    return LinearGradient(
      colors: colorslist,
    ).createShader(
      Rect.fromLTWH(60.0, 0.0, 200.0, 70.0),
    );
  }

  void nextstate() {
    setState(() {
      if (afterSong == "repeatall") {
        afterSong = "repeat";
        afterIcon = Icon(
          Icons.repeat_one,
          color: couleurAccent[(indexColor + 1) % couleurAccent.length],
        );
      } else if (afterSong == "repeat") {
        afterSong = "random";
        afterIcon = Icon(Icons.all_inclusive_outlined,
            color: couleurAccent[(indexColor + 1) % couleurAccent.length][400]);
      } else if (afterSong == "random") {
        afterSong = "repeatall";
        afterIcon = Icon(Icons.repeat,
            color: couleurAccent[(indexColor + 1) % couleurAccent.length][700]);
      }
    });
  }

  void play() {
    if (songsinfo.length != 0) {
      setState(() {
        playing = !playing;
      });
      if (playing) {
        _controller.forward();
        _player.pause();
        _player.play(songsinfo[indexSong].filePath, isLocal: true);
        _player.setVolume(volume);
      } else {
        _controller.stop();
        _player.pause();
      }
    }
  }

  void sliderMusic(double data) {
    setState(() {
      position = new Duration(milliseconds: data.toInt());
      _player.seek(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    var largeur = MediaQuery.of(context).size.width;
    var longeur = MediaQuery.of(context).size.height;
    return Container(
      color: couleurAccent[indexColor],
      child: Column(children: [
        SafeArea(
            child: Container(
          height: longeur / 10,
          padding: EdgeInsets.all(longeur / 80),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      indexColor = (indexColor + 1) % couleurAccent.length;
                      if (afterSong == "repeat") {
                        afterIcon = Icon(
                          Icons.repeat_one,
                          color: couleurAccent[
                              (indexColor + 1) % couleurAccent.length],
                        );
                      } else if (afterSong == "random") {
                        afterIcon = Icon(Icons.all_inclusive_outlined,
                            color: couleurAccent[
                                (indexColor + 1) % couleurAccent.length][400]);
                      } else if (afterSong == "repeatall") {
                        afterIcon = Icon(Icons.repeat,
                            color: couleurAccent[
                                (indexColor + 1) % couleurAccent.length][700]);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.color_lens,
                    size: longeur / 25,
                    color: Colors.white,
                  )),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    "FarBeats",
                    colors: [
                      Colors.white,
                      Colors.yellow,
                      Colors.red,
                      Colors.green,
                      Colors.white,
                      Colors.black,
                      Colors.blue,
                      Colors.orange
                    ],
                    textStyle: TextStyle(
                      fontFamily: 'pacifico',
                      fontSize: longeur / 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                repeatForever: true,
              ),
              IconButton(
                onPressed: () {
                  _player.stop();
                  exit(0);
                },
                icon: Icon(
                  Icons.exit_to_app,
                  size: longeur / 25,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )),
        Expanded(
          child: Container(
            child: Stack(children: [
              if (stateStar == true)
                CircularParticle(
                  height: longeur,
                  width: largeur,
                  isRandomColor: false,
                  awayRadius: largeur / 5,
                  onTapAnimation: true,
                  enableHover: true,
                  hoverColor: Colors.black,
                  hoverRadius: 90,
                  speedOfParticles: 1.5,
                  maxParticleSize: 7,
                  connectDots: true,
                  isRandSize: true,
                  numberOfParticles: 150,
                  particleColor: couleur[indexColor].withOpacity(.7),
                  awayAnimationCurve: Curves.easeInOutBack,
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if ((finishTime.difference(DateTime.now()))
                                            .inMinutes >
                                        0) {
                                      faya9a = (finishTime
                                              .difference(DateTime.now())) -
                                          Duration(minutes: 1);
                                      finishTime = DateTime.now().add(faya9a);
                                      t.cancel();
                                      t = Timer(faya9a, faye9ni);
                                    } else {
                                      t.cancel();
                                      faya9a = (finishTime
                                              .difference(DateTime.now())) -
                                          Duration(minutes: 1);
                                      finishTime = DateTime.now().add(faya9a);
                                    }
                                  });
                                },
                                icon: Icon(Icons.exposure_minus_1_rounded),
                                iconSize: longeur / 30,
                              ),
                              if ((finishTime.difference(DateTime.now()))
                                      .isNegative ==
                                  false)
                                Text(
                                  (finishTime.difference(DateTime.now()))
                                      .toString()
                                      .split(".")[0],
                                  style: TextStyle(fontSize: longeur / 60),
                                ),
                              IconButton(
                                onPressed: () {
                                  if ((finishTime.difference(DateTime.now()))
                                      .isNegative) {
                                    faya9a = Duration(minutes: 1);
                                  } else {
                                    faya9a = (finishTime
                                            .difference(DateTime.now())) +
                                        Duration(minutes: 1);
                                  }
                                  t.cancel();

                                  t = Timer(faya9a, faye9ni);
                                  finishTime = DateTime.now().add(faya9a);
                                  //print(faya9a);
                                  //print(finishTime);
                                },
                                icon: Icon(Icons.more_time),
                                iconSize: longeur / 30,
                              ),
                            ],
                          ),
                          if (playlistShow == true)
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  labelText: recherche,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                                cursorColor: couleur[indexColor],
                                enableSuggestions: true,
                                maxLines: 1,
                                onSubmitted: (String pattern) {
                                  playlistSongs.clear();
                                  for (int i = 0; i < songsinfo.length; i++) {
                                    if (songsinfo[i]
                                        .title
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase())) {
                                      setState(() {
                                        playlistSongs
                                            .add(PairItem(i, songsinfo[i]));
                                      });
                                    }
                                    setState(() {
                                      recherche = pattern;
                                      indexWheel = 0;
                                    });
                                  }
                                },
                              ),
                            ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                playlistShow = !playlistShow;
                              });
                            },
                            icon: playlistShow == true
                                ? Icon(Icons.music_note)
                                : Icon(Icons.playlist_play),
                            iconSize: longeur / 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  playlistShow == true
                      ? Flexible(
                          fit: FlexFit.tight,
                          flex: 8,
                          child: ListWheelScrollView(
                            squeeze: 1,
                            perspective: 0.004,
                            onSelectedItemChanged: (int x) {
                              setState(() {
                                indexWheel = x;
                              });
                            },
                            itemExtent: longeur / 3,
                            children: [
                              for (int index = 0;
                                  index < playlistSongs.length;
                                  index++)
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(longeur / 30))),
                                  color: couleur[indexColor][200],
                                  elevation: 100,
                                  shadowColor: Colors.grey,
                                  margin: EdgeInsets.only(
                                      left: longeur / 40, right: longeur / 40),
                                  child: Container(
                                    padding: EdgeInsets.all(longeur / 60),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              playlistSongs[index].song.title,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: longeur / 50,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 6,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 1,
                                                child: Container(
                                                  height: longeur / 6,
                                                  width: largeur / 2.5,
                                                  child: covers[
                                                      playlistSongs[index]
                                                          .index],
                                                ),
                                              ),
                                              Flexible(
                                                fit: FlexFit.tight,
                                                flex: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: couleur[indexColor]
                                                        [100],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: couleurAccent[
                                                            indexColor],
                                                        blurRadius: 20,
                                                      )
                                                    ],
                                                  ),
                                                  height: longeur / 6,
                                                  width: largeur / 2.5,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 1,
                                                        child: Text(
                                                          "Artist:",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                longeur / 40,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 1,
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Text(
                                                            playlistSongs[index]
                                                                .song
                                                                .artist,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  longeur / 40,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 1,
                                                        child: Text(
                                                          "Duration:",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                longeur / 40,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 1,
                                                        child: Text(
                                                            ((int.parse(playlistSongs[index]
                                                                            .song
                                                                            .duration)) ~/
                                                                        60000)
                                                                    .toString()
                                                                    .padLeft(2,
                                                                        '0') +
                                                                ":" +
                                                                ((int.parse(playlistSongs[index]
                                                                            .song
                                                                            .duration)) ~/
                                                                        1000)
                                                                    .remainder(
                                                                        60)
                                                                    .toString()
                                                                    .padLeft(
                                                                        2, '0'),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  longeur / 40,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ),
                                                      if (playlistSongs[index]
                                                              .index ==
                                                          indexSong)
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons.play_arrow,
                                                            color: Colors
                                                                .greenAccent,
                                                            size: longeur / 30,
                                                          ),
                                                        ),
                                                    ],
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
                            ],
                          ),
                        )
                      : Flexible(
                          fit: FlexFit.tight,
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 8,
                                child: AnimatedBuilder(
                                  animation: _controller,
                                  builder: (_, child) {
                                    return Transform.rotate(
                                      angle: _controller.value * 4 * math.pi,
                                      child: child,
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: longeur / 6.3,
                                    backgroundColor: Colors.grey,
                                    child: CircleAvatar(
                                        radius: longeur / 6.5,
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            AssetImage("images/cd.jpg"),
                                        child: songsinfo.length == 0
                                            ? CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: longeur / 25,
                                                child: Text("Wait...",
                                                    style: TextStyle(
                                                        fontSize:
                                                            longeur / 50)),
                                              )
                                            : CircleAvatar(
                                                radius: longeur / 6.5,
                                                child: covers[indexSong],
                                              )),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: largeur / 30, right: largeur / 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.volume_down,
                                        color: Colors.grey[700],
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: volume,
                                          onChanged: volumeSet,
                                          min: 0,
                                          max: 1,
                                          activeColor: couleur[indexColor],
                                          inactiveColor: Colors.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.volume_up,
                                        color: Colors.grey[700],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    songsinfo.length == 0
                                        ? "Please Start Enjoying Music"
                                        : songsinfo[indexSong].title,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'pacifico',
                                      fontSize: longeur / 40,
                                      fontWeight: FontWeight.w500,
                                      foreground: Paint()
                                        ..shader = linearGradient([
                                          Colors.blueGrey,
                                          couleur[indexColor]
                                        ]),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    songsinfo.length == 0
                                        ? "Made With Love by Farid"
                                        : songsinfo[indexSong].artist,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontFamily: 'pacifico',
                                      fontSize: longeur / 60,
                                      fontWeight: FontWeight.w500,
                                      foreground: Paint()
                                        ..shader = linearGradient([
                                          couleur[indexColor],
                                          Colors.blueGrey
                                        ]),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: nextstate,
                                        icon: afterIcon,
                                        iconSize: longeur / 30,
                                        padding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 2,
                                      child: IconButton(
                                          iconSize: longeur / 16,
                                          padding: EdgeInsets.all(0),
                                          onPressed: previousSong,
                                          icon: Icon(Icons.skip_previous)),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 3,
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) {
                                          return ui.Gradient.linear(
                                            Offset(4.0, 24.0),
                                            Offset(24.0, 4.0),
                                            playing
                                                ? [
                                                    couleurAccent[indexColor],
                                                    Colors.black87,
                                                  ]
                                                : [
                                                    Colors.black87,
                                                    couleurAccent[indexColor],
                                                  ],
                                          );
                                        },
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          iconSize: longeur / 10,
                                          icon: Icon(
                                            playing
                                                ? Icons.pause_circle_outlined
                                                : Icons.play_circle_outline,
                                          ),
                                          onPressed: play,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 2,
                                      child: IconButton(
                                        iconSize: longeur / 16,
                                        padding: EdgeInsets.all(0),
                                        onPressed: nextSong,
                                        icon: Icon(
                                          Icons.skip_next,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) {
                                          return ui.Gradient.linear(
                                            Offset(4.0, 24.0),
                                            Offset(24.0, 4.0),
                                            [
                                              couleur[(indexColor + 1) %
                                                  couleurAccent.length],
                                              Colors.grey,
                                            ],
                                          );
                                        },
                                        child: IconButton(
                                            padding: EdgeInsets.all(0),
                                            iconSize: longeur / 30,
                                            onPressed: star,
                                            icon: Icon(
                                              stateStar
                                                  ? Icons.auto_awesome
                                                  : Icons.auto_awesome_outlined,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Slider(
                                  value: position.inMilliseconds.toDouble(),
                                  onChanged: sliderMusic,
                                  min: 0,
                                  max: songsinfo.length != 0
                                      ? double.parse(
                                          songsinfo[indexSong].duration)
                                      : 0,
                                  activeColor: Colors.black,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: largeur / 30,
                                    right: largeur / 30,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.trending_down,
                                            color: couleur[indexColor],
                                            size: longeur / 35,
                                          ),
                                          songsinfo.length == 0
                                              ? Text(
                                                  "00:00",
                                                  style: TextStyle(
                                                      fontSize: longeur / 60),
                                                )
                                              : Text(
                                                  "  -" +
                                                      ((int.parse(songsinfo[
                                                                          indexSong]
                                                                      .duration) -
                                                                  position
                                                                      .inMilliseconds) ~/
                                                              60000)
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      ":" +
                                                      ((int.parse(songsinfo[
                                                                          indexSong]
                                                                      .duration) -
                                                                  position
                                                                      .inMilliseconds) ~/
                                                              1000)
                                                          .remainder(60)
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                  style: TextStyle(
                                                      fontSize: longeur / 60),
                                                ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          songsinfo.length == 0
                                              ? Text(
                                                  "00:00",
                                                  style: TextStyle(
                                                      fontSize: longeur / 60),
                                                )
                                              : Text(
                                                  ((int.parse(songsinfo[
                                                                      indexSong]
                                                                  .duration)) ~/
                                                              60000)
                                                          .toString()
                                                          .padLeft(2, '0') +
                                                      ":" +
                                                      ((int.parse(songsinfo[
                                                                      indexSong]
                                                                  .duration)) ~/
                                                              1000)
                                                          .remainder(60)
                                                          .toString()
                                                          .padLeft(2, '0'),
                                                  style: TextStyle(
                                                      fontSize: longeur / 60),
                                                ),
                                          Icon(
                                            Icons.timer,
                                            size: longeur / 35,
                                            color: couleur[indexColor],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  if (playlistShow == true &&
                      playlistSongs.length != 0 &&
                      (indexSong != playlistSongs[indexWheel].index ||
                          playing == false))
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: IconButton(
                          iconSize: longeur / 20,
                          onPressed: () {
                            setState(() {
                              playing = true;
                              indexSong = playlistSongs[indexWheel].index;
                            });

                            _player.play(songsinfo[indexSong].filePath,
                                isLocal: true);
                            _player.setVolume(volume);
                          },
                          icon: Icon(
                            Icons.play_arrow_outlined,
                            color: Colors.greenAccent,
                          )),
                    )
                  else if (playlistShow == true &&
                      playlistSongs.length != 0 &&
                      indexSong == playlistSongs[indexWheel].index)
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: IconButton(
                          iconSize: longeur / 20,
                          onPressed: () {
                            setState(() {
                              playing = false;
                            });
                            _player.pause();
                          },
                          icon: Icon(
                            Icons.pause,
                            color: Colors.greenAccent,
                          )),
                    ),
                ],
              ),
            ]),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70))),
          ),
        ),
      ]),
    );
  }
}

//Glow
//  CircularParticle(
//                       height: longeur / 3,
//                       width: largeur,
//                       isRandomColor: false,
//                       awayRadius: largeur / 5,
//                       onTapAnimation: true,
//                       enableHover: true,
//                       hoverColor: Colors.black,
//                       hoverRadius: 90,
//                       speedOfParticles: 1.5,
//                       maxParticleSize: 7,
//                       connectDots: true,
//                       isRandSize: true,
//                       numberOfParticles: 150,
//                       particleColor: Colors.pink.withOpacity(.7),
//                       awayAnimationCurve: Curves.easeInOutBack,
//                     ),
class PairItem {
  PairItem(this.index, this.song);
  SongInfo song;
  int index;
}
