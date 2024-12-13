English | [简体中文](./docs/readme.zh-CN.md)

# flutter_bbcode_editor

Edit bbcode with WYSIWYG support.

## WIP

**This package is still work in progress. Feature or API may change in the future.**

## Introduction

Flutter widget to edit [bbcode](https://en.wikipedia.org/wiki/BBCode) with [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) support.

Based on [flutter_quill](https://pub.dev/packages/flutter_quill).

## Screenshot

![cover](./docs/cover.jpg)

```console
[quote][size=4]flutter_bbcode_editor is a WYSIWYG editor based on [/size][size=4][url=https://github.com/singerdmx/flutter-quill]flutter_quill[/url][/size]
[/quote]
[size=4]Made for [/size][@]flutter[/@]

[size=6]Header size 6[/size]

[b]bold[/b]
[i]italic[/i]
[u]underline[/u]
[s]strikethrough[/s]
[color=#087]color[/color]
[backcolor=#5ae]backgroundcolor[/backcolor]

[hr]

[align=center][img=230,230]https://upload.wikimedia.org/wikipedia/commons/7/70/Example.png[/img][/align]
[align=center][size=3]Centered example image from [/size][size=3][url=https://en.wikipedia.org/wiki/BBCode]wikipedia - BBCode[/url][/size][/align]


[spoiler=Click to expand][size=4]All[/size] [b]formats[/b] can be used in [b][color=#a4b]spoiler[/color][/b]

[list]
[*][color=#e99]unordered[/color] list item 1
[*][color=#e99]unordered[/color] list item 2
[/list]

[hide=1234]Hide area inside spoiler[/hide]
[/spoiler]

[hide]This area is locked until user reply

[u]RIch[/u] text in [backcolor=#9c9]hide[/backcolor] area here

[list=1]
[*]ordered list [color=#4aa]item[/color] 1
[*]ordered list item 2
[/list][/hide]
```

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
  * [x] Divider `[hr]`
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
