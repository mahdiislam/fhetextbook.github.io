#strong[\- Reference 1:]
#link("https://brilliant.org/wiki/chinese-remainder-theorem/")[Brilliant -- Chinese Remainder Theorem]~@crt

#strong[\- Reference 2:]
#link("https://www.youtube.com/watch?v=fz1vxq5ts5I")[YouTube -- Extended Euclidean Algorithm Tutorial]

#block[
Suppose we have positive coprime integers
$n_0\,n_1\,n_2\,dots.h.c\,n_k$. Let $N = n_0 n_1 dots.h.c n_k$. We
sample $k + 1$ random integers $a_0\,a_1\,a_2\,dots.h.c\,a_k$ from each
modulus $n_0\,n_1\,n_2\,dots.h\,n_k$ (i.e., $a_0 in bb(Z)_(n_0)$,
$a_1 in bb(Z)_(n_1)$, $dots.h.c$, $a_k in bb(Z)_(n_k)$). Then, there
exists one and only one solution $x med mod med N$ such that
$x equiv a_i med\(mod med n_i\)$ for each $0 lt.eq i lt.eq k$. That is:

$x equiv a_0 med mod med n_0$

$x equiv a_1 med mod med n_1$

$x equiv a_2 med mod med n_2$

$dots.v$

$x equiv a_k med mod med n_k$

$$

To compute $x$, we first compute each $y_i$ and $z_i$ (for
$0 lt.eq i lt.eq k$) as follows:

$y_i = N / n_i\,upright(" ") z_i = y_i^(- 1) med mod med n_i$

$$

Note that each $y_i$'s inverse (i.e., $y_i^(- 1)$) can be computed by
using the Extended Euclidean algorithm (watch the
#link("https://www.youtube.com/watch?v=fz1vxq5ts5I")[YouTube tutorial]).
Then, the unique solution $x$ can be computed as follows:

$x = sum_(i = 0)^k a_i y_i z_i$ $gt.tri$ Alternatively, we can compute
$x = sum_(i = 0)^k\|a_i z_i\|_(n_i)y_i$ (where
$\|a_i z_i\|_(n_i)= a_i z_i med mod med n_i$)

$$

Since such $x$ is unique in $med mod med upright(" ") N$, there are
isomorphic mappings between $x med mod med N$ and
$\(a_0\,a_1\,a_2\,dots.h.c\,a_k\)$.

$$

Also, $y_i z_i equiv\(y_i z_i\)^2med mod med N$ for all
$0 lt.eq i lt.eq k$

]
#block[
#emph[Proof.] $$

+ Given $x = sum_(i = 0)^k a_i y_i z_i$, let's compute
  $x med mod med n_i$ for each $i$ where $0 lt.eq i lt.eq k$:

  $x med mod med n_i = sum_(j = 0)^k a_j y_j z_j med mod med n_i$

  $= a_0 y_0 z_0 + a_1 y_1 z_1 + a_2 y_2 z_2 + dots.h.c + a_k y_k z_k med mod med n_i$

  $= a_i y_i z_i med mod med n_i$ $gt.tri$ because
  $y_j equiv 0 med mod med n_i$ for all $j eq.not i$, as they are a
  multiple of $n_i$

  $= a_i$ $gt.tri$ because
  $y_i z_i equiv y_i y_i^(- 1) equiv 1 med mod med n_i$

  $$

  Thus, the value of $x$ in each modulo $n_0\,n_1\,n_2\,dots.h.c\,n_k$
  is congruent with $a_0\,a_1\,a_2\,dots.h.c\,a_k$.

  $$

  Alternatively, note that the following is also true:

  $x med mod med n_i = sum_(j = 0)^k\|a_j z_j\|_(n_j)y_i upright(" ")\(med mod med n_i\)$

  $=\|a_0 z_0\|_(n_0)y_0 +\|a_1 z_1\|_(n_1)y_1 +\|a_2 z_2\|_(n_2)y_2 + dots.h.c +\|a_k z_k\|_(n_k)y_k med mod med n_i$

  $=\|a_i z_i\|_(n_i)y_i med mod med n_i$

  $= a_i$

  $$

