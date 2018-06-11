    Title: An Introduction to Video's Architecture
    Date: 2018-06-13T18:53:05
    Tags: inside, implementation, DRAFT

Several people have asked me how Video works. I have [givent talks][bob2018] and [written papers][super8] on the tower of languages that Video uses. However, there currently isn't any documentation on how Video actually renders, well, video. This post describes the architecture Video v0.2 uses.

Existing sources mention that Video uses FFmpeg for rendering. While that is technically true, there is a lot more Video does behind the scenes to integrate the Video language with both the Racket VM, and FFmpeg. Generally speaking, Video's VM can be split into three main components, the Video compiler, the render pipeline, and finally orchestration logic. The diagram below gives a rough outline of how Video programs and media files flow through this VM. The rest of this post goes through each of these components in more detail.

<img src="/res/architecture.svg" width="800" />

<!-- more -->
 
## Video Compiler

## Render Pipeline

## Orchestration Logic

## Conclusion

[bob2018]: https://lang.video/blog/2018/04/17/video-at-bob-2018/
[super8]: https://dl.acm.org/citation.cfm?doid=3136534.3110274