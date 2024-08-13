(defun c:SetLinetypeScales ()
  (setvar "MSLTSCALE" 0)
  (setvar "PSLTSCALE" 0)
  (setvar "LTSCALE" 1)
  (princ "\nLinetype scales have been set: MSLTSCALE=0, PSLTSCALE=0, LTSCALE=1")
  (princ)
)

;; Alias for SetLinetypeScales
(defun c:SETLTS () (c:SetLinetypeScales))