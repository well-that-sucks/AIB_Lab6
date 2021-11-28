(import [pandas :as pd])

(setv df (pd.read_csv "results.csv"))

(setv row_num (len df))

(setv probability (/ 1 row_num))
(setv math_expectation 0)
(setv i 0)
(while (< i row_num)
    (setv row (get df.iloc i))
    (setv math_expectation (+ math_expectation (* row.Time probability)))
    (setv i (+ i 1)))

(print "Mathematical expectation of time: " math_expectation)

(setv score_col (get df "Score"))

(defn calc_sum[arr]
    (setv n (len arr))
    (setv sum 0)
    (setv i 0)
    (while (< i n)
        (setv elem (get arr.iloc i))
        (setv sum (+ sum elem))
        (setv i (+ i 1)))
    sum
)
(setv x_avg (* probability (calc_sum score_col)))

(setv i 0)
(setv dispersion 0)
(while (< i row_num)
    (setv xi (get score_col.iloc i))
    (setv dispersion (+ dispersion (** (- xi x_avg) 2)))
    (setv i (+ i 1)))
(setv dispersion (* dispersion probability))
(print "Dispersion of score: " dispersion)