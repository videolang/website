#!/usr/bin/env racket
#lang racket

(require compiler/find-exe
         racket/runtime-path
         scribble/html/resource
         "files.rkt")

(define-runtime-path project-root-dir ".")

(define git (find-executable-path "git"))

(define video-src "https://github.com/videolang/video.git")

(define (build)
  ;; Render HTML files
  (for ([f (in-list files)])
    (unless (equal? (path-get-extension f) #".html")
      (with-output-to-file (path-replace-suffix f ".html")
        #:exists 'replace
        (lambda ()
          (dynamic-require f 0)))))
  ;; Render image resources
  (parameterize ([current-directory project-root-dir])
    (render-all))
  ;; Render blog
  (parameterize ([current-directory (build-path project-root-dir "blog")])
    (system* (find-exe) "-l" "raco" "pkg" "install" "--auto" "--skip-installed" "frog")
    (system* (find-exe) "-l" "raco" "frog" "-b"))
  ;; Render current manual
  ;;(define tmp-dir (make-temporary-file "rkttmp~a" 'directory))
  #;(parameterize ([current-directory tmp-dir])
    (system* git "clone" video-src "video")
    (parameterize ([current-directory (build-path "video")])
      (system* (find-exe) "-l" "raco" "pkg" "install" "--auto" "--skip-installed"))
    (parameterize ([current-directory (build-path "video" "video" "scribblings")])
      (system* (find-exe) "-l" "raco" "scribble" "--htmls"
               "+m" "--redirect-main" "http://docs.racket-lang.org/" "video.scrbl")
      (copy-directory/files "video" (build-path project-root-dir "manl")))))

(build)
