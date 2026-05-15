In the GLWE cryptosystem, modulus switching is a process of changing a
ciphertext's modulo domain to a smaller (or larger) one, while ensuring
that the ciphertext still decrypts to the same plaintext. For example,
suppose we have the ciphertext
$sans("LWE")_(S\,sigma)\(Delta m\)in bb(Z)_q^(k + 1)$. If we switch the
ciphertext's modulo from $q arrow.r q'$, then the ciphertext is
converted into
$sans("LWE")_(S\,sigma) (Delta q' / q m + e') in bb(Z)_(q')^(k + 1)$.
The ciphertext's all other components such as the noise ($e$) and public
keys ($a_0\,a_1\,dots.h.c\,a_(k - 1)$, $b$) are scaled by $q' / q$,
becoming $⌈e q' / q⌋$,
$(⌈a_0 q' / q⌋ \, ⌈a_1 q' / q⌋ \, dots.h.c \, ⌈a_(k - 1) q' / q⌋ \, ⌈b q' / q⌋)$.
To switch the modulo of an LWE ciphertext, we use the modulo rescaling
technique learned from
#link(<sec:modulus-rescaling>)[\[sec:modulus-rescaling\]]. The same
modulus switching technique can also be applied to RLWE ciphertexts. In
this section, we will show how to switch (i.e., rescale) the modulo of
LWE and RLWE ciphertexts and prove its correctness.

== LWE Modulus Switching
<subsec:modulus-switch-lwe>
#strong[\- Reference:]
#link("https://www.jeremykun.com/2022/07/16/modulus-switching-in-lwe/")[Modulus Switching in LWE]

$$

Recall that the LWE cryptosystem
(#link(<subsec:lwe-enc>)[\[subsec:lwe-enc\]]) comprises the following
components:

- #strong[#underline[Setup]:] $Delta = q / t$,
  $S =\(s_0\,s_1\,dots.h\,s_(k - 1)\)arrow.l^(\$) bb(Z)_2^k$

- #strong[#underline[Encryption Input]:] $m in bb(Z)_t$,
  \$\\vv{a} = (a\_0, a\_1, \\ldots, a\_{k-1}) \\xleftarrow{\\\$} \\mathbb{Z}\_q^{k}\$,
  $e arrow.l^(chi_sigma) bb(Z)_q$

  $$

- #strong[#underline[Encryption]:]
  \$\\textsf{LWE}\_{\\vv{s},\\sigma}(\\Delta  m + e) = (\\vv{a}, b) \\in \\mathbb{Z}\_q^{k + 1}\$
  (where
  \$b = \\vv{a} \\cdot \\vv{s} + \\Delta  m + e \\in \\mathbb{Z}\_q\$)

  $$

- #strong[#underline[Decryption]:]
  \$\\textsf{LWE}^{-1}\_{S,\\sigma}(\\textsf{ct}) = b - \\vv{a}\\cdot \\vv{s} = \\Delta  m + e \\text{ } \\text{ } \\in \\mathbb{Z}\_q\$

$$

In the LWE cryptosystem, modulus switching is a process of converting an
original LWE ciphertext's modulo domain to a smaller modulo domain. This
can be seen as scaling down all components, except for the plaintext $m$
and the secret key $S$, in the original LWE ciphertext to a smaller
domain. This operation preserves the size and integrity of the original
plaintext $m$, while the scaling factor $Delta$ gets reduced to a
smaller value $hat(Delta)$ and the noise $e$ to a smaller (reduced)
noise $hat(e)$ (note that noise alteration does not affect the original
plaintext $m$, because the noise gets rounded away after decryption,
anyway), and \$\\vv{a}\$ also gets scaled down to a smaller
\$\\vv{\\hat{a}}\$. Modulus switching is used for computational
efficiency during TFHE's bootstrapping (which will be discussed in
#link(<subsec:tfhe-noise-bootstrapping>)[\[subsec:tfhe-noise-bootstrapping\]]).
Modulus switching is also used for implementing the
ciphertext-to-ciphertext multiplication algorithm in BGV
(#link(<subsec:bfv-mult-cipher>)[\[subsec:bfv-mult-cipher\]]) and CKKS
(#link(<subsec:ckks-mult-cipher>)[\[subsec:ckks-mult-cipher\]]).

The high-level idea of LWE modulus switch is to rescale the congruence
relationship of the LWE scheme. LWE's homomorphic computation algorithms
include the following: ciphertext-to-ciphertext addition,
ciphertext-to-plaintext addition, ciphertext-to-plaintext
multiplication, ciphertext-to-ciphertext multiplication. However, all
congruence relationships used in these algorithms are essentially
rewritten versions of the following single fundamental congruence
relationship: \$b = \\vv{a}\\cdot \\vv{s} + \\Delta m + e \\bmod q\$.
Thus, modulus switch of an LWE ciphertext from $q arrow.r q'$ is
equivalent to rescaling the modulo of the above congruence relationship
from $q arrow.r q'$.

Based on this insight, the LWE cryptosystem's modulus switching from
$q arrow.r hat(q)$ (where $q > hat(q)$) is a process of converting the
original LWE ciphertext $sans("LWE")_(S\,sigma)\(Delta m + e\)$ as
follows:

#block[
Given an LWE ciphertext \$(\\vv{a}, b)\$ where
\$b = \\vv{a}\\cdot \\vv{s} + \\Delta m + e \\bmod q\$ and
$m in bb(Z)_t$, modulus switch of the ciphertext from $q$ to $hat(q)$ is
equivalent to updating $\(A\,b\)$ to \$(\\vv{\\hat{a}}, \\hat b)\$ as
follows:

\$\\vv{\\hat{a}} = (\\hat{a}\_0, \\hat{a}\_1, \\ldots, \\hat{a}\_{k-1})\$,
where each
$hat(a)_i = #scale(x: 180%, y: 180%)[ceil.l] a hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$
$gt.tri$ $ceil.l floor.r$ means rounding to the nearest integer

$hat(b) = #scale(x: 180%, y: 180%)[ceil.l] b hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$sans("LWE")_(S\,sigma)\(hat(Delta) m + hat(e) + epsilon.alt_(italic("all"))\)=\(hat(a)_0\,hat(a)_1\,dots.h\,hat(b)\)in bb(Z)_(hat(q))^(k + 1)$
$gt.tri$ where $epsilon.alt_(italic("all"))$ is a small rounding error

$$

The above update effectively changes $hat(e)$ and $hat(Delta)$ as
follows:

$hat(e) = #scale(x: 180%, y: 180%)[ceil.l] e hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$,

$hat(Delta) = Delta hat(q) / q$ $gt.tri$ which should be an integer

$$

Meanwhile, $S$ and $m$ stay the same as before.

]
$$

Note that in order for
$\(hat(a)_0\,hat(a)_1\,dots.h\,hat(b)\)in bb(Z)_(hat(q))^(k + 1)$ to be
a valid LWE ciphertext of $hat(Delta) m$, we need to prove that the
following relationship holds:

$hat(b) = sum_(i = 0)^(k - 1) hat(a)_i dot.op s_i + hat(Delta) m + hat(e) in bb(Z)_(hat(q))$

$$

#block[
+ Note the following:

  $hat(b) = #scale(x: 180%, y: 180%)[ceil.l] b hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = b hat(q) / q + epsilon.alt_b$
  (where $- 0.5 < epsilon.alt_b < 0.5$, a rounding drift error)

  $hat(a_i) = #scale(x: 180%, y: 180%)[ceil.l] a_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = a_i hat(q) / q + epsilon.alt_(a_i)$
  (where $- 0.5 < epsilon.alt_(a_i) < 0.5$)

  $hat(e) = #scale(x: 180%, y: 180%)[ceil.l] e hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = e hat(q) / q + epsilon.alt_e$
  (where $- 0.5 < epsilon.alt_e < 0.5$)

+ Note the following:

  \$b = \\vv{a} \\cdot \\vv{s} + \\Delta  m + e = \\sum\\limits\_{i=0}^{k-1}(a\_is\_i) + \\Delta m + e  \\in \\mathbb{Z}\_q\$

  $b = sum_(i = 0)^(k - 1)\(a_i s_i\)+ Delta m + e + H dot.op q$ (where
  modulo $q$ is replaced by adding $H dot.op q$, some multiple of $q$)

+ According to step 1 and 2:

  $hat(b) = b hat(q) / q + epsilon.alt_b in bb(Z)_(hat(q))$

  $= (sum_(i = 0)^(k - 1) \( a_i s_i \) + Delta m + e + H dot.op q) dot.op hat(q) / q + epsilon.alt_b$

  $= hat(q) / q dot.op sum_(i = 0)^(k - 1)\(a_i s_i\)+ hat(q) / q dot.op Delta m + hat(q) / q dot.op e + hat(q) / q dot.op H dot.op q + epsilon.alt_b$

  $= sum_(i = 0)^(k - 1) (hat(q) / q dot.op a_i s_i) + hat(Delta) m +\(hat(e) - epsilon.alt_e\)+ hat(q) dot.op H + epsilon.alt_b$

  $= sum_(i = 0)^(k - 1) (\( hat(a)_i - epsilon.alt_(a_i) \) dot.op s_i) + hat(Delta) m + hat(e) - epsilon.alt_e + hat(q) dot.op H + epsilon.alt_b$

  $= sum_(i = 0)^(k - 1)\(hat(a)_i s_i - epsilon.alt_(a_i) s_i\)+ hat(Delta) m + hat(e) - epsilon.alt_e + epsilon.alt_b in bb(Z)_(hat(q))$

  $= sum_(i = 0)^(k - 1) hat(a)_i s_i + hat(Delta) m + (hat(e) - epsilon.alt_e + epsilon.alt_b - sum_(i = 0)^(k - 1) epsilon.alt_(a_i) s_i) in bb(Z)_(hat(q))$

  $= sum_(i = 0)^(k - 1) hat(a)_i s_i + hat(Delta) m + hat(e) + epsilon.alt_(italic("all")) in bb(Z)_(hat(q))$
  $gt.tri$ where
  $epsilon.alt_(italic("all")) = (- epsilon.alt_e + epsilon.alt_b - sum_(i = 0)^(k - 1) epsilon.alt_(a_i) s_i)$

  $$

  The biggest possible value for $epsilon.alt_(italic("all"))$ is,

  $epsilon.alt_(italic("all")) =\|- 0.5\|+\|0.5\|+\|- 0.5 dot.op k\|= 1 + 0.5 k$

  So, LWE modulus switching results in an approximate congruence
  relationship
  (#link(<sec:modulus-rescaling>)[\[sec:modulus-rescaling\]]). However,
  if $hat(Delta)$ is large enough,
  $epsilon.alt_(italic("all")) = 1 + 0.5 k$ will be shifted to the right
  upon LWE decryption and get eliminated, and finally we can recover the
  original $m$. Also, in practice, the term
  $sum_(i = 0)^(k - 1) epsilon.alt_(a_i) s_i$ would remain small
  relative to the ciphertext modulus for a sufficiently large $k$,
  because each $a_i$ is uniformly sampled and $s_i$ is also uniformly
  sampled.

  If $hat(Delta)$ is not large enough, then
  $epsilon.alt_(italic("all"))$ may not get eliminated during decryption
  and corrupt the plaintext $m$. Also, if $Delta arrow.r hat(Delta)$
  shrinks too much, then the distance between $hat(Delta) m$ and
  $hat(e)$ would become too narrow and the rounding process of
  $hat(e) = #scale(x: 180%, y: 180%)[ceil.l] e hat(q) / q #scale(x: 180%, y: 180%)[floor.r]$
  may end up overlapping the least significant bit of $hat(Delta) m$,
  corrupting the plaintext.

  $$

+ To summarize, $hat(b)$ is approximately as follows:

  $hat(b) = sum_(i = 0)^(k - 1) hat(a)_i s_i + hat(Delta) m + hat(e) + epsilon.alt_(italic("all")) approx sum_(i = 0)^(k - 1) hat(a)_i s_i + hat(Delta) m + hat(e) in bb(Z)_(hat(q))$

  Thus,
  $\(hat(a)_0\,hat(a)_1\,dots.h\,hat(b)\)= sans("LWE")_(S\,sigma)\(hat(Delta) m + hat(e) + epsilon.alt_(italic("all"))\)$,
  decrypting which will give us $m$.

]
== Example
<example>
Suppose we have the following LWE setup:

$$

$t = 4$

$q = 64$

$n = 4$

$Delta = q / t = 16$

$m = 1 in bb(Z)_t$

$S =\(s_0\,s_1\,s_2\,s_3\)=\(0\,1\,1\,0\)in { - 1\,0\,1 }^4$

$A =\(a_0\,a_1\,a_2\,a_3\)=\(- 25\,12\,- 3\,7\)in bb(Z)_q^4$

$e = 1 in bb(Z)_q$

$b = a_0 s_0 + a_1 s_1 + a_2 s_2 + a_3 s_3 + Delta m + e = 26 in bb(Z)_q$

$sans("LWE")_(S\,sigma)\(Delta m + e\)= sans("ct") =\(a_0\,a_1\,a_2\,a_3\,b\)=\(- 25\,12\,- 3\,7\,26\)in bb(Z)_q^(n + 1)$

$$

Now, suppose we want modulus switching from $q = 64$ to $hat(q) = 32$,
which gives:

$hat(Delta) = Delta dot.op 32 / 64 = 8$

$hat(e) = #scale(x: 180%, y: 180%)[ceil.l] 1 dot.op 32 / 64 #scale(x: 180%, y: 180%)[floor.r] = 1$

$sans("LWE")_(S\,sigma)\(hat(Delta) m + hat(e) + epsilon.alt_(italic("all"))\)= hat(sans("ct")) =\(hat(a_0)\,hat(a_1)\,hat(a_2)\,hat(a_3)\,hat(b)\)$

$= (#scale(x: 180%, y: 180%)[ceil.l] - 25 dot.op 32 / 64 #scale(x: 180%, y: 180%)[floor.r] \, #scale(x: 180%, y: 180%)[ceil.l] 12 dot.op 32 / 64 #scale(x: 180%, y: 180%)[floor.r] \, #scale(x: 180%, y: 180%)[ceil.l] - 3 dot.op 32 / 64 #scale(x: 180%, y: 180%)[floor.r] \, #scale(x: 180%, y: 180%)[ceil.l] 7 dot.op 32 / 64 #scale(x: 180%, y: 180%)[floor.r] \, #scale(x: 180%, y: 180%)[ceil.l] 26 dot.op 32 / 64 #scale(x: 180%, y: 180%)[floor.r])$

$=\(- 12\,6\,- 1\,4\,13\)in bb(Z)_(hat(q))^(n + 1)$

$$

Now, verify if the following LWE constraint holds:

$hat(b) = hat(a)_0 s_0 + hat(a)_1 s_1 + hat(a)_2 s_2 + hat(a)_3 s_3 + hat(Delta) m + hat(e) in bb(Z)_32$

$13 = 0 + 6 - 1 + 0 + 8 dot.op 1 + 1 in bb(Z)_32$

$13 approx 14 in bb(Z)_32$

We got this small difference of 1 due to the rounding drift error of:

$hat(a_0) = ceil.l - 12.5 floor.r = - 12$,
$hat(a_2) = ceil.l - 1.5 floor.r = - 1$,
$hat(a_3) = ceil.l 3.5 floor.r = 4$, and
$hat(e) = ceil.l 0.5 floor.r = 1$

$$

If we solve the LWE decryption formula:

$hat(b) -\(hat(a)_0 s_0 + hat(a)_1 s_1 + hat(a)_2 s_2 + hat(a)_3 s_3\)= 13 -\(0\(- 12\)+ 1\(6\)+ 1\(- 1\)+ 0\(4\)\)= 13 -\(6 - 1\)= 8 = hat(m) + hat(e) in bb(Z)_32$

$$

$m = ⌈8 / hat(Delta)⌋ = ⌈8 / 8⌋ = 1$, which is correct.

== Discussion
<subsubsec:modulus-switch-lwe-discuss>
#figure(image("figures/modulus-switching.pdf", width: 70.0%),
  caption: [
    An illustration of scaled plaintext with a noise:
    $Delta dot.op m + e in bb(Z)_q$
  ]
)
<fig:modulus-switch>

After modulus switching of an LWE ciphertext from $q arrow.r hat(q)$,
the underlying plaintext (containing a noise) $Delta m + e$ gets shrunk
to $hat(Delta) m + hat(e)$, as illustrated in
#link(<fig:modulus-switch>)[1]. Note that after the modulus switch from
$q arrow.r hat(q)$, $Delta m$ is down-scaled to $hat(Delta) m$ without
losing its bit data. Notably, the plaintext value $m$ stays the same
after the modulus switch, while its scaling factor $Delta$ gets reduced
to $hat(Delta)$ and the noise $e$ gets reduced to $hat(e)$. However,
after the modulus switch, the distance between $hat(e)$'s MSB and
$hat(Delta) m$'s LSB gets reduced compared to the distance between $e$'s
MSB and $Delta m$'s LSB.

== RLWE Modulus Switching
<subsec:modulus-switch-rlwe>
RLWE modulus switching is similar to LWE modulus switching. Recall that
the RLWE cryptosystem (#link(<subsec:rlwe-enc>)[\[subsec:rlwe-enc\]])
comprises the following components:

- #strong[#underline[Setup]:] $Delta = q / t$,
  $S = s_0 + s_1 X + s_2 X^2 + dots.h.c + s_(n - 1) X^(n - 1) arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)$

  $$

- #strong[#underline[Encryption Input]:]

  $M in cal(R)_(chevron.l n\,t chevron.r)$

  $A = a_0 + a_1 X + a_2 X^2 + dots.h.c + a_(n - 1) X^(n - 1) arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)$

  $E = e_0 + e_1 X + e_2 X^2 + dots.h.c + e_(n - 1) X^(n - 1) arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

  $$

- #strong[#underline[Encryption]:]
  $sans("RLWE")_(S\,sigma)\(Delta dot.op M + E\)=\(A\,B\)in cal(R)_(chevron.l n\,q chevron.r)^2$

  , where
  $B = A dot.op S + Delta dot.op M + E = b_0 + b_1 X + b_2 X^2 + dots.h.c + b_(n - 1) X^(n - 1)$

  $$

- #strong[#underline[Decryption]:]
  $sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= B - A dot.op S = Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

$$

RLWE modulus switching is done as follows:

#block[
For an RLWE ciphertext $\(A\,B\)$ where $B = A S + Delta M + E$ and
$M in cal(R)_(chevron.l n\,q chevron.r)$, modulus switch of the
ciphertext from $q$ to $hat(q)$ is equivalent to updating $\(A\,B\)$ to
$\(hat(A)\,hat(B)\)$ as follows:

$hat(A) = hat(a)_0 + hat(a)_1 X + hat(a)_2 X^2 + dots.h.c + hat(a)_(n - 1) X^(n - 1)$,
where each
$hat(a)_i = #scale(x: 180%, y: 180%)[ceil.l] a_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$hat(B) = hat(b)_0 + hat(b)_1 X + hat(b)_2 X^2 + dots.h.c + hat(b)_(n - 1) X^(n - 1)$,
where each
$hat(b)_i = #scale(x: 180%, y: 180%)[ceil.l] b_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$sans("RLWE")_(S\,sigma)\(hat(Delta) M + hat(E) + E^(chevron.l epsilon.alt_(italic("all")) chevron.r)\)=\(hat(A)\,hat(B)\)in cal(R)_(chevron.l n\,hat(q) chevron.r)^2$

$$

The above update effectively changes $Delta$ and $E$ as follows:

$hat(Delta) = Delta hat(q) / q$ $gt.tri$ which should be an integer

$hat(E) = hat(e)_0 + hat(e)_1 X + hat(e)_2 X^2 + dots.h.c + hat(e)_(n - 1) X^(n - 1)$,
where each
$hat(e)_i = #scale(x: 180%, y: 180%)[ceil.l] e_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$$

Meanwhile, $S$ and $M$ stay the same as before.

]
The proof is similar to that of LWE modulus switching.

$$

#strong[#underline[Proof]]

+ Note the following:

  $hat(b)_i = #scale(x: 180%, y: 180%)[ceil.l] b_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = b_i hat(q) / q + epsilon.alt_(b_i)$
  (where $- 0.5 < epsilon.alt_(b_i) < 0.5$, a rounding drift error)

  $hat(a)_i = #scale(x: 180%, y: 180%)[ceil.l] a_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = a_i hat(q) / q + epsilon.alt_(a_i)$
  (where $- 0.5 < epsilon.alt_(a_i) < 0.5$)

  $hat(e)_i = #scale(x: 180%, y: 180%)[ceil.l] e_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = e_i hat(q) / q + epsilon.alt_(e_i)$
  (where $- 0.5 < epsilon.alt_(e_i) < 0.5$)

+ Note the following:

  $B - A dot.op S$

  $=\(b_0 + b_1 X + dots.h.c + b_(n - 1) X^(n - 1)\)-\(a_0 + a_1 X + dots.h.c + a_(n - 1) X^(n - 1)\)\(s_0 + s_1 X + dots.h.c + s_(n - 1) X^(n - 1)\)$

  $= (b_0 - (sum_(i = 0)^0 \( a_(0 - i) s_i \) - sum_(i = 1)^(n - 1) \( a_(n - i) s_i \)))$

  $+ (b_1 - (sum_(i = 0)^1 \( a_(1 - i) s_i \) - sum_(i = 2)^(n - 1) \( a_(n + 1 - i) s_i \))) dot.op X$

  $+ (b_2 - (sum_(i = 0)^2 \( a_(2 - i) s_i \) - sum_(i = 3)^(n - 1) \( a_(n + 2 - i) s_i \))) dot.op X^2$

  $dots.v$

  $+ (b_(n - 1) - (sum_(i = 0)^(n - 1) \( a_(n - 1 - i) s_i \) - sum_(i = n)^(n - 1) \( a_(n + n - 1 - i) s_i \))) dot.op X^(n - 1)$
  $gt.tri$ Grouping the terms by same exponents

  $$

  $= sum_(h = 0)^(n - 1) (b_h - (sum_(i = 0)^h \( a_(h - i) s_i \) - sum_(i = h + 1)^(n - 1) \( a_(n + h - i) s_i \))) dot.op X^h$

  $$

  Thus,

  $$

  $B = sum_(h = 0)^(n - 1) b_h X^h$

  $A dot.op S = sum_(h = 0)^(n - 1) (sum_(i = 0)^h \( a_(h - i) s_i \) - sum_(i = h + 1)^(n - 1) \( a_(n + h - i) s_i \)) dot.op X^h$

  $$

+ Based on step 2,

  $B = A dot.op S + Delta M + E$

  $sum_(h = 0)^(n - 1) b_h X^h = sum_(h = 0)^(n - 1) (sum_(i = 0)^h \( a_(h - i) s_i \) - sum_(i = h + 1)^(n - 1) \( a_(n + h - i) s_i \)) dot.op X^h + Delta sum_(h = 0)^(n - 1) m_h X^h + sum_(h = 0)^(n - 1) e_h X^h in bb(Z)_q$

  $sum_(h = 0)^(n - 1) b_h X^h = sum_(h = 0)^(n - 1) (sum_(i = 0)^h \( a_(h - i) s_i \) - sum_(i = h + 1)^(n - 1) \( a_(n + h - i) s_i \)) dot.op X^h + Delta sum_(h = 0)^(n - 1) m_h X^h + sum_(h = 0)^(n - 1) e_h X^h + H dot.op q$

  \(where modulo $q$ is replaced by adding $H dot.op q$, an
  $\(n - 1\)$-degree polynomial whose each coefficient $c_i$ is some
  multiple of $q$)

  $$

+ According to step 1 and 3, for each $j$ in $0 lt.eq j lt.eq n - 1$:

  $hat(b)_j = b_j hat(q) / q + epsilon.alt_(b_j) in bb(Z)_(hat(q))$

  $= (sum_(i = 0)^j \( a_(j - i) s_i \) - sum_(i = j + 1)^(n - 1) \( a_(n + j - i) s_i \) + Delta m_j + e_j + c_j dot.op q) dot.op hat(q) / q + epsilon.alt_(b_j)$

  $= hat(q) / q sum_(i = 0)^j\(a_(j - i) s_i\)- hat(q) / q sum_(i = j + 1)^(n - 1)\(a_(n + j - i) s_i\)+ hat(q) / q dot.op Delta m_j + hat(q) / q e_j + hat(q) / q dot.op c_j dot.op q + epsilon.alt_(b_j)$

  $= sum_(i = 0)^j (hat(q) / q dot.op a_(j - i) s_i) - sum_(i = j + 1)^(n - 1) (hat(q) / q dot.op a_(n + j - i) s_i) + hat(Delta) m_j +\(hat(e)_j - epsilon.alt_(e_j)\)+ hat(q) dot.op c_j + epsilon.alt_(b_j)$

  $= sum_(i = 0)^j\(\(hat(a)_(j - i) - epsilon.alt_(a_(j - i))\)dot.op s_i\)- sum_(i = j + 1)^(n - 1)\(\(hat(a)_(n + j - i) - epsilon.alt_(a_(n + j - i))\)dot.op s_i\)+ hat(Delta) m_j +\(hat(e)_j - epsilon.alt_(e_j)\)+ hat(q) dot.op c_j + epsilon.alt_(b_j)$

  $= sum_(i = 0)^j\(hat(a)_(j - i) s_i\)- sum_(i = j + 1)^(n - 1)\(hat(a)_(n + j - i) s_i\)- sum_(i = 0)^j\(epsilon.alt_(a_(j - i)) s_i\)+ sum_(i = j + 1)^(n - 1)\(epsilon.alt_(a_(n + j - i)) s_i\)+ hat(Delta) m_j +\(hat(e)_j - epsilon.alt_(e_j)\)+ hat(q) dot.op c_j + epsilon.alt_(b_j)$

  $= (sum_(i = 0)^j \( hat(a)_(j - i) s_i \) - sum_(i = j + 1)^(n - 1) \( hat(a)_(n + j - i) s_i \)) + hat(Delta) m_j + hat(e)_j + (epsilon.alt_(b_j) - epsilon.alt_(e_j) - sum_(i = 0)^j \( epsilon.alt_(a_(j - i)) s_i \) + sum_(i = j + 1)^(n - 1) \( epsilon.alt_(a_(n + j - i)) s_i \)) + hat(q) dot.op c_j$

  $= (sum_(i = 0)^j \( hat(a)_(j - i) s_i \) - sum_(i = j + 1)^(n - 1) \( hat(a)_(n + j - i) s_i \)) + hat(Delta) m_j + hat(e)_j + epsilon.alt_(italic("all")) in bb(Z)_(hat(q))$

  $gt.tri$ where
  $epsilon.alt_(italic("all")) = epsilon.alt_(b_j) - epsilon.alt_(e_j) - sum_(i = 0)^j\(epsilon.alt_(a_(j - i)) s_i\)+ sum_(i = j + 1)^(n - 1)\(epsilon.alt_(a_(n + j - i)) s_i\)approx 0$

  $$

+ To summarize, for each $0 lt.eq j lt.eq n - 1$, each polynomial degree
  coefficient $hat(b_j)$ is approximately as follows:

  $hat(b)_j = (sum_(i = 0)^j \( hat(a)_(j - i) s_i \) - sum_(i = j + 1)^(n - 1) \( hat(a)_(n + j - i) s_i \)) + hat(Delta) m_j + hat(e)_j + epsilon.alt_(italic("all"))$

  $approx (sum_(i = 0)^j \( hat(a)_(j - i) s_i \) - sum_(i = j + 1)^(n - 1) \( hat(a)_(n + j - i) s_i \)) + hat(Delta) m_j + hat(e)_j$

  Thus,
  $\(hat(A)\,hat(B)\)= sans("RLWE")_(S\,sigma)\(hat(Delta) M + hat(E) + E^(chevron.l epsilon.alt_(italic("all")) chevron.r)\)$,
  decrypting which will give us $M$.

  #block[
  ]

