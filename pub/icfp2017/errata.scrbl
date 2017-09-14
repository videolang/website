#lang reader "../../website.rkt"

@page[#:title "Super 8 Languages for Making Movies Errata"]{
 @div[class: "jumbotron"]{
  @div[class: "container"]{@h1{Errata}}}
 @div[class: "container"]{
  @h2{Super 8 Languages for Making Movies}
  @ul{
   @li{@p{Figure 8 line 3 should read:}
    @blockquote{@samp{(provide (rename-out [#%video-module-begin #%module-begin])}}
    @p{Thanks to Alexander McLin.}}
   @li{@p{"a list of expressions @samp{(e ...)}," in the third paragraph of Section 5.2 should read:}
    @blockquote{"a list of expressions @samp{(expr ...)},"}
    @p{Thanks to Leandro Facchinetti}}}}}
