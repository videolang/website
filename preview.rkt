#!/usr/bin/env racket
#lang racket

(require web-server/servlet-env
         web-server/dispatchers/dispatch
         racket/runtime-path
         "logo/logo.rkt")

(parameterize ([current-default-backing-height 200])
  (dynamic-require "make.rkt" #f))

(define-runtime-path here ".")

(serve/servlet (lambda (_) (next-dispatcher))
               #:servlet-path "/index.html"
               #:extra-files-paths (list here)
               #:port (integer-bytes->integer #"VD" #f)
               #:listen-ip #f
               #:launch-browser? #t)
