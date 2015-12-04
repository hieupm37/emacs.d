;; Hide startup message
(setq inhibit-startup-message t)

;; Remove scrollbar, menubar, toolbar
(when (fboundp 'menu-bar-mode) (menu-bar-mode 0))
(when (fboundp 'tool-bar-mode) (tool-bar-mode 0))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))
(when (fboundp 'mouse-wheel-mode) (mouse-wheel-mode 0))

(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :font "Consolas" :height 120)
  )

(when (eq system-type 'darwin)
  ; remap Option/Alt -> Ctrl, Cmd -> Meta, Ctrl -> Super on OS X
  (setq ns-alternate-modifier 'control
	ns-right-alternate-modifier 'control
	ns-command-modifier 'meta
	ns-right-command-modifier 'meta)
  (set-face-attribute 'default nil :font "Source Code Pro" :height 130)
  )

;; show line number
(global-linum-mode t)

;; highlight current line
(global-hl-line-mode t)

;; show colnum number
(setq column-number-mode t)

;; highlight parent matching
(show-paren-mode t)
(setq show-paren-style 'expression)

;; auto reload buffer if file has changed externally
(global-auto-revert-mode 1)

;; auto delete whitespace trailing on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; put all backup files to temorary directory
(setq backup-directory-alist `((".*" . , temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*", temporary-file-directory t)))

;; remap window management
(global-set-key (kbd "M-3") 'split-window-horizontally)
(global-set-key (kbd "M-2") 'split-window-vertically)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-0") 'delete-window)
(global-set-key (kbd "M-o") 'other-window)

;; Save desktop session
(desktop-save-mode 1)

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

;;====================== MELPA package manager =================================
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed 'moe-theme
			  'helm
			  'projectile
			  'helm-projectile
			  'company
			  'smartparens
			  'google-c-style
			  'ace-jump-mode
			  'fill-column-indicator
			  'powerline
			  'smart-mode-line
			  'smart-mode-line-powerline-theme
			  'markdown-mode
			  'etags-select
			  'helm-descbinds
			  'magit) ;  --> (nil nil) if iedit and magit are already installed

;;==============================================================================

;; Theme
;; (require 'zenburn-theme)
(require 'moe-theme)
;; (moe-theme-set-color 'purple)
;; (powerline-moe-theme)
(moe-dark)
;; (load-theme 'zenburn t)

;; (require 'powerline)
;; (powerline-default-theme)

(require 'smart-mode-line)
(require 'smart-mode-line-powerline-theme)
(setq sml/no-confirm-load-theme t)
(setq sml/theme 'powerline)
(sml/setup)

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
(setq projectile-completion-system 'helm)
(setq projectile-enable-caching t)
(projectile-global-mode)
(helm-projectile-on)

(when (eq system-type 'window)
  ;; For windows, we use external indexing tool
  (setq projectile-indexing-method 'alien)
  )

(setq projectile-switch-project-action 'helm-projectile)

(add-to-list 'projectile-other-file-alist '("h" "cc"))
(add-to-list 'projectile-other-file-alist '("cc" "h"))
;;==================================================

;;========================= COMPANY MODE =======================================
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
;;==============================================================================

;;========================= SMARTPARENS ========================================
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; when you press RET, the curly braces automatically
;; add another newline
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))
;;==============================================================================

;;======================= TAGS ================================================
;; Refer: http://mattbriggs.net/blog/2012/03/18/awesome-emacs-plugins-ctags/
;; (require 'etags-select)

;; (defun visit-project-tags ()
;;   (interactive)
;;   (let ((tags-file (concat (projectile-project-root) "TAGS")))
;;     (visit-tags-table tags-file)
;;     (message (concat "Loaded " tags-file))))

;; (setq tags-case-fold-search nil)

;; (defun my-find-tag ()
;;   (interactive)
;;   (if (file-exists-p (concat (projectile-project-root) "TAGS"))
;;       (visit-project-tags))
;;   (etags-select-find-tag-at-point))


;; (global-set-key (kbd "M-.") 'my-find-tag)
(add-to-list 'load-path "~/.emacs.d/elisp/helm-etags-plus")
(require 'helm-etags+)
(global-set-key (kbd "M-.") 'helm-etags+-select)

;;==============================================================================

;; use google c++ style for c++ code
(require 'google-c-style)
(add-hook 'c++-mode-hook 'google-set-c-style)

(require 'ace-jump-mode)
(global-set-key (kbd "C-c w") 'ace-jump-word-mode)
(global-set-key (kbd "C-c c") 'ace-jump-char-mode)
(global-set-key (kbd "C-c l") 'ace-jump-line-mode)

;; Helm key bindings description
(require 'helm-descbinds)
(helm-descbinds-mode)

;; highlight column after 80
(require 'fill-column-indicator)
(setq fci-rule-column 80)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;; Markdown mode
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Objective c
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))

;; C++ mode for .h files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;========================== PROJECTS ==========================================
(when (eq system-type 'windows-nt)
  (setq browser-root "d:/workspace/browser/src/")
  (if (file-exists-p (concat browser-root "AUTHORS"))
      (progn (add-to-list 'load-path "d:/workspace/browser/src/tools/emacs")
	     (require 'flymake-chromium)
	     (message "Project %s loaded!" browser-root))
    (message "Cannot find project %s" browser-root)))