+ Now, we prove that $x$ is a unique solution modulo $N$. Suppose there
  were two solutions: $x$ and $x'$ such that:

  $x equiv x' equiv a_0 med mod med n_0$

  $x equiv x' equiv a_1 med mod med n_1$

  $x equiv x' equiv a_2 med mod med n_2$

  $dots.v$

  $x equiv x' equiv a_k med mod med n_k$

  $$

  Then, by definition of modulo congruence,
  $n_0 divides\(x - x'\)\,n_1 divides\(x - x'\)\,upright(" ") n_2 divides\(x - x'\)\,dots.h.c\,upright(" ") n_k divides\(x - x'\)$.

  Also, since $n_0\,n_1\,n_2\,dots.h.c\,n_k$ are coprime, it must be the
  case that $n_0 n_1 n_2 n_3 dots.h.c n_k divides\(x - x'\)$, or
  $N divides\(x - x'\)$. This means that $x equiv x' med mod med N$.
  Therefore, $x$ is a unique solution in modulo $N$.

  $$

+ Now, we will prove that $y_i z_i equiv\(y_i z_i\)^2med mod med N$ for
  all $0 lt.eq i lt.eq k$.

  $$

  In the case of modulo $n_i$, $y_i z_i equiv 1 med mod med n_i$, since
  $z_i$ is an inverse of $y_i$ modulo $n_i$. In the case of all other
  modulo $n_j$ where $i eq.not j$, $y_i z_i equiv 0 med mod med n_j$,
  because $y_i = N / n_i$ and thus $n_j$ divides $y_i$.

  $$

  By squaring both sides of $\(y_i z_i\)equiv 1 med mod med n_i$, we get
  $\(y_i z_i\)^2equiv 1 med mod med n_i$. Similarly, by squaring both
  sides of $\(y_i z_i\)equiv 0 med mod med n_j$, we get
  $\(y_i z_i\)^2equiv 0 med mod med n_j$.

  $$

  Therefore, $y_i z_i -\(y_i z_i\)^2equiv 0 med mod med n_i$, and
  $y_i z_i -\(y_i z_i\)^2equiv 0 med mod med n_j$. In other words,
  $y_i z_i -\(y_i z_i\)^2equiv 0 med mod med n_j$ for all
  $0 lt.eq j lt.eq k$.

  $$

  Then, we do the similar reasoning as step 2: since every co-prime
  $n_j$ divides $y_i z_i -\(y_i z_i\)^2$, $n_0 n_1 dots.h.c n_k = N$
  divides $y_i z_i -\(y_i z_i\)^2$. Thus,
  $y_i z_i -\(y_i z_i\)^2equiv 0 med mod med N$, which is
  $y_i z_i equiv\(y_i z_i\)^2med mod med N$. This is true for all
  $0 lt.eq i lt.eq k$.

~◻

]
== Application: Residue Number System (RNS)
<subsec:crt-application>
In a modern processor, each data size is a maximum of 64 bits. If the
data size exceeds 64 bits, its computations can be handled efficiently
by using the Chinese remainder theorem, ensuring that each co-prime
modulus $n_i$ satisfies $log_2 n_i lt.eq 64$ (where
$N = n_0 dot.op n_1 dots.h.c dot.op n_k$), so that we can represent a
large value $a med mod med N$ as
$arrow(a)_(italic(c r t)) =\(a_0\,a_1\,dots.h.c\,a_k\)$, where
$a equiv a_i med mod med n_i$. Then, for any pair of big numbers $a$ and
$b med mod med N$, we can compute $a + b med mod med N$ and
$a dot.op b med mod med N$ as follows:

- $a + b equiv sum_(i = 0)^k a_i y_i z_i + sum_(i = 0)^k b_i y_i z_i equiv sum_(i = 0)^k\(a_i y_i z_i + b_i y_i z_i\)equiv sum_(i = 0)^k\(a_i + b_i\)y_i z_i med mod med N$

  $$

- $a dot.op b equiv sum_(i = 0)^k a_i y_i z_i dot.op sum_(i = 0)^k b_i y_i z_i equiv sum_(i = 0)^k\(a_i dot.op b_i\)\(y_i z_i\)^2+ sum_(i eq.not j)^k\(a_i dot.op b_j\)y_i z_i y_j z_j equiv sum_(i = 0)^k\(a_i dot.op b_i\)\(y_i z_i\)^2$

  $gt.tri$ Note that all terms $y_i z_i y_j z_j$ where $i eq.not j$ are
  0 modulo $N$, because $y_i y_j med mod med N equiv 0$. \ This is
  because $y_i = n_0 n_1 dots.h.c n_(i - 1) n_(i + 1) dots.h.c$ and
  $y_j = n_0 n_1 dots.h.c n_(j - 1) n_(j + 1) dots.h.c$. \ Thus
  $y_i y_j$ is a multiple of $N$.

  $$

  $equiv sum_(i = 0)^k\(a_i dot.op b_i\)\(y_i z_i\)med mod med N$

  $gt.tri$ This is because $\(y_i z_i\)equiv\(y_i z_i\)^2$ as shown in
  step 3 in the proof of Theorem~@sec:chinese-remainder\.1

$$

Thus, the Chinese remainder theorem gives us the following useful
formula:

#block[
Suppose there are two big numbers
$a = sum_(i = 0)^k a_i y_i z_i med mod med N$ and
$b = sum_(i = 0)^k b_i y_i z_i med mod med N$ where $N$ is a the product
of co-prime moduli $n_0 dot.op n_1 dots.h.c n_k$, we have an isomorphism
as follows:

$a arrow.r^sigma arrow(a)_(italic(c r t)) =\(a_0\,a_1\,dots.h.c\,a_k\)$

$b arrow.r^sigma arrow(b)_(italic(c r t)) =\(b_0\,b_1\,dots.h.c\,b_k\)$

$$

Based on the above isomorphism, the following is true:

- $a + b equiv sum_(i = 0)^k\(a_i + b_i\)y_i z_i med mod med N arrow.l.r.double arrow(a)_(italic(c r t)) + arrow(b)_(italic(c r t)) equiv\(a_0 + b_0\,upright(" ") a_1 + b_1\,dots.h.c\,upright(" ") a_k + b_k\)med mod med N$

- $a dot.op b equiv sum_(i = 0)^k\(a_i dot.op b_i\)y_i z_i med mod med N arrow.l.r.double arrow(a)_(italic(c r t)) dot.circle arrow(b)_(italic(c r t)) equiv\(a_0 b_0\,a_1 b_1\,dots.h.c\,a_k b_k\)med mod med N$

, where each element-wise addition/multiplication can be independently
done modulo $n_i$

]
