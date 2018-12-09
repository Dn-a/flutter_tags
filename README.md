# flutter_tags

[![pub package](https://img.shields.io/badge/pub-0.1.0-orange.svg)](https://pub.dartlang.org/packages/flutter_tags)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

Flutter tags let you create a list of selectable tags or tag dynamically with input.


## Install
Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter_tags: "^0.1.1"
```


## DEMO
![Demo 1](https://github.com/Dn-a/flutter_tags/blob/master/example/example.gif)


## Selectable Tags

The Tag class has some optional parameters. If you want to insert an icon, the title is not displayed but you can always use it.
```
Tag(
    id: 1,// optional
    icon: Icon.home, // optional
    title: First Tag, // required
    active: true, // optional
)
```

### Simple usage (Selectable Tags)
```
import 'package:flutter_tags/flutter_selectable_tags.dart';

// List of tag class 
List<Tag> _tags=[
    Tag(
        id: 1,
        icon: Icon.home,
        title: 'home', 
        active: true,
    ),
    Tag(
        id: 2,
        title: 'Some tag', 
        active: false,
    ),
];

//Widget
SelectableTags(
    tags: _tags,
    columns: 3, // default 4
    simmetry: true, // default false
    onPressed: (tag){
        print(tag);
    },
)
```
### All parameters (Selectable Tags)
* tags - *List<Tag>*
* columns - *max columns (default 4)*
* height - *custom height of Tag (default auto-resize)*
* borderRadius - *custom border radius*
* symmetry - *bool*
* margin - *margin between the tags*
* fontSize - *default 14*
* maxLines - *default 1*
* textOverflow - *ellipsis, clip...(default fade)*
* textColor - *default black*
* textActiveColor - *default white*
* color - *background color of tag (default white)*
* activeColor - *background color of active tag (default green)*
* backgroundContainer - *default white* 
* onPressed - *method*


## Input Tags
```
Work in Progress...
```


## Issues
If you encounter problems, open an issue. Pull request are also welcome.

