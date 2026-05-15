#set heading(numbering: "1.")
#strong[\- Reference]

#link("https://www.youtube.com/watch?v=fz1vxq5ts5I")[YouTube -- Extended Euclidean Algorithm Tutorial].

== Overview
<subsec:modulo-overview>
#block[
- #strong[Modulo] is the operation of computing the remainder obtained
  when one number is divided by another. #strong[modulo] is often
  abbreviated as #strong[mod].

  $$

- #strong[$bold(a)$ mod $bold(q)$ (i.e.,
  $bold(a) bold(upright(" modulo ") q)$)] is the remainder after
  dividing $a$ by $q$, which is always an element of
  ${ 0\,1\,2\,3\,dots.h.c\,q - 1 }$. For example, $7 med mod med 5 = 2$,
  because the remainder of dividing 7 by 5 is 2.

  $$

- #strong[Modulus:] Given $bold(a)$ mod $bold(q)$, we call the divisor
  $q$ the modulus, whereas #emph[modulo] refers to the operation.

  $$

- #strong[Modulo Congruence ($bold(equiv)$):] $a$ is congruent to $b$
  modulo $q$ (i.e., $a equiv b bold(" mod ") q$) if they have the same
  remainder when divided by $q$. For example,
  $5 equiv 12 med mod med 7$, because $5 med mod med 7 = 5$ and
  $12 med mod med 7 = 5$. In mathematics, the notation
  $a equiv b med mod med q$ is identical to $a = b med\(mod med q\)$,
  meaning that the remainder of $a$ divided by $q$ is the same as the
  remainder of $b$ divided by $q$. Note that this notation differs from
  $a = b med mod med q$, which states that $a$ equals the remainder of
  $b$ divided by $q$.

  $$

- #strong[Congruence #emph[vs.] Equality:]

  $a equiv b med mod med q arrow.l.r.double a = b + k dot.op q$ (for
  some integer $k$)

  $$

  This means that $a$ and $b$ are congruent modulo $q$ if and only if
  $a$ and $b$ differ by some multiple of $q$. For example,
  $5 equiv 12 med mod med 7 arrow.l.r.double 5 = 12 +\(- 1\)dot.op 7$

]
== Modulo Arithmetic
<subsec:modulo-arithmetic>
The supported modulo operations are addition, subtraction, and
multiplication. The properties of these modulo operations are as
follows:

#block[
For any integer $x$, the following is true:

+ #strong[Addition:]
  $a equiv b med mod med q arrow.l.r.double a + x equiv b + x med mod med q$

+ #strong[Subtraction:]
  $a equiv b med mod med q arrow.l.r.double a - x equiv b - x med mod med q$

+ #strong[Multiplication:]
  $a equiv b med mod med q arrow.l.r.double a dot.op x equiv b dot.op x med mod med q$.
  This equivalence holds provided that $gcd\(x\,q\)= 1$. Without this
  assumption, only the implication
  $a equiv b med mod med q arrow.r.double a dot.op x equiv b dot.op x med mod med q$
  is guaranteed.

]
#block[
#emph[Proof.] $$

For any integer $x$,

+ #strong[Addition:]
  $a equiv b med mod med q arrow.l.r.double a = b + k q$ (for some
  integer $k$) \# $a$ and $b$ differ by some multiple of $q$

  $arrow.l.r.double a + x = b + k dot.op q + x$

  $arrow.l.r.double a + x = b + x + k dot.op q$ $gt.tri$ $a + x$ and
  $b + x$ differ by some multiple of $q$

  $arrow.l.r.double a + x equiv b + x med mod med q$

  $$

+ #strong[Subtraction:]
  $a equiv b med mod med q arrow.l.r.double a = b + k q$ (for some
  integer $k$)

  $arrow.l.r.double a - x = b + k dot.op q - x$

  $arrow.l.r.double a - x = b - x + k dot.op q$ $gt.tri$ $a - x$ and
  $b - x$ differ by some multiple of $q$

  $arrow.l.r.double a - x equiv b - x med mod med q$

  $$

