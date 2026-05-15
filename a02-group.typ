== Definitions
<subsec:group-def>
#block[
#strong[#underline[Set Elements]]

- #strong[Set ($bb(S)$):] An unordered collection of elements:
  $bb(S) = { a\,b\,c\,dots.h }$

- #strong[Set Operations $bold(\(+\,dot.op\))$:] We consider two binary
  operations on $bb(S)$: addition $\(+\)$ and multiplication
  $\(dot.op\)$.

- #strong[Additive Identity ($0_(\(+\))$ often written $0$):] An element
  $i in bb(S)$ is an additive identity if for all $a in bb(S)$,
  $i + a = a = a + i$.

- #strong[Multiplicative Identity ($1_(\(dot.op\))$ often written $1$):]
  An element $i in bb(S)$ is a multiplicative identity if for all
  $a in bb(S)$, $i dot.op a = a = a dot.op i$

- #strong[Additive Inverse ($a_(\(+\))^(- 1)$):] For each $a in bb(S)$,
  its additive inverse $a_(\(+\))^(- 1)$, often written $- a$, is
  defined as an element such that
  $a + a_(\(+\))^(- 1) = 0_(\(+\)) = a_(\(+\))^(- 1) + a$ (i.e.,
  additive identity)

- #strong[Multiplicative Inverse ($a_(\(dot.op\))^(- 1)$):] For each
  $a in bb(S)$ that is invertible with respect to $\(dot.op\)$, its
  multiplicative inverse $a_(\(dot.op\))^(- 1)$, often written
  $a^(- 1)$, is defined as an element such that
  $a dot.op a_(\(dot.op\))^(- 1) = 1_(\(dot.op\)) = a_(\(dot.op\))^(- 1) dot.op a$
  (i.e., multiplicative identity)

$$

#strong[#underline[Element Operation Features]]

- #strong[Closed:] A set $bb(S)$ is closed under the $\(+\)$ operation
  if for every $a\,b in bb(S)$, it is the case that $a + b in bb(S)$.
  Likewise, a set $bb(S)$ is closed under the $\(dot.op\)$ operation if
  for every $a\,b in bb(S)$, it is the case that $a dot.op b in bb(S)$.

- #strong[Associative:] For any $a\,b\,c in bb(S)$,
  $\(a + b\)+ c = a +\(b + c\)$

- #strong[Commutative:] For any $a\,b in bb(S)$, $a + b = b + a$

- #strong[Distributive:] If both $\(+\)$ and $\(dot.op\)$ are defined
  (e.g. in a ring), then
  $a dot.op\(b + c\)=\(a dot.op b\)+\(a dot.op c\)$, and
  $\(a + b\)dot.op c = a dot.op c + b dot.op c$.

$$

#strong[#underline[Group Types]]

- #strong[Semigroup:] A semigroup is a set of elements which is closed
  and associative on a single operation ($+$ or $dot.op$)

- #strong[Monoid:] A monoid is a semigroup with an identity element $e$
  (a neutral element that leaves any other element unchanged under the
  operation).

  \(e.g., $0$ is the identity element for $+$ operator, $1$ is the
  identity element for the $dot.op$ operator)

- #strong[Group:] A group is a monoid, and every element has an inverse
  with respect to the operation.

- #strong[Abelian Group:] An abelian group is a group, plus its
  operation is commutative.

]
== Examples
<subsec:group-ex>
$bb(Z)$ (i.e., the set of all integers) is an abelian group under
addition ($+$), because:

- #strong[Closed:] For any integer $a\,b in bb(Z)$, $a + b = c$ is also
  an integer (i.e. $a + b in bb(Z)$).

- #strong[Associative:] For any integer $a\,b\,c in bb(Z)$,
  $\(a + b\)+ c = a +\(b + c\)$.

- #strong[Identity:] The additive identity is 0 because, for any
  $a in bb(Z)$, $a + 0 = a$.

- #strong[Inverse:] For each $a in bb(Z)$, its additive inverse is
  $- a$, as $a +\(- a\)= 0$.

- #strong[Commutative:] For any integer $a\,b in bb(Z)$,
  $a + b = b + a$.

$$

$bb(Z)$ is a monoid under multiplication ($dot.op$) because:

- #strong[Closed:] For any integer $a\,b in bb(Z)$, $a dot.op b = c$ is
  also an integer (i.e., $a dot.op b in bb(Z)$).

- #strong[Associative:] For any integer $a\,b\,c in bb(Z)$,
  $\(a dot.op b\)dot.op c = a dot.op\(b dot.op c\)$.

- #strong[Identity:] The multiplicative identity is 1, because for any
  $a in bb(Z)$, $a dot.op 1 = a$.

- #strong[NO Inverse:] For an integer $a in bb(Z)$, its multiplicative
  inverse is $1 / a$, but this is not necessarily an integer
  ($in.not bb(Z)$); therefore, not every element has a multiplicative
  inverse. Thus, $\(bb(Z)\,dot.op\)$ is not a group (though it is a
  monoid).

$$

$bb(R)^times$ (i.e., the set of all nonzero real numbers) is an abelian
group under multiplication ($dot.op$), because:

- #strong[Closed:] For any real number $a\,b in bb(R)^times$,
  $a dot.op b = c$ is also a real number (and remains in $bb(R)^times$).

- #strong[Associative:] For any real number $a\,b\,c in bb(R)^times$,
  $\(a dot.op b\)dot.op c = a dot.op\(b dot.op c\)$.

- #strong[Identity:] The multiplicative identity is 1, as for any real
  number $a in bb(R)^times$, $a dot.op 1 = a$.

- #strong[Inverse:] For each real number $a in bb(R)^times$, its
  multiplicative inverse is $1 / a$, which is a non-zero real number
  ($in bb(R)^times$).