== GLWE Modulus Switching
<subsec:modulus-switch-glwe>
GLWE modulus switching is an extension of RLWE modulus switching. The
only difference is that while RLWE's $A$ and $S$ are a single polynomial
each, GLWE's $A$ and $S$ are a list of $k$ polynomials each. Thus, the
same modulus switching technique as RLWE can be applied to GLWE for its
$k$ polynomials.

Recall that the GLWE cryptosystem
(#link(<subsec:glwe-enc>)[\[subsec:glwe-enc\]]) is comprised of the
following components:

- #strong[#underline[Initial Setup]:] $Delta = q / t$,
  ${ S_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)^k$

  $$

- #strong[#underline[Encryption Input]:]
  $M in cal(R)_(chevron.l n\,t chevron.r)$,
  ${ A_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$,
  $E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

  $$

- #strong[#underline[Encryption]:]
  $sans("GLWE")_(S\,sigma)\(Delta M + E\)=\({ A_i }_(i = 0)^(k - 1)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

  , where
  $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

  $$

- #strong[#underline[Decryption]:]
  $sans("GLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= B - sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)= Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

$$

GLWE modulus switching is done as follows:

#block[
Given a GLWE ciphertext $\({ A_i }_(i = 0)^(k - 1)\,B\)$ where
\$B = \\vv A\\cdot \\vv S + \\Delta M + E \\bmod q\$ and
$M in cal(R)_(chevron.l n\,q chevron.r)$, the modulus switch of the
ciphertext from $q$ to $hat(q)$ is equivalent to updating
$\({ A }_(i = 0)^(k - 1)\,B\)$ to
$\({ hat(A)_i }_(i = 0)^(k - 1)\,hat(B)\)$ as follows:

$hat(A_i) = hat(a)_(i\,0) + hat(a)_(i\,1) X + hat(a)_(i\,2) X^2 + dots.h.c + hat(a)_(i\,n - 1) X^(n - 1)$,
where each
$hat(a)_(i\,j) = #scale(x: 180%, y: 180%)[ceil.l] a_(i\,j) hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$hat(B) = hat(b)_0 + hat(b)_1 X + hat(b)_2 X^2 + dots.h.c + hat(b)_(n - 1) X^(n - 1)$,
where each
$hat(b)_j = #scale(x: 180%, y: 180%)[ceil.l] b_j hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$sans("GLWE")_(S\,sigma)\(hat(Delta) M + hat(E) + E^(chevron.l epsilon.alt_(italic("all")) chevron.r)\)=\({ hat(A)_i }_(i = 0)^(k - 1)\,hat(B)\)in cal(R)_(chevron.l n\,hat(q) chevron.r)^(k + 1)$

$$

The above update effectively changes $E$ and $Delta$ as follows:

$hat(E) = hat(e)_0 + hat(e)_1 X + hat(e)_2 X^2 + dots.h.c + hat(e)_(n - 1) X^(n - 1)$,
where each
$hat(e)_j = #scale(x: 180%, y: 180%)[ceil.l] e_j hat(q) / q #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$hat(Delta) = Delta hat(q) / q$ $gt.tri$ which should be an integer

$$

Meanwhile, \$\\vv{S}\$ and $M$ stay the same as before.

]
The proof is similar to that of RLWE modulus switching. The
modulus-switched GLWE ciphertext's culminating rounding drift error for
each $j$-th polynomial coefficient in its congruence relationship (i.e.,
$B = sum_(i = 0)^(k - 1) A_i dot.op S_i + Delta M + E$) is as follows:

$epsilon.alt_(j\,a l l) = epsilon.alt_(b_j) - epsilon.alt_(e_j) - sum_(l = 0)^(k - 1) sum_(i = 0)^j\(epsilon.alt_(a_(l\,j - i)) dot.op s_(l\,i)\)+ sum_(l = 0)^(k - 1) sum_(i = j + 1)^(n - 1)\(epsilon.alt_(a_(l\,n + j - i)) dot.op s_(l\,i)\)$

$gt.tri$ derived from the proof step 4 of
Summary~@subsec:modulus-switch-rlwe:
$epsilon.alt_(italic("all")) = epsilon.alt_(b_j) - epsilon.alt_(e_j) - sum_(i = 0)^j\(epsilon.alt_(a_(j - i)) s_i\)+ sum_(i = j + 1)^(n - 1)\(epsilon.alt_(a_(n + j - i)) s_i\)$

$$

Note that GLWE's modulus switching can have a bigger rounding drift
error (about $k$ times) than that of RLWE's modulus switching. However,
in the long run, the error remains relatively small to the ciphertext
modulus, because the rounding errors are independent and uniform and
their sum grows slowly (central limit theorem) relative to the modulus.
