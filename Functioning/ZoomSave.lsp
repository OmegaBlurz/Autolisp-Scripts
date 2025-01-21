(defun c:ZoomSave ()
  (command "_.ZOOM" "_E")
  (command "_QSAVE")
  (if (= (getvar "DWGTITLED") 0)
    (command "_SAVEAS" "~")
  )
)

;; Alias for SetLayoutName
(defun c:ZSAVE () (c:ZoomSave))