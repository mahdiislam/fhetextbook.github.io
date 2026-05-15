#set heading(numbering: "1.")
#strong[\- Reference:]
#link("https://e.math.cornell.edu/people/belk/numbertheory/CyclotomicPolynomials.pdf")[Fields and Cyclotomic Polynomials]

== Definitions
<subsec:roots-def>
#block[
- #strong[$bold(n)$-th root of Unity:] A complex number $zeta$ that
  satisfies the equation $zeta^n = 1$

- #strong[Primitive $bold(n)$-th Root of Unity:] Any $n$-th root of
  unity $zeta$ such that $sans("ord")_(bb(C))\(zeta\)= n$. We denote
  $P\(n\)$ as a set of primitive $n$-th root of unity.

$$

A primitive $n$-th root of unity is considered a #emph[generator] of all
$n$ $n$-th roots of unity.

]
== Theorems
<subsec:roots-theorem>
#block[
Given $zeta^n = 1$, there exist exactly $n$ different $n$-th roots of
unity:

$$

$zeta = e^(2 k pi i\/n) = cos (frac(2 k pi, n)) + i dot.op sin (frac(2 k pi, n))$,

$$

for $n$ different $k$ values, where $k = { 0\,1\,dots.h.c\,n - 1 }$.

]
#block[
+ Suppose $zeta = e^(2 k pi i\/n)$. Then,
  $zeta^n =\(e^(2 k pi i\/n)\)^n= e^(2 k pi i)$, and since $zeta^n = 1$,
  we need to find the $k$ values such that $e^(2 k pi i) = 1$

+ Euler's formula states that
  $e^(i dot.op x) = upright("cos")\(x\)+ i dot.op upright("sin")\(x\)$.
  Therefore, if $x = 2 k pi$, then
  $e^(2 k pi i) = upright("cos")\(2 k pi\)+ i dot.op upright("sin")\(2 k pi\)$.
  This formula becomes 1 if $k = 0\,1\,2\,. . .$. Thus,
  $e^(2 k pi i) = 1$ for any integer $k gt.eq 0$.

+ If
  $zeta = e^(2 k pi i\/n) = upright("cos")\(frac(2 k pi, n)\)+ i dot.op upright("sin")\(frac(2 k pi, n)\)$,
  then the first $n$ roots for $k = 0\,1\,. . . upright(" ") n - 1$ are
  all distinct values, because they lie on the circle in the complex
  plane (where $x$-axis is a real value and $y$-axis is a complex value
  coefficient) at each angle $2 k pi\/n$ for
  $k = { 0\,1\,dots.h.c\,n - 1 }$.

+ Note $zeta^n = 1$ is an $n$-th polynomial, so it can have at most $n$
  roots. Thus, we can consider the first $n$ roots $e^(2 k pi i\/n)$ for
  $k = { 0\,1\,dots.h.c\,n - 1 }$ as the $n$ distinct roots and ignore
  the rest of roots (i.e., $k gt.eq n$), considering them to be
  repetitions of the first $n$ roots on a circle in the complex plane
  (see #link(<fig:complex-plane>)[1]).

]
#figure(image("figures/euler-formula.png", width: 40.0%),
  caption: [
    The figure illustrates a circle of Euler's formula in the complex
    plane
    #link("https://en.wikipedia.org/wiki/Euler's_formula")[\(Source)]
  ]
)
<fig:complex-plane>

#block[
Given $zeta in bb(C)$ (the complex number domain) and $zeta^n = 1$ where
$n gt.eq 1$, $zeta$ is an $n$-th root of unity if and only if
$sans("ord")_(bb(C))\(zeta\)upright(" ")\|upright(" ") n$.

]
#block[
#emph[Proof.] We use Theorem 1:

+ #emph[Forward Proof:] Since $sans("ord")_(bb(C))\(zeta\)= k$ is the
  smallest integer such that $zeta^k = 1$, for any $n$ that satisfies
  $zeta^n = 1$, $n$ must be a multiple of $k$. This means that
  $k divides n$.

+ #emph[Backward Proof:] If $k divides n$, then $n$ is a multiple of
  $k$, which means that $zeta^n = 1$.

~◻

]
#block[
The set of all $n$-th roots of unity is the union
$union.big_(d\|n) P\(d\)$ (i.e., the union of all primitive $d$-th roots
of unity where $d upright(" ")\|upright(" ") n$).

]
#block[
+ Let $omega = e^(2 pi i\/n)$. Given $zeta^n = 1$, for each $n$-th root
  of unity $zeta$ is, $zeta = omega^(k_i)$ for
  $k_i = { 0\,1\,dots.h.c\,n - 1 }$. Note that according to
  Theorem 1, $\(omega^(k_i)\)^n= 1$ if and only
  if $sans("ord")_(bb(C))\(omega^(k_i)\)upright(" ")\|upright(" ") n$.

