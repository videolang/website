#lang at-exp slideshow

(provide (all-defined-out))
(require with-cache
         images/icons/misc
         images/icons/symbol
         images/icons/stickman
         slideshow/code
         ppict/pict
         ppict/slideshow2
         pict
         pict/face
         pict/color
         pict/flash
         pict/balloon
         slideshow/staged-slide
         racket/draw
         "block.rkt"
         "logo.rkt"
         "utils.rkt"
         "tower.rkt")

(define script-clock
  (bitmap (stopwatch-icon
           0 8 #:height 100)))

(define nlve-clock
  (bitmap (stopwatch-icon
           0 27 #:height 100)))

(define clocks
  (with-cache (cachefile "the-clocks.rktd")
    (λ ()
      (for/list ([hour (in-range 12)])
        (for/list ([minute (in-range 6)])
          (printf "~a:~a~n" hour minute)
          (bitmap (stopwatch-icon
                   hour (* 10 minute) #:height 200)))))))

(define clock-list
  (append* clocks))

(define clock-wall-list
  (with-cache (cachefile "the-clock-wall.rktd")
    (λ ()
      (for/list ([clock (in-list clock-list)])
        (bitmap
         (pict->bitmap
          (vc-append
           (hc-append clock clock clock clock clock)
           (hc-append clock clock clock clock clock)
           (hc-append clock clock clock clock clock))))))))

(define the-lambda
  (with-cache (cachefile "the-lambda-icon.rktd")
    (λ ()
      (bitmap (lambda-icon #:color "blue"
                           #:height 200)))))

(define the-check
  (with-cache (cachefile "the-check-icon.rktd")
    (λ ()
      (bitmap (check-icon #:height 300)))))
(define the-X
  (with-cache (cachefile "the-X-icon.rktd")
    (λ ()
      (bitmap (x-icon #:height 300)))))

(define the-?
  (with-cache (cachefile "the-?-icon.rktd")
    (λ ()
      (bitmap (text-icon "?"
                         #:height 300
                         #:color "yellow")))))

(define the-^
  (ppict-do (blank 70 90)
            #:go (coord 1/2 1/2 'cc)
            (rotate (colorize (text " V " scribbly-font 60) "red")
                    (* pi 1/12))))

(define the-stickman
  (with-cache (cachefile "the-stickman-icon.rktd")
    (λ ()
      (bitmap (standing-stickman-icon #:height 200
                                      #:backing-scale 8)))))

(define the-microphone
  (clip
   (ppict-do (blank 150 150)
             #:go (coord 1/2 0.6 'cc)
             (filled-rounded-rectangle 10 100
                                       #:color "black")
             #:go (coord 0.58 0.1 'ct)
             (rotate (filled-rounded-rectangle #:color "gray" 40 20 -0.4)
                     (/ pi 4)))))

(define the-magnifying-glass
  (with-cache (cachefile "the-mag-icon.rktd")
    (λ ()
      (bitmap (magnifying-glass-icon #:height 200)))))

(define elided
  (hc-append
   (disk 5)
   (blank 5)
   (disk 5)
   (blank 5)
   (disk 5)
   (blank 5)
   (text "elided" font 32)
   (blank 5)
   (disk 5)
   (blank 5)
   (disk 5)
   (blank 5)
   (disk 5)))

(define the-scaled-nlve
  (freeze (scale-to-fit (bitmap "nlve-demo.png") 1000 1000)))

(define the-small-scaled-nlve
  (freeze (scale-to-fit (bitmap "nlve-demo.png") 800 800)))

(define ffi-cloud
  (cc-superimpose
   (rotate (cloud 250 250 "lightpink") (* pi 1/6))
   (text "FFI" font 64)))
(define doc-cloud
  (cc-superimpose
   (scale (rotate (cloud 250 250 "LightSalmon") (* pi 5/3)) 2 1)
   (text "Documentation" font 64)))
(define type-cloud
  (cc-superimpose
   (rotate (cloud 250 250 "NavajoWhite") (* pi -1/2))
   (text "Types" font 64)))

(define (vid-slide)
  (define the-code* (codeblock-pict @~a{
 #lang video
 ;; Append four conference talks
 (for/vertical ([i (in-range 2)])
   (for/horizontal ([j (in-range 2)])
     (external-video "conf-talk.vid"
       (clip "logo.png")
       (clip (format "~aX~a.mp4" i j)))))}))

  (define the-lib* (codeblock-pict @~a{
 #lang video/lib
 ;; Generate a conference talk
 (define-video (conf-talk logo slides)
   logo
   (fade-transition 1)
   (multitrack logo
               (overlay 0 0 100 100)
               slides))}))

  (define the-code
    (bitmap
     (pict->bitmap
      (vr-append
       (cc-superimpose
        (rectangle 200 50 #:border-width 2)
        (st "mosaic.vid"))
       (cc-superimpose
        (rectangle (+ (pict-width the-code*) 50)
                   (+ (pict-height the-code*) 25)
                   #:border-width 2)
        the-code*)))))
  
  (define the-lib
    (bitmap
     (pict->bitmap
      (vr-append
       (cc-superimpose
        (rectangle 200 50 #:border-width 2)
        (st "conf-talk.vid"))
       (cc-superimpose
        (rectangle (+ (pict-width the-code*) 50)
                   (+ (pict-height the-lib*) 25)
                   #:border-width 2)
        (hc-append the-lib*
                   (blank 80)))))))

  (define the-loop (colorize (filled-rectangle (- (pict-width the-code*) 50) 74) "pink"))
  (define the-prim (colorize (filled-rectangle 580 74) "pink"))
  (define the-call (colorize (filled-rectangle (- (pict-width the-code*) 50) 100) "cyan"))
  (define the-lang (colorize (filled-rectangle 278 36) "yellow"))
  (define the-ext (colorize (filled-rectangle 260 36) "yellow"))
  (define the-def (colorize (filled-rectangle 185 36) "yellow"))

  (define comp-balloon (pip-wrap-balloon (t "List Comprehensions")
                                         'nw 0 -200))
  (define prim-balloon (pip-wrap-balloon (t "Primitives")
                                         'ne 0 -150))
  (define call-balloon (pip-wrap-balloon (t "Modules")
                                         'n 0 -200))
  (define func-balloon (pip-wrap-balloon (t "Functions")
                                         'se 0 200))

  (staged [c cp cl cc l lc ll]
          (pslide
           #:go (coord 1/2 0.26 'cc)
           (if (at cl) the-loop (blank 1))
           #:go (coord 0.63 0.33 'cc)
           (if (at lc) the-ext (blank 1))
           #:go (coord 0.48 0.69 'cc)
           (if (at lc) the-def (blank 1))
           #:go (coord 0.5 0.38 'cc)
           (if (or (at cc) (at l)) the-call (blank 1))
           #:go (coord 0.53 0.40 'cc)
           (if (or (at cp) (at cc) (at l)) the-prim (blank 1))
           #:go (coord 0.28 0.14 'cc)
           (if (at ll) the-lang (blank 1))
           #:go (coord 0.28 0.59 'cc)
           (if (at ll) the-lang (blank 1))
           #:go (coord 1/2 1/2 'cc)
           (vl-append
            30
            (scale (if (at/after c) the-code (ghost the-code)) 0.9)
            (scale (if (at/after l) the-lib (ghost the-lib)) 0.9))
           #:go (coord 0.41 0.68 'cc)
           (if (at lc) func-balloon (blank 1))
           #:go (coord 1/4 0.3 'cc)
           (if (at cl) comp-balloon (blank 1))
           #:go (coord 0.5 0.45 'cc)
           (if (at cc) call-balloon (blank 1))
           #:go (coord 3/4 0.45 'cc)
           (if (at cp) prim-balloon (blank 1))
           #:set (let ([p ppict-do-state])
                   (if (at lc)
                       (pin-arrow-line
                        15 p
                        the-ext cb-find
                        the-def ct-find
                        #:line-width 5)
                       p)))))

(define (the-landscape-slide)
  (define no (scale-to-fit (face 'unhappy) 75 75))
  (define no! (scale-to-fit (face 'unhappier) 75 75))
  (define no!!! (scale-to-fit (face 'unhappiest) 75 75))
  (define maybe (scale the-? 0.3))
  (define pexample (st "Blender Script, AE Script"))
  (define mexample (st "Apple Script"))
  (define sexample (st "FFmpeg, AVISynth"))
  (define dexample 
    (bitmap
     (pict->bitmap (scale the-logo 0.08)
                   #:make-bitmap make-monochrome-bitmap)))

  (staged [tab plug mac script]
          (pslide
           #:go (coord 1/2 0.05 'ct)
           (mt "The Landscape")
           #:go (coord 1/2 0.45 'cc)
           (filled-rectangle 950 5)
           #:go (coord 0.33 0.6 'cc)
           (filled-rectangle 5 400)
           #:go (coord 1/2 0.6 'cc)
           (table
            3
            (list (t* "Tool") (t* "Example") (t* "Experience")
                  (t "Plugin-Ins")
                  pexample
                  (if (at/after plug) no (ghost no))

                  (vc-append (t "UI Automation")
                             (st "(Macros)"))
                  mexample
                  (if (at/after mac) no! (ghost no!))

                  (t "Shell Scripts")
                  sexample
                  (if (at/after script) no!!! (ghost no!!!)))
            (list* lc-superimpose cc-superimpose)
            cc-superimpose
            50 25))))

(define make-a-dsl
  (let ()
    (define solve
      (vc-append
       (t "DSLs are the")
       (mst "\"Ultimate Abstraction\"")))
    (ppict-do
     (cc-superimpose
      (colorize (filled-flash 1110 360 10 0.20 (* pi 2 1/100)) "red")
      (colorize (filled-flash 980 310 10 0.25 (* pi 1/100)) "orange")
      (colorize (filled-flash 870 260 10 0.3) "yellow")
      solve)
     #:go (coord 0.95 1 'rb)
     (text "Paul Hudak"
           (cons 'bold font) 40))))

(define tower-of-dsls
  (scale
   (cc-superimpose
    (scale the-shadow-tower 0.5)
    (vc-append
     (blank 130)
     (colorize (mt "Tower") "white")
     (colorize (mt "of DSLs") "white")))
   0.9))

(define the-clouds
  (bitmap
   (pict->bitmap
    (scale (hc-append -170 (blank 60) doc-cloud ffi-cloud (blank 290) type-cloud) 0.3))))

(define (mk-title-slide #:pre-slash [pre-slash #t]
                        #:to-highlight [to-highlight 'bottom])
  (define t1 (hc-append (t "Super 8")
                        (vc-append (colorize (lt ":") "red") (blank 30))
                        (t " Languages for Making Movies")))
  (define t1* (t "A DSL for Scripting Videos"))
  (define t2 (hc-append (t "Super")
                        (vc-append (colorize (lt ",") "red") (blank 40))
                        (t " 8 Languages for Making Movies")))
  (define t2* (t "DSL Towers to Solve Multitudes of Problems"))
  (define line (colorize (filled-rectangle 800 10) "red"))
  (define hline
    (if (eq? to-highlight 'top)
        (colorize (filled-rectangle 600 60) "yellow")
        (colorize (filled-rectangle 900 60) "yellow")))
  (define (mk-slide title2 rt2 rt2h to-highlight)
    (slide
     (vc-append
      80
      (vc-append
       -35
       (cc-superimpose
        t1
        (if rt2 line (ghost line)))
       (cc-superimpose
        (if (and rt2h (eq? to-highlight 'top)) hline (ghost hline))
        (if rt2 t1* (ghost t1*))))
      (vc-append
       -35
       (cc-superimpose
        t2
        (if rt2 line (ghost line)))
       (cc-superimpose
        (if (and rt2h (eq? to-highlight 'bottom)) hline (ghost hline))
        (if rt2 t2* (ghost t2*)))))))
  (if pre-slash
      (staged [title2 rt2 rt2h]
              (mk-slide (at/after title2)
                        (at/after rt2)
                        (at/after rt2h)
                        to-highlight))
      (staged [rt2 rt2h]
              (mk-slide #f
                        (at/after rt2)
                        (at/after rt2h)
                        to-highlight))))

(define linguistic-inheritance
  (vc-append
   (hc-append (st "We make ")
              (colorize (st "DSLs") (dark "gold"))
              (st " using"))
   (colorize (t* "Linguistic Inheritance") "maroon")))

(define (mk-tower-slide [type 'mk-tower])
  (define base
    (send (new block%
               [label "Racket"]
               [shape (λ (w h)
                        (filled-rectangle w h #:color (light "red")))])
          draw 350 100))
  (define impl
    (send (new block%
               [label "Video Implementation"]
               [label-scale 0.75]
               [shape (λ (w h)
                        (filled-rectangle w h #:color "tan"))])
          draw 350 100))
  (define user
    (send (new block%
               [label "Movie Script"]
               [shape (λ (w h)
                        (cloud w h (dark "lavenderblush")))])
          draw 350 100))
  (define re-feature
    (balloon-pict
     (wrap-balloon (t* "Re-export construct")
                   'e 100 0)))
  (define new-feature
    (balloon-pict
     (wrap-balloon (t* "New construct")
                   'e 100 0)))
  (define rm-feature
    (balloon-pict
     (wrap-balloon (t* "Remove construct")
                   'e 100 0)))
  (define change-feature
    (balloon-pict
     (wrap-balloon (t* "Change construct")
                   'e 100 0)))
  (define (mk-slide inh us pass blk new chng)
    (define at/after values)
          (pslide
           #:go (coord 0.05 0.05 'lt)
           (if (at/after inh) linguistic-inheritance (ghost linguistic-inheritance))
           #:go (coord 4/5 1/2 'cc)
          (ppict-do (blank 400 700)
                    #:go (coord 1/2 0 'ct)
                    (if (at/after us) user (ghost user))
                    #:go (coord 1/2 1/2 'cc)
                    (if (at/after us) impl (ghost impl))
                    #:go (coord 1/2 1 'cb)
                    (if (at/after us) base (ghost base))
                    #:set (let ([p ppict-do-state])
                            (if (at/after pass)
                                (pin-arrow-line
                                 20 p
                                 base (λ (a b)
                                        (let-values ([(x y) (lt-find a b)])
                                          (values (+ x 50) y)))
                                 user (λ (a b)
                                        (let-values ([(x y) (lb-find a b)])
                                          (values (+ x 50) (- y 50))))
                                 #:start-angle (* pi 1/2)
                                 #:end-angle (* pi 1/2)
                                 #:line-width 8)
                                p))
                    #:set (let ([p ppict-do-state])
                            (if (at/after blk)
                                (pin-arrow-line
                                 20 p
                                 base (λ (a b)
                                        (let-values ([(x y) (ct-find a b)])
                                          (values (- x 25) y)))
                                 impl (λ (a b)
                                        (let-values ([(x y) (cb-find a b)])
                                          (values (- x 25) (- y 50))))
                                 #:start-angle (* pi 1/2)
                                 #:end-angle (* pi 1/2)
                                 #:line-width 8)
                                p))
                    #:set (let ([p ppict-do-state])
                            (if (at/after new)
                                (pin-arrow-line
                                 20 p
                                 impl (λ (a b)
                                        (let-values ([(x y) (ct-find a b)])
                                          (values (+ x 25) y)))
                                 user (λ (a b)
                                        (let-values ([(x y) (cb-find a b)])
                                          (values (+ x 25) (- y 50))))
                                 #:start-angle (* pi 1/2)
                                 #:end-angle (* pi 1/2)
                                 #:line-width 8)
                                p))
                    #:set (let ([p ppict-do-state])
                            (if (at/after chng)
                                (pin-arrow-line
                                 20 p
                                 base (λ (a b)
                                        (let-values ([(x y) (rt-find a b)])
                                          (values (- x 50) y)))
                                 impl (λ (a b)
                                        (let-values ([(x y) (rb-find a b)])
                                          (values (- x 50) (- y 40))))
                                 #:start-angle (* pi 1/2)
                                 #:end-angle (* pi 1/2)
                                 #:line-width 8)
                                p))
                    #:set (let ([p ppict-do-state])
                            (if (at/after chng)
                                (pin-arrow-line
                                 20 p
                                 impl (λ (a b)
                                        (let-values ([(x y) (rt-find a b)])
                                          (values (- x 50) (+ y 40))))
                                 user (λ (a b)
                                        (let-values ([(x y) (rb-find a b)])
                                          (values (- x 50) (- y 50))))
                                 #:start-angle (* pi 1/2)
                                 #:end-angle (* pi 1/2)
                                 #:style 'dot
                                 #:line-width 8)
                                p)))
           #:go (coord 0.03 0.2 'lc)
           (if (at/after pass) re-feature (ghost re-feature))
           #:go (coord 0.18 0.6 'lc)
           (if (at/after blk) rm-feature (ghost rm-feature))
           #:go (coord 0.31 0.4 'lc)
           (if (at/after new) new-feature (ghost new-feature))
           #:go (coord 0.34 0.8 'lc)
           (cc-superimpose
            ;(if (at/after hchng) (colorize (filled-rectangle 500 200) "yellow") (blank))
            (if (at/after chng) change-feature (ghost change-feature)))))
  (match type
    [_
     (staged [inh us pass blk new chng]
             (mk-slide (at/after inh)
                       (at/after us)
                       (at/after pass)
                       (at/after blk)
                       (at/after new)
                       (at/after chng)))
     (slide
      (scale change-feature 1.3))]))

(define (end-slide)
  (pslide
   #:go (coord 1/2 0.05 'ct)
   (t "Thanks For Watching")
   #:go (coord 1/4 3/5)
   (vc-append
    (scale (tt "http://lang.video") 1)
    (scale (tt "@videolang") 1)
    (blank 30) 
    (scale the-logo 0.3))
   #:go (coord 3/4 3/5)
   (vc-append
    (scale linguistic-inheritance 0.9)
    (blank 10)
    (scale (mk-video-tower) 0.4))))

(define syntax-parse-dsl
  (vc-append
   (mst "syntax-parse")
   (t* "A DSL for making DSLs")))
