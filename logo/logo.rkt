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

(define (mk-logo [height 100]
                 #:square? [square? #f]
                 #:glossy? [glossy? #t]
                 #:text? [text? #t]
                 #:parens? [parens? #t])
  (define body-color "green")
  (define front-reel-color halt-icon-color)
  (define back-reel-color syntax-icon-color)
  (define film-ratio-to-body 2/3)
  (define body-height (/ height (+ 1 (/ film-ratio-to-body 2))))
  (define body-width (* body-height 2))
  (define film-ratio (* body-height 4/5))
  (define width body-width)
  (define lens-dim 2/3)
  (define font
    (let ()
      (define attempts (list "Linux Libertine Display"
                             "Linux Libertine Display O"))
      (define intersect (set-intersect (get-face-list) attempts))
      (when (set-empty? intersect)
        (error 'mk-logo "No fount ~s installed, currently installed: ~s" attempts (get-face-list)))
      (set-first intersect)))
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
    (disk film-ratio
          #:color back-reel-color
          #:border-color (icon-color->outline-color back-reel-color)))
  (define front-reel
    (disk film-ratio
          #:color front-reel-color
          #:border-color (icon-color->outline-color front-reel-color)))
  
  (define glossy-body
    (bitmap-render-icon (pict->bitmap camera-body)
                        10
                        metal-icon-material
                        #;plastic-icon-material))
  
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
    (send dc draw-bitmap body 0 (/ film-ratio 2))
    logo)

  (define plain-logo
    (if glossy?
        (assemble-parts glossy-body glossy-back-reel glossy-front-reel width height)
        (assemble-parts
         (pict->bitmap camera-body) (pict->bitmap back-reel) (pict->bitmap front-reel) width height)))
  
  (define pre-paren-image
    (hc-append
     (scale (text "(" font 1) (* 3/4 height))
     (scale (text "(" font 1) (* 2/4 height))
     (scale (text "(" font 1) (* 1/4 height))
     (ghost (scale (text "(" font 1) (* 1/4 height)))))
  (define post-paren-image
    (hc-append
     (ghost (scale (text ")" "Helvetica" 1) (* 1/4 height)))
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
       (* body-height 0.25)
       (shadow
        (scale (text "λ" font 1) (* body-height 10/9))
        (/ body-height 10) (/ body-height 50)
        #:color (make-object color% 255 255 255 0.75)
        #:shadow-color "black"))
      (if parens? post-paren-image (blank)))))
  (define logo
    (if text?
        lambda-logo
        plain-logo))
  (cond [square?
         (define size (max (send logo get-width) (send logo get-height)))
         (define logo* (make-object bitmap% (ceiling size) (ceiling size) #f #t))
         (define dc (make-object bitmap-dc% logo*))
         (send dc draw-bitmap logo 0 (/ (- size height) 2))
         logo*]
        [else logo]))

(define logo
  (resource
   "logo.png"
   (λ (p)
     (send (mk-logo 100 #:parens? #f) save-file p 'png 75))))

(define big-logo
  (resource
   "wlogo.png"
   (λ (p)
     (send (mk-logo 200) save-file p 'png 75))))

