# flutter_tags
[![pub package](https://img.shields.io/badge/pub-0.3.1-orange.svg)](https://pub.dartlang.org/packages/flutter_tags)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

Flutter tags simplifies the dynamic creation of selectable tags or input with textField. You will never have to worry about the screen width.

## Installing
Add this to your package's pubspec.yaml file:
```dart
dependencies:
  flutter_tags: "^0.3.1"
```


## DEMO

<div align="center">
<table>
<tr>
<td style="text-align:center">
 <img width = "250px" src="https://github.com/Dn-a/flutter_tags/blob/master/example/example0.3.0_1.gif?raw=true" />
 </td>
<td style="text-align:center">
  <img width = "250px" src="https://github.com/Dn-a/flutter_tags/blob/master/example/example0.3.0_2.gif?raw=true"/>
 </td>
</tr>
</table>
</div>


## Selectable Tags

The Tag class has some optional parameters. If you want to insert an icon, the title is not displayed but you can always use it.
```dart
Tag(
    id: 1,// optional
    icon: Icon.home, // optional
    title: 'First Tag', // required
    active: true, // optional
    color: Colors.white, // optional
    activeColor: Colors.blue // optional
    customData: 'DocumentId' // optional
)
```

### Simple usage
```dart
import 'package:flutter_tags/selectable_tags.dart';
.
.
.

List<Tag> _tags=[];

@override
void initState()
{
    super.initState();
    
    // if you store data on a local database (sqflite), then you could do something like this
    Model().getItems().then((items){
        items.forEach((item) =>
            _tags.add(
                Tag(
                    id: item.id,
                    title: item.title, 
                    active: bool.fromEnvironment(item.active) == "true",
                )
            )
        );  
    });
    
}


//Widget
SelectableTags(
    tags: _tags,
    columns: 3, // default 4
    symmetry: true, // default false
    popupMenuBuilder: _popupMenuBuilder,
    popupMenuOnSelected: (int id,Tag tag){
      switch(id){
          case 1:
              Clipboard.setData( ClipboardData(text: tag.title));
              break;
          case 2:
              setState(() {
                  _tags.remove(tag);
              });
      }
    },
    onPressed: (tag) => print(tag),
)

List<PopupMenuEntry> _popupMenuBuilder (Tag tag)
{
    return <PopupMenuEntry>[
      PopupMenuItem(
          child: Text(tag.title, style: TextStyle( color: Colors.blueGrey ) ),
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
    ];
}

void _getActiveTags()
{
    _tags.where((tag) => tag.active).forEach((tag) => print(tag.title));
}

void _getDisableTags()
{
    _tags.where((tag) => !tag.active).forEach((tag) => print(tag.title));
}
```

### All parameters (SelectableTags)
* tags - *List 'Tag'*
* columns - *max columns (default 4)*
* height - *custom height of Tag (default auto-resize)*
* borderRadius - *custom border radius (default BorderRadius.circular(_initBorderRadius))*
* borderSide - *style border Side*
* boxShadow - *List<BoxShadow> of tag*
* symmetry - *bool*
* singleItem - *default false - same Radiobutton group HTML*
* margin - *margin between the tags (default 3)*
* margin - *padding of the tags (default 8)*
* alignment - *default  MainAxisAlignment.center*
* offset - *Different characters may have different widths(e.g.: chinese character); (default 28)*
* fontSize - *default 14*
* textStyle - *if use textStyle, you need to set fontSize in it (the external fontSize will be ignored); if you set color in it will be ignored, you must use textColor/textActiveColor*
* textOverflow - *ellipsis, clip...(default fade)*
* textColor - *default black*
* textActiveColor - *default white*
* color - *background color of tag (default white)*
* activeColor - *background color of active tag (default green)*
* backgroundContainer - *default white* 
* popupMenuBuilder - *Popup Menu Items*
* popupMenuOnSelected - *On Selected Item*
* onPressed - *Callback*


# Input Tags

### Note (Flutter version < 1)
In the console you will receive some errors.
InputTags not work properly because textField has some bugs.
![Bug 1](https://github.com/flutter/flutter/issues/20893)


### Simple usage
```dart
import 'package:flutter_tags/input_tags.dart';
.
.
.

List<String> _tags=[];

@override
void initState()
{
    super.initState();
    _tags.addAll(
         [
             'first tag',
             'android world',
             'substring',
             'last tag',
             'enable'
         ]
    );
    
}


//Widget
InputTags(
    tags: _tags,
    suggestionsList: 
    [
        "One",
        "two",
        "android",
        "Dart",
        "flutter",
        "test",
        "tests",
        "androids",
        "Test",
        "suggest",
        "suggestions",
        "last",
        "lest"
    ],
    popupMenuBuilder: _popupMenuBuilder,
    popupMenuOnSelected: (int id,String tag){
      switch(id){
          case 1:
              Clipboard.setData( ClipboardData(text: tag));
              break;
          case 2:
              setState(() {
                  _tags.remove(tag);
              });
      }
    },
    onDelete: (tag) => print(tag),
    onInsert: (tag) => print(tag),
)

List<PopupMenuEntry> _popupMenuBuilder ( String tag)
{
    return <PopupMenuEntry>[
      PopupMenuItem(
          child: Text(tag, style: TextStyle( color: Colors.blueGrey ) ),
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
    ];
}

void _getTags()
{
    _tags.forEach((tag) => print(tag));
}
```

### All parameters (InputTags)
* tags - *List 'String'*
* columns - *max columns (default 4)*
* autofocus - *default true*
* inputDecoration - *textInput style*
* maxLength - *max length of textField (int)*
* keyboardType - *TextInputType*
* height - *custom height of Tag (default auto-resize)*
* borderRadius - *custom border radius (default BorderRadius.circular(_initBorderRadius))*
* boxShadow - *List<BoxShadow> of tag*
* symmetry - *default false*
* textFieldHidden - *default false*
* margin - *margin between the tags (default 3)*
* padding - *padding of the tags (default left: 10)*
* alignment - *default  MainAxisAlignment.center*
* offset - *default  3*
* duplicate - *allows you to insert duplicates (default false)*
* fontSize - *default 14*
* textColor - *Removed. now it can be set with textStyle*
* lowerCase - *default false*
* textStyle - *if use textStyle, you need to set fontSize in it (the external fontSize will be ignored)*
* textOverflow - *ellipsis, clip...(default fade)*
* iconSize - *default auto-resize*
* iconPadding - *padding of Icon close (default 3)*
* iconMargin - *margin of Icon close (default right: 8)*
* iconColor - *default White*
* iconBackground - *default transparent*
* color - *background color of tag (default green)*
* backgroundContainer - *default white*
* highlightColor - *default green'700'*
* popupMenuBuilder - *Popup Menu Items*
* popupMenuOnSelected - *On Selected Item*
* onDelete - *return the tag deleted*
* onInsert - *return the tag entered*
* suggestionsList - *a List of string that force the insertion of specific items*

## Donate
If you found this project helpful or you learned something from the source code and want to thank me: 
- [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

## Issues
If you encounter problems, open an issue. Pull request are also welcome.

