(gender Chandler M)
(gender John M)
(gender Adam M)
(gender Bob M)
(gender Tim M)
(gender Joey M)

(gender Monica F)
(gender Jane F)
(gender Pam F)
(gender Kim F)
(gender Eve F)
(is-parent Chandler John)
(is-parent Chandler Pam)
(is-parent Chandler Adam)
(is-parent Chandler Jane)
(is-parent Monica John)
(is-parent Monica Pam)
(is-parent Monica Adam)
(is-parent Monica Jane)
(is-parent John Bob)
(is-parent Pam Tim)
(is-parent Pam Kim)
(is-parent Adam Eve)
(is-parent Jane Joey)

(= (is-male $person)
    (match &self (gender $person $g) (if (== $g M) True False))
)



(= (get-parents $child)
    (match &self (is-parent $parent $child) $parent)
    )



(= (is-child $parent)
    (let $child (match &self (is-parent $parent $child) $child) $child)
)

(= (is-mother $child)
    (let* 
    (
        ($x (collapse (get-parents $child)))
        (($p1 $p2) $x)
    )
    (if (is-male $p1) $p2 $p1))
)


(= (is-sibling $child)
    (let $r (collapse (let* (
        ($p1 (get-parents $child))      
        ($siblings (is-child $p1)) ; Ensure output is a list
    )
    (if (== $siblings $child) (empty) $siblings)
    ))
    (unique (superpose $r)) 
    )

)


(= (filter-males $list)
    (filter-atom (superpose $list) (lambda ($person) (is-male $person)))
)







(= (is-uncle $child)
    (let* (
        ($parents (get-parents $child))  
        ($siblings (is-sibling $parents))  
        ($uncles (if (is-male $siblings) $siblings (empty)))  ; Filter uncles
    )
    $uncles
    )
)
        




(= (is-nephew $uncle)
     (let* (
            ($siblings (is-sibling $uncle))
            ($nephews (is-child $siblings))  ; Filter nephews
            ($nephew (if (is-male $nephews) $nephews (empty)))  ; Filter nephews
        )
        $nephew
        )
)

! (bind! &ancestor (new-space))
(= (ancestor $child)
    (let* (
        ($p (get-parents $child))
        ($s (add-atom &ancestor $p))
        )
        (ancestor $p)
    )

)






! (get-parents (get-parents Bob))
! (is-mother John)
! (is-child Monica)
! (is-sibling John)
!(is-uncle Bob)
!(is-nephew Pam)
!(ancestor Bob)
! (get-atoms &ancestor)



