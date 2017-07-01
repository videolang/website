#lang s-exp syntax/module-reader

#:read scribble:read-inside
#:read-syntax scribble:read-syntax-inside
#:whole-body-readers? #t
#:info        (scribble-base-reader-info)
#:language (build-path this-dir "templates.rkt")

(require (prefix-in scribble: scribble/reader)
         (only-in scribble/base/reader scribble-base-reader-info)
         (only-in racket/runtime-path define-runtime-path)
         (for-syntax (only-in racket/base #%datum)))

(define-runtime-path this-dir ".")
