(defun c:ZSAVE ()
  (command "_.ZOOM" "_E")
  (command "_QSAVE")
  (if (= (getvar "DWGTITLED") 0)
    (command "_SAVEAS" "~")
  )
)