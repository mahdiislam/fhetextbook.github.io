== Rescaling Modulo of Congruence Relations
<subsec:modulo-rescaling>
Remember from #link(<sec:modulo>)[\[sec:modulo\]] that $a med mod med q$
is the remainder of $a$ divided by $q$, and the congruence relation
$a equiv b med mod med q$ means that the remainder of $a$ divided by $q$
is the same as the remainder of $b$ divided by $q$. Its equivalent
numeric equation is $a = b + k dot.op q$, meaning that $a$ and $b$
differ by some multiple of $q$. The congruence and equation are two
different ways of describing the relationship between two numbers $a$
and $b$.

In this section, we introduce another way of describing the relationship
between numbers. We will describe two numbers $a$ and $b$ in terms of a
different modulo $q'$ instead of the original modulo $q$. Such a change
of modulo in a congruence relation is called modulo scaling. When we
rescale the modulo of a congruence relation, we also need to rescale the
numbers involved in the congruence relation.

Suppose we have the following congruence relations:

$a equiv b med mod med q$

$a + c equiv b + d med mod med q$

$a dot.op c equiv b dot.op d med mod med q$

Now, suppose we want to rescale the modulo of the above congruence
relations from $q arrow.r q'$, where $q' divides q$ (meaning $q$ is a
multiple of $q'$). Then, the accordingly updated congruence relations
are as shown in #link(<tab:rescaling>)[1].

#block[
#figure(
  align(center)[#table(
    columns: 3,
    align: (left,left,left,),
    [#strong[Congruence]], [#strong[Rescaled Congruence
    Relation]], [#strong[Rescaled Congruence Relation]],
    [#strong[Relation]], [#strong[-- Exact]], [#strong[-- Approximate]],
    [$a equiv b med mod med q$], [$#scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$], [$#scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] tilde.equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$],
    [], [\(if $q$ divides both $a q'$ and $b q'$)], [\(if $q$ does not
    divide either $a q' upright(" or ") b q'$)],
    [$a + c equiv b + d med mod med q$], [$#scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$], [$#scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r] tilde.equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$],
    [], [\(if $q$ divides all of $a q'\,b q'\,c q'$ and $d q'$)], [\(if
    $q$ does not divide: $a q'\,b q'\,c q'\,$ or $d q'$)],
    [$a dot.op c equiv b dot.op d med mod med q$], [$#scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$], [$#scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r] tilde.equiv #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$],
    [], [\(if $q$ divides both $a c q'$ and $b d q'$)], [\(if $q$ does
    not divide either $a c q'$ or $b d q'$)],
  )]
  , caption: [Rescaling the congruence relations from modulo
  $q arrow.r q'$ (where $ceil.l floor.r$ denotes rounding to the nearest
  integer)]
  , kind: table
  )

] <tab:rescaling>
#block[
#emph[Proof.] $$

+ $a equiv b med mod med q$ $arrow.l.r.double$ $a = b + q dot.op k$ (for
  some integer $k$)

  $arrow.l.r.double a dot.op q' / q = b dot.op q' / q + q dot.op k dot.op q' / q$

  $arrow.l.r.double a dot.op q' / q = b dot.op q' / q + k dot.op q'$

  + If $q$ divides both $a q'$ and $b q'$, then
    $a dot.op q' / q = #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r]$,
    and
    $b dot.op q' / q = #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r]$.
    Therefore:

    $a dot.op q' / q = b dot.op q' / q + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$
    $\(arrow.l.r.double a equiv b med mod med q\)$

    $$

  + If $q$ does not divide either $a q'$ or $b q'$, then
    $a dot.op q' / q approx #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r]$,
    $b dot.op q' / q approx #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r]$.
    Therefore:

    $a dot.op q' / q = b dot.op q' / q + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] approx #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] tilde.equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$
    $\(arrow.l.r.double a equiv b med mod med q\)$

  $$

+ $a + c equiv b + d med mod med q$ $arrow.l.r.double$
  $a + c = b + d + k dot.op q$ (for some integer $k$)

  $arrow.l.r.double a dot.op q' / q + c dot.op q' / q = b dot.op q' / q + d dot.op q' / q + q dot.op k dot.op q' / q$

  $arrow.l.r.double a dot.op q' / q + c dot.op q' / q = b dot.op q' / q + d dot.op q' / q + k dot.op q'$

  + If $q$ divides all of $a q'$, $b q'$, $c q'$, and $d q'$, then

    $a q' / q + c q' / q = #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r]$,
    $b q' / q + d q' / q = #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r]$

    Therefore:

    $a dot.op q' / q + c dot.op q' / q = b dot.op q' / q + d dot.op q' / q + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r] + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$
    $\(arrow.l.r.double a + c equiv b + d med mod med q\)$

    $$

  + If $q$ does not divide at least one of $a q'$, $b q'$, $c q'$, and
    $d q'$, then

    $a q' / q + c q' / q approx #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r]$,
    $b q' / q + d q' / q approx #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r]$

    Therefore:

    $a dot.op q' / q + c dot.op q' / q = b dot.op q' / q + d dot.op q' / q + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r] approx #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r] + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] c q' / q #scale(x: 300%, y: 300%)[floor.r] tilde.equiv #scale(x: 300%, y: 300%)[ceil.l] b q' / q #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$
    $\(arrow.l.r.double a + c equiv b + d med mod med q\)$

  $$

