;; ===================== ;;
;; List Utility Functions ;;
;; ===================== ;;

;; Basic List Operations

; (: length (-> List Number))
(= (length $list) 
    (if (== $list ())
        0
        (+ 1 (length (cdr-atom $list))))    
    )



; (: is-member (-> Number List Boolean))
(= (is-member $num $list)
   (if (== $list ())
       False
       (let* (($f (car-atom $list))
             ($r (cdr-atom $list)))
       (if (== $num $f)
           True
           (is-member $num $r)))))

(: append (-> Number List List))
(= (append $num $list)
   (if (== $list ())
       (cons-atom $num ())
       (let* (($m (car-atom $list))
             ($rest (cdr-atom $list))
             ($n (append $num $rest)))
       (cons-atom $m $n))))

;; Extremum Functions

(: min-value (-> List Number))
(= (min-value $list)
   (let* (($min (car-atom $list))
         ($rest (cdr-atom $list)))
   (min-value-helper $min $rest)))

(= (min-value-helper $min $list)
   (if (== $list ())
       $min
       (let* (($m (car-atom $list))
              ($rest (cdr-atom $list)))
         (if (> $min $m)
             (min-value-helper $m $rest)
             (min-value-helper $min $rest)))))

(: max-value (-> List Number))
(= (max-value $list)
   (let* (($max (car-atom $list))
          ($rest (cdr-atom $list)))
   (max-value-helper $max $rest)))

(= (max-value-helper $max $list)
   (if (== $list ())
       $max
       (let* (($m (car-atom $list))
              ($rest (cdr-atom $list)))
         (if (< $max $m)
             (max-value-helper $m $rest)
             (max-value-helper $max $rest)))))

;; Stack Operations

(: pop (-> List List List))
(= (pop $list $ans)
   (if (== $list ())
       $ans
       (let* (($m (car-atom $list))
              ($rest (cdr-atom $list)))
         (if (== (length $rest) 0)
             (pop $rest $ans)
             (let* (($new-ans (append $m $ans)))
               (pop $rest $new-ans))))))

;; List Modification

(: remove-element (-> Number List List List))
(= (remove-element $num $list $ans)
   (if (== $list ())
       (reverse $ans ())
       (let* (($m (car-atom $list))
              ($rest (cdr-atom $list))
              ($new-ans (if (== $m $num)
                          $ans
                          (cons-atom $m $ans))))
         (remove-element $num $rest $new-ans))))

(: reverse (-> List List List))
(= (reverse $list $ans)
   (if (== $list ())
       $ans
       (let* (($head (car-atom $list))
             ($tail (cdr-atom $list))
             ($new-ans (cons-atom $head $ans)))
       (reverse $tail $new-ans))))

;; Higher-Order Functions

; (: map (-> Function List List))
(= (map $f ()) ())
(= (map $f (:: $x $xs))
   (:: ($f $x) (map $f $xs)))

; (: filter (-> Function List List))
(= (filter $pred ()) ())
(= (filter $pred $lst)
   (let* (($head (car-atom $lst))
         ($tail (cdr-atom $lst))
         ($filtered-tail (filter $pred $tail)))
   (if ($pred $head)
       (cons-atom $head $filtered-tail)
       $filtered-tail)))

; (: foldl (-> Function Any List Any))
(= (foldl $func $acc ()) $acc)
(= (foldl $func $acc $lst)
   (let* (($head (car-atom $lst))
         ($tail (cdr-atom $lst))
         ($new-acc ($func $acc $head)))
   (foldl $func $new-acc $tail)))

; (: foldr (-> Function Any List Any))
(= (foldr $func $acc ()) $acc)
(= (foldr $func $acc $lst)
   (let* (($head (car-atom $lst))
         ($tail (cdr-atom $lst))
         ($folded-tail (foldr $func $acc $tail)))
   ($func $head $folded-tail)))

;; Remove duplicate elements from a list
(= (remove-duplicates $list)
   (remove-duplicates-helper $list ()))

;; Helper function with accumulator
(= (remove-duplicates-helper $list $seen)
   (if (== $list ())
       ()
       (let* (($head (car-atom $list))
             ($tail (cdr-atom $list)))
         (if (is-member $head $seen)
             (remove-duplicates-helper $tail $seen)
             (let* (($new_seen (cons-atom $head $seen)))
               (let* (($resuslts (remove-duplicates-helper $tail $new_seen)))
                  (cons-atom $head $resuslts)
               ))))))

;; Sorting Algorithms

(: insert (-> Number List List))
(= (insert $x ()) (:: $x ()))
(= (insert $x (:: $y $ys))
   (if (<= $x $y)
       (:: $x (:: $y $ys))
       (:: $y (insert $x $ys))))

(: sort (-> List List))
(= (sort ()) ())
(= (sort (:: $x $xs))
   (insert $x (sort $xs)))

;; =============== ;;
;; Example Usages ;;
;; =============== ;;

;; Predicates for filter examples
(= (less-than-3 $x) (< $x 3))
(= (greater-eq-5 $x) (>= $x 5))

;; Test Cases
! (length (1 2 3))
! (is-member 1 (1 2 3))
! (append 100 (1 2))
! (max-value (1 2 3 4 5))
! (min-value (100 101 200 400 -1 500))
! (pop (1 2 3) ())
! (reverse (3 2 1) ())
! (remove-element 10 (10 1 2 3 10) ())
! (filter less-than-3 (1 2 3 4 5))
! (filter greater-eq-5 (1 2 3 4 5 6))
! (foldr + 0 (1 2 3 4))
! (sort (:: 30 (:: 13 (:: -4 (:: 12 ())))))
! (remove-duplicates (1 2 2 3 1 4))