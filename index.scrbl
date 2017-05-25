#lang reader "website.rkt"

@(require "logo/logo.rkt")

@page[#:title "Main"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{
   @div[class: "splash"]{
    @center{@img[src: word-logo alt: "Video" height: 200 width: 325]}
    @h2{A Language for Making Movies}
    @p{@b{Video} is a language for making movies. It combines
     the power of a traditional video editor with the
     capabilities of a full programming language. Video
     integrates with the Racket ecosystem and extensions for
     DrRacket to transform it into a non-linear video editor.}
    @center{
     @a[class: "btn-oval btn btn-default btn-lg"
        href: "download.html"
        role: "button"]{
      Get Started}}}}}}
