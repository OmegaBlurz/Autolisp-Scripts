;; Script 1: Designate Layout Name
(defun c:SetLayoutName ()
  (setq *layoutName* (getstring "\nEnter layout name: "))
  ;; Save the layout name to a temporary file, clearing existing content
  (setq tempFile (open "C:\\Users\\{USER}\\AppData\\Local\\Temp\\layoutname.txt" "w"))
  (write-line *layoutName* tempFile)
  (close tempFile)
  (princ (strcat "\nLayout name set to: " *layoutName*))
  (princ)
)

;; Script 2: Change Current Layout to Designated Name
(defun c:ChangeLayoutName ()
  ;; Read the layout name from the temporary file
  (setq tempFile (open "C:\\Users\\{USER}\\AppData\\Local\\Temp\\layoutname.txt" "r"))
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
        (princ "\nNo valid layout name found in the file.")
      )
    )
    (princ "\nNo layout name has been set. Please run SetLayoutName first.")
  )
  (princ)
)

(princ)