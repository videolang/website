    Title: Making an IDE Plugin for DrRacket
    Date: 2018-03-21T12:52:03
    Tags: racket, drracket, tutorial
    Authors: Leif Andersen

I recently had several students ask me to show them how to make DrRacket plugins for their new language. It is easy to do, but I noticed that there aren any existing guides on how to do it. There is [the plugin documentation][PluginDocs], which is a good reference and has some good examples. Unfortunately, it lacks a good step by step tutorial on how to make new IDE plugins. This post is that tutorial.

DrRacket plugins fall into one of two main categories:

1. Language-Specific Plugins
2. Global Plugins

The former only enables the plugin when the user is editing a file in that plugin's associated language. The latter, however, is for plugins that should always be enabled, such as [DrRacket's Vim Mode][vimmode]. This tutorial covers both plugin styles.

<!-- more -->

## Language-Specific Plugins

Before you can create a language-specific plugin for DrRacket, you first need a language that Racket can recognize. There are plenty of good resources to learn how to make languages with Racket. I recommend reading [Languages as Dotfiles][LanguagesDotfiles], which is a simple step by step tutorial. Other good resources are [Matthew Butterick's Beautiful Racket][BeautifulRacket] and [the Racket documentation][SynModReader].

### Making a DSL

For this tutorial we will assume a language called `clippy`, the happy-helping language. The language will be identical to `racket/base`, except that it puts a button in DrRacket's toolbar that displays "Howdy!" when clicked. Let's start out with the following program for our language:

```racket
#lang racket/base ;; clippy/main.rkt
(provide (all-from-out racket/base))
(module* reader syntax/module-reader
  clippy
  #:read read
  #:read-syntax read-syntax)
```

This file re-exports `racket/base`, and also sets the reader to use `read` and `read-syntax`. This file assumes that it has been installed, so make sure at some point to run:

```
$ cd clippy/
$ raco pkg install
```

Now you can open DrRacket and start a file with `#lang clippy` and DrRacket will behave as if you told it to use `racket/base` for its language.

### Adding Language-Specific Plugins

Along with `read` and `read-syntax`, the `reader` submodule optionally provide an info function for tools surrounding your DSL. This info function includes everything from how syntax should be colored to even changing the entire behavior of the IDE. Language info functions are given a key, and responds with a value based on a pre-determined set of rules. DrRacket also gives default values to this function to handle different keys. The Racket documentation contains a [list of every possible symbol DrRacket will use][LanguageCustom].

For this tutorial, we only care about one possible key: [`drracket:toolbar-buttons`][ToolbarButton]. This key tells DrRacket to add new buttons when editing a specific language. DrRacket expects this key to contain a list for each button, which in tern is represented as a list with an element for:

* the button's name,
* the button's image,
* the callback when the button is pressed, and
* the button's priority in the toolbar.

For simplicity, let's define our list in its own file:

```racket
#lang racket/gui ;; clippy/button.rkt

(provide clippy-button)
(require pict)

(define clippy-button
  (list "Clippy"
        (pict->bitmap (disk 16))
        (λ (frame)
          (message-box "Clippy" "Howdy!"))
        #f))
```

Now we are ready to create our `make-info` function, and place it in the `reader` submodule:

```racket
(define (make-info key default use-default)
  (case key
    [(drracket:toolbar-buttons)
     (list (dynamic-require 'clippy/button 'clippy-button))]
    [else (use-default key default)]))
```

Note the use of `dynamic-require` rather than a static `require` statement. The `clippy-button` list requires the `pict` library to draw a circle. However, the `clippy` language proper does not have that dependency. By using a dynamic-require, we only load the `pict` library for DrRacket.[^lazy]

Putting everything together gives:

```racket
#lang racket/base ;; clippy/main.rkt
(provide (all-from-out racket/base))
(module* reader syntax/module-reader
  clippy
  #:read read
  #:read-syntax read-syntax
  #:info make-info
  
  (define (make-info key default use-default)
  (case key
    [(drracket:toolbar-buttons)
     (list (dynamic-require 'clippy/button 'clippy-button))]
    [else (use-default key default)])))
```

Restart DrRake, and create a file that begins with `#lang clippy`. A new button should appear near the run button.

## Global Plugins

Global DrRacket plugins require the IDE to have meta-information about installed languages. Racket collections can optionally use an [`info.rkt`][info] file to store meta information for the package, e.g., its name, version, dependancies, etc. In this case, we will use our `info.rkt` file to inform DrRacket that `tool.rkt` provides a DrRacket plugin. We will also give it the name `"Clippy"`, and add no icons:

```racket
#lang info ;; clippy/info.rkt
(define collection "clippy")

(define drracket-tools '(("tool.rkt")))
(define drracket-tool-names '("Clippy"))
(define drracket-tool-icons '(#f))
```

DrRacket expects its plugin file to export a single identifier `tool@`, which is a [unit][units][^unit], that satisfies the `drracket:tool-exports^` signature. We could build and provide this unit from any file, or we could use the `racket/unit` DSL. This DSL implicitly puts the body of the module[^unitreq] in a unit, and provides that unit as the file name. Using `racket/unit`, we will make a file that looks like:


```racket
#lang racket/unit ;; clippy/tool.rkt

(require drracket/tool
         ... other require forms ...)

(import drracket:tool^)
(export drracket:tool-exports^)

(define (phase1) (void))
(define (phase2) (void))
```

Let's break this file down piece by piece. First, the top-level require:

```racket
#lang racket/unit ;; clippy/tool.rkt

(require drracket/tool
         ... other require forms ...)
```

Files written in `racket/unit` are implicitly wrapped in the body of a unit. However, `require` statements must be at the module level. Therefore, the `racket/unit` language allows for one require form at the top of the file to bring in everything. In this case we are bringing in `drracket/tool`. We bring in this library for the next two lines:

```racket
(import drracket:tool^)
(export drracket:tool-exports^)
```

Units, unlike Racket modules, can have circular dependancies. Consequently, they use their own `import`/`export` system that is distinct from the traditional `require`/`provide` system. Here, we are giving our unit access to the `drracket:tool^` signature, and specifying that our unit satisfies the `drracket:tool-exports^` signature. This signature requires us to provide two functions:

```racket
(define (phase1) (void))
(define (phase2) (void))
```

Both of these functions are called at different points during DrRacket's startup. Our plugin, however, does not need to set up any special state during these phases. Therefore, we define both functions to do nothing and return `#<void>`. 

One thing we do want our plugin to do is add a new menu option for clippy:

```racket
(drracket:get/extend:extend-unit-frame clippy-frame-mixin)
```

Where we define `clippy-frame-mixin` as:[^reqs]

```racket
(define clippy-frame-mixin
  (mixin (drracket:unit:frame<%>) ()
    (super-new)
    (inherit get-insert-menu)
    (new menu-item%
         [parent (get-insert-menu)]
         [label "Paperclip Help"]
         [callback
          (λ (i e)
            (message-box "Clippy" "Howdy!"))])))
```

This mixin adds a clippy button to the insert menu, and when selected, a new message box pops up for clippy to say "Need any help?".

Putting the whole file together gives us:


```racket
#lang racket/unit ;; clippy/tool.rkt

(require drracket/tool
         racket/class
         racket/gui/base)

(import drracket:tool^)
(export drracket:tool-exports^)

(define (phase1) (void))
(define (phase2) (void))

(define clippy-frame-mixin
  (mixin (drracket:unit:frame<%>) ()
    (super-new)
    (inherit get-insert-menu)
    (new menu-item%
         [parent (get-insert-menu)]
         [label "Paperclip Help"]
         [callback
          (λ (i e)
            (message-box "Clippy" "Need any help?"))])))

(drracket:get/extend:extend-unit-frame clippy-frame-mixin)
```

As before, remember to restart DrRacket. When you do, there will now be a new menu option in the insert menu. When you press it, a helpful dialog box appears.

# Closing Remarks

This post shows you how to make plugins for the DrRacket IDE. Both language-specific plugins, as well as global plugins. You can find the project that the samples in this blog are based on in [the video source code][vidsrc]. You can also look at a [3rd party plugin framework for DrRacket][ScrPlugin], which lets you play with plugins without needing to restart DrRacket.

[^lazy]: Note that we could have used `lazy-require`to do the same thing.
[^unit]: In Racket, units are similar to modules, but can have circular dependancies.
[^unitreq]: Except for one top-level require statement.
[^reqs]: Note that to make this mixin, the tool also must require `racket/class` and `racket/gui/base`.

[PluginDocs]: https://docs.racket-lang.org/tools/index.html
[ScrPlugin]: https://docs.racket-lang.org/quickscript/index.html
[vimmode]: https://github.com/takikawa/drracket-vim-tool
[BeautifulRacket]: https://beautifulracket.com/#tutorials
[LanguagesDotfiles]: http://blog.racket-lang.org/2017/03/languages-as-dotfiles.html
[SynModReader]: https://docs.racket-lang.org/guide/syntax_module-reader.html
[LanguageCustom]: https://docs.racket-lang.org/tools/lang-languages-customization.html
[ToolbarButton]: http://docs.racket-lang.org/tools/lang-languages-customization.html?q=drracket%3Atoolbar-buttons#%28idx._%28gentag._18._%28lib._scribblings%2Ftools%2Ftools..scrbl%29%29%29
[info]: http://docs.racket-lang.org/raco/info_rkt.html?q=info
[units]: http://docs.racket-lang.org/guide/units.html?q=units#%28tech._unit%29
[vidsrc]: https://github.com/videolang/video/tree/v0.2-beta.1/video