+ Let $sans("ord")_(bb(C))\(omega^(k_i)\)= d_i$. Then,
  $\(omega^(k_i)\)^(d_i)= 1$. Combining these two facts, each $n$-th
  root of unity $omega^(k_i)$ is also the primitive $d_i$-th root of
  unity (i.e., a solution for $zeta^(d_i) = 1$), that is,
  $omega^(k_i) in P\(d_i\)$.

+ Remember that for each $sans("ord")_(bb(C))\(omega^(k_i)\)= d_i$,
  $d_i upright(" ")\|upright(" ") n$. For every $d_i$ that divides $n$,
  all the (primitive) $d_i$-th roots of unity are also the $n$-th root
  of unity. This is because the (primitive) $d_i$-th root of unity that
  satisfies $zeta^(d_i) = 1$ also satisfies $zeta^n = 1$ (as $n$ is a
  multiple of $d_i$).

+ Step 2 concludes that each $n$-th root of unity is a primitive
  $d_i$-th root of unity for some $d_i$ that divides $n$. Step 3
  concludes that each $d_i$-th root of unity, where $d_i$ divides $n$,
  is also the $n$-th root of unity. Combining these two conclusions, the
  set of all $n$-th root of unity is equivalent to the union of all
  primitive $d_i$-th roots of unity where $d_i$ divides $n$ (i.e.,
  $union.big_(d\|n) P\(d\)$).

]
#block[
Given an $n$-th root of unity $zeta = omega^k$ for
$k = { 0\,1\,dots.h.c\,n - 1 }$ where $omega = e^(2 pi i\/n)$, $zeta$ is
a primitive $n$-th root of unity if and only if
$upright("gcd")\(n\,k\)= 1$ (i.e., $k$ is co-prime to $n$).

]
#block[
+ Note that $zeta^n = 1$ and $zeta = omega$ for $k = 1$. Thus,
  $sans("ord")_(bb(C))\(omega\)= n$.

+ Theorem 2 states that if
  $o r d_(bb(F))\(a\)= k$, then for any $n gt.eq 1$,
  $o r d_(bb(F))\(a^n\)= frac(k, upright("gcd")\(k\,n\))$. Similarly, if
  $sans("ord")_(bb(C))\(omega\)= n$, then for any $k gt.eq 1$,
  $sans("ord")_(bb(C))\(omega^k\)= frac(n, upright("gcd")\(k\,n\))$.

+ Step 2 implies that $sans("ord")_(bb(C))\(omega^k\)= n$ (i.e.,
  $omega^k$ is a primitive $n$-th root of unity) if and only if
  $upright("gcd")\(k\,n\)= 1$.

]
#block[
The number of primitive $n$-th roots of unity is $phi.alt\(n\)$ (i.e.,
the number of elements in ${ 1\,dots.h.c\,n - 1 }$ that are coprime to
$n$).

]
#block[
#emph[Proof.] $$

+ Given $zeta^n = 1$, the roots of unity are $zeta = omega^k$ where
  $omega = e^(2 pi i\/n)$ and $k = { 0\,1\,dots.h.c\,n - 1 }$

+ By definition, $omega^k$ is a primitive $n$-th root of unity if and
  only if $sans("ord")_(bb(C))\(omega^k\)= n$.

+ $omega$ is a primitive $n$-th root of unity because
  $sans("ord")_(bb(C))\(omega\)= n$.

+ According to Theorem 2, if
  $sans("ord")_(bb(C))\(omega\)= n$, then
  $sans("ord")_(bb(C))\(omega^k\)= frac(n, upright("gcd")\(k\,n\))$.
  Therefore, in order for $sans("ord")_(bb(C))\(omega^k\)= n$,
  $upright("gcd")\(k\,n\)$ has to be 1. In other words, $k$ and $n$ have
  to be co-prime. The total number of such co-primes between $n$ and
  $k = { 1\,2\,dots.h.c\,n - 1 }$ (excluding 0 because
  $upright("gcd")\(0\,n\)= n$ and also
  $sans("ord")_(bb(C))\(omega^0\)= sans("ord")_(bb(C))\(1\)= 1 eq.not n$)
  is $phi.alt\(n\)$, which corresponds to the total number of the
  primitive $n$-th root of unity.

~◻

]
