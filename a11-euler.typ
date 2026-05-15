== Pythagorean Identity
<subsec:pythagorean>
#figure([],
  caption: [
  ]
)

#block[
$sin^2 theta + cos^2 theta = 1$

]
#block[
#emph[Proof.] $$

+ In #link(<fig:pythagorean-theorem>)[\[fig:pythagorean-theorem\]], by
  Pythagorean theorem, $a^2 + b^2 = c^2$.

+ In #link(<fig:pythagorean-identity>)[\[fig:pythagorean-identity\]], by
  definition of sin and cosine,

  $sin theta = a / c\,upright(" ") cos theta = b / c$

+ Combining step 1 and 2:

  $sin^2 theta + cos^2 theta = a^2 / c^2 + b^2 / c^2 = frac(a^2 + b^2, c^2) = 1$

~◻

]
== Imaginary Number
<imaginary-number>
n <subsec:imaginary>

#block[
- is defined to be an imaginary number that has the property:
  $i^2 = - 1$

- #strong[Complex Number] is a number of the form $a + b thin i$, where
  $a$ and $b$ are real numbers (e.g., $a = 5.6 + 4.3 i\)$

- #strong[Real Number] is a number that does not involve any imaginary
  number (e.g., $a = 13.4$)

- $overline(a)$ is a #strong[Conjugate] of $a$ if $a$ and $overline(a)$
  have the same real number part and an opposite-signed imaginary number
  part

  \(e.g., $a = 3 + i dot.op 3.4$, $overline(a) = 3 - i dot.op 3.4$)

- #strong[Hermitian Vector] is a vector where the 2nd half of its
  elements is the complex conjugate of the 1st half in reverse order, as
  illustrated by the $n$-dimensional vector below:

  $arrow(v) =\(v_1\,v_2\,v_3\,dots.h.c\,v_(n / 2 - 1)\,v_(n / 2)\,overline(v)_(n / 2)\,overline(v)_(n / 2 - 1)\,dots.h.c\,overline(v)_3\,overline(v)_2\,overline(v)_1\)$

]
== Euler's Formula
<subsec:euler>
#block[
$e^(i theta) = cos theta + i dot.op sin theta$

]
#figure(image("figures/euler-formula.png", width: 40.0%),
  caption: [
    The figure illustrates Euler's formula on the unit circle in the
    complex plane
    #link("https://en.wikipedia.org/wiki/Euler's_formula")[\(Source)]
  ]
)

The value of $e^(i theta)$ is represented as a coordinate on a circle in
the complex plane in #link(<fig:complex-plane>)[\[fig:complex-plane\]],
where the $x$-axis encodes the value's real number part and the $y$-axis
encodes the value's imaginary number part. Note that as $theta$
increases, the imaginary part ($sin theta$) oscillates between $1$ and
$- 1$ (reaching $i$ and $- i$ on the imaginary axis), and the real part
($cos theta$) oscillates between $1$ and $- 1$, with period $2 pi$.

