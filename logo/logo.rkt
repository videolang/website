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
         pict/color
         racket/gui/base
         racket/math
         images/icons/style
         mrlib/switchable-button
         racket/list
         scribble/html/resource
         pict
         pict/shadow)

(define (mk-logo height
                 #:square-pict? [square-pict? #f]
                 #:text? [text? #f])
  (define green (make-object color% #x55 #xd9 #x21))
  (define blue (make-object color% #x02 #x7e #xee))
  (define red (make-object color% #xf5 #x25 #x00)); #xe0 #x22 #x00))
  (define width (* height 2))
  (define film-ratio (/ height 3))
  (define film-offset (/ width 15))
  (define body-height (+ height film-ratio))
  (define lens-dim 2/3)
  (define camera (make-object bitmap% width height #f #t))

  (let ()
    (define dc (make-object bitmap-dc% camera))
    (send dc set-pen (new pen% [width 0] [color (icon-color->outline-color green)]))
    (send dc set-brush (new brush% [color green]))
    
    (define path (new dc-path%))
    (send path move-to 0             0)
    (send path line-to 0             height)
    (send path line-to (* width lens-dim) height)
    (send path line-to (* width lens-dim) (* height 3/4))
    (send path line-to width         (* height 9/10))
    (send path line-to width         (* height 1/10))
    (send path line-to (* width lens-dim) (* height 1/4))
    (send path line-to (* width lens-dim) 0)
    (send path line-to 0             0)
    (send dc draw-path path))
  
  (define camera-body (make-object bitmap% width (ceiling body-height) #f #t))
  
  (let ()
    (define dc (make-object bitmap-dc% camera-body))
    (send dc set-brush (new brush% [color red]))
    (send dc draw-arc (* 4 film-offset) 0 (* 2 film-ratio) (* 2 film-ratio) 0 pi)
    (send dc set-brush (new brush% [color blue]))
    (send dc draw-arc film-offset 0 (* 2 film-ratio) (* 2 film-ratio) 0 pi)
    (send dc set-brush (new brush% [color red]))
    (send dc draw-arc (* 4 film-offset) 0 (* 2 film-ratio) (* 2 film-ratio) 0 pi)
    (send dc draw-bitmap camera 0 film-ratio))
  
  (define plain-logo (make-object bitmap% width width #f #t))
  (let ()
    (define dc (make-object bitmap-dc% plain-logo))
    (send dc draw-bitmap camera-body 0 (/ (- width body-height) 2))
    (void))
  
  (define logo-picture
    (values #;bitmap-render-icon (if square-pict?
                            plain-logo
                            camera-body)))
  
  (define worded-logo
    (pict->bitmap
     (cc-superimpose
      (bitmap logo-picture)
      (inset
       (shadow 
        (text "λ" "Helvetica" (exact-round (* height 1.1)))
        0 0 ;(/ height 10) (/ height 50)
        #:color (make-object color% 255 255 255 0.5)
        #:shadow-color (make-object color% 230 255 255))
       0 (* height 0.55) (* height 0.7) 0))))
  (if text?
      worded-logo
      logo-picture))

(define logo
  (resource
   "logo.png"
   (λ (p)
     (send (mk-logo 100) save-file p 'png 75))))

(define word-logo
  (resource
   "wlogo.png"
   (λ (p)
     (send (mk-logo 200 #:text? #t) save-file p 'png 75))))

#;
(define big-logo
  (resource
   "blogo.png"
   (λ (p)
     (send (mk-logo 1000 #:text? #t) save-file p 'png 100))))
