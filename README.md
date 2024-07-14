# flutter_bbcode_editor

Edit bbcode with WYSIWYG support.

> **Warning**
>
> This package is still work in progress.

## Introduction

Flutter widget to edit [bbcode](https://en.wikipedia.org/wiki/BBCode) with [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) support.

Based on [flutter_quill](https://pub.dev/packages/flutter_quill).

## Features

> These tags are used by [TSDM forum](https://tsdm39.com/).

* [ ] BBCode tags.
  * [x] Font family (no preset).
  * [x] Font size (specified value 1~7).
  * [x] Font color.
  * [x] Bold.
  * [x] Italic.
  * [x] Underline.
  * [x] Strikethrough.
  * [x] Superscript.
  * [x] Alignment.
    * [x] Align left.
    * [x] Align center.
    * [x] Align right.
  * [ ] Custom emoji `{emoji_id}`.
  * [ ] Paragraph alignment (left/center/right).
  * [x] Url `[url]`.
  * [ ] Image `[img]`.
    * Specify size `[img=$width,$height]$image_url[/img]`.
  * [ ] Spoiler `[spoiler]`.
  * [ ] Locked area `[hide]`.
  * [ ] Mention other users with `[@]`.
  * [ ] Unordered list.
  * [ ] Ordered list.
  * [ ] Table.
* [x] Edit in WYSIWYG mode.
* [ ] ~~Edit in source code mode.~~
* [ ] View render result.
* [x] Export plain code result.
* [ ] Custom tags.
