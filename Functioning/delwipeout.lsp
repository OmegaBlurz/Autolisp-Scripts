;; 10/3/2005 Delete raster wipeouts in block definitions.
 (defun c:delwipeout:deleteBlockWipeouts ( / cnt blocks flag)
 (setq cnt 0)
 (setq blocks
 (vla-get-blocks
 (vla-get-activedocument
 (vlax-get-acad-object))))
 (vlax-for x blocks
 (if
 (and
 (not (wcmatch (strcase (vlax-get x 'Name)) "*MODEL*,*PAPER*,*|*"))
 (= :vlax-false (vla-get-IsXRef x))
 )
 (vlax-for item x
 (if (= "AcDbWipeout" (vlax-get item 'ObjectName))
 (if (not (vl-catch-all-error-p
 (vl-catch-all-apply 'vla-delete (list item))))
 (setq cnt (1+ cnt))
 (setq flag T)
 )
 )
 )
 )
 )
 (princ (strcat "\nNumber of wipeouts deleted: " (itoa cnt)))
 (if flag
 (princ "\nSome items could not be deleted. Check for locked layers. ")
 )
 (princ)
 ) ;end
 [/code]
