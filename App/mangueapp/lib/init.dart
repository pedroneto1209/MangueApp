import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

Color backgroundDown = Color(0xFF101820);
Color backgroundMid = Color(0xFF090D11);
Color backgroundUp = Color(0xFF000000);
Color textColor = Color(0xFFFFFFFF);
Color logoColor = Color(0xFF087234);
Color circleBackground = Color(0xFF666666);
String img = 'assets/Icons/Header/manguebeat.png';
String crab = 'assets/Icons/Crab/manguebeat.png';

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  BluetoothDevice device;
  BluetoothState state;
  BluetoothDeviceState deviceState;
  List<Widget> cont = [Container()];
  FlutterBlue bluetoothInstance = FlutterBlue.instance;
  StreamSubscription scanSubscription;
  
  @override
  void initState() {
    super.initState();

    if (read('colorBackD') != null) {
      read('colorBackD').then((value) {backgroundDown = Color(value);});
      read('colorBackM').then((value) {backgroundMid = Color(value);});
      read('colorBackU').then((value) {backgroundUp = Color(value);});
      read('colorText').then((value) {textColor = Color(value);});
      read('colorLogo').then((value) {logoColor = Color(value);});
      read('colorCircle').then((value) {circleBackground = Color(value);});
      reads('colorImg').then((value) {img = value;});
      reads('colorImgC').then((value) {crab = value;});
    }

    //checks bluetooth current state
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        setState(() {
          cont = [Container(
            height: 200,
            child: Center(
              child: Text('Por favor, ative seu bluetooth!',
              style: TextStyle(
                fontFamily: 'Ageoextrabold',
                fontSize: 18,
                color: textColor
                )
              )
            )
          )];
        });
      } else if (state == BluetoothState.on) {
        scanForDevices(); 
        setState(() {
          cont = [Container(
            height: 200,
            child: Center(
              child: Text('Procurando o dispositivo...',
              style: TextStyle(
                fontFamily: 'Ageoextrabold',
                fontSize: 18,
                color: textColor
                )
              )
            )
          )];
        });
      }
    });
  }

  Future<int> read(String cor) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(cor);
    return value;
  }

  Future<String> reads(String cor) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(cor);
    return value;
  }

  void scanForDevices() async {
    List<BluetoothDevice> devices = [];
    List<String> devicesname = [];

    scanSubscription = bluetoothInstance.scan().listen((scanResult) async {
      if (!devices.contains(scanResult.device)) {
        devices.add(scanResult.device);
      }

      Future.delayed(const Duration(milliseconds: 4000), () {
        stopScanning();

        devicesname = [];

        for (BluetoothDevice d in devices) {
          if (d.name == '') {
            devicesname.add(d.id.toString());
          } else {
            devicesname.add(d.name);
          }
        }

        List<Widget> c = fill(devicesname);
        setState(() {
          cont = c;
        });
      });
    });
  }

  void stopScanning() {
    bluetoothInstance.stopScan();
    scanSubscription.cancel();
  }

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
                    child: Image.asset(img, width: 134),
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
                  children: cont,
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

  List<Widget> fill(List<String> list) {
    List<Widget> result = [];
    for (String s in list) {
      result.add(
        option(s, Icon(Icons.bluetooth, color: logoColor))
      );
    }
    return result;
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
}
