#set heading(numbering: "1.")

== Definitions
<subsec:cyclotomic-def>
#block[
#strong[The $bold(n)$-th Cyclotomic Polynomial:] is a polynomial whose
roots are the primitive $n$-th roots of unity, that is:

\$\$\\Phi\_n(x) = \\prod\_{\\zeta \\in P(n)} (x - \\zeta)  = \\prod\_{\\substack{0 \\leq k \\leq n-1,\\\\ 
 \\text{gcd}(k, n) = 1}} (x - \\omega^k) \\textcolor{white}{......} \\text{, where } \\omega = e^{2\\pi i/n}\$\$

Remember the Euler's formula:
$e^(2 k pi i\/n) = cos (frac(2 k pi, n)) + i dot.op sin (frac(2 k pi, n))$

$$

A few pre-computed cyclotomic polynomials are as follows:

#block[
2 $Phi_1\(x\)= x - 1$ \ $Phi_2\(x\)= x + 1$ \ $Phi_3\(x\)= x^2 + x + 1$
\ $Phi_4\(x\)= x^2 + 1$ \ $Phi_5\(x\)= x^4 + x^3 + x^2 + x + 1$ \
$Phi_6\(x\)= x^2 - x + 1$ \
$Phi_7\(x\)= x^6 + x^5 + x^4 + x^3 + x^2 + x + 1$ \
$Phi_8\(x\)= x^4 + 1$ \ $Phi_9\(x\)= x^6 + x^3 + 1$ \
$Phi_10\(x\)= x^4 - x^3 + x^2 - x + 1$

]
]
As one example,

$ Phi_4\(x\)= product_(0 lt.eq k lt.eq 3\,\
upright("gcd")\(k\,4\)= 1)\(x - omega^k\)=\(x - omega^1\)\(x - omega^3\)=\(x - e^(2 pi i\/4)\)\(x - e^(2 dot.op 3 pi i\/4)\)=\(x - e^(pi i\/2)\)\(x - e^(3 pi i\/2)\) $

$= (x - (cos (pi / 2) + i dot.op sin (pi / 2))) dot.op (x - (cos (frac(3 pi, 2)) + i dot.op sin (frac(3 pi, 2))))$

$=\(x - i\)\(x + i\)= x^2 + 1$

== Theorems
<subsec:cyclotomic-theorem>
#block[
Suppose that $M$ is a power of 2 and the $M$-th cyclotomic polynomial
$Phi_M\(x\)= x^n + 1$ (where $M = 2 n$). Then, the roots of the $M$-th
cyclotomic polynomial are
$omega\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 1)$, where
$omega = e^(i pi\/n)$

]
#block[
#emph[Proof.] According to Definition~@subsec:cyclotomic-def in
#link(<subsec:cyclotomic-def>)[0.1], the roots of $Phi_M\(x\)$ are
$e^(2 k pi i\/M) = e^(2 k pi i\/\(2 n\)) = e^(k pi i\/n)$ where
$0 lt.eq k < M = 2 n$ and $sans("gcd")\(k\,M = 2 n\)= 1$, thus
$k = { 1\,3\,5\,dots.h.c\,2 n - 1 }$. If we let $omega = e^(i pi\/n)$,
then the roots of $Phi_M\(x\)$ are
$omega\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 1)$.~◻

]
#block[
For any positive integer $n$,
$ x^n - 1 = product_(d divides n) Phi_d\(x\) $

]
#block[
+ The roots of $x^n - 1$ are all the $n$-th roots of unity. Thus,
  $x^n - 1 =\(x - omega^0\)\(x - omega^1\). . .\(x - omega^(n - 1)\)$,
  where $zeta = omega^k$.

+ Theorem 3 states that each $n$-th root of unity
  ($omega^k$) is a primitive $d$-th root of unity for some $d$ that
  divides $n$. In other words, each $n$-th root of unity belongs to some
  $P\(d\)$ where $d divides n$. Meanwhile, by definition,
  $Phi_d\(x\)= Pi_(zeta in P\(d\))\(x - zeta\)$. Therefore, $x^n - 1$ is
  the product of all $Phi_d\(x\)$ such that $d divides n$.

]
#block[
A cyclotomic polynomial has only integer coefficients.

]
#block[
+ We prove by induction. When $n = 1$, $Phi_1\(x\)= x - 1$, where each
  coefficient is an integer.

