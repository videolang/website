#lang slideshow

(provide (except-out (all-defined-out)
                     the-video
                     the-logo
                     the-logo-video))
(require racket/gui/base
         (prefix-in video: video/base)
         video/player
         slideshow/repl
         racket/runtime-path
         "utils.rkt")

(define WIDTH 640) ;854)
(define HEIGHT 360) ;480)

(define-runtime-path h ".")
(define background '(color "black" #:properties (hash "width" 1920
                                                      "height" 1080)))
(define video `(clip ,(build-path h "res" "demo.mp4")))
(define camera `(clip ,(build-path h "res" "demo.mp4")))
(define logo `(clip ,(build-path h "res" "racket-logo.png")))
(define logoed-video
  `(playlist (cut-producer ,logo #:start 0 #:end 5)
             (fade-transition 1)
             ,video))
(define full-video
  `(playlist (cut-producer ,logo #:start 0 #:end 5)
             (fade-transition 1)
             (multitrack ,background
                         (overlay-merge 50 50 300 200)
                         ,logo
                         (overlay-merge 500 0 1280 720)
                         ,camera
                         (overlay-merge 0 500 960 540)
                         ,video)))

(define (live-demo video layout modtext
                   #:split-location [split-loc 1/2])
  (define ns (make-gui-namespace))
  (parameterize ([current-namespace ns])
    (namespace-require 'video/player)
    (namespace-require 'video/base))
  (define repl-group (make-repl-group))
  (define backing (make-module-backing repl-group modtext))
  (define repl-width (* client-w (if (eq? layout 'horizontal) (- 1 split-loc) 1) 5/6))
  (define repl-height (* client-h (if (eq? layout 'horizontal) 1 (- 1 split-loc)) 0.4))
  (define module-width (* client-w (if (eq? layout 'horizontal) split-loc 1) 5/6))
  (define module-height (* client-h (if (eq? layout 'horizontal) 1 split-loc) 0.4))
  (slide
   ((if (eq? layout 'horizontal) hc-append vc-append)
    (module-area backing
                 #:font-size 30
                 #:width module-width
                 #:height module-height)
    (repl-area #:make-namespace (λ () ns)
               #:width repl-width
               #:height repl-height))
   (interactive (blank WIDTH HEIGHT)
                (λ (frame)
                  (parameterize ([current-namespace ns])
                    (eval `(define-values (frame) ,frame))
                    (eval `(define-values (vps) (new video-player-server% [video ,video])))
                    (eval `(define-syntax-rule (play . ignore)
                             (send vps play)))
                    (eval `(define-syntax-rule (start . ignore)
                             (send vps play)))
                    (eval `(define-syntax-rule (stop . ignore)
                             (send vps stop)))
                    (eval `(define-values (screen)
                             (new video-canvas%
                                  [parent frame]
                                  [width (send frame get-width)]
                                  [height (send frame get-height)])))
                    (eval '(send vps set-canvas screen))
                    (eval '(send vps render-audio #f))
                    (eval '(struct producer ()))
                    (eval '(define vid (producer)))
                    (eval '(define vid1 (producer)))
                    (eval '(define vid2 (producer)))
                    (eval '(define vid3 producer))
                    (eval '(define v producer))
                    (eval '(define v1 producer))
                    (eval '(define v2 producer))
                    (eval '(define v3 producer))
                    (eval '(define-syntax-rule (define x . rest)
                             (begin
                               (define-values (x) (producer))
                               (void))))
                    (λ ()
                      (thread
                       (λ ()
                         (parameterize ([current-namespace ns])
                           (eval '(send vps stop)))))))))))

#| Uncomment to test just the live demo
(live-demo full-video 3)
(slide (t "test"))
|#

(define (mk-demo video width height)
  (interactive (blank width height)
                (λ (frame)
                  (send frame show #t)
                  (define vps (new video-player-server% [video video]))
                  (define screen (new video-canvas%
                                      [parent frame]
                                      [width (send frame get-width)]
                                      [height (send frame get-height)]))
                  (send vps set-canvas screen)
                  (send vps render-audio #f)
                  (send vps play)
                  (λ ()
                    (thread
                     (λ ()
                       (send vps stop)))
                    (send frame show #f)))))

(define the-video (video:clip (build-path h "res" "demo.mp4")))
(define the-logo (video:clip (build-path h "res" "racket-logo.png")))
(define the-logo-video (video:clip (build-path h "res" "racket-logo.mp4")))

(define producer-demo (mk-demo the-video 200 200))

(define playlist-demo
  (mk-demo
   (video:playlist (video:cut-producer the-video
                                       #:start 0
                                       #:end 5)
                   the-logo)
   400 300))

(define playlist-fade-demo
  (mk-demo
   (video:playlist (video:cut-producer the-video
                                       #:start 0
                                       #:end 5)
                   (video:fade-transition 3)
                   the-logo-video)
   400 300))

(define filter-demo
  (mk-demo
   (video:attach-filter the-video
                        (video:grayscale-filter))
   500 400))

(define multitrack-demo
  (mk-demo
   (video:multitrack the-video
                     (video:overlay-merge 50 50 300 200)
                     the-logo)
   400 300))

(define cloud-demo
  (mk-demo
   (video:multitrack the-video
                     (video:overlay-merge 50 50 300 200)
                     the-logo)
   450 300))

(define sepia-demo
  (mk-demo
   (video:attach-filter the-video
                        (video:sepia-filter))
   500 400))

(define the-base-demo
  (video:multitrack the-video
                    (video:overlay-merge 50 50 300 200)
                    the-logo))

(define func-demo
  (mk-demo
   (video:multitrack (video:color "black" #:properties (hash "width" 700 "height" 500))
                     (video:overlay-merge 0 0 350 250)
                     the-base-demo
                     (video:overlay-merge 350 0 350 250)
                     (video:attach-filter the-base-demo
                                          (video:sepia-filter))
                     (video:overlay-merge 0 250 350 250)
                     (video:attach-filter the-base-demo
                                          (video:grayscale-filter))
                     (video:overlay-merge 350 250 350 250)
                     (video:attach-filter the-base-demo
                                          (video:grayscale-filter)))
   750 500))
  