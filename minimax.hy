(import [random[randint]]
[copy[copy]])

(setv maze [])
(setv px 2)
(setv py 0)
(setv ex 2)
(setv ey 3)

(setv pool [])
(setv free [])


(for [y (range 5)]
    (for [x (range 5)]
        (setv point [])
        (if (and (or (!= px x) (!= py y)) (or (!= ex x) (!= ey y)))
            (do
                (point.append y)
                (point.append x)
                (pool.append point)
            )
        )
    ) 
)
(setv t [0 0])
(setv del_amount (- (len pool) 10))
(for [i (range del_amount)]
    (setv idx (randint 0 (- (len pool) 1)))
    (free.append (get pool idx))
    (del (get pool idx))
)
;(print free)
;(print pool)

(setv walls [])
(setv coins [])

(for [y (range 5)]
    (setv row [])
    (for [x (range 5)]
        (setv point [])
        (point.append y)
        (point.append x)
        (if (and (= px x) (= py y))
            (row.append 1)
        )
        (if (and (= ex x) (= ey y))
            (row.append 2)
        )
        (if (in point pool)
            (do 
                (setv t (randint 3 4))
                (if (= t 3)
                    (walls.append point)
                )
                (if (= t 4)
                    (coins.append point)
                )
                (row.append t)
            )
        )
        (if (in point free) 
            (row.append 0)
        )
    )
    (maze.append row)
)

(print "Generated maze: ")
(print maze)


(defn get_adjacent_points[maze y x]
    (setv dy [1, 0, -1, 0])
    (setv dx [0, 1, 0, -1])
    (setv adj_points [])
    (for [i (range 4)]
        (setv adjy (+ y (get dy i)))
        (setv adjx (+ x (get dx i)))
        (if (and (!= (get maze adjy adjx) 3) (and (in adjy (range 5)) (in adjx (range 5))))
            (do
                (setv point [adjy adjx])
                (adj_points.append point)
            )
        )
    )
    adj_points
)

(defn get_winner[py px ey ex coins]
    (setv res 0)
    (if (and (= py ey) (= px ex))
        (setv res -999999)
    )
    (if (= (len coins) 0)
        (setv res 999999)
    )
    res
)

(defn minimax[maze py px ey ex step coins score]
    (setv minimax_result [])
    (setv res 0)
    (if (> step 2)
        (setv res (+ (* (+ (abs (- px ex)) (abs (- py ey))) 500) score))
    )
    (if (<= step 2)
        (do
            (setv winner (get_winner py px ey ex coins))
            (if (!= winner 0)
                (setv res winner)
            )
            (if (= winner 0)
                (do
                    (if (= (% step 2) 1)
                        (do
                            (setv pos_available (get_adjacent_points maze py px))
                            (setv max_res -1000000)
                            (for [pos pos_available]
                                (if (in pos coins)
                                    (do
                                        (coins.remove pos)
                                        (setv t_res (get (minimax maze (get pos 0) (get pos 1) ey ex (+ step 1) coins (+ score 1000)) 0))
                                        ;(print t_res)
                                        (if (> t_res max_res)
                                            (do
                                                (setv max_res t_res)
                                                (if (= step 1)
                                                    (setv minimax_result pos)
                                                )
                                            )
                                        )
                                        
                                        (coins.append pos)
                                    )
                                )
                                (if (not (in pos coins))
                                    (do
                                        (setv t_res (get (minimax maze (get pos 0) (get pos 1) ey ex (+ step 1) coins score) 0))
                                            (if (> t_res max_res)
                                                (do
                                                    (setv max_res t_res)
                                                    (if (= step 1)
                                                        (setv minimax_result pos)
                                                    )
                                                )
                                            )
                                    )
                                )
                            )
                            (setv res max_res)
                        )
                    )
                    (if (= (% step 2) 0)
                        (do
                            (setv pos_available (get_adjacent_points maze ey ex))
                            (setv min_res 1000000)
                            (for [pos pos_available]
                                (setv min_res (min min_res (get (minimax maze py px (get pos 0) (get pos 1) (+ step 1) coins score) 0)))
                            )
                            (setv res min_res)
                        )
                    )
                )
            )
        )
    )
    (setv res [res minimax_result])
    res
)

(setv res (minimax maze py px ey ex 1 coins 0))
(print "Estimated best score: " (get res 0))
(print "Player should move to the cell " (get res 1))

;(defn minimax[maze py px ey ex step coins score]
;    (setv res 0)
;    (if (> step 2)
;        (setv res (+ (* (+ (abs (- px ex)) (abs (- py ey))) 500) score))
;    )
;    (if (<= step 2)
;        (do
;            (setv winner (get_winner py px ey ex coins))
;            (if (!= winner 0)
;                (setv res winner)
;            )
;            (if (= winner 0)
;                (do
;                    (if (= (% step 2) 1)
;                        (do
;                            (setv pos_available (get_adjacent_points maze py px))
;                            (setv max_res -1000000)
;                            (for [pos pos_available]
;                                (if (in pos coins)
;                                    (do
;                                        (coins.remove pos)
;                                        (if )
;                                        (setv max_res (max max_res (minimax maze (get pos 0) (get pos 1) ey ex (+ step 1) coins (+ score 1000))))
;                                        (coins.append pos)
;                                    )
;                                )
;                                (if (not (in pos coins))
;                                    (setv max_res (max max_res (minimax maze (get pos 0) (get pos 1) ey ex (+ step 1) coins score)))
;                                )
;                            )
;                            (setv res max_res)
;                        )
;                    )
;                    (if (= (% step 2) 0)
;                        (do
;                            (setv res (minimax maze py px (+ ey 1) (+ ex 1) (+ step 1) coins score))
;                        )
;                    )
;                )
;            )
;        )
;    )
;    res
;)