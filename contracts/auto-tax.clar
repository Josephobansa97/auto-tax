;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AUTO-TAX - Automated Tax Logger and Calculator
;; Author: You
;; Description: Log income, expenses, and auto-calculate taxes owed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Constants
(define-constant TAX-RATE 10) ;; 10% flat tax

;; Maps for tracking income and expenses by user and year
(define-map income-log
  { user: principal, year: uint }
  uint ;; income in microSTX
)

(define-map expense-log
  { user: principal, year: uint }
  uint ;; deductible expenses
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UTILITY FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Approximate tax year based on block height (~52,560 blocks per year)
(define-read-only (get-tax-year)
  (ok (/ stacks-block-height u52560))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PUBLIC FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Log taxable income
(define-public (log-income (amount uint))
  (let (
        (year (/ stacks-block-height u52560))
        (key { user: tx-sender, year: year })
        (current (default-to u0 (map-get? income-log key)))
       )
    (begin
      (map-set income-log key (+ current amount))
      (ok true)
    )
  )
)

;; 2. Log deductible expenses
(define-public (log-expense (amount uint))
  (let (
        (year (/ stacks-block-height u52560))
        (key { user: tx-sender, year: year })
        (current (default-to u0 (map-get? expense-log key)))
       )
    (begin
      (map-set expense-log key (+ current amount))
      (ok true)
    )
  )
)

;; 3. Calculate tax based on income - expense
(define-read-only (calculate-tax (who principal) (year uint))
  (let (
        (income (default-to u0 (map-get? income-log { user: who, year: year })))
        (expense (default-to u0 (map-get? expense-log { user: who, year: year })))
        (net-income (if (> income expense) (- income expense) u0))
       )
    (ok (/ (* net-income u10) u100)) ;; Tax = net-income * rate / 100
  )
)

;; 4. Generate a report for a specific user and year
(define-read-only (generate-report (who principal) (year uint))
  (let (
        (income (default-to u0 (map-get? income-log { user: who, year: year })))
        (expense (default-to u0 (map-get? expense-log { user: who, year: year })))
        (tax (unwrap! (calculate-tax who year) (err u1)))
       )
    (ok {
      income: income,
      expense: expense,
      tax-due: tax
    })
  )
)