+ #strong[Multiplication:]
  $a equiv b med mod med q arrow.l.r.double a = b + k q$ (for some
  integer $k$)

  $arrow.r.double a dot.op x = b dot.op x + k dot.op q dot.op x$

  $arrow.r.double a dot.op x = b dot.op x + k_x dot.op q$ (where
  $k_x = k dot.op x$) $gt.tri$ $a dot.op x$ and $b dot.op x$ differ by
  some multiple of $q$

  $arrow.r.double a dot.op x equiv b dot.op x med mod med q$

  Conversely, if $x$ and $q$ are coprime (i.e., $gcd\(x\,q\)= 1$), then
  $x$ has a multiplicative inverse $x^(- 1)$ modulo $q$. From
  $a dot.op x equiv b dot.op x med mod med q$

  $arrow.r.double a dot.op x dot.op x^(- 1) equiv b dot.op x dot.op x^(- 1) med mod med q$

  $arrow.r.double a equiv b med mod med q$

~◻

]
Based on the modulo operations in Theorem~@subsec:modulo-arithmetic\.1,
we can also derive the following properties of modulo arithmetic:

#block[
+ #strong[Associative:]
  $\(a dot.op b\)dot.op c equiv a dot.op\(b dot.op c\)med mod med q$

+ #strong[Commutative:] $\(a dot.op b\)equiv\(b dot.op a\)med mod med q$

+ #strong[Distributive:]
  $\(a dot.op\(b + c\)\)equiv\(\(a dot.op b\)+\(a dot.op c\)\)med mod med q$

+ #strong[Interchangeable:] Congruent values are interchangeable in
  modulo arithmetic.

  For example, suppose $\(a equiv b med mod med q\)$ and
  $\(c equiv d med mod med q\)$. Then, $a$ and $b$ are interchangeable,
  and $c$ and $d$ are interchangeable in modulo arithmetic as follows:

  $\(a + c\)equiv\(b + d\)equiv\(a + d\)equiv\(b + c\)med mod med q$

  $\(a - c\)equiv\(b - d\)equiv\(a - d\)equiv\(b - c\)med mod med q$

  $\(a dot.op c\)equiv\(b dot.op d\)equiv\(a dot.op d\)equiv\(b dot.op c\)med mod med q$

]
The proof of Theorem~@subsec:modulo-arithmetic\.2 is similar to that of
Theorem~@subsec:modulo-arithmetic\.1, which we leave as an exercise for
the reader.

== Inverse
<subsec:modulo-inverse>
#block[
In modulo $q$ (i.e., in the world of remainders where all numbers have
been divided by $q$), for each $a in { 0\,1\,2\,dots.h.c\,q - 1 }$:

- #strong[Additive Inverse] of $a$ is denoted as $a_(+)^(- 1)$ which
  satisfies $a + a_(+)^(- 1) equiv 0 med mod med q$. For example, in
  modulo 11, $3_(+)^(- 1) = 8$, because $3 + 8 equiv 0 med mod med 11$.

