The TFHE scheme is designed for homomorphic addition and multiplication
on integers (especially bit-wise computation, like logic circuits).
Unlike BFV, GBV, or CKKS, TFHE is characterized by fast noise
bootstrapping; therefore, it is efficient for processing deep
multiplication depths. TFHE's noise bootstrapping technique can be
further applied to functional encryption.

In TFHE, each plaintext is encrypted as an LWE ciphertext. Therefore,
TFHE's ciphertext-to-ciphertext addition, ciphertext-to-plaintext
addition, and ciphertext-to-plaintext multiplication are implemented
based on GLWE's homomorphic addition and multiplication described in
\$\\autoref{part:generic-fhe}\$, with $n = 1$ to make GLWE an LWE.

This section will explain TFHE's novel components: key switching,
ciphertext-to-ciphertext multiplication, coefficient extraction, and
noise bootstrapping.

$$

#block[
- #link(<sec:modulo>)[\[sec:modulo\]]:

- #link(<sec:group>)[\[sec:group\]]:

- #link(<sec:field>)[\[sec:field\]]:

- #link(<sec:order>)[\[sec:order\]]:

- #link(<sec:polynomial-ring>)[\[sec:polynomial-ring\]]:

- #link(<sec:decomp>)[\[sec:decomp\]]:

- #link(<sec:modulus-rescaling>)[\[sec:modulus-rescaling\]]:

- #link(<sec:lattice>)[\[sec:lattice\]]:

- #link(<sec:lwe>)[\[sec:lwe\]]:

- #link(<sec:rlwe>)[\[sec:rlwe\]]:

- #link(<sec:glwe>)[\[sec:glwe\]]:

- #link(<sec:glev>)[\[sec:glev\]]:

- #link(<sec:ggsw>)[\[sec:ggsw\]]:

- #link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]:

- #link(<sec:glwe-add-plain>)[\[sec:glwe-add-plain\]]:

- #link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]:

- #link(<subsec:modulus-switch-lwe>)[\[subsec:modulus-switch-lwe\]]:

- #link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]:

]
== Encryption and Decryption
<subsec:tfhe-enc-dec>
TFHE encrypts and decrypts ciphertexts based on the LWE cryptosystem
(#link(<sec:lwe>)[\[sec:lwe\]]), which is equivalent to the GLWE
cryptosystem (#link(<sec:glwe>)[\[sec:glwe\]]) with $n = 1$. However,
one distinction from the LWE cryptosystem is that TFHE samples the
secret key elements from the binary set ${ 0\,1 }$, not from the ternary
set ${ - 1\,0\,1 }$.

#block[
#strong[#underline[Initial Setup]:] $Delta = q / t$,
$arrow(s) arrow.l^(\$) bb(Z)_2^k$ $gt.tri$ where $t$ divides $q$, and
each element of $arrow(s)$ is a 0-degree polynomial

$$

#horizontalrule

#strong[#underline[Encryption Input]:] $m in bb(Z)_t$,
$arrow(a) arrow.l^(\$) bb(Z)_q^k$, $e arrow.l^(chi_sigma) bb(Z)_q$
$gt.tri$ each element of $arrow(a)$ is a 0-degree polynomial

+ Scale up $m arrow.r Delta dot.op m upright(" ") in bb(Z)_q$

+ Compute
  $b = arrow(a) dot.op arrow(s) + Delta m + e upright(" ") med mod med q$

+ $sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)=\(arrow(a)\,b\)upright(" ") in bb(Z)_q^(k + 1)$

#horizontalrule

#strong[#underline[Decryption Input]:]
$sans("ct") =\(arrow(a)\,b\)upright(" ") in bb(Z)_q^(k + 1)$

+ $sans("LWE")_(arrow(s)\,sigma)^(- 1)\(sans("ct")\)= b - arrow(a) dot.op arrow(s) = Delta m + e med\(mod med q\)$

+ Scale down
  $#scale(x: 300%, y: 300%)[ceil.l] frac(Delta m + e, Delta) #scale(x: 300%, y: 300%)[floor.r] = m upright(" ") in bb(Z)_t$
  $gt.tri$ i.e., modulus switch from $q arrow.r t$

$$

#strong[Condition for Correct Decryption:]

- The noise $e$ grown over homomorphic operations should be:
  $e < Delta / 2$.

]
In this section, we will often write
$sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)$ as
$sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$ for simplicity, because
$sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)approx sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$
(i.e., they decrypt to the same message). Even in the case that we write
$sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$ instead of
$sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)$, you should assume this
as an encryption of $Delta m + e$ (i.e., the noise is included inside
the scaled message).

== Homomorphic Ciphertext-to-Ciphertext Addition
<subsec:tfhe-add-cipher>
TFHE's ciphertext-to-ciphertext addition uses LWE's
ciphertext-to-ciphertext addition scheme, which is equivalent to GLWE's
ciphertext-to-ciphertext addition scheme
(#link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]) with $n = 1$.

#block[
$sans("LWE")_(arrow(s)\,sigma)\(Delta m^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r)\)+ sans("LWE")_(arrow(s)\,sigma)\(Delta m^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r)\)$

$=\(arrow(a)^(chevron.l 1 chevron.r)\,upright(" ") b^(chevron.l 1 chevron.r)\)+\(arrow(a)^(chevron.l 2 chevron.r)\,upright(" ") b^(chevron.l 2 chevron.r)\)$

$=\(arrow(a)^(chevron.l 1 chevron.r) + arrow(a)^(chevron.l 2 chevron.r)\,upright(" ") b^(chevron.l 1 chevron.r) + b^(chevron.l 2 chevron.r)\)$

$= sans("LWE")_(arrow(s)\,sigma)\(Delta\(m^(chevron.l 1 chevron.r) + m^(chevron.l 2 chevron.r)\)+ e^(chevron.l 1 + 2 chevron.r)\)$
<Here>

]
== Homomorphic Ciphertext-to-Plaintext Addition
<subsec:tfhe-add-plain>
TFHE's ciphertext-to-plaintext addition (where $lambda$ is a constant to
add) uses LWE's ciphertext-to-plaintext addition scheme, which is
equivalent to GLWE's ciphertext-to-plaintext addition scheme
(#link(<sec:glwe-add-plain>)[\[sec:glwe-add-plain\]]) with $n = 1$.

#block[
$sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)+ Delta lambda$

$=\(arrow(a)\,upright(" ") b\)+ Delta lambda$

$=\(arrow(a)\,upright(" ") b + Delta lambda\)$

$= sans("LWE")_(arrow(s)\,sigma)\(Delta\(m + lambda\)+ e\)$

]
== Homomorphic Ciphertext-to-Plaintext Multiplication
<subsec:tfhe-mult-plain>
TFHE's ciphertext-to-plaintext multiplication uses LWE's
ciphertext-to-plaintext multiplication scheme, which is equivalent to
GLWE's ciphertext-to-plaintext multiplication scheme
(#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]) with $n = 1$.

#block[
$sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)dot.op lambda$

$=\(arrow(a)\,upright(" ") b\)dot.op lambda$

$=\(lambda dot.op arrow(a)\,upright(" ") lambda dot.op b\)$

$= sans("LWE")_(arrow(s)\,sigma)\(Delta\(m dot.op lambda\)+ lambda dot.op e\)$

]
== Homomorphic Key Switching
<subsec:tfhe-key-switching>
#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-3")[TFHE Deep Dive - Part III - Key switching and leveled multiplications]~@tfhe-3

TFHE's key switching scheme changes an LWE ciphertext's secret key from
$arrow(s)$ to $arrow(s)_(')$, where the two key vectors may or may not
have the same dimensions. This scheme is essentially LWE's key switching
scheme. Specifically, this is equivalent to the alternative GLWE
version's
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]]) key
switching scheme
(#link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]) with
$n = 1$ as follows:

#block[
Given $sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)=\(arrow(a)\,b\)$,

$sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m + e'\)=\(0\,b\)- bold(chevron.l) sans("Decomp")^(beta\,l)\(arrow(a)\)\,upright(" ") sans("Lev")_(arrow(s)_(')\,sigma)^(beta\,l)\(arrow(s)\)bold(chevron.r)$

]
== Homomorphic Ciphertext-to-Ciphertext Multiplication
<subsec:tfhe-mult-cipher>
#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-3")[TFHE Deep Dive - Part III - Key switching and leveled multiplications]~@tfhe-3

$$

TFHE supports multiplication of two ciphertexts in the form:
$sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)dot.op sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$.

$$

The 1st term $sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 + e_1\)$ comes
from one of the following:

- A fresh LWE encryption (#link(<subsec:glwe-enc>)[\[subsec:glwe-enc\]])
  of plaintext $m_1$.

- A homomorphically added result of two LWE ciphertexts
  (#link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]).

- A homomorphically multiplied result of a LWE ciphertext with a
  plaintext (#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]).

$$

The 2nd term $sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$ comes from
one of the following:

- A fresh GSW encryption (#link(<subsec:ggsw-enc>)[\[subsec:ggsw-enc\]])
  of plaintext $m_2$.

- Converted from $sans("LWE")_(arrow(s)\,sigma)\(Delta m_2 + e_2\)$ into
  $sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$ by #emph[circuit
  bootstrapping] (this will be covered in the future).

$$

Remember the following:

$sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 + e_1\)=\(arrow(a)\,b\)in bb(Z)_q^(k + 1)$,
where $b = arrow(a) dot.op arrow(s) + Delta m_1 + e_1$

$$

$sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)= #scale(x: 180%, y: 180%)[{] { sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_i dot.op m_2\)}_(i = 0)^(k - 1)\,sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)#scale(x: 180%, y: 180%)[}] in bb(Z)_q^(\(k + 1\)dot.op l dot.op\(k' + 1\))$
$gt.tri$ from #link(<subsec:ggsw-enc>)[\[subsec:ggsw-enc\]]

$$

Let's use the following notations:

\$\\textsf{GSW}\_{\\vec{s}, \\sigma}^{\\beta, l}(m\_2) = {\\bar{\\textsf{ct}}} = (\\bar{\\textsf{ct}}\_0,. \\bar{\\textsf{ct}}\_1, \\gap{\$\\cdots\$} \\bar{\\textsf{ct}}\_k)\$

$macron(sans("ct"))_i = sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_i dot.op m_2\)$
for $0 lt.eq i lt.eq\(k - 1\)$

$macron(sans("ct"))_k = sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$

\$\\textsf{ct} = \\textsf{LWE}\_{\\vec{s}, \\sigma}(\\Delta m\_1 + e\_1) = (\\vec{a}, b) = (a\_0, a\_1, \\gap{\$\\cdots\$}, a\_{k-1}, b) = (\\textsf{ct}\_0, \\textsf{ct}\_1, \\cdots, \\textsf{ct}\_k)\$

$$

Let's define the following TFHE ciphertext multiplication operation:

$sans("ct") dot.op macron(sans("ct")) = sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(sans("ct")_i\)\,macron(sans("ct"))_i chevron.r$

$$

Then, the following is true:

#block[
$sans("ct") = sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 + e_1\)=\(a_0\,a_1\,dots.h.c\,a_(k - 1)\,b\)$

$macron(sans("ct")) = sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)= bold(\() sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_0 dot.op m_2\)\,sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_1 dot.op m_2\)\,dots.h.c\,sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_(k - 1) dot.op m_2\)\,sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)bold(\))$

$sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 + e_1\)dot.op sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$

$= sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(sans("ct")_i\)\,macron(sans("ct"))_i chevron.r$

$approx sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 m_2\)$

]
This means that multiplying two TFHE ciphertexts (one is in LWE and
another in GSW) and decrypting the resulting LWE ciphertext gives the
same result as multiplying their two original plaintexts.

#block[
+ $sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(sans("ct")_i\)\,macron(sans("ct"))_i chevron.r$
  \
  \$= \\langle \\textsf{Decomp}^{\\beta, l}(a\_0), \\bar{\\textsf{ct}}\_0 \\rangle + \\langle \\textsf{Decomp}^{\\beta, l}(a\_1), \\bar{\\textsf{ct}}\_1 \\rangle + \\gap{\$\\cdots\$} + \\langle \\textsf{Decomp}^{\\beta, l}(a\_{k-1}), \\bar{\\textsf{ct}}\_{k-1} \\rangle + \\langle \\textsf{Decomp}^{\\beta, l}(b), \\bar{\\textsf{ct}}\_k \\rangle\$
  \ $gt.tri$ expanding the dot product of two vectors

