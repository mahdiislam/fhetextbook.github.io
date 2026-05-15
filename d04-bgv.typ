Similar to BFV, the BGV scheme is designed for homomorphic addition and
multiplication of integers. Unlike CKKS, BGV guarantees exact encryption
and decryption. From this view, BGV is similar to BFV. However, the
major difference between these two schemes is that BFV stores the
plaintext value in the MSBs (most significant bits) and the noise in the
low-digit area (least significant bits), while BGV stores them the other
way around: the plaintext value in the low-digit area and the noise in
the MSBs. Technically, while BFV scales the plaintext polynomial by
$Delta$, BGV scales the noise polynomial by $Delta$. Therefore, these
two schemes use slightly different strategies to store and manage the
plaintext and noise within a ciphertext.

BGV internally uses almost the same strategy as BFV for plaintext
encoding, ciphertext-to-plaintext addition, ciphertext-to-ciphertext
addition, ciphertext-to-plaintext multiplication, and input vector
rotation. On the other hand, BGV's encryption and decryption are
slightly different from BFV's scheme, because its scaling target is not
the plaintext, but the noise. Also, unlike BFV where
ciphertext-to-ciphertext multiplication has no limit on the number,
BGV's ciphertext-to-ciphertext multiplication is leveled, switching the
modulus to a lower level like CKKS, and thus it is limited. Furthermore,
BGV's modulus switch and bootstrapping are partially different from
BFV's.

#block[
- #link(<sec:modulo>)[\[sec:modulo\]]:

- #link(<sec:group>)[\[sec:group\]]:

- #link(<sec:field>)[\[sec:field\]]:

- #link(<sec:order>)[\[sec:order\]]:

- #link(<sec:polynomial-ring>)[\[sec:polynomial-ring\]]:

- #link(<sec:decomp>)[\[sec:decomp\]]:

- #link(<sec:roots>)[\[sec:roots\]]:

- #link(<sec:cyclotomic>)[\[sec:cyclotomic\]]:

- #link(<sec:cyclotomic-polynomial-integer-ring>)[\[sec:cyclotomic-polynomial-integer-ring\]]:

- #link(<sec:matrix>)[\[sec:matrix\]]:

- #link(<sec:euler>)[\[sec:euler\]]:

- #link(<sec:modulus-rescaling>)[\[sec:modulus-rescaling\]]:

- #link(<sec:chinese-remainder>)[\[sec:chinese-remainder\]]:

- #link(<sec:polynomial-interpolation>)[\[sec:polynomial-interpolation\]]:

- #link(<sec:ntt>)[\[sec:ntt\]]:

- #link(<sec:lattice>)[\[sec:lattice\]]:

- #link(<sec:rlwe>)[\[sec:rlwe\]]:

- #link(<sec:glwe>)[\[sec:glwe\]]:

- #link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]:

- #link(<sec:glwe-add-plain>)[\[sec:glwe-add-plain\]]:

- #link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]:

- #link(<subsec:modulus-switch-rlwe>)[\[subsec:modulus-switch-rlwe\]]:

- #link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]:

- #link(<sec:bfv>)[\[sec:bfv\]]:

- #link(<sec:ckks>)[\[sec:ckks\]]:

]
== Encoding and Decoding
<subsec:bgv-encoding-decoding>
BGV uses almost the same plaintext encoding scheme as BFV as described
in Summary~@subsubsec:bfv-encoding-summary in
#link(<subsubsec:bfv-encoding-summary>)[\[subsubsec:bfv-encoding-summary\]],
with the only difference that the scaling factor $Delta = ⌊q / t⌋$ is
not applied to the plaintext polynomial $M\(X\)$ like BFV does. Instead,
BGV applies its own scaling factor $Delta = t$ to the noise polynomial
$E\(X\)$ whenever it encrypts a new ciphertext (will be explained in
#link(<subsec:bgv-enc-dec>)[0.2]).

The following is BGV's encoding and decoding scheme.

#block[
#strong[#underline[Input]:] An $n$-dimensional integer modulo $t$ vector
$arrow(v) =\(v_0\,v_1\,dots.h.c\,v_(n - 1)\)in bb(Z)_t^n$

$$

#strong[#underline[Encoding]:]

Convert $arrow(v) in bb(Z)_t^n$ into $arrow(m) in bb(Z)_t^n$ by applying
the transformation
\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}}{n}\$

, where \$\\hathat W\$ is a basis of the $n$-dimensional vector space
crafted as follows:

