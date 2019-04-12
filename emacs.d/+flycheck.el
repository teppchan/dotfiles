;;; ~/.doom.d/+flycheck.el -*- lexical-binding: t; -*-

(use-package flycheck
 :config
 ;; irun
  (flycheck-def-option-var flycheck-irun-library-directories nil verilog-irun
                           "A list of include directories for irun."
                           :type '(repeat (directory :tag "Library directory"))
                           :safe #'flycheck-stirng-lint-p
                           :package-version '(flycheck . "0.10"))
  (flycheck-def-option-var flycheck-irun-library-files nil verilog-irun
                           "A list of include files for irun"
                           :type '(repeat (file :tag "Include file"))
                           :safe #'flycheck-string-list-p
                           :package-version '(flycheck . "0.10"))
  (flycheck-def-option-var flycheck-irun-definitions nil verilog-irun
                           "Additional preprocessor definitions for irun"
                           :type '(repeat (string :tag "Definition"))
                           :safe #'flycheck-string-list-p
                           :package-version '(flycheck . "0.10"))
  (flycheck-def-option-var flycheck-irun-library-flags nil verilog-irun
                           "Additonal flags for irun"
                           :type '(repeat (string :tag "Flag"))
                           :safe #'flycheck-string-list-p
                           :package-version '(flycheck . "0.10"))

  (flycheck-define-checker verilog-irun
    "A linter for Verilog."
    :command ("/home/teppei/mybin/irun_compile.sh"
              (option-list "-y "      flycheck-irun-library-directories concat)
              (option-list " "        flycheck-irun-library-files       concat)
              (option-list "-define " flycheck-irun-definitions         concat)
              (option-list " "        flycheck-irun-library-flags       concat)
              source)
    :error-patterns
    ((warning line-start (zero-or-more not-newline) "*W," (zero-or-more not-newline)
              " (" (file-name) "," line "|" column "): " (message) line-end)
     (error   line-start (zero-or-more not-newline) "*E," (zero-or-more not-newline)
              " (" (file-name) "," line "|" column "): " (message) line-end))
    :modes verilog-mode)

  (add-hook 'verilog-mode-hook
            '(lambda ()
               (setq flycheck-checker 'verilog-irun)
                     (flycheck-mode 1)))

  (add-to-list 'flycheck-checkers 'verilog-irun))
