import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_tags/tag.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Tags'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollViewController;

  final List<String> _list = [
    '0',
    'SDK',
    'SDK',
    'plugin updates',
    'Facebook',
    '哔了狗了QP又不够了',
    'Kirchhoff',
    'Italy',
    'France',
    'Spain',
    '美',
    'Dart',
    'Foo',
    'Select',
    'lorem ip',
    '9',
    'Star',
    'Flutter Selectable Tags',
    '1',
    'Hubble',
    '2',
    'Input flutter tags',
    'A B C',
    '8',
    'Android Studio developer',
    'welcome to the jungle',
    'Gauss',
    '美术',
    '互联网',
    '炫舞时代',
    '篝火营地',
  ];

  bool _symmetry = false;
  bool _singleItem = false;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 0;
  double _fontSize = 14;

  String _onPressed = '';

  List _icon = [Icons.home, Icons.language, Icons.headset];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _scrollViewController = ScrollController();

    _items = _list.toList();
  }

  List _items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text("flutter tags"),
                centerTitle: true,
                pinned: true,
                expandedHeight: 0,
                floating: true,
                forceElevated: boxIsScrolled,
                bottom: TabBar(
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(fontSize: 18.0),
                  tabs: [
                    Tab(text: "Demo 1"),
                    //Tab(text: "Demo 2"),
                  ],
                  controller: _tabController,
                ),
              )
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey[300], width: 0.5))),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: ExpansionTile(
                        title: Text("Settings"),
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: _withSuggesttions,
                                        onChanged: (a) {
                                          setState(() {
                                            _withSuggesttions =
                                                !_withSuggesttions;
                                          });
                                        }),
                                    Text('Suggestions')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _withSuggesttions = !_withSuggesttions;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: _symmetry,
                                        onChanged: (a) {
                                          setState(() {
                                            _symmetry = !_symmetry;
                                          });
                                        }),
                                    Text('Symmetry')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _symmetry = !_symmetry;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                              ),
                              DropdownButton(
                                hint: _column == 0
                                    ? Text("Not set")
                                    : Text(_column.toString()),
                                items: _buildItems(),
                                onChanged: (a) {
                                  setState(() {
                                    _column = a;
                                  });
                                },
                              ),
                              Text("Columns"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: _horizontalScroll,
                                        onChanged: (a) {
                                          setState(() {
                                            _horizontalScroll =
                                                !_horizontalScroll;
                                          });
                                        }),
                                    Text('Horizontal scroll')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _horizontalScroll = !_horizontalScroll;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: _singleItem,
                                        onChanged: (a) {
                                          setState(() {
                                            _singleItem = !_singleItem;
                                          });
                                        }),
                                    Text('Single Item')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _singleItem = !_singleItem;
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
                                    onChanged: (a) {
                                      setState(() {
                                        _fontSize = (a.round()).toDouble();
                                      });
                                    },
                                  ),
                                  Text(_fontSize.toString()),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    //color: Colors.blueGrey,
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      //color: Colors.white,
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _count++;
                                          _items.add(_count.toString());
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    //color: Colors.grey,
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      //color: Colors.white,
                                      icon: Icon(Icons.refresh),
                                      onPressed: () {
                                        setState(() {
                                          _items = _list.toList();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                    ),
                    _tags,
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Divider(
                              color: Colors.blueGrey,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(_onPressed),
                            ),
                          ],
                        )),
                  ])),
                ],
              ),
              ListView(
                children: <Widget>[
                  //Text("aa")
                ],
              )
            ],
          )),
    );
  }

  Widget get _tags {
    return Tags(
      symmetry: _symmetry,
      columns: _column,
      //spacing: 36,
      //runSpacing: 20,
      //alignment: WrapAlignment.start,
      horizontalScroll: _horizontalScroll,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      textField: 1 == 0
          ? null
          : TagsTextFiled(
              //duplicates: true,
              autofocus: false,
              //position: TagsTextFiledPosition.start,
              textStyle: TextStyle(fontSize: _fontSize),
              suggestions: _withSuggesttions
                  ? [
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
                    ]
                  : null,
              onSubmitted: (String str) {
                setState(() {
                  _items.add(str);
                });
              },
            ),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          //pressEnabled: false,
          activeColor: Colors.blueGrey[600],
          singleItem: _singleItem,
          combine: ItemTagsCombine.withTextBefore,
          //alignment: MainAxisAlignment.start,
          //padding: EdgeInsets.all(10),
          splashColor: Colors.green,
          image: index > 0 && index < 5
              ? ItemTagsImage(image: AssetImage("img/p$index.jpg"))
              : (1 == 0
                  ? ItemTagsImage(
                      image: NetworkImage(
                          "https://image.flaticon.com/icons/png/512/44/44948.png"))
                  : null),
          icon: (item == '0' || item == '1' || item == '2')
              ? ItemTagsIcon(
                  icon: _icon[int.parse(item)],
                )
              : null,
          removeButton: 1 == 1
              ? ItemTagsRemoveButton(
                  //size: 5
                  //backgroundColor: Colors.green,
                  //borderRadius: BorderRadius.circular(5)
                  )
              : null,
          textScaleFactor:
              utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          onRemoved: () {
            print("remove");
            setState(() {
              _items.removeAt(index);
            });
          },
          //onPressed: (item) => print(item),
          //onLongPressed: (item) => print(item),
        );
      },
    );
  }

  List<DropdownMenuItem> _buildItems() {
    List<DropdownMenuItem> list = [];

    int count = 19;

    list.add(
      DropdownMenuItem(
        child: Text("Not set"),
        value: 0,
      ),
    );

    for (int i = 1; i < count; i++)
      list.add(
        DropdownMenuItem(
          child: Text(i.toString()),
          value: i,
        ),
      );

    return list;
  }
}
