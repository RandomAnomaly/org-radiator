(setq inhibit-startup-message t)

(setq revert-without-query '(".*"))
(global-auto-revert-mode 1)

(setq org-agenda-window-setup 'current-window)

(setq org-agenda-sticky t)

(setq org-agenda-files '("~/org/gtd.org" "~/org/tickler.org"))
 (require 'org-habit)
 (setq org-agenda-window-setup 'current-window)

 (defun org-current-is-todo ()
   (string= "TODO" (org-get-todo-state)))

 (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "DELEGATED(l)" "|" "DONE(d)" "CANCELLED(c)")))


(fset 'refresh-agenda
   "r")

(setq org-agenda-custom-commands 
      '(("o" "At the office" tags-todo "@work"
         ((org-agenda-overriding-header "Office")
          (org-agenda-skip-function '(my-org-agenda-skip-all-siblings-but-first))))
	("h" "At home" tags-todo "@home"
         ((org-agenda-overriding-header "Home")
          (org-agenda-skip-function '(my-org-agenda-skip-all-siblings-but-first))))
	("e" "errands" tags-todo "@errands"
         ((org-agenda-overriding-header "Errands")
          ))
	("r" "Reading list" tags-todo "@readinglist"
         ((org-agenda-overriding-header "Reading list")
          (org-agenda-skip-function '(my-org-agenda-skip-all-siblings-but-first))))
	))

(defun org-agenda-skip-if-scheduled-later ()
"If this function returns nil, the current match should not be skipped.
Otherwise, the function must return a position from where the search
should be continued."
  (ignore-errors
    (let ((subtree-end (save-excursion (org-end-of-subtree t)))
          (scheduled-seconds
            (time-to-seconds
              (org-time-string-to-time
                (org-entry-get nil "SCHEDULED"))))
          (now (time-to-seconds (current-time))))
       (and scheduled-seconds
            (>= scheduled-seconds now)
            subtree-end))))

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


(setq org-agenda-todo-ignore-scheduled 'future)
(setq org-agenda-tags-todo-honor-ignore-options t)

(setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
         (timeline . "  % s")
         (todo .
               " %i %-12:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
         (tags .
               " %i %-12:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
         (search . " %i %-12:c"))
      )

(setq agenda-keys '("a" "o" "h"))
(setq agenda-buffer-names '("*Org Agenda(a)*" "*Org Agenda(o:@work)*" "*Org Agenda(h:@home)*"))

(dolist (word agenda-keys)
  (org-agenda nil word)
  )

(defun syntactic-sugar/setup-agenda-windows ()
   ""
   (interactive)
   (split-window-horizontally)
   (other-window 1)
   (split-window-vertically)
   (other-window 2)
     (let ((i 0))
       (while (< i (length agenda-buffer-names))
	 (message (nth i agenda-buffer-names))
	 (set-window-buffer (nth i (window-list)) (nth i agenda-buffer-names))
	 (setq i (+ i 1))
	 )
       )
     )
(syntactic-sugar/setup-agenda-windows)

(defun syntactic-sugar/refresh-agendas ()
  ""
  (interactive)
  (when (and (file-exists-p "~/org/gtd.org") (file-exists-p "~/org/tickler.org"))
    (let ((i 0))
      (while (< i (length agenda-buffer-names))
	(let ((command-letter (nth i agenda-keys))(agenda-buffer-name (nth i agenda-buffer-names)))
	  (message command-letter)
	  (message agenda-buffer-name)
	  (org-agenda nil command-letter)
	  (let ((agenda-window (get-buffer-window agenda-buffer-name t)))
	    (when agenda-window
	      (with-selected-window agenda-window (org-agenda-redo))))
	  (setq i (+ i 1))
	  )))))


(run-at-time nil 15 'syntactic-sugar/refresh-agendas)
