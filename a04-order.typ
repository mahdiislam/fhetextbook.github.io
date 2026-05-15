#strong[\- Reference:]
#link("https://e.math.cornell.edu/people/belk/numbertheory/CyclotomicPolynomials.pdf")[Fields and Cyclotomic Polynomials]~@cyclotomic-polynomial

== Definitions
<subsec:order-def>
#block[
$bold(sans("ord")_(bb(F))\(a\))$: For $a in bb(F)^times$ (a finite
field, #link(<subsec:field-def>)[\[subsec:field-def\]]), $a$'s order is
the smallest positive integer $k$ such that $a^k = 1$.

]
== Theorems
<subsec:order-theorem>
#block[
For $a in bb(F)^times$, and $n gt.eq 1$, $a^n = 1$ if and only if
#strong[ord]$""_(bb(F))\(a\)upright(" ") divides upright(" ") n$

\(i.e., $sans("ord")_(bb(F))\(a\)$ divides $n$).

]
#block[
+ #emph[Forward Proof:] If
  $sans("ord")_(bb(F))\(a\)upright(" ")\|upright(" ") n$, then for
  $sans("ord")_(bb(F))\(a\)= k$ where $k$ is $a$'s order, and $n = l k$
  for some integer $l$.

  Then, $a^n = a^(l k) =\(a^k\)^l= 1^l = 1$.

+ #emph[Backward Proof:] If $a^n = 1$ and $sans("ord")_(bb(F))\(a\)= k$,
  write $n = q k + r$ with $0 lt.eq r < k$. Then
  $1 = a^n = a^(q k + r) =\(a^k\)^qa^r = a^r$. By minimality of $k$, we
  must have $r = 0$, hence $k divides n$.

]
#block[
If $sans("ord")_(bb(F))\(a\)= k$, then for any $n gt.eq 1$,
$sans("ord")_(bb(F))\(a^n\)= frac(k, gcd\(k\,n\))$.

]
#block[
+ $a^k\,a^(2 k)\,a^(3 k)\,dots.h = 1$.

+ Given $sans("ord")_(bb(F))\(a^n\)= m$,
  $\(a^n\)^m\,\(a^n\)^(2 m)\,\(a^n\)^(3 m)\,dots.h = 1$

+ Note that by definition of order, $x = k$ is the smallest value that
  satisfies $a^x$ = 1. Thus, given $sans("ord")_(bb(F))\(a^n\)= m$, then
  $m$ is the smallest integer that makes $\(a^n\)^m= 1$. Note that
  $\(a^n\)^m$ should be a multiple of $a^k$, which means $m n$ should be
  a multiple of $k$. The smallest possible integer $m$ that makes $m n$
  a multiple of $k$ is $m = frac(k, gcd\(k\,n\))$.

]
#block[
Suppose $k$ divides $n$. Then, $sans("ord")_(bb(F))\(a\)= k n$ if and
only if $sans("ord")_(bb(F))\(a^k\)= n$.

]
#block[
+ #emph[Forward Proof:] Given $sans("ord")_(bb(F))\(a\)= k n$, and given
  Theorem~@subsec:order-theorem\.2,
  $sans("ord")_(bb(F))\(a^k\)= frac(n k, gcd\(k\,n k\)) = frac(n k, k) = n$.

+ #emph[Backward Proof:] Given $sans("ord")_(bb(F))\(a^k\)= n$ and
  letting $sans("ord")_(bb(F))\(a\)= m$,
  Theorem~@subsec:order-theorem\.2 gives
  $sans("ord")_(bb(F))\(a^k\)= frac(m, gcd\(m\,k\)) = n$, so
  $m = n dot.op gcd\(m\,k\)$ (i.e., $m$ is some multiple of $n$). But
  since $k$ divides $n$, $k$ also divides $m$. This means that
  $gcd\(m\,k\)= k$. Hence,
  $sans("ord")_(bb(F))\(a\)= m = n dot.op gcd\(m\,k\)= n k$.

]
#block[
Given $\|bb(F)\|= p$ (a prime) and $a in bb(F)$, $a^p = a$.

]
#block[
+ If $a = 0$, then $a^p = a = 0$.

+ If $a eq.not 0$, then $a in bb(F)^times$, the multiplicative group of
  the field, which has size $\|bb(F)^times\|= p - 1$. By Lagrange's
  theorem (in a finite group $G$, the order of any element divides
  $\|G\|$), the order of $a$ divides $p - 1$, hence $a^(p - 1) = 1$.
  Therefore $a^p = a$.

]
