;;; punctuality-logger.el --- Punctuality logger for Emacs

;; Copyright (C) 2014 Philip Woods

;; Author: Philip Woods <elzairthesorcerer@gmail.com>
;; Version: 0.1
;; Keywords: reminder, calendar
;; URL: https://gitlab.com/elzair/punctuality-logger

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package helps you keep track of when you are on time
;; and when you are late to your various appointments.

;;; Code:

(defvar punctuality-logger-log-dir
  (concat (file-name-as-directory (getenv "HOME")) "punctuality-log")
  "Directory where punctuality-logger information is kept.")

(defun punctuality-logger-current-date ()
    "Evaluate to current date in YYYY-MM-DD format."
  (format-time-string "%Y-%m-%d"))

(defun punctuality-logger-log-name ()
  "Evaluate to the name of the log for the current day."
  (concat (file-name-as-directory punctuality-logger-log-dir)
          (punctuality-logger-current-date)
          ".tl"))

(defun punctuality-logger-log-template (latep &optional minutes-late)
  "Create template for tardiness log entry.

LATEP is whether or not you were late.

MINUTES-LATE is how many minutes you were late."
  (cons `(latep ,latep)
        (if (and (bound-and-true-p latep) (boundp 'minutes-late))
            (list `(minutes-late ,minutes-late))
          nil)))

(defun punctuality-logger-ensure-log-dir-exists ()
    "Ensure the directory to store log files has been created."
  (make-directory punctuality-logger-log-dir t))

(defun punctuality-logger-write-string-to-file (string file)
    "Write the string STRING to file FILE."
  (with-temp-buffer
    (insert string)
    (when (file-writable-p file)
      (write-region (point-min)
                    (point-max)
                    file))))

(defun punctuality-logger-write-log (latep &optional minutes-late)
    "Create a new log entry for the current day.

LATEP is whether or not you were late.

MINUTES-LATE is how many minutes you were late."
  (punctuality-logger-ensure-log-dir-exists)
  (punctuality-logger-write-string-to-file
   (pp-to-string (punctuality-logger-log-template latep minutes-late))
   (punctuality-logger-log-name)))

(defun punctuality-logger-new-log ()
    "Create a new log entry for the current day."
    (interactive)
    (if (y-or-n-p "Were you late today?")
      (let ((minutes-late (read-from-minibuffer "By how many minutes?" )))
        (punctuality-logger-write-log t (string-to-number minutes-late)))
      (punctuality-logger-write-log nil)))

;; Add menu item in Tools menu
(define-key global-map
  [menu-bar tools new-punctuality-log]
  '("New Punctuality Log" . punctuality-logger-new-log))

(provide 'punctuality-logger)
;;; punctuality-logger.el ends here
