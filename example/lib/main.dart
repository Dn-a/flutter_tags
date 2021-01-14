import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tags/flutter_tags.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tags Demo',
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
    'plugin updates',
    'Facebook',
    '哔了狗了QP又不够了',
    'Kirchhoff',
    'Italy',
    'France',
    'Spain',
    '美',
    'Dart',
    'SDK',
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
  bool _removeButton = true;
  bool _singleItem = true;
  bool _startDirection = false;
  bool _horizontalScroll = true;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 0;
  double _fontSize = 14;

  String _itemCombine = 'withTextBefore';

  String _onPressed = '';

  List _icon = [Icons.home, Icons.language, Icons.headset];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollViewController = ScrollController();

    _items = _list.toList();
  }

  List _items;

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    //List<Item> lst = _tagStateKey.currentState?.getAllItem; lst.forEach((f) => print(f.title));
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
                    Tab(text: "Demo 2"),
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
                                        value: _removeButton,
                                        onChanged: (a) {
                                          setState(() {
                                            _removeButton = !_removeButton;
                                          });
                                        }),
                                    Text('Remove Button')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _removeButton = !_removeButton;
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
                                          //_items.removeAt(3); _items.removeAt(10);
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
                    _tags1,
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
                                padding: EdgeInsets.all(20),
                              ),
                              DropdownButton(
                                hint: Text(_itemCombine),
                                items: _buildItems2(),
                                onChanged: (val) {
                                  setState(() {
                                    _itemCombine = val;
                                  });
                                },
                              ),
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
                                        value: _startDirection,
                                        onChanged: (a) {
                                          setState(() {
                                            _startDirection = !_startDirection;
                                          });
                                        }),
                                    Text('Start Direction')
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _startDirection = !_startDirection;
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
                    _tags2,
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
            ],
          )),
    );
  }

  Widget get _tags1 {
    return Tags(
      key: _tagStateKey,
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: _horizontalScroll,
      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: true,
          activeColor: Colors.blueGrey[600],
          singleItem: _singleItem,
          splashColor: Colors.green,
          combine: ItemTagsCombine.withTextBefore,
          image: index > 0 && index < 5
              ? ItemTagsImage(
                  //image: AssetImage("img/p$index.jpg"),
                  child: Image.network(
                  "http://www.clipartpanda.com/clipart_images/user-66327738/download",
                  width: 16 * _fontSize / 14,
                  height: 16 * _fontSize / 14,
                ))
              : (1 == 1
                  ? ItemTagsImage(
                      image: NetworkImage(
                          "https://d32ogoqmya1dw8.cloudfront.net/images/serc/empty_user_icon_256.v2.png"),
                    )
                  : null),
          icon: (item == '0' || item == '1' || item == '2')
              ? ItemTagsIcon(
                  icon: _icon[int.parse(item)],
                )
              : null,
          removeButton: _removeButton
              ? ItemTagsRemoveButton(
                  onRemoved: () {
                    setState(() {
                      _items.removeAt(index);
                    });
                    return true;
                  },
                )
              : null,
          textScaleFactor:
              utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          onPressed: (item) => print(item),
        );
      },
    );
  }

  // Position for popup menu
  Offset _tapPosition;

  Widget get _tags2 {
    //popup Menu
    final RenderBox overlay = Overlay.of(context).context?.findRenderObject();

    ItemTagsCombine combine = ItemTagsCombine.onlyText;

    switch (_itemCombine) {
      case 'onlyText':
        combine = ItemTagsCombine.onlyText;
        break;
      case 'onlyIcon':
        combine = ItemTagsCombine.onlyIcon;
        break;
      case 'onlyIcon':
        combine = ItemTagsCombine.onlyIcon;
        break;
      case 'onlyImage':
        combine = ItemTagsCombine.onlyImage;
        break;
      case 'imageOrIconOrText':
        combine = ItemTagsCombine.imageOrIconOrText;
        break;
      case 'withTextAfter':
        combine = ItemTagsCombine.withTextAfter;
        break;
      case 'withTextBefore':
        combine = ItemTagsCombine.withTextBefore;
        break;
    }

    return Tags(
      key: Key("2"),
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: _horizontalScroll,
      verticalDirection:
          _startDirection ? VerticalDirection.up : VerticalDirection.down,
      textDirection: _startDirection ? TextDirection.rtl : TextDirection.ltr,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      textField: _textField,
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return GestureDetector(
          child: ItemTags(
            key: Key(index.toString()),
            index: index,
            title: item,
            pressEnabled: false,
            activeColor: Colors.green[400],
            combine: combine,
            image: index > 0 && index < 5
                ? ItemTagsImage(image: AssetImage("img/p$index.jpg"))
                : (1 == 1
                    ? ItemTagsImage(
                        image: NetworkImage(
                            "https://image.flaticon.com/icons/png/512/44/44948.png"))
                    : null),
            icon: (item == '0' || item == '1' || item == '2')
                ? ItemTagsIcon(
                    icon: _icon[int.parse(item)],
                  )
                : null,
            removeButton: ItemTagsRemoveButton(
              backgroundColor: Colors.green[900],
              onRemoved: () {
                setState(() {
                  _items.removeAt(index);
                });
                return true;
              },
            ),
            textScaleFactor:
                utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
            textStyle: TextStyle(
              fontSize: _fontSize,
            ),
          ),
          onTapDown: (details) => _tapPosition = details.globalPosition,
          onLongPress: () {
            showMenu(
                    //semanticLabel: item,
                    items: <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text(item, style: TextStyle(color: Colors.blueGrey)),
                    enabled: false,
                  ),
                  PopupMenuDivider(),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.content_copy),
                        Text("Copy text"),
                      ],
                    ),
                  ),
                ],
                    context: context,
                    position: RelativeRect.fromRect(
                        _tapPosition & Size(40, 40),
                        Offset.zero &
                            overlay
                                .size) // & RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
                    )
                .then((value) {
              if (value == 1) Clipboard.setData(ClipboardData(text: item));
            });
          },
        );
      },
    );
  }

  TagsTextField get _textField {
    return TagsTextField(
      autofocus: false,
      //width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      textStyle: TextStyle(
        fontSize: _fontSize,
        //height: 1
      ),
      enabled: true,
      constraintSuggestion: true,
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
              "互联网",
              "last",
              "lest",
              "炫舞时代"
            ]
          : null,
      onSubmitted: (String str) {
        setState(() {
          _items.add(str);
        });
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

  List<DropdownMenuItem> _buildItems2() {
    List<DropdownMenuItem> list = [];

    list.add(DropdownMenuItem(
      child: Text("onlyText"),
      value: 'onlyText',
    ));

    list.add(DropdownMenuItem(
      child: Text("onlyIcon"),
      value: 'onlyIcon',
    ));
    list.add(DropdownMenuItem(
      child: Text("onlyImage"),
      value: 'onlyImage',
    ));
    list.add(DropdownMenuItem(
      child: Text("imageOrIconOrText"),
      value: 'imageOrIconOrText',
    ));
    list.add(DropdownMenuItem(
      child: Text("withTextBefore"),
      value: 'withTextBefore',
    ));
    list.add(DropdownMenuItem(
      child: Text("withTextAfter"),
      value: 'withTextAfter',
    ));

    return list;
  }
}
