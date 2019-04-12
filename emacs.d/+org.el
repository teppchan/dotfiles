;; -*- coding:utf-8-unix mode:lisp -*-

(use-package org
  :custom
  (org-directory "~/org/")
  (task-file    (concat org-directory "task.org"))
  (todo-file    (concat org-directory "todo.org"))
  (journal-file (concat org-directory "journal.org"))
  (org-capture-templates
   '(("t" "Todo" entry (file+headline todo-file "Tasks")
      "* TODO %?\n  %i\n  %a")
     ("j" "Journal" entry (file+datetree journal-file)
      "* %?\nEntered on %U  %i\n  %a")))
 ) 

(use-package org-pomodoro
  :after org-agenda
  )

(use-package org-bullets
  :hook
  (org-mode . org-bullets-mode))
