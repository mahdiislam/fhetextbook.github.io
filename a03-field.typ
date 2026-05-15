#strong[\- Reference:]
#link("https://e.math.cornell.edu/people/belk/numbertheory/CyclotomicPolynomials.pdf")[Fields and Cyclotomic Polynomials]~@cyclotomic-polynomial

== Definitions
<subsec:field-def>
#block[
- #strong[Ring:] A set $R$ that is an abelian group under addition
  $\(+\)$, equipped with a multiplication $\(dot.op\)$ that is closed
  and associative, and such that multiplication distributes over
  addition on both sides: $a dot.op\(b + c\)= a dot.op b + a dot.op c$
  and $\(a + b\)dot.op c = a dot.op c + b dot.op c$ for all
  $a\,b\,c in R$. (Multiplication is not necessarily commutative, e.g.,
  a matrix multiplication, and an identity element for $\(dot.op\)$ is
  optional unless stated "ring with unity"\.)

- #strong[Field:] A set $F$ that is an abelian group under $\(+\)$,
  whose nonzero elements $F^times = F\\{ 0 }$ form an abelian group
  under $\(dot.op\)$, with multiplication distributing over addition.

- #strong[Galois Field ($upright(G F)\(p^n\)$):] A field with $p^n$
  elements for some prime $p$ and positive integer $n$.

- #strong[$bb(Z)_p$ ($bb(Z)\/p bb(Z)$):] For a prime $p$, the set
  ${ 0\,1\,dots.h\,p - 1 }$ with addition and multiplication modulo $p$
  forms a finite field. More generally, for any integer $m gt.eq 2$,
  $bb(Z)_m$ is a commutative ring, and it is a field iff $m$ is prime.

]
$$

== Examples
<subsec:field-ex>
$bb(Z)$ (the set of all integers) is a ring but not a field, because not
all of its elements have a multiplicative inverse (as shown in
#link(<subsec:group-ex>)[\[subsec:group-ex\]]).

$$

$bb(R)$ (the set of all real numbers) is a field. As shown in
#link(<subsec:group-ex>)[\[subsec:group-ex\]], it is an abelian group
under $\(+\)$\; its nonzero elements form an abelian group under
$\(dot.op\)$, and multiplication distributes over addition.

$$

$bb(Z)_7 = { 0\,1\,2\,3\,4\,5\,6 }$ is a finite field because:

- #strong[Closed:] For any $a\,b in bb(Z)_7$, there exist
  $c_1\,c_2 in bb(Z)_7$ such that $a + b equiv c_1 med\(mod med 7\)$ and
  $a dot.op b equiv c_2 med\(mod med 7\)$.

- #strong[Associative:] For any $a\,b\,c in bb(Z)_7$,
  $\(a + b\)+ c = a +\(b + c\)$, and
  $\(a dot.op b\)dot.op c = a dot.op\(b dot.op c\)$.

- #strong[Commutative:] For any $a\,b in bb(Z)_7$, $a + b = b + a$, and
  $a dot.op b = b dot.op a$.

- #strong[Distributive:] For any $a\,b\,c in bb(Z)_7$,
  $\(a + b\)dot.op c = a dot.op c + b dot.op c$, and
  $a dot.op\(b + c\)= a dot.op b + a dot.op c$.

- #strong[Identity:] The additive identity is $0$, and the
  multiplicative identity is $1$.

- #strong[Inverse:] For any $a in bb(Z)_7$, there exists $a' in bb(Z)_7$
  such that $a + a' equiv 0 med\(mod med 7\)$ (e.g., the additive
  inverse of $3$ is $4$ since $3 + 4 equiv 0 med\(mod med 7\)$). For any
  $a in bb(Z)_7^times = { 1\,dots.h\,6 }$, there exists
  $b in bb(Z)_7^times$ such that $a b equiv 1 med\(mod med 7\)$ (e.g.,
  $3 dot.op 5 = 15 equiv 1 med\(mod med 7\)$).

== Theorems
<subsec:field-theorem>
#block[
+ #strong[Size of Finite Field:] Every finite field (also called a
  Galois Field) has $p^n$ elements for some prime $p$ and positive
  integer $n$, conversely, for each such prime power $p^n$, there exists
  a finite field of order $p^n$ (unique up to isomorphism).

+ #strong[Isomorphic Fields:] Any two finite fields $bb(F)_1$ and
  $bb(F)_2$ with the same number of elements are isomorphic, i.e., there
  exists a bijection $f : bb(F)_1 arrow.r bb(F)_2$ such that for all
  $a\,b in bb(F)_1$, $f\(a + b\)= f\(a\)+ f\(b\)$ and
  $f\(a b\)= f\(a\)f\(b\)$.

]
