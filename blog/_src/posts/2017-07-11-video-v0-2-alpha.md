    Title: Video v0.2 Alpha
    Date: 2017-07-11T11:18:14
    Tags: release
    Authors: Leif Andersen

**Update2** A third alpha is released. This should be the last alpha build. The next release will be a beta. You can [download the build here][download3].

**Update:** A second alpha release has been created. This fixes some bugs preventing Video from working on Windows and Linux. Video has now been tested on all three platforms. You can [download the build here][download2].

This is an alpha version of Video v0.2. The main update here is dropping MLT as a dependency, and bundling FFmpeg for Windows and Mac builds. As such, Video can be used out of the box on now, without the need to hunt down the more obscure MLT library separately. Linux machines must still download the correct version of FFmpeg themselves. However, this is much easier to do.

Specifically, FFmpeg 3.2 is recommended, but the following specific library versions are also usable:

* libavcodec v57
* libavformat v57
* libavutil v55
* libswscale v4
* libswresample v2
* libavfilter v6

Again, these are included for the mac/windows builds, and are all part of an FFmpeg 3.x installation.

Some notes about why this is still alpha:

* The video preview currently does not work. People needing access to this feature need to use v0.1.1.
* Video has not been thoroughly tested

Once the first one has been addressed we can move to beta, and once both have been addressed we can move to rc.

You can [download the release here][download].

Please report any issues you find on [the bug tracker][tracker]. (If you don't have a github account you can also use this [anonymous form][anonymous].

[download]: https://github.com/videolang/video/releases/tag/v0.2-alpha
[download2]: https://github.com/videolang/video/releases/tag/v0.2-alpha.1
[download3]: https://github.com/videolang/video/releases/tag/v0.2-alpha.2
[tracker]: https://github.com/videolang/video/issues
[anonymous]: https://gitreports.com/issue/videolang/video