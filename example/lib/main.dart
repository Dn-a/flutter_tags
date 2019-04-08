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
    '0','SDk','plugin updates','Facebook','哔了狗了QP又不够了',
    'Kirchhoff','Italy','France','Spain','美','Dart','Foo','Select','lorem ip','9',
    'Star','Flutter Selectable Tags','1','Hubble','2','Input flutter tags','A B C','8','Android Studio developer','welcome to the jungle','Gauss',
      '美术',
      '互联网',
      '炫舞时代',
      '篝火营地',
  ];

  bool _symmetry = false;
  bool _singleItem = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 8;
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

    int cnt = 0;
    _list.forEach((item)
    {
        _selectableTags.add (
            Tag (id: cnt,
                title: item,
                active: (_singleItem) ? ( cnt==3 ? true:false ) : true,
                icon: (item == '0' || item == '1' || item == '2') ?
                _icon[ int.parse (item
                ) ] : null
            )
        );
        cnt++;
    }
    );

    _inputTags.addAll(
        [
            'first tag',
            'android world',
            'pic',
            '美术',
            'substring',
            'last tag',
            '术',
            'enable',
            'act',
            '1',
            '上上下下左右左右',
            'first',
            'return',
            'lollipop',
            'loop',
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
                                        value: _symmetry,
                                        onChanged: (a){
                                          setState(() {
                                            _symmetry = !_symmetry;
                                          });
                                        }
                                    ),
                                    Text('Symmetry')
                                  ],
                                ),
                                onTap: (){
                                  setState(() {
                                    _symmetry = !_symmetry;
                                  });
                                },
                              ),
                              GestureDetector(
                                  child: Row(
                                      children: <Widget>[
                                          Checkbox(
                                              value: _singleItem,
                                              onChanged: (a){
                                                  setState(() {
                                                      _singleItem = !_singleItem;
                                                  });
                                              }
                                          ),
                                          Text('Single Item')
                                      ],
                                  ),
                                  onTap: (){
                                      setState(() {
                                          _singleItem = !_singleItem;
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
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  Container(
                                      height:   30,
                                      width: 30,
                                      color: Colors.blueGrey,
                                      child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          color: Colors.white,
                                          icon: Icon(Icons.add),
                                          onPressed: (){
                                              setState(() {
                                                  _count++;
                                                  _selectableTags.add(
                                                      Tag(
                                                          title:_count.toString(),
                                                          active: _count%2==0
                                                      )
                                                  );
                                              });
                                          },
                                      ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Container(
                            child:
                            SelectableTags(
                              tags: _selectableTags,
                              columns: _column,
                              fontSize: _fontSize,
                              symmetry: _symmetry,
                              singleItem: _singleItem,
                              //offset: 4, //
                              //activeColor: Colors.deepPurple,
                              //boxShadow: [],
                              //borderRadius:5,
                              //margin: EdgeInsets.symmetric(horizontal: 60, vertical: 6),
                              //padding: EdgeInsets.symmetric(horizontal: 19),
                              //borderRadius: BorderRadius.all(Radius.elliptical(20, 5)),
                              //height: 28,
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
                                                  value: _symmetry,
                                                  onChanged: (a){
                                                      setState(() {
                                                          _symmetry = !_symmetry;
                                                      });
                                                  }
                                              ),
                                              Text('Symmetry')
                                          ],
                                      ),
                                      onTap: (){
                                          setState(() {
                                              _symmetry = !_symmetry;
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  GestureDetector(
                                      child: Row(
                                          children: <Widget>[
                                              Checkbox(
                                                  value: _withSuggesttions,
                                                  onChanged: (a){
                                                      setState(() {
                                                          _withSuggesttions = !_withSuggesttions;
                                                      });
                                                  }
                                              ),
                                              Text('With suggestions')
                                          ],
                                      ),
                                      onTap: (){
                                          setState(() {
                                              _withSuggesttions = !_withSuggesttions;
                                          });
                                      },
                                  ),
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
                              child:
                              InputTags(
                                  tags: _inputTags,
                                  columns: _column,
                                  fontSize: _fontSize,
                                  symmetry: _symmetry,
                                  iconBackground: Colors.green[800],
                                  suggestionsList: !_withSuggesttions ? null :
                                  [
                                      "One",
                                      "two",
                                      "android",
                                      "Dart",
                                      "flutter",
                                      "test",
                                      "tests",
                                      "androids",
                                      "androidsaaa",
                                      "Test",
                                      "suggest",
                                      "suggestions",
                                      "last",
                                      "lest"
                                  ],
                                  //boxShadow: [],
                                  //offset: 5,
                                  //padding: EdgeInsets.only(left: 11),
                                  //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                  //iconPadding: EdgeInsets.all(5),
                                  //iconMargin: EdgeInsets.only(right:5,left: 2),
                                  //borderRadius: BorderRadius.all(Radius.elliptical(50, 5)),
                                  lowerCase: true,
                                  autofocus: false,
                                  //onDelete: (tag) => print(tag),
                                  //onInsert: (tag) => print(tag),

                              ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                  child: Text('Print all Tags'),
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

    int count = 19;

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