+ For $i = k$: \
  $sans("Decomp")^(beta\,l)\(b\)=\(b_1\,b_2\,dots.h\,b_l\)$, where
  $b = b_1 q / beta^1 + b_2 q / beta^2 + dots.h.c + b_l q / beta^l$
  $gt.tri$ from #link(<subsec:poly-decomp>)[\[subsec:poly-decomp\]] \
  $macron(sans("ct"))_k = sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)= (sans("LWE")_(arrow(s)\,sigma) (m_2 q / beta^1 + e_(2\,1)) \, sans("LWE")_(arrow(s)\,sigma) (m_2 q / beta^2 + e_(2\,2)) \, dots.h \, sans("LWE")_(arrow(s)\,sigma) (m_2 q / beta^l + e_(2\,l)))$
  \ $$

  Therefore: \
  $chevron.l sans("Decomp")^(beta\,l)\(b\)\,macron(sans("ct"))_k chevron.r$
  \
  \$= b\_1 \\cdot \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (m\_{2}\\dfrac{q}{\\beta^1}  + e\_{2, 1}\\right ) + b\_2 \\cdot \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (m\_{2}\\dfrac{q}{\\beta^2}  + e\_{2, 2}\\right ) + \\gap{\$\\cdots\$} + b\_l \\cdot \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (m\_{2}\\dfrac{q}{\\beta^l}  + e\_{2, l}\\right)\$
  \
  \$= \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (b\_1m\_{2}\\dfrac{q}{\\beta^1}  + b\_1e\_{2, 1}\\right ) + \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (b\_2m\_{2}\\dfrac{q}{\\beta^2}  + b\_2e\_{2,2}\\right ) + \\gap{\$\\cdots\$} + \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (b\_lm\_{2}\\dfrac{q}{\\beta^l} + b\_le\_{2, l}\\right)\$
  $gt.tri$ from #link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]] \
  \$= \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (b\_1m\_{2}\\dfrac{q}{\\beta^1} + b\_2m\_{2}\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + b\_lm\_{2}\\dfrac{q}{\\beta^l} + b\_1e\_{2,1} + \\cdots + b\_le\_{2,l}\\right)\$
  $gt.tri$ from #link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]] \
  \$= \\textsf{LWE}\_{\\vec{s}, \\sigma} \\left (m\_{2} \\cdot \\left ( b\_1\\dfrac{q}{\\beta^1} + b\_2\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + b\_l\\dfrac{q}{\\beta^l} + e^{\\langle k \\rangle} \\right)\\right)\$
  $gt.tri$ where
  $e^(chevron.l k chevron.r) = sum_(i = 1)^l b_i e_(2\,i)$ \
  $= sans("LWE")_(arrow(s)\,sigma)\(m_2 b + e^(chevron.l k chevron.r)\)$
  $gt.tri$ from #link(<subsec:poly-decomp>)[\[subsec:poly-decomp\]]

+ For $0 lt.eq i lt.eq\(k - 1\)$: \
  \$\\textsf{Decomp}^{\\beta, l}(a\_i) = (a\_{\\langle i, 1 \\rangle}, a\_{\\langle i, 2 \\rangle}, \\gap{\$\\cdots\$}, a\_{\\langle i, l \\rangle})\$,
  where
  \$a\_i = a\_{\\langle i, 1 \\rangle}\\dfrac{q}{\\beta^1} + a\_{\\langle i, 2 \\rangle}\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + a\_{\\langle i, l \\rangle}\\dfrac{q}{\\beta^l}\$
  \
  $macron(sans("ct"))_i = sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_i m_2\)$

  \$= \\left(\\textsf{LWE}\_{\\vec{s}, \\sigma}\\left(-s\_im\_2\\dfrac{q}{\\beta^1} + e\_{i, 1}\\right), \\textsf{LWE}\_{\\vec{s}, \\sigma}\\left(-s\_im\_2\\dfrac{q}{\\beta^2} + e\_{i, 2}\\right), \\gap{\$\\cdots\$}, \\textsf{LWE}\_{\\vec{s}, \\sigma}\\left(-s\_im\_2\\dfrac{q}{\\beta^l} + e\_{i, l}\\right) \\right)\$
  \ $$ Therefore: \
  \$\\langle \\textsf{Decomp}^{\\beta, l}(a\_0), \\bar{\\textsf{ct}}\_0 \\rangle + \\langle \\textsf{Decomp}^{\\beta, l}(a\_1), \\bar{\\textsf{ct}}\_1 \\rangle + \\gap{\$\\cdots\$} + \\langle \\textsf{Decomp}^{\\beta, l}(a\_{k-1}), \\bar{\\textsf{ct}}\_{k-1} \\rangle\$
  \
  $= sum_(i = 0)^(k - 1) chevron.l sans("Decomp")^(beta\,l)\(a_i\)\,macron(sans("ct"))_i chevron.r$
  \
  $= sum_(i = 0)^(k - 1) #scale(x: 300%, y: 300%)[\(] a_(chevron.l i\,1 chevron.r) dot.op sans("LWE")_(arrow(s)\,sigma) (- s_i m_2 q / beta^1 + e_(i\,1)) + a_(chevron.l i\,2 chevron.r) dot.op sans("LWE")_(arrow(s)\,sigma) (- s_i m_2 q / beta^2 + e_(i\,2)) +$

  $dots.h.c + a_(chevron.l i\,l chevron.r) dot.op sans("LWE")_(arrow(s)\,sigma) (- s_i m_2 q / beta^l + e_(i\,l)) #scale(x: 300%, y: 300%)[\)]$
  \
  $= sum_(i = 0)^(k - 1) #scale(x: 300%, y: 300%)[\(] sans("LWE")_(arrow(s)\,sigma) (- a_(chevron.l i\,1 chevron.r) s_i m_2 q / beta^1 + a_(chevron.l i\,1 chevron.r) e_(i\,1)) + sans("LWE")_(arrow(s)\,sigma) (- a_(chevron.l i\,2 chevron.r) s_i m_2 q / beta^2 + a_(chevron.l i\,2 chevron.r) e_(i\,2)) +$

  \$\\gap{\$\\cdots\$} + \\textsf{LWE}\_{\\vec{s}, \\sigma}\\left(-a\_{\\langle i, l\\rangle}s\_im\_2\\dfrac{q}{\\beta^l} + a\_{\\langle i, l \\rangle}e\_{i,l}\\right)\\Bigg)\$
  \
  \$= \\sum\\limits\_{i=0}^{k-1}\\textsf{LWE}\_{\\vec{s}, \\sigma}\\left(-a\_{\\langle i, 1\\rangle}s\_im\_2\\dfrac{q}{\\beta^1} -a\_{\\langle i, 2\\rangle}s\_im\_2\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} -a\_{\\langle i, l\\rangle}s\_im\_2\\dfrac{q}{\\beta^l} + a\_{\\langle i, 1 \\rangle}e\_{i,1} + \\cdots + a\_{\\langle i, l \\rangle}e\_{i,l}\\right)\$
  \
  \$= \\sum\\limits\_{i=0}^{k-1}\\textsf{LWE}\_{\\vec{s}, \\sigma}\\left(-s\_im\_2 \\cdot \\left(a\_{\\langle i, 1\\rangle}\\dfrac{q}{\\beta^1} + a\_{\\langle i, 2\\rangle}\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + a\_{\\langle i, l\\rangle}\\dfrac{q}{\\beta^l}\\right) + a\_{\\langle i, 1 \\rangle}e\_{i,1} + \\cdots + a\_{\\langle i, l \\rangle}e\_{i,l}\\right)\$
  \
  $= sum_(i = 0)^(k - 1) sans("LWE")_(arrow(s)\,sigma)\(- s_i m_2 a_i + e^(chevron.l i chevron.r)\)$
  $gt.tri$ where
  $e^(chevron.l i chevron.r) = a_(chevron.l i\,1 chevron.r) e_(i\,1) + dots.h.c + a_(chevron.l i\,l chevron.r) e_(i\,l)$

+ According to step 2 and 3, \
  $sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(sans("ct")_i\)\,macron(sans("ct"))_i chevron.r$
  \
  $= sum_(i = 0)^(k - 1) sans("LWE")_(arrow(s)\,sigma)\(- s_i m_2 a_i + e^(chevron.l i chevron.r)\)+ sans("LWE")_(arrow(s)\,sigma)\(m_2 b + e^(chevron.l k chevron.r)\)$
  \
  $= sans("LWE")_(arrow(s)\,sigma) (sum_(i = 0)^(k - 1) \( - s_i m_2 a_i \) + m_2 b + sum_(i = 0)^k e^(chevron.l i chevron.r))$
  $gt.tri$ addition of two LWE ciphertexts \
  $= sans("LWE")_(arrow(s)\,sigma) (m_2 b - sum_(i = 0)^(k - 1) m_2 a_i s_i + sum_(i = 0)^k e^(chevron.l i chevron.r))$
  \
  $= sans("LWE")_(arrow(s)\,sigma) (m_2 \( b - sum_(i = 0)^(k - 1) a_i s_i \) + sum_(i = 0)^k e^(chevron.l i chevron.r))$
  \
  $= sans("LWE")_(arrow(s)\,sigma) (m_2 \( Delta m_1 + e_1 \) + sum_(i = 0)^k e^(chevron.l i chevron.r))$
  \
  $= sans("LWE")_(arrow(s)\,sigma) (Delta m_1 m_2 + m_2 e_1 + sum_(i = 0)^k e^(chevron.l i chevron.r))$
  \ $approx sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 m_2\)$ $gt.tri$
  given $m_2 e_1 + sum_(i = 0)^k e^(chevron.l i chevron.r)$ is small and
  thus $m_2 e_1$ is also small

]
To reduce the noise growth, noise bootstrapping is needed (will be
discussed in #link(<subsec:tfhe-noise-bootstrapping>)[0.8]).

=== Generalization to GLWE-to-GGSW Multiplication
<subsubsec:tfhe-glwe-to-ggsw-multiplication>
We can further generalize TFHE's LWE-to-GSW multiplication to
GLWE-to-GGSW multiplication between the following two ciphertexts:
$sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1\)dot.op sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)$,
where $M_1$, $M_2$, and $S$ are $\(n - 1\)$-degree polynomials.

$$

The 1st term $sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1\)$ comes from
one of the following:

- A fresh GLWE encryption
  (#link(<subsec:glwe-enc>)[\[subsec:glwe-enc\]]) of plaintext $M_1$.

- A homomorphically added result of two GLWE ciphertexts
  (#link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]).

- A homomorphically multiplied result of a GLWE ciphertext with a
  plaintext (#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]).

$$

The 2nd term $sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)$ comes
from one of the following:

- A fresh GGSW encryption
  (#link(<subsec:ggsw-enc>)[\[subsec:ggsw-enc\]]) of plaintext $M_2$.

- Converted from $sans("GLWE")_(arrow(S)\,sigma)\(Delta M_2\)$ into
  $sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)$ by #emph[circuit
  bootstrapping] (this will be covered in the future).

$$

Remember the following:

\$\\textsf{GLWE}\_{\\vec{S}, \\sigma}(\\Delta M\_1) = (A\_0, A\_1, \\gap{\$\\cdots\$}, A\_{k-1}, B) \\in \\mathcal{R}\_{n, q}^{k + 1}\$,
where $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta M_1 + E$ \
$gt.tri$ from #link(<subsec:glwe-enc>)[\[subsec:glwe-enc\]]

$$

$sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)= #scale(x: 180%, y: 180%)[{] { sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(- S_i dot.op M_2\)}_(i = 0)^(k - 1)\,sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)#scale(x: 180%, y: 180%)[}] in cal(R)_(chevron.l n\,q chevron.r)^(\(k + 1\)dot.op l dot.op\(k' + 1\))$
$gt.tri$ from #link(<subsec:ggsw-enc>)[\[subsec:ggsw-enc\]]

$$

Let's use the following notations:

\$\\textsf{GGSW}\_{\\vec{S}, \\sigma}^{\\beta, l}(M\_2) = {\\bar{C}} = (\\bar{C\_0},. \\bar{C\_1}, \\gap{\$\\cdots\$} \\bar{C\_k})\$

$macron(C_i) = sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(- S_i dot.op M_2\)$
for $0 lt.eq i lt.eq\(k - 1\)$

$macron(C_k) = sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)$

\$\\textsf{ct} = \\textsf{GLWE}\_{\\vec{S}, \\sigma}(\\Delta M\_1) = (C\_0, C\_1, \\gap{\$\\cdots\$}, C\_k) = (A\_0, A\_1, \\gap{\$\\cdots\$}, A\_{k-1}, B)\$

$$

Let's define the following TFHE ciphertext multiplication operation:

$sans("ct") dot.op macron(C) = sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(C_i\)\,macron(C_i) chevron.r$

$$

Then, the following is true:

#block[
$sans("ct") = sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1\)=\(A_0\,A_1\,dots.h.c\,A_(k - 1)\,B\)$

$macron(C) = sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)$

$= bold(\() sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(- S_0 dot.op M_2\)\,sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(- S_1 dot.op M_2\)\,dots.h.c\,sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(- S_(k - 1) dot.op M_2\)\,sans("GLev")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)bold(\))$

$$

$sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1\)dot.op sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(M_2\)= sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(C_i\)\,macron(C_i) chevron.r approx sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1 M_2\)$

]
This means that multiplying two TFHE ciphertexts (one is in GLWE and
another in GGSW) and decrypting the resulting GLWE ciphertext gives the
same result as multiplying their two original plaintexts.

#block[
+ $sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(C_i\)\,macron(C_i) chevron.r$
  \
  \$= \\langle \\textsf{Decomp}^{\\beta, l}(A\_0), \\bar{C\_0} \\rangle + \\langle \\textsf{Decomp}^{\\beta, l}(A\_1), \\bar{C\_1} \\rangle + \\gap{\$\\cdots\$} + \\langle \\textsf{Decomp}^{\\beta, l}(A\_{k-1}), \\bar{C}\_{k-1} \\rangle + \\langle \\textsf{Decomp}^{\\beta, l}(B), \\bar{C\_k} \\rangle\$
  \ $gt.tri$ expanding the dot product of two vectors

