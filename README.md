# flutter_tags
[![pub package](https://img.shields.io/badge/pub-0.4.0-orange.svg)](https://pub.dartlang.org/packages/flutter_tags)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

Create beautiful tags quickly and easily.

**Since version 4.0 the structure of the code has changed radically.**
**`SelectableTags` and` InputTags` have been replaced with the Tags () widget**.
**Now it is possible to personalize every single tag, with the possibility of adding icons, images and a removal button.**
 If you still prefer the previous version, go to ![0.3.2](https://github.com/Dn-a/flutter_tags/tree/0.3.2)

## Installing
Add this to your package's pubspec.yaml file:
```dart
dependencies:
  flutter_tags: "^0.4.0"
```


## DEMO

<div align="center">
<table>
<tr>
<td style="text-align:center">
 <img width = "250px" src="https://github.com/Dn-a/flutter_tags/blob/master/example/example0.4.0.gif?raw=true" />
 </td>
</tr>
</table>
</div>


## Simple usage
```dart

import 'package:flutter_tags/tag.dart';
.
.
.
@override
void initState(){
    super.initState();
    _items.addAll(['first','second','third']);
}


List __items;
double _fontSize = 14;

//Widget
Tags(
      textField: TagsTextFiled(  
        textStyle: TextStyle(fontSize: _fontSize),        
        onSubmitted: (String str) {
          setState(() {
              // required
            _items.add(str);
          });
        },
      ),
      itemCount: _items.length, // required
      itemBuilder: (int index){          
            final item = _items[index];

            return ItemTags(
                  key: Key(index.toString()),
                  index: index, // required
                  title: item, 
                  textStyle: TextStyle( fontSize: _fontSize, ),
                  combine: ItemTagsCombine.withTextBefore,
                  image: ItemTagsImage(
                    image: AssetImage("img.jpg") OR NetworkImage("https://...image.png")
                  ) OR null,
                  icon: ItemTagsIcon(
                    icon: Icons.add,
                  ) OR null,
                  removeButton: ItemTagsRemoveButton( ) OR null, 
                  onRemoved: (){
                    setState(() {
                        // required
                      _items.removeAt(index); 
                    });
                  },
                  onPressed: (item) => print(item),
                  onLongPressed: (item) => print(item),
            );

      },
)
```

### Tags() parameters
* `columns` - *possibility to set number of columns when necessary. default not set*
* `itemCount` - *tag number to display ( required ) *
* `symmetry` - *set width equal to all tags ( default false)*
* `horizontalScroll` - *ability to view and scroll tags horizontally (default false)*
* `heightHorizontalScroll` - *height to set to display tags correctly*
* `spacing` - *horizontal space between the tags*
* `runSpacing` - *vertical space between the tags*
* `alignment` - *horizontal WrapAlignment ( default WrapAlignment.center)*
* `runAlignment` - *vertical WrapAlignment ( default WrapAlignment.center)*
* `direction` - *Axis.horizontal*
* `verticalDirection` - *VerticalDirection.down*
* `textDirection` - *textDirection*
* `itemBuilder` - *tag generator*
* `textField` - *add textField => TagsTextFiled()*

### ItemTags() parameters
* `index` - *required*
* `title` - *required*
* `textScaleFactor` - *custom textScaleFactor*
* `active` - *bool value (default true)*
* `pressEnabled` - *active onPress tag ( default true)*
* `customData` - *Possibility to add any custom value in customData field, you can retrieve this later. A good example: store an id from Firestore document.*
* `textStyle` - *textStyle()*
* `alignment` - *MainAxisAlignment ( default MainAxisAlignment.center)*
* `combine` - * ability to combine text, icons, images in different ways ( default  ItemTagsCombine.imageOrIconOrText)*
* `icon` - *ItemTagsIcon()*
* `image` - *ItemTagsImage()*
* `removeButton` - *ItemTagsRemoveButton()*
* `borderRadius` - *BorderRadius*
* `border` - *custom border-side*
* `padding` - *default EdgeInsets.symmetric(horizontal: 7, vertical: 5)*
* `elevation` - *default 5*
* `singleItem` - *default false*
* `textOverflow` - *default TextOverflow.fade*
* `textColor` - *default Colors.black*
* `textActiveColor` - *default  Colors.white*
* `color` - *default Colors.white*
* `activeColor` - *default Colors.blueGrey*
* `highlightColor` - **
* `splashColor` - **
* `colorShowDuplicate` - *default  Colors.red*
* `onPressed` - *callback*
* `onLongPressed` - *callback*
* `onRemoved` - *callback*


## Donate
If you found this project helpful or you learned something from the source code and want to thank me: 
- [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/dnag88)

## Issues
If you encounter problems, open an issue. Pull request are also welcome.