#lang reader "website.rkt"

@page[#:title "Documentation"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{@h1{Documentation}}}
 @div[class: "container"]{
  @h2{Video Manual}
  @p{You can find the documentation for the current stable version of Video
   @a[href: "http://docs.racket-lang.org/video/index.html"]{
    on the Racket docs website}.
   Older versions of this manual are also available:
   @ul{
    @;@li{@a[href: "man/index.html"]{v0.2 (beta)}}
    @li{@a[href: "http://docs.racket-lang.org/video@video-v0-2/index.html"]{v0.2}}
    @li{@a[href: "http://docs.racket-lang.org/video@video-v0-1/index.html"]{v0.1}}
    @li{@a[href: "http://docs.racket-lang.org/video@video-v0-0/index.html"]{v0.0}}}}
  @h2{Publications}
  @p{This is a list of Video related publications.}
  @ul{
   @li{@b{Super 8 Languages for Making Movies (A Functional
     Pearl).} Leif Andersen, Stephen Chang, Matthias Felleisen.
    ICFP 2017
    (@a[href: "https://doi.org/10.1145/3110274"]{PDF},
    @a[href: "pub/icfp2017/errata.html"]{Errata})
    (@a[href: "pub/icfp2017/slides.pdf"]{Slides},
    @a[href: "https://github.com/videolang/website/tree/master/pub/icfp2017/slidesrc"]{Source})}}}}
