import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  print('bdenaaaa');
  runApp(Bazzoka());
}

class Bazzoka extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "bazz",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHome(),
      debugShowCheckedModeBanner: false,
    );
    throw UnimplementedError();
  }
}

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homeState();
    throw UnimplementedError();
  }
}

class _homeState extends State<MyHome> {
  var x = [
    Icon(Icons.mail),
    Icon(Icons.nat),
    Icon(Icons.batch_prediction_outlined),
    Icon(Icons.headphones),
    Icon(Icons.padding_outlined)
  ];
  List<MyCard> cards = [
    new MyCard(
      image: "images/icon.png",
      callbackdel: null,
      callbackver: null,
    ),
    new MyCard(
      image: "images/flutter.png",
      callbackdel: null,
      callbackver: null,
    ),
    new MyCard(
      image: "images/farid.jpeg",
      callbackdel: null,
      callbackver: null,
    ),
    new MyCard(
      image: "images/linux.jpg",
      callbackdel: null,
      callbackver: null,
    )
  ];
  var index = 1;
  void nextIcon() {
    setState(() {
      index = (index + 1) % x.length;
    });
  }

  void delete(MyCard indice) {
    setState(() {
      this.cards.remove(indice);
      print(this.cards);
      print(indice.callbackdel);
    });
  }

  void verified() {
    print('verified');
  }

  @override
  Widget build(BuildContext context) {
    for (MyCard c in this.cards) {
      c.callbackdel = delete;
      c.callbackver = verified;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.account_circle,
          color: Colors.blue,
        ),
        title: Text("Bazzocam"),
        centerTitle: true,
        shadowColor: Colors.deepPurpleAccent,
        actions: [
          Icon(
            Icons.face,
            color: Colors.green[500],
          ),
          Icon(Icons.verified, color: Colors.white),
          Icon(Icons.baby_changing_station, color: Colors.red),
        ],
        elevation: 60,
      ),
      body: Column(
        children: cards,
      ),
      floatingActionButton: FloatingActionButton(
        child: x[(index + 1) % x.length],
        focusColor: Colors.black,
        onPressed: () => print('hello'),
      ),
    );
    throw UnimplementedError();
  }
}

class MyCard extends StatefulWidget {
  MyCard(
      {Key? key,
      this.image = "images/icon.png",
      this.callbackdel,
      this.callbackver})
      : super(key: key);
  var callbackdel;
  var callbackver;
  String image;

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  void delete() {
    this.widget.callbackdel(this.widget);
  }

  void verified() {
    this.widget.callbackver();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          color: Colors.white60,
          margin: EdgeInsets.all(10),
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(this.widget.image),
                radius: 50,
                child: Text(
                  "HF",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: Text(
                        "this is m fs is no aryou want to deal with other notification this is no argue to have seen this before "),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: delete,
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: verified,
                        icon: Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          )),

      // height: MediaQuery.of(context).size.height / 6,
      // width: MediaQuery.of(context).size.width / 1.2,
    );
  }
}
