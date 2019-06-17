#lang racket/base

#|
   Copyright 2016-2017 Leif Andersen

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
|#

(provide (all-defined-out))
(require racket/class
         racket/draw
         racket/path
         racket/gui/base
         racket/math
         racket/set
         images/icons/style
         mrlib/switchable-button
         racket/list
         scribble/html/resource
         pict
         pict/color
         pict/shadow)

(define current-default-backing-height (make-parameter 2000))

(define (mk-reel diam color theta)
  (define circ
    (disk diam))
  (define alpha-circ
    (disk (* diam 1/6)
          #:color "white"))
  (define mask
    (make-object bitmap% (ceiling diam) (ceiling diam) #t))
  (define mask-dc
    (new bitmap-dc% [bitmap mask]))
  (send mask-dc draw-bitmap (pict->bitmap circ) 0 0)
  (define (add-hole r theta)
    (define mid (* 1/2 diam))
    (define hole-mid (* 1/2 (pict-width alpha-circ)))
    (define x (+ (* r (cos theta)) mid (- hole-mid)))
    (define y (+ (* r (sin theta)) mid (- hole-mid)))
    (send mask-dc draw-bitmap (pict->bitmap alpha-circ) x y))
  (define hole-rad (* diam 3/10))
  (add-hole hole-rad 0)
  (add-hole hole-rad (* pi 1/3))
  (add-hole hole-rad (* pi 2/3))
  (add-hole hole-rad (* pi 3/3))
  (add-hole hole-rad (* pi 4/3))
  (add-hole hole-rad (* pi 5/3))
  (define reel
    (dc (λ (dc dx dy)
          (send dc draw-bitmap
                (pict->bitmap (disk diam
                                    #:color color
                                    #:border-color (icon-color->outline-color color)))
                0
                0
                'solid
                (send the-color-database find-color "black")
                mask))
        diam diam))
  (define rotated-reel (rotate reel theta))
  (inset/clip rotated-reel
              (* 1/2 (- diam (pict-height rotated-reel)))
              (* 1/2 (- diam (pict-width rotated-reel)))))

(define base-font
  (let ()
    (define attempts (list "Linux Libertine Display"
                           "Linux Libertine Display O"))
    (define intersect (set-intersect (get-face-list) attempts))
    (when (set-empty? intersect)
      (error 'mk-logo "No fount ~s installed, currently installed: ~s" attempts (get-face-list)))
    (set-first intersect)))

(define (mk-logo [out-height 100]
                 #:square? [square? #f]
                 #:glossy? [glossy? #t]
                 #:text? [text? #t]
                 #:paren-color [paren-color #f]
                 #:λ-color [λ-color #f]
                 #:parens? [parens? #t]
                 #:backing-height [height (current-default-backing-height)])
  (define scale-ratio (/ out-height height))
  (define body-color "green")
  (define front-reel-color halt-icon-color)
  (define back-reel-color syntax-icon-color)
  (define film-ratio-to-body 4/5)
  (define body-height (/ height (+ 1 (* film-ratio-to-body 3/5))))
  (define body-width (* body-height 2))
  (define film-ratio (* body-height 4/5))
  (define width body-width)
  (define lens-dim 2/3)
  (define paren-color*
    (cond [(string? paren-color) (make-object color% paren-color)]
          [else paren-color]))
  (define λ-color*
    (cond [(string? λ-color) (make-object color% λ-color)]
          [else λ-color]))
  (define λ-font
    (cond
      [λ-color (cons λ-color* base-font)]
      [glossy? base-font]
      [else (cons (make-object color% "white") base-font)]))
  (define font
    (if paren-color
        (cons paren-color* base-font)
        base-font))
  (define plain-logo
    (let ()
      (define camera-body
        (dc (λ (dc dx dy)
              (define old-brush (send dc get-brush))
              (define old-pen (send dc get-pen))
              (send dc set-pen (new pen% [width 0] [color (icon-color->outline-color body-color)]))
              (send dc set-brush (new brush% [color (dark body-color)]))
              (define path (new dc-path%))
              (send path move-to 0                       0)
              (send path line-to 0                       body-height)
              (send path line-to (* body-width lens-dim) body-height)
              (send path line-to (* body-width lens-dim) (* body-height 3/4))
              (send path line-to body-width              (* body-height 9/10))
              (send path line-to body-width              (* body-height 1/10))
              (send path line-to (* body-width lens-dim) (* body-height 1/4))
              (send path line-to (* body-width lens-dim) 0)
              (send path line-to 0                       0)
              (send dc draw-path path)
              (send dc set-brush old-brush)
              (send dc set-pen old-pen))
            width height))
      (define back-reel
        (mk-reel film-ratio back-reel-color (* pi 15/40)))
      (define front-reel
        (mk-reel film-ratio front-reel-color (* pi 9/20)))

      (define oversized-glossy-body
        (rotate
         (bitmap (bitmap-render-icon (pict->bitmap (rotate camera-body (* pi 1/15)))
                                     10
                                     metal-icon-material
                                     #;plastic-icon-material))
         (* pi -1/15)))
      (define glossy-body
        (pict->bitmap
         (inset/clip oversized-glossy-body
                     (* 1/2 (- body-width (pict-width oversized-glossy-body)))
                     (* 1/2 (- height (pict-height oversized-glossy-body))))))
      (define glossy-back-reel
        (bitmap-render-icon (pict->bitmap back-reel)
                            10
                            metal-icon-material
                            #;plastic-icon-material))
      (define glossy-front-reel
        (bitmap-render-icon (pict->bitmap front-reel)
                            10
                            metal-icon-material
                            #;plastic-icon-material))
  
      (define (assemble-parts body back-reel front-reel width height)
        (define logo (make-object bitmap% (ceiling width) (ceiling height) #f #t))
        (define front-film-offset (* width 0.02))
        (define back-film-offset (/ width 4))
        (define dc (make-object bitmap-dc% logo))
        (send dc draw-bitmap back-reel front-film-offset 0)
        (send dc draw-bitmap front-reel back-film-offset 0)
        (send dc draw-bitmap body 0 (* film-ratio 3/5))
        logo)

      (if glossy?
          (assemble-parts glossy-body glossy-back-reel glossy-front-reel width height)
          (assemble-parts
           (pict->bitmap camera-body) (pict->bitmap back-reel) (pict->bitmap front-reel) width height))))

  (define pre-paren-image
    (hc-append
     (scale (text "(" font 1) (* 3/4 height))
     (scale (text "(" font 1) (* 2/4 height))
     (scale (text "(" font 1) (* 1/4 height))
     (ghost (scale (text "(" font 1) (* 1/4 height)))))
  (define post-paren-image
    (hc-append
     (ghost (scale (text ")" font 1) (* 1/4 height)))
     (scale (text ")" font 1) (* 1/4 height))
     (scale (text ")" font 1) (* 2/4 height))
     (scale (text ")" font 1) (* 3/4 height))))

  (define lambda-logo
    (pict->bitmap
     (hb-append
      (if parens? pre-paren-image (blank))
      (pin-over
       (bitmap plain-logo)
       (* body-height 0.4)
       (* body-height 0.4)
       (if glossy?
           (shadow
            (scale (text "λ" λ-font 1) (* body-height 10/9))
            (/ body-height 10) (/ body-height 50)
            #:color (make-object color% 255 255 255 0.75)
            #:shadow-color "black")
           (scale (text "λ" λ-font 1) (* body-height 10/9))))
      (if parens? post-paren-image (blank)))))
  (define logo
    (if text?
        lambda-logo
        plain-logo))
  (define padded-logo
    (cond [square?
           (define size (max (send logo get-width) (send logo get-height)))
           (define logo* (make-object bitmap% (ceiling size) (ceiling size) #f #t))
           (define dc (make-object bitmap-dc% logo*))
           (send dc draw-bitmap logo 0 (/ (- size height) 2))
           logo*]
          [else logo]))
  (pict->bitmap (scale (freeze (bitmap padded-logo)) scale-ratio)))


#|
(require racket/pretty)
(for ([i (in-range 20)])
  (define backing-height (+ 500 (* 100 i)))
  (displayln backing-height)
  (pretty-write (time (mk-logo 100 #:backing-height backing-height)))
  (newline))
|#

;(mk-logo 250 #:parens? #f)
;(mk-logo 1000 #:parens? #f)
;(mk-logo 5000 #:parens? #f)
;(mk-logo 1000 #:parens? #f #:glossy? #f)

(define logo
  (resource
   "logo.png"
   (λ (p)
     (send (mk-logo 100 #:parens? #f) save-file p 'png 75))))

(define big-logo
  (resource
   "wlogo.png"
   (λ (p)
     (send (mk-logo 200 #:parens? #t) save-file p 'png 75))))

(define red-reel
  (cc-superimpose
   (mk-reel 400 "red" (* pi 1/6))
   (text "λ" base-font 256)))
(define gold-reel
  (cc-superimpose
   (mk-reel 400 "gold" (* pi 1/6))
   (text "λ" base-font 256)))
(define silver-reel
  (cc-superimpose
   (mk-reel 400 "silver" (* pi 1/6))
   (text "λ" base-font 256)))
