#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-1")[TFHE Deep Dive: Part I - Ciphertext types]~@tfhe-1

$$

== Setup
<setup>
Let $\[0\,t - 1\)$ be the plaintext range, and $\[0\,q - 1\)$ the
ciphertext range, where $t < q$ ($t$ is much smaller than $q$). Randomly
pick a vector $arrow(s)$ of length $k$ comprising $k$ ternary numbers
sampled from ${ - 1\,0\,1 }$ as a secret key (denoted as
$arrow(s) arrow.l^(\$) { - 1\,0\,1 }^k$). Let $Delta = q / t$, the
scaling factor of plaintext.

== Encryption
<subsec:lwe-enc>
+ Suppose we have a plaintext $m in bb(Z)_t$ to encrypt.

+ Randomly pick a vector $arrow(a) in bb(Z)_q^k$ (of length $k$) as a
  one-time random public mask (denoted as
  $arrow(a) arrow.l^(\$) bb(Z)_q^k$).

+ Randomly pick a small one-time noise $e in bb(Z)_q$ sampled from the
  Gaussian distribution $chi_sigma$ (denoted as
  $e arrow.l^(chi_sigma) bb(Z)_q$).

+ Scale $m$ by $Delta$, which is to compute $Delta dot.op m$. This
  converts $m in bb(Z)_t$ into $Delta dot.op m in bb(Z)_q$.

+ Compute
  $b = arrow(a) dot.op arrow(s) + Delta dot.op m + e in bb(Z)_q$.

$$

The LWE encryption formula is summarized as follows:

$$

#block[
#strong[#underline[Initial Setup]:] $Delta = q / t$,
$arrow(s) arrow.l^(\$) { - 1\,0\,1 }^k$, where $t$ divides $q$

$$

$$

#strong[#underline[Encryption Input]:] $m in bb(Z)_t$,
$arrow(a) arrow.l^(\$) bb(Z)_q^k$, $e arrow.l^(chi_sigma) bb(Z)_q$

$$

+ Scale up $m arrow.r Delta dot.op m upright(" ") in bb(Z)_q$

+ Compute $b = arrow(a) dot.op arrow(s) + Delta m + e med\(mod med q\)$

+ $sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)=\(arrow(a)\,b\)upright(" ") in bb(Z)_q^(k + 1)$

]
== Decryption
<subsec:lwe-dec>
+ Given the ciphertext $\(arrow(a)\,b\)$ where
  $b = arrow(a) dot.op arrow(s) + Delta dot.op m + e in bb(Z)_q$,
  compute $b - arrow(a) dot.op arrow(s)$, which gives the same value as
  $Delta dot.op m + e in bb(Z)_q$.

+ Round $Delta dot.op m + e in bb(Z)_q$ to the nearest multiple of
  $Delta$ (i.e., round it as a base $Delta$ number), which is denoted as
  $ceil.l Delta dot.op m + e floor.r_Delta$. This rounding operation
  successfully eliminates $e$ and gives $Delta m$, provided $e$ is small
  enough to be $e < Delta / 2$. If $e gt.eq Delta / 2$, then some of the
  higher bits of the noise $e$ will overlap with the plaintext $m$,
  won't be blown away, and will corrupt some lower bits of the plaintext
  $m$.

+ Compute $frac(Delta m, Delta)$, which is equivalent to right-shifting
  $ceil.l Delta dot.op m + e floor.r_Delta$ by $upright("log")_2 Delta$
  bits. (Here we assume $Delta$ is a power of 2; if $Delta$ is not a
  power of 2, scaling up or down $m$ by $Delta$ is equivalent to
  multiplying or dividing the value by $Delta$\.)

$$

The LWE decryption formula is summarized as follows:

$$

#block[
#strong[#underline[Decryption Input]:]
$sans("ct") =\(arrow(a)\,b\)upright(" ") in bb(Z)_q^(k + 1)$

$$

+ $sans("LWE")_(S\,sigma)^(- 1)\(sans("ct")\)= b - arrow(a) dot.op arrow(s) = Delta m + e med\(mod med q\)$

+ Scale down
  $#scale(x: 300%, y: 300%)[ceil.l] frac(Delta m + e, Delta) #scale(x: 300%, y: 300%)[floor.r] med mod med t = m upright(" ") in bb(Z)_t$

