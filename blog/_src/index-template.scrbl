#lang reader "../../website.rkt"

@(require racket/format)

@element['article]{
 @element['header]{
  @h2{@a[href: "@|uri-path|"]{@"@"|title|}}
  @p[class: "date-and-tags"]{@"@"|date| :: @"@"|tags|}}
 @"@"|content-only|
 @"@"(when more?
       @"@"list{@element['footer]{
 @a[href: @~a{@"@"|uri-path|}]{&hellip; more &hellip;}}})}
