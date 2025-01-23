;;; project-org-todo-capture.el --- Create TODOs for a project
;;
;; maintained in project-org-todo-capture.org
;;
;; Author: rileyrg <rileyrg@gmx.de>
;; Created: 22 January 2025
;; Keywords: org project todo tasks capture
;; Version : 1.1
;; Package-Requires: ((emacs "25.1")
;; Optional :
;; URL: git@github.com/rileyrg/project-org-todo-capture.git

;;; commentary:
;;
;; Usage example:
;;       (use-package project-org-todo-capture
;;       :bind (:map project-prefix-map
;;               (("t" . project-org-todo-capture)
;;              (("T" . project-org-todo-capture-file-open)))))
;;
;; customization:
;;   see project-org-todo-capture*
;;
;;; code:

(require 'project)
(require 'org-capture)


(defcustom project-org-todo-capture-template '("p" "Project" entry (file+headline project-org-todo-capture-file  "Project Tasks") "* TODO %?\12:PROPERTIES:\12:DateCreated: %T\12:END:\12%i\12%a") "project todo template")
(defcustom project-org-todo-capture-default-file "TODO.org" "default project tasks file. override with .dir-locals.el")
(defcustom project-org-todo-capture-auto-append-to-agenda t "When creating a new project todo file, auto  add to agenda files")


(push project-org-todo-capture-template org-capture-templates)

(defun project-org-todo-capture-file()
  ;; locate project todo file. create if not found .
  (let ((l (expand-file-name project-org-todo-capture-default-file (project-root (project-current t)))))
    ;; create project todo file if it doesnt exist and append to agenda files if  project-org-todo-capture-auto-append-to-agenda is set.
    (if (or (file-exists-p  l) (write-region "" nil l) t)
        (progn
          (when project-org-todo-capture-auto-append-to-agenda
            (when (not (member l org-agenda-files)) 
              (with-current-buffer (find-file-noselect l)
                (org-agenda-file-to-front))))
          l)
      nil)))

(defun project-org-todo-capture-file-open()
  "open the project TODO file"
  (interactive)
  (find-file (project-org-todo-capture-file)))


(defun project-org-todo-capture()
  (interactive)
  (org-capture nil "p"))

(provide 'project-org-todo-capture)
