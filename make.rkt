#!/usr/bin/env racket
#lang racket

(require compiler/find-exe
         racket/runtime-path
         frog
         "files.rkt")

(define-runtime-path project-root-dir ".")

(define (build)
  (for ([f (in-list files)])
    (with-output-to-file (path-replace-suffix f ".html")
      #:exists 'replace
      (lambda ()
        (dynamic-require f 0)))))

(build)
