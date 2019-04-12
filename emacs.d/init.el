;;-*- coding:utf-8-unix mode:lisp -*-

;;; emacs -q -lした時に、user-emacs-directoryが変わるように
;;; ただし、-qするとafter-init-hookが走らない。
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package, use-package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(package-initialize)
(setq package-archives
      '(("gnu"   . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org"   . "http://orgmode.org/elpa/")))

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-enable-imenu-support t)
(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(setq use-package-expand-minimally t)
(setq use-package-compute-statistics t)

(use-package bind-key)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Quelpa
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package package-utils)
(use-package delight)
(use-package diminish)
(use-package quelpa-use-package
  :init
  (setq quelpa-dir (expand-file-name "quelpa" user-emacs-directory)
	quelpa-upgrade-p nil
	quelpa-checkout-melpa-p nil
	quelpa-update-melpa-p nil
	quelpa-melpa-recipe-stores nil))
(quelpa-use-package-activate-advice)

;;https://uwabami.github.io/cc-env/Emacs.html


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; もろもろ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ring-bell-function 'ignore) ;;警告音を鳴らさない
(blink-cursor-mode 0) ;;カーソルを点滅しない
(global-hl-line-mode t) ;;カーソル表をハイライトする
(setq transient-mark-mode t) ;;選択範囲をハイライトする
(setq read-file-name-completion-ignore-case t) ;;ファイル名の補完で大文字小文字を区別しない
(setq completion-ignore-case t) ;;補完時に大文字小文字を区別しない
(setq read-buffer-completion-ignore-case t) ;;バッファ名の補完で大文字小文字を無視する
(defalias 'yes-or-no-p #'y-or-n-p) ;;yes/noの質問をy/nに統一する
(setq find-file-visit-truename t) ;;シンボリックリンクをたどって元のパスに展開する

;; Quiet Startup
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)

