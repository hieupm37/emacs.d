;; Hide startup message
(setq inhibit-startup-message t)

;; Remove scrollbar, menubar, toolbar
(when (fboundp 'menu-bar-mode) (menu-bar-mode 0))
(when (fboundp 'tool-bar-mode) (tool-bar-mode 0))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))
(when (fboundp 'mouse-wheel-mode) (mouse-wheel-mode 0))

;; font on windows
(set-default-font "Consolas-12")

;; show line number
(global-linum-mode t)

;; highlight current line
(global-hl-line-mode t)

;; show colnum number
(setq column-number-mode t)

;; highlight parent matching
(show-paren-mode t)

;; auto reload buffer if file has changed externally
(global-auto-revert-mode 1)

;; auto delete whitespace trailing on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; put all backup files to temorary directory
(setq backup-directory-alist `((".*" . , temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*", temporary-file-directory t)))

;; Comment/uncomment current line or region
(defun comment-or-uncomment-current-line-or-region ()
  "Comments or uncomments current current line or whole lines in region."
  (interactive)
  (save-excursion
    (let (min max)
      (if (region-active-p)
          (setq min (region-beginning) max (region-end))
        (setq min (point) max (point)))
      (comment-or-uncomment-region
       (progn (goto-char min) (line-beginning-position))
       (progn (goto-char max) (line-end-position))
       )
      )
    )
  )
(global-set-key (kbd "M-/") 'comment-or-uncomment-current-line-or-region)

;; Insert a blank line below current line
(defun my-insert-newline-below()
  "Insert new line below current line and indent"
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent)
)
(global-set-key (kbd "C-o") 'my-insert-newline-below)

;; Ask before quiting Emacs
(defun ask-before-quitting ()
  "Quit Emacs if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure want to exit Emacs? "))
      (save-buffers-kill-emacs)
    (message "Cancelled exit!")
    )
  )
(global-set-key (kbd "C-x C-c") 'ask-before-quitting)

;; Disable prompts
(fset 'yes-or-no-p 'y-or-n-p) ; "y or n" instead of "yes or no"

;; MELPA package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; TODO(hieupm37): install packages automatically

;; Theme
(require 'zenburn-theme)
(load-theme 'zenburn t)

;; Enable semantic mode
(semantic-mode 1)

;;================= HELM =========================
;; Config helm base on http://tuhdo.github.io/helm-intro.html
(require 'helm)
(require 'helm-config)

;; Change helm command prefix from "C-x c" to "C-c h" to prevent quit Emacs accidently.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z

(global-set-key (kbd "M-x") 'helm-M-x)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-x b") 'helm-mini)

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(global-set-key (kbd "C-c h o") 'helm-occur)

(setq
 ;; open helm buffer inside current window
 helm-split-window-in-side-p t
 ;; move to end or begin of source when reaching top or bottom
 helm-move-to-line-cycle-in-source t
 ;; search for library in 'require' and 'declare-function' sexp
 helm-ff-search-library-in-sexp t
 ;; scroll 8 lines other window using M-<next>/M-<prior>
 helm-scroll-amount 8
 helm-ff-file-name-history-use-recentf t
 )

(helm-mode 1)
(helm-autoresize-mode t)
;;==================================================

;;================= PROJECTILE =====================
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; For windows, we use external indexing tool
(setq projectile-indexing-method 'alien)

(setq projectile-switch-project-action 'helm-projectile)

;;==================================================

;; use google c++ style for c++ code
(require 'google-c-style)
(add-hook 'c++-mode-hook 'google-set-c-style)

(require 'powerline)
(powerline-default-theme)

(require 'ace-jump-mode)
(global-set-key (kbd "C-c w") 'ace-jump-word-mode)
(global-set-key (kbd "C-c c") 'ace-jump-char-mode)
(global-set-key (kbd "C-c l") 'ace-jump-line-mode)

;; highlight column after 80
(require 'fill-column-indicator)
(setq fci-rule-column 80)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)
