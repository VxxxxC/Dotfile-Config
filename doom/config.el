;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Hack Nerd Font" :size 18 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Hack Nerd Font" :size 18));
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'snazzy)
;(setq catppuccin-flavor 'frappe) ; or 'frappe 'latte, 'macchiato, or 'mocha
(load-theme 'snazzy t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Obsidian Vault/Emacs Org File/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Set the default shell for Emacs
(setq shell-file-name (executable-find "fish"))
;; (setq explicit-shell-file-name "/run/current-system/sw/bin/fish")

;; Better debugging
(use-package! dape)

;; mermaid diagram
(use-package! ob-mermaid)
(use-package! mermaid-mode)
;; 1. 啟用 mermaid Babel 支援
(org-babel-do-load-languages
    'org-babel-load-languages
    '((mermaid . t)
      (scheme . t)))

;; 2. 指定 CLI 工具路徑 (如果 mmdc 已經喺系統 PATH 入面，直接寫 "mmdc" 即可)
(setq ob-mermaid-cli-path "mmdc")

 ;; 3. 解決圖片只顯示路徑的問題：每次執行完 Code 後，自動重新載入並顯示圖片！
;;(add-hook 'org-babel-after-execute-hook #'org-display-inline-images)

;; 4. (可選) 設定全局預設輸出資料夾，例如預設放入 ~/Emacs-Org/mermaid_diagram/
(setq org-babel-default-header-args:mermaid
      '((:dir . "~/Documents/Obsidian Vault/Emacs Org File/mermaid-diagram/")))

;; ==========================================
;; Dape (Debugger) - Rust 全自動路徑尋找設定
;; ==========================================
(after! dape
  ;; 1. 自動尋找主程式 (Main)
  (add-to-list 'dape-configs
               `(rust-main
                 modes (rust-mode rust-ts-mode rustic-mode)
                 command "lldb-dap"
                 :type "lldb"
                 :request "launch"
                 compile "cargo build"
                 :cwd "."
                 :program
                 ;; [魔法開始] 動態計算路徑
                 ,(lambda ()
                    (let* ((root (doom-project-root))
                           ;; 預設執行檔名稱與資料夾名稱相同
                           (proj-name (file-name-nondirectory (directory-file-name root)))
                           (bin (expand-file-name (concat "target/debug/" proj-name) root)))
                      ;; 如果自動靠估的路徑存在，就直接用；否則彈出選單讓你選一次
                      (if (file-exists-p bin)
                          bin
                        (read-file-name "Select Main Binary: " (concat root "target/debug/")))))))

  ;; 2. 自動尋找最新編譯的測試 (Test)
  (add-to-list 'dape-configs
               `(rust-test
                 modes (rust-mode rust-ts-mode rustic-mode)
                 command "lldb-dap"
                 :type "lldb"
                 :request "launch"
                 ;; 關鍵：編譯但先不執行
                 compile "cargo test --no-run"
                 :cwd "."
                 :program
                 ;; [魔法開始] 動態找出剛剛編譯好的、帶有 Hash 亂碼的 Test Binary
                 ,(lambda ()
                    (let* ((root (doom-project-root))
                           (deps-dir (expand-file-name "target/debug/deps/" root)))
                      (if (not (file-exists-p deps-dir))
                          (read-file-name "Select Test Binary: " root)
                        (let* ((files (directory-files deps-dir t))
                               ;; 過濾掉不是執行檔的垃圾檔案 (.dSYM, .so 等)
                               (execs (cl-remove-if-not
                                       (lambda (f)
                                         (and (file-executable-p f)
                                              (not (file-directory-p f))
                                              (not (string-match-p "\\.\\(dSYM\\|dylib\\|so\\|dll\\)$" f))))
                                       files))
                               ;; 根據檔案修改時間排序 (最新鮮的排最前面)
                               (sorted (sort execs (lambda (a b)
                                                     (time-less-p (file-attribute-modification-time (file-attributes b))
                                                                  (file-attribute-modification-time (file-attributes a))))))
                               (newest (car sorted)))
                          ;; 自動回傳最新出爐的 test binary！
                          (if newest
                              newest
                            (read-file-name "Select Test Binary: " deps-dir)))))))))