;;スクリプトっぽいファイルに実行権限を付ける
(add-hook 'after-save-hook
	  'executable-make-buffer-file-executable-if-script-p)

;;起動時間の計測
(use-package esup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 文字コード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment               'utf-8)
(prefer-coding-system                   'utf-8)
(set-file-name-coding-system            'utf-8)
(set-keyboard-coding-system             'utf-8)
(set-terminal-coding-system             'utf-8)
(set-default 'buffer-file-coding-system 'utf-8)
(set-default-coding-systems             'utf-8)

;;文字の調整
;;https://uwabami.github.io/cc-env/Emacs.html
(use-package cp5022x
  :config
  (set-charset-priority 'ascii
			'japanese-jisx0208
			'latin-jisx0201
                        'katakana-jisx0201
			'iso-8859-1
			'unicode)
  (set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 絵文字
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package all-the-icons
  :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインドの説明を表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package hydra)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 括弧
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :custom-face
  (show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c"))))
  :custom
  (show-paren-style 'mixed)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 自動保存
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package auto-save-buffers-enhanced
  :config
  (setq auto-save-buffers-enhanced-include-regexps '(".+"))
  (setq auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$"))
  (auto-save-buffers-enhanced t))

(setq make-backup-files nil) ;;~付きのバックアップファイルを作らない
(setq auto-save-default nil) ;;#;付きのバックアップファイルを作らない
(setq auto-save-list-file-prefix nil) ;;auto-save-listを作らない

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eshell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package eshell
  :defer t
  :custom
  (eshell-directory-name (expand-file-name ".cache/eshell/" user-emacs-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; projectile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :diminish
  :custom
  (projectile-known-projects-file (expand-file-name ".cache/projectile-bookmarks.eld" user-emacs-directory))
  ;:bind
  ;("M-o p" . projectile-switch-project)
  :config
  (projectile-mode +1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; snippet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package yasnippet
  :diminish yas-minor-mode
  :custom (yas-snippet-dirs '((expand-file-name "snippets" user-emacs-directory)))
  :hook (after-init . yas-global-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; abbrev
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package abbrev
  :ensure nil
  :custom
  (abbrev-file-name (expand-file-name ".cache/abbrev_defs" user-emacs-directory))
  (save-abbrevs 'silently))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; visual-regexp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package visual-regexp
  ;:bind
  ;("M-%" . vr/query-replace)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; symbol-overlay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package symbol-overlay
  :hook
  (prog-mode     . symbol-overlay-mode)
  (markdown-mode . symbol-overlay-mode)
  :bind
  ("M-i" . symbol-overlay-put)
  ("C-g" . symbol-overlay-remove-all))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 空白の強調表示
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package whitespace
  :ensure nil
  :diminish global-whitespace-mode
  :config
  (setq whitespace-line-column 72
        whitespace-style '(face              ; faceを使って視覚化する．
                           trailing          ; 行末の空白を対象とする．
                           tabs              ; tab
                           spaces            ; space
                           )
        whitespace-display-mappings '((space-mark ?\u3000 [?\□])
                                      (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]))
        whitespace-space-regexp "\\(\u3000+\\)"
        whitespace-global-modes '(not
                                  eww-mode
                                  term-mode
                                  eshell-mode
                                  org-agenda-mode
                                  calendar-mode)
        )
  (global-whitespace-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TODO, FIXMEをハイライトする
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package hl-todo
  :config
  (global-hl-todo-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; history
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :custom
  (savehist-file (expand-file-name ".cache/history" user-emacs-directory)))

(setq undo-limit 200000
      undo-strong-limit 260000)
(setq history-length t  ; t で無制限
      )

;;以前開いたときのカーソル位置を復元する
(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode)
  :custom
  (save-place-file (expand-file-name ".cache/saved-places" user-emacs-directory)))

(use-package recentf-ext
  :hook (after-init . recentf-mode)
  :custom
  (recentf-save-file (expand-file-name ".cache/recentf" user-emacs-directory))
  (recentf-max-saved-items 200000000)
  (recentf-auto-cleanup 'never)
  (recentf-exclude '((expand-file-name package-user-dir)
		     ".cache"
		     "cache"
		     "recentf"
		     "COMMIT_EDITMSG\\'")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; redo/undo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package undo-tree
  ;;:bind ("M-/" . undo-tree-redo)
  :config
  (global-undo-tree-mode t))

;;履歴を永続化
(use-package undohist
  :diminish
  :hook (after-init . undohist-initialize)
  :custom
  (undohist-ignored-files '("/tmp" "/EDITMSG" "/elpa"))
  (undohist-directory (expand-file-name ".cache/undohist" user-emacs-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ido
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (use-package ido
;;   :ensure nil
;;   :bind
;;   (("C-x C-f" . ido-find-file)
;;    ("C-x C-d" . ido-dired)
;;    ("C-x b"   . ido-switch-buffer)
;;    ("C-x C-b" . ido-switch-buffer))
;;   :config
;;   (ido-mode t)
;;   (ido-ubiquitous-mode 1))
;;
;; (use-package flx-ido
;;   :config
;;   (flx-ido-mode 1)
;;   (setq flx-ido-use-faces nil
;; 	flx-ido-threshold 10000))
;;
;; ;; (use-package ido-grid
;; ;;   :quelpa (ido-grid :fetcher github :repo "larkery/ido-grid.el")
;; ;;   :config
;; ;;   (setq ido-grid-enabled nil
;; ;; 	ido-grid-start-small nil
;; ;; 	ido-grid-rows 0.220
;; ;; 	ido-grid-max-column 1
;; ;; 	ido-grid-indent 1
;; ;; 	ido-grid-column-padding 1
;; ;; 	ido-grid-bind-keys t)
;; ;;   (ido-grid-enable))
;;
;; (use-package ido-vertical-mode
;;   :config
;;   (setq ido-max-window-height 0.75
;; 	ido-enable-flex-matching t
;; 	ido-vertical-define-keys 'C-n-and-C-p-only)
;;   (ido-vertical-mode 1))
;;
;;
;; (use-package ido-completing-read+)
;;
;; (use-package smex
;;   :bind (("M-x" . smex))
;;   :config
;;   (setq smex-auto-update t
;; 	smex-prompt-string "smex: "
;; 	smex-flex-matching t)
;;   (smex-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; posframe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(use-package posframe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package counsel
  :diminish ivy-mode counsel-mode
  :custom
  ;(ivy-use-virtual-buffers t)
  ;(enable-recursive-minibuffers t)
  ;(ivy-height 10)
  (swiper-include-line-number-in-search t) ;;line-numberでも検索できる
  (ivy-count-format "(%d/%d) ")
  :hook
  (after-init . ivy-mode)
  (ivy-mode   . counsel-mode)
  :bind
  ("C-s"      . swiper))

(use-package flx)

(use-package amx
  :custom
  (amx-save-file (expand-file-name ".cache/amx-items" user-emacs-directory)))

(use-package counsel-projectile
  :config (counsel-projectile-mode 1))

(use-package ivy-rich
  :config
  (ivy-rich-mode 1))

;;(use-package ivy-posframe
;;  :after ivy
;;  :custom-face
;;  (ivy-posframe ((t (:background "#282a36"))))
;;  :custom
;;  (ivy-display-function #'ivy-posframe-display-at-frame-center)
;;  :config
;;  (ivy-posframe-enable))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; anzu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(use-package anzu
;;  :diminish
;;  :hook (after-init . global-anzu-mode)
;;  :config
;;  (global-set-key [remap query-replace]        'anzu-query-replace)
;;  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; neo-tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package neotree
  :custom
  (net-theme 'icon)
  (neo-persist-show t) ;;delete-other-windowでウィンドウを消さない
  (neo-smart-open t)   ;;neotreeウィンドウを表示する毎にcurrent fileのあるディレクトリを表示する
  (neo-show-hidden-files t) ;;隠しファイルを表示する
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ispell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ispell
  :ensure nil
  :init
  (setq-default ispell-program-name "aspell")
  :config
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; editorconfig
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package markdown-mode
  :custom
  (markdown-hide-markup        nil)
  (markdown-bold-underscore    t)
  (markdown-italic-underscore  t)
  (markdown-header-scaling     t)
  (markdown-indent-function    t)
  (markdown-enable-match       t)
  (markdown-hide-urls          nil)
  :mode "\\.md\\'")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :defer t
  :diminish company-mode
  :defines
  (company-dabbrev-ignore-case company-dabbrev-downcase)
  :custom
  (company-idle-delay 0)
  (company-echo-delay 0)
  ;;:hook (after-init . global-company-mode)
  )

(use-package company-box
  :defer t
  :diminish
  :hook (company-mode . company-box-mode))

(use-package company-quickhelp
  :defer t
  :defines company-quickhelp-delay
  :hook    (global-company-mode . company-quickhelp-mode)
  :custom  (company-quickhelp-delay 0.8))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :custom-face
  (doom-modeline-bar ((t (:background "#6272a4"))))
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon            t)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes     nil)
  :hook (after-init . doom-modeline-mode)
  :config
  ;(line-number-mode 0)
  ;(column-number-mode 0)
  (doom-modeline-def-modeline 'main
    '(bar workspace-number window-number evil-state god-state ryo-modal xah-fly-keys matches buffer-info remote-host buffer-position parrot selection-info)
    '(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker)))

;;起動画面
(use-package dashboard
  :diminish
  (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-startup-banner 2)
  (dashboard-items '((recents . 15)
		     (projects . 5)))
  :hook
  (after-init . dashboard-setup-startup-hook))

;;画面の左に行番号を表示する
(use-package display-line-numbers
  :ensure nil
  :hook
  (prog-mode . display-line-numbers-mode))

(use-package volatile-highlights
  :diminish
  :hook (after-init . volatile-highlights-mode)
  :custom-face
  (vhl/default-face ((nil (:foreground "#FF333" :background "#FFCDCD")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load (concat user-emacs-directory "+window.el"))
(load (concat user-emacs-directory "+org.el"))
(load (concat user-emacs-directory "+japanese.el"))
(load (concat user-emacs-directory "+flycheck.el"))
(load (concat user-emacs-directory "+verilog.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package evil
  :hook (after-init . evil-mode)
  :bind
  (("C-["     . evil-normal-state)
   ("C-g"     . evil-normal-state)
   :map evil-visual-state-map
   ("TAB"     . indent-for-tab-command)
   :map evil-normal-state-map
   ("SPC SPC" . counsel-M-x)
   ("TAB"     . indent-for-tab-command)
   ("SPC q r" . restart-emacs)
   ("SPC q q" . kill-emacs)
   ;;file
   ("SPC f f" . find-file)
   ("SPC f n" . neotree-toggle)
   ;;buffer
   ("SPC b b" . switch-to-buffer)
   ("SPC b k" . kill-this-buffer)
   ;;undo-tree
   ("u"       . undo-tree-undo)
   ("SPC u r" . undo-tree-redo)
   ("SPC u v" . undo-tree-visualize)
   ;;window
   ("SPC 1"   . delete-other-windows)
   ("SPC 0"   . delete-window)
   ;;symbol-overlay
   ("SPC s i" . symbol-overlay-put)
   ("SPC s c" . symbol-overlay-remove-all)
   ;;org-mode
   ("SPC o A" . org-agenda)
   ("SPC o p" . org-pomodoro)
   ("SPC X"   . org-capture)
   :map evil-insert-state-map
   ("C-g"     . evil-normal-state)
   ))


;;https://ladicle.com/post/config/
;;https://uwabami.github.io/cc-env/Emacs.html

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(abbrev-file-name "/home/teppei/.emacs.d/.cache/abbrev_defs")
 '(amx-save-file "/home/teppei/.emacs.d/.cache/amx-items")
 '(avy-migemo-function-names
   (quote
    (swiper--add-overlays-migemo
     (swiper--re-builder :around swiper--re-builder-migemo-around)
     (ivy--regex :around ivy--regex-migemo-around)
     (ivy--regex-ignore-order :around ivy--regex-ignore-order-migemo-around)
     (ivy--regex-plus :around ivy--regex-plus-migemo-around)
     ivy--highlight-default-migemo ivy-occur-revert-buffer-migemo ivy-occur-press-migemo avy-migemo-goto-char avy-migemo-goto-char-2 avy-migemo-goto-char-in-line avy-migemo-goto-char-timer avy-migemo-goto-subword-1 avy-migemo-goto-word-1 avy-migemo-isearch avy-migemo-org-goto-heading-timer avy-migemo--overlay-at avy-migemo--overlay-at-full)))
 '(company-echo-delay 0 t)
 '(company-idle-delay 0 t)
 '(company-quickhelp-delay 0.8 t)
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(eshell-directory-name "/home/teppei/.emacs.d/.cache/eshell/" t)
 '(ivy-count-format "(%d/%d) ")
 '(markdown-bold-underscore t t)
 '(markdown-enable-match t t)
 '(markdown-header-scaling t t)
 '(markdown-hide-markup nil t)
 '(markdown-hide-urls nil t)
 '(markdown-indent-function t t)
 '(markdown-italic-underscore t t)
 '(neo-persist-show t t)
 '(neo-show-hidden-files t)
 '(neo-smart-open t)
 '(net-theme (quote icon) t)
 '(package-selected-packages
   (quote
    (yasnippet which-key volatile-highlights visual-regexp verilog-mode veri-kompass undohist symbol-overlay recentf-ext rainbow-delimiters quelpa-use-package pangu-spacing package-utils org-pomodoro org-bullets neotree markdown-mode japanese-holidays ivy-rich hydra hl-todo flycheck flx evil esup editorconfig doom-themes doom-modeline diminish delight ddskk dashboard cp5022x counsel-projectile company-quickhelp company-box avy-migemo auto-save-buffers-enhanced amx)))
 '(projectile-known-projects-file "/home/teppei/.emacs.d/.cache/projectile-bookmarks.eld")
 '(recentf-auto-cleanup (quote never))
 '(recentf-exclude
   (quote
    ((expand-file-name package-user-dir)
     ".cache" "cache" "recentf" "COMMIT_EDITMSG\\'")))
 '(recentf-max-saved-items 200000000)
 '(recentf-save-file "/home/teppei/.emacs.d/.cache/recentf")
 '(safe-local-variable-values (quote ((flycheck-mode))))
 '(save-abbrevs (quote silently))
 '(save-place-file "/home/teppei/.emacs.d/.cache/saved-places")
 '(savehist-file "/home/teppei/.emacs.d/.cache/history")
 '(show-paren-style (quote mixed))
 '(show-paren-when-point-in-periphery t)
 '(show-paren-when-point-inside-paren t)
 '(swiper-include-line-number-in-search t)
 '(undohist-directory "/home/teppei/.emacs.d/.cache/undohist")
 '(undohist-ignored-files (quote ("/tmp" "/EDITMSG" "/elpa")))
 '(yas-snippet-dirs (quote ("~/.emacs.d/snippets"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-modeline-bar ((t (:background "#6272a4"))))
 '(show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c"))))
 '(vhl/default-face ((nil (:foreground "#FF333" :background "#FFCDCD")))))
