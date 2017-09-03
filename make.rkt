#!/usr/bin/env racket
#lang racket

(require racket/cmdline
         compiler/find-exe
         racket/runtime-path
         scribble/html/resource
         "files.rkt")

(define-runtime-path project-root-dir ".")

(define git (find-executable-path "git"))

(define video-src "https://github.com/videolang/video.git")

(define (build #:render-resources? [rr #t]
               #:render-blog? [rb #t])
  ;; Render HTML files
  (for ([f (in-list files)])
    (unless (equal? (path-get-extension f) #".html")
      (with-output-to-file (path-replace-suffix f ".html")
        #:exists 'replace
        (lambda ()
          (dynamic-require f 0)))))
  ;; Render image resources
  (when rr
    (parameterize ([current-directory project-root-dir])
      (render-all)))
  ;; Render blog
  (when rb
    (parameterize ([current-directory (build-path project-root-dir "blog")])
      (system* (find-exe) "-l" "raco" "pkg" "install" "--auto" "--skip-installed" "frog")
      (system* (find-exe) "-l" "raco" "frog" "-b")))
  ;; Render current manual
  ;(define tmp-dir (make-temporary-file "rkttmp~a" 'directory))
  #;(parameterize ([current-directory tmp-dir])
    (system* git "clone" video-src "video")
    (parameterize ([current-directory (build-path "video")])
      (system* (find-exe) "-l" "raco" "pkg" "install" "--auto" "--skip-installed"))
    (parameterize ([current-directory (build-path "video" "video" "scribblings")])
      (system* (find-exe) "-l" "raco" "scribble" "--htmls"
               "+m" "--redirect-main" "http://docs.racket-lang.org/" "video.scrbl")
      (copy-directory/files "video" (build-path project-root-dir "manl")))))

(define render-resources? #t)
(define render-blog? #t)
(define preview? #f)

(void
 (command-line
  #:program "Video Website Builder"
  #:once-each
  [("--disable-resources") "Do not compile resources for the website"
                           (set! render-resources? #f)]
  [("--disable-blog") "Do notcompile the blog"
                      (set! render-blog? #f)]
  [("-p" "--enable-preview" "--preview") "Preview the generated webpage"
                                         (set! preview? #t)]))

(build #:render-resources? render-resources?
       #:render-blog? render-blog?)

(when preview?
  (define serve/servlet (dynamic-require 'web-server/servlet-env 'serve/servlet))
  (define next-dispatcher (dynamic-require 'web-server/dispatchers/dispatch 'next-dispatcher))
  (serve/servlet (lambda (_) (next-dispatcher))
                 #:servlet-path "/index.html"
                 #:extra-files-paths (list project-root-dir)
                 #:port (integer-bytes->integer #"VD" #f)
                 #:listen-ip #f
                 #:launch-browser? #t))
  