\$\\hathat W = \\begin{bmatrix}
1 & 1 & \\cdots & 1 & 1 & 1 & \\cdots & 1\\\\
(\\omega^{J(\\frac{n}{2} - 1)}) & (\\omega^{J(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J(0)}) & (\\omega^{J\_\*(\\frac{n}{2} - 1)}) & (\\omega^{J\_\*(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J\_\*(0)})\\\\
(\\omega^{J(\\frac{n}{2} - 1)})^2 & (\\omega^{J(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J(0)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J\_\*(0)})^2 \\\\
\\vdots & \\vdots & \\ddots & \\vdots & \\vdots & \\ddots & \\vdots & \\vdots \\\\
(\\omega^{J(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J(\\frac{n}{2} - 2)})^{n-1} & \\cdots & (\\omega^{J(0)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^{n-1} & \\vdots  & (\\omega^{J\_\*(0)})^{n-1}
\\end{bmatrix}\$

$$

, where $omega$ is a primitive $2 n$-th root of unity modulo $t$ (which
implies $t equiv 1 med mod med 2 n$). This implies that
$omega = g^(frac(t - 1, 2 n)) med mod med t$ ($g$ is a generator of
$bb(Z)_t^times$ (see
#link(<subsubsec:poly-vector-transformation-modulus>)[\[subsubsec:poly-vector-transformation-modulus\]]).
The final output is
$M = sum_(i = 0)^(n - 1) m_i X^i upright(" ") in bb(Z)_t\[X\]\/\(X^n + 1\)$,
which we can also treat as

$M = sum_(i = 0)^(n - 1) m_i X^i upright(" ") in bb(Z)_q\[X\]\/\(X^n + 1\)$
during encryption/decryption later, because the initial fresh
coefficients $m_i$ are guaranteed to be smaller than any $q$ where
$q = { q_0\,q_1\,dots.h.c\,q_L }$.

$$

#strong[#underline[Decoding]:] For the plaintext polynomial
$M = sum_(i = 0)^(n - 1) m_i X^i$, compute
\$\\vec{v} = \\hathat W^\* \\cdot \\vec{m}\$, where

\$\\hathat{W}^\* = \\begin{bmatrix}
1 & (\\omega^{J(0)}) & (\\omega^{J(0)})^2 & \\cdots & (\\omega^{J(0)})^{n-1}\\\\
1 & (\\omega^{J(1)}) & (\\omega^{J(1)})^2 & \\cdots & (\\omega^{J(1)})^{n-1}\\\\
1 & (\\omega^{J(2)}) & (\\omega^{J(2)})^2 & \\cdots & (\\omega^{J(2)})^{n-1}\\\\
\\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\
1 & (\\omega^{J(\\frac{n}{2}-1)}) & (\\omega^{J(\\frac{n}{2}-1)})^2 & \\cdots & (\\omega^{J(\\frac{n}{2}-1)})^{n-1}\\\\
1 & (\\omega^{J\_\*(0)}) & (\\omega^{J\_\*(0)})^2 & \\cdots & (\\omega^{J\_\*(0)})^{n-1}\\\\
1 & (\\omega^{J\_\*(1)}) & (\\omega^{J\_\*(1)})^2 & \\cdots & (\\omega^{J\_\*(1)})^{n-1}\\\\
1 & (\\omega^{J\_\*(2)}) & (\\omega^{J\_\*(2)})^2 & \\cdots & (\\omega^{J\_\*(2)})^{n-1}\\\\
\\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\
1 & (\\omega^{J\_\*(\\frac{n}{2}-1)}) & (\\omega^{J\_\*(\\frac{n}{2}-1)})^2 & \\cdots & (\\omega^{J\_\*(\\frac{n}{2}-1)})^{n-1}\\\\
\\end{bmatrix}\$

]
== Encryption and Decryption
<subsec:bgv-enc-dec>
BGV's encryption and decryption scheme is very similar to BFV's scheme
(Summary~@subsec:bfv-enc-dec in
#link(<subsec:bfv-enc-dec>)[\[subsec:bfv-enc-dec\]]) with a small
difference: while BFV scales the plaintext polynomial $M\(X\)$ by
$Delta$, BGV scales the noise polynomial $E\(X\)$ by $Delta$. In BFV,
each encoded plaintext polynomial $M\(X\)$ is scaled by
$Delta = ⌊q / t⌋$. This strategy effectively shifts each plaintext
coefficient value to the most significant bits while keeping the noise
in the least significant bits. On the other hand, BGV does not scale the
plaintext polynomial $M\(X\)$, but instead it scales each new noise
$E\(X\)$ by $Delta = t$, making the noise $Delta E\(X\)$, which is newly
generated upon each new ciphertext creation. This different scaling
strategy effectively shifts the noise (i.e., $e_i$) to the most
significant bits by scaling it by $Delta = t$ while keeping the
plaintext value (i.e., $m_i$) $M\(X\)$'s each coefficient in the least
significant bits.

Also, in BGV, the ciphertext modulus $q$ is leveled like CKKS's one:
$q in { q_0\,q_1\,dots.h.c\,q_L }$, where each
$q_l = product_(i = 0)^l w_i$ (where each $w_i$ is a CRT modulus).

BGV's encryption decryption process is described as follows:

#block[
#strong[#underline[Initial Setup]:]

- The plaintext modulus $t = p$ (a prime)

- The ciphertext modulus $q$ is leveled like in CKKS:
  $q in { q_0\,q_1\,dots.h.c\,q_L }$, where each
  $q_l = product_(i = 0)^l w_i$ (each $w_i$ is a CRT modulus), and each
  $q_l equiv 1 med mod med t$ (will be explained in
  #link(<subsec:bgv-modulus-switch>)[0.7])

- The noise scaling factor $Delta = t$

- The secret key
  $S arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)$. The
  coefficients of the polynomial $S$ ternary (i.e., ${ - 1\,0\,1 }$).

#horizontalrule

#strong[#underline[Encryption Input]:]
$M in cal(R)_(chevron.l n\,q chevron.r)$,
$A arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)$,
$E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

+ Compute
  $B = - A dot.op S + M + Delta E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ $sans("RLWE")_(S\,sigma)\(M + Delta E\)=\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

#horizontalrule

#strong[#underline[Decryption Input]:]
$sans("ct") =\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

+ $sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= B + A dot.op S = M + Delta E med\(mod med q\)$

+ Compute $M + Delta E med mod med t$ to get $M$. $gt.tri$ modulo
  reduction of $M + Delta E$ by $t$

$$

The final output is $M\(X\)in bb(Z)_t\[X\]\/\(X^n + 1\)$.

$$

#strong[#underline[Conditions for Correct Decryption]:]

Each coefficient $Delta e_i + m_i$ that contains the scaled noise and
the plaintext should not overflow or underflow its ciphertext's any
current moment's multiplicative level $l$'s ciphertext modulus $q_l$
(i.e., $Delta e_i + m_i < q_l$, or $\|Delta e_i + m_i\|< q_l / 2$ in the
signed modulo representation).

]
When restoring the plaintext at the end of the decryption process, while
BFV shifts down the plaintext and the noise to the lower bit area (which
effectively rounds off the noise), BGV computes $upright(" mod ") p$,
which effectively modulo-reduces the accumulated noise because every
coefficient of $E$ is a multiple of $t$ (i.e., $Delta$). Finally, only
each coefficient of the plaintext polynomial $m_i$ remains in the
low-digit area without any noise $e_i$.

== Ciphertext-to-Ciphertext Addition
<subsec:bgv-add-cipher>
BGV's ciphertext-to-ciphertext addition scheme is exactly the same as
BFV's scheme (Summary~@subsec:bfv-add-cipher in
#link(<subsec:bfv-add-cipher>)[\[subsec:bfv-add-cipher\]]).

#block[
$sans("RLWE")_(S\,sigma)\(M^(chevron.l 1 chevron.r) + Delta E^(chevron.l 1 chevron.r)\)+ sans("RLWE")_(S\,sigma)\(M^(chevron.l 2 chevron.r) + Delta E^(chevron.l 2 chevron.r)\)$

$=\(A^(chevron.l 1 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r)\)+\(A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 2 chevron.r)\)$

$=\(A^(chevron.l 1 chevron.r) + A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)$

$= sans("RLWE")_(S\,sigma) bold(\()\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ Delta E^(chevron.l 1 chevron.r) + Delta E^(chevron.l 2 chevron.r) bold(\))$

]
== Ciphertext-to-Plaintext Addition
<subsec:bgv-add-plain>
BGV's ciphertext-to-plaintext addition scheme is almost the same as
BFV's scheme (Summary~@subsec:bfv-add-plain in
#link(<subsec:bfv-add-plain>)[\[subsec:bfv-add-plain\]]). However, one
difference is that it's not the case that the plaintext polynomial
$Lambda\(X\)$ to be added is scaled up by $Delta$, but it remains as
$Lambda\(X\)$.

#block[
$sans("RLWE")_(S\,sigma)\(M + Delta E\)+ Lambda$

$=\(A\,upright(" ") B\)+ Lambda$

$=\(A\,upright(" ") B + Lambda\)$

$= sans("RLWE")_(S\,sigma) bold(\()\(M + Lambda\)+ Delta E bold(\))$

]
== Ciphertext-to-Plaintext Multiplication
<subsec:bgv-mult-plain>
BGV's ciphertext-to-plaintext multiplication scheme is exactly the same
as BFV's scheme (Summary~@subsec:bfv-mult-plain in
#link(<subsec:bfv-mult-plain>)[\[subsec:bfv-mult-plain\]]).

#block[
$sans("RLWE")_(S\,sigma)\(M + Delta E\)dot.op Lambda$

$=\(A\,upright(" ") B\)dot.op Lambda$

$=\(A dot.op Lambda\,upright(" ") B dot.op Lambda\)$

$= sans("RLWE")_(S\,sigma)\(\(M dot.op Lambda\)+ Delta E dot.op Lambda\)$

]
Notice that BGV's ciphertext-to-plaintext multiplication does not
consume any multiplicative level.

== ModDrop
<subsec:bgv-moddrop>
BGV's ModDrop works similarly to that of CKKS's ModDrop
(Summary~@subsec:ckks-moddrop in
#link(<subsec:ckks-moddrop>)[\[subsec:ckks-moddrop\]]). Remember that
CKKS's ciphertext decryption relation is as follows:

$M + Delta E = A dot.op S + B med mod med q_l$

$M + Delta E = A dot.op S + B - K dot.op q_l$ $gt.tri$ where
$K dot.op q_l$ represents a modulo reduction by $q_l$

BGV's ModDrop operation decreases its modulus from
$q_l arrow.r q_(l - 1)$ is performed by updating the ciphertext
$\(A\,B\)$ to a new one: $bold(\() A' = A med mod med q_(l - 1)$,
$B' = B med mod med q_(l - 1)\)$. After the ModDrop, the ciphertext's
modulus decreases from $q_l arrow.r q_(l - 1)$, yet its decryption
relation still holds the same as follows:

$A' dot.op S + B' - K dot.op q_l$

$=\(A med mod med q_(l - 1)\)dot.op S +\(B med mod med q_(l - 1)\)- K dot.op q_l$

$=\(A - K_A dot.op q_(l - 1)\)dot.op S +\(B - K_B dot.op q_(l - 1)\)- K dot.op q_l$

$= A dot.op S + B -\(K_A dot.op S + K_B + K q / q_(l - 1)\)dot.op q_(l - 1)$
$gt.tri$ where $q / q_(l - 1) = w_l$ (i.e., the $l$-th prime element of
$q_L$)

$= A dot.op S + B - K' dot.op q_(l - 1)$ $gt.tri$ where
$K' = K_A dot.op S + K_B + K q / q_(l - 1)$, $q / q_(l - 1) = w_l$

$= A dot.op S + B med mod med q_(l - 1)$

$= M + Delta E$ $gt.tri$ since $M + Delta E < q_0 < q_(l - 1)$

$$

As shown above, $\(A'\,B'\)med mod med q_(l - 1)$ decrypts to the same
$M + Delta E$, a plaintext with a scaled error. However, the noise
budget (i.e., allowed threshold of the noise) decreases because the
ciphertext modulus-to-noise ratio decreases.

$$

BGV's ModDrop is summarized as follows:

#block[
Given a BGV ciphertext with the $l$-th multiplicative level
$sans("RLWE")_(S\,sigma)\(M + Delta E\)=\(A\,B\)med mod med q_l$, a
ModDrop operation is as follows:

$\(A'\,B'\)med mod med q_(l - 1) =\(A med mod med q_(l - 1)\,B med mod med q_(l - 1)\)$

$$

After this, the ciphertext's multiplicative level decreases by 1, the
noise's scaling factor $Delta$ and the plaintext are unaffected, and the
noise budget (i.e., allowed noise threshold) decreases.

]
== Modulus Switch
<subsec:bgv-modulus-switch>
#strong[\- Reference 1:]
#link("https://eprint.iacr.org/2020/1481")[Design and implementation of HElib: a homomorphic encryption library]~@bgv-modswitch1

#strong[\- Reference 2:]
#link("https://eprint.iacr.org/2011/277.pdf")[Fully Homomorphic Encryption without Bootstrapping]~@bgv-modswitch2

#strong[\- Reference 3:]
#link("https://eprint.iacr.org/2012/099.pdf")[Homomorphic Evaluation of the AES Circuit]~@bgv-modswitch3

Remember that the requirement of modulus switch is that while we change
the ciphertext modulus from $q$ to $hat(q)$, it should decrypt to the
same plaintext $M$. BGV's modulus switch is similar to that of the RLWE
modulus switch
(#link(<subsec:modulus-switch-rlwe>)[\[subsec:modulus-switch-rlwe\]]),
but there is an additional requirement, because BGV applies the scaling
factor $Delta$ not to plaintext $M$, but to noise $E$. In the case of
BFV or CKKS, their decryption process only needs to round off the noise
in the low-digit area. However, in the case of BGV, the plaintext is in
the low-digit area and its decryption process has to remove the noise in
the higher-bit area by modulo-$t$ reduction (i.e., the plaintext
modulus). More concretely, BGV's modulus switch from
$\(A\,B\)med mod med q_l$ $arrow.r$
$\(hat(A)\,hat(B)\)med mod med hat(q)$ should satisfy the decryption
relation such that
$\(\(hat(A) dot.op S + hat(B)\)med mod med hat(q)\)med mod med t = M$.
In BGV's modulus switch, $hat(q)$ does not have to be one of the
multiplicative levels of the ciphertext, and $hat(q)$ only needs to
satisfy the relationship: $hat(q) < q_l$ and
$hat(q) equiv 1 med mod med t$. BGV's modulus switch procedure is as
follows:

$$

+ The input ciphertext is $sans("ct") =\(A\,B\)med mod med q_l$. We
  compute new polynomials $A'$ and $B'$ as follows:

  $\(A'\,B'\)= (⌈hat(q) / q_l dot.op A⌋ \, ⌈hat(q) / q_l dot.op B⌋) med\(mod med hat(q)\)$

  $$

  And we compute the rounding error $epsilon.alt_A\,epsilon.alt_B$ as
  follows:

  $epsilon.alt_A = hat(q) / q_l dot.op A - A'$

  $epsilon.alt_B = hat(q) / q_l dot.op B - B'$

  $$

  , which we rewrite as follows:

  $hat(q) A = q_l A' + q_l epsilon.alt_A = q_l A' + epsilon.alt'_A$
  $gt.tri$ we denote $epsilon.alt'_A = q_l epsilon.alt_A$, where
  $epsilon.alt'_A in bb(Z)_(q_l)$

  $hat(q) B = q_l B' + q_l epsilon.alt_B = q_l B' + epsilon.alt'_B$
  $gt.tri$ we denote $epsilon.alt'_B = q_l epsilon.alt_B$, where
  $epsilon.alt'_B in bb(Z)_(q_l)$

  $$

+ We compute new polynomials $H_A$ and $H_B$ as follows:

  $H_A = q_l^(- 1) dot.op epsilon.alt'_A med mod med t$

  $H_B = q_l^(- 1) dot.op epsilon.alt'_B med mod med t$

  $$

+ We propose the final mod-switched ciphertext $hat(sans("ct"))$ as
  follows:

  $hat(sans("ct")) =\(hat(A)\,hat(B)\)=\(A' + H_A\,upright(" ") B' + H_B\)med mod med hat(q)$

  $$

  Note that the computation result of $A' + H_A$ and $B' + H_B$ alone
  can exceed the range $bb(Z)_(hat(q))$, because
  $A'\,B' in bb(Z)_(hat(q))$ and $H_A\,H_B in bb(Z)_t$. Therefore, our
  goal is reduce $A' + H_A$ and $B' + H_B$ modulo $hat(q)$ to derive
  $hat(A) in bb(Z)_(hat(q))$ and $hat(B) in bb(Z)_(hat(q))$.

  $$

+ From now on, we will verify that $hat(sans("ct"))$ is a valid
  ciphertext satisfying BGV's required decryption relation. First, we
  can derive the relationship among $sans("ct") =\(A\,B\)$, $A' + H_A$,
  and $B' + H_B$ as follows:

  $hat(q) dot.op sans("ct") med mod med t$

  $=\(hat(q) A\,hat(q) B\)med mod med t$

  $=\(q_l A' + epsilon.alt'_A\,upright(" ") q_l B' + epsilon.alt'_B\)med mod med t$
  $gt.tri$ applying step 1's result:
  $hat(q) A = q_l A' + epsilon.alt'_A$,
  $hat(q) B = q_l B' + epsilon.alt'_B$

  $=\(q_l A' + q_l H_A\,upright(" ") q_l B' + q_l H_B\)med mod med t$
  $gt.tri$ applying step 2's result:
  $H_A = q_l^(- 1) dot.op epsilon.alt'_A med mod med t$,
  $H_B = q_l^(- 1) dot.op epsilon.alt'_B med mod med t$

  $$

  $= q_l dot.op\(A' + H_A\,upright(" ") B' + H_B\)med mod med t$

  $$

  So,
  $hat(q) dot.op sans("ct") = q_l dot.op\(A' + H_A\,upright(" ") B' + H_B\)med mod med t$.
  But in BGV,
  $q_l equiv q_2 equiv dots.h.c equiv hat(q) equiv dots.h.c q_L equiv 1 med mod med t$.
  Thus, the following holds:

  $A equiv A' + H_A med mod med t$

  $B equiv B' + H_B med mod med t$

  $$

+ We can derive the decryption relation of $hat(sans("ct"))$ from the
  decryption relation of $sans("ct")$ as follows:

  $M =\(A dot.op S + B med mod med q_l\)med mod med t$ $gt.tri$ The BGV
  decryption relation of $sans("ct") =\(A\,B\)med mod med q_l$

  $=\(A dot.op S + B - K dot.op q_l\)med mod med t$ $gt.tri$ where
  $K dot.op q_l$ represents the modulo-$q_l$ reduction

  $=\(\(A' + H_A\)dot.op S + B' + H_B - K dot.op q_l\)med mod med t$
  $gt.tri$ applying step 4's result: $A equiv A' + H_A med mod med t$,
  $B equiv B' + H_B med mod med t$

  $=\(\(A' + H_A\)dot.op S + B' + H_B - K dot.op hat(q)\)med mod med t$
  $gt.tri$ since in BGV,
  $q_0 equiv q_1 equiv dots.h.c q_L equiv 1 med mod med t$, and we chose
  $hat(q)$ such that $hat(q) equiv 1 med mod med t$

  $$

+ Now, if we can prove that
  $\(A' + H_A\)dot.op S + B' + H_B - K dot.op hat(q) =\(A' + H_A\)dot.op S + B' + H_B med mod med hat(q)$
  (i.e., $K dot.op hat(q)$ reduces $\(A' + H_A\)dot.op S + B' + H_B$
  modulo $hat(q)$), then this sufficiently leads to the following
  conclusion:

  $\(hat(A) dot.op S + hat(B) med mod med hat(q)\)med mod med t$

  $=\(\(A' + H_A\)dot.op S + B' + H_B med mod med hat(q)\)med mod med t$

  $= M$ $gt.tri$ i.e.,
  $\(hat(A)\,hat(B)\)=\(A' + H_A\,B' + H_B\)med mod med hat(q)$ is a
  valid ciphertext that decrypts to $M$

  $$

+ We will prove that
  $\(A' + H_A\)dot.op S + B' + H_B - K dot.op hat(q) =\(A' + H_A\)dot.op S + B' + H_B med mod med hat(q)$
  as follows:

  $\(A' + H_A\)dot.op S + B' + H_B - K dot.op hat(q)$

  $=\(hat(q) / q_l dot.op A - epsilon.alt'_A / q_l + H_A\)dot.op S +\(hat(q) / q_l dot.op B - epsilon.alt'_B / q_l + H_B\)- K dot.op hat(q)$

  $gt.tri$ applying step 1's result:
  $A' = hat(q) / q_l dot.op A - epsilon.alt'_A / q_l\,upright(" ") B' = hat(q) / q_l dot.op B - epsilon.alt'_B / q_l$

  $$

  $$

  $= (hat(q) / q_l dot.op A dot.op S + hat(q) / q_l dot.op B - K dot.op hat(q)) + H_A dot.op S + H_B - epsilon.alt'_A / q_l dot.op S - epsilon.alt'_B / q_l$
  $gt.tri$ rearranging the terms

  $= hat(q) / q_l dot.op\(A dot.op S + B - K dot.op q_l\)+ H_A dot.op S + H_B - epsilon.alt'_A / q_l dot.op S - epsilon.alt'_B / q_l$
  $gt.tri$ taking out the common factor $hat(q) / q_l$

  $= hat(q) / q_l dot.op\(A dot.op S + B med mod med q_l\)+ H_A dot.op S + H_B - frac(epsilon.alt'_A dot.op S + epsilon.alt'_B, q_l)$
  $gt.tri$ since
  $A dot.op S + B - K dot.op q_l = A dot.op S + B med mod med q_l$

  $$

  For successful decryption, every coefficient of the resulting
  polynomial of the above expression has to be within the range
  $bb(Z)_(hat(q))$ (which means that $K dot.op hat(q)$ has successfully
  reduced $\(A' + H_A\)dot.op S + B' + H_B$ modulo $hat(q)$). The first
  term $hat(q) / q_l dot.op\(A dot.op S + B med mod med q_l\)$ can be
  viewed as the original ciphertext ct's noise (with the plaintext
  message) scaled down by $hat(q) / q_l$, which is guaranteed to be
  within the $bb(Z)_(hat(q))$ range. The coefficients of the second term
  $H_A dot.op S$ are also small, because $H_A in bb(Z)_t^n$ and
  $S in { - 1\,0\,1 }^n$. The coefficients of the third term $H_B$ are
  also small, because $H_B in bb(Z)_t^n$. The coefficients of the last
  term $- frac(epsilon.alt'_A dot.op S + epsilon.alt'_B, q_l)$ are also
  small, because $epsilon.alt'_A / q_l$ and $epsilon.alt'_B / q_l$ are
  $in bb(Z)_(q_l / hat(q))$.

  $$

  Therefore,
  $\(A' + H_A\)dot.op S + B' + H_B - K dot.op hat(q) =\(A' + H_A\)dot.op S + B' + H_B med mod med hat(q)$
  (provided the above error thresholds hold).

  $$

+ Finally, we combine the results of step 6 and 7 as follows:

  $bold(\()\(hat(A) dot.op S + hat(B)\)med mod med hat(q) bold(\)) med mod med t$

  $= bold(\()\(A' + H_A\)dot.op S + B' + H_B med mod med hat(q) bold(\)) med mod med t$
  $gt.tri$ since $hat(A) equiv A' + H_A med mod med hat(q)$, and
  $hat(B) equiv B' + H_B med mod med hat(q)$

  $=\(\(A' + H_A\)dot.op S + B' + H_B - K dot.op hat(q)\)med mod med t$
  $gt.tri$ by applying step 7

  $= M$ $gt.tri$ by applying step 5

  $$

  Hence, decrypting $\(hat(A)\,hat(B)\)med mod med hat(q)$ outputs the
  message $M$.

$$

We summarize BGV's modulus switch as follows:

#block[
Suppose we have the current ciphertext modulus $q_l$ and new ciphertext
modulus $hat(q)$ where $q_l equiv hat(q) equiv 1 med mod med t$ and
$hat(q) < q_l$. Therefore, $hat(q)$ may or may not be one of the
ciphertext moduli comprising a BGV ciphertext's multiplicative level
moduli $q_0\,q_1\,dots.h.c\,q_L$.

$$

BGV's modulus switch from $q_l arrow.r hat(q)$ is equivalent to updating
$\(A\,B\)med mod med q_l$ to $\(hat(A)\,hat(B)\)med mod med hat(q)$ as
follows:

$\(A'\,B'\)= (⌈hat(q) / q_l dot.op A⌋ \, ⌈hat(q) / q_l dot.op B⌋) in cal(R)_(chevron.l n\,hat(q) chevron.r)^2$

$$

$epsilon.alt'_A = hat(q) dot.op A - q_l dot.op A'$ $gt.tri$ where
$epsilon.alt'_A in bb(Z)_(q_l)$

$epsilon.alt'_B = hat(q) dot.op B - q_l dot.op B'$ $gt.tri$ where
$epsilon.alt'_B in bb(Z)_(q_l)$

$$

$H_A = q_l^(- 1) dot.op epsilon.alt'_A med mod med t$

$H_B = q_l^(- 1) dot.op epsilon.alt'_B med mod med t$

$$

$hat(sans("ct")) =\(hat(A)\,hat(B)\)=\(A' + H_A\,B' + H_B\)med mod med hat(q)$

$$

BGV's modulus switch is used for ciphertext-to-ciphertext multiplication
(will be covered in #link(<subsec:bgv-mult-cipher>)[0.8]). Meanwhile,
After BGV's modulus switch (i.e., the noise scaling factor), $Delta = t$
stays the same as before. The secret key $S$ also stays the same as
before. The noise gets scaled down roughly by $hat(q) / q_l$, but this
does not decrease the noise-to-ciphertext modulus ratio. The
noise-to-ciphertext modulus ratio can be reduced by modulus
bootstrapping (will be covered in
#link(<subsec:bgv-bootstrapping>)[0.11]).

]
=== Difference between Modulus Switch and ModDrop
<subsubsec:bgv-moddrop-vs-modswitch>
In the case of CKKS
(#link(<subsubsec:ckks-mult-cipher-rescale>)[\[subsubsec:ckks-mult-cipher-rescale\]]),
the difference between modulus switch and ModDrop is that the former
scales down the plaintext's scaling factor by
$q_l / q_(l - 1) approx 1 / Delta$, whereas ModDrop does not affect the
plaintext's scaling factor.

Similarly, in the case of BGV, modulus switch (rescaling) and ModDrop
from $q_l arrow.r q_(l - 1)$ both lower a BGV ciphertext's modulus from
$q_l arrow.r q_(l - 1)$. However, the key difference is that rescaling
also decreases the noise's scaling factor by
$q_l / q_(l - 1) approx 1 / Delta$, whereas ModDrop keeps the noise's
scaling factor the same as it is. Therefore, rescaling is used only
during ciphertext-to-ciphertext multiplication (to be explained in
#link(<subsec:bgv-mult-cipher>)[0.8]) when scaling down the noise's
scaling factor in the intermediate ciphertext from
$Delta^2 arrow.r Delta$. Meanwhile, ModDrop is used to reduce the modulo
computation time during an application's routine when it becomes certain
that the ciphertext will not undergo any additional
ciphertext-to-ciphertext multiplication (i.e., no need to further
decrease the ciphertext's modulus).

The main difference in modulus switch between CKKS and BGV is that the
former decreases the plaintext's scaling factor by approximately
$1 / Delta$, whereas the latter decreases the noise's scaling factor by
approximately $1 / Delta$.

Examples of BGV modulus switch can be executed by running
#link("https://github.com/fhetextbook/fhe-textbook/blob/main/source%20code/bgv.py")[#underline[this Python script]].

== Ciphertext-to-Ciphertext Multiplication
<subsec:bgv-mult-cipher>
#strong[\- Reference:]
#link("https://www.inferati.com/blog/fhe-schemes-bgv")[Introduction to the BGV encryption scheme]

Since BGV uses a leveled ciphertext modulus chain like CKKS, BGV's
ciphertext-to-ciphertext multiplication scheme is exactly the same as
CKKS's scheme (Summary~@subsec:ckks-mult-cipher in
#link(<subsec:ckks-mult-cipher>)[\[subsec:ckks-mult-cipher\]]), except
for the rescaling step which uses BGV's modulus switch
(#link(<subsec:bgv-modulus-switch>)[0.7]).

#block[
Suppose we have the following two RLWE ciphertexts:

$sans("RLWE")_(S\,sigma)\(M^(chevron.l 1 chevron.r) + Delta E^(chevron.l 1 chevron.r)\)=\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)$,
where
$B^(chevron.l 1 chevron.r) = - A^(chevron.l 1 chevron.r) dot.op S + M^(chevron.l 1 chevron.r) + Delta E^(chevron.l 1 chevron.r)$

$sans("RLWE")_(S\,sigma)\(M^(chevron.l 2 chevron.r) + Delta E^(chevron.l 2 chevron.r)\)=\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)$,
where
$B^(chevron.l 2 chevron.r) = - A^(chevron.l 2 chevron.r) dot.op S + M^(chevron.l 2 chevron.r) + Delta E^(chevron.l 2 chevron.r)$

$$

Multiplication between these two ciphertexts is performed as follows:

$$

+ #strong[#underline[Basic Multiplication]]

  Compute the following:

  $$

  $D_0 = B^(chevron.l 1 chevron.r) dot.op B^(chevron.l 2 chevron.r)$

  $D_1 = A^(chevron.l 1 chevron.r) dot.op B^(chevron.l 2 chevron.r) + A^(chevron.l 2 chevron.r) dot.op B^(chevron.l 1 chevron.r)$

  $D_2 = A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)$

  $$

  The decryption relation satisfies:
  $M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ Delta^2 E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r)$

  $= underbrace(B^(chevron.l 1 chevron.r) dot.op B^(chevron.l 2 chevron.r), D_0) + underbrace(\(B^(chevron.l 2 chevron.r) dot.op A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)\), D_1) dot.op S + underbrace(\(A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)\), D_2) dot.op underbrace(S dot.op S, S^2)$

  $= D_0 + D_1 dot.op S + D_2 dot.op S^2$

  $$

+ #strong[#underline[Relinearization]]

  $sans("RLWE")_(S\,sigma) bold(\() M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ Delta^2 E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) bold(\))$

  $= sans("RLWE")_(S\,sigma) bold(\() upright(" ") D_0 + D_1 dot.op S + D_2 dot.op S^2 upright(" ") bold(\))$

  $approx C_alpha + C_beta\,upright(" where ") upright(" ") C_alpha =\(D_1\,D_0\)\,upright(" ") upright(" ") upright(" ") C_beta = bold(chevron.l) upright(" ") sans("Decomp")^(beta\,l)\(D_2\)\,sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)upright(" ") bold(chevron.r)$

  $$

+ #strong[#underline[\(Optional) Rescaling]]

  To suppress the noise component scaled by $Delta^2$ and return it to a
  factor of $Delta$, switch the ciphertext's modulo from
  $q arrow.r hat(q)$ by updating $\(A\,B\)$ to $\(hat(A)\,hat(B)\)$
  according to BGV's modulus switch explained in
  Summary~@subsec:bgv-modulus-switch
  (#link(<subsec:bgv-modulus-switch>)[0.7]).

  $$

  After the above update of $\(A\,B\)$ to $\(hat(A)\,hat(B)\)$, the
  noise scaling factor $Delta = t$ and the plaintext $M$ stay the same,
  as we proved in #link(<subsec:bgv-modulus-switch>)[0.7] that
  $\(\(hat(A) dot.op S + hat(B)\)med mod med hat(q)\)med mod med t = M$.

  $$

The order of relinearization and rescaling is interchangeable. Running
rescaling before relinearization reduces the size of the ciphertext
modulus, and therefore the subsequent relinearization can be executed
faster.

]
Before rescaling, the contents of the ciphertext are
$M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ Delta^2 E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + epsilon.alt$,
where $epsilon.alt$ is a relinearization error. Therefore, after each
ciphertext-to-ciphertext multiplication, the noise's scaling factor will
become squared as $Delta^2\,Delta^4\,Delta^8\,dots.h.c$. To reduce such
exponential noise growth rate, we can optionally rescale down the
ciphertext by $w_l = q_l / q_(l - 1) > Delta$ at the end of each
relinearization at multiplicative level $l$, which is the noise's growth
rate (effectively keeping the noise scaling factor as $Delta$). After
rescaling, the ciphertext gets scaled down by $w_l$ and then added by a
new noise $epsilon.alt_2$. Before the rescaling, the noise grew roughly
by the factor of $Delta = t$ (as the largest noise term is
$Delta^2 E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r)$), but the
rescaling process reduces this growth rate by the factor of $w_l$ and
then introduces a new constant noise $epsilon.alt_2$. Therefore, if
$w_l$ is sufficiently bigger than $Delta = t$, the resulting noise will
decrease compared to both $Delta E^(chevron.l 1 chevron.r)$ and
$Delta E^(chevron.l 2 chevron.r)$. Due to this reason, when we design
the modulus chain of BGV, we require each $w_l$ to be sufficiently
bigger than $Delta = t$ to effectively reduce the noise growth rate upon
each ciphertext-to-ciphertext multiplication (while ensuring the
property that its reduction modulo $t$ gives the plaintext $M$ as
explained in #link(<subsec:bgv-modulus-switch>)[0.7]). Meanwhile, the
constant noise term $epsilon.alt_2$ gets newly added upon each
rescaling, but this term becomes part of the rescaled ciphertext, which
will be later reduced by the factor of $w_(l - 1)$ in the future
rescaling. Therefore, BGV's rescaling upon ciphertext-to-ciphertext
multiplication effectively suppresses the noise growth.

On the other hand, the above design strategy of noise reduction is
inapplicable to CKKS, because in CKKS, we use the scaling factor $Delta$
to scale the message $M$ (not the noise $E$), and thus CKKS requires
each $w_l approx Delta$ in order to preserve the plaintext's scaling
factor $Delta$ as the same value across ciphertext-to-ciphertext
multiplications. Because of this difference in design, CKKS inevitably
increases the noise after each ciphertext-to-ciphertext multiplication.

== Homomorphic Key Switching
<subsec:bgv-key-switching>
BGV's homomorphic key switching scheme changes an RLWE ciphertext's
secret key from $S$ to $S'$. This scheme is exactly the same as BFV's
key switching scheme (Summary~@subsec:bfv-key-switching in
#link(<subsec:bfv-key-switching>)[\[subsec:bfv-key-switching\]]).

#block[
$sans("RLWE")_(S'\,sigma)\(M + Delta E\)=\(0\,B\)+ bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$

]
== Homomorphic Rotation of Input Vector Slots
<subsec:bgv-rotation>
BGV's homomorphic rotation scheme of input vector slots is exactly the
same as BFV's rotation scheme (Summary~@subsec:bfv-rotation in
#link(<subsec:bfv-rotation>)[\[subsec:bfv-rotation\]]).

#block[
Suppose we have a BGV ciphertext and a key-switching key as follows:

$ sans("RLWE")_(S\,sigma)\(M + Delta E\)=\(A\,B\)\,quad sans("RLev")_(S\,sigma)^(beta\,l)\(S\(X^(J\(h\))\)\) $

Then, the procedure of rotating the first-half elements of the
ciphertext's original input vector $arrow(v)$ by $h$ positions to the
left (in a wrapping manner among them) and the second-half elements of
$arrow(v)$ by $h$ positions to the left (in a wrapping manner among
them) is as follows:

+ Update $A\(X\)$, $B\(X\)$ to $A\(X^(J\(h\))\)$, $B\(X^(J\(h\))\)$.

+ Perform the following key switching (refer to
  #link(<subsec:bfv-key-switching>)[\[subsec:bfv-key-switching\]]) from
  $S\(X^(J\(h\))\)$ to $S\(X\)$:

  $sans("RLWE")_(S\(X\)\,sigma) bold(\() M\(X^(J\(h\))\)+ Delta E\(X^(J\(h\))\)bold(\))$

  $= bold(\() 0\,B\(X^(J\(h\))\)bold(\)) upright(" ") + upright(" ") bold(chevron.l) sans("Decomp")^(beta\,l) bold(\() A\(X^(J\(h\))\)bold(\))\,upright(" ") sans("RLev")_(S\(X\)\,sigma)^(beta\,l) bold(\() S\(X^(J\(h\))\)bold(\)) bold(chevron.r)$

]
== Modulus Bootstrapping
<subsec:bgv-bootstrapping>
#strong[\- Reference:]
#link("https://eprint.iacr.org/2022/1363.pdf")[Bootstrapping for BGV and BFV Revisited]~#cite(label("cryptoeprint:2022/1363"))

BGV's bootstrapping shares some common aspects with both BFV and CKKS's
bootstrapping. The goal of BGV's bootstrapping is the same as that of
CKKS, but the internal technique is closer to that of BFV. Like CKKS,
BGV's bootstrapping resets the depleted ciphertext modulus from
$q_l arrow.r q_L$ (strictly speaking, from $q_l arrow.r q_(l')$ such
that $l < l' < L$ because the bootstrapping operations between step
2$tilde.op$6 have consumed multiplicative levels). This modulus
transition effectively not only resets the multiplicative level but also
reduces the noise-to-ciphertext modulus ratio. To achieve this goal, one
might think that BGV's bootstrapping can take the same ModRaise approach
used by CKKS's bootstrapping. However, this is not a directly applicable
solution because CKKS uses the sine approximation technique to eliminate
the $q_0$-multiple overflows after the mod-raise. On the other hand, BGV
is an exact encryption scheme that does not allow the approximation of
plaintext values. Therefore, BGV uses BFV's digit extraction approach to
eliminate its modulus overflows. To use digit extraction, as in the case
of BFV, BGV also has to modify the plaintext modulus to a specially
prepared one, $p^epsilon$. To configure both the plaintext modulus and
the ciphertext modulus to the desired values (i.e., $p^epsilon$ and
$q_L$), BGV employs the homomorphic decryption technique, as BFV does.

The technical details of BGV's bootstrapping are as follows.

$$

Suppose that we have an RLWE ciphertext
$\(A\,B\)= sans("RLWE")_(S\,sigma)\(M + Delta E\)med mod med q_l$, where
$A dot.op S + B = M + Delta E$, $Delta = t = p$ (a prime), and $q_l$ is
the ciphertext modulus of the current multiplicative level.

$$

+ #strong[#underline[Modulus Switch] from $q_l arrow.r hat(q)$:] BFV's
  bootstrapping initially switches the ciphertext modulus from
  $q arrow.r p^(epsilon - 1)$ where $q gt.double p^epsilon > t = p$. On
  the other hand, BGV's bootstrapping switches the ciphertext modulus to
  $hat(q)$ that is a special modulus satisfying the relation:
  $hat(q) equiv 1 med mod med p^epsilon$ and $hat(q) > p^epsilon$ (where
  $p^epsilon$ will be explained in the next step). In order for a
  modulus switch from $q_l arrow.r hat(q)$ (i.e., the special modulus)
  to be possible, the prime factor(s) comprising $hat(q)$ have to be
  congruent with $q_0\,dots.h\,q_L med mod med t$, so that we can do a
  modulus switch from $q_l dot.op hat(q) arrow.r hat(q)$ (based on the
  technique learned in #link(<subsec:bgv-modulus-switch>)[0.7]).
  Eventually, this step's modulus switch transforms the ciphertext
  $\(A\,B\)med mod med q_l$ to $\(hat(A)\,hat(B)\)med mod med hat(q)$,
  during which the plaintext modulus (i.e., noise's scaling factor)
  stays the same.

  $$

+ #strong[#underline[Ciphertext Coefficient Multiplication by
  $p^(epsilon - 1)$]:] The constant $p^(epsilon - 1)$ is multiplied to
  each coefficient of the ciphertext polynomials, updating the
  ciphertext to
  $p^(epsilon - 1) dot.op\(hat(A)\,hat(B)\)=\(A'\,B'\)med mod med hat(q)$,
  where $A' = p^(epsilon - 1) hat(A)$ and $B' = p^(epsilon - 1) hat(B)$.
  This operation updates the original decryption relation
  $hat(A) dot.op S + hat(B) = M + p E + K hat(q)$ to
  $A' dot.op S + B' = p^(epsilon - 1) M + p^epsilon E + K' hat(q)$
  (where $\|\|K'\|\|_oolt.eq n + 1$). Notice that the plaintext modulus
  (i.e., noise's scaling factor) has been changed from
  $p arrow.r p^epsilon$. When choosing $epsilon$, BGV enforces the
  following additional constraint: $hat(q) > p^epsilon$ and
  $hat(q) equiv 1 med mod med p^epsilon$.

  $$

+ #strong[#underline[ModRaise]:] We mod-raise
  $\(hat(A)\,hat(B)\)med mod med hat(q)$ to
  $\(hat(A)\,hat(B)\)med mod med q_L$, where $hat(q) lt.double q_L$. The
  mod-raised ciphertext's decryption relation is as follows:

  $hat(A) dot.op S + hat(B) = p^(epsilon - 1) M + p^epsilon E + K' hat(q) med mod med q_L$

  $$

  Note that $K' hat(q)$ is the $hat(q)$-multiple overflow and does not
  get reduced modulo $q_L$, because $K' hat(q) lt.double q_L$. We saw
  the same situation in the CKKS bootstrapping's ModRaise
  (#link(<subsubsec:ckks-bootstrapping-high-level>)[\[subsubsec:ckks-bootstrapping-high-level\]])
  which resets the ciphertext modulus from $q_0 arrow.r q_L$ at the cost
  of incurring a $K q_0$ overflow, which is to be removed by EvalExp's
  homomorphic (approximate) sine graph evaluation
  (#link(<subsubsec:ckks-bootstrapping-evalexp-details>)[\[subsubsec:ckks-bootstrapping-evalexp-details\]]).
  Likewise, BGV's mod-raised ciphertext
  $\(hat(A)\,hat(B)\)med mod med q_L$ is
  $sans("RLWE")_(S\,sigma)\(p^(epsilon - 1) M + p^epsilon E + K' hat(q)\)med mod med q_L$,
  an encryption of $p^(epsilon - 1) M + p^epsilon E + K' hat(q)$. In the
  later step, we will use digit extraction to homomorphically eliminate
  $K' hat(q)$ like we did in BFV's bootstrapping. The reason BGV's
  bootstrapping uses digit extraction instead of approximated sine
  evaluation is that BGV is an exact encryption scheme like BFV (not an
  approximate scheme like CKKS).

  $$

+ #strong[#underline[CoeffToSlot]:] This step works the same way as CKKS
  and BFV's CoeffToSlot step: move the coefficients of the polynomial
  $p^(epsilon - 1) M + p^epsilon E + hat(q) K'$ to the input vector
  slots of a new ciphertext. We denote polynomial
  $Z = p^(epsilon - 1) M + p^epsilon E + hat(q) K'$, and each $i$-th
  coefficient of $Z$ as $z_i$. For the CoeffToSlot step, we
  homomorphically compute
  \$Z \\cdot n^{-1} \\cdot \\hathat W \\cdot I\_n^R\$. Then, each input
  vector slot of the resulting ciphertext ends up storing each $z_i$ of
  the polynomial $Z$.

  $$

+ #strong[#underline[Digit Extraction]:] At this point, each input
  vector slot contains each coefficient of
  $p^(epsilon - 1) M + p^epsilon E + hat(q) K'$, which is
  $p^(epsilon - 1) m_i + p^epsilon e_i + hat(q) k'_i$. Recall that we
  designed the lowest multiplicative level's ciphertext modulus $hat(q)$
  and the homomorphic multiplication factor $p^epsilon$ such that
  $hat(q) equiv 1 med mod med p^epsilon$, or
  $hat(q) = k^(chevron.l hat(q) chevron.r) dot.op p^epsilon + 1$ for
  some positive integer $k^(chevron.l hat(q) chevron.r)$. Therefore, the
  following holds:

  $p^(epsilon - 1) m_i + p^epsilon e_i + hat(q) k'_i$

  $= p^(epsilon - 1) m_i + p^epsilon e_i + k'_i dot.op\(k^(chevron.l hat(q) chevron.r) dot.op p^epsilon + 1\)$
  $gt.tri$ applying
  $hat(q) = k^(chevron.l hat(q) chevron.r) dot.op p^epsilon + 1$

  $= p^(epsilon - 1) m_i + k'_i + p^epsilon dot.op\(e_i + k'_i dot.op k^(chevron.l hat(q) chevron.r)\)$
  $gt.tri$ rearranging the terms

  $= p^(epsilon - 1) m_i + k'_i + p^epsilon dot.op k_i^(chevron.l hat(q) + epsilon chevron.r)$
  $gt.tri$ where
  $k_i^(chevron.l hat(q) + epsilon chevron.r) = e_i + k'_i dot.op k^(chevron.l hat(q) chevron.r)$

  $equiv p^(epsilon - 1) m_i + k'_i med\(mod med p^epsilon\)$

  $$

  To eliminate $k'_i$ from the above (where $\|k'_i\|lt.eq n + 1$), we
  use the same digit extraction polynomial $G_(epsilon\,v)$ as in the
  BFV bootstrapping
  (#link(<subsubsec:bfv-bootstrapping-digit-extraction>)[\[subsubsec:bfv-bootstrapping-digit-extraction\]])
  :

  $z_i = d_0 + (sum_(j = epsilon')^(epsilon - 1) d_(*) p^j)$ $gt.tri$
  where $d_0 in bb(Z)_p$, and $d_(*)$ can be any integer, and
  $1 lt.eq epsilon' lt.eq epsilon$

  $F_(epsilon')\(z_i\)equiv d_0 med mod med p^(epsilon' + 1)$

  $G_epsilon\(z_i\)equiv\(z_i - underbrace(F_(epsilon - 1) compose F_(epsilon - 2) compose dots.h.c compose F_1, epsilon - 1 upright(" times"))\(z_i\)\)dot.op\|p^(- 1)\|_q$

  $$

  We evaluate the digit extraction polynomial $G_epsilon$ for
  ${ epsilon\,epsilon - 1\,epsilon - 2\,dots.h.c\,2 }$ recursively a
  total of $epsilon - 1$ times. This operation finally zeros out and
  right-shifts the least significant (base-$p$) $epsilon - 1$ digits of
  $z_i$ as follows:

  $G_2 compose G_3 compose dots.h.c compose G_(epsilon - 1) compose G_epsilon\(z_i\)$

  $= m_i + k''_i p med mod med q_(l')$

  $$

  , where $k''_i p^epsilon$ is some multiple of $p^epsilon$ to account
  for the original $p^epsilon$-multiple overflow term plus additional
  $p^epsilon$-multiple overflows generated during the digit extraction.
  Note that the digit extraction step reduces the ciphertext modulus
  from $q_L arrow.r q_(l')$ (where $l'$ is an integer smaller than $L$),
  because the homomorphic evaluation of the polynomial $G_epsilon$
  requires some ciphertext-to-ciphertext multiplications, which consume
  some multiplicative levels. The output of the digit extraction step is
  $m_i + k''_i p med mod med q_(l')$ stored in each input vector slot.

  $$

  Unlike in BFV
  (#link(<subsubsec:bfv-bootstrapping-digit-extraction>)[\[subsubsec:bfv-bootstrapping-digit-extraction\]]),
  we cannot use scaling factor re-interpretation because the scaling
  factor setup of BGV is different from that of BFV. In BGV's digit
  extraction, each round should explicitly homomorphically multiply the
  slot values by $\|p^(- 1)\|_(q^(chevron.l i chevron.r))$, where
  $q^(chevron.l i chevron.r)$ is the ciphertext modulus at the $i$-th
  round of digit extraction. Given
  $\(A^(chevron.l g_1 chevron.r)\,B^(chevron.l g_1 chevron.r)\)med mod med q^(chevron.l 1 chevron.r)$
  is the ciphertext at the 1st round of digit extraction just before
  inverse-$p$ division, the actual division-by-$p$ is equivalent to
  performing the ciphertext-to-plaintext multiplication
  (#link(<subsec:bfv-mult-plain>)[\[subsec:bfv-mult-plain\]]) as
  follows:

  $\(A^(chevron.l g_1 chevron.r)\,B^(chevron.l g_1 chevron.r)\)dot.op sans("Encode")\(p^(- 1)\)med mod med q^(chevron.l 1 chevron.r)$

  $=\(A^(chevron.l g_1 chevron.r)\,B^(chevron.l g_1 chevron.r)\)dot.op p^(- 1) med mod med q^(chevron.l 1 chevron.r)$
  $gt.tri$ since
  $sans("Encode")\(p^(- 1)\)= p^(- 1) + 0 X + 0 X^2 + dots.h.c + 0 X^(n - 1)$

  $=\(p^(- 1) A^(chevron.l g_1 chevron.r)\,p^(- 1) B^(chevron.l g_1 chevron.r)\)med mod med q^(chevron.l 1 chevron.r)$

  $$

  Therefore, by multiplying the coefficients of two BGV ciphertext
  polynomials $A^(chevron.l g_1 chevron.r)$ and
  $B^(chevron.l g_1 chevron.r)$ by
  $\|p^(- 1)\|_(q^(chevron.l 1 chevron.r))$, we obtain the following
  effect:

  $\(\|p^(- 1)\|_(q^(chevron.l 1 chevron.r))dot.op A^(chevron.l g_1 chevron.r)\)dot.op S +\(\|p^(- 1)\|_(q^(chevron.l 1 chevron.r))dot.op B^(chevron.l g_1 chevron.r)\)med mod med q^(chevron.l 1 chevron.r)$

  $=\|p^(- 1)\|_(q^(chevron.l 1 chevron.r))dot.op\(p^(epsilon - 1) M + ⌊K'⌋_p + K'' p^epsilon\)med mod med q^(chevron.l 1 chevron.r)$

  $= p^(epsilon - 2) M + ⌊K' / p⌋ + K'' p^(epsilon - 1) med mod med q^(chevron.l 1 chevron.r)$

  $$

  Verbally speaking, the above inverse-$p$ multiplication to all
  polynomial coefficients of
  $\(A^(chevron.l g_1 chevron.r)\,B^(chevron.l g_2 chevron.r)\)$ has the
  following two effects: (1) scales down the plaintext and the noise by
  $p$\; and (2) reduces the modulus garbage term $K'$ to $⌊K' / p⌋$
  (i.e., right-shift by 1 base-$p$ digit).

  $$

  BGV's digit extraction procedure is equivalent to recursively
  evaluating $G_epsilon$ with the input $z_i$ by decreasing $epsilon$ by
  1 at each round (total $epsilon - 1$ rounds) as follows:

  #strong[Input:]
  $p^(epsilon - 1) M + K' + K'' p^epsilon med mod med hat(q)$

  #strong[1st Round:]
  \$G\_{\\varepsilon}(z\_i) \\xRightarrow{\\text{effect}}  p^{\\varepsilon - 2}M + \\left\\lfloor\\dfrac{K\'}{p}\\right\\rfloor + K\'\'^{\\langle 1 \\rangle}p^{\\varepsilon-1} \\bmod q^{\\langle 1 \\rangle}\$

  #strong[2nd Round:]
  \$G\_{\\varepsilon-1} \\circ G\_{\\varepsilon}(z\_i) \\xRightarrow{\\text{effect}}  p^{\\varepsilon - 3}M + \\left\\lfloor\\dfrac{K\'}{p^2}\\right\\rfloor + K\'\'^{\\langle 2 \\rangle}p^{\\varepsilon-2} \\bmod q^{\\langle 2 \\rangle}\$

  #strong[3rd Round:]
  \$G\_{\\varepsilon-2} \\circ G\_{\\varepsilon-1} \\circ G\_{\\varepsilon}(z\_i)  \\xRightarrow{\\text{effect}}  p^{\\varepsilon - 4}M + \\left\\lfloor\\dfrac{K\'}{p^3}\\right\\rfloor + K\'\'^{\\langle 3 \\rangle}p^{\\varepsilon-3} \\bmod q^{\\langle 3 \\rangle}\$

  $dots.v$

  #strong[$bold(epsilon - 1)$-th Round:]
  \$G\_{2}\\circ \\cdots \\circ G\_{\\varepsilon} (z\_i) \\xRightarrow{\\text{effect}}  M + K\'\'^{\\langle \\varepsilon - 1 \\rangle}p \\bmod q^{\\langle \\varepsilon - 1 \\rangle}\$

  $$

  As shown above, the entire digit extraction procedure results in two
  effects on the values stored in the plaintext slots: (1) scales down
  the message $p^(epsilon - 1) M$ to $M$\; and (2) zeros out the modulus
  garbage $K'$ (i.e., $⌊K' / p^(epsilon - 1)⌋ = 0$). The reason why
  $K''$ gets updated to
  $K'' ""^(chevron.l 1 chevron.r)\,K'' ""^(chevron.l 2 chevron.r)\,dots.h.c\,K'' ""^(chevron.l epsilon - 1 chevron.r)$
  across rounds is that each $i$-th round's evaluation of function
  $F_(epsilon.alt')$ and $G_epsilon.alt$ is done modulo
  $p^(epsilon - i)$, which produces new $p^(epsilon - i)$-multiple
  overflow garbage values each time.

  $$

  Beneficially, the $epsilon - 1$ rounds of inverse-$p$ multiplications
  yields the effect of scaling down the plaintext
  $p^(epsilon - 1) m_i arrow.r m_i$ and the noise
  $k'' p^epsilon arrow.r k'' p$, which has the desired noise scaling
  factor $p$ for standard BGV ciphertexts.

  $$

+ #strong[#underline[SlotToCoeff]:] This step works the same way as
  BFV's SlotToCoeff step: move $m_i + k''_i p$ stored in the input
  vector slots back to the polynomial coefficient positions by
  homomorphically multiplying with \$\\hathat W^\*\$. Upon completing
  this step, the ciphertext modulus is some value $q_(l')$ smaller than
  $q_L$, because the homomorphic operation of step $4 tilde.op 6$ has
  consumed a few multiplicative levels. The resulting plaintext
  coefficients are $m_i + k'''_i p$, where $k''' > k''$ due to the
  additional noise generated by homomorphically running the SlotToCoeff
  step. The plaintext modulus (i.e., the noise scaling factor) and the
  noise scaling factor are $p$ at this point, the standard one for BGV
  ciphertexts. We let these polynomials be $M$ and $K'''$ each, and the
  output ciphertext is
  $sans("RLWE")_(S\,sigma)\(M + K''' p\)med mod med q_(l')$.

=== Discussion
<discussion>
: BGV switches the modulus from $q_l arrow.r hat(q)$ to eliminate the
$q_l$-multiple overflows during bootstrapping. After switching the
modulus $q_l arrow.r hat(q)$ and then ModRaise, the encrypted plaintext
gets the $K' hat(q)$ overflow term, which can be reduced to $K'$ from
the plaintext modulus's perspective due to the special property
$hat(q) equiv 1 med mod med p^epsilon$ (where $p^epsilon$ is the
plaintext modulus).

$$

The larger $epsilon$ is, the greater the (base-$p$) digit-wise gap
between $p^(epsilon - 1) M$ and $K'$ becomes; thus, the less likely it
is that the decryption would fail (i.e., fail to zero out $K'$).
However, a larger $epsilon$ means the digit extraction operation would
be more expensive.

$$

Like the case of BFV's bootstrapping
(Summary~@subsubsec:bfv-bootstrapping-summary in
#link(<subsubsec:bfv-bootstrapping-summary>)[\[subsubsec:bfv-bootstrapping-summary\]]),
we can generalize the plaintext modulus (i.e., noise scaling factor) to
$p^r$ where $p$ is a prime and $r$ can be any positive integer.

=== Comparing the Bootstrapping in BFV, BGV, and CKKS
<subsubsec:bootstrapping-differences>
Both BFV and BGV's bootstrapping use digit extraction, but for different
purposes. In BFV, digit extraction is used to eliminate the noise in the
lower-bit area. In BGV, digit extraction is used to eliminate the
modulus garbage values in the lower-bit area generated by ModRaise from
$hat(q) arrow.r q_L$. In addition, at each round of BGV's digit
extraction, we explicitly multiply the coefficients of the ciphertext
polynomials by $\|p^(- 1)\|_(q^(chevron.l i chevron.r))$. In BFV, this
explicit inverse-$p$ multiplication is skipped and we only conceptually
re-interpret the scaling factor.

CKKS's bootstrapping does not involve digit extraction because it has no
values to eliminate in the lower-bit area. Instead, regarding the
modulus garbage value ModRaise from $q_0 arrow.r q_L$, this is
eliminated by EvalExp's homomorphic evaluation of an approximate sine
function. Although CKKS's bootstrapping resets its modulus to a large
value, this operation does not decrease the noise-to-message ratio, and
this ratio continuously increases over homomorphic operations.
