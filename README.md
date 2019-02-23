# flutter_tags

[![pub package](https://img.shields.io/badge/pub-0.1.9-orange.svg)](https://pub.dartlang.org/packages/flutter_tags)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)


Flutter tags let you create a list of tags or insert them dynamically with the input.

## Installing
Add this to your package's pubspec.yaml file:
```dart
dependencies:
  flutter_tags: "^0.1.9"
```


### DEMO
![Example](https://github.com/Dn-a/flutter_tags/tree/master/example)

![Demo 1](https://github.com/Dn-a/flutter_tags/blob/master/example/example1.2.gif)
![Demo 2](https://github.com/Dn-a/flutter_tags/blob/master/example/example2.2.gif)


# Selectable Tags

The Tag class has some optional parameters. If you want to insert an icon, the title is not displayed but you can always use it.
```dart
Tag(
    id: 1,// optional
    icon: Icon.home, // optional
    title: 'First Tag', // required
    active: true, // optional
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
    onPressed: (tag){
        print(tag);
    },
)

void _getActiveTags()
{
    _tags.where((tag) => tag.active).forEach((tag) => print(tag.title));
}

void _getDisableTags()
{
    _tags.where((tag) => !tag.active).forEach((tag) => print(tag.title));
}
```

### All parameters
* tags - *List 'Tag'*
* columns - *max columns (default 4)*
* height - *custom height of Tag (default auto-resize)*
* borderRadius - *custom border radius*
* borderSide - *style border Side*
* boxShadow - *List<BoxShadow> of tag*
* symmetry - *bool*
* singleItem - *default false - same Radiobutton group HTML*
* margin - *margin between the tags*
* alignment - *default  MainAxisAlignment.center*
* offset - *Different characters may have different widths(e.g.: chinese character); (default 28)*
* fontSize - *default 14*
* textOverflow - *ellipsis, clip...(default fade)*
* textColor - *default black*
* textActiveColor - *default white*
* color - *background color of tag (default white)*
* activeColor - *background color of active tag (default green)*
* backgroundContainer - *default white* 
* onPressed - *method*


# Input Tags

### Note
In the console you will receive some errors.
InputTags not work properly because textField has some bugs.
here is one 
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
    onDelete: (tag){
        print(tag);
    },
    onInsert: (tag){
        print(tag);
    },
)

void _getTags()
{
    _tags.forEach((tag) => print(tag));
}
```

### All parameters
* tags - *List 'String'*
* columns - *max columns (default 4)*
* autofocus - *default true*
* inputDecoration - *textInput style*
* maxLength - *max length of textField (int)*
* keyboardType - *TextInputType*
* height - *custom height of Tag (default auto-resize)*
* borderRadius - *custom border radius (default 3)*
* boxShadow - *List<BoxShadow> of tag*
* symmetry - *default false*
* margin - *margin between the tags*
* alignment - *default  MainAxisAlignment.center*
* offset - *default  3*
* duplicate - *allows you to insert duplicates (default false)*
* fontSize - *default 14*
* iconSize - *default auto-resize*
* iconColor - *default White*
* iconBackground - *default transparent*
* textOverflow - *ellipsis, clip...(default fade)*
* textColor - *default white*
* lowerCase - *default false*
* color - *background color of tag (default green)*
* backgroundContainer - *default white*
* highlightColor - *default green'700'* 
* onDelete - *return the tag deleted*
* onInsert - *return the tag entered*


## Issues
If you encounter problems, open an issue. Pull request are also welcome.