+ For $i = k$: \
  \$\\textsf{Decomp}^{\\beta, l}(B) = (B\_1, B\_2, \\gap{\$\\cdots\$}, B\_l)\$,
  where
  \$B = B\_1\\dfrac{q}{\\beta^1} + B\_2\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + B\_l\\dfrac{q}{\\beta^l}\$
  $gt.tri$ from #link(<subsec:poly-decomp>)[\[subsec:poly-decomp\]] \
  \$\\bar{C}\_k = \\textsf{GLev}\_{\\vec{S}, \\sigma}^{\\beta, l}(M\_2) = \\left(\\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(M\_{2}\\dfrac{q}{\\beta^1}\\right), \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(M\_{2}\\dfrac{q}{\\beta^2}\\right), \\gap{\$\\cdots\$}, \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(M\_{2}\\dfrac{q}{\\beta^l}\\right) \\right)\$

  $gt.tri$ we omit the noise terms $E_(2\,1)\,dots.h\,E_(2\,l)$ in each
  GLWE ciphertext for simplicity \ $$

  Therefore: \
  $chevron.l sans("Decomp")^(beta\,l)\(B\)\,macron(C_k) chevron.r$ \
  \$= B\_1 \\cdot \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (M\_{2}\\dfrac{q}{\\beta^1} \\right ) + B\_2 \\cdot \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (M\_{2}\\dfrac{q}{\\beta^2} \\right ) + \\gap{\$\\cdots\$} + B\_l \\cdot \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (M\_{2}\\dfrac{q}{\\beta^l}\\right)\$
  \
  \$= \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (B\_1M\_{2}\\dfrac{q}{\\beta^1} \\right ) + \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (B\_2M\_{2}\\dfrac{q}{\\beta^2} \\right ) + \\gap{\$\\cdots\$} + \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (B\_lM\_{2}\\dfrac{q}{\\beta^l}\\right)\$
  $gt.tri$ from #link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]] \
  \$= \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (B\_1M\_{2}\\dfrac{q}{\\beta^1} + B\_2M\_{2}\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + B\_lM\_{2}\\dfrac{q}{\\beta^l}\\right)\$
  $gt.tri$ from #link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]] \
  \$= \\textsf{GLWE}\_{\\vec{S}, \\sigma} \\left (M\_{2} \\cdot \\left ( B\_1\\dfrac{q}{\\beta^1} + B\_2\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + B\_l\\dfrac{q}{\\beta^l} \\right)\\right)\$
  \ $= sans("GLWE")_(arrow(S)\,sigma)\(M_2 B\)$ $gt.tri$ from
  #link(<subsec:poly-decomp>)[\[subsec:poly-decomp\]]

+ For $0 lt.eq i lt.eq\(k - 1\)$: \
  \$\\textsf{Decomp}^{\\beta, l}(A\_i) = (A\_{\\langle i, 1 \\rangle}, A\_{\\langle i, 2 \\rangle}, \\gap{\$\\cdots\$}, A\_{\\langle i, l \\rangle})\$,
  where
  \$A\_i = A\_{\\langle i, 1 \\rangle}\\dfrac{q}{\\beta^1} + A\_{\\langle i, 2 \\rangle}\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + A\_{\\langle i, l \\rangle}\\dfrac{q}{\\beta^l}\$
  \
  \$\\bar{C\_i} =  \\textsf{GLev}\_{\\vec{S}, \\sigma}^{\\beta, l}(-S\_iM\_2) = \\left(\\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2\\dfrac{q}{\\beta^1}\\right), \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2\\dfrac{q}{\\beta^2}\\right), \\gap{\$\\cdots\$}, \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2\\dfrac{q}{\\beta^l}\\right) \\right)\$
  \ $$ Therefore: \
  \$\\langle \\textsf{Decomp}^{\\beta, l}(A\_0), \\bar{C\_0} \\rangle + \\langle \\textsf{Decomp}^{\\beta, l}(A\_1), \\bar{C\_1} \\rangle + \\gap{\$\\cdots\$} + \\langle \\textsf{Decomp}^{\\beta, l}(A\_{k-1}), \\bar{C}\_{k-1} \\rangle\$
  \
  $= sum_(i = 0)^(k - 1) chevron.l sans("Decomp")^(beta\,l)\(A_i\)\,macron(C_i) chevron.r$
  \
  \$= \\sum\\limits\_{i=0}^{k-1}\\left(A\_{\\langle i, 1\\rangle} \\cdot \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2\\dfrac{q}{\\beta^1}\\right) + A\_{\\langle i, 2\\rangle} \\cdot \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2\\dfrac{q}{\\beta^2}\\right) + \\gap{\$\\cdots\$} + A\_{\\langle i, l\\rangle} \\cdot \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2\\dfrac{q}{\\beta^l}\\right)\\right)\$
  \
  \$= \\sum\\limits\_{i=0}^{k-1}\\left(\\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-A\_{\\langle i, 1\\rangle}S\_iM\_2\\dfrac{q}{\\beta^1}\\right) + \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-A\_{\\langle i, 2\\rangle}S\_iM\_2\\dfrac{q}{\\beta^2}\\right) + \\gap{\$\\cdots\$} + \\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-A\_{\\langle i, l\\rangle}S\_iM\_2\\dfrac{q}{\\beta^l}\\right)\\right)\$
  \
  \$= \\sum\\limits\_{i=0}^{k-1}\\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-A\_{\\langle i, 1\\rangle}S\_iM\_2\\dfrac{q}{\\beta^1} + -A\_{\\langle i, 2\\rangle}S\_iM\_2\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + -A\_{\\langle i, l\\rangle}S\_iM\_2\\dfrac{q}{\\beta^l}\\right)\$
  \
  \$= \\sum\\limits\_{i=0}^{k-1}\\textsf{GLWE}\_{\\vec{S}, \\sigma}\\left(-S\_iM\_2 \\cdot \\left(A\_{\\langle i, 1\\rangle}\\dfrac{q}{\\beta^1} + A\_{\\langle i, 2\\rangle}\\dfrac{q}{\\beta^2} + \\gap{\$\\cdots\$} + A\_{\\langle i, l\\rangle}\\dfrac{q}{\\beta^l}\\right)\\right)\$
  \
  $= sum_(i = 0)^(k - 1) sans("GLWE")_(arrow(S)\,sigma)\(- S_i M_2 A_i\)$

+ According to step 2 and 3, \
  $sum_(i = 0)^k chevron.l sans("Decomp")^(beta\,l)\(C_i\)\,macron(C_i) chevron.r$
  \
  $= sum_(i = 0)^(k - 1) sans("GLWE")_(arrow(S)\,sigma)\(- S_i M_2 A_i\)+ sans("GLWE")_(arrow(S)\,sigma)\(M_2 B\)$
  \
  $= sans("GLWE")_(arrow(S)\,sigma) #scale(x: 180%, y: 180%)[\(] sum_(i = 0)^(k - 1)\(- S_i M_2 A_i\)+ M_2 B #scale(x: 180%, y: 180%)[\)]$
  $gt.tri$ addition of two GLWE ciphertexts \
  $= sans("GLWE")_(arrow(S)\,sigma) #scale(x: 180%, y: 180%)[\(] B M_2 - sum_(i = 0)^(k - 1) M_2 A_i S_i #scale(x: 180%, y: 180%)[\)]$
  \
  $= sans("GLWE")_(arrow(S)\,sigma) #scale(x: 180%, y: 180%)[\(] M_2\(B - sum_(i = 0)^(k - 1) A_i S_i\)#scale(x: 180%, y: 180%)[\)]$
  \ $= sans("GLWE")_(arrow(S)\,sigma)\(M_2\(Delta M_1 + E\)\)$ \
  $= sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1 M_2 + M_2 E\)$ \
  $approx sans("GLWE")_(arrow(S)\,sigma)\(Delta M_1 M_2\)$ $gt.tri$
  given $E$ is small and thus $M_2 E$ is also small

]
== Coefficient Extraction
<subsec:tfhe-extraction>
#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-4")[TFHE Deep Dive - Part IV - Programmable Bootstrapping]~@tfhe-4

$$

In TFHE, coefficient extraction is a process of extracting a coefficient
of a polynomial that is encrypted as GLWE ciphertext. The extracted
coefficient is in the form of LWE ciphertext
(#link(<sec:lwe>)[\[sec:lwe\]]).

Note that in the GLWE cryptosystem, plaintext $M$ is encoded as a
polynomial, where each coefficient encodes the plaintext value
$m_0\,m_1\,dots.h.c\,m_(n - 1)$.

Suppose we have a GLWE ciphertext setup as the following: \
$M = sum_(j = 0)^(n - 1) m_j X^j in cal(R)_(chevron.l n\,q chevron.r)$

\$S = \\left(S\_0 = \\sum\\limits\_{j=0}^{n-1}s\_{0,j}X^j, S\_1 = \\sum\\limits\_{j=0}^{n-1}s\_{1,j}X^j, \\gap{\$\\cdots\$}, S\_{k-1} = \\sum\\limits\_{j=0}^{n-1}s\_{k-1,j}X^j \\right)\$

\$\\textsf{GLWE}\_{\\vec{S}, \\sigma}(\\Delta M) = \\left(A\_0 = \\sum\\limits\_{j=0}^{n-1}a\_{0,j}X^j, A\_1 = \\sum\\limits\_{j=0}^{n-1}a\_{1,j}X^j, \\gap{\$\\cdots\$}, A\_{k-1} = \\sum\\limits\_{j=0}^{n-1}a\_{k-1,j}X^j, B = \\sum\\limits\_{j=0}^{n-1}b\_{j}X^j\\right)\$

$B = sum_(i = 0)^(k - 1) A_i S_i + Delta M + E$

$E = sum_(i = 0)^(n - 1) e_i X^i$

$$

Note that:

$Delta M + E = B - sum_(i = 0)^(k - 1) A_i S_i$

\$= (\\Delta m\_0 + \\Delta m\_1X + \\gap{\$\\cdots\$} + \\Delta m\_{n-1}X^{n-1}) + (e\_0 + e\_1X + \\gap{\$\\cdots\$} + e\_{n-1}X^{n-1})\$

\$= (\\Delta m\_0 + e\_0) + (\\Delta m\_1 + e\_1)X + \\gap{\$\\cdots\$} + (\\Delta m\_{n-1} + e\_{n-1})X^{n-1}\$

$$

Another way to write the formula is:

$B - sum_(i = 0)^(k - 1) A_i S_i$

\$= (b\_0 + b\_1X + \\gap{\$\\cdots\$} + b\_{n-1}X^{n-1} )\$

\$- (a\_{0,0} + a\_{0,1}X + \\gap{\$\\cdots\$} + a\_{0, n-1}X^{n-1})(s\_{0,0} + s\_{0,1}X + \\gap{\$\\cdots\$} + s\_{0, n-1}X^{n-1})\$

\$- (a\_{1,0} + a\_{1,1}X + \\gap{\$\\cdots\$} + a\_{1, n-1}X^{n-1})(s\_{1,0} + s\_{1,1}X + \\gap{\$\\cdots\$} + s\_{1, n-1}X^{n-1})\$

\$- \\gap{\$\\cdots\$}\$

\$- (a\_{k-1,0} + a\_{k-1,1}X + \\gap{\$\\cdots\$} + a\_{k-1, n-1}X^{n-1})(s\_{k-1,0} + s\_{k-1,1}X + \\gap{\$\\cdots\$} + s\_{k-1, n-1}X^{n-1})\$

$$

$= (b_0 - (sum_(i = 0)^(k - 1) sum_(j = 0)^0 \( a_(i\,0 - j) s_(i\,j) \) - sum_(i = 0)^(k - 1) sum_(j = 1)^(n - 1) \( a_(i\,n - j) s_(i\,j) \)))$

$+ (b_1 - (sum_(i = 0)^(k - 1) sum_(j = 0)^1 \( a_(i\,1 - j) s_(i\,j) \) - sum_(i = 0)^(k - 1) sum_(j = 2)^(n - 1) \( a_(i\,n + 1 - j) s_(i\,j) \))) dot.op X$

$+ (b_2 - (sum_(i = 0)^(k - 1) sum_(j = 0)^2 \( a_(i\,2 - j) s_(i\,j) \) - sum_(i = 0)^(k - 1) sum_(j = 3)^(n - 1) \( a_(i\,n + 2 - j) s_(i\,j) \))) dot.op X^2$

$$

\$\\gap{\$\\cdots\$}\$

$$

$+ (b_(n - 1) - (sum_(i = 0)^(k - 1) sum_(j = 0)^(n - 1) \( a_(i\,n - 1 - j) s_(i\,j) \) - sum_(i = 0)^(k - 1) sum_(j = n)^(n - 1) \( a_(i\,n +\(n - 1\)- j) s_(i\,j) \))) dot.op X^(n - 1)$

$gt.tri$ Grouping the terms by same exponents

$$

$$

$= sum_(h = 0)^(n - 1) (b_h - (sum_(i = 0)^(k - 1) sum_(j = 0)^h \( a_(i\,h - j) s_(i\,j) \) - sum_(i = 0)^(k - 1) sum_(j = h + 1)^(n - 1) \( a_(i\,n + h - j) s_(i\,j) \))) dot.op X^h$

$$

$= sum_(h = 0)^(n - 1) C_h dot.op X^h$, where
$C_h = b_h - (sum_(i = 0)^(k - 1) sum_(j = 0)^h \( a_(i\,h - j) s_(i\,j) \) - sum_(i = 0)^(k - 1) sum_(j = h + 1)^(n - 1) \( a_(i\,n + h - j) s_(i\,j) \))$

$$

In the above $\(n - 1\)$-degree polynomial, notice that each $X^h$
term's coefficient, $C_h$, can be expressed as an LWE ciphertext
$sans("ct")_h$ as follows:

\$S\' = (s\_{0,0}, s\_{0,1}, \\gap{\$\\cdots\$}, s\_{0,n-1}, s\_{1,0}, s\_{1,1}, \\gap{\$\\cdots\$}, s\_{1, n-1}, \\gap{\$\\cdots\$}, s\_{k-1, n-1}) = (s\'\_0, s\'\_1, \\gap{\$\\cdots\$}, s\'\_{nk-1} ) \\in \\mathbb{Z}\_q^{nk}\$

\$\\textsf{ct}\_h = (a\'\_0, a\'\_1, \\gap{\$\\cdots\$}, a\'\_{nk-1}, b\_h) \\in \\mathbb{Z}\_q^{nk + 1}\$

\$\$\\text{, where } a\'\_{n \\cdot i + j} =   
\\begin{cases}
    a\_{i,h - j} \\text{ (if } 0 \\leq j \\leq h\\text{)}\\\\
    -a\_{i,n + h - j} \\text{ (if } h+1 \\leq j \\leq n-1\\text{)}\\\\
\\end{cases}
\\centering , b\_h \\text{ is directly obtained from the polynomial } B\$\$

Note that $b_h - sum_(i = 0)^(n k - 1) s'_i a'_i = Delta m_h + e_h$.
This means that $C_h$ can be replaced by its encrypted version,
$sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m_h\)$, an LWE ciphertext
$sans("ct")_h$ encrypting the $h$-th coefficient of $M$. Therefore, we
just extracted $sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m_h\)$ from
$sans("GLWE")_(arrow(S)\,sigma)\(Delta M\)$. This operation is called
coefficient extraction, which does not add any noise because it simply
extracts an LWE ciphertext by reordering the polynomial of the GLWE
ciphertext.

