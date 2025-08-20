;; Designate Layout Name
(defun c:SetLayoutNameVar ()
  (setq *layoutName* (getstring "\nEnter layout name: "))
  ;; Construct the path to the user's temp folder
  (setq tempFile (open (strcat (getenv "TEMP") "\\layoutname.tmp") "w"))
  (write-line *layoutName* tempFile)
  (close tempFile)
  (princ (strcat "\nStored layout name variable set to: " *layoutName*))
  (princ)
)

;; Read the Layout name currently stored in TEMP
(defun c:ReadLayoutNameVar ()
  ;; Construct the path to the user's temp folder
  (setq tempFile (open (strcat (getenv "TEMP") "\\layoutname.txt") "r"))
  (if tempFile
    (progn
      (setq *layoutName* (read-line tempFile))
      (close tempFile)
      (if *layoutName*
        (progn
          (princ (strcat "\nLayout name variable is: " *layoutName*))
        )
        (princ "\nNo valid layout name found in the temp file.")
      )
    )
    (princ "\nCould not open the temp file. Make sure it exists.")
  )
  (princ)
)

;; Change Current Layout to Designated Name
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

;; Alias for SetLayoutName
(defun c:LSETVAR () (c:SetLayoutNameVar))

;; Alias for ChangeLayoutName
(defun c:LCHG () (c:ChangeLayoutName))

;; Alias for ChangeLayoutName
(defun c:LVARREAD () (c:ReadLayoutNameVar))
