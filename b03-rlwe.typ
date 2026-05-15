The RLWE cryptosystem's ciphertext is a tuple $\(A\,B\)$, where
$B = S dot.op A + Delta dot.op M + E$. The random public mask $A$ and
the secret key $S$ are $\(n - 1\)$-degree polynomials. The message $M$
and the noise $E$ are $\(n - 1\)$-degree polynomials. Like in LWE, a new
random public mask $A$ is created for each ciphertext, whereas the same
secret key $S$ is used for all ciphertexts. In this section, we denote
each ciphertext instance as $\(A\,B\)$ instead of
$\(A^(chevron.l i chevron.r)\,b^(chevron.l i chevron.r)\)$ for
simplicity.

In RLWE, all polynomials are computed in the polynomial ring
$bb(Z)_q\[x\]\/\(x^n + 1\)$, where $x^n + 1$ is a cyclotomic polynomial
with $n = 2^f$ for some integer $f$ and the polynomial coefficients are
in $bb(Z)_q$. Thus, all polynomials in RLWE have the coefficient range
$bb(Z)_q$ and the maximum polynomial degree of $n - 1$. For simplicity,
we denote
$cal(R)_(chevron.l n\,q chevron.r) = bb(Z)_q\[x\]\/\(x^n + 1\)$.

== Setup
<setup>
Let $t$ be the size of plaintext, and $q$ the size of ciphertext, where
$t < q$ ($t$ is much smaller than $q$) and $t\|q$ (i.e., $t$ divides
$q$). Randomly pick a $\(n - 1\)$-degree polynomial
$S in cal(R)_(chevron.l n\,q chevron.r)$ whose coefficients are either
${ - 1\,0\,1 }$ as a secret key. Let $Delta = ⌊q / t⌋$ be the scaling
factor of plaintext.

Notice that RLWE's setup parameters are similar to that of LWE. One
difference is that $S$ is not a vector of length $k$ sampled from
${ - 1\,0\,1 }$, but an $\(n - 1\)$-degree polynomial encoding $n$
secret coefficients, where each coefficient is a randomly picked ternary
number from ${ - 1\,0\,1 }$ (denoted as
$S arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)$).

== Encryption
<subsec:rlwe-enc>
+ Suppose we have an $\(n - 1\)$-degree polynomial
  $M in cal(R)_(chevron.l n\,t chevron.r)$ whose coefficients represent
  the plaintext numbers to encrypt.

+ Randomly pick an $\(n - 1\)$-degree polynomial
  $A in cal(R)_(chevron.l n\,q chevron.r)$ as a one-time random public
  mask (denoted as $A arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)$).

+ Randomly pick a small polynomial
  $E in cal(R)_(chevron.l n\,q chevron.r)$ as a one-time noise, whose
  $n$ coefficients are small numbers in $bb(Z)_q$ randomly sampled from
  the Gaussian distribution $chi_sigma$ (denoted as
  $E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$).

+ Scale $M$ by $Delta$, which is to compute $Delta dot.op M$. This
  converts $M in cal(R)_(chevron.l n\,t chevron.r)$ into
  $Delta dot.op M in cal(R)_(chevron.l n\,q chevron.r)$.

+ Compute
  $B = A dot.op S + Delta dot.op M + E med mod med cal(R)_(chevron.l n\,q chevron.r)$
  (i.e., reduce the degree by $n$ and the coefficient by modulo $q$).

+ The final ciphertext is $\(A\,B\)$.

$$

The RLWE encryption formula is summarized as follows:

$$

#block[
#strong[#underline[Initial Setup]:] $Delta = ⌊q / t⌋$,
$S arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)$

$$

$$

#strong[#underline[Encryption Input]:]
$M in cal(R)_(chevron.l n\,t chevron.r)$,
$A arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)$,
$E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

$$

+ Scale up
  $M arrow.r Delta M upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Compute
  $B = A dot.op S + Delta M + E upright(" ") med mod med cal(R)_(chevron.l n\,q chevron.r)$

+ $sans("RLWE")_(S\,sigma)\(Delta M + E\)=\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

]
== Decryption
<subsec:rlwe-dec>
+ Given the ciphertext $\(A\,B\)$ where
  $B = A dot.op S + Delta dot.op M + E in cal(R)_(chevron.l n\,q chevron.r)$,
  compute $B - A dot.op S = Delta dot.op M + E$.

+ Round each coefficient of the polynomial
  $Delta dot.op M + E in cal(R)_(chevron.l n\,q chevron.r)$ to the
  nearest multiple of $Delta$ (i.e., round it as a base $Delta$ number),
  which is denoted as $ceil.l Delta dot.op M + E floor.r_Delta$. This
  rounding operation successfully eliminates $E$ and gives
  $Delta dot.op M$. One caveat is that the noise $E$'s each coefficient
  $e_i$ should be small enough to be $\|e_i\|< Delta / 2$ in order to be
  eliminated during the rounding. Otherwise, some of $e_i$'s higher bits
  will overlap and corrupt the plaintext $m_i$ coefficient's lower bits
  and won't be blown away.

+ Compute $frac(Delta dot.op M, Delta)$, which is equivalent to scaling
  down each polynomial coefficient in $Delta dot.op M$ by $Delta$ (or
  right-shifting each coefficient by $upright("log")_2 Delta$ bits if
  $Delta$ is a power of 2).

$$

In summary, the RLWE decryption formula is summarized as follows:

#block[
#strong[#underline[Decryption Input]:]
$sans("ct") =\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

$$

+ $sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= B - A dot.op S = Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Scale down
  $#scale(x: 300%, y: 300%)[ceil.l] frac(Delta M + E, Delta) #scale(x: 300%, y: 300%)[floor.r] med mod med t = M upright(" ") in cal(R)_(chevron.l n\,t chevron.r)$

For correct decryption, every noise coefficient $e_i$ of polynomial $E$
should be: $\|e_i\|< Delta / 2$. And in case $t$ does not divide $q$,
$q$ should be sufficiently larger than $t$.

]
