(setq gc-cons-threshold (* 100 1024 1024)
      gc-cons-percentage 0.6)

(require 'server)
(unless (server-running-p)
  (server-start))

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))

(setq-default load-prefer-newer t

package-enable-at-startup nil)

(package-initialize)

(unless (and (package-installed-p 'use-package)
             (package-installed-p 'delight))
  (package-refresh-contents)
  (package-install 'use-package t)
  (package-install 'delight t))

(eval-when-compile
  (require 'use-package)
  (require 'delight))

(setq use-package-always-ensure t

;; use-package-check-before-init t

;; use-package-always-defer t
)

(setq byte-compile--use-old-handlers nil)

(use-package which-key
  :demand t
  :commands (which-key-mode)
  :config
  (progn
    (which-key-mode)
    (setq which-key-sort-order 'which-key-key-order-alpha
          which-key-sort-uppercase-first nil
          which-key-prefix-prefix nil
          which-key-idle-delay 0.3)))

(use-package general
  :demand t
  :commands (general-define-key general-evil-setup)
  :config
  (progn
    (general-evil-setup)))

(general-create-definer leader-keys
                        :states '(emacs normal visual motion insert)
                        :prefix "SPC"
                        :non-normal-prefix "M-m")

(general-create-definer major-mode-leader-keys
                        :states '(emacs normal visual motion insert)
                        :prefix "'"
                        :non-normal-prefix "SPC-m")

(general-nmap "/" 'swiper)

(defun my--switch-buffer (&optional window)
  (interactive)
  (let ((current-buffer (window-buffer window))
        (buffer-predicate
         (frame-parameter (window-frame window) 'buffer-predicate)))
    ;; switch to first buffer previously shown in this window that matches
    ;; frame-parameter `buffer-predicate'
    (switch-to-buffer
     (or (cl-find-if (lambda (buffer)
                       (and (not (eq buffer current-buffer))
                            (or (null buffer-predicate)
                                (funcall buffer-predicate buffer))))
                     (mapcar #'car (window-prev-buffers window)))
         ;; `other-buffer' honors `buffer-predicate' so no need to filter
         (other-buffer current-buffer t)))))

(use-package evil
  :commands (evil-mode)
  :init (setq evil-want-integration nil)
  :config (evil-mode t))

(use-package evil-collection
  :after evil
  :commands (evil-collection-init)
  :config (evil-collection-init))

(use-package evil-escape
  :after evil
  :commands (evil-escape-mode)
  :delight evil-escape-mode
  :init (evil-escape-mode 1)
  :config
  (progn
    (setq-default evil-escape-key-sequence "jk")))

(use-package evil-surround
  :after evil
  :commands (global-evil-surround-mode)
  :init (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :commands (evil-commentary-mode)
  :delight evil-commentary-mode
  :init (evil-commentary-mode))

(use-package evil-goggles
  :after evil
  :commands (evil-goggles-mode evil-goggles-use-diff-faces)
  :config
  (progn
    (evil-goggles-mode)
    (evil-goggles-use-diff-faces)))

(use-package evil-matchit
  :commands (global-evil-matchit-mode)
  :config (global-evil-matchit-mode t))

(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system                   'utf-8)
(set-terminal-coding-system             'utf-8)
(set-keyboard-coding-system             'utf-8)
(set-selection-coding-system            'utf-8)
(setq locale-coding-system              'utf-8)
(setq-default buffer-file-coding-system 'utf-8)

(fset 'yes-or-no-p 'y-or-n-p)

(delete-selection-mode t)

(setq custom-file (expand-file-name (concat user-emacs-directory "custom.el")))

(load custom-file t t)

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(defun display-startup-echo-area-message ())

(setq visible-bell nil
      ring-bell-function #'ignore)

(use-package autorevert
  :ensure nil
  :commands (global-auto-revert-mode)
  :init
  (progn
    (setq auto-revert-verbose nil
          global-auto-revert-non-file-buffers t)
    (global-auto-revert-mode)))

(add-hook 'prog-mode-hook #'electric-pair-mode)

(use-package paren
  :ensure nil
  :commands (show-paren-mode)
  :init (show-paren-mode 1)
  :config
  (progn
    (setq-default show-paren-delay 0
                  show-paren-highlight-openparen t
                  show-paren-when-point-inside-paren t)))

(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-track-opened-file)
  :init
  (progn
    (add-hook 'find-file-hook (lambda () (unless recentf-mode
                                           (recentf-mode)
                                           (recentf-track-opened-file))))
    (setq recentf-save-file (concat user-emacs-directory "recentf")
          recentf-max-saved-items 1000
          recentf-auto-cleanup 'never
          recentf-filename-handlers '(abbreviate-file-name))))

(use-package savehist
  :ensure nil
  :commands (savehist-mode)
  :init
  (progn
    (setq savehist-file (concat user-emacs-directory "savehist")
          enable-recursive-minibuffers t
          savehist-save-minibuffer-history t
          history-length 1000
          savehist-autosave-interval 60
          savehist-additional-variables '(mark-ring
                                          global-mark-ring
                                          search-ring
                                          regexp-search-ring
                                          extended-command-history))
    (savehist-mode t)))

(use-package saveplace
  :ensure nil
  :commands (save-place-mode)
  :init
  (progn
    (setq save-place-file (concat user-emacs-directory "places"))
    (save-place-mode)))

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "saves/")))
      auto-save-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save") t))
      auto-save-list-file-name (concat user-emacs-directory "autosave")
      abbrev-file-name (concat user-emacs-directory "abbrev_defs")
      make-backup-files nil
      backup-by-copying t
      version-control t
      delete-old-versions t)

(use-package ws-butler
  :commands (ws-butler-global-mode)
  :init (ws-butler-global-mode 1))

(use-package aggressive-indent
  :commands (aggressive-indent-mode)
  :init (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))

(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(setq-default indent-tabs-mode nil
              tab-width 2
              sentence-end-double-space nil
              vc-follow-symlinks t
              fill-column 80)
(setq help-window-select t
      compilation-scroll-output 'first-error
      save-interprogram-paste-before-kill t
      max-specpdl-size 10000)
(add-hook 'text-mode-hook #'auto-fill-mode)

(use-package company
  :commands (global-company-mode)
  :delight
  :init
  (progn
    (setq company-idle-delay 0.2
          company-minimum-length 2
          company-require-match nil
          company-dabbrev-ignore-case nil
          company-dabbrev-downcase nil
          company-tooltip-align-annotations t))
  :config (add-hook 'after-init-hook #'global-company-mode))

(use-package gitattributes-mode)
(use-package gitconfig-mode)
(use-package gitignore-mode)

(use-package magit
  :delight auto-revert-mode
  :general
  (general-define-key
   "C-x g" '(:which-key "git")
   "C-x g s" '(magit-status :which-key "git status")))

(use-package evil-magit
  :after magit
  :commands (evil-magit-init)
  :init (evil-magit-init))

(use-package diff-hl
  :commands (diff-hl-magit-post-refresh global-diff-hl-mode)
  :init
  (progn
    (setq diff-hl-side 'left
          diff-hl-margin-symbols-alist
          '((insert . "+") (delete . "-") (change . "~")
            (unknown . "?") (ignored . "i")))
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)
    (diff-hl-flydiff-mode)
    (diff-hl-margin-mode)
    (global-diff-hl-mode)))

(use-package flyspell
  :commands (flyspell-mode flyspell-buffer)
  :init
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (dolist (mode-hook '(text-mode-hook LaTeX-mode-hook))
    (add-hook mode-hook (lambda () (flyspell-mode))))
  :config
  (setq ispell-dictionary "en_US"
        flyspell-use-meta-tab nil
        flyspell-issue-message-flag nil
        flyspell-issue-welcome-flag nil))

(use-package flyspell-correct-ivy
  :commands (flyspell-correct-ivy)
  :general (:keymaps 'flyspell-mode-map
                     "C-;" 'flyspell-correct-previous-word-generic)
  :init (setq flyspell-correct-interface #'flyspell-correct-ivy))

(use-package flycheck
  :commands (global-flycheck-mode)
  :init
  (progn
    (global-flycheck-mode t)
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
  :config
  (progn
    (setq flycheck-standard-error-navigation nil
          flycheck-indication-mode 'right-fringe
          flycheck-check-syntax-automatically '(save idle-change mode-enable)
          flycheck-idle-change-delay 4)))

(use-package counsel
  :commands (counsel-mode)
  :demand
  :delight
  :general
  (general-define-key
   "C-x C-f" 'counsel-find-file
   "C-x C-r" 'counsel-recentf
   "C-h f" 'counsel-describe-function
   "C-h v" 'counsel-describe-variable)
  :config
  (progn
    (counsel-mode)))

(use-package ivy
  :commands (ivy-mode)
  :demand
  :delight
  :config
  (progn
    (ivy-mode)
    (setq ivy-use-virtual-buffers t
          enable-recursive-minibuffers t
          ivy-count-format "%d%d ")))

(use-package swiper
  :demand
  :general
  (general-define-key "C-S" 'swiper))

(defun my--switch-window ()
  (interactive)
  (let (;; switch to first window previously shown in this frame
        (prev-window (get-mru-window nil t t)))
    ;; Check window was not found successfully
    (unless prev-window (user-error "Last window not found."))
    (select-window prev-window)))

(use-package avy
  :commands (avy-goto-char avy-goto-line)
  ;; :init (unbind-key "C-'" org-mode-map)
  :config
  (progn
    (general-define-key :states '(normal visual)
                        "f" 'avy-goto-char-2)
    (general-define-key :states '(normal visual)
                        :keymaps 'org-mode-map
                        "M-g f" 'avy-org-goto-heading-timer)
    (general-define-key :states '(normal insert visual)
                        "C-'" 'avy-goto-char
                        "M-g g" 'avy-goto-line)))

(use-package treemacs
  :commands (treemacs-follow-mode treemacs-filewatch-mode)
  :config
  (progn
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)))

(use-package treemacs-evil
  :after (evil treemacs))

(use-package async
  :commands (async-start)
  :config
  (progn
    (async-bytecomp-package-mode t)
    (setq async-bytecomp-allowed-packages '(all))))

(use-package tao-theme
  :demand t
  :init (load-theme 'tao-yang t))

(set-face-attribute 'default nil
                    :family "DejaVu Sans Mono"
                    :height 80)
(set-face-attribute 'variable-pitch nil
                    :family "DejaVu Sans"
                    :height 80)
(set-frame-font "DejaVu Sans Mono" nil t)

(setq display-time-day-and-date t
      display-time-24hr-format t
      display-time-default-load-average nil)
(display-time-mode t)

(setq-default display-line-numbers 'visual
              display-line-numbers-current-absolute t
              display-line-numbers-width 4
              display-line-numbers-widen nil)

(set-fringe-style '(0 . 16))

(use-package hl-line
  :ensure nil
  :commands (global-hl-line-mode)
  :init (global-hl-line-mode t)
  :config
  (progn

(setq hl-line-sticky-flag nil

global-hl-line-sticky-flag nil)))

(use-package uniquify
  :ensure nil
  :init
  (progn
    (setq uniquify-buffer-name-style 'forward)))

(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(setq-default line-spacing 0.15

cursor-type '(bar . 2)

frame-title-format '("Amalthea :: %b"))

(use-package org
  :ensure org-plus-contrib
  :commands (org-babel-do-load-languages org-load-modules-maybe)
  :config
  (progn
    (add-to-list 'org-modules 'org-crypt)
    (setq org-use-sub-superscripts '{}
          org-export-with-sub-superscripts '{}
          org-export-use-babel nil
          org-preview-latex-default-process 'dvipng
          org-pretty-entities t
          org-list-allow-alphabetical t
          org-latex-remove-logfiles nil)
    (org-load-modules-maybe t)))

(setq-default org-src-fontify-natively t)

(setq org-startup-indented t)
(delight 'org-indent-mode)

(setq org-hide-emphasis-markers t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (emacs-lisp . t)
   (sql . t)
   (latex . t)
   (lua . t)
   (R . t)))

(use-package htmlize)

(use-package ox-twbs
  ;; stupid hack required to make it work >:(
  :init (require 'ox-twbs))

(use-package toc-org)

(add-hook 'org-mode-hook
          '(lambda ()
             (setq display-line-numbers nil)
             (set-fringe-style '(16 . 16))
             (variable-pitch-mode t)
             (dolist (face '(org-code
                             org-link
                             org-block
                             org-table
                             org-block-begin-line
                             org-block-end-line
                             org-meta-line
                             org-document-info-keyword))
               (set-face-attribute face nil :inherit 'fixed-pitch))))

(setq org-directory "~/Documents/Org"
      org-default-notes-file "~/Documents/Org/refile.org"
      org-agenda-files '("~/Documents/Org"))

(use-package org-journal
  :commands (org-journal-mode)
  :config
  (progn
    (setq org-journal-dir (concat (expand-file-name "~/.journal/") (format-time-string "%Y/"))
          org-journal-file-format "%F"
          org-journal-date-format "%A -- %B %e, %Y"
          org-journal-time-format ""
          org-journal-enable-encryption t
          org-journal-enable-agenda-integration t)))

(use-package org
  :init (org-crypt-use-before-save-magic)
  :config
  (progn
    (add-to-list 'org-tag-alist '("crypt" . ?C))
    (setq org-tags-exclude-from-inheritance '("crypt")
          org-crypt-key "877E8F427CEF8D21DD0E86194BA8924BECCB34DA"
          auto-save-default nil)))

(use-package evil-org
  :after org
  :commands (evil-org-set-key-theme evil-org-agenda-set-keys)
  :hook ((org-mode . evil-org-mode)
         (evil-org-mode . (lambda () (evil-org-set-key-theme))))
  :config
  (progn
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys)))

(defun my--tangle-byte-compile-org ()
  "Tangles emacs.org and byte compiles ~/.emacs.d/"
  (interactive)
  (when (equal (buffer-name) (concat "emacs.org"))
    (async-start
     `(lambda ()
        (require 'org)
        (org-babel-tangle-file (concat (expand-file-name "~/.dotfiles/") "emacs.org")))
     (lambda (result)
       (byte-recompile-file (concat (expand-file-name user-emacs-directory) "init.el") t)
       (message "Tangled and compiled emacs.org")))))

(add-hook 'after-save-hook #'my--tangle-byte-compile-org)

(add-hook 'kill-emacs-hook
          (lambda ()
            (byte-recompile-directory (expand-file-name user-emacs-directory) 0)))

(use-package tex
  :ensure auctex
  :commands (TeX-source-correlate-mode TeX-PDF-mode)
  :init
  (progn
    (setq-default TeX-master nil)
    (setq TeX-command-default "latexmk"
          TeX-command-force "latexmk"
          TeX-engine 'lualatex
          TeX-auto-save t
          TeX-parse-self t
          TeX-save-query nil
          TeX-PDF-mode t
          TeX-show-compilation nil
          TeX-syntactic-comment t
          TeX-clean-confirm t
          TeX-source-correlate-mode t
          TeX-source-correlate-method 'synctex
          TeX-source-correlate-start-server t
          LaTeX-babel-hyphen nil
          LaTeX-fill-break-at-separators nil
          TeX-view-program-selection '((output-pdf "Zathura")))
    (add-hook 'LaTeX-mode-hook #'TeX-fold-mode)
    (add-hook 'LaTeX-mode-hook #'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook #'TeX-source-correlate-mode)
    (add-hook 'LaTeX-mode-hook #'TeX-PDF-mode)
    (add-hook 'LaTeX-mode-hook #'flyspell-mode)
    (add-hook 'LaTeX-mode-hook #'flyspell-buffer)))

(use-package auctex-latexmk
  :commands (auctex-latexmk-setup)
  :init
  (progn
    (setq auctex-latexmk-inherit-TeX-PDF-mode t)
    (auctex-latexmk-setup)))

(use-package company-auctex
  :commands (company-auctex-init)
  :init (company-auctex-init))

(use-package company-math
  :config
  (progn
    (add-to-list 'company-backends 'company-math-symbols-latex)
    (add-to-list 'company-backends 'company-math-symbols-unicode)
    (add-to-list 'company-backends 'company-latex-commands)))

(use-package magic-latex-buffer
  :commands (magic-latex-buffer)
  :init
  (progn
    (add-hook 'LaTeX-mode-hook #'magic-latex-buffer)
    (setq magic-latex-enable-block-highlight t
          magic-latex-enable-suscript t
          magic-latex-enable-pretty-symbols t
          magic-latex-enable-block-align nil
          magic-latex-enable-inline-image t)))

(use-package reftex
  :ensure nil
  :commands (turn-on-reftex reftex-mode)
  :init
  (progn
    (setq reftex-plug-into-AUCTeX t
          reftex-use-fonts t
          reftex-default-bibliography '("~/Documents/UiB/bibliography.bib")
          reftex-toc-split-windows-fraction 0.2))
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex))

(use-package bibtex
  :ensure nil
  :config
  (progn
    (setq bibtex-dialect 'biblatex
          bibtex-align-at-equal-sign t
          bibtex-text-indentation 20
          bibtex-completion-bibliography '("~/Documents/UiB/bibliography.bib"))))

(use-package company-reftex)

(use-package lispy
  :config
  :hook (emacs-lisp-mode . lispy-mode)
  :config (define-key lispy-mode-map-lispy (kbd "\"") nil))

(use-package lispyville
  :after lispy
  :hook (lispy-mode . lispyville-mode))

(use-package flycheck-package
  :after flycheck)

(use-package sql
  :ensure nil
  :config
  (progn
    (setq sql-product 'mysql)))

(use-package sqlup-mode
  :after sql
  :hook ((sql-mode sql-interactive-mode) . sqlup-mode))

(use-package sql-indent
  :load-path "~/Code/emacs/emacs-sql-indent"
  :hook (sql-mode . sqlind-minor-mode))

(use-package ess)

(use-package nix-mode)

(use-package company-nixos-options
  :init (add-to-list 'company-backends 'company-nixos-options))

(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode)
  :interpreter ("lua" . lua-mode)
  :init (progn
          (setq lua-indent-level 2
                lua-indent-string-contents t)))

(use-package company-lua
  :after lua-mode
  :init (progn
          (add-hook 'lua-mode-hook 'company-mode)
          (defun my--lua-init ()
            (setq-local company-backends '((company-lua
                                            company-etags
                                            company-dabbrev-code
                                            company-yasnippet))))
          (add-hook 'lua-mode-hook #'my--lua-init)))

(add-hook 'emacs-startup-hook
          (lambda () (message (concat "Booted in: " (emacs-init-time))))
          (setq gc-cons-threshold (* 100 1024)
                gc-cons-percentage 0.1))
