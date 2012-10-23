;(set-language-environment 'Japanese)

(setq load-path
      (append
       (list (expand-file-name "~/lisp")) load-path))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(tool-bar-mode 0)

;;(define-key global-map [?¥] [?\\])  ;; ¥の代わりにバックスラッシュを入力する
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-?" 'help-for-help)
(global-set-key [f1] 'help-for-help)
(global-set-key "\M-g" 'goto-line) ;; M-g で指定行へ移動
(global-set-key "\C-co" 'comment-or-uncomment-region)

;; マウスで選択するとコピーする
(setq mouse-drag-copy-region t)

;;http://hylom.net/2012/08/08/emacs-24-on-mac-os-x/
(setq mac-option-modifier nil)   ;;optionキーをoptionキーとして設定
(setq mac-command-modifier 'meta)  ;;commandキーをmetaキーとして設定
(global-set-key (kbd "C-M-¥") 'indent-region) ;;

;; 改行キーでオートインデント
;(define-key global-map "\C-m" 'newline-and-indent)
;(setq indent-line-function 'indent-relative-maybe)

;;;http://meadow-faq.sourceforge.net/meadow-faq-ja_4.html#SEC78
;; 一行ずつスクロール
(defun scroll-up-one-line ()
  (interactive)
  (scroll-up 1))
(defun scroll-down-one-line ()
  (interactive)
  (scroll-down 1))
(global-set-key [?\C-,] 'scroll-up-one-line)
(global-set-key [?\C-.] 'scroll-down-one-line)

;; TAB はスペース 4 個ぶんを基本
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; モードラインにライン数、カラム数表示
(line-number-mode 1)
(column-number-mode 1)

;; 対応するカッコを色表示する
(show-paren-mode 1)

;;コマンドキーをMetaキーとして利用
(setq mac-command-key-is-meta t)

;;動的略語展開で大文字小文字を区別
;(setq dabbrev-case-fold-search nil)

;;大文字小文字区別しない
(setq read-file-name-completion-ignore-case t)

;;(require 'auto-save-buffers)
;;(run-with-idle-timer 0.5 t 'auto-save-buffers)
;;(require 'my-auto-save-buffer 10)

(require 'auto-save-buffers)
(run-with-idle-timer 0.5 t 'auto-save-buffers)


;;;http://www.bookshelf.jp/soft/meadow_31.html#SEC417
;; 10 回ごとに加速
(defvar scroll-speedup-count 10)
;; 10 回下カーソルを入力すると，次からは 1+1 で 2 行ずつの
;; 移動になる
(defvar scroll-speedup-rate 1)
;; 800ms 経過したら通常のスクロールに戻す
(defvar scroll-speedup-time 800)

;; 以下，内部変数
(defvar scroll-step-default 1)
(defvar scroll-step-count 1)
(defvar scroll-speedup-zero (current-time))

(defun scroll-speedup-setspeed ()
  (let* ((now (current-time))
         (min (- (car now)
                 (car scroll-speedup-zero)))
         (sec (- (car (cdr now))
                 (car (cdr scroll-speedup-zero))))
         (msec
          (/ (- (car (cdr (cdr now)))
                (car
                 (cdr (cdr scroll-speedup-zero))))
                     1000))
         (lag
          (+ (* 60000 min)
             (* 1000 sec) msec)))
    (if (> lag scroll-speedup-time)
        (progn
          (setq scroll-step-default 1)
          (setq scroll-step-count 1))
      (setq scroll-step-count
            (+ 1 scroll-step-count)))
    (setq scroll-speedup-zero (current-time))))

(defun scroll-speedup-next-line (arg)
  (if (= (% scroll-step-count
            scroll-speedup-count) 0)
      (setq scroll-step-default
            (+ scroll-speedup-rate
               scroll-step-default)))
  (if (string= arg 'next)
      (line-move scroll-step-default)
    (line-move (* -1 scroll-step-default))))

(defadvice next-line
  (around next-line-speedup activate)
  (if (and (string= last-command 'next-line)
           (interactive-p))
      (progn
        (scroll-speedup-setspeed)
        (condition-case err
            (scroll-speedup-next-line 'next)
          (error
           (if (and
                next-line-add-newlines
                (save-excursion
                  (end-of-line) (eobp)))
               (let ((abbrev-mode nil))
                 (end-of-line)
                 (insert "\n"))
             (line-move 1)))))
    (setq scroll-step-default 1)
    (setq scroll-step-count 1)
    ad-do-it))

(defadvice previous-line
  (around previous-line-speedup activate)
  (if (and
       (string= last-command 'previous-line)
       (interactive-p))
      (progn
        (scroll-speedup-setspeed)
        (scroll-speedup-next-line 'previous))
    (setq scroll-step-default 1)
    (setq scroll-step-count 1)
    ad-do-it))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SKK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(require 'skk-autoloads)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xt" 'skk-tutorial)
;; Specify dictionary location
(setq skk-large-jisyo "/Applications/Emacs.app/Contents/Resources/etc/skk/SKK-JISYO.L")
;; Specify tutorial location
(setq skk-tut-file "/Applications/Emacs.app/Contents/Resources/etc/skk/SKK.tut")

(add-hook 'isearch-mode-hook
	  (function (lambda ()
		      (and (boundp 'skk-mode) skk-mode
			   (skk-isearch-mode-setup)))))

(add-hook 'isearch-mode-end-hook
	  (function
	   (lambda ()
	     (and (boundp 'skk-mode) skk-mode (skk-isearch-mode-cleanup))
	     (and (boundp 'skk-mode-invoked) skk-mode-invoked
		  (skk-set-cursor-properly)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Verilog
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq verilog-auto-newline nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ActionScript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'actionscript-mode "actionscript-mode" "actionscript" t)
(setq auto-mode-alist
      (append '(("\\.as$" . actionscript-mode))
              auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Haskell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(load "~/lisp/haskell-mode-2.4/haskell-site-file")

(append auto-mode-alist
        '(("¥¥.hs$" . 'haskell-mode)
          ("¥¥.hi$" . 'haskell-mode)
          ("¥¥.lhs$" . 'literate-haskell-mode)))
4967733
(autoload 'haskell-mode "haskell-mode"
  "Majour mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Majour mode for editing literate Haskell scripts." t)

(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
(add-hook 'haskell-mode-hook 'font-lock-mode)

(setq haskell-literate-default 'latex)
(setq haskell-doc-idle-delay 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Coffee Script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/lisp/coffee-mode")
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; font
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;https://gist.github.com/3465571
(when (and (>= emacs-major-version 24)
           (eq window-system 'ns))
  ;; フォントセットを作る
  (let* ((fontset-name "myfonts") ; フォントセットの名前
         (size 14) ; ASCIIフォントのサイズ [9/10/12/14/15/17/19/20/...]
         (asciifont "Menlo") ; ASCIIフォント
         (jpfont "Hiragino Maru Gothic ProN") ; 日本語フォント
         (font (format "%s-%d:weight=normal:slant=normal" asciifont size))
         (fontspec (font-spec :family asciifont))
         (jp-fontspec (font-spec :family jpfont)) 
         (fsn (create-fontset-from-ascii-font font nil fontset-name)))
    (set-fontset-font fsn 'japanese-jisx0213.2004-1 jp-fontspec)
    (set-fontset-font fsn 'japanese-jisx0213-2 jp-fontspec)
    (set-fontset-font fsn 'katakana-jisx0201 jp-fontspec) ; 半角カナ
    (set-fontset-font fsn '(#x0080 . #x024F) fontspec)    ; 分音符付きラテン
    (set-fontset-font fsn '(#x0370 . #x03FF) fontspec)    ; ギリシャ文字
    )

  ;; デフォルトのフレームパラメータでフォントセットを指定
  (add-to-list 'default-frame-alist '(font . "fontset-myfonts"))

  ;; フォントサイズの比を設定
  (dolist (elt '(("^-apple-hiragino.*"               . 1.2)
		 (".*osaka-bold.*"                   . 1.2)
		 (".*osaka-medium.*"                 . 1.2)
		 (".*courier-bold-.*-mac-roman"      . 1.0)
		 (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
		 (".*monaco-bold-.*-mac-roman"       . 0.9)))
    (add-to-list 'face-font-rescale-alist elt))

  ;; デフォルトフェイスにフォントセットを設定
  ;; # これは起動時に default-frame-alist に従ったフレームが
  ;; # 作成されない現象への対処
  (set-face-font 'default "fontset-myfonts"))
