#set heading(numbering: "1.")
Decomposition is a mathematical technique used to represent a number in
a smaller base (radix) while preserving its value. This section will
explain number decomposition and polynomial decomposition.

== Number Decomposition
<subsec:number-decomp>
We fix a modulus $q gt.eq 2$ and write $bb(Z)_q = bb(Z)\/q bb(Z)$. Let
$gamma in bb(Z)_q$. Number decomposition expresses $gamma$ as a sum of
multiple numbers in base $beta$ as follows:

$$

$gamma = gamma_1 q / beta^1 + gamma_2 q / beta^2 + dots.h.c + gamma_ell q / beta^ell$

$$

where $beta gt.eq 2$ is a base and $ell gt.eq 1$ is the decomposition
level. We assume $beta^ell divides q$ and take digits
$gamma_i in { 0\,1\,dots.h\,beta - 1 }$\; under these conditions, the
decomposition is unique. This is visually shown in
#link(<fig:decomp>)[1]. (If $beta^ell divides.not q$, see
#link(<subsec:approx-decomp>)[0.3]\.) Each $gamma_i$ is a digit in the
base-$beta$ representation of $gamma$, where $i = 1$ is the most
significant digit. When $q$ is a power of two, this corresponds to a
shift by $i dot.op log_2 beta$ bits.

#figure(image("figures/decomp.pdf", width: 80.0%),
  caption: [
    An illustration of number decomposition.
  ]
)
<fig:decomp>

We define the decomposition of the number $gamma$ into base $beta$ with
level $ell$ as follows:

$$

$sans("Decomp")^(beta\,ell)\(gamma\)=\(gamma_1\,gamma_2\,upright(" ") dots.h.c\,upright(" ") gamma_ell\)$.

$$

Number decomposition is also called radix decomposition, where the base
$beta$ is referred to as a radix.

=== Example
<example>
Suppose we take $gamma = 13$ in $bb(Z)_16$. Suppose we want to decompose
13 with the base $beta = 2$ and level $ell = 4$. Then, 13 is decomposed
as follows:

$$

$13 = 1 dot.op 16 / 2^1 + 1 dot.op 16 / 2^2 + 0 dot.op 16 / 2^3 + 1 dot.op 16 / 2^4$

$$

$sans("Decomp")^(2\,4)\(13\)=\(1\,1\,0\,1\)$

== Polynomial Decomposition
<subsec:poly-decomp>
This time, suppose we have a polynomial $f$ in the polynomial ring
$bb(Z)_q\[x\]\/\(x^n + 1\)$. Therefore, each coefficient $c_i$ of $f$ is
an integer modulo $q$. Polynomial decomposition expresses $f$ as a sum
of multiple polynomials in base $beta$ and level $ell$ as follows:

#block[
Given $f in bb(Z)_q\[x\]\/\(x^n + 1\)$, fix $beta gt.eq 2$ and
$ell gt.eq 1$ with $beta^ell divides q$. We write

$$

$f = sum_(i = 1)^ell f_i thin q / beta^i\,#h(2em) f_i in bb(Z)_q\[x\]\/\(x^n + 1\)$

$$

where each $f_i$ is obtained by decomposing every coefficient of $f$ in
base $beta$. If $f = sum_j c_j x^j$ with $c_j in bb(Z)_q$, then
$c_j = sum_(i = 1)^ell c_(j\,i) thin q / beta^i$ with
$c_(j\,i) in { 0\,dots.h\,beta - 1 }$, and $f_i = sum_j c_(j\,i) x^j$.
We denote the decomposition of the polynomial $f$ into the base $beta$
with the level $ell$ as follows:

$$

$sans("Decomp")^(beta\,ell)\(f\)=\(f_1\,f_2\,upright(" ") dots.h.c\,upright(" ") f_ell\)$
$$

]
=== Example
<example-1>
Suppose we have the following polynomial in the polynomial ring
$bb(Z)_16\[x\]\/\(x^4 + 1\)$:

$$

$f = 6 x^3 + 3 x^2 + 14 x + 7 in bb(Z)_16\[x\]\/\(x^4 + 1\)$

$$