+ $a dot.op c equiv b dot.op d med mod med q$ $arrow.l.r.double$
  $a dot.op c = b dot.op d + k dot.op q$ (for some integer $k$)

  $arrow.l.r.double a c dot.op q' / q = b d dot.op q' / q + q dot.op k dot.op q' / q$

  $arrow.l.r.double a c dot.op q' / q = b d dot.op q' / q + k dot.op q'$

  + If $q$ divides all of $a q'$, $b q'$, $c q'$, and $d q'$, then

    $a c dot.op q' / q = #scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r]$,
    $b d dot.op q' / q = #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r]$

    Therefore:

    $a c dot.op q' / q = b d dot.op q' / q + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r] + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$
    $\(arrow.l.r.double a dot.op c equiv b dot.op d med mod med q\)$

    $$

  + If $q$ does not divide any of $a q'$, $b q'$, $c q'$, or $d q'$,
    then

    $a c dot.op q' / q approx #scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r]$,
    $b d dot.op q' / q approx #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r]$

    Therefore:

    $a c dot.op q' / q = b d dot.op q' / q + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r] approx #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r] + k dot.op q'$

    $arrow.l.r.double #scale(x: 300%, y: 300%)[ceil.l] a c q' / q #scale(x: 300%, y: 300%)[floor.r] tilde.equiv #scale(x: 300%, y: 300%)[ceil.l] b d q' / q #scale(x: 300%, y: 300%)[floor.r] med mod med q'$
    $\(arrow.l.r.double a dot.op c equiv b dot.op d med mod med q\)$

  $$

~◻

]
As shown in the proof, if all numbers in the congruence relations are
exactly divisible by the rescaling factor during the modulo rescaling,
then the rescaled result gives exact congruence relations in the new
modulo. On the other hand, if any numbers in the congruence relations
are not divisible by the rescaling factor during the modulo rescaling
(i.e., we need to round some decimals), then the rescaled result gives
approximate congruence relations in the new modulo.

In a more complicated congruence relation that contains many
$\(+\,-\,dot.op\)$ operations, the same principle of modulo rescaling
explained above can be recursively applied to each pair of operands
surrounding each operator.

=== Example
<subsec:modulo-rescaling-ex>
Suppose we have the following congruence relation:

$b equiv a dot.op s + Delta dot.op m + e med mod med q$, where:
$q = 30$, $s = 5$, $a = 10$, $Delta = 10$, $m = 1$, $e = 10$, $b = 40$

$$

First, we can test if the above congruence relation is true by plugging
in the given example values as follows:

$b equiv a dot.op s + Delta dot.op m + e med mod med 30$

$40 equiv 10 dot.op 5 + 10 dot.op 1 + 10 med mod med 30$

$40 equiv 70 med mod med 30$

$$

This congruence relation is true.

$$

Now, suppose we want to rescale the modulo from $30 arrow.r 3$. Then,
based on the rescaling principles described in
#link(<tab:rescaling>)[1], we compute the rescaled values as follows:

$q' = 3$, $s = 5$, $m = 1$

$hat(a) = #scale(x: 300%, y: 300%)[ceil.l] a dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] 10 dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = 1$

$hat(Delta) = #scale(x: 300%, y: 300%)[ceil.l] Delta dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] 10 dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = 1$

$hat(e) = #scale(x: 300%, y: 300%)[ceil.l] e dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] 10 dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = 1$

$hat(b) = #scale(x: 300%, y: 300%)[ceil.l] b dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = #scale(x: 300%, y: 300%)[ceil.l] 40 dot.op 3 / 30 #scale(x: 300%, y: 300%)[floor.r] = 4$

$$

The rescaled congruence relation from modulo $30 arrow.r 3$ is derived
as follows:

$#scale(x: 300%, y: 300%)[ceil.l] b 3 / 30 #scale(x: 300%, y: 300%)[floor.r] equiv #scale(x: 300%, y: 300%)[ceil.l] s dot.op a 3 / 30 #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] m dot.op Delta 3 / 30 #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] e 3 / 30 #scale(x: 300%, y: 300%)[floor.r] med mod med 3$

$hat(b) equiv hat(a) dot.op s + hat(Delta) dot.op m + hat(e) med mod med 3$
(an exact congruence relation, as all rescaled values have no decimals)

$4 equiv 1 dot.op 5 + 1 dot.op 1 + 1 med mod med 3$

$4 equiv 7 med mod med 3$

$$

As shown above, the rescaled congruence relation preserves correctness,
because all rescaled values are divisible by the rescaling factor. By
contrast, if $q / q' = 30 / 3 = 10$ did not divide at least one of
$a dot.op s$, $Delta m$, or $e$, then the rescaled congruence relation
would be an approximate (i.e., $tilde.equiv$) congruence relation.
