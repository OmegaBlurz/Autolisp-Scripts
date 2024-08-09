(defun c:INVERTLAYERVISIBILITY ()
  (vl-load-com)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (setq layers (vla-get-Layers doc))

  (vlax-for layer layers
    (progn
      (if (and
            (/= (vla-get-Name layer) "0")
            (/= (vla-get-Name layer) "Defpoints")
          )
        (progn
          ;; Invert Freeze/Thaw state
          (if (= :vlax-true (vla-get-Freeze layer))
            (vla-put-Freeze layer :vlax-false)
            (vla-put-Freeze layer :vlax-true)
          )
          ;; Invert On/Off state
          (if (= :vlax-true (vla-get-LayerOn layer))
            (vla-put-LayerOn layer :vlax-false)
            (vla-put-LayerOn layer :vlax-true)
          )
        )
      )
    )
  )
  (princ "\nLayer visibility inverted.\n")
  (princ)
)

;; To execute the function, type INVERTLAYERVISIBILITY in the command line
