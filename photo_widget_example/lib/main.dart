import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
          _buildDropdownButton(),
          AnimatedBuilder(
            animation: provider.currentPathNotifier,
            builder: (_, __) => Expanded(child: _buildPath()),
          ),
        ],
      ),
    );
  }

  void _refreshGalleryList() async {
    final pathList = await PhotoManager.getAssetPathList();
    provider.resetPathList(pathList, sortBy: (a, b) {
      if (a.isAll) {
        return -1;
      }
      if (b.isAll) {
        return 1;
      }
      return 0;
    });
  }

  Widget _buildDropdownButton() {
    return SelectedPathDropdownButton(
      provider: provider,
    );
  }

  Widget _buildPath() {
    if (provider.currentPath == null) {
      return Container();
    }
    return AssetPathWidget(
      path: provider.currentPath,
      buildItem: (context, asset, size) {
        return PickAssetWidget(
          asset: asset,
          provider: provider,
          thumbSize: size,
        );
        // return AssetWidget(asset: asset);
      },
    );
  }
}
