#lang scribble/html

@(require racket/dict
          scribble/html/lang
          (for-syntax syntax/parse)
          "files.rkt")

@(provide (all-from-out scribble/html/lang)
          page)

@(define (header . v)
   @head{
     @meta[charset: "utf-8"]
     @meta[http-equiv: "X-UA-Compatible" content: "IE=edge"]
     @meta[name: "viewport" 'content: "width=device-width, initial-scale=1"]
     @link[href: "css/bootstrap.min.css" rel: "stylesheet"]
     @link[href: "css/custom.css" rel: "stylesheet"]
     @title[v]{ - Video Language}})

@(define (navbar . current-page)
   @element/not-empty["nav" class: "navbar navbar-inverse"]{
     @div[class: "navbar-inner"]{
       @div[class: "container"]{
         @div[class: "navbar-header"]{
           @button[type: "button"
                   class: "navbar-toggle collapsed"
                   data-toggle: "collapse"
                   data-target: "#navbar"
                   aria-expanded: "false"
                   aria-controls: "navbar"]{
             @span[class: "sr-only"]{Toggle navigation}
             @span[class: "icon-bar"]
             @span[class: "icon-bar"]
             @span[class: "icon-bar"]}
           @a[class: "navbar-brand" href: (dict-ref html-file-table "Home")]{
             @img[src: "logo/small-nav.png" alt: "Video logo" height: "51" width: "75"]}}
         @div[id: "navbar" class: "navbar-collapse collapse"]{
           @ul[class: "nav navbar-nav pull-right"]{
             @(for/list ([title-pair (in-list html-file-table)])
               (if (equal? (car title-pair) (car current-page))
                 @li[role: "presentation" class: "active"]{@a[href: "#" (car title-pair)]}
                 @li[role: "presentation"]{@a[href: (cdr title-pair) (car title-pair)]}))}}}}})

@(define (footer . v)
   (list
    @div[class: "footer-color"]{
    @div[class: "container"]{
      @element/not-empty["footer" class: "footer float:right"]{
        @div[class: "copyright"]{
          @p[style: "float:left"]{Copyright © 2016-2017 Leif Andersen}}
        @div[class: "pull-right"]{
          @img[src: "logo/tiny.png" alt: "Video Logo" height: "25" width: "25"]}}}}
    @script[src: "https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"]
    @script[src: "js/bootstrap.min.js"]))

@(define (page #:title title . content)
   (list @doctype{html}
         @html[lang: "en"]{
           @header{@title}
           @body[id: "pn-top"]{
             @navbar[title]
             @content
             @footer{}}}))

