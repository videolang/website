#lang reader "website.rkt"

@(require "logo/logo.rkt")

@page[#:title "Main"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{
   @div[class: "splash"]{
    @center{@img[src: word-logo alt: "Video" height: 200 width: 325]}
    @h2{A Language for Making Movies}
    @p{@b{Video} is a language for making movies.}
    @center{
     @a[class: "btn-oval btn btn-default btn-lg"
        href: "http://github.com/videolang/video"
        role: "button"]{
      Get Started}}}}}}
