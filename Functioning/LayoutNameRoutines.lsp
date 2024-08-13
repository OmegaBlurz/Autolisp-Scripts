;; Script 1: Designate Layout Name
(defun c:SetLayoutName ()
  (setq *layoutName* (getstring "\nEnter layout name: "))
  ;; Construct the path to the user's temp folder
  (setq tempFile (open (strcat (getenv "TEMP") "\\layoutname.tmp") "w"))
  (write-line *layoutName* tempFile)
  (close tempFile)
  (princ (strcat "\nLayout name set to: " *layoutName*))
  (princ)
)

;; Script 2: Change Current Layout to Designated Name
(defun c:ChangeLayoutName ()
  ;; Construct the path to the user's temp folder
  (setq tempFile (open (strcat (getenv "TEMP") "\\layoutname.tmp") "r"))
  (if tempFile
    (progn
      (setq *layoutName* (read-line tempFile))
      (close tempFile)
      (if *layoutName*
        (progn
          (setq currentLayout (getvar "CTAB"))
          (command "._layout" "rename" currentLayout *layoutName*)
          (princ (strcat "\nCurrent layout renamed to: " *layoutName*))
        )
        (princ "\nNo valid layout name found in the temp file.")
      )
    )
    (princ "\nCould not open the temp file. Make sure it exists.")
  )
  (princ)
)
