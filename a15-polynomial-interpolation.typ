Suppose we are given $n + 1$ two-dimensional coordinates
$\(x_0\,y_0\)\,\(x_1\,y_1\)\,dots.h.c\,\(x_n\,y_n\)$, where all $x$
values are distinct, but $y$ values are not necessarily distinct.
Lagrange's polynomial interpolation is a technique to find a unique
polynomial of degree at most $n$ that passes through such $n + 1$
coordinates. The given points $\(x_i\,y_i\)$ may lie either in $bb(C)^2$
(the complex plane, which includes the real numbers) or in $bb(Z)_p^2$
for some prime $p$.

#block[
Suppose we are given $n + 1$ two-dimensional coordinates
$\(x_0\,y_0\)\,\(x_1\,y_1\)\,dots.h.c\,\(x_n\,y_n\)$, whereas all $X$
values are distinct but the $Y$ values don't need to be distinct. The
domain of $\(X\,Y\)$ can be either: $\(x_i\,y_i\)in bb(C)^2$ (which
includes the real domain) or $\(x_i\,y_i\)in bb(Z)_p^2$ (where $p$ is a
prime). Then, there exists a unique polynomial $f\(X\)$ of degree at
most $n$ that passes through these $n + 1$ coordinates. Such a
polynomial $f\(X\)$ is computed as follows:

$f\(X\)= sum_(j = 0)^n frac(\(X - x_0\)dot.op\(X - x_1\)dots.h.c\(X - x_(j - 1)\)dot.op\(X - x_(j + 1)\)dots.h.c\(X - x_n\), \(x_j - x_0\)dot.op\(x_j - x_1\)dots.h.c\(x_j - x_(j - 1)\)dot.op\(x_j - x_(j + 1)\)dots.h.c\(x_j - x_n\)) dot.op y_j$

\$\\textcolor{white}{f(X) }= \\sum\\limits\_{j=0}^{n} \\left( \\prod\\limits\_{\\substack{0 \\le k \\le n\\\\ k \\ne j}} \\dfrac{X - x\_k}{x\_j - x\_k} \\cdot y\_j\\right)\$

]
#block[
+ First, we will show that there exists an $n$-degree (or lesser degree)
  polynomial $f\(X\)$ that passes through the $n + 1$ distinct
  coordinates: $\(x_0\,y_0\)\,\(x_1\,y_1\)\,dots.h\,\(x_n\,y_n\)$. Such
  a polynomial $f\(X\)$ is designed as follows:

  $f\(X\)= sum_(j = 0)^n frac(\(X - x_0\)dot.op\(X - x_1\)dots.h.c\(X - x_(j - 1)\)dot.op\(X - x_(j + 1)\)dots.h.c\(X - x_n\), \(x_j - x_0\)dot.op\(x_j - x_1\)dots.h.c\(x_j - x_(j - 1)\)dot.op\(x_j - x_(j + 1)\)dots.h.c\(x_j - x_n\)) dot.op y_j$

  \$\\textcolor{white}{f(X) }= \\sum\\limits\_{j=0}^{n} \\left( \\prod\\limits\_{\\substack{0 \\le k \\le n\\\\ k \\ne j}} \\dfrac{X - x\_k}{x\_j - x\_k} \\cdot y\_j\\right)\$

  \$\\textcolor{white}{f(X) }= \\sum\\limits\_{j=0}^{n} \\ell\_j(X) \\cdot y\_j\$
  $gt.tri$ where $ell_j\(X\)= product_(0 lt.eq k lt.eq n\
  k eq.not j) frac(X - x_k, x_j - x_k)$

  $$

  We call ${ ell_0\(X\)\,ell_1\(X\)\,dots.h\,ell_n\(X\)}$ the Lagrange
  basis for polynomials of degree $lt.eq n$. Given this design of
  $f\(X\)$, notice that for each of
  $\(x_i\,y_i\)in {\(x_0\,y_0\)\,\(x_1\,y_1\)\,dots.h\,\(x_n\,y_n\)}$,
  $ell_i\(x_(i')\)= 1$ for $i' = i$, and $ell_i\(x_(i')\)= 0$ for
  $i' eq.not i$. Therefore,
  $f\(x_i\)= sum_(j = 0)^n ell_j\(x_i\)dot.op y_j = 1 dot.op y_i = y_i$
  for $0 lt.eq i lt.eq n$. In other words, $f\(X\)$ passes through the
  $n + 1$ distinct coordinates:
  ${\(x_0\,y_0\)\,\(x_1\,y_1\)\,dots.h\,\(x_n\,y_n\)}$. Such a
  satisfactory $f\(X\)$ can be computed in the case where the domain of
  $\(X\,Y$) is either: $\(x_i\,y_i\)in bb(C)^2$ (i.e., real and complex
  numbers), or $\(x_i\,y_i\)in bb(Z)_p^2$ (where $p$ is a prime).
  Especially, a valid $f\(X\)$ can be computed also in the
  $med mod med thin p$ domain, because as we learned from Fermat's
  Little Theorem in Theorem~@subsec:order-theorem\.4
  (#link(<subsec:order-theorem>)[\[subsec:order-theorem\]]),
  $a^(p - 1) equiv 1 med mod med p$ if and only if $a$ and $p$ are
  co-prime, and this means that if $p$ is a prime, then
  $a^(p - 1) equiv 1 med mod med p$ for all $a in bb(Z)_p^times$ (i.e.,
  $bb(Z)_p$ without ${ 0 }$). Since every value in $bb(Z)_p^times$ has
  an inverse, we can perform each division in the formula for
  $f\(X\)= sum_(j = 0)^n frac(\(X - x_0\)dot.op\(X - x_1\)dots.h.c\(X - x_(j - 1)\)dot.op\(X - x_(j + 1)\)dots.h.c\(X - x_n\), \(x_j - x_0\)dot.op\(x_j - x_1\)dots.h.c\(x_j - x_(j - 1)\)dot.op\(x_j - x_(j + 1)\)dots.h.c\(x_j - x_n\)) dot.op y_j$
  by multiplying with the corresponding inverses of those denominators.

+ Next, we will prove that no two distinct $n$-degree (or lesser degree)
  polynomials $f_1\(X\)$ and $f_2\(X\)$ can pass through the same
  $n + 1$ distinct $\(X\,Y\)$ coordinates. Suppose there exist such two
  polynomials $f_1\(X\)$ and $f_2\(X\)$. Then
  $f_(1 - 2)\(X\)= f_1\(X\)- f_2\(X\)$ will be a new $n$-degree (or
  lesser degree) polynomial that passes through
  $\(x_0\,0\)\,\(x_1\,0\)\,dots.h.c\,\(x_n\,0\)$. This means that
  $f_(1 - 2)\(X\)$ has $n + 1$ distinct roots. In other words,
  $f_(1 - 2)\(X\)$ is an $n + 1$-degree (or higher-degree) polynomial.
  However, this contradicts the assumption that $f_(1 - 2)\(X\)$ is an
  $n$-degree (or lesser degree) polynomial. Therefore, there exist no
  two polynomials $f_1\(X\)$ and $f_2\(X\)$ that pass through the same
  $n + 1$ distinct $\(X\,Y\)$ coordinates.

+ We have shown that there exists some $n$-degree (or lesser degree)
  polynomial $f\(X\)$ that passes through $n + 1$ distinct $\(X\,Y\)$
  coordinates, and no such two or more distinct polynomials exists.
  Therefore, there exists only a unique polynomial that satisfies this
  requirement.

]
