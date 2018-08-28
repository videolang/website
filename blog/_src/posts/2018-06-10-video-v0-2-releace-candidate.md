    Title: Video v0.2 Releace Candidate
    Date: 2018-06-10T21:49:43
    Authors: Leif Andersen
    Tags: release

**Update:** We have released a second release candidate. This fixes several bugs users have posted on the issue tracker.

The first release candidate for Video v0.2 has been released! You can install it from the command line with:

```
raco pkg install video-testing
```

As before, the `video` Racket package points to the latest stable version (v0.1 when writing this post), so use `video-testing` to download the RC.

You can report any bugs you find here: https://github.com/videolang/video/issues

Here is a list of the major changes from the last beta:

* Update Video to use a version of libvid that does not segfault.
* More precise dependencies in Video's info file.
* If FF_LOG=stdout, then do no redirection of ffmpeg's logging.
* More complete render parameterization.
* Cleaner error messages.
* Fixed bug preventing Video from rendering audio-only files.
* Pause feature no longer additionally stops the video.
* Improved audio/video syncing in live preview.
* Fixed bugs in front half of Video compiler.
* Made 'canvas' an optional parameter
