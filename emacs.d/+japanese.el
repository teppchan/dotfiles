;;; ~/.doom.d/+japanese.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SKK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ddskk
  :config
  (setq default-input-method "japanese-skk")
  (setq skk-user-viper       nil)
  :bind
  ("C-\\" . skk-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; migemo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package migemo
  :config
  (setq migemo-command             "cmigemo")
  (setq migemo-options             '("-q" "--emacs" "-i" "\a"))
  (setq migemo-user-dictionary     nil)
  (setq migemo-regex-dictionary    nil)
  (setq migemo-coding-system       'utf-8-unix)
  (setq search-default-regexp-mode nil)
  (setq migemo-dictionary          "/home/teppei/.linuxbrew/share/migemo/utf-8/migemo-dict")
  (setq migemo-pattern-alist-file  (expand-file-name ".cache/migemo/migemo-pattern" user-emacs-directory))
  (setq migemo-frequent-pattern-alist-file (expand-file-name ".cache/migemo/migemo-frequent" user-emacs-directory))
  (migemo-init))

(use-package avy-migemo
  :hook (after-init . avy-migemo-mode)
  :custom
  (avy-timeout-seconds nil)
  ;:bind
  ;("C-M-;" . avy-migemo-goto-char-timer)
  :config
  (require 'avy-migemo-e.g.swiper))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; japaese holiday
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package japanese-holidays
  :init
  (add-hook 'calendar-today-visible-hook   'japanese-holiday-mark-weekend)
  (add-hook 'calendar-today-invisible-hook 'japanese-holiday-mark-weekend)
  (add-hook 'calendar-today-visible-hook   'calendar-mark-today)
  :config
  (setq calendar-holidays               ; とりあえず日本のみを表示
        (append japanese-holidays holiday-local-holidays)
        mark-holidays-in-calendar t     ; 祝日をカレンダーに表示
        ;; calendar-month-name-array       ; 月と曜日の表示調整
        ;; ["01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" ]
        ;; calendar-day-name-array
        ;; ["日" "月" "火" "水" "木" "金" "土"]
        ;; calendar-day-header-array
        ;; ["日" "月" "火" "水" "木" "金" "土"]
        calendar-date-style 'iso         ; ISO format (YYYY/MM/DD) に変更
        japanese-holiday-weekend '(0 6)  ; 土曜日・日曜日を祝日として表示
        japanese-holiday-weekend-marker
        '(holiday nil nil nil nil nil japanese-holiday-saturday)
        ;; 日曜開始
        calendar-week-start-day 0)
  (calendar-set-date-style 'iso)
   )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pangu-spacing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package pangu-spacing
  :init
  (progn ;; replacing `chinese-two-byte' by `japanese'
    (setq pangu-spacing-chinese-before-english-regexp
          (rx (group-n 1 (category japanese))
              (group-n 2 (in "a-zA-Z0-9"))))
    (setq pangu-spacing-chinese-after-english-regexp
          (rx (group-n 1 (in "a-zA-Z0-9"))
              (group-n 2 (category japanese))))
    (setq pangu-spacing-real-insert-separtor t)
    ;; (global-pangu-spacing-mode 1)
    (add-hook 'text-mode-hook 'pangu-spacing-mode)))

