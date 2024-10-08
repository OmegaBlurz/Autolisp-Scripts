(defun c:DIMDEL (/ ss i sn name lst)
  (vl-load-com)
;;;        ------ Tharwat 15. June. 2012 -----      ;;;
;;; codes to delete all dimensions entities in the  ;;;
;;;                selected blocks                  ;;;
  (if (not acdoc)
    (setq acdoc (vla-get-activedocument (vlax-get-acad-object)))
  )
  (if (setq ss (ssget "_:L" '((0 . "INSERT"))))
    (repeat (setq i (sslength ss))
      (setq sn (ssname ss (setq i (1- i))))
      (if (not (member (setq name (cdr (assoc 2 (entget sn)))) lst))
        (progn
          (setq lst (cons name lst))
          (vlax-for each (vla-item (vla-get-blocks acdoc) name)
            (if (eq (vla-get-objectname each) "AcDbRotatedDimension")
              (vla-delete each))
          )
        )
      )
    )
    (princ)
  )
  (if ss (vla-regen acdoc AcAllviewports))
  (princ)
)