Once we have $sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m_h\)$, we can
key-switch it from $arrow(s)_(') arrow.r arrow(s)$
(#link(<subsec:tfhe-key-switching>)[0.5]).

#block[
Given the following GLWE ciphertext:

$M = sum_(j = 0)^(n - 1) m_j X^j in cal(R)_(chevron.l n\,t chevron.r)$

\$\\vec{S} = \\left(S\_0 = \\sum\\limits\_{j=0}^{n-1}s\_{0,j}X^j, S\_1 = \\sum\\limits\_{j=0}^{n-1}s\_{1,j}X^j, \\gap{\$\\cdots\$}, S\_{k-1} = \\sum\\limits\_{j=0}^{n-1}s\_{k-1,j}X^j \\right)\$

\$\\textsf{GLWE}\_{\\vec{S}, \\sigma}(\\Delta M) = \\left(A\_0 = \\sum\\limits\_{j=0}^{n-1}a\_{0,j}X^j, A\_1 = \\sum\\limits\_{j=0}^{n-1}a\_{1,j}X^j, \\gap{\$\\cdots\$}, A\_{k-1} = \\sum\\limits\_{j=0}^{n-1}a\_{k-1,j}X^j, B = \\sum\\limits\_{j=0}^{n-1}b\_{j}X^j\\right)\$

$B = sum_(i = 0)^(k - 1) A_i S_i + Delta M + E med mod med q$,
$E = sum_(i = 0)^(n - 1) e_i X^i$

$$

$sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m_h\)$ is an LWE ciphertext
that encrypts $Delta M$'s $h$-th coefficient (i.e., $Delta m_h$).
$sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m_h\)$ can be extracted from
$sans("GLWE")_(arrow(S)\,sigma)\(Delta M\)$ as follows:

$$

\$\\vec{s}\_{\'} = (s\_{0,0}, s\_{0,1}, \\gap{\$\\cdots\$}, s\_{0,n-1}, s\_{1,0}, s\_{1,1}, \\gap{\$\\cdots\$}, s\_{1, n-1}, \\gap{\$\\cdots\$}, s\_{k-1, n-1}) = (s\'\_0, s\'\_1, \\gap{\$\\cdots\$}, s\'\_{nk-1} ) \\in \\mathbb{Z}\_q^{nk}\$

\$\\textsf{LWE}\_{\\vec{s}\_{\'}, \\sigma}(\\Delta m\_h) = (a\_0\', a\_1\', \\gap{\$\\cdots\$} , a\_{nk-1}\', b\_h) \\in \\mathbb{Z}\_q^{nk + 1}\$

$ upright(", where ") a'_(n dot.op i + j) = {a_(i\,h - j) upright(" (if ") 0 lt.eq j lt.eq h upright(")")\
- a_(i\,n + h - j) upright(" (if ") h + 1 lt.eq j lt.eq n - 1 upright(")")\
\,b_h upright(" is obtained from the polynomial ") B $

Once we have $sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m_h\)$,
key-switch it from $arrow(s)_(') arrow.r arrow(s)$
(#link(<subsec:tfhe-key-switching>)[0.5]).

]
== Noise Bootstrapping
<subsec:tfhe-noise-bootstrapping>
#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-4")[TFHE Deep Dive - Part IV - Programmable Bootstrapping]~@tfhe-4

$$

Continuing homomorphic additions of TFHE ciphertexts does not
necessarily increase the noise $e$, because $e$ is randomly generated
over the Gaussian distribution, thus adding up many noises would give
the mean value of 0. On the other hand, continuing homomorphic
multiplications increases the noise, because the noise terms get
multiplied, growing its magnitude. Thus, we need to somehow #emph[reset]
the noise before it trespasses on the higher bits where plaintext $m$
resides (i.e., preventing the red noise bits from overflowing to the
blue plaintext bits as shown in #link(<fig:scaling>)[\[fig:scaling\]]).
The process of re-initializing the noise to a smaller value is called
noise bootstrapping.

As explained in the beginning of this section, TFHE uses LWE (which is
GLWE with polynomial degree 0) to encrypt & decrypt a plaintext. That
is, each plaintext is $m$ (a single number), encoded as a zero-degree
polynomial. Further, the secret key S that encrypts each $m$ is a vector
${ s_0\,s_1\,upright(" ") dots.h.c upright(" ")\,s_(k - 1) }$ instead of
a polynomial. On the other hand, TFHE's noise bootstrapping uses
homomorphic addition between GLWE ciphertexts and homomorphic
multiplication between GLWE and GGSW ciphertexts.

Suppose we have a TFHE ciphertext as follows:

$$

\$\\textsf{LWE}\_{\\vec{s}, \\sigma}(\\Delta m) = (a\_0, a\_1, \\gap{\$\\cdots\$} a\_{k-1}, b)\$

$b = sum_(i = 0)^(k - 1) a_i s_i + Delta m + e_b$

\$\\vec{s} = (s\_0, s\_1, \\gap{\$\\cdots\$} s\_{k-1})\$

$$

, where $e_b$ is a big noise accumulated over a series of many
ciphertext (or plaintext) multiplications. The goal of noise
bootstrapping is to convert
\$(a\_0, a\_1, \\gap{\$\\cdots\$} a\_{k-1}, b)\$ into
\$(a\_0\', a\_1\', \\gap{\$\\cdots\$} a\_{k-1}\', b\')\$ such that:

$$

$b' = sum_(i = 0)^(k - 1) a'_i s_i + Delta m + e_s$

$$

, where $e_s$ is a re-initialized noise.

$$

=== Overview
<subsec:bootstrapping-overview>
To implement noise bootstrapping, we create a specially designed
$\(n - 1\)$-degree polynomial $V\(X\)$ called a Lookup Table (LUT).
Before explaining $V\(X\)$, we will first motivate the idea based on a
preliminary LUT polynomial $V_q\(X\)$. Imagine that the polynomial
$V_q\(X\)$'s each degree term $X^j$ has its exponent
$j = Delta m_i + e_(*)$, a plaintext $m_i$ with some noise
$e_(*) in bb(Z)_Delta$, and its corresponding coefficient $v_j = m_i$,
which is a noise-free plaintext. Therefore, the $\(q - 1\)$-degree
polynomial $V_q\(X\)$ is defined as follows:

\$V\_q(X) = v\_0 + v\_1X^1 + v\_2X^2 + \\gap{\$\\cdots\$} + v\_{q-1}X^{q-1}\$

\$= m\_0X^{\\Delta m\_0 + e\_0} + m\_0X^{\\Delta m\_0 + e\_1} + m\_0X^{\\Delta m\_0 + e\_2} + \\gap{\$\\cdots\$} + m\_0X^{\\Delta m\_0 + e\_{\\Delta - 1}}\$
$gt.tri$ total $Delta$ terms

\$+ \\text{ } m\_1X^{\\Delta m\_1 + e\_0} + m\_1X^{\\Delta m\_1 + e\_1} + m\_1X^{\\Delta m\_1 + e\_2} + \\gap{\$\\cdots\$} + m\_1X^{\\Delta m\_1 + e\_{\\Delta - 1}}\$
$gt.tri$ total $Delta$ terms

\$+ \\gap{\$\\cdots\$}\$

\$+ \\text{ } m\_{t - 1}X^{\\Delta m\_{t - 1} + e\_0} + m\_{t - 1}X^{\\Delta m\_{t - 1} + e\_1} + m\_{t - 1}X^{\\Delta m\_{t - 1} + e\_2} + \\gap{\$\\cdots\$} + m\_{t - 1}X^{\\Delta m\_{t - 1} + e\_{\\Delta - 1}}\$
$gt.tri$ total $Delta$ terms

$$

In the above formula, each $m_i$ and $e_k$ represents every possible
plaintext message and error values (where $m_i in bb(Z)_t$ and
$e_k in bb(Z)_Delta$).

We design $V_q\(X\)$ to have the special property that each $v_j X^j$
term represents the special mapping (exponent, coefficient)
$=\(Delta m_i + e_(*)\,m_i\)$, where $e_(*)$ can be any value in
$bb(Z)_Delta$. During the TFHE setup stage, we GLWE-encrypt $V_q\(X\)$
by using our newly defined GLWE key $arrow(S)_(b k)$, a
#emph[bootstrapping key], which is different from the LWE secret key
$arrow(s)$. $arrow(S)_(b k)$ is a list of $\(n - 1\)$-degree polynomials
with binary coefficients. Later, during the noise bootstrapping stage,
we will rotate the coefficients of $V$ by $Delta m + e$ positions to the
left by computing $V dot.op X^(-\(Delta m + e\)) = V'$, using the
polynomial coefficient rotation method 1 technique
(Summary~@subsec:coeff-rotation\.1 in
#link(<subsec:coeff-rotation>)[\[subsec:coeff-rotation\]]). Then, we
will extract the polynomial's constant term's coefficient (i.e., the
left-most 0-degree term's coefficient in the rotated polynomial $V'$) by
using the coefficient extraction technique
(#link(<subsec:tfhe-extraction>)[0.7]). Further, we will encrypt
$V_q\(X\)$ as a GLWE ciphertext at the TFHE setup stage, and thus the
rotated $V'_q\(X\)$'s extracted constant term's coefficient is an LWE
encryption of $m$ (i.e., $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$)
with a re-initialized (i.e., completely reduced) noise.

To summarize, the noise bootstrapping procedure can be conceptually
understood (at least for now) as follows:

$$

+ #strong[#underline[Input]:]
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m + e\)$ as a noisy ciphertext
  encrypting $m$

+ Convert the input into the form of $X^(-\(Delta m + e\))$ as a rotator
  of $V_q\(X\)$ (Lookup Table).

+ Rotate $V_q$ to the left by $Delta m + e$ positions by computing
  $V_q dot.op X^(-\(Delta m + e\)) = V'_q$.

+ Extract the rotated $V'_q\(X\)$'s constant term's coefficient $m$ as
  an LWE encryption, which is
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$.

+ #strong[#underline[Output]:]
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$ as an LWE encryption of the
  plaintext $m$ with a re-initialized noise

$$

The output $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$ encrypts the same
plaintext message as the input ciphertext, but with completely reduced
noise. Therefore, the output $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$
can be used for subsequent TFHE homomorphic operations (e.g., addition
or multiplication). During this noise bootstrapping process, the
polynomial $V_q$ is used as a #emph[dictionary] that contains the
mappings from the noisy plaintext $Delta m + e$ (i.e., as
$Delta m + e = j$ where $v_j X^j$) to the noise-free plaintext $m$
(i.e., as $m = v_j$ where $v_j X^j$). Therefore, $V_q$ is called the
Lookup Table (LUT).

Then, what should be the degree of $V_q\(X\)$? In order for $V_q\(X\)$
to encode all possible mappings from $Delta m + e in bb(Z)_q$ to
$m in bb(Z)_t$, $V_q\(X\)$ should be a $\(q - 1\)$-degree polynomial.
However, $q$ is a very big number, and it is computationally infeasible
to manage a $\(q - 1\)$-degree polynomial. Thus, in practice, we instead
use a much smaller polynomial $V\(X\)$ whose degree is only $n - 1$.
Remember that according to our TFHE setup, $n lt.double q$. Therefore,
we need a way to #emph[compress] the big ciphertext space
$Delta m + e in bb(Z)_q$ into a much smaller space $bb(Z)_n$ and encode
the compressed values as the exponents of $X^j$ in a
#emph[proportionally] correct way. For this proportional compression of
$bb(Z)_q arrow.r bb(Z)_n$, we will use the LWE modulus switching
technique learned from
#link(<subsec:modulus-switch-lwe>)[\[subsec:modulus-switch-lwe\]].

=== Modulus Switch for Noise Bootstrapping
<subsec:bootstrapping-modulus-switch>
To avoid using the giant $\(q - 1\)$-degree polynomial $V_q$, we will
compress $q$ possible ciphertext elements $Delta m + e in bb(Z)_q$ into
$n$ distinct exponents of the $\(n - 1\)$-degree polynomial $V$, where
each $v_j X^j$ term in $V$ represents a mapping from $j arrow.r v_j$
(i.e., noisy plaintext to noise-free plaintext). However, notice that
when we rotate the coefficients of the $\(n - 1\)$-degree polynomial $V$
to the left, as $v_j X^j$ rotates across the boundary between $X^0$ and
$X^(n - 1)$ degree terms, $v_j$'s sign flips to $- v_j$ (as shown in the
example of
#link(<subsec:coeff-rotation-ex>)[\[subsec:coeff-rotation-ex\]]). Due to
this coefficient sign flip, the $\(n - 1\)$-degree polynomial $V$ can
theoretically encode total $2 n$ distinct coefficient states as follows:
\$(v\_0, v\_1, v\_2, \\gap{\$\\cdots\$}, v\_{n-1}, -v\_0, -v\_1, \\gap{\$\\cdots\$}, -v\_{n-1})\$.
To move each of these $2 n$ distinct coefficients to the constant term's
coefficient position in $V$ (i.e., shifting the coefficient $v_j$ to the
leftmost term in $V$), the rotating computation of $V dot.op X^(- j)$
can use $2 n$ distinct $j$ values, which are
\$\\{0, 1, 2, \\gap{\$\\cdots\$}, n-1, n, \\gap{\$\\cdots\$}, 2n-1\\}\$,
to move each of
\$(v\_0, v\_1, v\_2, \\gap{\$\\cdots\$}, v\_{n-1}, -v\_0, -v\_1, \\gap{\$\\cdots\$}, -v\_{n-1})\$
coefficients to the constant term's position. This implies that the
exponent $j$ in $V dot.op X^(- j)$ can use any of the $2 n$ distinct
values to cover all possible $2 n$ (sign-flipped) coefficient states of
$V$. Also, remember that $j = Delta m + e$. Therefore, we will switch
the modulo of $Delta m + e$ from $q arrow.r 2 n$. Using the LWE modulus
switching technique
(#link(<subsec:modulus-switch-lwe>)[\[subsec:modulus-switch-lwe\]]), our
original LWE ciphertext
\$\\textsf{LWE}\_{\\vec{s}, \\sigma}(\\Delta m + e) = ({a}\_0, {a}\_1, \\gap{\$\\cdots\$} {a}\_{k-1}, {b}) \\in \\mathbb{Z}\_q^{k+1}\$
(i.e., the initial input to the noise bootstrapping procedure) will be
converted into the following:

$$

\$\\textsf{LWE}\_{\\vec{s}, \\sigma}(\\hat{\\Delta} m) = (\\hat{a}\_0, \\hat{a}\_1, \\gap{\$\\cdots\$} \\hat{a}\_{k-1}, \\hat{b}) \\in \\mathbb{Z}\_{2n}^{k+1}\$

\$\\vec{s} = (s\_0, s\_1, \\gap{\$\\cdots\$} s\_{k-1}) \\in \\mathbb{Z}\_2^{k}\$
$gt.tri$ the secret key stays the same, as each $s_i$ is binary

$hat(Delta) = Delta frac(2 n, q) = frac(2 n, t) in bb(Z)_(2 n)$

$hat(a)_i = ⌈a_i frac(2 n, q)⌋ in bb(Z)_(2 n)$

$hat(e) = ⌈e frac(2 n, q)⌋ in bb(Z)_(2 n)$

$hat(b) = ⌈b frac(2 n, q)⌋ approx sum_(i = 0)^(k - 1) hat(a)_i s_i + hat(Delta) m + hat(e) in bb(Z)_(2 n)$

$$

: If our goal were to design the minimal-degree polynomial $V$ whose
coefficients map all possible values of the plaintext $m$, then it would
be sufficient to design a $t$-degree polynomial $V$. Nonetheless, the
reason why we choose the degree of $V$ to be $2 n$ instead of $t$ is to
guarantee an enough security level-- the higher the polynomial degree
$n$ is, the safer our scheme is against attacks.

=== Halving the Plaintext Space To be Used
<subsec:tfhe-zero-padding>
Problematically, the LUT polynomial $V\(X\)$ rotates
#emph[negacyclically], that is, $V\(X\)dot.op X^n = - V\(X\)$ (i.e.,
coefficients flip their signs with the rotation period of $n$). More
generally:

$V\(X\)dot.op X^(- j) = V\(X\)dot.op X^(2 n - j) = V\(X\)dot.op X^(4 n - j) = dots.h.c$

$= V\(X\)dot.op X^(-\(j med mod med 2 n\)) = {v_j + v_(j + 1) X + dots.h.c\,upright("for ") 0 lt.eq i < n\
- v_j - v_(j - 1) X - dots.h.c\,upright("for ") n lt.eq j < 2 n$

$$

, where $v_j$ denotes the constant term's coefficient after rotating the
polynomial $V\(X\)$ by $j$ positions to the left. Problematically, $v_j$
flips its sign whenever its rotation crosses the boundary between $X^0$
and $X^(n - 1)$. Given the modulus-switched values $hat(a)_j$, $hat(e)$,
and $hat(b)$, we design the following LUT polynomial $V\(X\)$:

$$

\$V(X) = v\_0 + v\_1X^1 + v\_2X^2 + \\gap{\$\\cdots\$} + v\_{n-1}X^{n-1}\$

\$= m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_0} + m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_1} + m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_2} + \\gap{\$\\cdots\$} +  m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_{\\hat{\\Delta} - 1}}\$
$gt.tri$ total $hat(Delta)$ terms

\$+ \\text{ } m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_0} + m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_1} + m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_2} + \\gap{\$\\cdots\$} + m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_{\\hat{\\Delta} - 1}}\$
$gt.tri$ total $hat(Delta)$ terms