+ Let
  $x^n - 1 = f\(x\)dot.op g\(x\)=\(Sigma_(i = 0)^p a_i x^i\)\(Sigma_(j = 0)^q b_j x^j\)$.
  As an induction hypothesis 1, we will prove that if $f\(x\)$ has only
  integer coefficients, then $g\(x\)$ will also have only integer
  coefficients. Given our target equation is $x^n - 1$, we know that
  $a_p x^p dot.op b_q x^q = x^n$, and thus $a_p b_q = 1$, which means
  $a_p = plus.minus 1$ (as we hypothesized that $f\(x\)$ has only
  integer coefficients). We also know that $a_0 b_0 = - 1$. All the
  other coefficients should be 0. Thus, for any $r < q$, the
  coefficients are either: (i)
  $a_p b_r + a_(p - 1) b_(r + 1) + . . . + a_(p - q + r) b_q = 0$\; or
  (ii) $a_p b_r + a_(p - 1) b_(r + 1) + . . . + a_0 b_(r + p) = 0$. Both
  case (i) and (ii) represent $f\(x\)dot.op g\(x\)$'s computed
  coefficient of some $x^i$ where $0 < i < n$. Now, we propose another
  induction hypothesis 2, which is that
  $b_q\,. . . upright(" ") b_(r + 1)$ are all integers.

+ In the case of (i),
  $a_p b_r = -\(a_(p - 1) b_(r + 1) + . . . + a_(p - q + r) b_q\)$, and
  dividing both sides by $a_p$ (which is either $1$ or $- 1$),
  $b_r = plus.minus\(a_(p - 1) b_(r + 1) + . . . + a_(p - q + r) b_q\)$,
  as every $a_i$ is an integer based on our hypothesis. By induction
  hypothesis 1 and 2, $b_r$ is an integer. The same is true in the case
  of (ii).

+ We set $b_q$ (an integer coefficient) as the starting point for
  induction hypothesis 2. Then, according to induction proof 2, all of
  $b_j$ for $0 lt.eq j lt.eq q$ are integers.

+ Now, we set $Phi_1\(x\)$ (an integer coefficient polynomial) as the
  starting point for induction hypothesis 1. Let
  $x^n - 1 = Phi_(d_1)\(x\)Phi_(d_2)\(x\). . . Phi_(d_k)\(x\)Phi_n\(x\)$,
  where each $d_i divides n$ (Theorem~@subsec:cyclotomic-theorem\.2). We
  know that $Phi_(d_1)\(x\)Phi_(d_2)\(x\)dots.h.c Phi_(d_k)\(x\)$ forms
  an integer coefficient polynomial. We treat
  $Phi_(d_1)\(x\)Phi_(d_2)\(x\)dots.h.c Phi_(d_k)\(x\)$ as $f\(x\)$, and
  $Phi_n\(x\)$ as $g\(x\)$. Then, according to step 4's induction proof,
  $Phi_n\(x\)$ is an integer coefficient polynomial (also note that
  $Phi_n\(x\)$ is monic, whose the highest degree's coefficient is 1).

+ As we marginally increase $n$ to $n + 1$ to compute
  $x^(n + 1) - 1 = Phi_(d'_1)\(x\)Phi_(d'_2)\(x\). . . Phi_(d'_k)\(x\)Phi_(n + 1)\(x\)$
  (where each $d'_i divides\(n + 1\)$), we know that
  $Phi_(d'_1)\(x\)Phi_(d'_2)\(x\)dots.h.c Phi_(d'_k)\(x\)$ is a monic
  polynomial, as proved by the previous induction step. Thus,
  $Phi_(n + 1)\(x\)$ is also monic.

]
#block[
If $k divides n$, then $Phi_(n k)\(x\)= Phi_n\(x^k\)$.

]
#block[
+ Theorem 3 states that given $k divides n$,
  $upright("ord")_(bb(F))\(a\)= k n$ if and only if
  $upright("ord")_(bb(F))\(a^k\)= n$. This means that for
  $zeta in bb(C)$, $upright("ord")_(bb(C))\(zeta\)= n k$ if and only if
  $upright("ord")_(bb(C))\(zeta^k\)= n$. In other words, $zeta$ is a
  primitive $n k$-th root of unity if and only if $zeta^k$ is the
  primitive $n$-th root of unity. This implies that $zeta$ is a root of
  $Phi_(n k)\(x\)$ if and only if $zeta^k$ is a root of $Phi_n\(x\)$.

+ Let $Phi_(n k)\(x\)=\(x - zeta_1\)\(x - zeta_2\). . .\(x - zeta_p\)$,
  where $P\(n k\)$ has $p$ primitive $n k$-th roots of unity.

+ $Phi_n\(x\)=\(x - zeta_1^k\)\(x - zeta_2^k\). . .\(x - zeta_p^k\)$.
  Note that raising each element of $P\(n k\)$ to the $k$-th power
  yields an element of $P\(n\)$, thus mapping $P\(n k\)$ onto $P\(n\)$
  (by the result of step 2). Now, it's also true that
  $Phi_n\(y\)=\(y - zeta_1^k\)\(y - zeta_2^k\). . .\(y - zeta_p^k\)$,
  where $y = x^k$. In this case, $x = { zeta_1\,zeta_2\,. . . zeta_p }$.

+ $Phi_(n k)\(x\)$ and $Phi_n\(y\)= Phi_n\(x^k\)$ have the same roots
  with the same coefficients. Therefore,
  $Phi_(n k)\(x\)= Phi_n\(y\)= Phi_n\(x^k\)$.

]
