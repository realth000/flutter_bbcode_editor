# Spoiler V2

This directory contains v2 version of spoiler. 

Originally spoiler is designed to be an inline block holding hint text and support all types of tags inside.

But it's impossible to implement like that, embed attributes are exclusive, direct to a new page causes app jank on Android.

The v2 version of spoiler consists of a header and a tail, both head and tail are embed block that separated. Contents between head and tail are considered inside the spoiler.

In the future, some style may apply on the content to make it aware, but I guess not, because the behavior is not the same as expected to be an entire block.

