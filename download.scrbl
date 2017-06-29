#lang reader "website.rkt"

@page[#:title "Download"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{@h1{Download}}}
 @div[class: "container"]{
  @p{Currently Installing Video is a three step process.
   First you need to install Racket; then, you need to install
   MLT; and finally you can use Racket to install Video.}
  @center{@h2{Step 1: Download Racket}}
  @a[type: "button"
     role: "button"
     href: "https://download.racket-lang.org/"
     class: "btn btn-primary btn-lg btn-block"]{
   Download Racket}
  @center{@h2{Step 2: Download MLT}}
  @a[type: "button"
     role: "button"
     href: "https://www.mltframework.org/"
     class: "btn btn-primary btn-lg btn-block"]{
   Donload MLT}
  @center{@h2{Step 3: Download Video}}
  @div[class: "row"]{
   @button[data-toggle: "collapse"
           data-target: "#step2a"
           class: "btn btn-primary btn-lg btn-block"]{
    Option A: Install in DrRacket (Recommended)}
   @div[id: "step2a" class: "collapse"]{
    @h3{Coming Soon... Use Option B for now.}}}
  @div[class: "row"]{
   @button[data-toggle: "collapse"
           data-target: "#step2b"
           class: "btn btn-secondary btn-lg btn-block"]{
    Option B: Install in terminal (Advanced)}
   @div[id: "step2b" class: "collapse"]{
    @div[class: "container"]{
     @p{First ensure that @code{raco} is in your @code{$PATH},
      and then run:}
     @kbd{raco pkg install video}}}}}}
