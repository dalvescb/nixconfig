;; .yas-setup.el for term-mode

(defun concat-strs (list)
  (mapconcat 'identity list "\n")
  )

(defun edit-tmp-buffer (strs)
  (interactive)
  (pop-to-buffer (make-temp-name "scratch"))
  (yas-minor-mode)
  (yas-expand-snippet (concat-strs strs))
  (shell-script-mode)
  )
