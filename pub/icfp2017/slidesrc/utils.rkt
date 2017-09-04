#lang racket

(provide (all-defined-out))
(require racket/draw
         pict)

(define font
  (let ()
    (define attempts (list "Linux Libertine Display"
                           "Linux Libertine Display O"))
    (define intersect (set-intersect (get-face-list) attempts))
    (when (set-empty? intersect)
      (error 'mk-logo "No fount ~s installed, currently installed: ~s" attempts (get-face-list)))
    (set-first attempts)))

(define scribbly-font
  (let ()
    (define attempts (list "Permanent Marker"))
    (define intersect (set-intersect (get-face-list) attempts))
    (when (set-empty? intersect)
      (error 'mk-logo "No fount ~s installed, currently installed: ~s" attempts (get-face-list)))
    (set-first attempts)))

(define (st str)
  (text str font 30))

(define (st* str)
  (text str font 40))

(define (t str)
  (text str font 50))

(define (mst str)
  (text str font 80))

(define (t* str)
  (text str font 60))

(define (t*.5 str)
  (text str font 65))

(define (t** str)
  (text str font 70))

(define (mt str)
  (text str font 100))

(define (mlt str)
  (text str font 130))

(define (lt str)
  (text str font 150))

(define (vlt str)
  (text str font 200))
