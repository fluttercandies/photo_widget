# photo_widget

For photo_manager extension

## Feature

Unlike photo, this library extracts various widget units so that any widget can be extracted and put into its own project. It can also be used to quickly create your own style of image/video selector.

It has not been submitted to pub, before submission, there is no guarantee that the api will not change

## Widgets

### AssetPathWidget

Display `AssetPathEntity`

| name            | type               | requied | default value                | description                                                                                                                                                    |
| --------------- | ------------------ | ------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| path            | AssetPathEntity    | true    |                              | Concepts in photo_manager, used to describe albums                                                                                                             |
| buildItem       | AssetWidgetBuilder | false   |                              |
| rowCount        | int                | false   | 4                            | There are several items in a row, see GridView for details                                                                                                     |
| thumbSize       | int                | false   | 100                          | The size of each item thumbnail                                                                                                                                |
| scrollingWidget | Widget             | false   | const ScrollingPlaceholder() | Since loading an image is a resource-consuming operation, you only start loading images when the scrolling stops, with a placeholder before loading the image. |

### AssetWidget

Display `AssetEntity`

| name      | type        | requied | default value | description                                       |
| --------- | ----------- | ------- | ------------- | ------------------------------------------------- |
| asset     | AssetEntity | true    |               | Concepts in photo_manager, used to describe asset |
| thumbSize | int         | false   | 100           | The item thumb size.                              |
