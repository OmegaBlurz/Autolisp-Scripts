(defun c:SETLTS ()
  (setvar "MSLTSCALE" 0)  ;Disables scaling of linetypes in model space relative to viewport scale
  (setvar "PSLTSCALE" 0)  ;Disables scaling of linetypes in paper space relative to viewport scale
  (setvar "LTSCALE" 1)    ;Sets the global linetype scale factor to 1
  (princ "\nLinetype scales have been set: MSLTSCALE=0, PSLTSCALE=0, LTSCALE=1")
  (princ)
)