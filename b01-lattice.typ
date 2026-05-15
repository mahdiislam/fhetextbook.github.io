#strong[\- Reference:]
#link("https://mysite.science.uottawa.ca/mnevins/papers/StephenHarrigan2017LWE.pdf")[Lattice-Based Cryptography and the Learning with Errors Problem]~@lattice-crypto

$$

Lattice-based cryptography is often considered as post-quantum
cryptography, resistant against quantum computer attacks. This section
describes the mathematical hard problem that is the basis of the
lattice-based cryptosystems we will explore: LWE (Learning with Error)
cryptosystem, RLWE (Ring Learning with Error) cryptosystem, GLWE
(General Learning with Error) cryptosystem, GLev cryptosystem, and GGSW
cryptosystem.

== Overview
<subsec:lattice-overview>
Suppose we have a single unknown $k$-dimensional vector $arrow(s)$ as a
secret key, many publicly known $k$-dimensional vectors
$arrow(a)^(chevron.l i chevron.r)$.

And suppose we have a large set of the following dot products
$arrow(s) dot.op arrow(a)^(chevron.l i chevron.r)$:

$arrow(s) dot.op arrow(a)^(chevron.l 0 chevron.r) = s_0 dot.op a_0^(chevron.l 0 chevron.r) + s_1 dot.op a_1^(chevron.l 0 chevron.r) + dots.h.c + s_(k - 1) dot.op a_(k - 1)^(chevron.l 0 chevron.r) = b^(chevron.l 0 chevron.r)$

$arrow(s) dot.op arrow(a)^(chevron.l 1 chevron.r) = s_0 dot.op a_0^(chevron.l 1 chevron.r) + s_1 dot.op a_1^(chevron.l 1 chevron.r) + dots.h.c + s_(k - 1) dot.op a_(k - 1)^(chevron.l 1 chevron.r) = b^(chevron.l 1 chevron.r)$

$arrow(s) dot.op arrow(a)^(chevron.l 2 chevron.r) = s_0 dot.op a_0^(chevron.l 2 chevron.r) + s_1 dot.op a_1^(chevron.l 2 chevron.r) + dots.h.c + s_(k - 1) dot.op a_(k - 1)^(chevron.l 2 chevron.r) = b^(chevron.l 2 chevron.r)$

$dots.v$

$$

Suppose that all
$\(arrow(a)^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\)$ tuples
are publicly known. An attacker only needs $k$ such tuples to derive the
secret vector $arrow(s)$. Specifically, as there are $k$ unknown
variables (i.e., $s_0\,s_1\,dots.h.c\,s_(k - 1)$), the attacker can
solve for those $k$ variables with $k$ equations by using linear
algebra.

However, suppose that in each equation above, we randomly add an unknown
small noise $e^(chevron.l i chevron.r)$ (i.e., error) as follows:

$arrow(s) dot.op arrow(a)^(chevron.l 0 chevron.r) = s_0 dot.op a_0^(chevron.l 0 chevron.r) + s_1 dot.op a_1^(chevron.l 0 chevron.r) + dots.h.c + s_(k - 1) dot.op a_(k - 1)^(chevron.l 0 chevron.r) + e^(chevron.l 0 chevron.r) approx b^(chevron.l 0 chevron.r)$

$arrow(s) dot.op arrow(a)^(chevron.l 1 chevron.r) = s_0 dot.op a_0^(chevron.l 1 chevron.r) + s_1 dot.op a_1^(chevron.l 1 chevron.r) + dots.h.c + s_(k - 1) dot.op a_(k - 1)^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r) approx b^(chevron.l 1 chevron.r)$

$arrow(s) dot.op arrow(a)^(chevron.l 2 chevron.r) = s_0 dot.op a_0^(chevron.l 2 chevron.r) + s_1 dot.op a_1^(chevron.l 2 chevron.r) + dots.h.c + s_(k - 1) dot.op a_(k - 1)^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r) approx b^(chevron.l 2 chevron.r)$

$dots.v$

$$

