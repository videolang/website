    Title: Tutorial: Making a Video Player with FFmpeg and Racket (Part 1, Decoding Video)
    Date: 2017-07-11T11:46:00
    Tags: tutorial, ffmpeg, opengl, racket, DRAFT
    Authors: Leif Andersen

[FFmpeg][ffmpeg] is a fantastic library for making multimedia applications. For example, [Video][video] uses it as [a backend for its video processing][videoffmpeg]. Unfortunately, while the library itself is great, there are not many tutorials on how to use it as a library.<sup>1</sup> Martin Bohme has written [a nice tutorial][dranger] on how to use FFmpeg to create a media player. This is a fantastic tutorial, but uses the [now deprecated FFmpeg API].[ffmpegdep].

Luca Barbato has written an excellent [blog post][newapi] that describes the new API and how it maps to he old one. In theory, someone could read these two sources in lockstep to make a media player. In practice, however, there are a few tiny details which are hard to get right when combining these posts. Resolving these issues requires users to read [the FFmpeg API documentation][ffmpegdocs]<sup>2</sup> and sometimes the FFmpeg source code itself.

This tutorial aims to rectify this issue. We will use the newer FFmpeg 3.2 API, as well as OpenGL and PortAudio, to create a simple media player. This tutorial will use [Racket][racket] because of its [exception handling][exceptions] and [garbage collection][garbage] features, while also having the speed to support a media player.

<!-- more -->

The first step to using FFmpeg in Racket is to import its bindings using Racket's FFI. Asumu Takikawa wrote a [tutorial][ffi] on how to use the FFI. To speed things along, however, we will use [existing bindings][videoffi] from the v0.2 Video branch.<sup>3</sup> These bindings work with Racket v6.10 and up. While you theoretically can follow this tutorial with DrRacket, you will have a much better experience running your code from the command line.

You can test to make sure you set up everything right by creating a file in the same directory:

```racket
#lang racket
(require "ffmpeg.rkt")
```



<sub><sup>1</sup>There are, however, plenty of tutorials for using it as a command line application.</sub>

<sub><sup>2</sup>Make sure to always check the API version number when looking at FFmpeg APIs. Google has a nasty tendency to show old, incompatible, documentation first.</sub>

<sub><sup>3</sup>These bindings do not register video datatypes with the GC. Future versions of this tutorial may be updated for this.</sup>

[ffmpeg]: https://ffmpeg.org/
[dranger]: http://dranger.com/ffmpeg/
[video]: http://lang.video
[videoffmpeg]: https://github.com/videolang/video/blob/master/video/private/ffmpeg-pipeline.rkt
[ffmpegdep]: https://ffmpeg.org/doxygen/3.2/group__lavc__decoding.html#ga3ac51525b7ad8bca4ced9f3446e96532
[newapi]: https://blogs.gentoo.org/lu_zero/2016/03/29/new-avcodec-api/
[ffmpegdocs]: http://ffmpeg.org/doxygen/3.2/
[racket]: https;//racket-lang.org
[exceptions]: http://docs.racket-lang.org/guide/exns.html
[garbage]: http://docs.racket-lang.org/reference/garbagecollection.html
[ffi]: http://prl.ccs.neu.edu/blog/2016/06/27/tutorial-using-racket-s-ffi/
[videoffi]: https://raw.githubusercontent.com/videolang/video/0dba5893097faef48b9e45900aefcd13137c27d3/video/private/ffmpeg.rkt