#lang reader "website.rkt"

@page[#:title "Download"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{@h1{Download}}}
 @div[class: "container"]{
                          
  @p{There are currently two variants of Video, @samp{stable}
   and @samp{testing}. We highly recommend using @samp{
    testing}, as the @samp{stable} branch is old. (The @samp{
    testing} branch will be merged into @samp{stable} in the
   coming months.)}

  @h2{Install Testing (Recommended)}
  
  @p{On Windows and macOS, you can download Video directly within Racket.}

  @div[class: "container"]{
   @center{@h3{Step 1: Download Racket}}
   @a[type: "button"
      role: "button"
      href: "https://download.racket-lang.org/"
      class: "btn btn-primary btn-lg btn-block"]{
    Download Racket}
   @center{@h3{Step 2: Download Video}}
   @div[class:"container"]{
    @div[class: "panel-group" id: "accordion"]{
     @div[class: "panel panel-primary"]{
      @h4[class: "panel-title"]{
       @a[data-toggle: "collapse"
          data-parent: "#accordion"
          href: "#collapse1"]{
        Install in DrRacket}}
      @div[id: "collapse1" class: "panel-collapse collapse in"]{
       @div[class: "panel-body"]{
        @img[src: "res/install-step1.png"
             alt: "Installation Step 1"]
        @img[src: "res/install-step2.png"
             alt: "Installation Step 2"]}}
      @div[class: "panel-group" id: "accordion"]{
       @div[class: "panel panel-primary"]{
        @h4[class: "panel-title"]{
         @a[data-toggle: "collapse"
            data-parent: "#accordion"
            href: "#collapse2"]{
          Install with command line}}}}
      @div[id: "collapse2" class: "panel-collapse collapse"]{
       @div[class: "panel-boy"]{
        If you have added Racket to your @kbd{$PATH}, you can
        install Video by typing in:
        @p{@kbd{raco pkg install video}}}}}}}}

  @br{}
  
  @h2{Install Stable}
  
  @p{We highly recommend installing Video's testing build. The latest build
  of the stable branch requires manual library installation.}

  @p{
   @div[class: "row"]{
    @button[data-toggle: "collapse"
            data-target: "#opt2"
            class: "btn btn-secondary btn-lg btn-block"]{
     Show (Not Recommended)}
    @div[id: "opt2" class: "collapse"]{
     @div[class: "container"]{
      @p{Currently Installing Video stable is a three step process.
       First you need to install Racket; then, you need to install
       MLT; and finally you can use Racket to install Video.}
      @center{@h3{Step 1: Download Racket}}
      @a[type: "button"
         role: "button"
         href: "https://download.racket-lang.org/"
         class: "btn btn-primary btn-lg btn-block"]{
       Download Racket}
      @center{@h3{Step 2: Download MLT}}
      @a[type: "button"
         role: "button"
         href: "https://www.mltframework.org/"
         class: "btn btn-primary btn-lg btn-block"]{
       Download MLT}
      @center{@h3{Step 3: Download Video}}
      @p{First ensure that @code{raco} is in your @code{$PATH},
       and then run:}
      @p{@kbd{raco pkg install video}}}}}}}}
