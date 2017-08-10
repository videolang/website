#lang reader "website.rkt"

@page[#:title "Documentation"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{@h1{Documentation}}}
   @div[class: "container"]{
  @h2{Video Manual}
  @p{You can find the current documentation for Video
   @a[href: "http://docs.racket-lang.org/video@video-v0-1/index.html"]{
    on the Racket docs website}.
   Older versions of this manual are also available:
   @ul{
    @;@li{@a[href: "man/index.html"]{v0.2 (beta)}}
    @li{@a[href: "http://docs.racket-lang.org/video@video-v0-1/index.html"]{v0.1}}
    @li{@a[href: "http://docs.racket-lang.org/video@video-v0-0/index.html"]{v0.0}}}}
  @h2{Publications}
  @p{This is a list of Video related publications.}
  @ul{
   @li{@b{Super 8 Languages for Making Movies (A Functional
     Pearl).} Leif Andersen, Stephen Chang, Matthias Felleisen.
    ICFP 2017 (@a[href: "pub/icfp2017.pdf"]{PDF})}}}}