- #strong[Multiplicative Inverse] of $a$ is denoted as $a_(*)^(- 1)$
  which satisfies $a dot.op a_(*)^(- 1) equiv 1 med mod med q$. Such an
  inverse exists if and only if $gcd\(a\,q\)= 1$. For example, modulo
  11, $3_(*)^(- 1) = 4$, because $3 dot.op 4 equiv 1 med mod med 11$.

]
== Modulo Division
<subsec:modulo-division>
In modulo arithmetic, #emph[modulo division] is different from regular
numeric division. Strictly speaking, there is no separate operation
called "modulo division", because the modulo operation already returns
only the remainder of a division. In practice, one uses "modulo
division" to mean multiplying by a modular inverse when it exists, i.e.,
when $gcd\(a\,q\)= 1$. #emph[Modulo division] of $b$ by $a$ modulo $q$
is equivalent to computing the #emph[modular] multiplication
$b dot.op a^(- 1) med mod med q$. The result of #emph[modulo division]
is different from that of numeric division because #emph[modulo
division] always gives an integer (a residue modulo $q$) (as it
multiplies two integers modulo $q$), whereas numeric division gives a
real number. The inverse of an integer modulo $q$ can be computed using
the extended Euclidean algorithm
(#link("https://www.youtube.com/watch?v=fz1vxq5ts5I")[YouTube tutorial]).

== Centered Residue Representation
<subsec:modulo-centered>
Throughout this section, we have assumed that the residues are positive
integers. For example, the possible residues modulo $q$ are assumed to
be ${ 0\,1\,dots.h.c\,q - 1 }$. This system is called the canonical
(i.e., unsigned) residue representation. On the other hand, there is
also a counterpart system that assumes signed (i.e., centered) residues
${- q / 2 \, - q / 2 + 1 \, dots.h.c \, 0 \, dots.h.c \, q / 2 - 2 \, q / 2 - 1}$#footnote[Here,
we assume $q$ is an even number. In the case where $q$ is an odd number,
the residues are
${- frac(q - 1, 2) \, - frac(q - 3, 2) \, dots.h.c \, 0 \, dots.h.c \, frac(q - 3, 2) \, frac(q - 1, 2)}$],
with the residues centered around $0$, and the total number of residues
is the same, namely $q$. In both systems, a modulo operation changes a
given value to another value within the system's residue range such
that: (1) if the given value is greater than the upper bound of the
residue range, the value is subtracted by the modulus $q$\; (2) if the
value is less than the lower bound of the residue range, the value is
increased by the modulus $q$. The only difference between these two
(canonical and centered) systems is their upper bounds and lower bounds:
$0$ and $q - 1$ in the canonical residue system, whereas $- q / 2$ and
$q / 2 - 1$ in the centered residue system. The canonical residue
representation assumes that $bb(Z)_q = { 0\,1\,dots.h.c\,q - 1 }$,
whereas the centered residue system assumes that
$bb(Z)_q = {- q / 2 \, - q / 2 + 1 \, dots.h.c \, 0 \, dots.h.c \, q / 2 - 2 \, q / 2 - 1}$.

In both systems, the same properties hold for addition, subtraction,
multiplication, and division (when the divisor is invertible). This can
be proved using the reasoning from
#link(<subsec:modulo-arithmetic>)[0.2]: any two congruent residues
differ by an integer multiple of $q$ in either representation.

Also, the same property holds for an inverse: an inverse of $a$ modulo
$q$ is $a^(- 1)$ such that $a dot.op a^(- 1) equiv 1 med mod med q$.

Using a signed residue representation is useful in certain cases. In an
example of canonical (i.e., unsigned) residue representation, suppose we
have the relation $a + b med mod med q$ and we know that in a given
application, $a + b$ is guaranteed to be within the $\[0\,q - 1\]$ range
(i.e., $0 lt.eq a + b lt.eq q - 1$). Then, $\(a + b med mod med q\)$ =
$a + b$, and thus we can remove the modulo operation, simplifying the
relation. Now, suppose a different example of centered (i.e., signed)
residue representation where we have the relation $a - b med mod med q$,
and we know that in a given application, $a - b$ is guaranteed to be
within the range $[- q / 2 \, q / 2 - 1]$. Then,
$\(a - b med mod med q\)= a - b$. However, notice that if the relation
$a - b med mod med q$ were in a canonical residue representation, then
we cannot remove the modulo operation because if $a - b$ is negative,
then this becomes smaller than the lower bound of the canonical residue
system (i.e., $0$), and thus a modulo reduction (i.e., addition by one
or more $q$) is needed.

In #link("./d05-rns.typ#<subsec:rns-fastbconvex>")[\[subsec:rns-fastbconvex\]], we
design the FastBConvEx operation based on this beneficial property of
centered residue representation: in this algorithm design, we can
simplify $\(mu + u med mod med b_alpha\)$ to $mu + u$ because we know
that $- b_alpha / 2 lt.eq mu + u < b_alpha / 2$.
