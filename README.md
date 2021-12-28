# photo_widget

Flutter widgets.

Base on photo_manager, wraps up some UI components to quickly display the photo_manager as a usable widget, inserting it wherever you need it.

## Feature

Unlike photo, this library extracts various widget units so that any widget can be extracted and put into its own project. It can also be used to quickly create your own style of image/video picker.

Currently in the development stage, the API may change at any time.

## Import

```dart
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_widget/photo_widget.dart';
```

## Widgets

### AssetPathWidget

Display `AssetPathEntity`

| name            | type               | required | default value                | description                                                                                                                                                    |
| --------------- | ------------------ | -------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| path            | AssetPathEntity    | true     |                              | Concepts in photo_manager, used to describe albums                                                                                                             |
| buildItem       | AssetWidgetBuilder | false    | AssetWidget.buildWidget      | Build items in the list                                                                                                                                        |
| rowCount        | int                | false    | 4                            | There are several items in a row, see GridView for details                                                                                                     |
| thumbSize       | int                | false    | 100                          | The size of each item thumbnail                                                                                                                                |
| scrollingWidget | Widget             | false    | const ScrollingPlaceholder() | Since loading an image is a resource-consuming operation, you only start loading images when the scrolling stops, with a placeholder before loading the image. |

### AssetWidget

Display `AssetEntity`

| name      | type        | required | default value | description                                       |
| --------- | ----------- | -------- | ------------- | ------------------------------------------------- |
| asset     | AssetEntity | true     |               | Concepts in photo_manager, used to describe asset |
| thumbSize | int         | false    | 100           | The item thumb size.                              |

### PickAssetWidget

A widget with a selection box for displaying assets is generally used in scenes where you need to select an image.

| name                  | type                                                                       | required | default value             | description                                                                              |
| --------------------- | -------------------------------------------------------------------------- | -------- | ------------------------- | ---------------------------------------------------------------------------------------- |
| asset                 | AssetEntity                                                                | true     |                           | Concepts in photo_manager, used to describe asset                                        |
| thumbSize             | int                                                                        | false    | 100                       |                                                                                          |
| provider              | PickerDataProvider                                                         | true     |                           | This is a provider for picker scenes, and internally maintains the data needed by picker |
| onTap                 | Function                                                                   | false    |                           | Callback when item is clicked, exception, there is a separate response in checkbox area  |
| pickColorMaskBuilder  | typedef Widget PickColorMaskBuilder(BuildContext context, bool picked)     | false    | PickColorMask.buildWidget | Used to mask the image when selected or unselected                                       |
| pickedCheckboxBuilder | typedef Widget PickedCheckboxBuilder(BuildContext context, int checkIndex) | false    |                           | Whether to build the checked flag, the default is a `PickedCheckbox`                     |

### PickColorMask

Colored mask

### PickedCheckbox

A default white background, the blue selection box is selected, and the selected serial number will be selected after selection.
