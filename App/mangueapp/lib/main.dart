import 'package:flutter/material.dart';
import 'models/circle.dart';
import 'models/global.dart';
//added for testing
import "dart:math";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'Init',
      routes: {
        'Init': (context) => InitScreen(),
        'Home': (context) => HomeScreen(),
      },
      home: InitScreen(),
    );
  }
}

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Set appbar to control system icons color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: backgroundUp,
        )
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 65, 0, 0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                    Container(
                      height: 180,
                      width: 292
                    ),
                  Positioned(
                    bottom: 50,
                    child: Image.asset('assets/images/HeaderLogo.png', width: 134),
                  ),
                  Text(
                    'mangue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ageoextrabold',
                      fontSize: 80,
                      color: logoColor
                    )
                  ),
                ],
              ),
            ),
            Container(
              height: 4,
              width: 345,
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Text(
                'Olá, Conecte-se ao baja!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Ageoextrabold',
                  fontSize: 25,
                  color: textColor
                ),
              ),
            ),
            //List of bluetooths
            Container(
              height: 250,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView(
                  children: getList(),
                ),
              ),
            ),
            //Link pro home
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'Home');
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 42, 0, 0),
                child: Text(
                  'Não quer se conectar? clique aqui para acessar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'Ageoextrabold',
                    fontSize: 15,
                    color: logoColor
                  ),
                ),
              )
            ),
          ],
        ),
        //Makes the gradient background
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [0.10, 0.25, 0.5],
              colors: [backgroundUp, backgroundMid, backgroundDown],
          ),
        ),
      )
    );
  }

  //List of bluetooths
  List<Widget> getList() {
    return [
      option('HC - 06'),
      option('AirPods de Rafael'),
      option('Isso n é bluetooth de vdd'),
    ];
  }

  Widget option(String name) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          height: 60,
        ),
        Positioned(
          bottom: 20,
          left: 60,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'HP',
              fontSize: 15,
              color: textColor
            ),
          ),
        ),
        Container(
          height: 2,
          width: 330,
          color: backgroundUp
        ),
        Positioned(
          bottom: 20,
          left: 33,
          child: Image.asset('assets/images/bluetooth.png', width: 20),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int vel = 0, rot = 0, tempo = 0, tempc = 0;
  double acc = 0.0, press = 0.0;

  //this part is to test
  var vellist = [23, 24 ,25, 26];
  var rotlist = [2000, 2200 , 2400, 2600];
  var presslist = [2.8, 0.5 , 3.0, 0.3];
  var acclist = [-0.42, -0.2 , 0.8, 1.01];
  var tempolist = [92, 93];
  var tempclist = [143, 142];
  final _random = new Random();
  //end of test
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 2,
        length: 5,
        child:Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: TabBarView(
              children: getPages(),
            ),
            bottomNavigationBar: Container(
              height: 70,
              color: backgroundUp,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(IconData(0xe900, fontFamily: 'Emergency'), size: 35,)
                  ),
                  Tab(
                    icon: Icon(IconData(0xe902, fontFamily: 'Map'), size: 35,)
                  ),
                  //testing 
                  GestureDetector(
                  onTap: () {
                  setState(() {
                  this.vel = vellist[_random.nextInt(vellist.length)];
                  this.rot = rotlist[_random.nextInt(rotlist.length)];
                  this.press = presslist[_random.nextInt(presslist.length)];
                  this.acc = acclist[_random.nextInt(acclist.length)];
                  this.tempo = tempolist[_random.nextInt(tempolist.length)];
                  this.tempc = tempclist[_random.nextInt(tempclist.length)];
                  }
                  );
                },
                  child: Tab(
                    icon: Icon(IconData(0xe901, fontFamily: 'Live'), size: 35,)
                  )
                  ),
                  //testing
                  Tab(
                    icon: Icon(IconData(0xe903, fontFamily: 'Server'), size: 35,)
                  ),
                  Tab(
                    icon: Icon(Icons.settings, size: 35)
                  )
                ],
                labelColor: logoColor,
                unselectedLabelColor: textColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: backgroundDown,
                )
              ),
            ),
          ),
          //set gradient background
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [0.10, 0.25, 0.5],
                colors: [backgroundUp, backgroundMid, backgroundDown],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getPages () {
    return [
      Container(
      ), 
      Container(
      ),
      Container(
        child: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            liveitem('Velocidade', this.vel.toString(), this.vel/60, 'Km/h'),
            liveitem('Rotação', this.rot.toString(), this.rot/4000, 'RPM'),
            liveitem('Pressão do freio', this.press.toString(), this.press/11, 'Mpa'),
            liveitem('Acelerações', this.acc.toString(), this.acc/4, 'g'),
            liveitem('Temp. do óleo', this.tempo.toString(), this.tempo/180, '°C'),
            liveitem('Temp. da CVT', this.tempc.toString(), this.tempc/350, '°C'),
          ],
        ),
      ),
      Container(
        width: 300,
        height: 300
      ),
      Container(
      ),
    ];
  }

  Widget liveitem(String name, String valor, double percent, String unity) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: Container(
            height: 4,
            width: 150,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
          ),
        ),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Ageoextrabold',
            fontSize: 15,
            color: logoColor
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                width: 126,
                child: CircleProgressBar(
                  foregroundColor: logoColor,
                  backgroundColor: circleBackground,
                  value: percent
                ),
              ),
              Text(
                valor,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'HP',
                  fontSize: 30,
                  color: textColor
                ),
              ),
              Positioned(child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 42, 0, 0),
                child: Text(
                  unity,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'HP',
                    fontSize: 15,
                    color: textColor
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }
}