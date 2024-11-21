English | [简体中文](./docs/readme.zh-CN.md)

# flutter_bbcode_editor

Edit bbcode with WYSIWYG support.

## WIP

**This package is still work in progress. Feature or API may change in the future.**

## Introduction

Flutter widget to edit [bbcode](https://en.wikipedia.org/wiki/BBCode) with [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) support.

Based on [flutter_quill](https://pub.dev/packages/flutter_quill).

## Feature

> These tags are used in [TSDM](https://tsdm39.com/) forum.
> Allow to disable and override.

* [ ] BBCode tags
  * ~~Font family~~ *Not planned*
  * [x] Font size `[size=$size]` (specified value 1~7)
  * [x] Font color `[color]`
  * [x] Bold `[b]`
  * [x] Italic `[i]`
  * [x] Underline `[u]`
  * [x] Background color `[backcolor=$color]`
  * [x] Strikethrough `[s]`
  * [x] Superscript `[sup]`
  * [x] Alignment
    * [x] Align left `[align=left]`
    * [x] Align center `[align=center]`
    * [x] Align right `[align=right]`
  * [x] Emoji `{:emoji_id:}`
  * [x] Url `[url]`
  * [x] Image `[img]`
    * Specify size `[img=$width,$height]$image_url[/img]`
  * [x] Spoiler `[spoiler]`
  * [x] Locked area
    * [x] Locked with reply `[hide]` *Users need to reply to see this content.*
    * [x] Locked with points `[hide=$points]` *Only users have points more than $points are allowed to see this content.*
  * [x] Mention user with `[@]$user_name[/@]`
  * [x] Ordered list `[list=1]`
  * [x] Bullet list `[list=]`
  * [ ] Splitter `[hr]`
  * [ ] Table `[table]`
  * [x] Code block `[code]`
  * [x] Quote block `[quote]`
* [ ] Source code mode
* [x] Export **Output format is not stable yet, changes in future may cause old data unparsable.**
  * [x] As bbcode
  * [x] As quill delta
* [ ] Import
  * [ ] From BBCode
  * [x] From quill delta
* [ ] Custom tags
* [ ] Nested block styles (code block, quote block, list)
