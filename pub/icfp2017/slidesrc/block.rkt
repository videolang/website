#lang racket

(provide (all-defined-out))
(require racket/draw
         pict
         ppict/pict
         racket/class
         "utils.rkt")

(define block%
  (class object%
    (super-new)
    (init-field label
                [label-scale 1]
                [label-rotation 0]
                [label-x-offset 0]
                [label-y-offset 0])
    (init [(i-shape shape) #f])
    (define shape (or i-shape (λ (w h) (rounded-rectangle w h -0.05))))
    (define/public (draw w h)
      (define sh (shape w h))
      (ppict-do sh
                #:go (coord (+ (* w label-x-offset 1/200) 1/2) (+ (* h label-y-offset 1/200) 1/2) 'cc)
                (rotate (text label font (exact-round (* label-scale (exact-floor (* h 1/2))))) label-rotation)))))

(define ((draw-colored-rect color) w h)
  (filled-rounded-rectangle w h -0.05 #:color color))
