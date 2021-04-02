import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Devices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bluetooth Devices'),
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
  bool _isLoading = false;

  void _scanDevices() async {
    setState(() {
      _isLoading = true;
    });
    List<ScanResult> devices =
        await FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<ScanResult>>(
          stream: FlutterBlue.instance.scanResults,
          initialData: [],
          builder: (c, snapshot) {
            if (!snapshot.hasData) {
              return Text('Loading.....');
            }
            return Column(
              children: snapshot.data
                  .map(
                    (r) => ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailWidget(
                                  id: r.device.id.toString(),
                                  name: r.device.name)),
                        );
                      },
                      title: Text(r.device.id.toString()),
                      leading: Icon(Icons.devices),
                    ),
                  )
                  .toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: !_isLoading ? _scanDevices : null,
        tooltip: 'Increment',
        child: Icon(Icons.scanner),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DetailWidget extends StatelessWidget {
  final String id;
  final String name;

  const DetailWidget({Key key, @required this.id, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Widget'),
      ),
      body: ListTile(
        title: Text(this.id),
        subtitle: Text(this.name),
        trailing: Icon(Icons.bluetooth),
      ),
    );
  }
}
