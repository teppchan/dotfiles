;;; *- lexical-binding: t; coding: utf-8-unix -*-

(use-package verilog-mode
  :quelpa (verilog-mode :fetcher github :repo "veripool/verilog-mode")
  :mode (("\\.[ds]?vh?\\'" . verilog-mode))
  :hook
  ;;https://emacs.stackexchange.com/questions/38468/disable-autocompletion-abbreviation-in-verilog-mode
  (verilog-mode . (lambda () (clear-abbrev-table verilog-mode-abbrev-table)))
  :custom
  (verilog-indent-level             2)
  (verilog-indent-level-module      2)
  (verilog-indent-level-declaration 2)
  (verilog-indent-level-behavioral  2)
  (verilog-indent-level-directive   1)
  (verilog-case-indent              2)
  (verilog-auto-newline             nil)
  (verilog-auto-indent-on-newline   nil)
  (verilog-tab-always-indent        t)
  (verilog-auto-endcomments         nil)
  (verilog-minimum-comment-distance 40)
  (verilog-indent-begin-after-if    nil)
  (verilog-auto-lineup              nil)
  (verilog-highlight-p1800-keywords nil))


(use-package veri-kompass
  :diminish veri-kompass-minor-mode
  :hook (verilog-mode . veri-kompass-minor-mode))
