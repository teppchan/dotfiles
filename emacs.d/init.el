;;init.el

;use-packageが無いときにエラーがでないようにする
;http://qiita.com/kai2nenobu/items/5dfae3767514584f5220
;; (unless (require 'use-package nil t)
;;   (defmacro use-package (&rest args)))

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cask
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'cask "~/.cask/cask.el")
;; (cask-initialize)


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
;(add-to-list 'package-archives '("melpa-stable" . "https://melpa.org/packages/") t)
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

(use-package whitespace
  :config
  (progn
    (setq whitespace-style '(face tabs tab-mark spaces space-mark))
    (setq whitespace-space-regexp "\\(\x3000+\\)")
    (setq whitespace-display-mappings
          '((space-mark ?\x3000 [?\□])
            (tab-mark   ?\t   [?\xBB ?\t])
            ))
    (global-whitespace-mode 1)))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Anthy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load-library "anthy")
;; (setq default-input-method "japanese-anthy")
;; (autoload 'boiling-rK-trans "boiling-anthy" "romaji-kanji conversion" t)
;; (autoload 'boiling-rhkR-trans "boiling-anthy" "romaji-kana conversion" t)
;; (global-set-key "\C-t" 'boiling-rK-trans)
;; (global-set-key "\M-t" 'boiling-rhkR-trans)
;; (if (>= emacs-major-version 22)
;;     (setq anthy-accept-timeout 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SKK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle ddskk)
(setq skk-tut-file "/home/teppei/.emacs.d/el-get/ddskk/etc/SKK.tut")
(use-package skk
  :bind (("C-x C-j" . skk-mode)
         ("C-\\"    . skk-mode))
  :config
  (progn
    (setq skk-sticky-key [muhenkan])      ;;無変換ボタンで漢字変換切り替えする
    (setq skk-isearch-start-mode 'latin)  ;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
    ;;(setq skk-byte-compile-init-file t)   ;;~/.skk にいっぱい設定を書いているのでバイトコンパイルしたい
    (defvar skk-auto-save-jisyo-interval 600) ;; 10 分放置すると個人辞書が自動的に保存される設定
    (defun skk-auto-save-jisyo () (skk-save-jisyo))
    (run-with-idle-timer skk-auto-save-jisyo-interval
                         skk-auto-save-jisyo-interval
                         'skk-auto-save-jisyo)
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; migemo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle migemo)
(setq migemo-dictionary       "/home/teppei/usr/share/migemo/utf-8/migemo-dict")
(setq migemo-command          "cmigemo")
(setq migemo-options          '("-q" "--emacs"))
(setq migemo-user-dictionary  nil)
(setq migemo-coding-system    'utf-8)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)

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
;; (require 'undo-tree)
;; (global-undo-tree-mode t)
;; (global-set-key (kbd "M-/") 'undo-tree-redo)

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
      verilog-auto-lineup              'declarations
      verilog-highlight-p1800-keywords nil
;      verilog-linter                   "my_lint_shell_command"
      )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'helm-config)
;; (helm-mode 1)
;; (helm-migemo-mode 1)

;; ;; C-hで前の文字削除
;; (define-key helm-map (kbd "C-h") 'delete-backward-char)
;; (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

;; (require 'helm-Ag)
;; (setq helm-ag-base-command "ag --nocolor --nogrou")
;; (global-set-key (kbd "C-c s") 'helm-ag)

;; ;; キーバインド
;; ;;(define-key global-map (kbd "C-x b")   'helm-buffers-list)
;; (define-key global-map (kbd "C-x b") 'helm-for-files)
;; (define-key global-map (kbd "C-x C-f") 'helm-find-files)
;; (define-key global-map (kbd "M-x")     'helm-M-x)
;; (define-key global-map (kbd "M-y")     'helm-show-kill-ring)

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
;; フォントとウィンドウサイズ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq initial-frame-alist
      (append (list
               '(width . 100)
               '(height . 48)
               '(top . 30)
               '(left . 2000)
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
    (comment-dwim-2 auto-save-buffers-enhanced bind-key))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
