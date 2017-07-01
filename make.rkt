#!/usr/bin/env racket
#lang racket

(require compiler/find-exe
         racket/runtime-path
         scribble/html/resource
         "files.rkt")

(define-runtime-path project-root-dir ".")

(define (build)
  (for ([f (in-list files)])
    (with-output-to-file (path-replace-suffix f ".html")
      #:exists 'replace
      (lambda ()
        (dynamic-require f 0))))
  (parameterize ([current-directory project-root-dir])
    (render-all))
  (parameterize ([current-directory (build-path project-root-dir "blog")])
    (system* (find-exe) "-l" "raco" "frog" "-b")))

(build)
