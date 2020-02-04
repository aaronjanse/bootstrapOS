#lang racket/base
(require pollen/tag)
(require racket/string)
(require racket/format)
(provide (all-defined-out))
(require txexpr racket/string)

;; delete `toc` variable

;; `make-toc` is the same
(define (make-toc) '(meta ((toc "true"))))

;; `section` doesn't toggle its behavior based on `toc` variable
;; `gensym` is a handy Racket function for id fields
;; because it avoids problems of escaping characters, etc. 
(define (section level desc . text)
  (define heading-tag-numbered (string->symbol (format "h~a" (+ 1 level))))
  `(,heading-tag-numbered [[id ,(symbol->string (gensym))]] ,@text " "
  		,(if (null? desc) "" `(span "(" ,desc ")"))))

;; use `root` as the place to gather the headings for toc-entries, 
;; because it executes last, and thus all the headings will be available
(define (root . xs)
  ;; gather the headings (using `split-txexpr` utility function in txexpr library)
  (define-values (_ headings)
    (splitf-txexpr `(root ,@xs)
                   (λ(x) (and (txexpr? x) (member (car x) '(h1 h2 h3 h4 h5 h6 h7))))))
  ;; covert these headings into toc entries using helper function
  (define toc-entries (map heading->toc-entry headings))
  ;; package the content into a `body` tag, and the toc-entries into a `toc-entries` tag
  `(root (body ,@(decode-paragraphs xs #:force? #t)) (toc-entries ,@toc-entries)))

;; helper function for `root`
(define (heading->toc-entry heading)
  `(div [[class ,(string-replace (symbol->string (get-tag heading)) "h" "nav")]]
        (a [[href ,(string-append "#" (attr-ref heading 'id))]]
        	,(car (get-elements heading)))))


(define (parify text)
	`(div ,@(car (foldl
		(lambda (this state)
			(if (and (string? this) (equal? this "\n"))
				(cons (append (car state) (list `(p ,@(cdr state)))) (list))
				(cons (car state) (append (cdr state) (list this)))))
		(cons (list) (list))
		(append text (list "\n"))))))

(define (pars . content) (parify content))

(define (date year month day)
	`(h2 ,(number->string year)
		"-"
		,(~a (number->string month) #:min-width 2 #:left-pad-string "0" #:align 'right)
		"-"
		,(~a (number->string day) #:min-width 2 #:left-pad-string "0" #:align 'right)))

(define (day year month day . text)
	`(div ,(date year month day)
		,(parify text)))

(define (quoted . text)
	`(blockquote ,(parify text)))

(define (shortcut-url url page zoom desc)
	`(a ((href ,(string-append
			url
			"#page="
			(number->string page)
			"&zoom="
			(if (null? zoom) "auto,-54,848" zoom
				)))) ,desc))


(define (armv8-arm page zoom desc)
	(shortcut-url
		"https://static.docs.arm.com/ddi0487/ca/DDI0487C_a_armv8_arm.pdf"
		page zoom desc))

(define (arm-periph page zoom desc)
	(shortcut-url
		"https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf"
		page zoom desc))

(define (cortex page zoom desc)
	(shortcut-url
		"https://static.docs.arm.com/100095/0003/cortex_a72_mpcore_trm_100095_0003_05_en.pdf"
		page zoom desc))

; (define (table . content)
; 	`(table ,@content))

(define (chat label . text)
	`(tr (td ,label)
		 (td ,(parify text))))

(define (i . text)
	`(i ,@text))

(define (b . text)
	`(b ,@text))

(define (codeblock . text)
	`(pre ,@text)) ; ,(string-join text "\n")

(define details (default-tag-function 'details))
(define summary (default-tag-function 'summary))

(define mono (default-tag-function 'code))

(define ul (default-tag-function 'ul))
(define ol (default-tag-function 'ol))
(define li (default-tag-function 'li))

(define (link url text) `(a ((href ,url)) ,text))

(require pollen/core pollen/decode)

(provide root include)

; (define (root . elems)
;   `(body ,@(decode-paragraphs elems #:force? #t)))

(define (include file)
  `(@ ,@(cdr (get-doc file))))