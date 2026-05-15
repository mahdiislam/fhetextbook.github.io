#strong[\- Reference:]
#link("http://web.cecs.pdx.edu/~maier/cs584/Lectures/lect07b-11-MG.pdf")[Polynomials and the Fast Fourier Transform (FFT)]~@ntt

== Background and Motivation
<subsec:ntt-motivation>
Given two $\(n - 1\)$-degree polynomials:

$A\(X\)= sum_(i = 0)^(n - 1) a_i X^i$, \...
$B\(X\)= sum_(i = 0)^(n - 1) b_i X^i$

, the polynomial multiplication $C\(X\)= A\(X\)dot.op B\(X\)$ is
computed as follows:

$C\(X\)= sum_(i = 0)^(2 n - 2) c_i X^i$, where
$c_i = sum_(k = 0)^i a_k b_(i - k)$

This operation of computing
$arrow(c) =\(c_0\,c_1\,dots.h.c\,c_(2 n - 1)\)$ is also called the
convolution of $arrow(a)$ and $arrow(b)$, denoted as
$arrow(c) = arrow(a) times.circle arrow(b)$. The time complexity of this
operation (i.e., the total number of multiplications between two
numbers) is $O\(n^2\)$.

Another way of multiplying two polynomials is based on
#strong[point-value representation]. The point-value representation of
an $\(n - 1\)$-degree (or lesser degree) polynomial $A\(X\)$ is a set of
$n$ coordinates
${\(x_0\,y_0\)\,\(x_1\,y_1\)\,dots.h.c\(x_(n - 1)\,y_(n - 1)\)}$, where
each $x_i$ is a distinct $X$ coordinate (whereas each $y_i$ is not
necessarily a distinct $Y$ coordinate). Given a point-value
representation of an $\(n - 1\)$-degree (or lesser degree) polynomial,
we can use polynomial interpolation
(#link(<sec:polynomial-interpolation>)[\[sec:polynomial-interpolation\]])
to derive the polynomial. Let's denote the point-value representation of
$\(n - 1\)$-degree (or lesser degree) polynomial $A\(X\)$ and $B\(X\)$
as follows:

$A\(X\)$ :
$bold(\()\(x_0\,y_0^(chevron.l a chevron.r)\)\,\(x_1\,y_1^(chevron.l a chevron.r)\)\,dots.h.c\(x_(n - 1)\,y_(n - 1)^(chevron.l a chevron.r)\)bold(\))$

$B\(X\)$ :
$bold(\()\(x_0\,y_0^(chevron.l b chevron.r)\)\,\(x_1\,y_1^(chevron.l b chevron.r)\)\,dots.h.c\(x_(n - 1)\,y_(n - 1)^(chevron.l b chevron.r)\)bold(\))$

Then, the point-value representation of the polynomial
$C\(X\)= A\(X\)dot.op B\(X\)$ can be computed as a Hadamard product
(Definition~@subsec:vector-arithmetic in
#link(<subsec:vector-arithmetic>)[\[subsec:vector-arithmetic\]]) of the
$y$ values of the point-value representation of $A\(X\)$ and $B\(X\)$ as
follows:

$C\(X\)$ :
$bold(\()\(x_0\,y_0^(chevron.l c chevron.r)\)\,\(x_1\,y_1^(chevron.l c chevron.r)\)\,dots.h.c\(x_(n - 1)\,y_(n - 1)^(chevron.l c chevron.r)\)bold(\))$,
where
$y_i^(chevron.l c chevron.r) = y_i^(chevron.l a chevron.r) dot.op y_i^(chevron.l b chevron.r)$

However, we cannot derive polynomial $C\(X\)$ based on these $n$
coordinates because the degree of $C\(X\)$ is $2 n - 2$ (or less than
$2 n - 2$). But if we regard all polynomials (including $A\(X\)\,B\(X\)$
and $C\(X\)$) to be in the polynomial ring $bb(R)\[X\]\/\(X^n + 1\)$ (or
$bb(Z)_p\[X\]\/\(X^n + 1\)$), then we can reduce the
$\(2 n - 2\)$-degree polynomial $C\(X\)$ to a congruent
$\(n - 1\)$-degree (or lesser degree) polynomial in the ring. Then, the
$n$ coordinates of $C\(X\)$ are sufficient to derive $C\(X\)$.

However, the time complexity of this new method is still $O\(n^2\)$. The
Hadamard product between two polynomials' point-value representations
takes $O\(n\)$, but evaluating a polynomial at $n$ distinct $x$ values
takes $O\(n^2\)$ (because each polynomial has $n$ terms, and we have to
compute each term for $n$ distinct $x$ values). The polynomial
interpolation for deriving $C\(X\)$ also takes $O\(n^2\)$.

To solve this efficiency problem, this section will explain an efficient
technique for polynomial evaluation, which can evaluate a polynomial at
$n$ distinct roots of unity in $O\(n log n\)$. This technique is
classified into 2 types: Fast Fourier Transform (FFT) and
Number-theoretic Transform (NTT). These two types are technically almost
the same, with the only difference that the FFT assumes a polynomial
ring over complex numbers (#link(<sec:roots>)[\[sec:roots\]]), whereas
the NTT assumes a polynomial ring over a finite field (e.g., integers
modulo a prime)
(#link(<sec:cyclotomic-polynomial-integer-ring>)[\[sec:cyclotomic-polynomial-integer-ring\]]).
Polynomial multiplication based on FFT (or NTT) comprises 3 steps: (1)
forward FFT (or NTT); (2) point-value multiplication; and (3) inverse
FFT (or NTT).

== Forward FFT (or NTT)
<subsec:ntt-forward>
We assume a polynomial ring of $bb(R)\[X\]\/\(X^n + 1\)$ for FFT, and
$bb(Z)_p\[X\]\/\(X^n + 1\)$ for NTT (where $X^n + 1$ is a cyclotomic
polynomial). The $x$ coordinates to evaluate the target polynomial are
the $n$ distinct roots of $X^n + 1$, which are $omega^1$,
$omega^3\,dots.h\,omega^(2 n - 1)$, where $omega$ is the primitive
$2 n$-th root of unity. Then, the point-value representation of the
polynomial $A\(X\)$ is
$bold(\()\(x_0\,y_0^(chevron.l a chevron.r)\)\,\(x_1\,y_1^(chevron.l a chevron.r)\)\,dots.h.c\(x_(n - 1)\,y_(n - 1)^(chevron.l a chevron.r)\)bold(\))$,
where:

$y_i^(chevron.l a chevron.r) = A\(omega^(2 i + 1)\)= sum_(j = 0)^(n - 1) a_j dot.op\(omega^(2 i + 1)\)^j= sum_(j = 0)^(n - 1) a_j dot.op omega^(\(2 i + 1\)dot.op j)$

$$

We call the vector
$arrow(y)^(chevron.l a chevron.r) =\(y_0^(chevron.l a chevron.r)\,y_1^(chevron.l a chevron.r)\,dots.h.c\,y_(n - 1)^(chevron.l a chevron.r)\)$
the Discrete Fourier Transform (DFT) of the coefficient vector
$arrow(a) =\(a_0\,a_1\,dots.h.c\,a_(n - 1)\)$. We write this as
$arrow(y)^(chevron.l a chevron.r) = sans("DFT")\(arrow(a)\)$. As
explained in #link(<subsec:ntt-motivation>)[0.1], the computation of the
DFT takes $O\(n^2\)$, because we have to evaluate $n$ distinct $X$
values for a polynomial that has $n$ terms.

=== High-level Idea
<subsec:ntt-forward-overview>
FFT (or NTT) is an improved method for computing the DFT, which reduces
the time complexity from $O\(n^2\)$ to $O\(n log n\)$. The high-level
idea of FFT is to split the $\(n - 1\)$-degree (or lesser degree) target
polynomial $A\(X\)$ to evaluate into 2 half-degree polynomials
$A_0\(X\)$ and $A_1\(X\)$ as follows:

$A\(X\)= a_0 + a_1 X + a_2 X^2 + dots.h.c + a_(n - 1) X^(n - 1)$

\$\\textcolor{white}{A(X) }= A\_0(X^2) + X \\cdot A\_1(X^2)\$
$A_0\(X\)= a_0 + a_2 X + a_4 X^2 + dots.h.c + a_(n - 2) X^(n / 2 - 1)$

$A_1\(X\)= a_1 + a_3 X + a_5 X^2 + dots.h.c + a_(n - 1) X^(n / 2 - 1)$

The above method of splitting a polynomial into two half-degree
polynomials is called the Cooley-Tukey step. As we split $A\(X\)$ into
two smaller-degree polynomials $A_0\(X\)$ and $A_1\(X\)$, evaluating
$A\(X\)$ at the odd-powered primitive $2 n$-th roots of unity
${ omega^1\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 1) }$ is equivalent
to evaluating $A_0\(X\)$ and $A_1\(X\)$ at $n$ distinct #emph[squared]
$n$-th roots of unity
${\(omega^2\)^1\,\(omega^2\)^3\,\(omega^2\)^5\,dots.h\,\(omega^2\)^(2 n - 1)}$
and computing $A_0\(X^2\)+ X dot.op A_1\(X^2\)$. However, remember that
the primitive $2 n$-th root of unity $omega$ has order $2 n$ (i.e.,
$omega^(2 n) = 1$ and $omega^m eq.not 1$ for all $m < 2 n$). Therefore,
the second half of
${\(omega^2\)^1\,\(omega^2\)^3\,\(omega^2\)^5\,dots.h\,\(omega^2\)^(2 n - 1)}$
is a repetition of the first half. This implies that we only need to
evaluate $A_0\(X\)$ and $A_1\(X\)$ at $n / 2$ distinct $x$ coordinates
each, instead of $n$ distinct coordinates, because the polynomial
evaluation results for the other half are the same as those of the first
half (as their input $x$ to the polynomial is the same).

We recursively split $A_0\(X\)$ and $A_1\(X\)$ into half-degree
polynomials and evaluate them at half-counted (i.e., $n\/2$) $n$-th
roots of unity. Then, the total number of rounds of splitting is
$log n$, and the maximum number of root-to-coefficient multiplications
in each round is $n$, which aggregates to $O\(n log n\)$.

=== Details
<subsec:ntt-forward-details>
Suppose we have a polynomial ring that is either
$bb(Z)_p\[X\]\/\(X^8 + 1\)$ (i.e., over a finite field with prime $p$)
or $bb(R)\[X\]\/\(X^8 + 1\)$ (over complex numbers). We denote by
$omega$ a primitive $\(2 n = 16\)$-th root of unity, and the 8 distinct
roots of $X^8 + 1$ are:
${ omega^1\,omega^3\,omega^5\,omega^7\,omega^9\,omega^11\,omega^13\,omega^15 }$.

$$

Now, we define our target polynomial to evaluate as follows:

$A\(X\)= a_0 + a_1 X + a_2 X^2 + a_3 X^3 + a_4 X^4 + a_5 X^5 + a_6 X^6 + a_7 X^7$

$$

We split this 7-degree polynomial into the following two 3-degree
polynomials (using the Cooley-Tukey step):

$A_0\(X\)= a_0 + a_2 X + a_4 X^2 + a_6 X^3$

$A_1\(X\)= a_1 + a_3 X + a_5 X^2 + a_7 X^3$

$A\(X\)= A_0\(X^2\)+ X dot.op A_1\(X^2\)$

$$

We recursively split the two 3-degree polynomials above into 1-degree
polynomials as follows:

$A_(0\,0)\(X\)= a_0 + a_4 X$, \... $A_(0\,1)\(X\)= a_2 + a_6 X$

$A_0\(X\)= A_(0\,0)\(X^2\)+ X dot.op A_(0\,1)\(X^2\)$

$$

$A_(1\,0)\(X\)= a_1 + a_5 X$, \... $A_(1\,1)\(X\)= a_3 + a_7 X$

$A_1\(X\)= A_(1\,0)\(X^2\)+ X dot.op A_(1\,1)\(X^2\)$

$$

$A\(X\)= A_0\(X^2\)+ X dot.op A_1\(X^2\)$

\$\\mathcolor{white}{A(X)} = \\underbrace{\\underbrace{(\\underbrace{A\_{0,0}(X^4)}\_{\\text{FFT Level 1}} + X^2\\cdot \\underbrace{A\_{0,1}(X^4)}\_{\\text{FFT Level 1}})}\_{\\text{FFT Level 2}} + X \\cdot \\underbrace{(\\underbrace{A\_{1,0}(X^4)}\_{\\text{FFT Level 1}} + X^2\\cdot \\underbrace{A\_{1,1}(X^4)}\_{\\text{FFT Level 1}})}\_{\\text{FFT Level 2}}}\_{\\text{FFT Level 3}}\$

$$

To evaluate $A\(X\)$ at the $n$ distinct roots
$X = { omega^1\,omega^3\,dots.h\,omega^15 }$, we evaluate each FFT level
of the above formula at $X = { omega^1\,omega^3\,dots.h.c\,omega^15 }$,
starting from level $1 lt.eq l lt.eq 3$.

$$

We evaluate $A_(0\,0)\(X^4\)$, $A_(0\,1)\(X^4\)$, $A_(1\,0)\(X^4\)$, and
$A_(1\,1)\(X^4\)$ at $X = { omega^1\,omega^3\,dots.h.c\,omega^15 }$.
However, notice that plugging in
$X = { omega^1\,omega^3\,dots.h.c\,omega^15 }$ to $X^4$ results in only
2 distinct values: $omega^4$ and $omega^12$ (which correspond to roots
of $X^2 + 1$). This is because the order of $omega$ is $2 n$ (i.e.,
$omega^(2 n) = 1$), and thus
$\(omega^1\)^4=\(omega^5\)^4=\(omega^9\)^4=\(omega^13\)^4= omega^4$, and
$\(omega^3\)^4=\(omega^7\)^4=\(omega^11\)^4=\(omega^15\)^4= omega^12$.
Therefore, we only need to evaluate $A_(0\,0)\(X^4\)$,
$A_(0\,1)\(X^4\)$, $A_(1\,0)\(X^4\)$, and $A_(1\,1)\(X^4\)$ at 2
distinct $x$ values instead of 8, where each evaluation requires a
constant number of arithmetic operations: computing 1 multiplication and
1 addition. As there are a total of 4 polynomials to evaluate (i.e.,
$A_(0\,0)\(X^4\)\,A_(0\,1)\(X^4\)\,A_(1\,0)\(X^4\)\,A_(1\,1)\(X^4\)$),
we compute the FFT a total of $4 dot.op 2 = 8$ times.

$$

Based on the evaluation results from FFT Level 1 as building blocks, we
evaluate $A_0\(X^2\)$ and $A_1\(X^2\)$ at
$X = { omega^1\,omega^3\,dots.h.c\,omega^15 }$. However, notice that
plugging in $X = { omega^1\,omega^3\,dots.h.c\,omega^15 }$ to $X^2$
results in only 4 distinct values: $omega^2$, $omega^6$, $omega^10$, and
$omega^14$ (which correspond to roots of $X^4 + 1$). This is because the
order of $omega$ is $2 n$ (i.e., $omega^(2 n) = 1$), and thus
$\(omega^1\)^2=\(omega^9\)^2$, $\(omega^3\)^2=\(omega^11\)^2$,
$\(omega^5\)^2=\(omega^13\)^2$, and $\(omega^7\)^2=\(omega^15\)^2$.
Therefore, we only need to evaluate $A_0\(X^2\)$ and $A_1\(X^2\)$ at 4
distinct $x$ values instead of 8, where each evaluation requires a
constant number of arithmetic operations: computing 1 multiplication and
1 addition (where we use the results from FFT Level 1 as building
blocks, and the computational structure of FFT Level 2 is the same as
that of FFT Level 1). There are a total of 2 polynomials to evaluate
(i.e., $A_0\(X^2\)\,A_1\(X^2\)$); thus, we compute the FFT a total of
$2 dot.op 4 = 8$ times.

$$

Based on the evaluation results from FFT Level 2 as building blocks, we
evaluate $A\(X\)$ at $X = { omega^1\,omega^3\,dots.h.c\,omega^15 }$. For
this last level of computation, we need to evaluate all 8 distinct $X$
values, since they are all unique values, and each evaluation requires a
constant number of arithmetic operations: computing 1 multiplication and
1 addition. There is a total of 1 polynomial to evaluate (i.e.,
$A\(X\)$); thus, we compute the FFT a total of $1 dot.op 8 = 8$ times.

$$

Suppose that the degree of the target polynomial to evaluate is at most
$n - 1$ (with $n$ terms), and we define $L = log n$ (i.e., the total
number of FFT levels). Then, the forward FFT operation requires a total
of $L$ FFT levels, where each $l$-th level requires the evaluation of
$2^(L - l)$ polynomials at $2^l$ distinct $X$ values. Therefore, the
total number of FFT computations for the forward FFT is:
$sum_(l = 1)^L\(2^(L - l) dot.op 2^l\)= L dot.op 2^L = n log n$ .
Therefore, the time complexity of the forward FFT is $O\(n log n\)$.

Using the FFT technique, we reduce the number of $x$ points to evaluate
to half as the level decreases (while the number of polynomials to
evaluate doubles), and their growth and reduction cancel each other,
resulting in $O\(n\)$ for each level. Since there are $log n$ such
levels, the total time complexity is $O\(n log n\)$. The core enabler of
this optimization is the special property of the $x$ evaluation
coordinates: its power (i.e., $omega^i$) is cyclic. To enforce this
cyclic property, FFT requires the evaluation points of $x$ to be the
odd-powered primitive $2 n$-th roots of unity.

== Point-wise Multiplication
<subsec:pointwise-multiplication>
Once we have applied the forward FFT operation
(#link(<subsec:ntt-forward>)[0.2]) to polynomial $A\(X\)$ and $B\(X\)$
as $arrow(y)^(chevron.l a chevron.r)$ and
$arrow(y)^(chevron.l b chevron.r)$, computing the point-value
representation of $C\(X\)= A\(X\)dot.op B\(X\)$ can be done in $O\(n\)$
using the Hadamard product
$arrow(y)^(chevron.l c chevron.r) = arrow(y)^(chevron.l a chevron.r) dot.circle arrow(y)^(chevron.l b chevron.r)$
(as explained in #link(<subsec:ntt-motivation>)[0.1]).

== Inverse FFT (or NTT)
<subsec:ntt-backward>
So far, we have computed:

$C\(X\)$ :
$bold(\()\(x_0\,y_0^(chevron.l c chevron.r)\)\,\(x_1\,y_1^(chevron.l c chevron.r)\)\,dots.h.c\(x_(n - 1)\,y_(n - 1)^(chevron.l c chevron.r)\)bold(\))$,
where
$y_i^(chevron.l c chevron.r) = y_i^(chevron.l a chevron.r) dot.op y_i^(chevron.l b chevron.r)$

$$

Our final step is to convert $y_i^(chevron.l c chevron.r)$ back to
$arrow(c)$, the polynomial coefficients of $C\(X\)$. We call this
reversing operation the inverse FFT.

Given an $\(n - 1\)$-degree polynomial
$C\(X\)= sum_(i = 0)^(n - 1) c_i X^i$, the forward FFT process is
computationally equivalent to evaluating the polynomial at $n$ distinct
$n$-th roots of $X^n + 1$ as follows:

$y_i^(chevron.l c chevron.r) = C\(omega^(2 i + 1)\)= sum_(j = 0)^(n - 1) c_j dot.op\(omega^(2 i + 1)\)^j= sum_(j = 0)^(n - 1) c_j dot.op omega^(\(2 i + 1\)j)$

The above evaluation is equivalent to computing the following
matrix-vector multiplication:

$$

$y_i^(chevron.l c chevron.r) = W dot.op arrow(c)$, where
$W = mat(delim: "[", \(omega^1\)^0, \(omega^1\)^1, dots.h.c, \(omega^1\)^(n - 1); \(omega^3\)^0, \(omega^3\)^1, dots.h.c, \(omega^3\)^(n - 1); dots.v, dots.v, dots.down, dots.v; \(omega^(2 n - 1)\)^0, \(omega^(2 n - 1)\)^1, dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$,
$arrow(c) =\(c_0\,c_1\,dots.h.c\,c_(n - 1)\)$

$$

We denote each element of $W$ as: $\(W\)_(i\,j)= omega^(\(2 i + 1\)j)$.
The inverse FFT is a process of reversing the above computation. For
this inversion, our goal is to find an inverse matrix $W^(- 1)$ such
that
$W^(- 1) dot.op y_i^(chevron.l c chevron.r) = W^(- 1) dot.op\(W dot.op arrow(c)\)=\(W^(- 1) dot.op W\)dot.op arrow(c) = I_n dot.op arrow(c) = arrow(c)$.
As a solution, we propose the inverse matrix $W^(- 1)$ as follows:

$\(W^(- 1)\)_(j\,k)= n^(- 1) dot.op omega^(-\(2 k + 1\)j)$

$$

Now, we will show why $W^(- 1) dot.op W = I_n$. Each element of
$W^(- 1) dot.op W$ is computed as:

$\(W^(- 1) dot.op W\)_(j\,i)= sum_(k = 0)^(n - 1)\(n^(- 1) dot.op omega^(-\(2 k + 1\)j) dot.op omega^(\(2 k + 1\)i)\)= n^(- 1) dot.op sum_(k = 0)^(n - 1) omega^(\(2 k + 1\)\(i - j\))$

In order for $W^(- 1) dot.op W$ to be $I_n$, the following should hold:

$ \(W^(- 1) dot.op W\)_(j\,i)= {upright("1 if ") j = i\
upright("0 if ") j eq.not i\
 $

If $j = i$ holds, the above condition is satisfied because:

$\(W^(- 1) dot.op W\)_(j\,i)= n^(- 1) dot.op sum_(k = 0)^(n - 1) omega^(\(2 k + 1\)\(0\)) = n^(- 1) dot.op sum_(k = 0)^(n - 1) 1 = n^(- 1) dot.op n = 1$

$$

In the case of $j eq.not i$, we will leverage the Geometric Sum formula
$sum_(i = 0)^(n - 1) x^i = frac(x^n - 1, x - 1)$ (the proof is provided
below):

#block[
Let the geometric sum $S_n = 1 + x + x^2 + dots.h.c + x^(n - 1)$

Then, $x dot.op S_n = x + x^2 + x^3 + dots.h.c + x^n$

$x dot.op S_n - S_n =\(x + x^2 + x^3 + dots.h.c + x^n\)-\(1 + x + x^2 + dots.h.c + x^(n - 1)\)= x^n - 1$

$S_n dot.op\(x - 1\)= x^n - 1$

$S_n = frac(x^n - 1, x - 1)$ $gt.tri$ with the constraint that
$x eq.not 1$

]
Our goal is to compute
$sum_(k = 0)^(n - 1) omega^(\(2 k + 1\)\(i - j\)) = omega^(i - j) sum_(k = 0)^(n - 1)\(omega^(2\(i - j\))\)^k$.
Leveraging the Geometric Sum formula with $x = omega^(2\(i - j\))$:

$omega^(i - j) sum_(k = 0)^(n - 1)\(omega^(2\(i - j\))\)^k= omega^(i - j) frac(\(omega^(2\(i - j\))\)^n- 1, omega^(2\(i - j\)) - 1)$

$= omega^(i - j) frac(\(omega^(2 n)\)^(i - j)- 1, omega^(2\(i - j\)) - 1)$

$= omega^(i - j) frac(\(1\)^(i - j)- 1, omega^(2\(i - j\)) - 1)$
$gt.tri$ since the order of $omega$ is $2 n$, $omega^(2 n) = 1$

$gt.tri$ Here, the denominator can't be 0. Since $i eq.not j$ and
$\|i - j\|< n$, the exponent $2\(i - j\)$ is not a multiple of $2 n$.

$= 0$

$$

Thus, $\(W^(- 1) dot.op W\)_(j\,i)$ is 1 if $j = i$, and 0 if
$j eq.not i$. Therefore, the inverse FFT can be computed as
$arrow(c) = W^(- 1) dot.op y^(chevron.l c chevron.r)$, where:

$c_i = sum_(j = 0)^(n - 1)\(W^(- 1)\)_(i\,j)dot.op y_j^(chevron.l c chevron.r)$

$sum_(j = 0)^(n - 1) (n^(- 1) dot.op omega^(-\(2 j + 1\)i)) dot.op y_j^(chevron.l c chevron.r)$
$gt.tri$ since
$\(W^(- 1)\)_(j\,k)= n^(- 1) dot.op omega^(-\(2 k + 1\)j)$, and
$\(W^(- 1)\)_(i\,j)= n^(- 1) dot.op omega^(-\(2 j + 1\)i)$

$= n^(- 1) dot.op sum_(j = 0)^(n - 1) y_j^(chevron.l c chevron.r) dot.op omega^(-\(2 j + 1\)i)$

$= n^(- 1) sum_(j = 0)^(n - 1) y_j^(chevron.l c chevron.r) dot.op\(omega^(- 2 j i) dot.op omega^(- i)\)$
$gt.tri$ since
$omega^(-\(2 j + 1\)i) = omega^(- 2 j i - i) = omega^(- 2 j i) dot.op omega^(- i)$

$= n^(- 1) omega^(- i) sum_(j = 0)^(n - 1) y_j^(chevron.l c chevron.r)\(omega^(- 2)\)^(j i)$

$$

By reusing the recursive splitting technique explained in the forward
process (#link(<subsec:ntt-forward-details>)[0.2.2]), this inverse
operation also achieves a time complexity of $O\(n log n\)$.
