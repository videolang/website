#lang racket

(provide mk-video-tower
         the-shadow-tower
         mlt-block
         ffmpeg-block)
(require racket/draw
         pict
         pict/shadow
         pict/color
         ppict/pict
         "logo.rkt"
         "block.rkt"
         "utils.rkt")

(define racket-block
  (new block%
       [label "Racket"]
       [shape (λ (w h)
                (filled-rectangle w h #:color (light "red")))]))
(define sp-block
  (new block%
       [label "syntax-parse"]
       [label-scale 0.6]
       [shape (λ (w h)
                (filled-rectangle w h #:color "yellow"))]))

(define ffi-block
  (new block%
       [label "Video FFI"]
       [label-scale 0.3]
       [label-y-offset -0.15]
       [shape (λ (w h)
                (dc (λ (dc dx dy)
                      (define old-brush (send dc get-brush))
                      (send dc set-brush (new brush% [color (light "blue")]))
                      (define path (new dc-path%))
                      (send path move-to 0 0)
                      (send path line-to 0 h)
                      (send path line-to (* w 0.34) h)
                      (send path line-to (* w 0.34) (* h 0.5))
                      (send path line-to w (* h 0.5))
                      (send path line-to w 0)
                      (send path close)
                      (send dc draw-path path dx dy)
                      (send dc set-brush old-brush))
                    w h))]))

(define ts-block
  (new block%
       [label "Turnstile"]
       [label-scale 0.3]
       [label-y-offset -0.15]
       [shape (λ (w h)
                (cc-superimpose
                 (blank w h)
                 (scale
                  (dc (λ (dc dx dy)
                        (define old-brush (send dc get-brush))
                        (send dc set-brush (new brush% [color (light "green")]))
                        (define path (new dc-path%))
                        (send path move-to 0 0)
                        (send path line-to 0 h)
                        (send path line-to (* w 0.34) h)
                        (send path line-to (* w 0.34) (* h 0.5))
                        (send path line-to w (* h 0.5))
                        (send path line-to w 0)
                        (send path close)
                        (send dc draw-path path dx dy)
                        (send dc set-brush old-brush))
                      w h)
                  -1 1)))]))

(define scrib-block
  (new block%
       [label "Scribble"]
       [label-scale 0.5]
       [label-rotation (* pi 1/3)]
       [shape (λ (w h)
                (filled-rectangle w h #:color (light "purple")))]))

(define vid-doc-block
  (new block%
       [label "VidDoc Lang"]
       [label-scale 0.4]
       [label-x-offset 0.05]
       [label-rotation (* pi 1/6)]
       [shape (λ (w h)
                (dc (λ (dc dx dy)
                      (define old-brush (send dc get-brush))
                      (send dc set-brush (new brush% [color "orange"]))
                      (define path (new dc-path%))
                      (send path move-to 0 0)
                      (send path line-to 0 (* h 0.40))
                      (send path line-to (* w 0.2) (* h 0.40))
                      (send path line-to (* w 0.2) h)
                      (send path line-to (* w 0.9) h)
                      (send path line-to (* w 0.9) (* h 0.75))
                      (send path line-to w (* h 0.75))
                      (send path line-to w 0)
                      (send path close)
                      (send dc draw-path path dx dy)
                      (send dc set-brush old-brush))
                    w h))]))

(define video-block
  (new block%
       [label "Video"]
       [label-scale 0.5]
       [shape (λ (w h)
                (filled-rectangle w h #:color "tan"))]))

(define typed-video-block
  (new block%
       [label "Typed Video"]
       [label-scale 0.4]
       [label-x-offset -0.05]
       [label-rotation (* pi -1/6)]
       [shape (λ (w h)
                (cc-superimpose
                 (blank w h)
                 (scale
                  (dc (λ (dc dx dy)
                        (define old-brush (send dc get-brush))
                        (send dc set-brush (new brush% [color "pink"]))
                        (define path (new dc-path%))
                        (send path move-to 0 0)
                        (send path line-to 0 (* h 0.40))
                        (send path line-to (* w 0.2) (* h 0.40))
                        (send path line-to (* w 0.2) h)
                        (send path line-to (* w 0.9) h)
                        (send path line-to (* w 0.9) (* h 0.75))
                        (send path line-to w (* h 0.75))
                        (send path line-to w 0)
                        (send path close)
                        (send dc draw-path path dx dy)
                        (send dc set-brush old-brush))
                      w h)
                  -1 1)))]))

(define tc (make-parameter "gray"))

(define top
  (new block%
       [label ""]
       [shape (λ (w h)
                (filled-rectangle w h #:color (tc)))]))

(define flag
  (new block%
       [label ""]
       [shape (λ (w h)
                (define fw (* w 0.9))
                (define fh (* h 0.2))
                (define the-flag
                  (dc (λ (dc dx dy)
                        (define old-brush (send dc get-brush))
                        (send dc set-brush (new brush% [color (light "gray")]))
                        (define path (new dc-path%))
                        (send path move-to 0 0)
                        (send path line-to 0 fh)
                        (send path line-to fw (/ fh 2))
                        (send path close)
                        (send dc draw-path path (* dx 0.253) dy)
                        (send dc set-brush old-brush))
                      fw fh))
                (ppict-do (blank w h)
                          #:go (coord 0 1/2 'lc)
                          (filled-rounded-rectangle (* w 0.1) h -0.75
                                                    #:color "brown")
                          #:go (coord (* w 0.1) 1/6 'lc)
                          the-flag
                          #:go (coord 0.4 0.17 'cc)
                          (scale-to-fit the-logo (* 0.25 w) (* 0.25 h))))]))

(define (render-proc should-render? pict)
  (if should-render?
      pict
      (ghost pict)))

(define ffmpeg-block (new block%
                          [label "FFmpeg"]
                          [shape (λ (w h)
                                   (vl-append
                                    (* h -1/3)
                                    (hc-append
                                     (blank (* w 0.05))
                                     (cloud (* w 2/3) h "forest green" #:style '(square wide)))
                                    (cloud w h "forest green" #:style '(square wide))))]))
(define mlt-block (new block%
                       [label "MLT"]
                       [shape (λ (w h)
                                (vr-append
                                 (* h -1/3)
                                 (hc-append
                                  (cloud (* w 2/3) h "green" #:style '(square wide))
                                  (blank (* w 0.05)))
                                 (cloud w h "green" #:style '(square wide))))]))

(define (video-tower #:render-racket [rr #t]
                     #:render-ffmpeg [rfm #t]
                     #:render-mlt [rml #t]
                     #:render-sp [rsp #t]
                     #:render-ffi [rffi #t]
                     #:render-video [rv #t]
                     #:render-ts [rts #t]
                     #:render-tv [rtv #t]
                     #:render-scribble [rs #t]
                     #:render-viddoc [rvd #t]
                     #:render-top [rt #t])
  (define the-tower
    (vc-append
     (render-proc rt
                  (cb-superimpose
                   (send flag draw 100 200)
                   (hc-append
                    50
                    (parameterize ([tc "orange"])
                      (send top draw 50 50))
                    (parameterize ([tc "orange"])
                      (send top draw 50 50))
                    (parameterize ([tc "orange"])
                      (send top draw 50 50))
                    (parameterize ([tc "tan"])
                      (send top draw 50 50))
                    (parameterize ([tc "tan"])
                      (send top draw 50 50))
                    (parameterize ([tc "pink"])
                      (send top draw 50 50))
                    (parameterize ([tc "pink"])
                      (send top draw 50 50))
                    (parameterize ([tc "pink"])
                      (send top draw 50 50)))))
     (cc-superimpose
      (render-proc rv (send video-block draw 200 200))
      (hc-append
       140
       (render-proc rvd (send vid-doc-block draw 300 200))
       (render-proc rtv (send typed-video-block draw 300 200))))
     (vc-append
      (vc-append
       -150
       (hc-append
        (render-proc rs (send scrib-block draw 200 300))
        (hc-append (render-proc rffi (send ffi-block draw 200 300))
                   (render-proc rts (send ts-block draw 200 300))))
       (hc-append
        (blank 70)
        (render-proc rsp (send sp-block draw 400 150))))
      (render-proc rr (send racket-block draw 600 125)))))
  (cc-superimpose
   (hb-append
    -125
    (render-proc rml (send mlt-block draw 375 150))
    (ghost the-tower)
    (render-proc rfm (send ffmpeg-block draw 375 150)))
   (bitmap (pict->bitmap the-tower))))

(define the-shadow-tower
  (blur
   (bitmap
    (pict->bitmap (video-tower)
                  #:make-bitmap make-monochrome-bitmap))
   10))

(define the-shadow-tower/no-bushes
  (blur
   (bitmap
    (pict->bitmap (video-tower #:render-ffmpeg #f
                               #:render-mlt #f)
                  #:make-bitmap make-monochrome-bitmap))
   10))

(define (mk-video-tower #:render-ffmpeg [rfm #t]
                        #:render-mlt [rml #t]
                        #:render-racket [rr #t]
                        #:render-sp [rsp #t]
                        #:render-ffi [rffi #t]
                        #:render-video [rv #t]
                        #:render-ts [rts #t]
                        #:render-tv [rtv #t]
                        #:render-scribble [rs #t]
                        #:render-viddoc [rvd #t]
                        #:render-top [rt #t])
  (define the-bushes
    (video-tower #:render-ffmpeg rfm
                 #:render-mlt rml))
  (define the-tower
    (video-tower #:render-ffmpeg #f
                 #:render-mlt #f
                 #:render-racket rr
                 #:render-sp rsp
                 #:render-ffi rffi
                 #:render-video rv
                 #:render-ts rts
                 #:render-tv rtv
                 #:render-scribble rs
                 #:render-viddoc rvd
                 #:render-top rt))
  (define shadowed-tower
    (cc-superimpose
     the-bushes
     the-shadow-tower/no-bushes
     (bitmap (pict->bitmap the-tower))))
  (scale shadowed-tower 0.75))
