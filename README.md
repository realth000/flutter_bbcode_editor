# flutter_bbcode_editor

Edit bbcode with WYSIWYG support.

> **Warning**
>
> This package is still work in progress.

## Introduction

Flutter widget to edit [bbcode](https://en.wikipedia.org/wiki/BBCode) with [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) support.

Based on [flutter_quill](https://pub.dev/packages/flutter_quill).

## Features

> These tags are used in [TSDM](https://tsdm39.com/) forum.
> Can disable and override.

* [ ] BBCode tags.
  * [x] Font family (support code convert but no visual result).
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
  * [x] Image `[img]`.
    * Specify size `[img=$width,$height]$image_url[/img]`.
  * [ ] Spoiler `[spoiler]`.
  * [ ] Locked area `[hide]`.
  * [ ] Mention other users with `[@]`.
  * [x] Ordered list.
  * [x] Bullet list.
  * [ ] Table.
* [ ] Source code mode.
* [x] Export plain code result.
* [ ] Custom tags.

### Not supported

These features are not supported.

* Nested block styles (code block, quote block, list)
