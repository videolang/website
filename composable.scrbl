#lang reader "website.rkt"

@(require "logo/logo.rkt")

@page[#:title "Composable"]{
 @div[class: "jumbotron"]{
  @center{
   @div[class: "container clearfix"]{
    @img[src: composable-logo
         alt: "Composable Logo"
         width: 100
         class: "pull-left mr-5"]
    @h1{Composable}}}}
 @div[class: "container"]{
  @p{Composable consists of
   @a[href: "https://leifandersen.net"]{Leif Andersen} and
   @a[href: "https://benchung.github.io"]{Benjamin Chung}. We
   develop and maintain the @a[href: "https://lang.video"]{
    Video Language}. We also record scientific conferences,
   primarily conferences run by
   @a[href: "https://www.sigplan.org/"]{ACM SIGPLAN}. You can
   find the videos we've recorded at
   @a[href: "https://twitter.com/PLPresents"]|{@PLPresents}|}
  @br{}
  @div[class: "row"]{
   @div[class: "col-md-6 blurb"]{
    @center{@img[src: "res/leif.jpg" alt: "Leif Andersen" width: 300]}
    @center{@h2{Leif Andersen}}}
   @div[class: "col-md-6 blurb"]{
    @center{@img[src: "res/ben.jpg" alt: "Benjamin Chung" width: 300]}
    @center{@h2{Benjamin Chung}}}}
}}
