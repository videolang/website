#lang scribble/html

@(require scribble/html/lang
          (for-syntax syntax/parse))

@(provide (all-from-out scribble/html/lang)
          page)

@(define (header . v)
   @head{
     @title[v]{ - Video Language}})

@(define(footer)
   (list))

@(define (page #:title title . content)
   (list @doctype{html}
         @html[lang: "en"]{
           @header{@title}
           @body{@content}
           @footer{}}))

