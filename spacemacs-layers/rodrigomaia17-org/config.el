(setq
 ;; set up org mode
 org-log-done 'time
 org-startup-indented t
 org-startup-folded "content"
 org-directory "~/notas"
 org-enable-org-journal-support t org-journal-dir "~/notas/journal/"
 org-journal-date-format "%A, %B %d %Y"
 org-agenda-todo-ignore-scheduled 'future  ;; Ignore todos for 5 days in the future
 org-agenda-todo-ignore-timestamp 5  ;; Ignore todos for 5 days in the future
 org-agenda-tags-todo-honor-ignore-options t
 org-agenda-skip-scheduled-if-done t
 org-agenda-skip-deadline-if-done t
 org-agenda-start-on-weekday nil
 org-enforce-todo-dependencies t
 org-want-todo-bindings t
 org-journal-time-prefix "* ")

(setq org-modules '(org-bbdb
                    org-gnus
                    org-checklist
                    org-drill
                    org-info
                    org-jsinfo
                    org-habit
                    org-irc
                    org-mouse
                    org-protocol
                    org-annotate-file
                    org-eval
                    org-expiry
                    org-interactive-query
                    org-man
                    org-collector
                    org-panel
                    org-screen
                    org-toc))
(eval-after-load 'org
  '(org-load-modules-maybe t))
;; Prepare stuff for org-export-backends
(setq org-export-backends '(org latex icalendar html ascii))

;; org-habit
(setq org-habit-following-days 4)
(setq org-habit-show-all-today t) ;; show completed tasks too
;;(setq org-habit-show-habits-only-for-today nil)

;; gtd in org-mode https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html

(setq org-agenda-files '("~/notas/inbox.org"
                         "~/notas/gtd.org"
                         "~/notas/saude.org"
                         "~/notas/tickler.org"))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/notas/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/notas/tickler.org" "Tickler")
                               "* %i%? \n %U")
                              ))

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)
                           ("~/notas/someday.org" :level . 1)
                           ("~/notas/trash.org" :level . 1)
                           ))

(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
;; explanation: https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html

(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))


(setq org-agenda-custom-commands
      '(("n" "Agenda and all TODOs"
  ((agenda "")
   (alltodo ""
     ((org-agenda-skip-function 'my-org-agenda-skip-all-siblings-but-first)))))))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(defun open-inbox-file ()
  (interactive)
  (find-file "~/notas/inbox.org"))
(spacemacs/set-leader-keys "oi" 'open-inbox-file)

(defun open-gtd-file ()
  (interactive)
  (find-file "~/notas/gtd.org"))
(spacemacs/set-leader-keys "og" 'open-gtd-file)

(defun open-someday-file ()
  (interactive)
  (find-file "~/notas/someday.org"))
(spacemacs/set-leader-keys "os" 'open-someday-file)

(defun open-tickler-file ()
  (interactive)
  (find-file "~/notas/tickler.org"))
(spacemacs/set-leader-keys "ot" 'open-tickler-file)

:init
(setq org-brain-path "~/notas/brain")
(with-eval-after-load 'evil
  (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
