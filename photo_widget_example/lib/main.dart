import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetPathEntity> galleryList = [];
  AssetPathEntity currentPick;

  final provider = PickerDataProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple example"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: _refreshGalleryList,
            child: Text('refresh gallery list'),
          ),
          if (galleryList.isNotEmpty) _buildDropdownButton(),
          if (currentPick != null) Expanded(child: _buildPath()),
        ],
      ),
    );
  }

  void _refreshGalleryList() async {
    final pathList = await PhotoManager.getAssetPathList();
    galleryList.clear();
    galleryList.addAll(pathList);
    setState(() {});
  }

  Widget _buildDropdownButton() {
    return DropdownButton<AssetPathEntity>(
      items: [for (final path in galleryList) _buildPathItem(path)],
      onChanged: (value) {
        currentPick = value;
        setState(() {});
      },
      value: currentPick,
    );
  }

  DropdownMenuItem<AssetPathEntity> _buildPathItem(AssetPathEntity path) {
    return DropdownMenuItem<AssetPathEntity>(
      child: Text(path.name),
      value: path,
    );
  }

  Widget _buildPath() {
    return AssetPathWidget(
      path: currentPick,
      buildItem: (context, asset, size) {
        return PickAssetWidget(asset: asset, provider: provider);
      },
    );
  }
}
