(defun C:HatchDel ()(delete-all-hatch))

(defun delete-all-hatch (  / adoc *error*)
  
  (defun *error* (msg)
    (setvar "MODEMACRO" "")
    (princ msg)
    (vla-regen aDOC acactiveviewport)
    (bg:progress-clear)
    (bg:layer-status-restore)
    (princ)
  ) ;_ end of defun
  (defun _loc-delete-items ()
    (if	(= (vla-get-IsXref Blk) :vlax-false)
      (progn
	(setq count 0)
	(if (> (vla-get-count Blk) 100)
	  (bg:progress-init
	    (strcat (vla-get-name Blk) " :")
	    (vla-get-count Blk)
	  ) ;_ end of bg:progress-init
	  (progn
	    (setvar "MODEMACRO" (vla-get-name Blk))
	  ) ;_ end of progn
	) ;_ end of if
	(vlax-for Obj Blk
	  (if (= (vla-get-ObjectName Obj) "AcDbHatch")
            (vl-catch-all-apply 'vla-delete (list Obj))
	  ) ;_ end of if
	) ;_ end of vlax-for
	(bg:progress-clear)
      ) ;_ end of progn
    ) ;_ end of if
  ) ;_ end of defun
  (setq	aDOC	   (vla-get-activedocument (vlax-get-acad-object))
  ) ;_ end of setq
  (bg:layer-status-save)
  (vlax-for Blk (vla-get-Blocks aDOC)
	(_loc-delete-items)
    )
  (bg:layer-status-restore)
    (vla-regen aDOC acActiveViewport)
  (princ)
) ;_ end of defun
(defun bg:layer-status-restore ()
    (foreach item *BG_LAYER_LST*
      (if (not (vlax-erased-p (car item)))
        (vl-catch-all-apply
          '(lambda ()
             (vla-put-lock (car item) (cdr (assoc "lock" (cdr item))))
             (vla-put-freeze (car item) (cdr (assoc "freeze" (cdr item))))
             ) ;_ end of lambda
          ) ;_ end of vl-catch-all-apply
        ) ;_ end of if
      ) ;_ end of foreach
    (setq *BG_LAYER_LST* nil)
    ) ;_ end of defun

  (defun bg:layer-status-save ()
    (setq *BG_LAYER_LST* nil)
    (vlax-for item (vla-get-layers (vla-get-activedocument (vlax-get-acad-object)))
      (setq *BG_LAYER_LST* (cons (list item
                                  (cons "freeze" (vla-get-freeze item))
                                  (cons "lock" (vla-get-lock item))
                                  ) ;_ end of cons
                            *BG_LAYER_LST*
                            ) ;_ end of cons
            ) ;_ end of setq
      (vla-put-lock item :vlax-false)
      (if (= (vla-get-freeze item) :vlax-true)
      (vl-catch-all-apply '(lambda () (vla-put-freeze item :vlax-false))))
      ) ;_ end of vlax-for
    ) ;_ end of defun
(defun bg:progress-init (msg maxlen)
  ;;; msg - сообщение или пустая строка
  ;;; maxlen - максимальное количество
  (setq *BG:PROGRESS:OM* (getvar "MODEMACRO"))
  (setq *BG:PROGRESS:MSG* (vl-princ-to-string msg))
  (setq *BG:PROGRESS:MAXLEN* maxlen)
  (setq *BG:PROGRESS:LPS* '-1)(princ)
  )
(defun bg:progress ( currvalue / persent str1 count)
  (if *BG:PROGRESS:MAXLEN*
    (progn
  (setq persent (fix (/ currvalue 0.01 *BG:PROGRESS:MAXLEN*)))
  ;;;Каждые 5 %
  (setq count (fix(* persent 0.2)))
  (setq str1 "")
  (if (/= count *BG:PROGRESS:LPS*)
    (progn
      ;;(setq str1 "")
      (repeat persent (setq str1 (strcat str1 "|")))
      )
    )
       ;;; currvalue - текущее значение
      (setvar "MODEMACRO"
              (strcat (vl-princ-to-string *BG:PROGRESS:MSG*)
                      " "
                      (itoa persent)
                      " % "
                      str1
                      )
              )
      (setq *BG:PROGRESS:LPS* persent)
  )
    )
  )
     
(defun bg:progress-clear ()
  (setq *BG:PROGRESS:MSG* nil)
  (setq *BG:PROGRESS:MAXLEN* nil)
  (setq *BG:PROGRESS:LPS* nil)
  (setvar "MODEMACRO" (vl-princ-to-string *BG:PROGRESS:OM*))
  ;;;(vla-regen (vla-get-activedocument (vlax-get-acad-object)) acactiveviewport)
  (princ)
  )
(princ "\nType HatchDel in command line")