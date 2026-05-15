#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-2")[TFHE Deep Dive - Part II - Encodings and linear leveled operations]~@tfhe-2

$$

Suppose we have two GLWE ciphertexts encrypting two different plaintexts
$M^(chevron.l 1 chevron.r)\,M^(chevron.l 2 chevron.r)$:

$sans("GLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)= sans("ct")^(chevron.l 1 chevron.r) =\(A_0^(chevron.l 1 chevron.r)\,A_1^(chevron.l 1 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

$sans("GLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)= sans("ct")^(chevron.l 2 chevron.r) =\(A_0^(chevron.l 2 chevron.r)\,A_1^(chevron.l 2 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

$$

Let's define the following ciphertext addition operation:

$sans("ct")^(chevron.l 1 chevron.r) + sans("ct")^(chevron.l 2 chevron.r) =\(A_0^(chevron.l 1 chevron.r) + A_0^(chevron.l 2 chevron.r)\,upright(" ") A_1^(chevron.l 1 chevron.r) + A_1^(chevron.l 2 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 1 chevron.r) + A_(k - 1)^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)$

$$

Then, the following is true:

#block[
$sans("GLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)+ sans("GLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)$

$=\({ A_i^(chevron.l 1 chevron.r) }_(i = 0)^(k - 1)\,upright(" ") B^(chevron.l 1 chevron.r)\)+\({ A_i^(chevron.l 2 chevron.r) }_(i = 0)^(k - 1)\,upright(" ") B^(chevron.l 2 chevron.r)\)$

$=\({ A_i^(chevron.l 1 chevron.r) + A_i^(chevron.l 2 chevron.r) }_(i = 0)^(k - 1)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)$

$= sans("GLWE")_(S\,sigma)\(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 3 chevron.r)\)$
$gt.tri$ where
$E^(chevron.l 3 chevron.r) = E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)$

]
This means that adding two GLWE ciphertexts (each of which encrypts
$M^(chevron.l 1 chevron.r)$ and $M^(chevron.l 2 chevron.r)$) and
decrypting the resulting ciphertext yields
$M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)$.

$$

#block[
+ Define the following notations: \
  $A_0^(chevron.l 3 chevron.r) = A_0^(chevron.l 1 chevron.r) + A_0^(chevron.l 2 chevron.r)$
  \
  $A_1^(chevron.l 3 chevron.r) = A_1^(chevron.l 1 chevron.r) + A_1^(chevron.l 2 chevron.r)$
  \ $dots.v$ \
  $A_(k - 1)^(chevron.l 3 chevron.r) = A_(k - 1)^(chevron.l 1 chevron.r) + A_(k - 1)^(chevron.l 2 chevron.r)$
  \
  $E^(chevron.l 3 chevron.r) = E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)$
  \
  $B^(chevron.l 3 chevron.r) = B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)$

+ Derive the following: \
  $B^(chevron.l 3 chevron.r) = B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)$
  \
  $= sum_(i = 0)^(k - 1)\(A_i^(chevron.l 1 chevron.r) dot.op S_i\)+ Delta dot.op M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + sum_(i = 0)^(k - 1)\(A_i^(chevron.l 2 chevron.r) dot.op S_i\)+ Delta dot.op M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)$
  \
  $= sum_(i = 0)^(k - 1)\(\(A_i^(chevron.l 1 chevron.r) + A_i^(chevron.l 2 chevron.r)\)dot.op S_i\)+ Delta dot.op\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+\(E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)\)$
  $gt.tri$ commutative and distributive rules \
  $= sum_(i = 0)^(k - 1)\(A_i^(chevron.l 3 chevron.r) dot.op S_i\)+ Delta dot.op\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 3 chevron.r)$
  \

