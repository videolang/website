#lang frog/config

;; Called early when Frog launches. Use this to set parameters defined
;; in frog/params.
(define/contract (init)
  (-> any)
  (current-scheme/host "http://video.lang")
  (current-uri-prefix "/blog")
  (current-title "Video Blog")
  (current-author "The Video Language Team")
  (current-permalink "/{year}/{month}/{day}/{title}/index.html")
  (current-posts-per-page 10)
  (current-posts-index-uri "/index.html")
  (current-source-dir "_src")
  (current-output-dir "."))

;; Called once per post and non-post page, on the contents.
(define/contract (enhance-body xs)
  (-> (listof xexpr/c) (listof xexpr/c))
  ;; Here we pass the xexprs through a series of functions.
  (~> xs
      (syntax-highlight #:python-executable "python"
                        #:line-numbers? #t
                        #:css-class "source")
      (auto-embed-tweets #:parents? #t)
      (add-racket-doc-links #:code? #t #:prose? #f)))

;; Called from `raco frog --clean`.
(define/contract (clean)
  (-> any)
  (void))
