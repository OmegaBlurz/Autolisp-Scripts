; This script defines a custom AutoCAD command named ZCLOSE.
; When invoked, it zooms to extents, performs a quick save, and closes the drawing. 
; If the drawing is untitled, it prompts the user to choose the save location and file name.

(defun c:ZoomSaveClose ()
  ; Zoom to the extents of the drawing
  (command "_.ZOOM" "_E")

  ; Quick save the drawing
  (command "_QSAVE")

  ; Close the drawing
  (command "_CLOSE")
)

;; Alias for ZoomSaveClose
(defun c:ZCLOSE () (c:ZoomSaveClose))
