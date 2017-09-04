#lang racket

(provide (all-defined-out))
(require racket/draw
         pict
         ppict)

(define (skirt width height
               #:color [color "royalblue"])
  (scale-to-fit
   #:mode 'distort
   (dc (λ (dc dx dy)
         (define old-pen (send dc get-pen))
         (send dc set-pen
               (new pen% [width 1] [color "black"]))
         (define old-brush (send dc get-brush))
         (send dc set-brush
               (new brush% [color color]))
         (define path (new dc-path%))
         (send path move-to 50 0)
         (send path curve-to 20 0 20 0 0 100)
         (send path line-to 100 100)
         (send path curve-to 80 0 80 0 50 0)
         (send path close)
         (send dc draw-path path dx dy)
         (send dc set-brush old-brush)
         (send dc set-pen old-pen))
       100 100)
   width height))

(define person%
  (class object%
    (super-new)
    [init-field [height 100]
                [hair-type 'long]
                [hair-color "brown"]
                [skin-color "Burlywood"]
                [top-color "DeepPink"]
                [bottom-color "RoyalBlue"]
                [shoe-color "black"]
                [outfit 'skirt]]

    (define/public (draw)
      (define hair (filled-ellipse height (* height 0.8) #:color hair-color))
      (define hair-bottom (filled-rectangle (* height 0.8) height #:color hair-color))
      (define head (disk height #:color skin-color))
      (define top-body (filled-rounded-rectangle (* height 1.2) (* height 2.3) -0.5
                                                 #:color top-color))
      (define arm (filled-rounded-rectangle (* height 0.4) (* height 1.4) -0.45
                                            #:color skin-color))
      (define hand (disk (* height 0.5)
                         #:color skin-color))
      (define left-arm-full
        (clip
         (ppict-do (blank (* height 2))
                   #:go (coord 1/2 1/2 'cc)
                   arm
                   #:go (coord 0.48 0.8 'cc)
                   hand)))
      (define right-arm-full
        (scale left-arm-full -1 1))
      (define left-leg
        (filled-rounded-rectangle (* height 0.6) (* height 1.8)
                                  #:color (match outfit
                                            ['pants bottom-color]
                                            [_ skin-color])))
      (define left-foot
        (filled-rounded-rectangle (* height 0.9) (* height 0.3) -0.4
                                  #:color shoe-color))
      (define left-leg-full
        (clip
         (ppict-do (blank (* height 2))
                   #:go (coord 1/2 1/2 'cc)
                   left-leg
                   #:go (coord 0.4 0.9 'cc)
                   left-foot)))
      (define right-leg-full
        (scale  left-leg-full -1 1))
      (define bottom-body (match outfit
                            ['skirt
                             (skirt (* height 1.9) (* height 1.5)
                                    #:color bottom-color)]
                            [_ (blank)]))
      (clip
       (ppict-do (blank (* height 5))
                 #:go (coord 1/2 0.14 'cc)
                 (if (eq? hair-type 'long)
                     hair-bottom
                     (blank 1))
                 #:go (coord 1/2 0.43 'cc)
                 top-body
                 #:go (coord 1/2 0.08 'cc)
                 hair
                 #:go (coord 1/2 0.12 'cc)
                 head
                 #:go (coord 0.45 0.10 'cc)
                 (disk 10 #:color "black")
                 #:go (coord 0.55 0.10 'cc)
                 (disk 10 #:color "black")
                 #:go (coord 0.4 0.8 'cc)
                 left-leg-full
                 #:go (coord 0.6 0.8 'cc)
                 right-leg-full
                 #:go (coord 1/2 0.6 'cc)
                 bottom-body
                 #:go (coord 0.35 0.43 'cc)
                 left-arm-full
                 #:go (coord 0.65 0.43 'cc)
                 right-arm-full)))))

;(define leif (new person%))
;(send leif draw)