Then, even if the attacker has a sufficient number of
$\(arrow(a)^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\)$
tuples, it is not feasible to derive $s_0\,s_1\,dots.h.c\,s_(k - 1)$,
because even a small amount of noise added to each equation prevents the
linear-algebra-based direct derivation of the unknown variables. For
each of the above equations, the attacker has to consider as many
possibilities as there are possible values of
$e^(chevron.l i chevron.r)$. For example, if there are $r$ possible
values for each noise $e^(chevron.l i chevron.r)$, the attacker's
brute-force search space for applying linear algebra to those $k$
equations is:
$overbrace(r times r times r times dots.h.c times r, upright("k times")) = r^k$.
Thus, the number of noisy equations grows, and the aggregate
possibilities of $e^(chevron.l i chevron.r)$s grow exponentially, which
means that the attacker's cost of attack grows exponentially.

Based on this intuition, the mathematical hard problem that constitutes
lattice-based cryptography is as follows:

$$

#block[
#strong[#underline[LWE Problem]]

Consider samples of the form: $b = arrow(s) dot.op arrow(a) + e$ (where
$e$ is a small noise to be explained later).

For each encryption, a random $k$-dimensional vector
$arrow(a) in bb(Z)_q^k$ and a small noise value $e in bb(Z)_q$ are newly
sampled from ${ 0\,1\,dots.h.c\,q - 1 }$, where $q$ is the ciphertext
domain size. On the other hand, the $k$-dimensional secret vector
$arrow(s)$ is the same for all encryptions. Suppose we have a sufficient
number of ciphertext tuples:

$\(arrow(a)^(chevron.l 1 chevron.r)\,b^(chevron.l 1 chevron.r)\)$, where
$b^(chevron.l 1 chevron.r) = arrow(s) dot.op arrow(a)^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r)$

$\(arrow(a)^(chevron.l 2 chevron.r)\,b^(chevron.l 2 chevron.r)\)$, where
$b^(chevron.l 2 chevron.r) = arrow(s) dot.op arrow(a)^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r)$

$\(arrow(a)^(chevron.l 3 chevron.r)\,b^(chevron.l 3 chevron.r)\)$, where
$b^(chevron.l 3 chevron.r) = arrow(s) dot.op arrow(a)^(chevron.l 3 chevron.r) + e^(chevron.l 3 chevron.r)$

$dots.v$

Suppose that the attacker has a sufficiently large number of
$\(arrow(a)^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\)$
tuples. Given this setup, the following hard problems constitute the
defense mechanism of the LWE (Learning with Errors) cryptosystem:

$$

- #strong[Search-Hard Problem:] There is no efficient algorithm for the
  attacker to find out the secret key vector $arrow(s)$.

- #strong[Decision-Hard Problem:] We create a black box system which can
  be configured to one of the following two modes: (1) all
  $b^(chevron.l i chevron.r)$ values are purely randomly generated; (2)
  all $b^(chevron.l i chevron.r)$ values are computed as the results of
  $arrow(s) dot.op arrow(a)^(chevron.l i chevron.r) + e^(chevron.l i chevron.r)$
  based on the randomly picked known public (symmetric) keys
  $arrow(a)^(chevron.l i chevron.r)$, randomly picked unknown noises
  $e^(chevron.l i chevron.r)$, and a constant unknown secret vector
  $arrow(s)$. Given a sufficient number of
  $\(arrow(a)^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\)$
  tuples generated by this black box system, the attacker has no
  efficient algorithm to determine which mode this black box system is
  configured to.

$$

These two problems are interchangeable.

$$

#strong[#underline[RLWE Problem]]

In the case of the RLWE (Ring Learning with Errors) problem, the only
difference is that $arrow(a)$, $b$, $arrow(s)$, and $e$ are replaced by
polynomials $\(n - 1\)$-degree polynomials $A$, $B$, $S$, and $E$ in
$bb(Z)_q\[X\]\/\(x^n + 1\)$, and its search-hard problem is finding the
unknown $n$ coefficients of the secret polynomial $S$.

]
== LWE Cryptosystem
<subsec:lattice-scheme>
The LWE cryptosystem uses the following encryption formula:
$b = arrow(s) dot.op arrow(a) + Delta dot.op m + e$ (where $arrow(s)$ is
a secret key, $arrow(a)$ is a publicly known random vector picked per
encryption, $m$ is a plaintext, $e$ is small noise randomly picked per
encryption from a normal distribution, and $b$ is a ciphertext). $Delta$
is a scaling factor of the plaintext $M$ (shifting $m$ by
$upright("log")_2 Delta$ bits to the left). Before encrypting the
plaintext, we left-shift the plaintext several bits (i.e.,
$upright("log")_2 Delta$ bits) to secure sufficient space to store the
error in the lower bits.

