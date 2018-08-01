;;init.el

;use-packageが無いときにエラーがでないようにする
;http://qiita.com/kai2nenobu/items/5dfae3767514584f5220
;; (unless (require 'use-package nil t)
;;   (defmacro use-package (&rest args)))

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; el-get
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;http://tarao.hatenablog.com/entry/20150221/1424518030
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get-bundle use-package)
(el-get-bundle bind-key)
;M-x describe-personal-keybindingsで割り当てたキーバインドを表示してくれる

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq frame-title-format (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

(setq load-path
      (append
       (list (expand-file-name "~/.emacs.d/site-lisp")) load-path))


(bind-key "C-h"  'backward-delete-char)
(bind-key "M-?"  'help-for-help)
(bind-key [f1]   'help-for-help)
(bind-key "M-g"  'goto-line) ;; M-g で指定行へ移動
(bind-key "C-c o" 'comment-or-uncomment-region)

(setq mouse-drag-copy-region t) ;; マウスで選択するとコピーする
(tool-bar-mode 0) ;;toolbarがでない

;;シンボリックリンクをたどって元のパスに展開する
(setq-default find-file-visit-truename t)

;;;http://meadow-faq.sourceforge.net/meadow-faq-ja_4.html#SEC78
;; 一行ずつスクロール
(defun scroll-up-one-line ()
  (interactive)
  (scroll-up 1))
(defun scroll-down-one-line ()
  (interactive)
  (scroll-down 1))
(bind-key "C-," 'scroll-up-one-line)
(bind-key "C-." 'scroll-down-one-line)

;; TAB はスペース 4 個ぶんを基本
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; モードラインにライン数、カラム数表示
(line-number-mode 1)
(column-number-mode 1)

;;大文字小文字区別しない
(setq read-file-name-completion-ignore-case t)
(setq completion-ignore-case t)

;;ハイライト
(setq-default show-trailing-whitespace t) ;;行末の空白を強調
(show-paren-mode 1)     ;; 対応するカッコを色表示する
(setq show-paren-style 'mixed) ;;画面内に対応する括弧がある場合は括弧だけを，ない場合は括弧で囲まれた部分をハイライト
(global-hl-line-mode t) ;;現在行をハイライト
(transient-mark-mode t) ;;選択範囲をハイライト

;;http://d.hatena.ne.jp/hnw/20140115
 (add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)


;;isearchで、カーソルのある位置の文字を1文字ずつ入力する
(defun isearch-yank-char ()
  "Pull next character from buffer into search string."
  (interactive)
  (isearch-yank-string
   (save-excursion
     (and (not isearch-forward) isearch-other-end
          (goto-char isearch-other-end))
     (buffer-substring (point) (1+ (point))))))
(define-key isearch-mode-map "\C-d" 'isearch-yank-char)

;; Default encoding
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


;;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;; Major mode
;;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STIL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle stil-mode
  :url "https://www.advantest.com/documents/11348/146462/DfX%20EMACS.txt")
(use-package stil-mode
  :config
  (setq auto-mode-alist (nconc '(("\\.stil$" . stil-mode)) auto-mode-alist))
  (add-hook 'stil-mode-hook 'turn-on-font-lock)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Verilog
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle veripool/verilog-mode)
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))

(setq verilog-auto-newline nil)

;; User customization for Verilog mode
(setq verilog-indent-level             2
      verilog-indent-level-module      2
      verilog-indent-level-declaration 2
      verilog-indent-level-behavioral  2
      verilog-indent-level-directive   1
      verilog-case-indent              2
      verilog-auto-newline             nil
      verilog-auto-indent-on-newline   nil
      verilog-tab-always-indent        t
      verilog-auto-endcomments         t
      verilog-minimum-comment-distance 40
      verilog-indent-begin-after-if    t
;      verilog-auto-lineup              'declarations
      verilog-auto-lineup              nil
      verilog-highlight-p1800-keywords nil
;      verilog-linter                   "my_lint_shell_command"
      )


(defun toggle-verilog-auto-lineup ()
  "toggle verilog-auto-lineup"
  (interactive)
  (setq verilog-auto-lineup
   (case verilog-auto-lineup
    ('declarations 'nil)
    ('nil 'declarations)))
  (message "verilog-auto-lineup: %s" verilog-auto-lineup)
  )

;;(bind-key "C-c C-0" 'toggle-verilog-auto-lineup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; go
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle go)
(el-get-bundle company-go)
(use-package go
  :mode
  (("\\.go" . go-mode))
  )

(add-to-list 'exec-path (expand-file-name "~/usr/go/bin/"))
(use-package company-go)


;;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
;; Minor mode
;;-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;https://qiita.com/jabberwocky0139/items/86df1d3108e147c69e2c

(el-get-bundle helm)
(use-package helm
  :bind
  (("C-c h"   . helm-command-prefix)
   ("M-x"     . helm-M-x)
   ("C-x b"   . helm-mini)
   ("C-x C-f" . helm-find-files)
   ("C-c y"   . helm-show-kill-ring)
   ("C-c m"   . helm-man-woman)
   ("C-c o"   . helm-occur)
   :map helm-map
   ("C-h"     . delete-backward-char)
   ("<tab>"   . helm-execute-persistent-action)
   ("C-z"     . helm-select-action)
   :map helm-find-files-map
   ("C-h"     . delete-backward-char))
  :config
  (global-unset-key (kbd "C-x c"))
  ;(setq ad-return-value             (ad-get-arg 0))
  (setq helm-M-x-fuzzy-match        t)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-recentf-fuzzy-match    t)
  (setq helm-split-window-in-side-p t) ; open helm buffer inside current window, not occupy whole other window
  (setq helm-move-to-line-cycle-in-source t) ; move to end or beginning of source when reaching top or bottom of source
  (setq helm-ff-search-library-in-sexp        t) ; search for library in 'require' and 'declare-function' sexp
  (setq helm-scroll-amount                    8) ; scroll 8 lines other window using M-<next>/M-<prior>
  (setq helm-echo-input-in-header-line        t)
  (setq helm-ff-file-name-history-use-recentf t)
  ;(defadvice helm-buffers-sort-transformer (around ignore activate))
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  (helm-mode 1)
  ; :init
  ; (add-hook 'helm-minibuffer-set-up-hook)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; whitespace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package whitespace
  :ensure t
  :config
  (setq whitespace-style        '(face tabs tab-mark spaces space-mark))
  (setq whitespace-space-regexp "\\(\x3000+\\)")
  (setq whitespace-display-mappings
        '((space-mark ?\x3000 [?\□])
          (tab-mark   ?\t   [?\xBB ?\t])
          ))
  (global-whitespace-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eshell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package eshell
  :config
  (setq eshell-command-aliases-list
        (append
         (list
          (list "lr" "ls -atlr")
          (list "la" "ls -a")
          (list "ll" "ls -la")
          ))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SKK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle ddskk)
(use-package skk
  :config
  (setq skk-tut-file           "~/.emacs.d/el-get/ddskk/etc/SKK.tut")
  (setq skk-sticky-key         [muhenkan])      ;;無変換ボタンで漢字変換切り替えする
  (setq skk-isearch-start-mode 'latin)  ;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
  ;;(setq skk-byte-compile-init-file t)   ;;~/.skk にいっぱい設定を書いているのでバイトコンパイルしたい
  (defvar skk-auto-save-jisyo-interval 600) ;; 10 分放置すると個人辞書が自動的に保存される設定
  (defun skk-auto-save-jisyo () (skk-save-jisyo))
  (run-with-idle-timer skk-auto-save-jisyo-interval
                       skk-auto-save-jisyo-interval
                       'skk-auto-save-jisyo)
  :bind
  ("C-x C-j" . skk-mode)
  ("C-\\"    . skk-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; migemo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle migemo)
(setq migemo-command          "cmigemo")
(setq migemo-options          '("-q" "--emacs"))
(setq migemo-coding-system    'utf-8)
;(setq migemo-dictionary       "~/usr/share/migemo/utf-8/migemo-dict")
(setq migemo-dictionary       "~/.linuxbrew/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary  nil)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)

;; (use-package migemo
;;   :ensure t
;;   :config
;;   (setq migemo-command          "cmigemo")
;;   (setq migemo-options          '("-q" "--emacs"))
;;   (setq migemo-coding-system    'utf-8-unix)
;;   (setq migemo-dictionary       "~/.linuxbrew/share/migemo/utf-8/migemo-dict")
;;   (setq migemo-user-dictionary  nil)
;;   (setq migemo-regex-dictionary nil)
;;   (migemo-init)
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; expand region
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle expand-region)
(use-package expand-region
  :bind (("C-@"   . er/expand-region)     ;;リージョンを広げる
         ("C-M-@" . er/contract-region))) ;;リージョンを狭める

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; visual-regexp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle visual-regexp)
(use-package visual-regexp
  :bind
  ("M-%" . vr/query-replace)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo-tree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle undo-tree)
(use-package undo-tree
  :bind
  ("M-/" . undo-tree-redo)
  :config
  (global-undo-tree-mode t)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-save-buffers-enhanced
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle auto-save-buffers-enhanced)
(use-package auto-save-buffers-enhanced
  :bind
  ("C-x a s" . auto-save-buffers-enhanced-toggle-activity)
  :config
  (progn
    (setq auto-save-buffers-enhanced-include-regexps '(".+"))
    (setq auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$"))))

(auto-save-buffers-enhanced t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; aspell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;http://keisanbutsuriya.hateblo.jp/entry/2015/02/10/152543
(setq-default ispell-program-name "aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flyspell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;http://keisanbutsuriya.hateblo.jp/entry/2015/02/10/152543
;; (el-get-bundle flyspell)
;; (mapc
;;  (lambda (hook)
;;    (add-hook hook 'flyspell-prog-mode))
;;  '(
;;    c-mode-common-hook                 ;; ここに書いたモードではコメント領域のところだけ
;;    emacs-lisp-mode-hook               ;; flyspell-mode が有効になる
;;    ;; verilog-mode-hook
;;    ))
;; (mapc
;;  (lambda (hook)
;;    (add-hook hook
;;              '(lambda () (flyspell-mode 1))))
;;  '(
;;    yatex-mode-hook     ;; ここに書いたモードでは
;;    ;; flyspell-mode が有効になる
;;    ))

;; (global-set-key [?\C-,] 'flyspell-goto-next-error)
;; (global-set-key [?\C-.] 'flyspell-auto-correct-word)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; flycheck
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(require 'flycheck)
;;(add-hook 'verilog-mode-hook 'flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; comment-dwin2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://emacs.rubikitch.com/comment-dwim-2/
;; https://github.com/remyferre/comment-dwim-2
;; (el-get-bundle comment-dwim-2)
(use-package comment-dwim-2
  :ensure t
  :bind (("M-;" . comment-dwim-2))
  :config
  (progn
    (setq comment-dwim-2--inline-comment-behavior 'reindent-comment) ;;2回目のM-;で、コメントをインデントする
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;http://keisanbutsuriya.hateblo.jp/entry/2015/02/08/175005
;;http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part9

;; (el-get-bundle auto-complete)
;; (ac-config-default)
;; (setq ac-use-menu-map t) ;;補完メニュー表示時に、C-n/C-pで補完候補選択
;; (ac-set-trigger-key "TAB")     ;;自分のタイミングで補完開始

;; ;;自動的に有効にならないモードを追加する
;; (add-to-list 'ac-modes 'text-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;http://qiita.com/sune2/items/b73037f9e85962f5afb7

;(el-get-bundle company)
(use-package company
  :ensure t
  :config
  (global-company-mode) ;全バッファで使用
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; tail
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;https://www.emacswiki.org/emacs/TailEl
;;http://dev.ariel-networks.com/wp/documents/aritcles/emacs/part11
;(require 'tail)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; itail
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;http://emacs.rubikitch.com/itail/
(el-get-bundle itail)
(use-package itail
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Graphvis
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle graphviz-dot-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle elpa:markdown-mode)
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq markdown-command "pandoc -s --self-contained -t html5 -c /home/teppei/.pandoc/github.css")
  ;;(setq markdown-command "pandoc -s --self-contained -t html5 -c https://gist.github.com/andyferra/2554919.js")
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; linum-mode
;; http://d.hatena.ne.jp/tm_tn/20110605/1307238416
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle elpa:hlinum)

;; M-x linum-mode
;; で、左に行番号を表示する。

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cmake-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle cmake-mode)
(use-package cmake-mode-abbrev-table
  :mode (("CMakeLists\\.txt\\'" . cmake-mode))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://qiita.com/blue0513/items/c0dc35a880170997c3f5
;; (use-package ivy
;;   :ensure t
;;   :config
;;   (ivy-mode t)
;;   (setq ivy-use-virtual-buffers t)
;;   (setq enable-recursive-minibuffers t)
;;   (setq ivy-height 30) ;; minibufferのサイズを拡大
;;   (setq ivy-extra-directories nil)
;;   (setq ivy-re-builders-alist '((t . ivy--regex-plus))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; counsel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://qiita.com/blue0513/items/c0dc35a880170997c3f5
;(el-get-bundle counsel)
;; (use-package counsel
;;   :ensure t
;;   :config
;;    (global-set-key (kbd "M-x")     'counsel-M-x)
;;    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;    (defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))
;;   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; recentf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;https://qiita.com/blue0513/items/c0dc35a880170997c3f5
;; 余分なメッセージを削除しておきましょう
;; https://qiita.com/blue0513/items/c0dc35a880170997c3f5
(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))

(use-package recentf
  :ensure t
  :init
  (el-get-bundle recentf-ext)
  :config
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-max-saved-items 200)   ;;recentfに保存するファイル数
  (setq recentf-exclude '(".recentf")) ;;.recentfは含めない
  (setq recentf-auto-cleanup 'never)   ;;保存する内容を整理
  (run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list))))
  ;(require 'recentf-ext)
  (define-key global-map [(super r)] 'counsel-recentf) ;; counselにおまかせ！
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dumb-jump
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;https://qiita.com/blue0513/items/c0dc35a880170997c3f5
(use-package dumb-jump
  :ensure t
  :config
;  (setq dumb-jump-selector 'ivy)
  (setq dumb-jump-force-searcher 'ag)
;  (setq dumb-jump-use-visible-window nil)
  (setq dumb-jump-default-project "")
;  (define-key global-map [(super d)]       'dump-jump-go)
;  (define-key global-map [(super shift d)] 'dumb-jump-back)
  (dumb-jump-mode)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; symbol-overlay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package symbol-overlay
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'symbol-overlay-mode)
  (add-hook 'markdown-mode-hook #'symbol-overlay-mode)
  (global-set-key (kbd "M-i") 'symbol-overlay-put)
  (define-key symbol-overlay-map (kbd "p") 'symbol-overlay-jump-prev) ;; 次のシンボルへ
  (define-key symbol-overlay-map (kbd "n") 'symbol-overlay-jump-next) ;; 前のシンボルへ
  (define-key symbol-overlay-map (kbd "C-g") 'symbol-overlay-remove-all) ;; ハイライトキャンセル
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; neotree
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package neotree
  :ensure t
  :config
  (setq neo-theme 'ascii) ;; icon, classic等もあるよ！
  (setq neo-persist-show t) ;; delete-other-window で neotree ウィンドウを消さない
  (setq neo-smart-open t) ;; neotree ウィンドウを表示する毎に current file のあるディレクトリを表示する
  (setq neo-smart-open t)
;  (global-set-key "\C-o" 'neotree-toggle)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; which-key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle which-key)
(use-package which-key
  ;:ensure t
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フォントとウィンドウサイズ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq initial-frame-alist
      (append (list
               '(width . 100)
               '(height . 48)
               '(top . 30)
               ;'(left . 2000)
               '(left . 20)
               )
              initial-frame-alist))
(setq default-frame-alist initial-frame-alist)

(add-to-list 'default-frame-alist '(font . "Source Han Code JP N-10"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (neotree symbol-overlay which-key helm skk migemo ddskk dumb-jump counsel-mode counsel markdown-mode itail go company-go comment-dwim-2 bind-key auto-save-buffers-enhanced))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:family "Source Han Code JP N-10"))))
 '(markdown-pre-face ((t (:family "Source Han Code JP N-10")))))
