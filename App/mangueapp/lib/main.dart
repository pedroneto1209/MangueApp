import 'package:flutter/material.dart';
import 'package:mangueapp/models/UI/database.dart';
import 'package:mangueapp/models/UI/loginscreen.dart';
import 'package:mangueapp/models/UI/theme.dart';
import 'models/UI/circle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "dart:math";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mangueapp/bloc/blocs/user_bloc_provider.dart';
import 'package:mangueapp/init.dart';
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
        'DataBase': (context) => DataBasePage(),
        'Theme': (context) => ThemeScreen()
      },
      home: InitScreen()
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

  TextEditingController usernameText = new TextEditingController();
  TextEditingController passwordText = new TextEditingController();

  //this part is to test
  var vellist = [23, 24 ,25, 26];
  var rotlist = [2000, 2200 , 2400, 2600];
  var presslist = [2.8, 0.5 , 3.0, 0.3];
  var acclist = [-0.42, -0.2 , 0.8, 1.01];
  var tempolist = [92, 93];
  var tempclist = [143, 142];
  final _random = new Random();
  //end of test

  //map requirements
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
  }

  double lat = 45.521563;
  double long = -122.677433;

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    mapController.setMapStyle(style);
  }
  //end of map requirements

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 2,
        length: 4,
        child:Container(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: getPages(),
            ),
            bottomNavigationBar: Container(
              height: 65,
              color: backgroundUp,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(IconData(0xe902, fontFamily: 'Map'), size: 30)
                  ),
                  GestureDetector(
                  onTap: () {
                  setState((){
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
                    icon: Icon(IconData(0xe901, fontFamily: 'Live'), size: 30)
                  )
                  ),
                  Tab(
                    icon: Icon(IconData(0xe903, fontFamily: 'Server'), size: 30)
                  ),
                  Tab(
                    icon: Icon(Icons.settings, size: 30)
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
      Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget> [
          Container(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 11.0,
              ),
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                height: 42,
                width: 226,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundDown,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Última velocidade máx.: 49 Km/h',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'HP',
                  fontSize: 15,
                  color: logoColor
                ),
              ),
            ],
          ),
        ]
      ),
      Container(
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
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
      FutureBuilder(
        future: signinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          String apiKey = '';
          if (snapshot.hasData){
            apiKey = snapshot.data;
          } else{
          }

          return apiKey.length > 0 ? databasewidget() : LoginPage(login: login, newUser: false);
        },
      ),
      Container(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: <Widget> [
              Container(
                height: 20,
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Tema', Icon(Icons.format_paint, color: logoColor))
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'Theme');
                },
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Conectar ao bluetooth', Icon(Icons.bluetooth, color: logoColor))),
                onTap: () {
                  Navigator.pushNamed(context, 'Init');
                }
              ),
              GestureDetector(
                child: Container(color: Colors.transparent, child: option('Logout', Icon(Icons.exit_to_app, color: logoColor))),
                onTap: () {
                  logout();
                }
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Widget databasewidget(){
    return Container(
      child:
      Center(
        child: 
        Column(
          children: <Widget>[
            Text(
              'Pesquise os dados por data ou nome:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Ageo',
                fontSize: 18,
                color: logoColor
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Container(
                height: 50,
                width: 345,
                color: Colors.transparent,
                child: Stack(
                  children: <Widget>[
                  Container(
                    child: Padding(
                    padding: EdgeInsets.fromLTRB(38, 0, 10, 9),
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Ageo',
                        fontSize: 18,
                        color: textColor
                      ),
                      maxLength: 28,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                        color: textColor,
                        width: 2
                      )
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 13, 0, 0),
                  child: Icon(Icons.search, color: textColor)
                  )
                  ]
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'DataBase');
                },
                child: Container(
                  height: 30,
                  width: 130,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      'Pesquisar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Ageoextrabold',
                        fontSize: 18,
                        color: textColor
                      )
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: textColor,
                      width: 1
                    )
                  ),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }

  Future signinUser() async {
    String apiKey = await getApiKey();
    if (apiKey.length > 0) {
      userBloc.signinUser("", "", apiKey);
    } else {
      print("No api key");
    }
    return apiKey;
  }

  Future getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('APIToken');
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

  Widget option(String name, Widget icon) {
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
          color: textColor
        ),
        Positioned(
          bottom: 18,
          left: 33,
          child: icon
        ),
      ],
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('APIToken', '');
    setState(() {
      build(context);
    });
  }

  void login() {
    setState(() {
      build(context);
    });
  }

  @override
    void initState() {
      super.initState();
    }
}