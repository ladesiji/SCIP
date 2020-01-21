#lang planet neil/sicp
#|
扩充例题2.3.2 将幂的求导规则也加进来
符号求导
1、先定义求导算法,操作抽象对象
2、再定义具体对象的表示
|#

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum
          (deriv (addend exp) var)
          (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (multiplicand exp)
                        (deriv (multiplier exp) var))))
         (else
          (error "unknown expression exp tpye --DERIV" exp))))

(define (variable? x) (symbol? x))
(define (same-variable? a b)
  (and (variable? a)(variable? b)(eq? a b)))



(define (=number? a b)
  (and (number? a)(= a b)))
                         
(define (make-sum a1 . a2)
    (if (single-operand? a2)
        (let ((a2 (car a2)))
            (cond ((=number? a1 0)
                    a2)
                  ((=number? a2 0)
                    a1)
                  ((and (number? a1) (number? a2))
                    (+ a1 a2))
                  (else
                    (list '+ a1 a2))))
        (cons '+ (cons a1 a2))))

(define (sum? x)
    (and (pair? x)
         (eq? (car x) '+)))

(define (addend s)
    (cadr s))

(define (augend s)
    (let ((tail-operand (cddr s)))
        (if (single-operand? tail-operand)
            (car tail-operand)
            (apply make-sum tail-operand))))


(define (make-product m1 . m2)
    (if (single-operand? m2)
        (let ((m2 (car m2)))
            (cond ((or (=number? m1 0) (=number? m2 0))
                    0)
                  ((=number? m1 1)
                    m2)
                  ((=number? m2 1)
                    m1)
                  ((and (number? m1) (number? m2))
                    (* m1 m2))
                  (else
                    (list '* m1 m2))))
        (cons '* (cons m1 m2))))

(define (product? x)
    (and (pair? x)
         (eq? (car x) '*)))

(define (multiplier p)
    (cadr p))

(define (multiplicand p)
    (let ((tail-operand (cddr p)))
        (if (single-operand? tail-operand)
            (car tail-operand)
            (apply make-product tail-operand))))

(define (single-operand? m2)(null? (cdr m2)))
  