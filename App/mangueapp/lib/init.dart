import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mangueapp/main.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Color backgroundDown = Color(0xFF101820);
Color backgroundMid = Color(0xFF090D11);
Color backgroundUp = Color(0xFF000000);
Color textColor = Color(0xFFFFFFFF);
Color logoColor = Color(0xFF087234);
Color circleBackground = Color(0xFF666666);

String img = 'assets/Icons/Header/manguebeat.png';
String crab = 'assets/Icons/Crab/manguebeat.png';
String mapStyle = 'assets/Maps/manguebeat.json';
StreamController<List<int>> cont = StreamController<List<int>>.broadcast();
Stream listStream = cont.stream;
bool isready;
bool isconn = false;
BluetoothDevice devv;
String graphname;
int nottheme;

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

    read('colorBackD').then((value) {
      nottheme = value;
    });

    if (nottheme != null) {
      read('colorBackD').then((value) {
        backgroundDown = Color(value);
      });
      read('colorBackM').then((value) {
        backgroundMid = Color(value);
      });
      read('colorBackU').then((value) {
        backgroundUp = Color(value);
      });
      read('colorText').then((value) {
        textColor = Color(value);
      });
      read('colorLogo').then((value) {
        logoColor = Color(value);
      });
      read('colorCircle').then((value) {
        circleBackground = Color(value);
      });
      reads('colorImg').then((value) {
        img = value;
      });
      reads('colorImgC').then((value) {
        crab = value;
      });
    }

    //checks bluetooth current state
    FlutterBlue.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        setState(() {
          cont = [
            Container(
                height: 200,
                child: Center(
                    child: Text('Por favor, ative seu bluetooth!',
                        style: TextStyle(
                            fontFamily: 'Ageoextrabold',
                            fontSize: 18,
                            color: textColor))))
          ];
        });
      } else if (state == BluetoothState.on) {
        scanForDevices();
        setState(() {
          cont = [
            Container(
                height: 200,
                child: Center(
                    child: Text('Procurando o dispositivo...',
                        style: TextStyle(
                            fontFamily: 'Ageoextrabold',
                            fontSize: 18,
                            color: textColor))))
          ];
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

    scanSubscription = bluetoothInstance.scan().listen((scanResult) async {
      if (!devices.contains(scanResult.device)) {
        devices.add(scanResult.device);
      }

      Future.delayed(const Duration(milliseconds: 4000), () {
        stopScanning();

        List<Widget> c = fill(devices);
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
            )),
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
                    Container(height: 180, width: 292),
                    Positioned(
                      bottom: 50,
                      child: Image.asset(img, width: 134),
                    ),
                    Text('mangue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Ageoextrabold',
                            fontSize: 80,
                            color: logoColor)),
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
                      borderRadius: BorderRadius.all(Radius.circular(10))),
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
                      color: textColor),
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
                    isready = false;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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
                          color: logoColor),
                    ),
                  )),
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
        ));
  }

  List<Widget> fill(List<BluetoothDevice> list) {
    List<Widget> result = [];
    for (BluetoothDevice s in list) {
      result.add(option(s, Icon(Icons.bluetooth, color: logoColor)));
    }
    return result;
  }

  Future connectToDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: false);
    isconn = true;
  }

  Future discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) {
        listStream = characteristic.value.asBroadcastStream();
        characteristic.setNotifyValue(!characteristic.isNotifying);
        isready = true;
      });
    });
  }

  void showDia(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            color: Colors.transparent,
            child: Container(
              width: 340,
              height: 150,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Selecione o próximo teste',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Ageo', fontSize: 16, color: textColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Container(
                      width: 180,
                      height: 40,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration.collapsed(
                            hintText: '', hoverColor: Colors.black),
                        items: <String>['AV', 'SquidPad', 'AR', 'Freio']
                            .map((String value) {
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
                                    color: Colors.black),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String select) {
                          graphname = select;
                        },
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Container(
                      height: 30,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                        child: Text('Ok!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Ageoextrabold',
                                fontSize: 18,
                                color: textColor)),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: textColor, width: 1)),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: backgroundDown,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        );
      },
    );
  }

  Widget optwid(String nameopt) {
    return Positioned(
      bottom: 20,
      left: 60,
      child: Text(
        nameopt,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'HP', fontSize: 15, color: textColor),
      ),
    );
  }

  Widget option(BluetoothDevice device, Widget icon) {
    String nameopt;
    if (device.name == '') {
      nameopt = 'Dispositivo sem nome';
    } else {
      nameopt = device.name;
    }
    Widget optwidg;
    optwidg = optwid(nameopt);

    return GestureDetector(
      onTap: () {
        devv = device;
        connectToDevice(device).then((_) {
          discoverServices(device).then((_) {
            showDia(context);
          });
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(
              height: 60,
            ),
            optwidg,
            Container(height: 2, width: 330, color: textColor),
            Positioned(bottom: 18, left: 33, child: icon),
          ],
        ),
      ),
    );
  }
}