\$+ \\gap{\$\\cdots\$}\$

\$+ \\text{ } m\_{t/2 - 1}X^{\\hat{\\Delta} m\_{t/2 - 1} + \\hat{e}\_0} + m\_{t/2 - 1}X^{\\hat{\\Delta} m\_{t/2 - 1} + \\hat{e}\_1} + m\_{t/2 - 1}X^{\\hat{\\Delta} m\_{t/2 - 1} + \\hat{e}\_2} + \\gap{\$\\cdots\$} + m\_{t/2 - 1}X^{\\hat{\\Delta} m\_{t/2 - 1} + \\hat{e}\_{\\hat{\\Delta} - 1}}\$
$gt.tri$ total $hat(Delta)$ terms

$$

Remember that by computing $V\(X\)dot.op X^(- j)$ for
$j = { 0\,1\,dots.h.c\,n - 1 }$, we can rotate $V\(X\)$'s coefficients
to the left by ${ 0\,1\,dots.h.c n - 1 }$ positions. For each $j$-slot
rotation of $V\(X\)$ where $j = { 0\,1\,dots.h.c\,n - 1 }$, the rotated
polynomial $V'\(X\)$ gets the following values as the constant-term's
coefficient:

\$\\overbrace{\\overbrace{\\underbrace{\\Delta m\_0, \\Delta m\_0, \\gap{\$\\cdots\$}}\_{\\text{coeff. of } X^{\\hat{\\Delta}m\_0 + \\hat{e}\_\*}}}^{\\hat{\\Delta} \\text{ repetitions}} \\overbrace{\\underbrace{\\Delta m\_1, \\Delta m\_1, \\gap{\$\\cdots\$}}\_{\\text{coeff. of } X^{\\hat{\\Delta}m\_1 + \\hat{e}\_\*}}}^{\\hat{\\Delta} \\text{ repetitions}} \\gap{\$\\cdots\$} \\overbrace{\\underbrace{\\Delta m\_{{t}/{2}-1}, \\Delta m\_{{t}/{2}-1}, \\gap{\$\\cdots\$}}\_{\\text{coeff. of } X^{\\hat{\\Delta}m\_{{t}/{2}-1}+ \\hat{e}\_\*} }}^{\\hat{\\Delta} \\text{ repetitions}}}^{\\text{\$V\'(X)\$\'s constant term\'s coefficient for \$j = \\{0, 1, \\cdots n-1\\}\$ rotations}}\$

$$

In the above expression, $hat(e)_(*)$ is a noise that can range from
$\[0\,hat(Delta)\)$. Note that all of
$hat(Delta) m_i + hat(e)_0\,hat(Delta) m_i + hat(e)_1\,dots.h.c\,hat(Delta) m_i + hat(e)_(hat(Delta) - 1)$
exponents are designed to be mapped to the same coefficient value,
$m_i$, which aligns with the fact that their underlying plaintext $m_i$
is the same when decrypted (once their associated noise $hat(e)_(*)$
gets eliminated). This is why each $m_i$ is redundantly used
$hat(Delta)$ times in a row as coefficients in $V\(X\)$. We can view
this sequential repetition of coefficients as having a robustness of
mapping each $hat(Delta) m_i + hat(e)_(*)$ to $m_i$ against any noise
$hat(e)_(*) in bb(Z)_(hat(Delta))$.

So far, the above sequence of $m_0\,m_1\,dots.h.c\,m_(t\/2 - 1)$
coefficients is what we expect $V'\(X\)$ (i.e., the rotated polynomial)
to return as its constant term's coefficient for each of
$0\,1\,dots.h.c\,n - 1$ rotations (where each $m_i + 1 = m_(i + 1)$).
However, the correctness of the coefficient mappings breaks when the
rotation count is between $\[n\,2 n - 1\)$, because their coefficients
flip their signs when they cross the term's boundary from $X^0$ to
$X^(n - 1)$, due to the polynomial ring's negacyclic nature.
Specifically, the constant term's coefficient values of the rotated
polynomial $V'\(X\)$ are as follows for each rotation of
$n\,n + 1\,dots.h.c\,2 n - 1$ positions:

$$

\$\\overbrace{\\overbrace{\\underbrace{-m\_{0}, -m\_{0}, \\gap{\$\\cdots\$}}\_{-\\text{coeff. of } X^{\\hat{\\Delta}m\_{0} + \\hat{e}\_\*}}}^{\\hat{\\Delta} \\text{ repetitions}} \\overbrace{\\underbrace{-m\_{1}, -m\_{1}, \\gap{\$\\cdots\$}}\_{-\\text{coeff. of } X^{\\hat{\\Delta}m\_{1} + \\hat{e}\_\*}}}^{\\hat{\\Delta} \\text{ repetitions}} \\gap{\$\\cdots\$} \\overbrace{\\underbrace{-m\_{t/2 - 1}, -m\_{t/2 - 1}, \\gap{\$\\cdots\$}}\_{-\\text{coeff. of } X^{\\hat{\\Delta}m\_{t/2 - 1} + \\hat{e}\_\*} }}^{\\hat{\\Delta} \\text{ repetitions}}}^{\\text{\$V\'(X)\$\'s constant term\'s coefficient after each of \$n, n+1, \\cdots 2n-1\$ rotations}}\$

$$

As we can see above, the rotated $V'\(X\)$'s constant term's coefficient
shows a negacyclic pattern with the rotation period of $n$, where the
second $n$-rotation group's coefficients are exactly the negated values
of the first $n$-rotation group's values. Let's understand why this
negacyclic behavior breaks the (exponent, coefficient) =
$\(hat(Delta) m + hat(e)\,m\)$ mappings. Since TFHE's plaintext and
ciphertext values are defined in rings, as we rotate the LUT polynomial
$V\(X\)$, we ideally want the rotated polynomial $V'\(X\)$'s constant
term's value (i.e., mapped plaintext value) to wrap around in a circular
manner, representing a ring pattern (with sequential $hat(Delta)$
repetitions of each value to be resistant against up to a
$hat(e)_(*) in Z_(hat(Delta))$ noise). However, the negacyclic nature of
a polynomial ring makes the constant term's value of the second-half
rotation group problematic, because they are exact negations of those of
the first-half rotation group, breaking the circular wrapping-around
ring pattern between the first-group values and the second-group values.

To summarize the problem, $V\(X\)$ has a limitation in becoming a
perfect LUT, because it preserves the correct mappings of (exponent,
coefficient) = $\(hat(Delta) m + hat(e)\,m\)$ only for one half of
$i in bb(Z)_t$, not for the other half.

Good news is that we have observed that $V\(X\)$'s mappings of
(exponent, coefficient) = $\(hat(Delta) m + hat(e)\,Delta m\)$ preserve
their ring-pattern consistency if $V\(X\)$ is rotated no more than
$n - 1$ positions (i.e., the first-half rotation group). Therefore, the
easiest solution to avoid the negacyclic problem of the LUT polynomial
rotation is that the application of TFHE restricts $V\(X\)$ to be
rotated no more than $n - 1$ positions #emph[by design] during the noise
bootstrapping. To enforce this, when the TFHE application's computation
pipeline processes plaintext values (in its original plaintext
computation logic before considering any homomorphic operations), the
application should ensure to involve only some pre-defined contiguous
$t / 2$ modulo values within $bb(Z)_t$ as the possible inputs and
outputs of each computation step. This constraint effectively ensures
the possible values of $hat(Delta) m + hat(e)$ to be contiguous $n$
values within $bb(Z)_(2 n)$. Since the LUT polynomial $V\(X\)$ gets
rotated by computing $V\(X\)dot.op X^(-\(hat(Delta) m + hat(e)\))$, as
the application restricts $hat(Delta) m + hat(e)$ to be at most $n - 1$
(out of $2 n - 1$) by its application design, $V\(X\)$ will be rotated
at most $n - 1$ positions during the noise bootstrapping. Thus, we can
prevent the occurrences of the problematic
\$\\{n, n+1, \\gap{\$\\cdots\$}, 2n -1 \\}\$ rotations that flip the
signs of coefficients.

To summarize, at the cost of halving the application's usable plaintext
values to some contiguous $t / 2$ values within $bb(Z)_t$, we can
prevent $V\(X\)$'s negacyclic rotation problem, and thereby preserve
$V\(X\)$'s correct mappings of (exponent, coefficient) =
$\(hat(Delta) m + hat(e)\,m\)$.

Considering all these, our final LUT polynomial $V\(X\)$ is as follows:

#block[
$$

\$V(X) = v\_0 + v\_1X^1 + v\_2X^2 + \\gap{\$\\cdots\$} + v\_{n-1}X^{n-1}\$

\$= m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_0} + m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_1} + m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_2} + \\gap{\$\\cdots\$} + m\_0X^{\\hat{\\Delta} m\_0 + \\hat{e}\_{\\hat{\\Delta} - 1}}\$

\$+ \\text{ } m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_0} + m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_1} + m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_2} + \\gap{\$\\cdots\$} + m\_1X^{\\hat{\\Delta} m\_1 + \\hat{e}\_{\\hat{\\Delta} - 1}}\$

\$+ \\gap{\$\\cdots\$}\$

$+ m_(t\/2 - 1) X^(hat(Delta) m_(t\/2 - 1) + hat(e)_0) + m_(t\/2 - 1) X^(hat(Delta) m_(t\/2 - 1) + hat(e)_1) + m_(t\/2 - 1) X^(hat(Delta) m_(t\/2 - 1) + hat(e)_2)$