== Vandermonde Matrix with Roots of Cyclotomic Polynomial over Complex Numbers
<subsec:vandermonde-euler>
In this subsection, we will build a Vandermonde matrix
(#link(<subsec:vandermonde>)[\[subsec:vandermonde\]]) with the $n$
distinct roots of the $mu$-th cyclotomic polynomial over complex numbers
(where $mu$ is a power of 2) as follows:

#block[
Suppose we have an $n times n$ (where $n$ is a power of 2) Vandermonde
matrix comprised of $n$ distinct roots of the $mu$-th cyclotomic
polynomial (explained in Theorem~@subsec:cyclotomic-theorem\.1 in
#link(<subsec:cyclotomic-theorem>)[\[subsec:cyclotomic-theorem\]]),
where $mu$ is a power of 2 and $n = mu / 2$. In other words,
$V = italic(V a n d e r)\(x_0\,x_1\,dots.h.c\,x_(n - 1)\)$, where each
$x_j =\(e^(i pi\/n)\)^(2 j - 1)$ for $1 lt.eq j lt.eq n$ (i.e., the
primitive $mu$-th roots of unity). Then, the following holds:

$V dot.op V^T = mat(delim: "[", 0, dots.h.c, 0, 0, n; 0, dots.h.c, 0, n, 0; 0, dots.h.c, n, 0, 0; dots.v, dots.up, dots.v, dots.v, dots.v; n, 0, 0, dots.h.c, 0; #none) = n dot.op I_n^R$

$$

And $V^(- 1) = frac(V^T dot.op I_n^R, n)$

]
#block[
#emph[Proof.] $$

+ Given $omega = e^(i pi\/n)$, each $x_j =\(omega\)^(2 j - 1)$. Thus, we
  can expand as follows:

  $V dot.op V^T = mat(delim: "[", 1, \(omega\), \(omega\)^2, dots.h.c, \(omega\)^(n - 1); 1, \(omega^3\), \(omega^3\)^2, dots.h.c, \(omega^3\)^(n - 1); 1, \(omega^5\), \(omega^5\)^2, dots.h.c, \(omega^5\)^(n - 1); dots.v, dots.v, dots.v, dots.down, dots.v; 1, \(omega^(2 n - 1)\), \(omega^(2 n - 1)\)^2, dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none) dot.op mat(delim: "[", 1, 1, 1, dots.h.c, 1; \(omega\), \(omega^3\), \(omega^5\), dots.h.c, \(omega^(2 n - 1)\); \(omega\)^2, \(omega^3\)^2, \(omega^5\)^2, dots.h.c, \(omega^(2 n - 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), \(omega^5\)^(n - 1), dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$

  $$

  $= mat(delim: "[", sum_(k = 0)^(n - 1) omega^(2 k), sum_(k = 0)^(n - 1) omega^(4 k), sum_(k = 0)^(n - 1) omega^(6 k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2 n k); sum_(k = 0)^(n - 1) omega^(4 k), sum_(k = 0)^(n - 1) omega^(6 k), sum_(k = 0)^(n - 1) omega^(8 k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2 k\(n + 1\)); sum_(k = 0)^(n - 1) omega^(6 k), sum_(k = 0)^(n - 1) omega^(8 k), sum_(k = 0)^(n - 1) omega^(10 k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2 k\(n + 2\)); dots.v, dots.v, dots.v, dots.down, dots.v; sum_(k = 0)^(n - 1) omega^(2 n k), sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k), sum_(k = 0)^(n - 1) omega^(2\(n + 2\)k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2\(n + n - 1\)k); #none)$

  $$

+ The $V dot.op V^T$ matrix's anti-diagonal elements are
  $sum_(k = 0)^(n - 1) omega^(2 n k)$. We can derive the following:

  $sum_(k = 0)^(n - 1) omega^(2 n k) = sum_(k = 0)^(n - 1)\(e^(i pi\/n)\)^(2 n k)= sum_(k = 0)^(n - 1) e^(2 pi k i) = sum_(k = 0)^(n - 1)\(cos\(2 pi k\)+ i sin\(2 pi k\)\)= sum_(k = 0)^(n - 1)\(1 + 0\)= n$

  This means that The $V dot.op V^T$ matrix's anti-diagonal elements are
  $n$.

  $$

+ Next, we will prove that the $V dot.op V^T$ matrix has 0 for all
  positions except for the anti-diagonal ones. In other words, we will
  prove the following:

  $sum_(k = 0)^(n - 1) omega^(2 k) = sum_(k = 0)^(n - 1) omega^(4 k) = sum_(k = 0)^(n - 1) omega^(6 k) = dots.h.c = sum_(k = 0)^(n - 1) omega^(2\(n - 1\)k) = sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k) = dots.h.c = sum_(k = 0)^(n - 1) omega^(2\(2 n - 1\)k) = 0$

  For this proof, we will leverage the Geometric Sum formula
  $sum_(i = 0)^(n - 1) x^i = frac(x^n - 1, x - 1)$:

  #block[
  Let the geometric sum $S_n = 1 + x + x^2 + dots.h.c + x^(n - 1)$

  Then, $x dot.op S_n = x + x^2 + x^3 + dots.h.c + x^n$

  $x dot.op S_n - S_n =\(x + x^2 + x^3 + dots.h.c + x^n\)-\(1 + x + x^2 + dots.h.c + x^(n - 1)\)= x^n - 1$

  $S_n dot.op\(x - 1\)= x^n - 1$

  $S_n = frac(x^n - 1, x - 1)$ $gt.tri$ with the constraint that
  $x eq.not 1$

  ]
  Leveraging the Geometric Sum formula
  $sum_(i = 0)^(n - 1) x^i = frac(x^n - 1, x - 1)$,

  $sum_(k = 0)^(n - 1) omega^(2 m k) = frac(\(omega^(2 m)\)^n- 1, omega^(2 m) - 1) = frac(\(omega^(2 n)\)^m- 1, omega^(2 m) - 1) = frac(1 - 1, omega^(2 m) - 1) = 0$
  for $1 lt.eq m lt.eq\(2 n - 1\)$ $gt.tri$ since
  $sans("Ord")\(omega\)= 2 n$

  Therefore,

  $sum_(k = 0)^(n - 1) omega^(2 k) = sum_(k = 0)^(n - 1) omega^(4 k) = sum_(k = 0)^(n - 1) omega^(6 k) = dots.h.c = sum_(k = 0)^(n - 1) omega^(2\(n - 1\)k) = sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k) = dots.h.c = sum_(k = 0)^(n - 1) omega^(2\(2 n - 1\)k) = 0$

  $$

+ Based on the proof of step 2 and 3,
  $V dot.op V^T = mat(delim: "[", 0, dots.h.c, 0, 0, n; 0, dots.h.c, 0, n, 0; 0, dots.h.c, n, 0, 0; dots.v, dots.up, dots.v, dots.v, dots.v; n, 0, 0, dots.h.c, 0; #none) = n dot.op I_n^R$

+ Given $V dot.op V^T = n dot.op I_n^R$,

  $V^(- 1) dot.op V dot.op V^T = V^(- 1) dot.op n dot.op I_n^R$

  $V^T = V^(- 1) dot.op n dot.op I_n^R$

  $V^T dot.op I_n^R = V^(- 1) dot.op n dot.op I_n^R dot.op I_n^R$

  $V^T dot.op I_n^R = V^(- 1) dot.op n$ \# since
  $I_n^R dot.op I_n^R = I_n$

  $V^(- 1) = frac(V^T dot.op I_n^R, n)$

~◻

]
Later in the CKKS scheme (#link(<sec:ckks>)[\[sec:ckks\]]), we will use
$V^(- 1)$ to encode a complex vector into a real number vector, and
$V^T$ to decode a real number vector into a complex vector
(#link(<subsec:ckks-enc-dec>)[\[subsec:ckks-enc-dec\]]).

$$

It's worthwhile to note that the property
$V dot.op V^T = n dot.op I_n^R$ does not hold if $mu$ (denoting the
$mu$-th cyclotomic polynomial) is not a power of 2. In particular, step
3 of the proof does not hold anymore if $mu$ is not a power of 2:

$sum_(k = 0)^(n - 1) omega^(2 k) eq.not sum_(k = 0)^(n - 1) omega^(4 k) eq.not sum_(k = 0)^(n - 1) omega^(6 k) eq.not dots.h.c eq.not sum_(k = 0)^(n - 1) omega^(2\(n - 1\)k) eq.not sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k) eq.not dots.h.c eq.not sum_(k = 0)^(n - 1) omega^(2\(2 n - 1\)k) eq.not 0$

== Vandermonde Matrix with Roots of Cyclotomic Polynomial over Rings ($bb(Z)_p$)
<subsec:vandermonde-euler-integer-ring>
Theorem~@subsec:vandermonde-euler (in
#link(<subsec:vandermonde-euler>)[0.4]) showed that
$V dot.op V^T = n dot.op I_n^R$, where $V$ is the Vandermonde matrix
$V = italic(V a n d e r)\(x_0\,x_1\,dots.h.c\,x_(n - 1)\)$, where each
$x_i$ is the primitive $mu$-th root of unity over $X in bb(C)$ (i.e.,
complex number) and $mu$ is a power of 2. In this subsection, we will
show that the relation $V dot.op V^T = n dot.op I_n^R$ holds even if
each $x_i$ is the primitive $mu$-th root of unity over $X in bb(Z)_p$
(i.e., ring). In particular, we will prove
Theorem~@subsec:vandermonde-euler:

#block[
The proof takes the same format as that of
Theorem~@subsec:vandermonde-euler (in
#link(<subsec:vandermonde-euler>)[0.4]). Suppose we have an $n times n$
(where $n$ is a power of 2) Vandermonde matrix comprised of $n$ distinct
roots of the $mu$-th cyclotomic polynomial over $X in bb(Z)_p$ (ring),
where $mu$ is a power of 2 and $n = mu / 2$. In other words,
$V = italic(V a n d e r)\(x_0\,x_1\,dots.h.c\,x_(n - 1)\)$, where each
$x_i$ is the root of $X^n + 1$ (i.e., the primitive $\(mu = 2 n\)$-th
roots of unity). Then, the following holds:

$V dot.op V^T = mat(delim: "[", 0, dots.h.c, 0, 0, n; 0, dots.h.c, 0, n, 0; 0, dots.h.c, n, 0, 0; dots.v, dots.up, dots.v, dots.v, dots.v; n, 0, 0, dots.h.c, 0; #none) = n dot.op I_n^R$

$$

And $V^(- 1) = n^(- 1) dot.op V^T dot.op I_n^R$

]
#block[
#emph[Proof.] $$

+ $V dot.op V^T$ is expanded as follows:

  $V dot.op V^T = mat(delim: "[", 1, \(omega\), \(omega\)^2, dots.h.c, \(omega\)^(n - 1); 1, \(omega^3\), \(omega^3\)^2, dots.h.c, \(omega^3\)^(n - 1); 1, \(omega^5\), \(omega^5\)^2, dots.h.c, \(omega^5\)^(n - 1); dots.v, dots.v, dots.v, dots.down, dots.v; 1, \(omega^(2 n - 1)\), \(omega^(2 n - 1)\)^2, dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none) dot.op mat(delim: "[", 1, 1, 1, dots.h.c, 1; \(omega\), \(omega^3\), \(omega^5\), dots.h.c, \(omega^(2 n - 1)\); \(omega\)^2, \(omega^3\)^2, \(omega^5\)^2, dots.h.c, \(omega^(2 n - 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), \(omega^5\)^(n - 1), dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$

  $$

  $= mat(delim: "[", sum_(k = 0)^(n - 1) omega^(2 k), sum_(k = 0)^(n - 1) omega^(4 k), sum_(k = 0)^(n - 1) omega^(6 k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2 n k); sum_(k = 0)^(n - 1) omega^(4 k), sum_(k = 0)^(n - 1) omega^(6 k), sum_(k = 0)^(n - 1) omega^(8 k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2 k\(n + 1\)); sum_(k = 0)^(n - 1) omega^(6 k), sum_(k = 0)^(n - 1) omega^(8 k), sum_(k = 0)^(n - 1) omega^(10 k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2 k\(n + 2\)); dots.v, dots.v, dots.v, dots.down, dots.v; sum_(k = 0)^(n - 1) omega^(2 n k), sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k), sum_(k = 0)^(n - 1) omega^(2\(n + 2\)k), dots.h.c, sum_(k = 0)^(n - 1) omega^(2\(n + n - 1\)k); #none)$

  $$

  , where $omega$ (i.e., the primitive $\(mu = 2 n\)$-th root of unity)
  has the order $2 n$.

  $$

+ Note that the $V dot.op V^T$ matrix's anti-diagonal elements are
  $sum_(k = 0)^(n - 1) omega^(2 n k)$. It can be seen that
  $omega^(2 n) equiv 1 med mod med p$, because
  $sans("Ord")_p\(omega\)= 2 n$. Thus, the $V dot.op V^T$ matrix's every
  anti-diagonal element is $sum_(k = 0)^(n - 1) 1 = n$.

  $$

+ Next, we will prove that the $V dot.op V^T$ matrix has $0$ for all
  other positions than the anti-diagonal ones. In other words, we will
  prove the following:

  $sum_(k = 0)^(n - 1) omega^(2 k) = sum_(k = 0)^(n - 1) omega^(4 k) = sum_(k = 0)^(n - 1) omega^(6 k) = dots.h.c = sum_(k = 0)^(n - 1) omega^(2\(n - 1\)k) = sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k) = dots.h.c = sum_(k = 0)^(n - 1) omega^(2\(2 n - 1\)k) = 0$

  $$

  The above is true by the Geometric Sum formula
  (Theorem~@subsec:vandermonde-euler\.1). As shown in the proof step 3
  of Theorem~@subsec:vandermonde-euler, each element is of the form
  $sum_(k = 0)^(n - 1)\(omega^(2 m)\)^k$ for some integer $m$ (where
  $2 m$ is not a multiple of $2 n$). Let $r = omega^(2 m)$. Then:

  $sum_(k = 0)^(n - 1) r^k = frac(r^n - 1, r - 1) = frac(\(omega^(2 m)\)^n- 1, omega^(2 m) - 1) = frac(\(omega^n\)^(2 m)- 1, omega^(2 m) - 1)$

  $$

  Since $omega$ is a root of $X^n + 1$, we know
  $omega^n equiv - 1 med mod med p$. Thus:

  $frac(\(- 1\)^(2 m)- 1, omega^(2 m) - 1) = frac(1 - 1, omega^(2 m) - 1) = 0$

  $$

  Therefore, the sum is 0 for all off-anti-diagonal positions.

  $$

+ According to step 1 and 2, the $V dot.op V^T$ matrix has $n$ on its
  anti-diagonal positions and $0$ for all other positions.

+ Now we will derive the formula for $V^(- 1)$. Given
  $V dot.op V^T = n dot.op I_n^R$,

  $V^(- 1) dot.op V dot.op V^T = V^(- 1) dot.op n dot.op I_n^R$

  $V^T = V^(- 1) dot.op n dot.op I_n^R$

  $V^T dot.op I_n^R = V^(- 1) dot.op n dot.op I_n^R dot.op I_n^R$

  $V^T dot.op I_n^R = V^(- 1) dot.op n$ \# since
  $I_n^R dot.op I_n^R = I_n$

  $$

  Now, there is one caveat: modulo operation does not support direct
  number division (as explained in
  #link(<subsec:modulo-division>)[\[subsec:modulo-division\]]). This
  means that the formula $V^(- 1) = frac(V^T dot.op I_n^R, n)$ in
  Theorem~@subsec:vandermonde-euler (in
  #link(<subsec:vandermonde-euler>)[0.4]) is inapplicable in our case,
  because our modulo $p$ arithmetic does not allow direct division of
  $V^T dot.op I_n^R$ by $n$. Therefore, we instead multiply
  $V^T dot.op I_n^R$ by the inverse of $n$ (i.e., $n^(- 1)$). We
  continue as follows:

  $V^T dot.op I_n^R = V^(- 1) dot.op n$

  $V^T dot.op I_n^R dot.op n^(- 1) = V^(- 1) dot.op n dot.op n^(- 1)$

  $V^(- 1) = n^(- 1) dot.op V^T dot.op I_n^R$

~◻

]
We finally proved that $V dot.op V^T = n dot.op I_n^R$, and
$V^(- 1) = n^(- 1) dot.op V^T dot.op I_n^R$. Later in the BFV scheme
(#link(<sec:bfv>)[\[sec:bfv\]]), we will use $V^(- 1)$ to encode an
integer vector into a vector of polynomial coefficients, and $V^T$ to
decode it back to the integer vector
(#link(<subsec:bfv-batch-encoding>)[\[subsec:bfv-batch-encoding\]]).

$$

Like in CKKS, it's worthwhile to note that the property
$V dot.op V^T = n dot.op I_n^R$ does not hold if $mu$ (denoting the
$mu$-th cyclotomic polynomial) is not a power of 2. In particular, step
3 of the proof does not hold anymore if $mu$ is not a power of 2:

$sum_(k = 0)^(n - 1) omega^(2 k) eq.not sum_(k = 0)^(n - 1) omega^(4 k) eq.not sum_(k = 0)^(n - 1) omega^(6 k) eq.not dots.h.c eq.not sum_(k = 0)^(n - 1) omega^(2\(n - 1\)k) eq.not sum_(k = 0)^(n - 1) omega^(2\(n + 1\)k) eq.not dots.h.c eq.not sum_(k = 0)^(n - 1) omega^(2\(2 n - 1\)k) eq.not 0$
