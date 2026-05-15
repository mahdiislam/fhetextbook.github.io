#set heading(numbering: "1.")
#strong[\- Reference 1:]
#link("https://en.wikipedia.org/wiki/Polynomial_ring")[Polynomial Ring (Wikipedia)]

#strong[\- Reference 2:]
#link("https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Applied_Discrete_Structures_(Doerr_and_Levasseur)/16%3A_An_Introduction_to_Rings_and_Fields/16.03%3A_Polynomial_Rings")[Polynomial Rings (LibreTexts)]

== Overview
<subsec:poly-ring-overview>
#strong[A polynomial ring] is a set of polynomials where polynomial
computations over the $\(+\,dot.op\)$ operators (e.g., $f_1 + f_2$,
$f_1 dot.op\(f_2 - f_3\)$, $f_1 + f_2 + f_4$) are closed, associative,
commutative, and distributive.

A polynomial ring $bb(Z)_p\[x\]\/\(x^n + 1\)$ is the set of all
polynomials $f_i$ that have the following properties:

#block[
For a polynomial $f in bb(Z)_p\[x\]\/\(x^n + 1\)$ where
$f = c_0 + c_1 x^1 + dots.h.c + c_(n - 1) x^(n - 1)$:

- #strong[Coefficient Ring:] each coefficient $c_j in bb(Z)_p$.

  $$

- #strong[Degree Bound:] Any $f' in bb(Z)_p\[x\]$ can be written as:

  $$

  $f' =\(x^n + 1\)f_q + f_r\,#h(2em) deg f_r < n\,$

  $$

  so in the quotient ring $bb(Z)_p\[x\]\/\(x^n + 1\)$ we have
  $f' equiv f_r med\(mod med x^n + 1\)$. $f_q$ is called a quotient
  polynomial and $f_r$ is called a remainder polynomial resulting from
  the polynomial division of $f'$ divided by $x^n + 1$.

  $$

- #strong[Polynomial Congruence:] If two polynomials are congruent, they
  belong to the same equivalence class, in which case they are
  interchangeable in the polynomial operations ($+\,dot.op$) in the
  polynomial ring. For example, if:

  $$

  $f' equiv f_(r 1) in bb(Z)_p\[x\]\/\(x^n + 1\)$

  $f'' equiv f_(r 2) in bb(Z)_p\[x\]\/\(x^n + 1\)$

  $f_(r 1) + f_(r 2) equiv f_(r 3) in bb(Z)_p\[x\]\/\(x^n + 1\)$

  $$

  Then the polynomial operation result of $f' + f''$ is in the same
  equivalence class as:

  $f' + f'' equiv f_(r 1) + f_(r 2) equiv f_(r 3) in bb(Z)_p\[x\]\/\(x^n + 1\)$

To make the notation simple, we denote the polynomial ring
$bb(Z)_p\[x\]\/\(x^n + 1\)$ as $cal(R)_(chevron.l n\,p chevron.r)$

]
Recall that in $bb(Z)_p$, any $b$ writes $b = m p + r$ with
$0 lt.eq r < p$, hence $b equiv r med\(mod med p\)$ (the quotient $m$
disappears). Similarly, in a polynomial ring
$cal(R)_(chevron.l n\,p chevron.r)$, a high-degree polynomial
$f_(b i g)$ can be divided by the polynomial modulo $x^n + 1$, which
yields:

$f_(b i g) =\(x^n + 1\)dot.op\(f_q\)+ f_r equiv f_r in cal(R)_(chevron.l n\,p chevron.r)$

, whereas $f_q$ is a quotient polynomial, and $f_r$ is a remainder
polynomial. In this case, $f_(b i g)$ is congruent to (i.e., it is in
the same equivalence class as) $f_r$. Thus, $f_q$ can be eliminated, and
$f_r$ (i.e., the simplified version of $f_(b i g)$) can be used
interchangeably for polynomial operations $\(+\,dot.op\)$ in the
polynomial ring. Polynomial simplification (i.e., reduction) in a
polynomial ring is done by substituting $x^n equiv - 1$ into $f_(b i g)$
because $x^n + 1 equiv 0$ in the polynomial ring (this is the same as
the case of a number ring modulo $p$, where we reduce a number by
substituting $0$ for $p$). This way, a high-degree polynomial
$f_(b i g)$ can be recursively simplified to a polynomial of degree less
than $n$ by recursively substituting $x^n equiv - 1$ into $f_(b i g)$.