\$+ \\gap{\$\\cdots\$} + m\_{{t}/{2} - 1}X^{\\hat{\\Delta} m\_{{t}/{2} - 1} + \\hat{e}\_{\\hat{\\Delta} - 1}}\$

$$

, where $hat(Delta) = Delta dot.op frac(2 n, q) = frac(2 n, t)$. The
application should ensure that $m_0\,m_1\,dots.h.c\,m_(t\/2 - 1)$ are
some contiguous modulo-$t / 2$ values in $bb(Z)_t$. This constraint
ensures $V\(X\)$'s rotation positions $hat(Delta) m_i + hat(e)_(*)$
(where $e_(*) in bb(Z)_(hat(Delta))$) to be most $n$ contiguous
possibilities, preventing $V\(X\)$ from making more than 1 full-cycle
rotation that triggers a negacyclic problem.

]
Another name for the LUT polynomial $V\(X\)$ is an accumulator.

=== Blind Rotation
<subsec:bootstrapping-blind-rotation>
Blind rotation refers to rotating the coefficients of an
#emph[encrypted] polynomial so that it is not possible to know how many
positions the polynomial's coefficients have been rotated. After the
rotation, it is not possible to see which coefficient has moved to which
degree term. Blind rotation uses the basic polynomial rotation method 1
technique (Summary~@subsec:coeff-rotation in
#link(<subsec:coeff-rotation>)[\[subsec:coeff-rotation\]]), with the
difference that the $V\(X\)dot.op X^(- i)$ computation is done
homomorphically.

Note that
$X^(hat(Delta) m + hat(e)_b) = X^(hat(b) - sum_(i = 0)^(k - 1) hat(a)_i s_i)$,
so we can rotate $V$ by computing
$V dot.op X^(-\(hat(b) - sum_(i = 0)^(k - 1) hat(a)_i s_i\)) = V dot.op X^(- hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i)$.
In fact, we cannot directly compute the LWE decryption formula
$- hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i$ (or
$hat(b) - sum_(i = 0)^(k - 1) hat(a)_i s_i$) without the knowledge of
the LWE secret key $S$. Nevertheless, there is a mathematical
work-around to compute
$V dot.op X^(- hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i)$ without the
knowledge of the secret key $S$, provided we are given
${ G G S W_(arrow(S)_(b k)\,sigma)^(beta\,l)\(s_i\)}_(i = 0)^(k - 1)$ at
the TFHE setup stage. Note that
${ G G S W_(arrow(S)_(b k)\,sigma)^(beta\,l)\(s_i\)}_(i = 0)^(k - 1)$ is
a GGSW encryption of the LWE secret key $S$, encrypted by the GLWE
secret key $arrow(S)_(b k)$ (i.e., a #emph[bootstrapping] key). We use
$arrow(S)_(b k)$ to homomorphically compute
$V dot.op X^(- hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i)$ (i.e.,
blindly rotate the coefficients of $V$ to the left by
$hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i$ positions), according to the
following procedure:

+ GLWE-encrypt the polynomial $V$ with the bootstrapping key
  $arrow(S)_(b k)$ at the TFHE setup stage, so that each coefficient of
  $V$ gets encrypted.

+ Compute $V_0 = V dot.op X^(- hat(b))$, which is basically rotating
  $V$'s polynomials by $hat(b)$ positions to the left. Since $hat(b)$ is
  a known value visible in the LWE ciphertext, we can directly compute
  the rotation of $V_0 = V dot.op X^(- hat(b))$.

+ Compute
  $V_1 = V_0 dot.op X^(hat(a)_0 s_0) = s_0 dot.op\(V_0 dot.op X^(hat(a)_0) - V_0\)+ V_0$.
  This formula works for the special case where $s_0 in { 0\,1 }$: if
  $s_0 = 0$, then $V_1 = V_0$\; else if $s_0 = 1$, then
  $V_1 = V_0 dot.op X^(hat(a)_0)$. Computing
  $s_0 dot.op\(V_0 dot.op X^(hat(a)_0) - V_0\)+ V_0$ is done as a TFHE
  homomorphic addition and multiplication. We call this blind rotation
  of $V_0$, where the selection bit $s_0$ (i.e., the 1st element of the
  secret key vector $S$) is encrypted as a GGSW ciphertext by using
  $arrow(S)_(b k)$ (i.e. the bootstrapping key) and $V_0$ is an
  encrypted polynomial as a GLWE ciphertext. Multiplying GLWE-encrypted
  $V_0$ with $x^(hat(a)_0)$ is done by GLWE ciphertext-to-plaintext
  multiplication
  (#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]), and
  subtracting the result by GLWE-encrypted $V_0$ is done by GLWE
  ciphertext-to-ciphertext addition/subtraction
  (#link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]), and
  multiplying the result by GGSW-encrypted $s_0$ is done by GLWE-to-GGSW
  multiplication
  (#link(<subsubsec:tfhe-glwe-to-ggsw-multiplication>)[0.6.1]), and
  adding the result with GLWE-encrypted $V_0$ is done by GLWE
  ciphertext-to-ciphertext addition. If $s_0 = 1$, then the formula's
  $X^(hat(a)_0)$ term gets multiplied to $V_0$, which effectively
  rotates $V_0$'s coefficients by $hat(a)_0$ positions to the right.
  Else if $s_0 = 0$, then $V_0$ does not get rotated and stays the same.
  In both cases, the resulting $V_1$ is encrypted as a new GLWE
  ciphertext. During this blind rotation, unless we have the knowledge
  of $s_0$ and $arrow(S)_(b k)$, it is impossible to know whether $V_0$
  has been rotated or not, and also how many positions have been
  rotated.

+ By using the same blind rotation method as in the previous step,
  compute the GLWE encryption of
  $V_2 = V_1 dot.op X^(hat(a)_1 s_1) = s_1 dot.op\(V_1 dot.op X_1^(hat(a)) - V_1\)+ V_1$.
  Note that we have the following publicly known components: $hat(a)_1$,
  a GLWE encryption of $V_1$, and a GGSW ciphertext of $s_1$ encrypted
  by using $arrow(S)_(b k)$.

+ Continue to compute the GLWE encryption of
  \$V\_3, V\_4, \\gap{\$\\cdots\$}, V\_k\$ in the same manner, and we
  finally get a GLWE encryption of $V_k$, whose computed value is
  equivalent to:

  $V' = V_k$

  $upright(" ") = V_(k - 1) dot.op X^(hat(a)_(k - 1) s_(k - 1))$

  $upright(" ") = V_0 dot.op X^(hat(a)_0 s_0) X^(hat(a)_1 s_1) dots.h.c X^(hat(a)_(k - 1) s_(k - 1))$

  $upright(" ") = V dot.op X^(- hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i)$

  $upright(" ") = V dot.op X^(-\(hat(Delta) m + hat(e)_b\))$

This means that the GLWE encryption of the final polynomial $V_k$ will
have the coefficient $m$ in its constant term, as $V\(X\)$ is designed
to have the mapping ($hat(Delta) m + hat(e)_(*)\,m$).

Note that while we restrict the application's plaintext space usage to
some contiguous $t / 2$ modulo values within $bb(Z)_t$
(#link(<subsec:tfhe-zero-padding>)[0.8.3]), this restriction does not
exist in the ciphertext space. That is, it is acceptable for blind
rotations to rotate $V\(X\)$ more than $n$ positions during the
intermediate steps because their invalid positions can be brought back
to valid ones by subsequent steps. Therefore, what matters for the noise
bootstrapping correctness is only the completed state $V_k\(X\)$. The
rotation-completed $V_k\(X\)$ must have been rotated
$hat(Delta) m + hat(e)$ positions to the left. Therefore, we only need
to ensure that $hat(Delta) m + hat(e)$ falls within our pre-defined
contiguous $t / 2$ modulo range within the $bb(Z)_t$ domain, which is
equivalent to ensuring that the aggregate rotation count is at most
$n - 1$ positions to avoid the extraction of any double-signed
contradicting coefficients.

#figure(image("figures/mux.pdf", width: 20.0%),
  caption: [
    An illustration of the MUX logic gate
  ]
)
<fig:mux>

In step 3, the formula
$s_0 dot.op\(V_0 dot.op X^(hat(a)_0) - V_0\)+ V_0$ implements the MUX
logic gate as shown in #link(<fig:mux>)[1], where in our case $s_0$ is
the selection bit that chooses between the two inputs: $V_0$ and
$V_0 dot.op X^(hat(a)_0)$. If $s_0$ is 1, then the output is
$V_0 dot.op X^(hat(a)_0)$\; otherwise, the output is $V_0$. In our
design, the homomorphic computation of
$s_0 dot.op\(V_0 dot.op X^(hat(a)_0) - V_0\)+ V_0$ effectively
implements a homomorphic MUX gate, where the two inputs are
LWE-encrypted and the selection bit is GGSW-encrypted.

The GLWE ciphertext that encrypts the LUT polynomial $V\(X\)$ has a
$k' times n$ dimension, where $k'$ is the length of $arrow(A)$ (i.e.,
the number of public mask polynomials) and $n$ is the polynomial degree
of $A\,B\,$ and $V$. The dimension of the GGSW ciphertext that encrypts
each element of $arrow(S)_(italic("bk"))$ (i.e., each coefficient of the
bootstrapping key polynomials) is $\(k' + 1\)times l times\(k' + 1\)$.
In practice, we let $k' = 1$, which simplifies these ciphertexts as RLWE
and RGSW ciphertexts. The reason we set $k' = 1$ is for computational
efficiency.

=== Coefficient Extraction
<coefficient-extraction>
Next, we use the coefficient extraction technique
(#link(<subsec:tfhe-extraction>)[0.7]) to extract the constant term's
coefficient of the rotated polynomial $V'\(X\)$' as an encryption of
$m$: $sans("LWE")_(arrow(s)'\,sigma)\(Delta m\)$, where $arrow(s)'$ is a
vector of length $k' dot.op n$. At this point, the original
$sans("LWE")$ ciphertext's old noise $hat(e)_b$ has disappeared, and the
bootstrapped new ciphertext $sans("LWE")_(arrow(s)'\,sigma)\(Delta m\)$
has newly generated small noise $e_s$.

In fact, the homomorphic MUX logic in the blind rotation procedure
(#link(<subsec:bootstrapping-blind-rotation>)[0.8.4]) involves numerous
ciphertext multiplications and additions, which can accumulate
additional noise until we reach the point of coefficient extraction. To
limit the accumulating noise during the series of MUX logic operations,
we can carefully adjust the security parameters. For example, we can
design a narrower Gaussian distribution for sampling the noise $e$,
while designing a sufficiently large $n$ to compensate for the reduced
noise. Meanwhile, increasing $q$ can make the system less secure because
it becomes more vulnerable to lattice reduction attacks.

=== Key Switching
<subsec:bootstrapping-key-switch>
The output of the key extraction is
$sans("LWE")_(arrow(s)'\,sigma)\(Delta m\)$, which is encrypted by a
secret key $arrow(s)'$ whose length is $k' dot.op n$. For consistency,
we need to switch its key from $arrow(s)' arrow.r arrow(s)$, where
$arrow(s)$ is our original $k$-length key. This key switching can be
done by using the technique explained in
Summary~@subsec:tfhe-key-switching (in
#link(<subsec:tfhe-key-switching>)[0.5]).

=== Noise Bootstrapping Summary
<subsec:tfhe-summary>
TFHE's noise bootstrapping procedure is summarized as follows:

#block[
#strong[#underline[Lookup Table Encryption]:] Encrypt the LUT polynomial
$V\(X\)$ as a GLWE ciphertext by using the bootstrapping key
$arrow(S)_(b k)$ whose length is $k'$.

+ #strong[#underline[Modulus Switch]:] Change the modulus of the TFHE
  ciphertext $sans("LWE")_(arrow(s)\,sigma)\(Delta m + e_b\)$ from
  $q arrow.r 2 n$ to get
  $sans("LWE")_(arrow(s)\,sigma)\(hat(Delta) m + hat(e)_b\)$, where
  $hat(Delta) = Delta dot.op frac(2 n, q) = frac(2 n, t)$.

  $$

+ #strong[#underline[Blind Rotation]:] Rotate the GLWE-encrypted
  polynomial $V$ by
  $\(hat(b) - sum_(i = 0)^(k - 1) hat(a)_i s_i\)=\(hat(Delta) m + hat(e)_b\)$
  positions to the left, by recursively computing:

  $V_0 = V dot.op X^(- hat(b))$

  $V_1 = V_0 dot.op X^(hat(a)_0 s_0) = s_0 dot.op\(V_0 dot.op X^(hat(a)_0) - V_0\)+ V_0$

  $dots.v$

  $V_k = V_(k - 1) dot.op X^(hat(a)_(k - 1) s_(k - 1)) = s_(k - 1) dot.op\(V_(k - 1) dot.op X^(hat(a)_(k - 1)) - V_(k - 1)\)+ V_(k - 1)$

  $= V_0 dot.op X^(hat(a)_0 s_0) X^(hat(a)_1 s_1) dots.h.c X^(hat(a)_(k - 1) s_(k - 1))$

  $= V dot.op X^(- hat(b) + sum_(i = 0)^(k - 1) hat(a)_i s_i)$

  $= V dot.op X^(-\(hat(Delta) m + hat(e)_b\))$

  $$

  Each step of the actual blind rotation above is computed as the
  following TFHE ciphertext-to-ciphertext multiplication and addition:

  $sans("GLWE")_(arrow(S)_(b k)\,sigma)\(V_(i + 1)\)= sans("GGSW")_(arrow(S)_(b k)\,sigma)^(beta\,l)\(s_i\)dot.op\(sans("GLWE")_(arrow(S)_(b k)\,sigma)\(V_i\)dot.op X^(hat(a)_i) - sans("GLWE")_(arrow(S)_(b k)\,sigma)\(V_i\)\)+ sans("GLWE")_(arrow(S)_(b k)\,sigma)\(V_i\)$

  $$

+ #strong[#underline[Coefficient Extraction]:] Homomorphically extract
  the constant term's coefficient $m$ from the rotated polynomial $V_k$,
  which is $sans("LWE")_(arrow(s)'\,sigma)\(Delta m\)$, where
  $arrow(s)'$ is a vector of length $k' dot.op n$.

  $$

+ #strong[#underline[Key Switching]:] Homomorphically switch the key of
  the LWE ciphertext from $arrow(s)' arrow.r arrow(s)$.

$$

Problematically, the LUT polynomial V rotates negacyclically. To avoid
this problem, we require the application to ensure that the plaintext
$m$ uses only contiguous $t / 2$ modulo values within $bb(Z)_t$. This
way, we avoid rotating $V\(X\)$ more than $n - 1$ positions that cause
coefficient extraction of double-signed contradicting coefficients.

$$

For computational efficiency, $k'$ is set to be 1, which simplifies the
GLWE and GGSW ciphertexts as RLWE and RGSW ciphertexts.

]
=== Example: Noise Bootstrapping
<subsec:tfhe-noise-bootstrapping-ex>
Suppose the GLWE security setup: $n = 16$, $t = 8$, $q = 64$, $k = 8$

$bb(Z)_(t = 8) = { - 4\,- 3\,- 2\,- 1\,0\,1\,2\,3 }$

\$\\mathbb{Z}\_{q=64} = \\{ -32, -31, -30, \\gap{\$\\cdots\$}, 29, 30, 31 \\}\$

$Delta = q / t = 64 / 8 = 8$

$$

And suppose we have the following LWE ciphertext:

$arrow(s) =\(1\,0\,0\,1\,1\,1\,0\,1\)= bb(Z)_2^(k = 8)$

$m = 1 in bb(Z)_(t = 8)$

$Delta m = 1 dot.op 8 = 8 in bb(Z)_(q = 64)$

$sans("LWE")_(arrow(s)\,sigma)\(Delta m\)=\(a_0\,a_1\,a_2\,a_3\,a_4\,a_5\,a_6\,a_7\,b\)=\(8\,- 28\,4\,- 32\,0\,31\,- 6\,7\,24\)in bb(Z)_(q = 64)^(k + 1 = 9)$

$e = 2 in bb(Z)_(q = 64)$ (should be the case that
$\|e\|< Delta / 2 = 4$ for correct decryption)

$b = sum_(i = 0)^7 a_i s_i + Delta m + e =\(8 - 32 + 31 + 7\)+ 8 + 2 = 24 in bb(Z)_(q = 64)$

$$

Now then, the TFHE noise bootstrapping procedure is as follows:

$$

+ #strong[Modulus Switch:] Switch the modulus of
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$ From $q arrow.r 2 n$, which
  is from $64 arrow.r 32$. After the modulus switch, the original LWE
  ciphertext is converted as follows:

  \$\\mathbb{Z}\_{2n=32} = \\{-16, -15, -14, \\gap{\$\\cdots\$}, 13, 14, 15\\}\$

  $arrow(s) =\(1\,0\,0\,1\,1\,1\,0\,1\)= bb(Z)_2^(k = 8)$

  $hat(Delta) = Delta frac(2 n, 64) = 8 32 / 64 = 4$

  $hat(Delta) m = 4 dot.op 1 = 4 in bb(Z)_(2 n = 32)$

  $hat(e) = ⌈e frac(2 n, q)⌋ = ⌈2 32 / 64⌋ = 1 in bb(Z)_(2 n = 32)$

  $$

  $sans("LWE")_(arrow(s)\,sigma)\(hat(Delta) m\)=\(hat(a)_0\,hat(a)_1\,hat(a)_2\,hat(a)_3\,hat(a)_4\,hat(a)_5\,hat(a)_6\,hat(a)_7\,hat(b)\)in bb(Z)_(2 n = 32)^(k + 1 = 9)$

  $=\(#scale(x: 180%, y: 180%)[ceil.l] 8 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] - 28 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] 4 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] - 32 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] 0 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] 31 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] - 6 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] 7 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\,#scale(x: 180%, y: 180%)[ceil.l] 24 32 / 64 #scale(x: 180%, y: 180%)[floor.r]\)$

  $$

  $=\(4\,- 14\,2\,- 16\,0\,16\,- 3\,4\,12\)$

  $$

  Note that
  $sum_(i = 0)^7\(hat(a)_i s_i\)+ hat(Delta) m + hat(e) =\(4 - 16 + 16 + 4\)+ 4 + 1 = 13 in bb(Z)_(2 n = 32)$

  $$

  $hat(b) = 12 approx 13 = sum_(i = 0)^7\(hat(a)_i s_i\)+ hat(Delta) m + hat(e)$

  This small difference in $hat(b)$ comes from the aggregated noises of
  rounding $hat(a)_0\,hat(a)_1\,dots.h.c\,hat(e)$ during the modulus
  switch.

  $$

+ #strong[Blind Rotation:] We assume that the application avoids the
  problem of negacyclic polynomial rotation by ensuring that the usable
  plaintext values are the following contiguous $8 / 2$ modulo values
  within $bb(Z)_8 = { - 4\,- 3\,- 2\,- 1\,0\,1\,2\,3 }$, which are
  ${ - 2\,- 1\,0\,1 }$. This implies that the only possible values of
  $i = hat(Delta) m + hat(e)$ in $V\(X\)dot.op X^i$ will be:
  $i = { - 8\,- 7\,dots.h.c\,6\,7 }$. Based on these requirements,
  #link(<tab:lut>)[1] is the Lookup Table polynomial $V\(X\)$ that maps
  $hat(Delta) m + hat(e)$ to $Delta m$.

  #block[
  #figure(
    align(center)[#table(
      columns: 11,
      align: (center,center,center,center,center,center,center,center,center,center,center,),
      table.cell(align: left, colspan: 10)[$V\(X\)= v_0 + v_1 X + v_2 X^2 + v_3 X^3 + v_4 X^4 + v_5 X^5 + v_6 X^6 + v_7 X^7$], [],
      table.cell(align: left, colspan: 10)[\......
      $+ v_8 X^8 + v_9 X^9 + v_10 X^10 + v_11 X^11 + v_12 X^12 + v_13 X^13 + v_14 X^14 + v_15 X^15$], [],
      table.cell(align: left, colspan: 10)[\....$= 0 + 0 X + 0 X^2 + 0 X^3 + 1 X^4 + 1 X^5 + 1 X^6 + 1 X^7$], [],
      table.cell(align: left, colspan: 10)[\......$+ 2 X^8 + 2 X^9 + 2 X^10 + 2 X^11 + 1 X^12 + 1 X^13 + 1 X^14 + 1 X^15$], [],
      [#strong[$i = hat(Delta) m + hat(e)$]], [$- 8$], [$- 7$], [$- 6$], [$- 5$], [$- 4$], [$- 3$], [$- 2$], [$- 1$], [], [],
      [\(in
      $V dot.op X^(- i)$)], [\(\$\\textcolor{orange}{110}\\textcolor{green}{00}\_2\$)], [\(\$\\textcolor{orange}{110}\\textcolor{green}{01}\_2\$)], [\(\$\\textcolor{orange}{110}\\textcolor{green}{10}\_2\$)], [\(\$\\textcolor{orange}{110}\\textcolor{green}{11}\_2\$)], [\(\$\\textcolor{orange}{111}\\textcolor{green}{00}\_2\$)], [\(\$\\textcolor{orange}{111}\\textcolor{green}{01}\_2\$)], [\(\$\\textcolor{orange}{111}\\textcolor{green}{10}\_2\$)], [\(\$\\textcolor{orange}{111}\\textcolor{green}{11}\_2\$)], [], [],
      [#strong[constant
      term's]], [$- 2$], [$- 2$], [$- 2$], [$- 2$], [$- 1$], [$- 1$], [$- 1$], [$- 1$], [], [],
      [#strong[coeff. of
      $V dot.op X^(- i)$]], [\$\\textcolor{orange}{110}\_2\$], [\$\\textcolor{orange}{110}\_2\$], [\$\\textcolor{orange}{110}\_2\$], [\$\\textcolor{orange}{110}\_2\$], [\$\\textcolor{orange}{111}\_2\$], [\$\\textcolor{orange}{111}\_2\$], [\$\\textcolor{orange}{111}\_2\$], [\$\\textcolor{orange}{111}\\textcolor{green}{00}\_2\$], [], [],
      [#strong[$bold(m)$
      (plaintext)]], [$- 2$], [$- 2$], [$- 2$], [$- 2$], [$- 1$], [$- 1$], [$- 1$], [$- 1$], [], [],
      [#strong[$i = hat(Delta) m + hat(e)$]], [$0$], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$], [$7$], [], [],
      [\(in
      $V dot.op X^(- i)$)], [\(\$\\textcolor{orange}{000}\_2\$)], [\(\$\\textcolor{orange}{000}\_2\$)], [\(\$\\textcolor{orange}{000}\_2\$)], [\(\$\\textcolor{orange}{000}\_2\$)], [\(\$\\textcolor{orange}{001}\_2\$)], [\(\$\\textcolor{orange}{001}\_2\$)], [\(\$\\textcolor{orange}{001}\_2\$)], [\(\$\\textcolor{orange}{001}\_2\$)], [], [],
      [#strong[constant
      term's]], [$0$], [$0$], [$0$], [$0$], [$1$], [$1$], [$1$], [$1$], [], [],
      [#strong[coeff. of
      $V dot.op X^(- i)$]], [\$\\textcolor{orange}{000}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{000}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{000}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{000}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{001}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{001}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{001}\\textcolor{green}{00}\_2\$], [\$\\textcolor{orange}{001}\\textcolor{green}{00}\_2\$], [], [],
      [#strong[$bold(m)$
      (plaintext)]], [$0$], [$0$], [$0$], [$0$], [$1$], [$1$], [$1$], [$1$], [], [],
    )]
    , caption: [The Lookup Table for $n = 16\,q = 64\,t = 8$ LWE setup.
    Orange is the plaintext $m$'s bits. Green is the noise $e$'s bits. ]
    , kind: table
    )

  ] <tab:lut>
  Note that $V\(X\)$'s coefficients for the $X^8 tilde.op X^15$ terms
  are ${ 2\,1 }$ instead of ${ - 2\,- 1 }$, so that if $V$ gets rotated
  by ${ - 8\,- 7\,- 6\,- 5\,4\,5\,6\,7 }$ slots to the left, the
  constant term's coefficient flips its sign to ${ - 2\,- 1 }$ due to
  wrapping around the boundary of the $n$ exponent.

  During the actual bootstrapping, we will do a blind rotation of
  #link(<tab:lut>)[1]'s $V\(X\)$ (which is GLWE-encrypted) by
  $hat(b) - sum_(i = 0)^7 hat(a)_i s_i = 4$ positions to the left, which
  is computed as follows:

  $hat(Delta) m + hat(e) = hat(b) - sum_(i = 0)^7 hat(a)_i s_i = 12 -\(4 - 16 + 16 + 4\)= 4 upright(" mod 32") in bb(Z)_(2 n = 32)$

  In #link(<tab:lut>)[1], if the rotation count $i = 4$, the
  corresponding constant term's coefficient is $v_4 = 1 = m$. As
  $Delta = 4$, we finally get
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)= 1$.

  $$

  The actual blind rotation is computed as follows:

  $arrow(s) =\(1\,0\,0\,1\,1\,1\,0\,1\)$

  $sans("LWE")_(arrow(s)\,sigma)\(hat(Delta) m\)=\(hat(a)_0\,hat(a)_1\,hat(a)_2\,hat(a)_3\,hat(a)_4\,hat(a)_5\,hat(a)_6\,hat(a)_7\,hat(b)\)=\(4\,- 14\,2\,- 16\,0\,16\,- 3\,4\,12\)$

  $V_0 = V dot.op X^(- hat(b)) = V dot.op X^(- 12) = v_12 + v_13 X + v_14 X^2 + dots.h.c$

  $V_1 = V_0 dot.op X^(hat(a)_0 s_0) = s_0 dot.op\(V_0 dot.op X^(hat(a)_0) - V_0\)+ V_0 = V_0 dot.op X^4 = v_8 + v_9 X + v_10 X^2 + dots.h.c$

  $V_2 = V_1 dot.op X^(hat(a)_1 s_1) = s_1 dot.op\(V_1 dot.op X^(hat(a)_1) - V_1\)+ V_1 = V_1 = v_8 + v_9 X + v_10 X^2 + dots.h.c$

  $V_3 = V_2 dot.op X^(hat(a)_2 s_2) = s_2 dot.op\(V_2 dot.op X^(hat(a)_2) - V_2\)+ V_2 = V_2 = v_8 + v_9 X + v_10 X^2 + dots.h.c$

  $V_4 = V_3 dot.op X^(hat(a)_3 s_3) = s_3 dot.op\(V_3 dot.op X^(hat(a)_3) - V_3\)+ V_3 = V_3 dot.op X^(- 16) = - v_8 - v_9 X - v_10 X^2 - dots.h.c$

  $V_5 = V_4 dot.op X^(hat(a)_4 s_4) = s_4 dot.op\(V_4 dot.op X^(hat(a)_4) - V_4\)+ V_4 = V_4 dot.op X^0 = - v_8 - v_9 X - v_10 X^2 - dots.h.c$

  $V_6 = V_5 dot.op X^(hat(a)_5 s_5) = s_5 dot.op\(V_5 dot.op X^(hat(a)_5) - V_5\)+ V_5 = V_5 dot.op X^16 = v_8 + v_9 X + v_10 X^2 + dots.h.c$

  $V_7 = V_6 dot.op X^(hat(a)_6 s_6) = s_6 dot.op\(V_6 dot.op X^(hat(a)_6) - V_6\)+ V_6 = V_6 = v_8 + v_9 X + v_10 X^2 + dots.h.c$

  $V_8 = V_7 dot.op X^(hat(a)_7 s_7) = s_7 dot.op\(V_7 dot.op X^(hat(a)_7) - V_7\)+ V_7 = V_7 dot.op X^4 = v_4 + v_5 X + v_6 X^2 + dots.h.c$

  $$

  The final output of blind rotation is the GLWE ciphertext of $V_8$,
  $sans("GLWE")_(arrow(S)\,sigma)\(V_8\)$, whose constant term's
  coefficient is $v_4 = m = 1$.

  $$

  Each step of the actual blind rotation above is computed as the
  following TFHE ciphertext-to-ciphertext multiplication:

  $sans("GLWE")_(arrow(S)\,sigma)\(V_(i + 1)\)= sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(s_i\)dot.op\(sans("GLWE")_(arrow(S)\,sigma)\(V_i\)dot.op X^(hat(a)_i) - sans("GLWE")_(arrow(S)\,sigma)\(V_i\)\)+ sans("GLWE")_(arrow(S)\,sigma)\(V_i\)$

  $$

  We will leave this computation for the reader's exercise.

  $$

+ #strong[Coefficient Extraction:] At the end of blind rotation, we
  finally get the following GLWE ciphertext:

  $sans("GLWE")_(arrow(S)\,sigma)\(V_8\)$

  $= sans("GLWE")_(arrow(S)\,sigma) bold(\() hat(Delta) dot.op\(v_4 + v_5 X + v_6 X^2 + v_7 X^3 + v_8 X^4 + v_9 X^5 + v_10 X^6 + v_11 X^7 + v_12 X^8 + v_13 X^9 + v_14 X^10 + v_15 X^11 - v_0 X^12 - v_1 X^13 - v_2 X^14 - v_3 X^15\)bold(\))$

  $= sans("GLWE")_(arrow(S)\,sigma) bold(\() hat(Delta) dot.op\(1 + 1 X + 1 X^2 + 1 X^3 + 2 X^4 + 2 X^5 + 2 X^6 + 2 X^7 + 1 X^8 + 1 X^9 + 1 X^10 + 1 X^11 - 0 X^12 - 0 X^13 - 0 X^14 - 0 X^15\)bold(\))$

  $= (A_0 = sum_(j = 0)^15 \( a_(0\,0) + a_(0\,1) X + dots.h.c \) \, A_1 = dots.h.c \, A_(k - 1) = dots.h.c \, B = sum_(j = 0)^15 b_j X^j)$

  Now, we extract the constant term's coefficient of the encrypted
  polynomial
  $sans("GLWE")_(arrow(S)\,sigma)\(hat(Delta) dot.op\(1 + 1 X + 1 X^2 + dots.h.c\)\)$
  by using the coefficient extraction formula
  (Summary~@subsec:tfhe-extraction). Specifically, we will extract the
  constant term's coefficient, which corresponds to
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m_0\)$. We extract
  $sans("LWE")_(arrow(s)\,sigma)\(Delta m_0\)$ by computing the
  following:

  \$\\textsf{LWE}\_{\\vec{s}, \\sigma}(\\Delta m\_0) = (a\_0\', a\_1\', \\gap{\$\\cdots\$} , a\_{nk-1}\', b\_h)\$
  $gt.tri$ where $h = 0$

  $ upright(", where ") a'_(n dot.op i + j) = {a_(i\,0 - j) upright(" (if ") 0 lt.eq j lt.eq 0 upright(")")\
  - a_(i\,n + 0 - j) upright(" (if ") 0 + 1 lt.eq j lt.eq n - 1 upright(")")\
  \,b_0 upright(" is obtained from the polynomial ") B $

=== Discussion
<subsec:tfhe-noise-bootstrapping-discussion>
- #strong[Programmable Bootstrapping]: While the bootstrapping
  (#link(<subsec:tfhe-noise-bootstrapping>)[0.8]) uses a simple Lookup
  Table $V\(X\)$ which maps $Delta m + e$ to $Delta m$, we can edit the
  coefficients of $V\(X\)$ to make $Delta m + e$ map to different
  values. For example, an altered mappings between the inputs and
  outputs to LUT can implement logic gates such as AND, OR, XOR, CMUX,
  etc, which will be explained in
  #link(<subsec:tfhe-noise-bootstrapping-gate>)[0.8.10]. Such edited
  mappings between the exponents and coefficients in $V\(X\)$ are called
  programmable bootstrapping. If we encrypt $V\(X\)$ as a GLWE
  ciphertext, we can hide the mappings as well as each input instance,
  which effectively implements #emph[functional encryption]. Note that
  both the vanilla bootstrapping
  (#link(<subsec:tfhe-noise-bootstrapping>)[0.8]) and programmable
  bootstrapping (#link(<subsec:tfhe-noise-bootstrapping-gate>)[0.8.10])
  generate the same amount of noise.

- #strong[Bootstrapping Noise]: During the bootstrapping's LUT
  polynomial $V\(X\)$ rotation, we perform many TFHE multiplications in
  the homomorphic MUX gates to derive $V_0 dots.h.c V_k$, which
  inevitably creates additional noises before the noise gets
  re-initialized at the end. However, a careful parameter choice can
  limit the growth of this additional noise during modulus switch and
  blind rotation.

=== Application: Gate Bootstrapping
<subsec:tfhe-noise-bootstrapping-gate>
Besides implementing the homomorphic MUX logic gate used during blind
rotation (#link(<subsec:bootstrapping-blind-rotation>)[0.8.4]), it is
possible to leverage the LUT polynomial $V\(X\)$ to implement other
homomorphic logic gates such as AND, NAND, OR, XOR, etc. When
implementing these gates, each ciphertext is an encryption of a
single-bit plaintext (or several bits can be bundled up in a linear
combination formula and be processed simultaneously by using LUT).
Suppose $q = 32$, $t = 8$,
$m in bb(Z)_8 = { - 4\,- 3\,- 2\,- 1\,0\,1\,2\,3 }$,
$Delta = q / t = 4$, $hat(Delta) = frac(Delta dot.op 2 n, q) = 2$, and
we encode the gate input into LWE plaintext as $0 arrow.r - 1$, and
$1 arrow.r 1$, and the maximum (accumulated) noise $e =\[- 1\,1\]$.

#link(<tab:gate-and>)[\[tab:gate-and\]] is a programmable bootstrapping
design for an AND logic gate. For this application, we define the LUT
polynomial $V$ as $V\(X\)= sum_(i = 0)^7 X^i$. The LUT polynomial
$V\(X\)$ maps one half of the plaintext domain to $1$, while the other
half to $- 1$ (as the terms wrap around the boundary of $X^7$). In this
design setup, each bit is separately encrypted as independent TFHE
ciphertext. Gate inputs 0 and 1 are encoded as $- 1$ and $1$,
respectively. The linear combination (i.e., homomorphic computation
formula) for an AND gate is
$sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)+ sans("LWE")_(arrow(s)\,sigma)\(Delta m_2\)- 1$.
Its output is positive if both inputs are positive (i.e. $1$, in which
case the blind rotation will rotate $V$ to the left by
$hat(Delta) dot.op 1 + e$ positions and the constant term's coefficient
will be $1$. Thus, the output of blind rotation and coefficient
extraction will be $sans("LWE")_(arrow(s)\,sigma)\(Delta dot.op 1\)$
with a reduced noise, which is an encoding of $1$. This design can
tolerate the maximum noise of $\|e\|= 1$. To endure bigger noises, we
should increase $q$ and $n$.

Note that the AND gate's LUT layout is negacyclic, which is a special
case, thus we could use the entire $2 n = 16$ coefficient states in
$V\(X\)$ for the AND gate mapping function's outputs, by leveraging
$V\(X\)$'s innate property of negacyclic rotation. However, in many use
cases, the LUT layout is not necessarily negacyclic like this AND gate
example. Even our noise bootstrapping's LUT layout
(#link(<subsec:bootstrapping-overview>)[0.8.1]) was not negacyclic, but
a unity function (as it simply removes the noise). Thus, for most use
cases, we need to use only $t / 2$ out of $t$ plaintext space to avoid
more than $n - 1$ rotations of $V\(X\)$
(#link(<subsec:tfhe-zero-padding>)[0.8.3]).

Besides the AND gate, other logic gates can be built in a similar
manner, each of which is based on a different linear combination formula
and LUT layout.

TFHE does not support direct division of plaintext numbers of any size.
This is because TFHE's LWE vector elements are in the $Z_q$ ring, where
each element $g$ does not necessarily have a multiplicative inverse
$g^(- 1)$, which makes it hard to multiply $g^(- 1)$ to the target
number to divide. Instead, division can be implemented as binary
division based on the gates implemented by gate bootstrapping. To
support binary division, each plaintext has to be a single bit and
encrypted as an independent ciphertext. Or multiple bits can be bundled
up and processed concurrently by designing a linear combination formula,
similar to the linear combination that we designed for processing 2
input bits of an AND gate.

=== Application: Neural Networks Bootstrapping
<subsec:tfhe-neural-network>
#figure(image("figures/neural-network.pdf", width: 80.0%),
  caption: [
    An illustration of neural networks
  ]
)
<fig:neural-network>

#figure(image("figures/nn-homomorphic.pdf", width: 80.0%),
  caption: [
    An illustration of neural networks's programmable bootstrapping
  ]
)
<fig:neural-network2>

Homomorphic encryption can be applied to the neurons of deep neural
networks, in which each neuron is generally comprised of two steps of
computation:

+ #strong[Linear Combination of Input Values:] An input feature value
  (or intermediate value) set
  \$(x\_1, x\_2, \\gap{\$\\cdots\$}, x\_n)\$, a weight set
  \$(w\_1, w\_2, \\gap{\$\\cdots\$}, w\_n)\$, and a bias $b$ are
  computed as: $y = sum_(i = 1)^n x_i w_i + b$.

+ #strong[Activation Function:] $f\(y\)$ is computed, where $f$ is a
  non-linear activation function such as the $sin$ function, ReLU,
  sigmoid, hyperbolic tangent, etc.

TFHE can homomorphically compute the 1st step's linear combination
formula: $y = sum_(i = 1)^n x_i w_i + b$ as
$sum_(i = 1)^n sans("LWE")_(arrow(s)\,sigma)\(x_i\)dot.op w_i + b$,
which can be implemented as ciphertext addition
(#link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]) and
ciphertext-to-plaintext multiplication
(#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]).

However, the 2nd step's non-linear functions cannot be expressed as
addition and multiplication of ciphertexts. To address this issue, the
activation function can be evaluated as a programmable bootstrapping,
such that the output of the bootstrapping matches or (or is similar) to
the output of the activation function. If we use bootstrapping at the
2nd step, noises can be refreshed at the end of every neuron, thus we
can potentially handle neural networks of any depth without worrying
about the noise growth.

== TFHE on a Discrete Torus
<subsec:torus>
#strong[\- Reference:]
#link("https://eprint.iacr.org/2021/1402.pdf")[Guide to Fully Homomorphic Encryption over the \[Discretized\] Torus]~@torus

$$

Torus $bb(T)$ is a continuous real number domain between 0 and 1 that
wraps around, that is $\[0\,1\)$.

A discrete torus $bb(T)_t$ is a finite real number set:
\$\\Big(0, \\dfrac{1}{t}, \\dfrac{2}{t}, \\gap{\$\\cdots\$}, \\dfrac{t - 1}{t}\\Big)\$

In the previous subsections, we learned the TFHE scheme based on the
following setup:

$$

$m in bb(Z)_t$ $arrow(s) = { 0\,1 }^k$ $e in bb(Z)_q$

\$\\textsf{LWE}\_{\\vec{s}, \\sigma}(\\Delta m) = (a\_0, a\_1, \\gap{\$\\cdots\$}, a\_k, b) \\in \\mathbb{Z}\_t^{k + 1}\$

$$

However, the original TFHE scheme is designed based on a discrete torus:

$$

$m in bb(T)_t\,upright(" ") arrow(s) in { 0\,1 }^k\,upright(" ") e in bb(T)_q$

$$

\$\\textsf{LWE}\_{\\vec{s}, \\sigma}(m) = \\textsf{ct} = (a\_0, a\_1, \\gap{\$\\cdots\$}, a\_k, b) \\in \\mathbb{T}\_{q}^{k+1}\$

$b = sum_(i = 0)^k\(a_i s_i\)+ m + e in bb(T)_q$

$sans("LWE")_(arrow(s)\,sigma)^(- 1)\(sans("ct")\)= #scale(x: 180%, y: 180%)[ceil.l] b - sum_(i = 0)^(k - 1)\(a_i s_i\)#scale(x: 180%, y: 180%)[floor.r]_(1 / t) = #scale(x: 180%, y: 180%)[ceil.l] m + e #scale(x: 180%, y: 180%)[floor.r]_(1 / t) = m$,
given $e < frac(1, 2 t)$

$gt.tri$ where $ceil.l x floor.r_(1 / t)$ means rounding $x$ to the
nearest multiple of $1 / t$

$$

The original TFHE's difference is that all values (either polynomial
coefficients or vector elements) are computed in a floating point modulo
1 (i.e., $\[0\,1\)$) instead of a big integer (i.e., $\[0\,q\)$). This
means the plaintext also has to be encoded as values within $\[0\,1\)$
instead of integers within $\[0\,q\)$. Note that in the original TFHE
scheme, there is no need for the scaling factor $Delta$, because the
continuous domain of torus $\[0\,1\)$ provides a floating-point
precision up to $q$ discrete fractional values, and its decryption
process can successfully blow away the noise $E$ as far as each
coefficient (or vector element) $e_i$ in $E$ is smaller than
$frac(1, 2 t)$.

Both the torus-based and integer-ring-based TFHE schemes are built based
on the same fundamental principles.