#figure(image("figures/TFHE-fig1.pdf", width: 80.0%),
  caption: [
    An illustration of LWE's plaintext scaling and adding a noise:
    $Delta dot.op m + e in bb(Z)_q$
  ]
)
<fig:scaling>

#link(<fig:scaling>)[1] visually illustrates the term
$Delta dot.op m + e$, where the plaintext $m$ left-shifted by
$upright("log")_2 Delta$ bits and noised by the noise $e$. The actual
encryption and decryption formulas are as follows:

#block[
- #strong[#underline[Encryption]:]
  $b^(chevron.l i chevron.r) = arrow(s) dot.op arrow(a)^(chevron.l i chevron.r) + Delta dot.op m^(chevron.l i chevron.r) + e^(chevron.l i chevron.r)$,
  where $b^(chevron.l i chevron.r)$ and
  $arrow(a)^(chevron.l i chevron.r)$ are publicly known also to the
  attacker, while
  $arrow(s)\,m^(chevron.l i chevron.r)\,e^(chevron.l i chevron.r)$ are
  unknown (only known by the secret key owner).

  $$

- #strong[#underline[Decryption]:]
  $frac(ceil.l b^(chevron.l i chevron.r) - arrow(s) dot.op arrow(a)^(chevron.l i chevron.r) floor.r_Delta, Delta) = frac(ceil.l Delta m^(chevron.l i chevron.r) + e^(chevron.l i chevron.r) floor.r_Delta, Delta) = m^(chevron.l i chevron.r)$
  $#scale(x: 180%, y: 180%)[\(]$ provided
  $\|e^(chevron.l i chevron.r)\|< Delta / 2 #scale(x: 180%, y: 180%)[\)]$

]
$floor.l ceil.r_Delta$ means rounding the number to the nearest multiple
of $Delta$. For example, $floor.l 16 ceil.r_10 = 20$, which is rounding
16 to the nearest multiple of 10. As another example,
$floor.l 17 ceil.r_8 = 16$, which rounds 17 to the nearest multiple of 8
(note that 17 is closer to 16 than to 24; thus, it is rounded to 16).

$$

#strong[Correctness:] In the decryption scheme, computing
$b^(chevron.l i chevron.r) - arrow(s) dot.op arrow(a)^(chevron.l i chevron.r)$
gives
$Delta dot.op m^(chevron.l i chevron.r) + e^(chevron.l i chevron.r)$,
which is #link(<fig:scaling>)[1]. Then,
$ceil.l Delta dot.op m^(chevron.l i chevron.r) + e^(chevron.l i chevron.r) floor.r_Delta$
(i.e., rounding the value to the nearest multiple of $Delta$) gives
$Delta dot.op m^(chevron.l i chevron.r)$, provided the added noise
$\|e^(chevron.l i chevron.r)\|< Delta / 2$. That is, if the noise is
less than $Delta / 2$, it will disappear during the rounding. Finally,
right-shifting $Delta dot.op m^(chevron.l i chevron.r)$ by
$upright("log")_2 Delta$ bits gives $m^(chevron.l i chevron.r)$. To
summarize, if we ensure $\|e^(chevron.l i chevron.r)\|< Delta / 2$
(which is why the noise $e^(chevron.l i chevron.r)$ should be smaller
than this threshold), then we can eliminate $e^(chevron.l i chevron.r)$
during the decryption's rounding process and retrieve the original
$Delta dot.op m^(chevron.l i chevron.r)$. The reason we scaled
$m^(chevron.l i chevron.r)$ by $Delta$ is to: (i) create space for
storing $e^(chevron.l i chevron.r)$ in the lower bits during encryption
such that the noise bits do not interfere with the plaintext bits (to
avoid corrupting the plaintext bits); and (ii) blow away the noise
$e^(chevron.l i chevron.r)$ stored in the lower bits during decryption
without corrupting the plaintext $m^(chevron.l i chevron.r)$.

$$

