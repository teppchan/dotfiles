;; -*- coding:utf-8-unix mode:lisp -*- 

(if window-system
    (progn
      ;; UI parts
      (toggle-scroll-bar 0)
      (tool-bar-mode 0)
      (menu-bar-mode 0)

      ;; Japanese font settings
      (defun set-japanese-font (family)
	(set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208        (font-spec :family family))
	(set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0212        (font-spec :family family))
	(set-fontset-font (frame-parameter nil 'font) 'katakana-jisx0201        (font-spec :family family)))

      ;; Overwrite latin and greek char's font
      (defun set-latin-and-greek-font (family)
	(set-fontset-font (frame-parameter nil 'font) '(#x0250 . #x02AF) (font-spec :family family)) ; IPA extensions
	(set-fontset-font (frame-parameter nil 'font) '(#x00A0 . #x00FF) (font-spec :family family)) ; latin-1
	(set-fontset-font (frame-parameter nil 'font) '(#x0100 . #x017F) (font-spec :family family)) ; latin extended-A
	(set-fontset-font (frame-parameter nil 'font) '(#x0180 . #x024F) (font-spec :family family)) ; latin extended-B
	(set-fontset-font (frame-parameter nil 'font) '(#x2018 . #x2019) (font-spec :family family)) ; end quote
	(set-fontset-font (frame-parameter nil 'font) '(#x2588 . #x2588) (font-spec :family family)) ; 
	(set-fontset-font (frame-parameter nil 'font) '(#x0370 . #x03FF) (font-spec :family family)))

      (setq use-default-font-for-symbols nil)
      (setq inhibit-compacting-font-caches t)
      (setq jp-font-family "SF Mono Square")
      (setq default-font-family "FuraCode Nerd Font")

      ;; (set-face-attribute 'default nil :family default-font-family)
      (when (eq system-type 'darwin)
		(set-face-attribute 'default nil :family jp-font-family :height 135))
      (when (eq system-type 'gnu/linux)
		(set-face-attribute 'default nil :family jp-font-family :height 135))
      (set-japanese-font jp-font-family)
      (set-latin-and-greek-font default-font-family)
      (add-to-list 'face-font-rescale-alist (cons default-font-family 0.86))
      (add-to-list 'face-font-rescale-alist (cons jp-font-family 1.0))
      ))
