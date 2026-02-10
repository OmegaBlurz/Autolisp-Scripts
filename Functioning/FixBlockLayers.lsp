;   File Name: FIXBLOCK.LSP
;   Description: Puts all of a blocks sub-entities on layer 0 with color and
;					  linetype set to BYBLOCK. The block, itself, will remain on
;					  its' original layer.
;
;   Revision:
;   3-Dec-2003 YZ
;      Changed program to work from a keyword on the command line
;   2024-01-01 
;      Modified to allow multiple block selection
;   2026-02-10
;      Added new alias
;*******************************************************************************
(defun d_FixBlock (/             ssBlocks       ; Block selection set
                   iCount        ; Counter for selection set
                   eBlockSel     ; Individual block entity
                   lInsertData   ; Entity data
                   sBlockName    ; Block name
                   lBlockData    ; Entity data
                   eSubEntity    ; Sub-entity name
                   lSubData      ; Sub-entity data
                   processedBlocks ; List of blocks already processed
                  )

  ;; Redefine error handler
  (setq
    d_#error *error*
    *error*  d_FB_Error
  ) ;_ end setq

  ;; Set up environment
  (setq #SYSVARS (#SaveSysVars (list "cmdecho")))

  (setvar "cmdecho" 0)
  (command "._undo" "_group")

  ;; Get multiple blocks from user
  (if (setq ssBlocks (ssget '((0 . "INSERT"))))
    (progn
      (setq processedBlocks '()) ; Initialize list of processed blocks
      
      ;; Process each selected block
      (setq iCount 0)
      (repeat (sslength ssBlocks)
        (setq eBlockSel (ssname ssBlocks iCount))
        (setq lInsertData (entget eBlockSel))
        
        (if (= (cdr (assoc 0 lInsertData)) "INSERT")
          (progn
            (setq sBlockName (cdr (assoc 2 lInsertData)))
            
            ;; Check if this block type has already been processed
            (if (not (member sBlockName processedBlocks))
              (progn
                ;; Add to processed list
                (setq processedBlocks (cons sBlockName processedBlocks))
                
                ;; Get block info from the block table
                (setq
                  lBlockData (tblsearch "BLOCK" sBlockName)
                  eSubEntity (cdr (assoc -2 lBlockData))
                ) ;_ end setq

                ;; Make sure block is not an Xref
                (if (not (assoc 1 lBlockData))
                  (progn
                    (princ "\nProcessing block: ")
                    (princ sBlockName)

                    (princ "\nUpdating blocks sub-entities. . .")

                    ;; Parse through all of the blocks sub-entities
                    (while eSubEntity
                      (princ " .")
                      (setq lSubData (entget eSubEntity))

                      ;; Update layer property
                      (if (assoc 8 lSubData)
                        (progn
                          (setq lSubData
                                 (subst
                                   (cons 8 "0")
                                   (assoc 8 lSubData)
                                   lSubData
                                 ) ;_ end subst
                          ) ;_ end setq
                          (entmod lSubData)
                        ) ;_ end progn
                      ) ;_ end if

                      ;; Update the linetype property
                      (if (assoc 6 lSubData)
                        (progn
                          (setq lSubData
                                 (subst
                                   (cons 6 "BYBLOCK")
                                   (assoc 6 lSubData)
                                   lSubData
                                 ) ;_ end subst
                          ) ;_ end setq
                          (entmod lSubData)
                        ) ;_ end progn
                        (entmod (append lSubData (list (cons 6 "BYBLOCK"))))
                      ) ;_ end if

                      ;; Update the color property
                      (if (assoc 62 lSubData)
                        (progn
                          (setq lSubData
                                 (subst
                                   (cons 62 0)
                                   (assoc 62 lSubData)
                                   lSubData
                                 ) ;_ end subst
                          ) ;_ end setq
                          (entmod lSubData)
                        ) ;_ end progn
                        (entmod (append lSubData (list (cons 62 0))))
                      ) ;_ end if

                      (setq eSubEntity (entnext eSubEntity))
                      ; get next sub entity
                    ) ; end while

                    ;; Update attributes for this block type
                    (idc_FB_UpdAttribs sBlockName)

                  ) ; end progn
                  (progn
                    (princ (strcat "\nXREF \"" sBlockName "\" selected. Not updated!"))
                  ) ;_ end progn
                ) ; end if
              ) ; end progn - block not processed yet
            ) ; end if - block not in processed list
          ) ; end progn - valid INSERT entity
          (princ "\nSelected entity is not a block. Skipping...")
        ) ; end if - INSERT check
        
        (setq iCount (1+ iCount))
      ) ; end repeat
    ) ; end progn - selection set exists
    (alert "Nothing selected.")
  ) ; end if

  ;;; Pop error stack and reset environment
  (idc_RestoreSysVars)

  (princ "\nDone!")

  (setq *error* d_#error)

  (princ)

)   ; end defun

;*******************************************************************************
; Function to update block attributes
;*******************************************************************************
(defun idc_FB_UpdAttribs (sBlockName / iCount ssInserts eBlockName eSubEntity lSubData eSubType)

  ;; Update any attribute definitions
  (setq iCount 0)

  (princ "\nUpdating attributes. . .")
  (if (setq ssInserts (ssget "x"
                             (list (cons 0 "INSERT")
                                   (cons 66 1)
                                   (cons 2 sBlockName)
                             ) ;_ end list
                      ) ;_ end ssget
      ) ;_ end setq
    (repeat (sslength ssInserts)
      (setq eBlockName (ssname ssInserts iCount))

      (if (setq eSubEntity (entnext eBlockName))
        (setq
          lSubData (entget eSubEntity)
          eSubType (cdr (assoc 0 lSubData))
        ) ;_ end setq
      ) ;_ end if

      (while (or (= eSubType "ATTRIB") (= eSubType "SEQEND"))
        ;; Update layer property
        (if (assoc 8 lSubData)
          (progn
            (setq lSubData
                   (subst
                     (cons 8 "0")
                     (assoc 8 lSubData)
                     lSubData
                   ) ;_ end subst
            ) ;_ end setq
            (entmod lSubData)
          ) ;_ end progn
        ) ;_ end if

        ;; Update the linetype property
        (if (assoc 6 lSubData)
          (progn
            (setq lSubData
                   (subst
                     (cons 6 "BYBLOCK")
                     (assoc 6 lSubData)
                     lSubData
                   ) ;_ end subst
            ) ;_ end setq
            (entmod lSubData)
          ) ;_ end progn
          (entmod (append lSubData (list (cons 6 "BYBLOCK"))))
        ) ;_ end if

        ;; Update the color property
        (if (assoc 62 lSubData)
          (progn
            (setq lSubData
                   (subst
                     (cons 62 0)
                     (assoc 62 lSubData)
                     lSubData
                   ) ;_ end subst
            ) ;_ end setq
            (entmod lSubData)
          ) ;_ end progn
          (entmod (append lSubData (list (cons 62 0))))
        ) ;_ end if

        (if (setq eSubEntity (entnext eSubEntity))
          (setq
            lSubData (entget eSubEntity)
            eSubType (cdr (assoc 0 lSubData))
          ) ;_ end setq
          (setq eSubType nil)
        ) ;_ end if
      ) ; end while

      (setq iCount (1+ iCount))
    ) ; end repeat
  ) ; end if
  (command "regen")
)   ; end defun

;*******************************************************************************
; Function to save a list of system variables
;*******************************************************************************
(defun #SaveSysVars (lVarList / sSystemVar lSystemVars)
  (setq lSystemVars '())
  (mapcar
    '(lambda (sSystemVar)
       (setq lSystemVars
              (append lSystemVars
                      (list (list sSystemVar (getvar sSystemVar)))
              ) ;_ end append
       ) ;_ end setq
     ) ;_ end lambda
    lVarList
  ) ;_ end mapcar
  lSystemVars
) ;_ end defun

;*******************************************************************************
; Function to restore a list of system variables
;*******************************************************************************
(defun idc_RestoreSysVars ()
  (mapcar
    '(lambda (sSystemVar)
       (setvar (car sSystemVar) (cadr sSystemVar))
     ) ;_ end lambda
    #SYSVARS
  ) ;_ end mapcar
) ;_ end defun

;*******************************************************************************
; Error Handler
;*******************************************************************************
(defun d_FB_Error (msg)
  (princ "\nError occurred in the Fix Block routine...")
  (princ "\nError: ")
  (princ msg)

  (setq *error* d_#error)
  (if *error*
    (*error* msg)
  ) ;_ end if

  (command)

  (if (/= msg "quit / exit abort")
    (progn
      (command "._undo" "_end")
      (command "._u")
    ) ;_ end progn
  ) ;_ end if

  (idc_RestoreSysVars)

  (princ)
) ;_ end defun

;*******************************************************************************

(defun C:FIXBLOCK () (d_FixBlock))
(defun C:SetToLayer0 () (d_FixBlock))
(princ)