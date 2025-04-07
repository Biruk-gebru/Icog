;; ===================== ;;
;; List Utility Functions ;;
;; ===================== ;;

;; Type Definitions
(: List (-> $a Type))
(: Nil (List $a))
(: Cons (-> $a (List $a) (List $a)))

;; ===================== ;;
;; Basic List Operations ;;
;; ===================== ;;

(: length (-> (List $a) Number))
(= (length Nil) 0)
(= (length (Cons $x $xs)) 
   (+ 1 (length $xs)))

(: is-member (-> $a (List $a) Bool))
(= (is-member $num Nil) False)
(= (is-member $num (Cons $head $tail))
   (if (== $num $head)
       True
       (is-member $num $tail)))

(: append (-> $a (List $a) (List $a)))
(= (append $num Nil) (Cons $num Nil))
(= (append $num (Cons $head $tail))
   (Cons $head (append $num $tail)))

;; ===================== ;;
;; Extremum Functions ;;
;; ===================== ;;

(: min-value (-> (List Number) Number))
(= (min-value (Cons $x Nil)) $x)
(= (min-value (Cons $x (Cons $y $ys)))
   (let*    (
                ($min-rest (min-value (Cons $y $ys)))
                ; (() (println! $min-rest))
            )
            (if (< $x $min-rest) 
                $x 
                $min-rest)
    )
)

(: max-value (-> (List Number) Number))
(= (max-value (Cons $x Nil)) $x)
(= (max-value (Cons $x (Cons $y $ys)))
   (let* (($max-rest (max-value (Cons $y $ys))))
     (if (> $x $max-rest) $x $max-rest)))

;; ===================== ;;
;; Stack Operations ;;
;; ===================== ;;

(: pop (-> (List $a) (List $a)))
(= (pop Nil) Nil)
(= (pop (Cons $x Nil)) Nil)
(= (pop (Cons $x (Cons $y $ys)))
   (Cons $x (pop (Cons $y $ys))))

;; ===================== ;;
;; List Modification ;;
;; ===================== ;;

(: remove-element (-> $a (List $a) (List $a)))
(= (remove-element $num Nil) Nil)
(= (remove-element $num (Cons $head $tail))
   (if (== $head $num)
       (remove-element $num $tail)
       (Cons $head (remove-element $num $tail))))

(: reverse (-> (List $a) (List $a)))
(= (reverse $list) (reverse-helper $list Nil))

(: reverse-helper (-> (List $a) (List $a) (List $a)))
(= (reverse-helper Nil $acc) $acc)
(= (reverse-helper (Cons $head $tail) $acc)
   (reverse-helper $tail (Cons $head $acc)))

;; ===================== ;;
;; Higher-Order Functions ;;
;; ===================== ;;

(: map (-> (-> $a $b) (List $a) (List $b)))
(= (map $f Nil) Nil)
(= (map $f (Cons $x $xs))
   (Cons ($f $x) (map $f $xs)))

(: filter (-> (-> $a Boolean) (List $a) (List $a)))
(= (filter $pred Nil) Nil)
(= (filter $pred (Cons $head $tail))
   (if ($pred $head)
       (Cons $head (filter $pred $tail))
       (filter $pred $tail)))

(: foldl (-> (-> $b $a $b) $b (List $a) $b))
(= (foldl $func $acc Nil) $acc)
(= (foldl $func $acc (Cons $head $tail))
   (foldl $func ($func $acc $head) $tail))

(: foldr (-> (-> $a $b $b) $b (List $a) $b))
(= (foldr $func $acc Nil) $acc)
(= (foldr $func $acc (Cons $head $tail))
   ($func $head (foldr $func $acc $tail)))

(: remove-duplicates (-> (List $a) (List $a)))
(= (remove-duplicates $list)
   (remove-duplicates-helper $list Nil))

(: remove-duplicates-helper (-> (List $a) (List $a) (List $a)))
(= (remove-duplicates-helper Nil $seen) Nil)
(= (remove-duplicates-helper (Cons $head $tail) $seen)
   (if (is-member $head $seen)
       (remove-duplicates-helper $tail $seen)
       (Cons $head (remove-duplicates-helper $tail (Cons $head $seen)))))

;; ===================== ;;
;; Sorting Algorithms ;;
;; ===================== ;;

(: filter-greater (-> Number (List Number) (List Number)))


(= (filter-greater $x Nil) Nil)
(= (filter-greater $x (Cons $y $ys)) 
   (if (> $y $x)  
       (Cons $y (filter-greater $x $ys))
       (filter-greater $x $ys)))

(: filter-less (-> Number (List Number) (List Number)))
(= (filter-less $x Nil) Nil)
(= (filter-less $x (Cons $y $ys)) 
   (if (< $y $x)  
       (Cons $y (filter-less $x $ys))
       (filter-less $x $ys)))

(: quicksort (-> (List Number) (List Number)))
(= (quicksort Nil) Nil)
(= (quicksort (Cons $pivot $rest))
   (let* (($lesser (filter-less $pivot $rest))  ; Fixed function name (was filter-lesser)
          ($greater (filter-greater $pivot $rest))
          ($sorted-lesser (quicksort $lesser))
          ($sorted-greater (quicksort $greater)))
     (concat $sorted-lesser 
             (Cons $pivot $sorted-greater))))

(: concat (-> (List $a) (List $a) (List $a)))
(= (concat Nil $b) $b)
(= (concat (Cons $head $tail) $b)
   (Cons $head (concat $tail $b)))

;; ===================== ;;
;; Example Usages ;;
;; ===================== ;;

;; Predicates for filter examples
(= (less-than-3 $x) (< $x 3))
(= (greater-eq-5 $x) (>= $x 5))

;; Test Cases
! (length (Cons 1 (Cons 2 (Cons 3 Nil))))
! (is-member 1 (Cons 1 (Cons 2 (Cons 3 Nil))))
! (append 100 (Cons 1 (Cons 2 Nil)))
! (max-value (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 5 Nil))))))
! (min-value (Cons 100 (Cons 101 (Cons 200 (Cons 400 (Cons -1 (Cons 500 Nil)))))))
! (pop (Cons 1 (Cons 2 (Cons 3 Nil))))
! (reverse (Cons 3 (Cons 2 (Cons 1 Nil))))
! (remove-element 10 (Cons 10 (Cons 1 Nil)))
! (filter less-than-3 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 5 Nil))))))
! (filter greater-eq-5 (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 5 (Cons 6 Nil)))))))
! (foldr + 0 (Cons 1 (Cons 2 (Cons 3 (Cons 4 Nil)))))
! (quicksort (Cons 8 (Cons 7 (Cons 6 (Cons 1 (Cons 0 (Cons 9 (Cons 2 Nil))))))))
! (remove-duplicates (Cons 1 (Cons 2 (Cons 2 (Cons 3 (Cons 1 (Cons 4 Nil)))))))
