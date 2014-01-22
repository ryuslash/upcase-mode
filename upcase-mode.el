;;; upcase-mode.el --- Upcase all input              -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Tom Willemse

;; Author: Tom Willemse <tom@ryuslash.org>
;; Keywords: convenience
;; Version: 0.1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; The main entry point for this module, `upcase-transient-mode',
;; temporarily enables a keymap that causes all input to be made
;; upper-case.  This map stays active as long as the result of
;; `upcase' applied to the input is different from the input itself,
;; or if there is a value in `upcase-character-map' for the input.

;;; Code:

(defvar upcase-transient-map
  (let ((map (make-sparse-keymap)))
    (define-key map [remap self-insert-command] #'upcase-self-insert-command)
    map)
  "The transient keymap that will take effect.")

(defvar upcase-character-map
  #s(hash-table data (?- ?_))
  "Extra characters to switch.")

(defun upcase-self-insert-command ()
  "Wrap `self-insert-command' to upcase the input character.

This also translates keys from the variable
`upcase-character-map' to values from the same variable."
  (interactive)
  (let ((last-command-event
         (gethash last-command-event upcase-character-map
                  (upcase last-command-event))))
    (self-insert-command 1)))

(defun upcase-able-p ()
  "Check to see if the current input can be upcased.

Upcased can mean either the result of `upcase' being different
from the original or having a value in `upcase-character-map'."
  (let ((case-fold-search nil))
    (or (not (char-equal
              last-command-event (capitalize last-command-event)))
        (gethash last-command-event upcase-character-map))))

;;;###autoload
(defun upcase-transient-mode ()
  "Set a transient map that upcases any input.

This map stays active as long as the input can be upcased."
  (interactive)
  (set-transient-map upcase-transient-map #'upcase-able-p))

(provide 'upcase-mode)
;;; upcase-mode.el ends here
