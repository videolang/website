#lang racket

(require "make.rkt"
         web-server/servlet-env
         web-server/dispatchers/dispatch
         racket/runtime-path)

(define-runtime-path here ".")

(serve/servlet (lambda (_) (next-dispatcher))
               #:servlet-path "/index.html"
               #:extra-files-paths (list here)
               #:port (integer-bytes->integer #"VD" #f)
               #:listen-ip #f
               #:launch-browser? #t)
