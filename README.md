[![MELPA](http://melpa.org/packages/punctuality-logger-badge.svg)](http://melpa.org/#/punctuality-logger)
punctuality-logger
==================

A simple punctuality logger for Emacs.

Install
-------

Get **punctuality-logger** from [MELPA](http://melpa.org).

To set-up MELPA, add the following code to `~/.emacs.d/init.el`.

```elisp
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
```

Now, start Emacs and press `M-x package-install [RET] punctuality-logger`.

Use
---

Currently, **punctuality-logger** supports three interactive functions.

* **punctuality-logger-new-entry** asks you if you were late today and, if so, how many minutes you were late. It then creates a new log entry with your input.

* **punctuality-logger-late-days** lists in a new buffer the days you were late.

* **punctuality-logger-all-days** lists in a new buffer all the days in the log.

These functions are also available from the top-menu *Tools->Punctuality Logger*.
