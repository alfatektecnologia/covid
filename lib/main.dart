import 'dart:convert';
import 'dart:io';

import 'package:covid19/utilitario/util.dart';
import 'package:covid19/widgets/background_widget.dart';
import 'package:covid19/widgets/carregando.dart';
import 'package:covid19/widgets/show_cards.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
//import 'package:flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Corona vírus - report',
      theme: ThemeData.dark(),
      home: MyHomePage(
        title: 'Coronavírus',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'http://coronavirusdata.herokuapp.com/';
  http.Response response;
  var decodeJson;
  static String _newValue;
  bool showMessageCarregando = false;
  var listener;

  Map<String, dynamic> countries;
  List<String> listaPaises = List();

  @override
  void initState() {
    super.initState();
    hasInternet();
    getCountry();
  }

  getCountry() async {
    showMessageCarregando = true;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.statusCode);
        decodeJson = jsonDecode(response.body);
        countries = decodeJson['paises'];
        setState(() {
          countries.keys.forEach((value) {
            listaPaises.add(value);
          });
          showMessageCarregando = false;
        });
      }
    } catch (e) {
      mostrarAlerta('Erro no acesso aos dados!', context);
    }
  }

  getCountryCases(String pais) async {
    Util.carregando = true;
    print(Util.carregando);
    response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      decodeJson = jsonDecode(response.body);
      countries = decodeJson['paises'][pais];
      setState(() {
        Util.totalCasos = double.parse(countries['totalCasos'].toString());
        Util.novasMortes = double.parse(countries['novasMortes'].toString());
        Util.totalMortes = double.parse(countries['totalMortes'].toString());
        Util.novosCasos = double.parse(countries['novosCasos'].toString());
        Util.casosGraves = double.parse(countries['casosGraves'].toString());
        Util.casosAtivos = double.parse(countries['casosAtivos'].toString());
        Util.totalCurados = double.parse(countries['totalCurados'].toString());
        showMessageCarregando = false;
        Util.carregando = false;

        print(Util.carregando);
      });
    }
    print(Util.totalCasos.toString() + ' total de casos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Image.asset(
                'assets/images/exit.png',
                width: 50,
              ),
              onPressed: () => exit(0))
        ],
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: BackgroundWidget(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'País: ',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          //SizedBox(width: 20),
                          DropdownButton<String>(
                              items: listaPaises.map((value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.cyan)));
                              }).toList(),
                              hint: Text('Selecione o país...',style:TextStyle(
                                 color:showMessageCarregando
                                ?Colors.red
                                :Colors.green,
                              )),
                              value: _newValue,
                              onChanged: (selected) {
                                setState(() {
                                  _newValue = selected;
                                  showMessageCarregando = true;
                                  getCountryCases(_newValue);
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                  (!Util.carregando && !showMessageCarregando)
                      ? ShowCards()
                      : Center(
                          child: Container(
                            child: showMessageCarregando
                                ? Carregando()/* Text('Carregando os dados...',
                                    style: TextStyle(fontSize: 30)) */
                                : Container(),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//check if has a valid internet connection
  Future hasInternet() async {
    // Simple check to see if we have internet
    print("The statement 'this machine is connected to the Internet' is: ");
    print(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    print("Current status: ${await DataConnectionChecker().connectionStatus}");
    // prints either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    print("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Data connection is available.');
          break;
        case DataConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          mostrarAlerta('Verifique sua conexão com a internet!', context);

          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  mostrarAlerta(String message, context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                'Alerta',
                style: TextStyle(color: Colors.black, fontSize: 40),
              ),
              content: Text(
                message,
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: FlatButton(
                    onPressed: () {
                      // Navigator.of(context).pop();
                      exit(0);
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
              elevation: 16,
              backgroundColor: Colors.white,
              //shape: CircleBorder(),
            ));
  }
}