#strong[Security:] Given that an attacker has a large list of
$\(arrow(a)^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\)$ (i.e.,
many ciphertexts), it is almost impossible for them to derive
$arrow(s)$, due to the random noise $e^(chevron.l i chevron.r)$ added in
each encryption (which is a search-hard problem described in
#link(<subsec:lattice-overview>)[0.1]). This is because even small added
unknown noises $e^(chevron.l i chevron.r)$ greatly change the
mathematical solution for $arrow(s)$ that satisfies all the
$b^(chevron.l i chevron.r) = arrow(s) dot.op arrow(a)^(chevron.l i chevron.r) + Delta dot.op m^(chevron.l i chevron.r) + e^(chevron.l i chevron.r)$
equations.

Even in the case that the attacker has a large list of
$\(arrow(a)^(\(j\))\,b^(\(j\))\)$ generated for the same ciphertext
$m^(chevron.l i chevron.r)$ (where each ciphertext used different
$arrow(a)^(\(j\))$ and $e^(\(j\))$ to encrypt the same
$m^(chevron.l i chevron.r)$), he still cannot derive
$m^(chevron.l i chevron.r)$, because a randomly picked different noise
$e^(\(j\))$ is used for every $\(arrow(a)^(\(j\))\,b^(\(j\))\)$ and is
accumulated over ciphertexts, which exponentially complicates the
difficulty of the linear algebra involved in solving $arrow(s)$. Also,
in the actual cryptosystem (#link(<sec:lwe>)[\[sec:lwe\]]), the publicly
known random vector $arrow(a)^(chevron.l i chevron.r)$ and the secret
key $arrow(s)$ are not a single number but a long vector comprising many
random numbers. Thus, adding
$arrow(a)^(chevron.l i chevron.r) dot.op arrow(s)$ to
$Delta m^(chevron.l i chevron.r) + e^(chevron.l i chevron.r)$ increases
the entropy of randomness against the attack.

$$

To summarize, lattice-based cryptography hides plaintext by adding the
encryption component $arrow(s) dot.op arrow(a)$ to it, along with a
small random noise $e$. During decryption, the secret key owner
re-creates this encryption component $arrow(a) dot.op arrow(s)$ by using
her $arrow(s)$ and removes it. She then removes the noise $e$ using the
rounding technique and finally right-shifts the remaining $Delta m$ by
$upright("log")_2 Delta$ bits to get $m$.

== RLWE Cryptosystem
<subsec:lattice-scheme2>
In the RLWE cryptosystem, the formula in is the same, but
$arrow(s)\,arrow(a)^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\,m^(chevron.l i chevron.r)\,e^(chevron.l i chevron.r)$
are replaced by polynomials
$S\,A^(chevron.l i chevron.r)\,B^(chevron.l i chevron.r)\,M^(chevron.l i chevron.r)\,E^(chevron.l i chevron.r)$
as follows:

#block[
- #strong[#underline[Encryption]:]
  $B^(chevron.l i chevron.r) = S dot.op A^(chevron.l i chevron.r) + Delta dot.op M^(chevron.l i chevron.r) + E^(chevron.l i chevron.r)$,
  where $B^(chevron.l i chevron.r)$ and $A^(chevron.l i chevron.r)$ are
  publicly known also to the attacker, while
  $S\,M^(chevron.l i chevron.r)\,E^(chevron.l i chevron.r)$ are unknown
  (only known by the secret key owner).

  $$

- #strong[#underline[Decryption]:]
  $frac(ceil.l B^(chevron.l i chevron.r) - S dot.op A^(chevron.l i chevron.r) floor.r_Delta, Delta) = frac(ceil.l Delta M^(chevron.l i chevron.r) + E^(chevron.l i chevron.r) floor.r_Delta, Delta) = M^(chevron.l i chevron.r)$
  \ $#scale(x: 180%, y: 180%)[\(]$provided
  $\|\|E^(chevron.l i chevron.r)\|\|_oo< Delta / 2$, meaning each
  coefficient of $E^(chevron.l i chevron.r)$ has a magnitude less than
  $Delta / 2 #scale(x: 180%, y: 180%)[\)]$

  $$

  $ceil.l floor.r_Delta$ is equivalent to rounding each term's
  coefficient in the polynomial.

]
