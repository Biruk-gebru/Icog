;; ========================= ;;
;; Binary Tree Data Structure ;;
;; ========================= ;;

(: BinaryTree (-> $a Type))
(: Empty (BinaryTree $a))
(: Node (-> $a (BinaryTree $a) (BinaryTree $a) (BinaryTree $a)))


;; =================== ;;
;; Concat Function     ;;
;; =================== ;;
(: concat (-> (List $a) (List $a) (List $a)))
(= (concat Nil $b) $b)
(= (concat (Cons $head $tail) $b)
   (Cons $head (concat $tail $b)))
; 

;; =================== ;;
;; Insert Function     ;;
;; =================== ;;

(: insert (-> Number (BinaryTree Number) (BinaryTree Number)))
(= (insert $x Empty) (Node $x Empty Empty))
(= (insert $x (Node $val $left $right))
   (if (< $x $val)
       (let $l (insert $x $left) (Node $val $l $right))
       (let $r (insert $x $right) (Node $val $left $r))))

;; ========================= ;;
;; Tree Traversal Functions ;;
;; ========================= ;;

(: preorder (-> (BinaryTree $a) (List $a)))
(= (preorder Empty) Nil)
(= (preorder (Node $val $left $right))
   (Cons $val (concat (preorder $left) (preorder $right))))

(: inorder (-> (BinaryTree $a) (List $a)))
(= (inorder Empty) Nil)
(= (inorder (Node $val $left $right))
   (concat (inorder $left) (Cons $val (inorder $right))))

(: postorder (-> (BinaryTree $a) (List $a)))
(= (postorder Empty) Nil)
(= (postorder (Node $val $left $right))
   (concat (postorder $left) (concat (postorder $right) (Cons $val Nil))))

;; =================== ;;
;; Search Function     ;;
;; =================== ;;

(: search (-> Number (BinaryTree Number) Bool))
(= (search $x Empty) False)
(= (search $x (Node $val $left $right))
   (if (== $x $val)
       True
       (if (< $x $val)
           (search $x $left)
           (search $x $right))))

;; =================== ;;
;; Example Usage       ;;
;; =================== ;;

; (: small-tree (BinaryTree Number))
(= (small-tree) 
   (Node 10 
     (Node 5 
       (Node 3 Empty Empty) 
       (Node 7 Empty Empty))
     (Node 15 Empty Empty)))

! (insert 14 (small-tree))
! (preorder (small-tree))
! (inorder (small-tree))
! (postorder (small-tree))
! (search 7 (small-tree))
! (search 100 (small-tree))
