    Title: Video v0.2 Released
    Date: 2018-09-04T13:16:35
    Authors: Leif Andersen
    Tags: relase

We just launched Video v0.2. This release marks the first stable version of Video for since v0.1.1 over a year ago. This release uses FFmpeg as a backend directly, rather than going through MLT. As such, Video is significantly more stable. Additionally, Windows and macOS users don't need to worry about installing any more third party libraries, as Video comes bundled with the versions of FFmpeg required to run.<sup>1</sup>

You can download the latest version of Video using the Racket archives, by running:

```
raco pkg install video
```

or installing it in DrRacket. Alternatively, you can download a tarball [on Github](https://github.com/videolang/video/releases/tag/v0.2).

The following is a list of features since the last release candidate for Video. See previous blog posts or the [LOG file](https://github.com/videolang/video/blob/master/LOG) for a full list.


* Complete rewrite of compiler (first two passes).
  - New compiler creates significantly more stable video programs.
* Can now properly decode wav files
* Remove explicit #:transitions/#:merges keywrods from playlists/filters.
* Fixed bug preventing video from being compiled on systems without ffmpeg.
  - (Still requires ffmpeg to run.)
* Improve video player stability.
  - Seek bar and counter much more reliable.
  - Disable some unstable features, to be enabled for the next release.
* Minimum required version of Racket bumped to 7.0
* Add a --prove flag to raco video to get information about media file.
* When using the video player server, sound stops when the server is out of scope.
* The video-player-server% object is now considerably easier to construct.
* Add #:start/#:end/#:length as special keywords for clip function.
* Improve pause responsiveness
* Add `-m` flag to play media files without a video program
* Fix bug where audio wouldn't play on windows
* Pause feature no longer additionally stops the video.
* Improved audio/video syncing in live preview.
* Fixed bugs in front half of Video compiler.
* Made 'canvas' an optional parameter

<sub><sup>1</sup>Linux users will still need to install FFmpeg themselves. Video will work best with FFmpeg 3.x, but may also work with 2.7+ with mixed results.</sub>