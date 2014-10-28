;;; punctuality-logger --- Punctuality logger for Emacs
;;; Commentary:
;;; This package helps you keep track of when you are on time
;;; and when you are late to your various appointments.
;;; Code:

(defvar punctuality-logger-log-dir
  (concat (file-name-as-directory (getenv "HOME")) "tardiness-log")
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
   (prin1-to-string (punctuality-logger-log-template latep minutes-late))
   (punctuality-logger-log-name)))

(defun punctuality-logger-new-log ()
    "Create a new log entry for the current day."
    (interactive)
    (if (y-or-n-p "Were you late today?")
      (let ((minutes-late (read-from-minibuffer "By how many minutes?" )))
        (punctuality-logger-write-log t (string-to-number minutes-late)))
      (punctuality-logger-write-log nil)))

(provide 'punctuality-logger)
;;; punctuality-logger.el ends here
