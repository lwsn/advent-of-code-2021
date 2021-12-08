(let ((nl (make-string 1 :initial-element #\Newline)) (input (uiop:read-file-string #p"./input")))
  (defun uniq-len (s l) (+ s (if (or (eq l 2) (eq l 3) (eq l 4) (eq l 7)) 1 0)))
  (defun output-list (s) (cdr (uiop:split-string (nth 1 (uiop:split-string s :separator "|")) :separator " ")))
  (defun output-len (s) (mapcar (lambda (s) (length s)) (output-list s)))
  (print
    (reduce 
      #'+
      (mapcar
        (lambda (l) (reduce (lambda (s l) (uniq-len s l)) l :initial-value 0))
        (mapcar (lambda (s) (output-len s)) (uiop:split-string input :separator nl)))))
  )
