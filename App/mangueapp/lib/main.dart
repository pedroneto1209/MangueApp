import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:mangueapp/bloc/resources/repository.dart';
import 'package:mangueapp/models/UI/loginscreen.dart';
import 'package:mangueapp/models/UI/theme.dart';
import 'models/UI/circle.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mangueapp/bloc/blocs/user_bloc_provider.dart';
import 'package:mangueapp/init.dart';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';

import 'models/classes/graph.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      initialRoute: 'Init',
      routes: {
        'Init': (context) => InitScreen(),
        'Home': (context) => HomeScreen(),
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
  List<Graph> graphs;
  TextEditingController usernameText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  String searchtype;
  String searchpar;
  List<double> graphdata;

  bool graph = false;
  bool searched = false;
  bool tappedgraph = false;
  List<Widget> graphsarray = [];

  GraphBloc graphBloc;
  Repository _repository = Repository();
  String apiKey = '';

  int sup = 0;
  List<double> pckg = List.filled(150, 0);
  List<double> tim = [for(double i=0; i<150; i+=1) i];
  List<double> tim1 = [for(double i=0; i<150; i+=1) i];

  //map requirements
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
  }

  double lat = -8.05428;
  double long = -34.8813;

  void _setMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString(mapStyle);
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
          child: !isready ? getPages() : getPagesNew(),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [0.10, 0.25, 0.5],
                colors: [backgroundUp, backgroundMid, backgroundDown],
            ),
          ),
        )
      )
    );
  }

  Widget getPagesNew () {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children:[
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget> [
            Container(
              child: GoogleMap(
                myLocationButtonEnabled: false,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 11.0,
                ),
              ),
            ),
            //Stack(
            //  alignment: AlignmentDirectional.center,
            //  children: <Widget>[
            //    Container(
            //      height: 42,
            //      width: MediaQuery. of(context).size.width/4,
            //      color: Colors.transparent,
            //      child: Container(
            //        decoration: BoxDecoration(
            //          color: backgroundDown,
            //          borderRadius: BorderRadius.only(
            //            topLeft: Radius.circular(10),
            //            topRight: Radius.circular(10),
            //          ),
            //          boxShadow: [
            //            BoxShadow(
            //              color: Colors.black.withOpacity(0.5),
            //              spreadRadius: 5,
            //              blurRadius: 7,
            //              offset: Offset(0, 3), // changes position of shadow
            //            ),
            //          ],
            //        ),
            //      ),
            //    ),
            //    Text(
            //      '150.00 Km/h',
            //      textAlign: TextAlign.center,
            //      style: TextStyle(
            //        fontFamily: 'HP',
            //        fontSize: 12,
            //        color: logoColor
            //      ),
            //    ),
            //  ],
            //),
          ]
        ),
        StreamBuilder<List<int>>(
          stream: listStream,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var curValue = _dataParser(snapshot.data);
              var curTime = _timeParser(snapshot.data);

              pckg[sup] = curValue;
              sup++;

              if (curTime % 15 == 0) {
                print('sent');
                String liststring = listString(pckg);
                var now  = DateTime.now().toString();
                addGraph(liststring, now, graphname);
                sup = 0;
                pckg = List.filled(150, 0);
                tim = [for(double i=0; i<150; i+=1) i];
              }

              return !graph ? Container(
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: <Widget>[
                    liveitem('Velocidade', (curValue*3 + 30).toString(), (curValue*3 + 30)/60, 'Km/h'),
                    liveitem('Rotação', (curValue*100 + 3000).toString(), (curValue*100 + 3000)/4000, 'RPM'),
                    liveitem('Pressão do freio', (curValue*4 + 6).toString(), (curValue*4 + 6)/11, 'Mpa'),
                    liveitem('Acelerações', (curValue + 1.5).toString(), (curValue + 1.5)/4, 'g'),
                    liveitem('Temp. do óleo', (curValue + 82).toString(), (curValue + 82)/180, '°C'),
                    liveitem('Temp. da CVT', (curValue*2 + 176).toString(), (curValue*2 + 176)/350, '°C'),
                  ],
                ),
              ):
              Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Container(color: Colors.transparent),
                  Column(
                    children: <Widget>[
                      Container(height: 200,),
                      Container(
                        height: 200,
                        child: BezierChart(
                          
                          bezierChartScale: BezierChartScale.CUSTOM,
                          xAxisCustomValues: tim,
                          series: [
                            BezierLine(
                              lineColor: textColor,
                              data: dataForGraph(pckg, tim),
                            ),
                          ],
                          config: BezierChartConfig(
                            showDataPoints: false,
                            verticalIndicatorColor: logoColor,
                            displayYAxis: true,
                            xAxisTextStyle: TextStyle(
                              color: Colors.transparent,
                            ),
                            yAxisTextStyle: TextStyle(
                              color: logoColor
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: GestureDetector(
                      onTap: () {
                        graph = false;
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: logoColor,
                      ),
                    ),
                    top: 25,
                    left: 10,
                  ),
                ],
              );
            } else {
              return SizedBox();
            }
          }
        ),
        FutureBuilder(
          future: signinUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            
            if (snapshot.hasData){
              apiKey = snapshot.data;
              graphBloc = GraphBloc();
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ThemeScreen()));
                  },
                ),
                GestureDetector(
                  child: Container(color: Colors.transparent, child: option('Conectar ao bluetooth', Icon(Icons.bluetooth, color: logoColor))),
                  onTap: () {
                    if (isconn) {
                      disconnectToDevice(devv);
                    }
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
        ]
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: backgroundUp,
        child: TabBar(
          tabs: [
            Tab(
              icon: Icon(IconData(0xe902, fontFamily: 'Map'), size: 30)
            ),
            Tab(
              icon: Icon(IconData(0xe901, fontFamily: 'Live'), size: 30)
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
    );
  }

  List<DataPoint> dataForGraph (List<double> pckg, List<double> tim) {
    List<DataPoint> a = [];
    for (double v in pckg) {
      a.add(DataPoint<double>(value: double.parse((v + 1).toStringAsFixed(2)), xAxis: tim[pckg.indexOf(v)]));
    }
    return a;
  }

  void addGraph (String data, String date, String datatype) async {
    await _repository.addUserGraph(apiKey, data, date, datatype);
  }

  Future getGraph () async {
    graphs = await _repository.getGraphs(apiKey);
  }

  String listString(List<double> list) {
    String result = '';
    for (double d in list) {
      result += d.toString() + ', ';
    }
    return result;
  }

  Widget getPages () {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget> [
              Container(
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 11.0,
                  ),
                ),
              ),
              //Stack(
              //  alignment: AlignmentDirectional.center,
              //  children: <Widget>[
              //    Container(
              //      height: 42,
              //      width: MediaQuery. of(context).size.width/4,
              //      color: Colors.transparent,
              //      child: Container(
              //        decoration: BoxDecoration(
              //          color: backgroundDown,
              //          borderRadius: BorderRadius.only(
              //            topLeft: Radius.circular(10),
              //            topRight: Radius.circular(10),
              //          ),
              //          boxShadow: [
              //            BoxShadow(
              //              color: Colors.black.withOpacity(0.5),
              //              spreadRadius: 5,
              //              blurRadius: 7,
              //              offset: Offset(0, 3), // changes position of shadow
              //            ),
              //          ],
              //        ),
              //      ),
              //    ),
              //    Text(
              //      '150.00 Km/h',
              //      textAlign: TextAlign.center,
              //      style: TextStyle(
              //        fontFamily: 'HP',
              //        fontSize: 12,
              //        color: logoColor
              //      ),
              //    ),
              //  ],
              //),
          ]
        ),
          Container(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: <Widget>[
                liveitem('Velocidade', '0', 0.0, 'Km/h'),
                liveitem('Rotação', '0', 0.0, 'RPM'),
                liveitem('Pressão do freio', '0', 0.0, 'Mpa'),
                liveitem('Acelerações', '0', 0.0, 'g'),
                liveitem('Temp. do óleo', '0', 0.0, '°C'),
                liveitem('Temp. da CVT', '0', 0.0, '°C'),
              ],
            ),
          ),
          FutureBuilder(
            future: signinUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      if (isconn) {
                        disconnectToDevice(devv);
                      }
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
        ]
      ),
      bottomNavigationBar: Container(
        height: 65,
        color: backgroundUp,
        child: TabBar(
          tabs: [
            Tab(
              icon: Icon(IconData(0xe902, fontFamily: 'Map'), size: 30)
            ),
            Tab(
              icon: Icon(IconData(0xe901, fontFamily: 'Live'), size: 30)
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
    );
  }

  disconnectToDevice(BluetoothDevice device) async {
    await device.disconnect();
    isconn = false;
  }

  double _dataParser(List<int> dat) {
    String s = utf8.decode(dat);
    s = s.substring(0, s.indexOf(', '));
    return double.parse(s);
  }

  double _timeParser(List<int> dat) {
    String s = utf8.decode(dat);
    s = s.substring(s.indexOf(', ') + 1);
    return double.parse(s);
  }

  Widget optwidg = Padding(
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
  );

  Widget databasewidget(){
    return !searched ? Container(
      child:
      Center(
        child: 
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                'Preencha os dados do gráfico:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Ageo',
                  fontSize: 20,
                  color: logoColor
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Tipo do teste',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Ageo',
                          fontSize: 16,
                          color: logoColor
                        ),
                      ),
                      Container(
                        width: 110,
                        height: 40,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(hintText: '',
                          hoverColor: Colors.black),
                          items: <String>['AV', 'SquidPad', 'AR', 'Freio'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Ageo',
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String select) {
                            searchtype = select;
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Parâmetro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Ageo',
                        fontSize: 16,
                        color: logoColor
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration.collapsed(hintText: '',
                        hoverColor: Colors.black),
                        items: <String>['Velocidade', 'Rotação', 'Pressão freio', 'Aceleração X', 'Aceleração Y', 'Aceleração Z', 'Temperatura óleo', 'Temperatura motor'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Ageo',
                                  fontSize: 15,
                                  color: Colors.black
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String select) {
                          searchpar = select;
                        },
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: GestureDetector(
                onTap: () {
                  graphsarray = [];
                  getGraph().then((_) {
                    setState(() {
                      for (Graph g in graphs) {
                        if (searchtype == g.typedata){
                          graphsarray.add(graphopt(g));
                        }
                      }
                      searched = true;
                    });
                  });
                  setState(() {
                    optwidg = Center(
                      child: Container(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textColor),),
                      ),
                    );
                  });
                },
                child: Container(
                  height: 30,
                  width: 130,
                  child: optwidg,
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
    ) : !tappedgraph?
    Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(color: Colors.transparent),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
          child: ListView(
            children: graphsarray
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              setState(() {
                searched = false;
                optwidg = Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text(
                    'Pesquisar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Ageoextrabold',
                      fontSize: 18,
                      color: textColor
                    )
                  )
                );
              });
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: logoColor,
            ),
          ),
          top: 25,
          left: 10,
        ),
      ],
    ) :
    Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(color: Colors.transparent),
        Column(
          children: <Widget>[
            Container(height: 200,),
            Container(
              height: 200,
              child: BezierChart(
                bezierChartScale: BezierChartScale.CUSTOM,
                xAxisCustomValues: tim1,
                series: [
                  BezierLine(
                    lineColor: textColor,
                    data: dataForGraph(graphdata, tim1),
                  ),
                ],
                config: BezierChartConfig(
                  pinchZoom: true,
                  showDataPoints: false,
                  verticalIndicatorColor: logoColor,
                  displayYAxis: true,
                  xAxisTextStyle: TextStyle(
                    color: Colors.transparent,
                  ),
                  yAxisTextStyle: TextStyle(
                    color: logoColor
                  )
                ),
              ),
            ),
          ],
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              setState(() {
                tappedgraph = false;
              });
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: logoColor,
            ),
          ),
          top: 25,
          left: 10,
        ),
      ],
    );
  }

  Widget graphopt(Graph g) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tappedgraph = true;
          graphdata = icontrans(g.data);
        });
      },
      child: Container(
        height: 100,
        color: Colors.transparent,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              height: 100,
            ),
            Positioned(
              top: 10,
              right: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 200,
                    child: BezierChart(
                      bezierChartScale: BezierChartScale.CUSTOM,
                      xAxisCustomValues: tim1,
                      series: [
                        BezierLine(
                          lineColor: textColor,
                          data: dataForGraph(icontrans(g.data), tim1),
                        ),
                      ],
                      config: BezierChartConfig(
                        pinchZoom: true,
                        showDataPoints: false,
                        verticalIndicatorColor: logoColor,
                        displayYAxis: false,
                        xAxisTextStyle: TextStyle(
                          color: Colors.transparent,
                        ),
                        yAxisTextStyle: TextStyle(
                          color: logoColor
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      g.date.substring(0, 19),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'HP',
                        fontSize: 15,
                        color: textColor
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              width: 330,
              color: textColor
            ),
          ],
        ),
      ),
    );
  }

  List<double> icontrans (String data) {
    List<String> list = [];
    List<double> listd = [];
    List<double> pckg = List.filled(150, 0);
    list = data.split(', ');
    list.removeLast();
    //print(list);
    for (String i in list) {
      listd.add(double.parse(i));
    }
    int s = 0;
    for (double i in listd) {
      //print(s);
      pckg[s] = i;
      if (s < 149){
        s++;
      }
    }
    //print(pckg);
    //print(pckg);
    return pckg;
  }

  Future signinUser() async {
    String apiKey = await getApiKey();
    if (apiKey.length > 0) {
      userBloc.signinUser("", "", apiKey);
    } else {
      //print("No api key");
    }
    return apiKey;
  }

  Future getApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('APIToken');
  }

  Widget liveitem(String name, String valor, double percent, String unity) {
    return GestureDetector(
      onTap: () {
        graph = true;
      },
      child: Column(
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
                  width: 110,
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
                    fontSize: 25,
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
      ),
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