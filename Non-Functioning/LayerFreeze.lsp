(defun C:FreezeLayer () (freeze-hatch-layer))

(defun freeze-hatch-layer ()
  (vl-load-com) ; Load Visual LISP runtime
  (setq newLayerName "Hatch_Layer")
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-StartUndoMark doc)
  
  ; Create a new layer if it doesn't exist
  (setq newLayer (create-new-layer doc newLayerName))
  
  ; Move all hatches to the new layer
  (move-hatches-to-layer doc newLayerName)
  
  ; Freeze the new layer
  (vla-put-Freeze newLayer :vlax-true)
  
  (vla-EndUndoMark doc)
  (vla-Regen doc acActiveViewport)
  (princ)
)

(defun create-new-layer (doc layerName)
  (setq layers (vla-get-Layers doc))
  (if (not (vla-Item layers layerName))
    (setq newLayer (vla-Add layers layerName))
  )
  (vla-put-Freeze newLayer :vlax-false)
  newLayer
)

(defun move-hatches-to-layer (doc layerName)
  (setq modelSpace (vla-get-ModelSpace doc))
  (setq hatchesOnLayer (list))
  (vla-ForEach hatch modelSpace
    (if (= (vla-get-ObjectName hatch) "AcDbHatch")
      (progn
        (vla-put-Layer hatch layerName)
        (setq hatchesOnLayer (cons hatch hatchesOnLayer))
      )
    )
  )
  hatchesOnLayer
)