Suppose we want to decompose the above polynomial with base $beta = 4$
and level $ell = 2$. Then, each degree's coefficient of the polynomial
$f$ is decomposed as follows:

$$

$bold(x)^(bold(3))$: $6 = 1 dot.op 16 / 4^1 + 2 dot.op 16 / 4^2$

$bold(x)^(bold(2))$: $3 = 0 dot.op 16 / 4^1 + 3 dot.op 16 / 4^2$

$bold(x)^(bold(1))$: $14 = 3 dot.op 16 / 4^1 + 2 dot.op 16 / 4^2$

$bold(x)^(bold(0))$: $7 = 1 dot.op 16 / 4^1 + 3 dot.op 16 / 4^2$

$$

The decomposed polynomial is as follows:

\$f = 6x^3 + 3x^2 + 14x + 7 = \\color{blue}{(1x^3 + 0x^2 + 3x + 1) \\cdot \\dfrac{16}{4^1}} \\color{black}+ \\color{red}{(2x^3 + 3x^2 + 2x + 3) \\cdot \\dfrac{16}{4^2}} \\color{black}\$

$$

$sans("Decomp")^(4\,2)\(6 x^3 + 3 x^2 + 14 x + 7\)=\(1 x^3 + 0 x^2 + 3 x + 1\,2 x^3 + 3 x^2 + 2 x + 3\)$

=== Discussion
<discussion>
Note that after decomposition, the original coefficients of the
polynomial have been reduced to smaller numbers. This characteristic is
importantly used in the multiplication of polynomials in FHE ciphertexts
to reduce the growth rate of the noise. Normally, the polynomial
coefficients of ciphertexts are large because they are uniformly random
numbers. Reducing such large constants is important for reducing the
noise growth during homomorphic multiplication. We will discuss this in
more detail in
#link("<subsec:tfhe-mult-cipher>")[\[subsec:tfhe-mult-cipher\]].

== Approximate Decomposition
<subsec:approx-decomp>
#figure(image("figures/decomp3.pdf", width: 70.0%),
  caption: [
    An illustration of approximate decomposition
  ]
)
<fig:decomp3>

If no level $ell$ satisfies $beta^ell divides q$, then some lower-order
digits of $q$ (in base $beta$) must be discarded during decomposition,
as shown in #link(<fig:decomp3>)[2]. Such lower bits can be rounded to
the nearest multiple of $q / beta^ell$ during decomposition. In such a
case, the decomposition is an approximate decomposition. Formally, when
$beta^ell divides.not q$ we can write
$ gamma = sum_(i = 1)^ell gamma_i thin q / beta^i + epsilon\,#h(2em) gamma_i in { 0\,dots.h\,beta - 1 }\,quad\|epsilon\|lt.eq frac(q, 2 beta^ell) $
(using nearest-integer rounding and identifying $gamma$ with its integer
representative)The polynomial case is analogous, coefficient-wise.

== Gadget Decomposition
<subsec:gadget-decomposition>
Gadget decomposition is a generalized form of number decomposition
(#link(<subsec:number-decomp>)[0.1]). In number decomposition, a number
$gamma$ is decomposed as follows:

$gamma = gamma_1 q / beta^1 + gamma_2 q / beta^2 + dots.h.c + gamma_ell q / beta^ell$

$$

In gadget decomposition, we decompose $gamma$ as follows:

$gamma = gamma_1 g_1 + gamma_2 g_2 + dots.h.c + gamma_ell g_ell$

$$

We denote $arrow(g) =\(g_1\,g_2\,dots.h.c\,g_ell\)$ as a gadget vector,
and
$sans("Decomp")^(arrow(g))\(gamma\)=\(gamma_1\,gamma_2\,upright(" ") dots.h.c\,upright(" ") gamma_ell\)$

$$

Then,
$gamma = chevron.l sans("Decomp")^(arrow(g))\(gamma\)\,arrow(g) chevron.r$

$$

In the case of number decomposition
(#link(<subsec:number-decomp>)[0.1]), its gadget vector is
$arrow(g) = #scale(x: 300%, y: 300%)[\(] q / beta\,q / beta^2\,dots.h.c\,q / beta^ell #scale(x: 300%, y: 300%)[\)]$.
