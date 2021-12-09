(defparameter lines (uiop:split-string (uiop:read-file-string #p"./input") :separator (make-string 1 :initial-element #\Newline)))
(defun split-space (s) (uiop:split-string (string-trim " " s) :separator " "))
(defun split-pipes (s) (mapcar (lambda (s) (split-space s)) (uiop:split-string s :separator "|")))

(defparameter fmt-lines (remove 'nil (mapcar (lambda (s) (split-pipes s)) lines)))

(defun uniq-len (s l) (+ s (if (or (eq l 2) (eq l 3) (eq l 4) (eq l 7)) 1 0)))

(print
  (reduce
    #'+
    (mapcar
      (lambda (l) (reduce (lambda (s l) (uniq-len s l)) l :initial-value 0))
      (mapcar (lambda (l) (mapcar (lambda (k) (length k)) (nth 1 l))) fmt-lines))))

(defun gen-perm (list)
  (cond ((null list) nil)
        ((null (cdr list)) (list list))
        (t (loop for element in list
             append (mapcar (lambda (l) (cons element l))
                            (gen-perm (remove element list)))))))

(defparameter all-permutations (gen-perm  '("a" "b" "c" "d" "e" "f" "g")))

(defparameter valid-segments
  '(119 18 93 91 58 107 111 82 127 123))

(defun as-int (s p) (parse-integer (format nil "~{~A~}" (mapcar (lambda (c) (if (search c s) 1 0)) p)) :radix 2))
(defun is-valid-segment (s p)
  (reduce (lambda (res n) (or res (eq n (as-int s p)))) valid-segments :initial-value NIL))

(defun filter-permutations
  (s pl) (reduce (lambda (res p) (if (is-valid-segment s p) (cons p res) res)) pl :initial-value NIL))

(defun deduce-permutation
  (seq) (reduce (lambda (pl s) (filter-permutations s pl)) seq :initial-value all-permutations))

(defun output-as-int (o p)
  (mapcar (lambda (s) (as-int s p)) o))

(defun output-as-number (o)
  (reduce (lambda (sum x) (+ (* sum 10) x)) (mapcar (lambda (s) (position s valid-segments)) o) :initial-value 0))

(print
  (reduce
    (lambda (sum line) (+ sum (output-as-number (output-as-int (nth 1 line) (car (deduce-permutation (car line)))))))
    fmt-lines :initial-value 0))
