;; Copyright 2006-2012 Alexander I. Grafov,Daniel L. Gregoire, Ameen Ross, Kristian Nygaard Jensen

;; This file is part of drupal-emacs.

;; drupal-emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; drupal-emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with drupal-emacs.  If not, see <http://www.gnu.org/licenses/>.
;;;###autoload
(define-derived-mode drupal-mode php-mode "Drupal"
  "Major mode for DRUPAL coding.\n\n\\{drupal-mode-map}"
  (setq tab-width 2)
  (c-set-offset 'arglist-intro '+) ; for FAPI arrays and DBTNG
  (c-set-offset 'arglist-close '0)
  (setq c-basic-offset 2)
  (setq x-stretch-cursor t)
  (setq indent-tabs-mode nil)
  (setq fill-column 78)
  (setq show-trailing-whitespace t)
  (global-set-key (kbd "<f5>") "grep -n -R --exclude-dir=.svn --exclude=*~ --exclude=#* --exclude=TAGS --exclude=*emconf* -i -e bootstrap . 2>")
  (global-set-key (kbd "<f6>") "$this->")
  (global-set-key (kbd "<f7>") "DIRECTORY_SEPARATOR")
  (global-set-key (kbd "<f12>") 'imenu-add-menubar-index)
  (global-set-key (kbd "<f8>") "__METHOD__.__FILE__.__LINE__")
  (add-hook 'after-save-hook 'compile-tags)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (if (fboundp 'c-subword-mode)
      (c-subword-mode t))
  (run-mode-hooks 'drupal-mode-hook))

(provide 'drupal-mode)

(defun compile-tags-action (project-root-dir, current-dir)
  "compile etags for the current project"
  (cd project-root-dir)
  (start-file-process-shell-command "shell" nil "rm TAGS;find -L .  -name \"*.php\" -o -name \"*.inc\" -o -name \"*.module\"|xargs ctags -ea --language-force=PHP")
  (cd current-dir))

(defun compile-tags ()
  "compile etags for the current project"
  (interactive)
  (if (boundp 'project-root-dir)
    (compile-tags-action project-root-dir (file-name-directory  buffer-file-name))))