For a polynomial modulo, we normally choose a cyclotomic polynomial
$x^n + 1$ (where $n$ is $2^p$ for some integer $p$) as the divisor, as
it provides computational efficiency.

=== Example
<subsubsec:poly-ring-ex>
Given $f in bb(Z)_7\[x\]\/\(x^2 + 1\)$, suppose
$f = x^4 + 3 x^3 + 11 x^2 + 6 x + 10$. Then,

$$

$f =\(x^2\)dot.op\(x^2\)+ 3 x dot.op\(x^2\)+ 11 x^2 + 6 x + 10$

$equiv\(- 1\)\(- 1\)+ 3 x\(- 1\)+\(11 med mod med 7\)\(- 1\)+ 6 x +\(10 med mod med 7\)$

$= 3 x in bb(Z)_7\[x\]\/\(x^2 + 1\)$

$$

Thus, $f\(x\)= x^4 + 3 x^3 + 11 x^2 + 6 x + 10$ is equivalent to
($equiv$) $3 x$ in the polynomial ring $bb(Z)_7\[x\]\/\(x^2 + 1\)$.

=== Discussion
<subsubsec:polynomial-ring-discuss>
#block[
#figure(
  align(center)[#table(
    columns: 3,
    align: (center,center,center,),
    table.header([], [#strong[Ring]], [#strong[Polynomial Ring]],),
    table.hline(),
    [#strong[Set Elements]], [number], [polynomial],
    [#strong[Ring
    Notation]], [$bb(Z)_p = { 0\,1\,dots.h\,p - 1 }$], [$bb(Z)_p\[x\]\/\(x^n + 1\)$],
    [#strong[& Definition]], [The set of all integers between $0$ and
    $p$], [The set of all polynomials $f$ such that],
    [], [], [$f = c_0 + c_1 x^1 + c_2 x^2 dots.h.c + c_(n - 1) x^(n - 1)$],
    [], [], [where each coefficient $c_i in bb(Z)_p$],
    [], [], [and $f$'s degree is less than $n$],
    [#strong[Supported]], [$\(+\,dot.op\)$], [$\(+\,dot.op\)$],
    [#strong[Operations]], [\(Addition, Multiplication)], [\(Addition,
    Multiplication)],
    [#strong[\($+$) Operation]], [We know how to add
    numbers], [$f_a = a_0 + a_1 x^1 + a_2 x^2 dots.h.c + a_(d_a - 1) x^(d_a - 1)$],
    [], [], [$f_b = b_0 + b_1 x^1 + b_2 x^2 dots.h.c + b_(d_b - 1) x^(d_b - 1)$],
    [], [], [Then, $f_a + f_b$ is computed as:],
    [], [], [$f_c = sum_(i = 0)^(sans("max")\(d_a\,d_b\))\(a_i + b_i\)x^i$],
    [#strong[\($dot.op$) Operation]], [We know how to multiply
    numbers], [$f_a = a_0 + a_1 x^1 + a_2 x^2 dots.h.c + a_(d_a - 1) x^(d_a - 1)$],
    [], [], [$f_b = b_0 + b_1 x^1 + b_2 x^2 dots.h.c + b_(d_b - 1) x^(d_b - 1)$],
    [], [], [Then, $f_a dot.op f_b$ is computed as:],
    [], [], [$f_c = sum_(i = 0)^(d_a + d_b) sum_(j = 0)^i a_j b_(i - j) x^i$],
    [], [For $a\,b in bb(Z)_p$], [For
    $f_a\,f_b in bb(Z)_p\[x\]\/\(x^n + 1\)$,],
    [#strong[Commutative]], [$a + b = b + a$], [$f_a + f_b = f_b + f_a$],
    [#strong[Associative]], [$\(a + b\)+ c = a +\(b + c\)$], [$\(f_a + f_b\)+ f_c = f_a +\(f_b + f_c\)$],
    [#strong[Distributive]], [$a dot.op\(b + c\)= a dot.op b + a dot.op c$], [$f_a dot.op\(f_b + f_c\)= f_a dot.op f_b + f_a dot.op f_c$],
    [#strong[Closed]], [$a + b equiv c in bb(Z)_p$,
    $a dot.op b equiv d in bb(Z)_p$], [$f_a + f_b equiv f_c in cal(R)_(chevron.l n\,p chevron.r)$,],
    [], [], [$f_a dot.op f_b equiv f_d in cal(R)_(chevron.l n\,p chevron.r)$],
    [#strong[Congruency ($equiv$)]], [Two numbers $a equiv b$ in modulo
    $p$ if:], [Two polynomials $f_a equiv f_b$ in
    $bb(Z)_p\[x\]\/\(x^n + 1\)$ if:],
    [], [$\(a med mod med p\)=\(b med mod med p\)$], [$f'_a = f_a med mod med\( x^n + 1\)= sum_(i = 0)^(d_a) a_i x^i$],
    [], [], [$f'_b = f_b med mod med\( x^n + 1\)= sum_(i = 0)^(d_b) b_i x^i$,],
    [], [], [$d_a = d_b$ and $a_i equiv b_i$ in modulo $p$],
    [], [], [for all $0 lt.eq i lt.eq d_a$],
  )]
  , caption: [Comparison between a number ring and a polynomial ring. ]
  , kind: table
  )

] <tab:ring-comparison>
If two numbers are congruent, they belong to the same #emph[congruence
class]. The same is true for two congruent polynomials. If the
computation results of two mathematical formulas belong to the same
congruency class, then their computations wrap around within the modulus
of their congruency. This is a useful property for cryptographic schemes
where encryption & decryption computations wrap around their values
within a limited set of binary bits. Congruency is useful for
simplifying computations. For example, a large number or a complex
polynomial can be #emph[normalized] to a simpler number or polynomial by
using the congruency rule, which reduces the computational overhead.

Note that two numbers that belong to the same congruence class are not
necessarily the same number. For example, $5 equiv 10$ modulo 5, but
these two numbers are not the same. Likewise, two congruent polynomials
are not the same. While two congruent polynomials in a polynomial ring
can be interchangeably used for polynomial operations supported in the
ring (i.e., $\(+\,dot.op\)$), such as $f_1 + f_2$ or
$f_1 dot.op\(f_2 - f_3\)$, two congruent polynomials do not necessarily
yield the same result when evaluated for a certain variable value
$x = a$. For example, in the previous example of
#link(<subsubsec:poly-ring-ex>)[0.1.1], the two polynomials
$x^4 + 3 x^3 + 11 x^2 + 6 x + 10$ and $3 x$ are congruent in the
polynomial ring $bb(Z)_7\[x\]\/\(x^2 + 1\)$. However, these two
polynomials do not give the same evaluation results for $x = 0$: the
original polynomial gives 10, whereas the reduced (i.e., simplified)
polynomial gives 0. This discrepancy in evaluation occurs because we
defined two polynomials $M_1$ and $M_2$ to be congruent over $x^n + 1$
(i.e., $M_1 equiv M_2$) if their remainder is the same after being
divided by $x^n + 1$ (i.e., $M_1 = Q dot.op\(x^n + 1\)+ M_2$ for some
polynomial $Q$). Therefore, $M_1$ and $M_2$ will be evaluated to the
same polynomial $M_2$ if they are evaluated at the $x$ values such that
$x^n = - 1$, which makes the $x^n + 1$ term 0. The solutions for
$x^n = - 1$ are called the $n$-th roots of unity, which we will learn in
#link("<sec:roots>")[\[sec:roots\]] and
#link("<sec:cyclotomic-polynomial-integer-ring>")[\[sec:cyclotomic-polynomial-integer-ring\]].
We summarize as follows:

#block[
Suppose polynomials $M_1$ and $M_2$ are congruent over the polynomial
ring $x^n + 1$. This is equivalent to the following relation:
$M_1 = Q dot.op\(x^n + 1\)+ M_2$ for some polynomial $Q$. Then,
$M_1\(X\)$ and $M_2\(X\)$ are guaranteed to be evaluated to the same
value if $X = x_i$ is the solution for $x^n + 1$ (i.e., $X$ is the
$n$-th root of unity). That is , $M_1\(x_i\)= M_2\(x_i\)$.

]
These two rings share many common characteristics, which are summarized
in #link(<tab:ring-comparison>)[1].

== Coefficient Rotation
<subsec:coeff-rotation>
Coefficient rotation is a process of shifting the entire coefficients of
a polynomial (either to the left or right) in a polynomial ring. In
order to rotate the entire coefficients of a polynomial by $h$ positions
to the left, we multiply $x^(- h)$ with the polynomial.

For example, suppose we have a polynomial as follows:

$$

$f\(x\)= c_0 + c_1 x^1 + c_2 x^2 + dots.h.c + c_h x^h + dots.h.c + c_(n - 1) x^(n - 1) in cal(R)_(chevron.l n\,p chevron.r)$

$$

To shift the entire coefficients of $f$ to the left by $h$ positions
(i.e., shift $f$'s $h$-th coefficient to the constant term), we compute
$f dot.op x^(- h)$, which is:

$$

#block[
Given the $\(n - 1\)$-degree polynomial:

$$

$f\(x\)= c_0 + c_1 x^1 + c_2 x^2 + dots.h.c + c_h x^h + dots.h.c + c_(n - 1) x^(n - 1) in cal(R)_(chevron.l n\,p chevron.r)$

$$

The coefficients of $f\(x\)$ can be rotated to the left by $h$ positions
by multiplying to $f\(x\)$ by $x^(- h)$ as follows:

$$

$f\(x\)dot.op x^(- h) = c_0 dot.op x^(- h) + c_1 x^1 dot.op x^(- h) + c_2 x^2 dot.op x^(- h) + dots.h.c + c_h x^h dot.op x^(- h) + dots.h.c + c_(n - 1) x^(n - 1) dot.op x^(- h)$
$equiv c_h + c_(h + 1) x + c_(h + 2) x^2 + dots.h.c + c_(n - 1) x^(n - 1 - h) - c_0 x^(n - h) - dots.h.c - c_(h - 1) x^(n - 1) in cal(R)_(chevron.l n\,p chevron.r)$

]
$$

Note that multiplying the two polynomials $f$ and $x^(- h)$ will yield a
congruent polynomial in $cal(R)_(chevron.l n\,p chevron.r)$. Therefore,
the rotated polynomial, which is the result of $f dot.op x^(- h)$, will
also have a congruent polynomial in $cal(R)_(chevron.l n\,p chevron.r)$.

Note that the coefficient signs change when they rotate around the
boundary of $x^n\(= - 1\)$, as the computation is conducted in the
polynomial ring $bb(Z)_p\[x\]\/\(x^n + 1\)$.

=== Example
<subsec:coeff-rotation-ex>
Suppose we have a polynomial $f in bb(Z)_8\[x\]\/\(x^4 + 1\)$ as
follows:

We use the centered residue system for $bb(Z)_8$, i.e.,
${ - 4\,- 3\,- 2\,- 1\,0\,1\,2\,3 }$.

$f = 2 + 3 x - 4 x^2 - x^3$

$$

The polynomial ring $bb(Z)_8\[x\]\/\(x^4 + 1\)$ has the following 4
congruence relationships:

$x^4 dot.op x^(- 1) equiv - 1 dot.op x^(- 1)$

$$

$x^4 equiv - 1$

$x^4 dot.op x^(- 3) equiv - 1 dot.op x^(- 3)$

$$

$x^4 equiv - 1$

$x^4 dot.op x^(- 2) equiv - 1 dot.op x^(- 2)$

$$

Then, based on the coefficient rotation technique in
Summary @subsec:coeff-rotation, rotating 1 position to the left is
equivalent to computing $f dot.op x^(- 1)$ as follows:

$f dot.op x^(- 1) = 2 dot.op\(x^(- 1)\)+ 3 x dot.op\(x^(- 1)\)- 4 x^2 dot.op\(x^(- 1)\)- x^3 dot.op\(x^(- 1)\)$

$equiv - 2 x^3 + 3 - 4 x^1 - x^2$

$= 3 - 4 x^1 - x^2 - 2 x^3$

$$

As another example, rotating 3 positions to the left is equivalent to
computing $f dot.op x^(- 3)$ as follows:

$f dot.op x^(- 3) = 2 dot.op\(x^(- 3)\)+ 3 x dot.op\(x^(- 3)\)- 4 x^2 dot.op\(x^(- 3)\)- x^3 dot.op\(x^(- 3)\)$

$equiv - 2 x - 3 x^2 + 4 x^3 - 1$

$= - 1 - 2 x - 3 x^2 + 4 x^3$

$= - 1 - 2 x - 3 x^2 +\(4 equiv - 4 med mod med 8\)x^3$

$equiv - 1 - 2 x - 3 x^2 - 4 x^3$