For correct decryption, the noise $e$ should be $e < Delta / 2$.

]
During decryption, the secret key owner can subtract
$arrow(a) dot.op arrow(s)$ from $b$ because he can directly compute
$arrow(a) dot.op arrow(s)$ by using his secret key $arrow(s)$.

The reason we scaled the plaintext $m$ by $Delta$ is: (i) to left-shift
$m$ by $upright("log")_2 Delta$ bits and separate it from the noise $e$
in the lower bits during encryption, whereas $e$ is essential to make it
hard for the attacker to guess $m$ or $arrow(s)$\; and (ii) to eliminate
$e$ in the lower bits by right-shifting it by $upright("log")_2 Delta$
bits without compromising $m$ in the higher bits during decryption. The
process of right-shifting (i.e., scaling) the plaintext $m$ by
$upright("log")_2 Delta$ bits, followed by adding the noise $e$, is
illustrated in #link(<fig:scaling>)[\[fig:scaling\]].

=== In the Case of $t$ not Dividing $q$
<subsubsec:lwe-noise-bound>
In Summary~@subsec:lwe-enc (#link(<subsec:lwe-enc>)[0.2]), we assumed
that $t$ divides $q$. In this case, there is no upper or lower limit on
the size of plaintext $m$: its value is allowed to wrap around modulo
$t$ indefinitely, yet the decryption works correctly. This is because
any $m$ value greater than $t$ will be correctly modulo-reduced by $t$
when we perform modulo reduction by $q$ during decryption.

On the other hand, suppose that $t$ does not divide $q$. In such a case,
we set the scaling factor as $Delta = ⌊q / t⌋$. Then, provided
$q gt.double t$, the decryption works correctly even if $m$ is a large
value that wraps around $t$. We will show why this is so.

In this subsection's analysis, we choose $t$ to be an odd (prime)
number, which is the general FHE practice for computational efficiency
reasons (see
#link(<subsubsec:poly-vector-transformation-modulus>)[\[subsubsec:poly-vector-transformation-modulus\]]).
We assume the use of the centered residue system, where the plaintext
domain is $[- frac(t - 1, 2) \, frac(t - 1, 2)]$ and the ciphertext
domain is $[- q / 2 \, q / 2 - 1]$. We denote plaintext
$m med mod med t$ as $m = m' + v t$, where $m' in bb(Z)_t$, and $v$ is
an integer that represents the $t$-overflow portions of $m$. We set the
plaintext scaling factor as $Delta = ⌊q / t⌋$. Then, the noise-added and
$Delta$-scaled plaintext can be expressed as follows:

$⌊q / t⌋ dot.op m + e$

$= ⌊q / t⌋ dot.op m' + ⌊q / t⌋ dot.op v t + e$ $gt.tri$ applying
$m = m' + v t$

$= ⌊q / t⌋ dot.op m' + q / t dot.op v t - (q / t - ⌊q / t⌋) dot.op v t + e$

$= ⌊q / t⌋ dot.op m' + q v - (q / t - ⌊q / t⌋) dot.op v t + e$

$= ⌊q / t⌋ dot.op m' + q v - epsilon.alt dot.op v t + e$ $gt.tri$ where
$epsilon.alt = q / t - ⌊q / t⌋$, a fractional value between $\[0\,1\)$

$$

Remember that the LWE decryption relation:
$frac(b - arrow(a) dot.op arrow(s) med mod med q, Delta) med mod med t = frac(Delta m + e med mod med q, Delta) med mod med t$.
Therefore, from the above expression, we can decrypt the message by
computing as follows:

$⌈1 / Delta dot.op (b - arrow(a) dot.op arrow(s) med mod med q)⌋ med mod med t$

$= ⌈1 / Delta dot.op (Delta m + e med mod med q)⌋ med mod med t$

$= ⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op \( m' + v t \) + e med mod med q)⌋ med mod med t$

$= ⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op m' + ⌊q / t⌋ dot.op v t + e med mod med q)⌋ med mod med t$

$= ⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op m' + (q / t - epsilon.alt) dot.op v t + e med mod med q)⌋ med mod med t$

$= ⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op m' + v q - epsilon.alt v t + e med mod med q)⌋ med mod med t$

$= ⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op m' - epsilon.alt v t + e med mod med q)⌋ med mod med t$

$$

In order for the decryption to work, we ideally want to eliminate the
inner modulo $q$ reduction. That is, assuming the centered residue
system $[- q / 2 \, q / 2 - 1]$, we want
$- q / 2 lt.eq ⌊q / t⌋ dot.op m' - epsilon.alt v t + e < q / 2$, or more
strictly, $lr(|⌊q / t⌋ dot.op m' - epsilon.alt v t + e|) < q / 2$.

$$

To ensure these conditions hold, we will make a special assumption:
$\|- epsilon.alt v t + e\|< Delta / 2$. Applying this assumption to the
expression above, we can derive the following relation:

$lr(|⌊q / t⌋ dot.op m' - epsilon.alt v t + e|)$

$lt.eq lr(|⌊q / t⌋ dot.op m'|) + lr(|- epsilon.alt v t + e|)$

$lt.eq lr(|⌊q / t⌋ dot.op frac(t - 1, 2)|) + lr(|- epsilon.alt v t + e|)$
$gt.tri$ we assume $t$ is an odd prime, as that's the general FHE
practice

$lt.eq lr(|q / t dot.op frac(t - 1, 2)|) + lr(|- epsilon.alt v t + e|)$

$= q / 2 - frac(q, 2 t) + lr(|- epsilon.alt v t + e|)$

$< q / 2 - frac(q, 2 t) + Delta / 2$ $gt.tri$ applying our special
assumption $\|- epsilon.alt v t + e\|< Delta / 2$

$= q / 2 + 1 / 2 dot.op (Delta - q / t)$

$< q / 2$ $gt.tri$ since $Delta < q / t$

$$

Therefore, if we assume $\|- epsilon.alt v t + e\|< Delta / 2$, then
$⌊q / t⌋ dot.op m' - epsilon.alt v t + e med mod med q$ can be
simplified to $⌊q / t⌋ dot.op m' - epsilon.alt v t + e$. We continue
with the following derivation:

$⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op m' - epsilon.alt v t + e med mod med q)⌋ med mod med t$

$= ⌈1 / ⌊q / t⌋ dot.op (⌊q / t⌋ dot.op m' - epsilon.alt v t + e)⌋ med mod med t$

$= ⌈m' + frac(- epsilon.alt v t + e, floor.l q / t floor.r)⌋ med mod med t$

$= m' + ⌈frac(- epsilon.alt v t + e, floor.l q / t floor.r)⌋ med mod med t$
$gt.tri$ since $ceil.l m' floor.r = m'$

$= m' med mod med t$ $gt.tri$ applying special assumption
$\|- epsilon.alt v t + e\|< Delta / 2 = frac(floor.l q / t floor.r, 2)$

To summarize, if we set the plaintext's scaling factor as
$Delta = ⌊q / t⌋$ and $t$ is an odd (prime) number, the decryption works
correctly as long as the following error-bounding condition holds:
$\|- epsilon.alt v t + e\|< Delta / 2 = frac(floor.l q / t floor.r, 2)$.
This condition (i.e., decryption) breaks if: (1) the noise $e$ is too
large relative to $q$\; (2) the plaintext modulus $t$ is too large
relative to $q$\; or (3) the plaintext value wraps around $t$ too many
times (i.e., $v$ is too large). A general solution to ensure all these
error bound conditions is to set the ciphertext modulus $q$ to be
sufficiently large. To put it differently, if $q gt.double t$ and
$q gt.double e$, then the error bound holds.

We can generalize the formula for the plaintext's scaling factor in
Summary~@subsec:lwe-enc (in #link(<subsec:lwe-enc>)[0.2]) as $⌊q / t⌋$,
where $t$ is an odd (prime) number.

#block[
Given the plaintext's scaling factor $Delta = ⌊q / t⌋$ and $t$ is an odd
(prime) number, the LWE decryption works correctly as long as the
error-bounding condition holds:

$\|- epsilon.alt v t + e\|< Delta / 2$

$$

, where $epsilon.alt = q / t - ⌊q / t⌋$ is a fractional value between
$\[0\,1\)$, and $v$ accounts for the $t$-overflows of the plaintext $m$.

]
