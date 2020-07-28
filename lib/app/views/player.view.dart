import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutify/app/views/player.controls.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayerView extends StatefulWidget {
  @override
  PlayerViewState createState() => PlayerViewState();
}

class Musica {
  String nome, artista, artwork, url;

  Musica(this.nome, this.artista, this.artwork, this.url);
}

class PlayerViewState extends State<PlayerView> {
  List<Musica> _tracks = [
    Musica("On & On", "Cartoon, Daniel Levi", "https://i.imgur.com/3f1l5OW.jpg",
        "https://music.mp3-download.best/guWBZB:fsTAsB"),
    Musica(
        "So far away",
        "Martin Garrix, David Guetta, Jamie Scott, Romy Dia",
        "https://upload.wikimedia.org/wikipedia/en/0/01/Martin_Garrix_and_David_Guetta_So_Far_Away.jpg",
        "https://music.mp3-download.best/-fEkFvH:zYeeG"),
    Musica(
        "Unstoppable",
        "The Score",
        "https://images.genius.com/abbe0b25dbcc59e00fda8bbc2289d5b6.500x500x1.jpg",
        "https://music.mp3-download.best/JcGuV:JZX1rB")
  ];

  PaletteGenerator _generator;
  Musica musica;

  Future<void> _updatePaletteGenerator() async {
    String artwork = musica.artwork;

    _generator = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(artwork, errorListener: () {
      print("deu erro");
    }));
    setState(() {});
  }

  @override
  void initState() {
    // forcar a orientação de tela
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
    musica = _tracks[Random().nextInt(_tracks.length)];
    _updatePaletteGenerator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
            color: _generator == null
                ? Colors.black
                : _generator.vibrantColor == null
                    ? Colors.grey
                    : _generator.vibrantColor.color,
            duration: Duration(milliseconds: 500),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromRGBO(0, 0, 0, 0.1),
                    const Color.fromRGBO(0, 0, 0, 1)
                  ],
                  stops: [
                    0.05,
                    1
                  ]),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return new Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 60),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Tocando da sua biblioteca".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Spotify_Book",
                            fontSize: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          "Músicas curtidas",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: musica.artwork,
                          ),
                        ),
                      ),
                      PlayerControlsView(musica)
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
