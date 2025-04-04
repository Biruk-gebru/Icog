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
       (let* ((($head $tail) (decons-atom $list))
             )
       (if (== $num $head)
           True
           (is-member $num $tail)))))

; (: append (-> Number List List))
(= (append $num $list)
   (if (== $list ())
       (cons-atom $num ())
       (let* ((($head $tail) (decons-atom $list))
             ($n (append $num $tail)))
       (cons-atom $head $n))))

;; Extremum Functions

; (: min-value (-> List Number))
(= (min-value $list)
   (let* ((($min $tail) (decons-atom $list)))
   (min-value-helper $min $tail)))

(= (min-value-helper $min $list)
   (if (== $list ())
       $min
       (let* ((($head $tail) (decons-atom $list)))
         (if (> $min $head)
             (min-value-helper $head $tail)
             (min-value-helper $min $tail)))))

; (: max-value (-> List Number))
(= (max-value $list)
   (let* ((($max $rest) (decons-atom $list)))
   (max-value-helper $max $rest)))

(= (max-value-helper $max $list)
   (if (== $list ())
       $max
       (let* ((($m $rest) (decons-atom $list)))
         (if (< $max $m)
             (max-value-helper $m $rest)
             (max-value-helper $max $rest)))))

;; Stack Operations

; (: pop (-> List List List))
(= (pop $list $ans)
   (if (== $list ())
       $ans
       (let* ((($m $rest) (decons-atom $list)))
         (if (== $rest ())
             (pop $rest $ans)
             (let* (($new-ans (append $m $ans)))
               (pop $rest $new-ans))))))

;; List Modification

; (: remove-element (-> Number List List List))
(= (remove-element $num $list)
   (if (== $list ())
       ()
       (let* ((($head $tail) (decons-atom $list)))
         (if (== $head $num)
             (remove-element $num $tail)
             (let* (($n (remove-element $num $tail)))
               (cons-atom $head $n))))))



; (: reverse (-> List List List))
(= (reverse $list $ans)
   (if (== $list ())
       $ans
       (let* ((($head $tail) (decons-atom $list))
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
   (let* ((($head $tail) (decons-atom $lst))
         ($filtered-tail (filter $pred $tail)))
   (if ($pred $head)
       (cons-atom $head $filtered-tail)
       $filtered-tail)))

; (: foldl (-> Function Any List Any))
(= (foldl $func $acc ()) $acc)
(= (foldl $func $acc $lst)
   (let* ((($head $tail) (decons-atom $lst))
         ($new-acc ($func $acc $head)))
   (foldl $func $new-acc $tail)))

; (: foldr (-> Function Any List Any))
(= (foldr $func $acc ()) $acc)
(= (foldr $func $acc $lst)
   (let* ((($head $tail) (decons-atom $lst))
         ($folded-tail (foldr $func $acc $tail)))
   ($func $head $folded-tail)))

;; Remove duplicate elements from a list
(= (remove-duplicates $list)
   (remove-duplicates-helper $list ()))

;; Helper function with accumulator
(= (remove-duplicates-helper $list $seen)
   (if (== $list ())
       ()
       (let* ((($head $tail) (decons-atom $list)))
         (if (is-member $head $seen)
             (remove-duplicates-helper $tail $seen)
             (let* (
               ($new_seen (cons-atom $head $seen))
               ($resuslts (remove-duplicates-helper $tail $new_seen))
             
             )
               (cons-atom $head $resuslts)
               )))))

;; Sorting Algorithms

(= (quicksort $lst)
   (if (== $lst ())
       ()
       (let* ((($pivot $rest) (decons-atom $lst)))
         (let* (($lesser (filter-less $pivot $rest))
                ($greater (filter-greater-eq $pivot $rest))
                ($sorted-lesser (quicksort $lesser))
                ($sorted-greater (quicksort $greater))
                ($pivot-and-greater (cons-atom $pivot $sorted-greater)))
           (concat $sorted-lesser $pivot-and-greater)))))

(= (filter-less $pivot $lst)
   (if (== $lst ())
       ()
       (let* ((($head $tail) (decons-atom $lst)))
         (if (< $head $pivot)
             (let* (($filtered (filter-less $pivot $tail)))
               (cons-atom $head $filtered))
             (filter-less $pivot $tail)))))

(= (filter-greater-eq $pivot $lst)
   (if (== $lst ())
       ()
       (let* ((($head $tail) (decons-atom $lst)))
         (if (>= $head $pivot)
             (let* (($filtered (filter-greater-eq $pivot $tail)))
               (cons-atom $head $filtered))
             (filter-greater-eq $pivot $tail)))))

(= (concat $a $b)
   (if (== $a ())
       $b
       (let* ((($head $tail) (decons-atom $a)))
         (let* (($concatenated (concat $tail $b)))
           (cons-atom $head $concatenated)))))

;; =============== ;;
;; Example Usages ;;
;; =============== ;;

;; Predicates for filter examples
(= (less-than-3 $x) (< $x 3))
(= (greater-eq-5 $x) (>= $x 5))

; ;; Test Cases
! (length (1 2 3))
! (is-member 1 (1 2 3))
! (append 100 (1 2))
! (max-value (1 2 3 4 5))
! (min-value (100 101 200 400 -1 500))
! (pop (1 2 3) ())
! (reverse (3 2 1) ())
! (remove-element 10 (10 1 2 3 10))
! (filter less-than-3 (1 2 3 4 5))
! (filter greater-eq-5 (1 2 3 4 5 6))
! (foldr + 0 (1 2 3 4))
! (quicksort (8 7 6 1 0 9 2))
! (remove-duplicates (1 2 2 3 1 4))