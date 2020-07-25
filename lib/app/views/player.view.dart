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
        "Rap do Bam (Tower of God)",
        "Basara",
        "https://img1.ak.crunchyroll.com/i/spire1/883cdbb8c791ff02c2c11e80d32ae1681585766451_full.png",
        "http://dl66.y2mate.com/?file=M3R4SUNiN3JsOHJ6WWQ2a3NQS1Y5ZGlxVlZIOCtyZ1dtY1Z4d3g5b0k2cEI3Y2g5ajlDdk5NeGRaYWdKaHEydEZac0dySFdkSnZQQUF3ckNrSmMwQ1VPTzVaMEx0anlLME4xbGVPZzZFMEhiME1TaWhUQmtpRGlzYlBxVUlZOVNlbGdqc0E1dXczWFZ5dmpZdkNyb3NtbWwrZ2pSU2owRnB5OGVQL0NWbzdsRnhUcU9QZEhobHNJanRIU1M0NDVNbFBPU3VVcTdpS0EvcU9OeFVYdDJjcDFpelpYaTJ1THpxa0VtaDVZWTVWNmhsdVNwRktFbEU3ZWhiemh6T3gwTDZQenVUaG9obGpjOG9WaUo4cmdLdG5OSGZMQW1ybWVzNmZ2N1l5dVJjOGVySHNUZGY3N3I5WjJvdGI5eXRsdkUrN2VVenNJU3dWM2hXOTZpVmNkZA%3D%3D"),
    Musica(
        "Intangível",
        "Tauz",
        "https://i.ytimg.com/vi/oznS7uzaBpE/maxresdefault.jpg",
        "http://dl38.y2mate.com/?file=M3R4SUNiN3JsOHJ6WWQ2a3NQS1Y5ZGlxVlZIOCtyZ1FtY0FnakYxb0tJVjRoNk1Ja3NmelpwRnJHSUlqOHRQNkNQcGY5anI2ZmNtbWZnS1o1ZDRnUzMrRXlNWThyVGVTdHR3R1FNWmtRZ1A2bnFQeHNEeG0ya0tuV04ySVI1NVBQM3A2dDBVdDBDbWVoN3lmclJUdHFVS2txVm1DWWlNRHBENEhBcXlJNkx0RDFtM3BZKzdKblowVi9tQ2Erb3BBeVBXSnZRenpudU5yNFlrakNCY3RJTVFieXBQdjJxMmY4aEZLMGM1T25GNnk5UEd3VXc9PQ%3D%3D")
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
