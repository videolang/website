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

  @h2{Installing Testing (Recommended)}
  
  @p{Installing Video is as simple as installing Racket, and
   downloading Video from within it.}

  
  @h2{Installing Stable}
  
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
     @p{@kbd{raco pkg install video}}}}}}}

@;{
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