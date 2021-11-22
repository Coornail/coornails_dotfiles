(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Tell Emacs to start org-roam-mode when Emacs starts
(add-hook 'after-init-hook 'org-roam-mode)
(setq org-roam-graph-executable "/usr/local/bin/dot")
(require 'org-protocol)
(require 'org-roam-protocol)
(require 'org-roam-server)
(setq org-roam-server-host "127.0.0.1"
       org-roam-server-port 8088
       org-roam-server-export-inline-images t
       org-roam-server-authenticate nil
       org-roam-server-network-poll t
       org-roam-server-network-arrows nil
       org-roam-server-network-label-truncate t
       org-roam-server-network-label-truncate-length 60
       org-roam-server-network-label-wrap-length 20)

(setq make-backup-files nil)

;; Enable Evil
(require 'evil)
(evil-mode 1)

;; Olivetti
(setq olivetti-body-width 120)
(add-hook 'text-mode-hook 'olivetti-mode)

;; Doom
(doom-modeline-mode 1)

;; Org-reveal
(require 'ox-reveal)

;; Helm
(helm-mode 1)
(recentf-mode 1)
(define-key evil-normal-state-map (kbd "C-p") 'helm-recentf)
;;(setq mac-command-modifier 'control)
;;(global-set-key (kbd "\s p") 'helm-recentf)

(server-start)
(require 'org-protocol)

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'org-mode)
(setq-default indent-tabs-mode nil)
(setq pop-up-windows nil)
(tool-bar-mode 0) 
(tooltip-mode  0)
(scroll-bar-mode 0)
