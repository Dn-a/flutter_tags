# Example Flutter Tags

An example of how you could implement it.

## Getting Started - Selectable Tags
```
import 'package:flutter/material.dart';

import 'package:flutter_tags/input_tags.dart';
import 'package:flutter_tags/selectable_tags.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget
{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'flutter_tags - Test'),
    );
  }
}


class MyHomePage extends StatefulWidget
{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin
{
  TabController _tabController;
  ScrollController _scrollViewController;

  final List<String> _list = [
    '0','SDk','plugin updates','Facebook',
    'First','Italy','France','Spain','Dart','Foo','Select','lorem ip',
    'Star','Flutter Selectable Tags','1','Hubble','2','Input flutter tags','A B C','Android Studio developer','welcome to the jungle','very large text',
  ];

  bool _simmetry = false;
  int _column = 4;
  double _fontSize = 14;

  String _selectableOnPressed = '';
  String _inputOnPressed = '';

  List<Tag> _selectableTags = [];
  List<String> _inputTags = [];

  List _icon=[
    Icons.home,
    Icons.language,
    Icons.headset
  ];

  @override
  void initState()
  {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollViewController = ScrollController();

    _list.forEach((item) =>
        _selectableTags.add(
            Tag(title: item, active: true,icon: (item=='0' || item=='1' || item=='2')? _icon[ int.parse(item) ]:null )
        )
    );

    _inputTags.addAll(
        [
            'First Tag',
            'Android World',
            'substring',
            'Last tag',
            'enable'
        ]
    );

  }


  @override
  Widget build(BuildContext context)
  {
        return Scaffold(
          body: NestedScrollView(
              controller: _scrollViewController,
              headerSliverBuilder: (BuildContext context,bool boxIsScrolled){
                return <Widget>[
                  SliverAppBar(
                    title: Text("flutter_tags - Test"),
                    centerTitle: true,
                    pinned: true,
                    expandedHeight: 110.0,
                    floating: true,
                    forceElevated: boxIsScrolled,
                    bottom: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: TextStyle(fontSize: 18.0),
                      tabs: [
                        Tab(text: "Selectable"),
                        Tab(text: "Input"),
                      ],
                      controller: _tabController,
                    ),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children:  [
                  ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: _simmetry,
                                        onChanged: (a){
                                          setState(() {
                                            _simmetry = !_simmetry;
                                          });
                                        }
                                    ),
                                    Text('Simmetry')
                                  ],
                                ),
                                onTap: (){
                                  setState(() {
                                    _simmetry = !_simmetry;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                              ),
                              DropdownButton(
                                hint: Text(_column.toString()),
                                items: _buildItems(),
                                onChanged: (a) {
                                  setState(() {
                                    _column = a;
                                  });
                                },
                              ),
                              Text("Columns")
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Font Size'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Slider(
                                    value: _fontSize,
                                    min: 6,
                                    max: 30,
                                    onChanged: (a){
                                      setState(() {
                                        _fontSize = (a.round()).toDouble();
                                      });
                                    },
                                  ),
                                  Text(_fontSize.toString()),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Container(
                            child: SelectableTags(
                              tags: _selectableTags,
                              columns: _column,
                              fontSize: _fontSize,
                              symmetry: _simmetry,
                              onPressed: (tag){
                                setState(() {
                                  _selectableOnPressed = tag.toString();
                                });
                              },
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Divider(color: Colors.blueGrey,)
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child: Text("OnPressed",style: TextStyle(fontSize: 18),)),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              alignment: Alignment.topLeft,
                              child: Text(_selectableOnPressed)
                          )
                        ],
                      ),
                    ],
                  ),
                  ListView(
                      children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  GestureDetector(
                                      child: Row(
                                          children: <Widget>[
                                              Checkbox(
                                                  value: _simmetry,
                                                  onChanged: (a){
                                                      setState(() {
                                                          _simmetry = !_simmetry;
                                                      });
                                                  }
                                              ),
                                              Text('Simmetry')
                                          ],
                                      ),
                                      onTap: (){
                                          setState(() {
                                              _simmetry = !_simmetry;
                                          });
                                      },
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(20),
                                  ),
                                  DropdownButton(
                                      hint: Text(_column.toString()),
                                      items: _buildItems(),
                                      onChanged: (a) {
                                          setState(() {
                                              _column = a;
                                          });
                                      },
                                  ),
                                  Text("Columns")
                              ],
                          ),
                          Column(
                              children: <Widget>[
                                  Text('Font Size'),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                          Slider(
                                              value: _fontSize,
                                              min: 6,
                                              max: 30,
                                              onChanged: (a){
                                                  setState(() {
                                                      _fontSize = (a.round()).toDouble();
                                                  });
                                              },
                                          ),
                                          Text(_fontSize.toString()),
                                      ],
                                  ),
                              ],
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: InputTags(
                                  tags: _inputTags,
                                  columns: _column,
                                  fontSize: _fontSize,
                                  symmetry: _simmetry,
                                  onDelete: (tag){
                                      print(tag);
                                  },
                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                  child: Text('Print all Tag'),
                                  onPressed: (){
                                      _inputOnPressed ='';
                                      _inputTags.forEach((tag) =>
                                          setState(() {
                                              _inputOnPressed+='${tag},\n';
                                          })
                                      );
                                  }
                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(_inputOnPressed),
                          ),
                      ],
                  )
                ],
              )
          ),
        );
  }


  List<DropdownMenuItem> _buildItems()
  {
    List<DropdownMenuItem> list = [];

    int count = 15;

    for(int i = 1; i < count; i++)
      list.add(
        DropdownMenuItem(
          child: Text(i.toString() ),
          value: i,
        ),
      );

    return list;
  }
}

```

## DEMO
![Demo 1](https://github.com/Dn-a/flutter_tags/blob/master/example/example.gif)
![Demo 2](https://github.com/Dn-a/flutter_tags/blob/master/example/example2.gif)

## Other
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
