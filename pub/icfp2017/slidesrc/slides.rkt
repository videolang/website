#lang at-exp slideshow

(require racket/draw
         pict/shadow
         slideshow/staged-slide
         slideshow/play
         (only-in ppict/slideshow pslide-base-pict)
         ppict/slideshow2
         ppict/pict
         images/icons/misc
         pict/color
         pict/flash
         pict/balloon
         slideshow/code
         "block.rkt"
         "character.rkt"
         "demo.rkt"
         "logo.rkt"
         "assets.rkt"
         "tower.rkt"
         "utils.rkt")


(define video-block (new block%
                         [label "Video"]
                         [shape (draw-colored-rect (light "blue"))]))

(define small-logo (scale-to-fit the-plain-logo 300 300))
(define tiny-logo (scale-to-fit the-plain-logo 150 150))
(define leif (new person%))

(define (bg-slide-assembler title sep content)
  (inset content (- margin) (- margin) 0 0))

(define ben (new person%
                 [hair-color "black"]
                 [hair-type 'short]
                 [skin-color "SaddleBrown"]
                 [outfit 'pants]
                 [bottom-color "gray"]
                 [top-color "red"]))

(define (make-a-dsl-slide [overlay #f]
                          #:cite [cite #f]
                          #:lower [lower 60]
                          #:sep [sep 10]
                          #:text-func [text-func t*]
                          #:carrot-offset [carrot-offset -35]
                          #:slogan [slogan 'spark])
  (define prob (text-func "We have a problem..."))
  (define terms (vc-append (text-func "We want to solve it in the")
                           (text-func "problem domain's own language...")))
  (define solve*
    (match slogan
      ['spark make-a-dsl]
      ['tower tower-of-dsls]
      ['syntax-parse (vc-append
                      (blank 90)
                      syntax-parse-dsl
                      (blank 95))]
      ['linguistic-huh (vc-append
                        (blank 90)
                        (hc-append (mlt "? ")
                                   (scale linguistic-inheritance 1.4)
                                   (mlt " ?"))
                        (blank 100))]
      ['linguistic (vc-append
                    (blank 90)
                    (scale linguistic-inheritance 1.8)
                    (blank 95))]))
  (staged [start mid end]
          (pslide
           #:go (coord 1/2 1/2 'cc)
           (vc-append
            10
            (blank lower)
            (if (at/after start) prob (ghost prob))
            (blank sep)
            (if (at/after mid) terms (ghost terms))
            (if (at/after end) solve* (ghost solve*)))
           #:go (coord 0.505 0.14 'cc)
           (if overlay
               (vc-append
                carrot-offset
                (cond [(string? overlay)
                       (colorize (text overlay scribbly-font 42) "red")]
                      [else overlay])
                the-^)
               (blank 0))
           #:go (coord 1 1 'rb)
           (or (and (at/after end)
                    cite)
               (blank 1)))))

(define (clouds-pict s
                     #:ffi-cloud [ffi-cloud? #t]
                     #:doc-cloud [doc-cloud? #t]
                     #:types-cloud [types-cloud? #t])
  (scale
   (freeze
    (ppict-do (blank 1100 750)
              #:go (coord 0.5 0.65 'cc)
              (if ffi-cloud? (scale ffi-cloud 1.7) (blank 1))
              #:go (coord 0.2 0.35 'cc)
              (if doc-cloud? (scale (rotate doc-cloud (* pi 1/4)) 1.2) (blank 1))
              #:go (coord 0.75 0.4 'cc)
              (if types-cloud? (scale type-cloud 1.55) (blank 1))))
   s))

(set-page-numbers-visible! #f)
;(current-page-number-font (make-object font% 42 'default))
(set-spotlight-style! #:size 100
                      #:color (make-object color% 64 64 0 0.66))

#|
Good morning ICFP! Today I will be talking about Super 8 Langauges for
making movies. Super 8, for reference, is the title of a monstor movie
about making movies. The recursive and abiguous nature of the title seemed appropriate
given the content of this talk.
|#
(parameterize ([current-slide-assembler bg-slide-assembler])
  (slide
   (ppict-do (bitmap "res/plt-back.title.1024x768.png")
             #:go (coord 1/2 1/2 'cc)
             (t* "Super 8 Languages for Making Movies")
             (t "(A Functional Pearl)")
             (blank 60)
             (colorize (t "Leif Andersen") "blue")
             (colorize (t "Stephen Chang") (dark "brown"))
             (colorize (t "Matthias Felleisen") (dark "brown"))
             (blank 50)
             (colorize (st "PLT @ Northeastern University") (dark "blue"))
             (blank 10)
             (colorize (st "ICFP - Sept 4, 2017") "black"))))

#|
You see, `super 8 languages for making movies` can be parsed in two different ways.
It can either refer to `super 8`, as in a language for making movies, but it
can also refer to `8 languages for making movies`, with super being a preposition
and the `8 languages` referring to a tower of DSLs enabling video production.
This talk is about both of these concepts. First, lets talk about whata DSL
for making movies would can even look like.
|#
(mk-title-slide #:to-highlight 'top)

#|
This is me.
|#
(slide
 (send leif draw))

#|
I like to record things.
|#
(pslide
 #:go (coord 1/2 1/2 'cc #:compose hc-append)
 (send leif draw)
 small-logo)

#|
One day, I foolishly offered to record and edit the recordings for a conference.
|#
(pslide
 #:go (coord 0 1/2 'lc #:compose hc-append)
 (send leif draw)
 #:go (coord 0.45 0.35 'cc)
 tiny-logo
 #:go (coord 0.74 0.26 'rc)
 (scale the-microphone 1.7)
 #:go (coord 0.9 1/4 'rc #:compose hc-append)
 (scale (send ben draw) 0.66)
 #:go (coord 1 0.2 'rc)
 (desktop-machine 1.5))

#|
The recording went well, but then I needed to find a way to clean up the
recording and upload it to the internet. That means I needed to combine
three feeds, the presontor's video, the presontor's audio, and the presentor's
screen, into one video. Producing something like this.
|#
(let ()
  (define the-machine (desktop-machine 1.5))
  (define the-cloud (cc-superimpose
                     (cloud 400 125 #:style '(wide))
                     (scale the-? 0.3)))
  (staged [items arrows]
          (pslide #:go (coord 0 0 'lt)
                  the-machine
                  #:go (coord 0.5 0 'ct)
                  tiny-logo
                  #:go (coord 0.95 0 'rt)
                  the-microphone
                  #:go (coord 0.5 0.4 'cc)
                  (if (at/after arrows) the-cloud (ghost the-cloud))
                  #:go (coord 0.5 0.8 'cc)
                  (if (at/after arrows) cloud-demo (ghost cloud-demo))
                  #:set (let ([p ppict-do-state])
                          (if (at/after arrows)
                              (let* ([p (pin-arrow-line
                                         20 p
                                         the-machine cb-find
                                         the-cloud (λ (a b)
                                                     (let-values ([(x y) (ct-find a b)])
                                                       (values (- x 100) y)))
                                         #:start-angle (* pi -1/2)
                                         #:end-angle (* pi -1/2)
                                         #:line-width 8)]
                                     [p (pin-arrow-line
                                         20 p
                                         tiny-logo cb-find
                                         the-cloud ct-find
                                         #:line-width 8)]
                                     [p (pin-arrow-line
                                         20 p
                                         the-microphone cb-find
                                         the-cloud (λ (a b)
                                                     (let-values ([(x y) (ct-find a b)])
                                                       (values (+ x 100) y)))
                                         #:start-angle (* pi -1/2)
                                         #:end-angle (* pi -1/2)
                                         #:line-width 8)]
                                     [p (pin-arrow-line
                                         20 p
                                         the-cloud cb-find
                                         cloud-demo ct-find
                                         #:line-width 8)])
                                p)
                              p)))))

#|
So I got to work, and after a while
|#
(play-n
 #:delay 0.01
 #:steps 100
 (λ (n)
   (define index (min (exact-floor (* n (length clock-list)))
                      (sub1 (length clock-list))))
   (scale (list-ref clock-list index) 2)))

#|
I had one video edited.
|#
(slide
 (lt "One down"))

#|
The problem is that this was a conference, not just one talk. So I still had
19 more edits to go.
|#
(slide
 (lt "One down")
 (lt "19 more to go..."))

#|
So I had a few options, I could either just repeat the task of editing a
single video.
|#
(play-n
 #:delay 0.01
 #:steps 50
 (λ (n)
   (define index (min (exact-floor (* n (length clock-list)))
                      (sub1 (length clock-list))))
   (list-ref clock-wall-list index)))

#|
Or I could find a way to automate the process.

What I really needed to do was find a way to abstract over
the process of editing a video, so I could have a machine do it
for me.
|#
(let ()
  (define strike (colorize (filled-rectangle 500 10) "red"))
  (define auto (mt "Automation"))
  (define abstraction (colorize (text "Abstraction" scribbly-font 80) "red"))
  (staged [aut abs]
          (slide
           (vc-append
            10
            (mt "We Need")
            (cc-superimpose
             auto
             (if (at/after abs) strike (ghost strike)))
            (if (at/after abs) abstraction (ghost abstraction))))))

#|
So I rushed off to see what existing tools I could use for the job
I found 3 catagories of tools:

The first type is editor plugins, such as Blender's API or After Effects script.
These are good for building extensions to video editor, but are not desirable
when abstracting over videos. Details are in the paper.

The second type are OS macros. Here I don't meen C pre-processor
directives or syntax extensions for a language, I mean the type
of scripts you see when making UI tests. On example is Apple Script,
which provides a uniform scripting language accross applications.
Unfortunately, these are too brittle, see the paper for details.

The final option is shell scripts. The are arguably the most powerful,
but can feel like your programming in video-assembly, so to speak. Again,
details are in the paper. We can, and should, do better.
|#
(the-landscape-slide)

#|
All of these options made me sad. So I went back to the drawing board, and
took a look at what the essense of a video editor, or as they're called in
the video production industry, an NLVE, is.

After some thought, I realized that an NLVE really is a functional programming
language, even if professionals in the field haven't realized it yet. This is
because modern video day editing does not have any side effects, the original
source is not altered in any way. Rather, the editor just provide a description
of how to translate the source clips into an output. As such, you can
think of it as a peculuar graphical language for describing a function that
takes input clips, and produces an output clip.

Unfortunately this language does not have any way of creating new (or helper)
functions, and no expressive way of making new abstractions. And this is where
it fails.
|#
(play-n
 #:steps 20
 #:delay 0.025
 (λ (n)
   (fade-pict
    n
    (vc-append
     (mst "Video Editor")
     the-small-scaled-nlve)
    (vc-append
     50
     (ht-append (t*.5 "Functional Programming Language")
                (t "*"))
     the-lambda
     (vc-append
      (ht-append (st "*")
                 (t* "But bad with abstractions.")))))))

#|
So I went off to my desk for a while, and eventually came up
with a solution, I called "Video", which is a programming language for
editing videos.
|#
(slide
 (mlt "Video,")
 (mst "the programming language"))

#|
The resulting product looked something like this. It starts with `#lang video`
and the rest of the script describes a video. In this case, we are building
a mosaic of conference talks. Some notable features of this language include:

* List comprehensions, which are used to append the talks vertically and
horizontally on the screen.

* Primitives, which are used to import actual images, video, and audio from
the hard drive.

* Modules, as shown with this call to `external-video`.

* And functions, as shown in this helper file.

* Note that these two files are using slightly different
language declarations. #lang video means that the rest of the module
describes a video. It can have helper functions, but every top level
expression needs to be something that can be converted into a video.
On the other hand, #lang video/lib results in a video based on the function
in the file that matches the module's name.
|#
(vid-slide)

#|
Running this code gives us this result. The person on the screen is one of
the paper's co-authors. Note that this is NOT being pre-rendered. Video is
actually running this code live.
|#
(slide
 func-demo)

#|
Also, to show you that this is a real thing, and not just a toy
(nothing wrong with toys, they're cute), we actually used this
to edit all of the videos for the RacketCon 2016 videos. And
David Christenson also used it for editing many of the OPLSS 2016
videos as well.
|#
(slide
 (scale-to-fit (bitmap "res/youtube.png") 1000 700))

#|
In fact, not only were we able to use this to edit actual videos,
but it took me less time to both create this language and edit
videos with it then to just edit the videos by hand.

This is HUGE! It shows that making a DSL can be so cheap, its worth
it to make one even if a single program is written with it.

And now we have the DSL and can have a much faster turn arround time for
future conferences!
|#
(slide
 (hc-append
  35
  (vc-append
   10
   script-clock
   (vc-append (t* "Writing Video")
              (t* "+ Editing Talks"))
   (st "(RacketCon 2016)"))
  (scale (vlt "<") 1 1.5)
  (vc-append
   15
   nlve-clock
   (vc-append
    (t* "Editing Talks")
    (t* "Manually"))
   (st "(RacketCon 2015)"))))

#|
Okay, that was a long enough break.
Remember when I said that this talk's title could be
parsed two seperate ways, it turns out that the second parsing,
the tower of DSLs, is the not-so-secret weapon.
|#
(mk-title-slide #:pre-slash #f
                #:to-highlight 'bottom)

#|
So, while Video itself is a DSL, it is also a tower of DSLs
all working together. To understand how this works, lets take
a closer look at the problem.
|#
(slide
 (mlt "Video,")
 (mst "the tower of languages"))

#|
Up here in the clouds we have Video, the nice language that we would
like to be making movies in. However, down in the weeds we have libraries
like FFmpeg and MLT. These libraries handle the encoding, decoding, signal
procesing, etc. that we need for Video. But they lack the linguistic
constructs that we want in Video.

In this talk we will focus on three aspects we would like in Video. First,
we need to create an FFI layer to connect MLT and FFmpeg (which are implemented
in C), to the Racket VM. Second, we would like to write documentation for
Video. Finally, and while not strictly necesarry, it would be pretty cool if
we could even create a typed video language.
|#
(let ()
  (define v (send video-block draw 600 100))
  (define m (send mlt-block draw 250 100))
  (define f (send ffmpeg-block draw 250 100))
  (define t
    (freeze
     (ppict-do (blank 900 700)
               #:go (coord 0.5 0.65 'cc)
               (scale ffi-cloud 1.7)
               #:go (coord 0.3 0.35 'cc)
               (scale (rotate doc-cloud (* pi 1/6)) 1.2)
               #:go (coord 0.75 0.4 'cc)
               (scale type-cloud 1.55))))
  (play-n
   #:steps 20
   #:delay 0.01
   #:skip-first? #t
   (λ (n1 n2)
     (ppict-do (blank 600 600)
               #:go (coord 3/4 n1 'cb)
               (if (= n1 0) (ghost f) f)
               #:go (coord 1/4 n1 'cb)
               (if (= n1 0) (ghost m) m)
               #:go (coord 1/2 (* n1 1/6) 'cb)
               (if (= n1 0) (ghost v) v)
               #:go (coord 1/2 1/2)
               (cellophane t n2)))))

#|
Clearly, this is a problem, and we need to find a way to bridge the gap.
There are many ways to do this, and the most straightforward way is to open
up your favorite programming language and start hacking...errr...designing....
your way to the solution. You will eventually implement the language, but
it will take a lot of work, and be tricky to maintain.

Another approach is to solve the problem in the language of the problem
itself. This has three big advantages: first, it allows domain experts
(that are not necisarrily programming experts) to solve the problem,
and second, it allows the solution to be made more quickly, and finally
the simpler code enables easier maintence and prototype.

In other words, as Paul Hudak said, DSLs are the ultimate abstraction.
|#
(make-a-dsl-slide)

#|
In specific we have 3 problems. An FFI problem, a documentation problem,
and a self imposed types problem. As before, we want to solve them on their
own terms, so we want a tower of DSLs, rather than just one.
|#
(make-a-dsl-slide the-clouds
                  #:sep 0
                  #:lower 70
                  #:text-func t
                  #:carrot-offset -50
                  #:slogan 'tower)

#|
Some people call this language oriented programming.
The process involves breaking down a larger problem into smaller domain
specific problems, and using a DSL that is suited for each
sub problem.
|#
(slide
 tower-of-dsls
 (blank 50)
 (mst "Language Oriented")
 (mst "Programming"))

#|
Because we want to make a lot of DSLs, most of which will
be used for a single program, we need to be able to make DSLs quickly.
This is where Racket comes in. It, like many other functional languages,
gives us the ability to make DSLs quickly. What really sets Racket apart
however, is the ability to quickly make DSLs vertically, and not just horizontally
compose.
|#
(slide
 (st* "We want to make DSLs quickly...")
  (vc-append
  (st* "Use Racket, a programmable")
  (st* "programming language"))
  (scale
   (cc-superimpose
    (mk-video-tower #:render-sp #f
                    #:render-ffi #f
                    #:render-ts #f
                    #:render-tv #f
                    #:render-scribble #f
                    #:render-viddoc #f
                    #:render-top #f)
    (clouds-pict 0.8))
   0.8))

#|
That is, we can make DSLs using what we call linguistic inheritence. As an
example, take this tower, we have Racket at the bottom, and Video which is
built on top of it, and up in the clouds we have movie
scripts built with Video.

When creating Video implementation, we can do so by describing it in terms of a base language,
in this case Racket. The four main operations that we can use are: we can let
an existing feature pass through unchanged, we can remove an existing feature, we can create
new features, and we can can change the interpretation of an existing feature. Its this last
option that is special and makes a vertical stacking of DSLs so easy.
|#
(mk-tower-slide)

(let ()
  (define v-code
    (vc-append
     (hc-append (codeblock-pict @~a{#lang })
                (cc-superimpose
                 (colorize (filled-rectangle 100 40) "yellow")
                 (code video)))
    (codeblock-pict @~a{
                        
 logo
 talk
 
 ;; Where
 (define logo
   ...)
 (define talk
   ...)})))
  
  (define r-code
    (vc-append
     (hc-append (codeblock-pict @~a{#lang })
                (cc-superimpose
                 (colorize (filled-rectangle 120 40) (light "red"))
                 (code racket)))
    (codeblock-pict @~a{
 
 (provide vid)
 (require vidlib)
 (define logo
   ...)
 (define talk
   ...)
 
 (define vid
   (playlist logo
             talk))})))
  (define mbv (cc-superimpose
               (colorize (filled-rectangle 280 40) "yellow")
               (code #%module-begin)))
  (define vl (cc-superimpose
              (colorize (filled-rectangle 100 40)  "yellow")
              (code video)))
  (define rl (cc-superimpose
              (colorize (filled-rectangle 120 40) (light "red"))
              (code racket)))
  (define vlib (cc-superimpose
                (colorize (filled-rectangle 120 35)  "yellow")
                (code vidlib)))
  (define vid-mod
    (scale
    (code
     (module anon #,vl
       (#,mbv
        logo
        talk
        (define logo
          ...)
        (define talk
          ...))))
    0.8))
  (define mbr (cc-superimpose
               (colorize (filled-rectangle 280 40) (light "red"))
               (code #%module-begin)))
  (define rr (cc-superimpose
              (colorize (filled-rectangle 270 40) (light "red"))
              (code (require #,vlib))))
  (define vb (cc-superimpose
              (colorize (filled-rectangle 300 110) "yellow")
              (code
               (vid-begin vid
                logo
                talk))))
  (define rmod
    (scale
    (code
     (module anon #,rl
       (#,mbr
        #,rr
        (define logo
          ...)
        (define talk
          ...)
        #,vb)))
    0.8))
  (define pv (cc-superimpose
              (colorize (filled-rectangle 240 40) (light "red"))
              (code (provide vid))))
  (define dv (cc-superimpose
              (colorize (filled-rectangle 310 110) (light "red"))
              (code (define vid
                      (playlist logo
                                talk)))))
  (define rpmod
    (scale
    (code
    (module anon racket
      (#%module-begin:racket
       #,pv
       (require vidlib)
       (define logo
         ...)
       (define talk
         ...)
       #,dv)))
     0.8))
  (pslide
   #:go (coord 1/2 0.1 'ct)
   (t "Interposition Points")
   #:go (coord 1/2 0.3 'ct)
   (pin-arrow-line
    15
    (ht-append
     v-code
     (blank 200)
     vid-mod)
    v-code (λ (a b)
             (let-values ([(x y) (rt-find a b)])
               (values (- x 15) (+ y 150))))
    vid-mod (λ (a b)
              (let-values ([(x y) (lt-find a b)])
                (values (+ x 35) (+ y 150))))
    #:line-width 5
    #:label (t "parses")))
  (pslide
   #:go (coord 1/2 0.1 'ct)
   (t "Interposition Points")
   #:go (coord 1/2 0.3 'ct)
   (pin-arrow-line
    15
    (ht-append
     vid-mod
     (blank 200)
     rmod)
    vid-mod (λ (a b)
              (let-values ([(x y) (rt-find a b)])
                (values (- x 30) (+ y 150))))
    rmod (λ (a b)
           (let-values ([(x y) (lt-find a b)])
             (values (+ x 20) (+ y 150))))
    #:line-width 5
    #:label (t "elaborates"))))

(let ()
  (define lang (codeblock-pict "#lang racket"))
  (define rec-code (code (require racket)))
  (define all-from-out (code (provide (all-from-out racket))))
  (define only-out (code (provide (only-out racket
                                            lambda
                                            +))))
  (define ~mb (cc-superimpose
               (colorize (filled-rectangle 350 40) "cyan")
               (code video-module-begin)))
  (define %mb (cc-superimpose
               (colorize (filled-rectangle 270 40) "yellow")
               (code #%module-begin)))
  (define r-%mb (cc-superimpose
                 (colorize (filled-rectangle 270 40) (light "red"))
                 (code #%module-begin)))
  (define rename-out
    (freeze (code (provide (rename-out [#,~mb
                                        #,%mb])))))
  (define def-syntax
    (freeze (code (define-syntax (#,~mb stx)
                      ... #,r-%mb ...))))
  (staged [rename]
          (slide
           (t* "Implementing Interposition Points")
           (vl-append
            lang
            rename-out
            def-syntax))))

#|
We can see an example of this in Video's FFI.
|#
(slide
 (scale ffi-cloud 2))

#|
MLT is a library implemented in C, which Video uses to handle low level video processing.
For example, this C function is `mlt_factory_init`.

We can re-use Racket's existing FFI to connect the C function to the Racket VM. Note that
the we only needed to specify the function's C type. The DSL takes care of the needed conversions
and even error checking for us. This is an example of being able to reuse
an existing DSL. But we can do even better still.

This is another DSL we built on top of the FFI specifically for Video. This gives us several nice
object-oriented properties that we wanted when handeling the MLT library. Its entire implementation
is only a couple hundred lines long and was built in a few hours.
|#
(let ()
  (define mlt-factory-init
    (let ()
      (define x (code mlt-factory-init))
      (cc-superimpose
       (colorize (filled-rectangle (+ (pict-width x) 5)
                                   (+ (pict-height x) 5))
                 "yellow")
       x)))
  (define mlt-ffi-code
    (scale
     (parameterize ([code-italic-underscore-enabled #f])
       (code (define-mlt #,mlt-factory-init
               (_fun [p : _path]
                     -> [ret : _mlt-repository/null]
                     -> (maybe-error? ret)))))
    1.2))
  (define mlt-ffi-short-code
    (scale
     (code (define-mlt mlt-factory-init ...)
           (define-mlt mlt-factory-close ...))
     1.2))
  (staged [c r]
          (pslide
           #:go (coord 1/2 0.1 'cc)
           (t "An FFI DSL")
           #:go (coord 0.24 0.33 'cc)
           (colorize (filled-rectangle 350 40) "yellow")
           #:go (coord 1/2 1/2 'cc)
           (scale (codeblock-pict #:keep-lang-line? #f @~a{
#lang scribble/base
mlt_repository
mlt_factory_init(const char *directory);})
                  1.1)
           (blank 100)
           (if (at/after r) mlt-ffi-code (ghost mlt-ffi-code))
           #:go (coord 1 1 'rb)
           (st "(Scheme Wrksp., 2004)")))
  (pslide
   #:go (coord 1/2 0.1 'cc)
   (t "An Object DSL")
   #:go (coord 1/2 1/2 'cc)
   mlt-ffi-short-code
   (blank 100)
   (scale
    (code
     (define-constructor clip video
       ... mlt-factory-init ...
           mlt-factory-close ...))
    1.2)))

#|
Implementing these two DSLs gives us enough to have a small language. But if we want
Video to be a user facing language, we really need to build an ecosystem around it.
|#
(slide
 (mk-video-tower #:render-sp #f
                 #:render-scribble #f
                 #:render-ts #f
                 #:render-tv #f
                 #:render-viddoc #f
                 #:render-top #f))

#|
Namely, we need to document Video.
|#
(slide
 (scale doc-cloud 1.5))

#|
We would ideally like the documentation to look like this. Its formatted nicely on a web page
or PDF file, and it uses a lot of prose with some code examples. There are a lot of
tools out there we can use to do this. Two common ones being markdown and latex. Instead, we chose
to go another route.

This is scribble. Its a DSL created to write prose. Believe it or not, while this looks a lot like
latex, its actually running on the Racket VM. By using Scribble, we were able to create another DSL
on top of it, I call it VidDocLang, that handles video specific primitives.
|#
(let ()
  (define scrib
            (scale (codeblock-pict #:keep-lang-line? #f @~a|{
#lang scribble/manual
#lang video/documentation
@title{Video: The Language}
@(defmodulelang video)

Video Language (or VidLang, sometimes referred
to as just Video) is a DSL for editing...videos.
It aims to merge the capabilities of a traditional}|)
         0.80))
  (staged [d c]
          (pslide
           #:go (coord 1/2 0.01 'ct)
           (st* "A Documentation DSL")
           #:go (coord 1/2 1/2 'cc)
           (vc-append
            60
            (scale (bitmap "res/docs.png") 0.6)
            (if (at/after c) scrib (ghost scrib)))
           #:go (coord 1 1 'rb)
           (st "(ICFP, 2009)"))))

#|
With documentation in place, we have our language. But we were done with that so fast,
why not try to solve one more thing.
|#
(slide
 (mk-video-tower #:render-sp #f
                 #:render-ts #f
                 #:render-tv #f
                 #:render-top #f))

#|
Namely types. Video wasn't intended to have types originally. But, linguistic
inheritance gives us the ability to make a type system quickly. Lets quickly take
a look at what types could even meen in this sort of setting.
|#
(slide
 (scale type-cloud 2))

#|
This is a block of code that creates a 50 second long video.

Now we are putting this code in a context that creates a new video out of
the first 100 seconds of the old one. This is a problem, the original video only
had 50 seconds. So what should we do for the rest of the time? I really don't like
the sound of an undefined video....

So how about we create a type system that forbids this.
|#
(play-n
 #:steps 20
 #:delay 0.025
 (λ (n1 n2)
   (cc-superimpose
    (scale
     (fade-around-pict
      n1
      (code (clip "clip.mp4"
                  #:start 0
                  #:end 50))
      (λ (x)
        (code (cut-producer #,x
                            #:start 0
                            #:end 100))))
     1.5)
    (cellophane the-X n2))))

#|
We created a type system that
|#
(let ()
  (define a (bitmap "res/prod-type.png"))
  (define b (scale (bitmap "res/clip-type.png") 1));0.6))
  (define c (scale (bitmap "res/playlist-type.png") 0.55))
  (define d (scale (bitmap "res/kind-rule.png") 0.6))
  (define c1 (scale (codeblock-pict #:keep-lang-line? #f @~a|{
#lang racket
(define-typed-syntax (clip f) ≫
  [⊢ f ≫ _ ⇐ File] #:where n (length f)
  -------------------------------------
  [⊢ (untyped:clip f) ⇒ (Producer n)])}|)
 1.1))
  (staged [rule]
          (pslide
           #:go (coord 1/2 0.1 'cc)
           (t "A Typed DSL")
           #:go (coord 1/2 1/2 'cc)
           a))
  (staged [example1 code1]
          (pslide
           #:go (coord 1/2 0.1 'cc)
           (if (at example1)
               (t "A Typed DSL")
               (t "A Type Implementation DSL"))
           #:go (coord 1/2 1/2 'cc)
           (if (at/after example1) b (ghost b))
           (blank 100)
           (if (at/after code1) c1 (ghost c1))
           #:go (coord 1 1 'rb)
           (st "(POPL, 2016)"))))

(slide
 (mk-video-tower #:render-sp #f
                 #:render-top #f))

(make-a-dsl-slide "DSL"
                  #:slogan 'syntax-parse
                  #:cite (st "(ICFP, 2010)"))

(slide
 (mk-video-tower #:render-top #f))

(make-a-dsl-slide "Editor"
                  #:slogan 'linguistic-huh)

(slide
 (bitmap "res/vidgui.png"))

(slide
 (scale (bitmap "res/vidgui2.png") 0.8))

(slide
 (lt "Future Work"))

(slide
 (mk-video-tower))

(end-slide)
