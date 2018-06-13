    Title: An Introduction to Video's Architecture
    Date: 2018-06-13T18:53:05
    Tags: inside, implementation, DRAFT

Several people have asked me how Video works. I have [givent talks][bob2018] and [written papers][super8] on the tower of languages that Video uses. However, there currently isn't any documentation on how Video actually renders, well, video. This post describes the architecture Video v0.2 uses.

Existing sources mention that Video uses FFmpeg for rendering. While that is technically true, there is a lot more Video does behind the scenes to integrate the Video language with both the Racket VM, and FFmpeg. Generally speaking, Video's VM can be split into three main components, the Video compiler, the render pipeline, and finally orchestration logic. The diagram below gives a rough outline of how Video programs and media files flow through this VM. The rest of this post goes through each of these components in more detail.

<img src="/res/architecture.svg" width="800" />

<!-- more -->
 
## Video Compiler

The Video compiler translates a Video program into a filter graph that the render pipeline can understand. As of version 0.2, the code for this compiler is a bit ad-hoc. Cleaning up the compiler is a main goal for Video v0.3. Video uses a three pass compiler with the following languages: source video program, core video data structure, video filter graph, and ffmpeg filter graph.

```racket
#lang video
(clip "movie.mp4")
```

```racket
#<playlist #<producer "movie.mp4" ...>>
```

```javascript
digraph G {
    node0 [label="(source-node ...)"];
    node1 [label="(filter-node ...)"];
    node2 [label="(filter-node ...)"];
    ...
    node14 [label="(sink-node ...)"];
    subgraph D {
        node0 -> node1 [label="1"];
        node1 -> node2 [label="1"];
        node2 -> node3 [label="1"];
        node3 -> node4 [label="1"];
        node4 -> node6 [label="1"];
        node5 -> node7 [label="1"];
        node6 -> node5 [label="0"];
        ...
    }
}
```

```text
[video1]scale=height=256:width=256[video5];
[video5]fps=fps=90000[video7];
[video7]format=pix_fmts=yuv420p[video9];
[video9]setpts=expr=PTS-STARTPTS[video11];
[video11]concat=n=1:v=1:a=0[video14];

[audio8]asetpts=expr=PTS-STARTPTS[audio10];
[audio10]concat=n=1:v=0:a=1[audio12];
[audio12]atrim=end=169.27346666666668:start=0[audio19];
[audio19]aformat=sample_rates=44100:channel_layouts=stereo:sample_fmts=fltp[audio22];
[audio22]asetrate=r=44100.0[audio23]
```


## Render Pipeline

## Orchestration Logic

## Conclusion

[bob2018]: https://lang.video/blog/2018/04/17/video-at-bob-2018/
[super8]: https://dl.acm.org/citation.cfm?doid=3136534.3110274