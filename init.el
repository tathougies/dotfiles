;; MELPA Configuration

(require 'package) ;; You might already have this line
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; Use package

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(require 'diminish)

(use-package direnv
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'direnv-update-environment)
  :config
  (direnv-mode))
(use-package company-lsp :defer t)

(use-package handlebars-mode
  :commands handlebars-mode)
(use-package org-kanban :ensure t)

(use-package svelte-mode
  :commands (svelte-mode)
  :mode "\\.svelte\\'")
(use-package rust-mode
  :mode "\\.rs\\'"
  :commands
  (rust-mode)
  :config
  (add-hook 'rust-mode-hook #'lsp))

(use-package thrift
  :commands (thrift-mode)
   :config
   (progn
     (add-to-list 'auto-mode-alist '("*\\.thrift$" . thrift-mode))))
(use-package protobuf-mode
  :mode "\\.proto\\'")
(use-package bazel-mode
  :commands bazel-mode
  :mode "^(WORKSPACE\|BUILD)$")

(use-package anaconda-mode
  :commands anaconda-mode
  :config
  (progn
    (add-hook 'python-mode-hook 'anaconda-mode)))

(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (require 'helm-files)
    (require 'helm-projectile)

    (setq helm-candidate-number-limit 100)
    (setq helm-idle-delay 0.0
          helm-input-idle-delay 0.01
          helm-yas-update-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode))
  :bind ( ("M-x" . helm-M-x)
	  ("C-x C-f" . helm-find-files)))
(use-package helm-projectile
  :commands helm-projectile-on)
(use-package projectile
  :ensure t
  :bind-keymap ("C-c p" . projectile-command-map)
  :config (helm-projectile-on)
  :init
  (progn (add-to-list 'projectile-globally-ignored-files ".git")
         (add-to-list 'projectile-globally-ignored-files ".cabal-sandbox")))


(use-package flycheck
  :ensure t)

(use-package
  haskell-mode
  :mode ("\\.\\(hs\\|lhs\\)\\'")
  :init
  (progn
    (add-hook 'haskell-mode-hook 'haskell-indent-mode)
;    (add-hook 'haskell-mode-hook 'flycheck-mode)
    ))
;;    (add-hook 'haskell-mode-hook 'company-mode)
(use-package nix-mode
  :mode "\\.nix\\'"
  :ensure t)
(use-package elm-mode
  :mode "\\.elm\\'")

;; (use-package
;;   nix-sandbox
;;   :ensure t
;;   :init
;;   (progn
;;     (setq haskell-process-wrapper-function
;;           (lambda (args) (apply 'nix-shell-command (nix-current-sandbox) args)))
;;     (setq flycheck-command-wrapper-function
;;           (lambda (command) (apply 'nix-shell-command (nix-current-sandbox) command))
;;           flycheck-executable-find
;;           (lambda (command) (nix-executable-find (nix-current-sandbox) command)))))

(use-package
  ace-window
  :bind (("M-o" . ace-window))
  :commands (ace-window))

(use-package restclient :commands (restclient-mode) :mode "\\.rest\\'")

(use-package lsp-mode
  :after (direnv)
  :config
  (setq lsp-prefer-flymake nil)
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-clients-clangd-args '("--header-insertion-decorators=0" "--enable-config"))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
         (lsp-mode . lsp-ui-sideline-mode)
         (lsp-mode . lsp-headerline-breadcrumb-mode)
         (rust-mode . lsp-lens-mode))
  :commands lsp)

(use-package ccls
  :after (lsp-mode)
  :ensure t)

;; optionally
(use-package lsp-ui
  :commands (lsp-ui-mode lsp-ui-sideline-mode)
  :config
  (setq lsp-ui-sideline-show-code-actions t)
  )
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :commands (lsp-treemacs-errors-list lsp-treemacs-symbols)
  :bind (("C-c l g s" . lsp-treemacs-symbols))
  )

(use-package bison-mode :mode "\\.yacc\\'")

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

(if (file-exists-p "~/.emacs.d/local.el") (load-file "~/.emacs.d/local.el"))
 
;; (require 'haskell)

;; (require 'nix-mode)
;; (add-hook 'haskell-mode-hook 'haskell-indent-mode)

;; Custom variables

(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)
(global-linum-mode 1)

;;(tool-bar-add-item "spell" 'strokes-do-stroke 'strokes-do-stroke :help "Gesture")
(tool-bar-add-item "spell" 'yas-insert-snippet 'yas-insert-snippet :help "Insert snippet")
(put 'set-goal-column 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(lsp-clients-clangd-args '("--header-insertion-decorators=0" "--enable-config"))
 '(org-agenda-files '("~/Projects/wg-vpn/TODO.org"))
 '(package-selected-packages
   '(lsp-treemacs ccls direnv bison-mode flex-mode company-mode lsp-ui lsp-mode rust-mode bbdb bbdb-wl mime-w3m wanderlust svelte-mode elm-mode lilypond-mode org-kanban handlebars-mode protobuf-mode thrift bazel-mode lua-mode erc-sasl web-mode django-html-mode django-mode yasnippet anaconda-mode restclient-helm restclient yaml-mode use-package scala-mode sbt-mode popwin nix-sandbox nix-mode markdown-mode magithub jade-mode helm-projectile helm-hayoo helm-git helm-c-moccur flycheck-hdevtools company-nixos-options company-ghc cmake-mode ac-helm))
 '(send-mail-function 'smtpmail-send-it)
 '(smtpmail-smtp-server "mail.f-omega.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (load-file (let ((coding-system-for-read 'utf-8))
;;             "/nix/store/s64zb3cdc9q26a25ssxvhckihggggffk-Agda-2.6.0.1-data/share/ghc-8.6.5/x86_64-linux-ghc-8.6.5/Agda-2.6.0.1/emacs-mode/agda2.el"))



(add-hook 'c++-mode-hook #'lsp)