+ Since
  $B^(chevron.l 3 chevron.r) = sum_(i = 0)^(k - 1)\(A_i^(chevron.l 3 chevron.r) dot.op S_i\)+ Delta dot.op\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 3 chevron.r)$,

  this means that
  $\(A_0^(chevron.l 3 chevron.r)\,A_1^(chevron.l 3 chevron.r)\,A_2^(chevron.l 3 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 3 chevron.r)\,B^(chevron.l 3 chevron.r)\)$
  form the ciphertext:
  $sans("GLWE")_(S\,sigma)\(Delta dot.op\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 3 chevron.r)\)$.
  \

+ Thus, \
  $sans("GLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)+ sans("GLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)$
  \
  $=\(A_0^(chevron.l 1 chevron.r) + A_0^(chevron.l 2 chevron.r)\,upright(" ") A_1^(chevron.l 1 chevron.r) + A_1^(chevron.l 2 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 1 chevron.r) + A_(k - 1)^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)$
  \
  $=\(A_0^(chevron.l 3 chevron.r)\,A_1^(chevron.l 3 chevron.r)\,A_2^(chevron.l 3 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 3 chevron.r)\,B^(chevron.l 3 chevron.r)\)$
  \
  $=\({ A_i^(chevron.l 3 chevron.r) }_(i = 0)^(k - 1)\,B^(chevron.l 3 chevron.r)\)$
  \
  $= sans("GLWE")_(S\,sigma)\(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 3 chevron.r)\)$

]
== Discussion
<subsubsec:glwe-add-cipher-discuss>
If we decrypt
$sans("GLWE")_(S\,sigma)\(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 3 chevron.r)\)$
by using the secret key $S$, then we get the plaintext
$M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)$. Meanwhile,
$A_1^(chevron.l 3 chevron.r)\,A_2^(chevron.l 3 chevron.r)\,dots.h\,A_(k - 1)^(chevron.l 3 chevron.r)\,E^(chevron.l 3 chevron.r)$
gets eliminated by decryption (with rounding), regardless of whatever
their randomly sampled values were during encryption.

$$

Note that after decryption, the original ciphertext $C$'s noise has
increased from $E^(chevron.l 1 chevron.r)$ and
$E^(chevron.l 2 chevron.r)$ to
$E^(chevron.l 3 chevron.r) = E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)$.
However, if the noise is sampled from a Gaussian distribution with the
mean $mu = 0$, then the noise variance grows linearly with the number of
additions and eventually consumes the budget $Delta\/2$. However, this
growth rate is significantly lower than that of homomorphic
multiplication, where noise typically grows multiplicatively.

$$

During homomorphic operations (e.g., addition or multiplication) and
decryption, the $A S$ and $B$ terms in the $B = A S + Delta M + E + v q$
relation are allowed to wrap around modulo $q$ indefinitely, because
regardless of whatever their wrapping count is, the final decryption
step will always subtract $B$ by $A S$, outputting
$Delta M + E + v' q = Delta M + E med\(mod med q\)$, and the $v' q$ term
is always exactly eliminated by modulo reduction by $q$. After that, we
can correctly recover $M$ by computing
$⌈frac(Delta M + E med mod med q, Delta)⌋$, eliminating the noise $E$.
However, as we learned in Summary~@subsubsec:lwe-noise-bound (in
#link(<subsubsec:lwe-noise-bound>)[\[subsubsec:lwe-noise-bound\]]), if
the error bound $\|- epsilon.alt v t + e\|< Delta / 2$ breaks (where $e$
can be any coefficient of $E$), then modulo reduction by $q$ starts to
contaminate the scaled plaintext bits. This violation of the error bound
occurs when the noise $e$ grows too much over homomorphic operations, or
the ciphertext modulus $q$ is not sufficiently larger than the plaintext
modulus $t$. If $q gt.double t$, the scheme can take on a big $v t$
value (i.e., the plaintext value can wrap around the plaintext modulus
$t$ many times across its homomorphic operations). The error bound
constraint $frac(v t + e, floor.l q / t floor.r) < 1 / 2$ is used in the
BFV scheme.
