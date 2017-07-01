#lang racket

(provide html-navbar-file-table
         files)

(require racket/runtime-path
         (for-syntax racket))

(module files-mod racket
  (provide file-table)
  (define file-table
    '(
      ("Home"              . "index.scrbl")
      ("Download"          . "download.scrbl")
      ("Documentation"     . "documentation.scrbl")
      ("Community"         . "community.scrbl")
      )))
(require 'files-mod
         (for-syntax 'files-mod))

(define-runtime-path-list files
  (list* "blog/_src/page-template.scrb2"
         (dict-values file-table)))

(define html-navbar-file-table
  (for/list ([f (in-list (dict-keys file-table))]
             [v (in-list (dict-values file-table))])
    (cons f (path-replace-suffix v ".html"))))
