(setq user-full-name "Ravi Srinivasan"
      user-mail-address "rsriniva@redhat.com")

;; Update package-archive lists
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

;; Install 'use-package' if necessary
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))

;;; Validation
(use-package validate                   ; Validate options
  :ensure t)

(use-package exec-path-from-shell       ; Set up environment variables
  :ensure t
  :if (display-graphic-p)
  :config
  (validate-setq exec-path-from-shell-variables
                 '("PATH"               ; Full path
                   )))

  (exec-path-from-shell-initialize)

;; Disable start screen
(setq inhibit-startup-screen t

;; Disable lockfiles
create-lockfiles nil

 ;; Always follow symbolic links to version controlled files
vc-follow-symlinks t

 ;; Mac ls does not implement --dired
dired-use-ls-dired nil

;; Show buffer name in title bar
 frame-title-format '("%b")

;; Default to Unix LF line endings
 buffer-file-coding-system 'utf-8-unix

;; bashate
 sh-basic-offset 2
 sh-indentation 2
 
;; Minibuffer line and column
line-number-mode t
column-number-mode t)

;; Enable Ido for case-aware fuzzy finding
(ido-mode)

(use-package solarized-theme
  :ensure t)

;; default font on Mac
(set-face-attribute 'default nil :font "-outline-Monaco-normal-normal-normal-mono-14-*-*-*-c-*-iso8859-1")

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

;; turn off annoying bell
(setq ring-bell-function 'ignore)

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;; turn on bracket match highlight
(show-paren-mode 1)

;; auto insert closing bracket
(electric-pair-mode 1)

;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

;; UTF-8 as default encoding
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; when a file is updated outside emacs, make it update if it's already opened in emacs
(global-auto-revert-mode 1)

;; keep a list of recently opened files
(require 'recentf)
(recentf-mode 1)

;; save/restore opened files
(desktop-save-mode 1)

;; wrap long lines by word boundary, and arrow up/down move by visual line, etc
(global-visual-line-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(progn
  ;; make indentation commands use space only (never tab character)
  (setq-default indent-tabs-mode nil))

;; set default tab char's display width to 4 spaces
(setq-default tab-width 4)

;; Makes *scratch* empty.
(setq initial-scratch-message "")

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)

(use-package yasnippet
  :ensure t)

(yas-global-mode 1)

(setq inhibit-startup-message t
      initial-scratch-message ""
      inhibit-startup-echo-area-message t
      menu-bar-mode nil)

(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;; docker
(use-package docker
  :commands docker-mode
  :ensure t)

(use-package dockerfile-mode
  :mode "Dockerfile.*\\'"
  :ensure t)

(defun wrap-xml-tag (tagName)
  "Add a tag to beginning and ending of current word or text selection."
  (interactive "sEnter tag name: ")
  (let (p1 p2 inputText)
    (if (use-region-p)
        (progn
          (setq p1 (region-beginning) )
          (setq p2 (region-end) )
          )
      (let ((bds (bounds-of-thing-at-point 'symbol)))
        (setq p1 (car bds) )
        (setq p2 (cdr bds) ) ) )

    (goto-char p2)
    (insert "</" tagName ">")
    (goto-char p1)
    (insert "<" tagName ">")
    ))

(defun my-nxml-mode-config ()
  "For use in `nxml-mode-hook'."
  (local-set-key (kbd "<f1>") 'wrap-xml-tag))

;; add to hook
(add-hook 'nxml-mode-hook 'my-nxml-mode-config)

(use-package magit
  :ensure t)

(defun kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))

(global-set-key (kbd "C-c k") 'kill-other-buffers)
