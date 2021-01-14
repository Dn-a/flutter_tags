## [1.0.0-nullsafety.1] - 2021-01-14.

* `[Updated]` - Documentation.
* 
## [1.0.0-nullsafety.0] - 2021-01-14.

* **Breaking Change ( Dart SDK version >= 2.12.0-133.2.beta )**

* `[Updated]` - dependencies updated to `Sound null safety` version.
* `[Fixed]` - Some problem.
* `[Updated]` - Documentation.

## [0.4.9+1] - 2020-11-11.

* `[Fixed]` - Issue #66.
* `[Fixed]` - `DataList` null id.

## [0.4.9] - 2020-09-15.

* `[Added]` - Possibility to to define the padding of the `textField`.

## [0.4.8+2] - 2020-06-02.

* `[Updated]` - Documentation.

## [0.4.8+1] - 2020-05-13.

* `[Updated]` - Documentation.

## [0.4.8] - 2020-03-07.

* `[Updated]` - Documentation.

## [0.4.7] - 2020-02-26.

* `[Updated]` -  Documentation.
* General improvement of the code.

## [0.4.6] - 2020-02-26.

* `[Fixed]` -  some problem.
* `[Added]` - Possibility to disabled/enabled `textField` field - Issue #36.
* `[Added]` - Possibility to insert tags not present in the list of suggestions with the `constraintSuggestion` field - Issue #33.
* `onRemoved` field has been moved inside `ItemTagsRemoveButton()` to maintain consistency.
* `onRemoved` now has a bool return type (ex: when you want to add a control before removing a tag).

## [0.4.5] - 2019-10-30.

* Renamed `TagstextField` to `TagsTextField`.
* Added `textCapitalization` field in `TagsTextField`.

## [0.4.4] - 2019-10-16.

* New Features and Documentation Updates.

* Added `child` field in `ItemTagsImage()`, allows more control over the images.
* Fixed alignment `textField` and `suggestions` - Issue #31.
* Added the possibility to get a list of all the `ItemTags` via GlobalKey<TagsState>.

## [0.4.3] - 2019-07-28.

* Minor Update Documentation.
* Fixed some problem.
* removed the 'position' parameter  in TagsTexField () because it is not essential. the same result can be obtained by setting the verticalDirection and TextDirection parameters in Tags ().

## [0.4.2] - 2019-07-27.

* Update Documentation.
* General improvement of the code.

## [0.4.1] - 2019-07-27.

* Minor Update Documentation.

## [0.4.0] - 2019-07-27.

* **Improvements, new Structure, new Features and Documentation Updates**
*
* `SelectableTags` and `InputTags`have been removed, now there is only one widget. **Tags()**
* Now it is possible to personalize every single tag, with the possibility of adding icons, images and a removal button.
* Possibility to display the list with horizontal scroll.

## [0.3.2] - 2019-06-20.

* Issue #14 and #13 fixed.
* Added `customData` field in Tag Class.

## [0.3.1] - 2019-05-13.

* General improvement of the code.

## [0.3.0] - 2019-04-09.

* **New features**
* Possibility to create a customizable popupMenu.
* **SelectableTags**. Possibility to set a color and an activeColor for each tag.
* **InputTags**. Possibility to hide textField.

## [0.2.4] - 2019-04-08.

* fixed some problem.

## [0.2.3] - 2019-04-05.

* General improvement of the code.
* OnInsert, onDelete and onPressed are now optional.

## [0.2.2] - 2019-03-02.

* Added property `textStyle` in InputTags. NOTE: `textColor` has been removed. now it can be set with `textStyle`.
* added property `textStyle` in SelectableTags. NOTE: if you set `color` in it will be ignored, you must use `textColor` `textActiveColor`.
* Created InputSuggestions. Return suggestions in the TextField. Is not complete, soon the list of suggestions will be implemented.
* General improvement of the code.

## [0.2.1] - 2019-03-01.

* The code has been largely rewritten.
* Now the Tag width calculation is very accurate.

## [0.2.0] - 2019-02-24.

* Improved tag width calculation; 
* Possibility to change the margin and padding of the close icon ( InputTags ).

## [0.1.9] - 2019-02-23.

* Width calculated based on the byte length of the title; 
* When the orientation changes, a recalculation of the screen width is performed.

## [0.1.8] - 2019-02-16.

* Improvement of library documentation.

## [0.1.7] - 2019-02-07.

* Added new feature SingleItem on SelectableTags; 
* Possibility to change color/background-color icon on InputTags; - General improvement of the code.

## [0.1.6] - 2019-01-07.

* Fixed error "Infinity or NaN toInt" on InputTags; - general improvement of the code.

## [0.1.5] - 2018-12-24.

* General improvement of the code.

## [0.1.4] - 2018-12-18.

* Added new features.

## [0.1.3] - 2018-12-16.

* Added new highlight feature (InputTags) - general improvement of the code.

## [0.1.2] - 2018-12-15.

* Add InputTags Widget - Improved documentation.

## [0.1.1] - 2018-12-08.

* Improved documentation.

## [0.1.0] - 2018-12-08.

* Did some changing readme.

## [0.0.1] - 2018-12-08.

* Created Selectable Tags.
