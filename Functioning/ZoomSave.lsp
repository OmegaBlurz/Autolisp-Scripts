(defun c:ZSAVE ()
  (command "_.ZOOM" "_E")         ; Zoom to extents
  (command "_QSAVE")              ; Quick save the drawing
  (if (= (getvar "DWGTITLED") 0)  ; TODO non-functioning save logic
    (command "_SAVEAS" "~")
  )
)