The BFV scheme is designed for homomorphic addition and multiplication
of integers. BFV's encoding scheme does not require such approximation
issues because BFV is designed to encode only integers. Therefore, BFV
guarantees exact encryption and decryption. BFV is suitable for use
cases where the encrypted and decrypted values should exactly match
(e.g., voting, financial computation), whereas CKKS is suitable for the
use cases that tolerate tiny errors (e.g., data analytics, machine
learning).

In BFV, each plaintext is encrypted as an RLWE ciphertext. Therefore,
BFV's ciphertext-to-ciphertext addition, ciphertext-to-plaintext
addition, and ciphertext-to-plaintext multiplication are implemented
based on GLWE's homomorphic addition and multiplication (as we learned
in \$\\autoref{part:generic-fhe}\$), with $k = 1$ to make GLWE an RLWE.

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

]
== Single Value Encoding
<subsec:bfv-single-encoding>
BFV supports two encoding schemes: single value encoding and batch
encoding. In this subsection, we will explain the single value encoding
scheme.

#block[
#strong[#underline[Input Integer]:] Decompose the input integer
$m in bb(Z)_(gt.eq 0)$ (i.e., 0 or any positive integer) as follows:

$m = b_(n - 1) dot.op 2^(n - 1) + b_(n - 2) dot.op 2^(n - 2) + dots.h.c + b_1 dot.op 2^1 + b_0 dot.op 2^0$
, where each $b_i in { 0\,1 }$

$$

#strong[#underline[Encoded Polynomial]:]
$M\(X\)= b_0 + b_1 X + b_2 X^2 + dots.h.c + b_(n - 1) X^(n - 1) in cal(R)_(chevron.l n\,t chevron.r)$

$$

#strong[#underline[Decoding]:] $M\(X = 2\)= m$

]
Let's analyze whether the encoding scheme in
Summary~@subsec:bfv-single-encoding ensures correct decoding after
addition and multiplication. This is equivalent to showing that:

$upright("Decode")\(sigma\(m_1\)+ sigma\(m_2\)\)= m_1 + m_2$ $gt.tri$
where $sigma$ is the encoding function

$upright("Decode")\(sigma\(m_1\)dot.op sigma\(m_2\)\)= m_1 dot.op m_2$

Let $sigma\(m_1\)= M_1\(X\)$ and $sigma\(m_2\)= M_2\(X\)$. Then,

$upright("Decode")\(sigma\(m_1\)+ sigma\(m_2\)\)= upright("Decode")\(M_1\(X\)+ M_2\(X\)\)$

$= upright("Decode")\(M_(1 + 2)\(X\)\)$ $gt.tri$ where
$M_(1 + 2)\(X\)= M_1\(X\)+ M_2\(X\)$

$= M_(1 + 2)\(2\)$ $gt.tri$ since decoding is evaluating the polynomial
at $X = 2$

$= M_1\(2\)+ M_2\(2\)$ $gt.tri$ since evaluating $M_(1 + 2)\(X\)$ at
$X = 2$ is computationally the same as splitting $M_(1 + 2)\(X\)$ into
$M_1\(X\)$ and $M_2\(X\)$, evaluating $M_1\(2\)$ and $M_2\(2\)$ and
summing them

$$

Similarly, the decoding preserves correctness over multiplication as
well:

$upright("Decode")\(sigma\(m_1\)dot.op sigma\(m_2\)\)= upright("Decode")\(M_1\(X\)dot.op M_2\(X\)\)$

$= upright("Decode")\(M_(1 dot.op 2)\(X\)\)$ $gt.tri$ where
$M_(1 dot.op 2)\(X\)= M_1\(X\)dot.op M_2\(X\)$

$= M_(1 dot.op 2)\(2\)$ $gt.tri$ since decoding is evaluating the
polynomial at $X = 2$

$= M_1\(2\)dot.op M_2\(2\)$ $gt.tri$ since evaluating
$M_(1 dot.op 2)\(X\)$ at $X = 2$ is computationally the same as
splitting $M_(1 dot.op 2)\(X\)$ into $M_1\(X\)$ and $M_2\(X\)$,
evaluating $M_1\(2\)$ and $M_2\(2\)$ and multiplying them

$$

Therefore, the single value encoding scheme preserves the correctness of
decoding after addition and multiplication.

$$

The encoding scheme in Summary~@subsec:bfv-single-encoding can be
validly used for fully homomorphic encryption only if the multiplication
of the encoded polynomials do not exceed the polynomial ring's degree
$n$, because once the degree gets reduced due to an overflow, the
evaluated values of polynomials lose consistency. Also, the coefficients
of polynomials should not wrap modulo $t$ after additions or
multiplications. Due to these constraints, the single value encoding is
not a good choice for fully homomorphic encryption. Also, the single
value encoding is computationally inefficient, because each polynomial
can encode only a single value even if it holds $n$ coefficients.

== Batch Encoding
<subsec:bfv-batch-encoding>
While the single-value encoding scheme
(#link(<subsec:bfv-single-encoding>)[0.1]) encodes & decodes each
individual value one at a time, the batch encoding scheme does the same
for a huge list of values simultaneously using a large dimensional
vector. Therefore, batch encoding is more efficient than single-value
encoding. Furthermore, batch-encoded values can be homomorphically added
or multiplied simultaneously element-wise by vector-to-vector addition
and Hadamard product. Therefore, the homomorphic operation of
batch-encoded values can be processed more efficiently in a SIMD
(single-instruction-multiple-data) manner than single-value encoded
ones.

BFV's encoding converts an $n$-dimensional integer input slot vector
$arrow(v) =\(v_0\,v_1\,v_2\,dots.h.c v_(n - 1)\)$ modulo $t$ into
another $n$-dimensional vector
$arrow(m) =\(m_0\,m_1\,m_2\,dots.h.c m_(n - 1)\)$ modulo $t$, which are
the coefficients of the encoded $\(n - 1\)$-degree (or lesser-degree)
polynomial $M\(X\)in bb(Z)_t\[X\]\/\(X^n + 1\)$.

$$

=== Encoding#sub[1]
<subsubsec:bfv-encoding-1>
In
#link(<subsec:poly-vector-transformation>)[\[subsec:poly-vector-transformation\]],
we learned that an $\(n - 1\)$-degree (or lesser degree) polynomial can
be isomorphically mapped to an $n$-dimensional vector based on the
mapping $sigma$ (we notate $sigma_c$ in
#link(<subsec:poly-vector-transformation>)[\[subsec:poly-vector-transformation\]]
as $sigma$ for simplicity):

$sigma : M\(X\)in bb(Z)_t\[X\]\/\(X^n + 1\)arrow.r\(M\(omega\)\,M\(omega^3\)\,M\(omega^5\)\,dots.h.c\,M\(omega^(2 n - 1)\)\)in bb(Z)_t^n$

$$

, which evaluates the polynomial $M\(X\)$ at $n$ distinct
$\(mu = 2 n\)$-th primitive roots of unity:
$omega\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 1)$. Let $arrow(m)$ be
a vector that contains $n$ coefficients of the polynomial $M\(X\)$.
Then, we can express the mapping $sigma$ as follows:

$arrow(v) = W^T dot.op arrow(m)$

$$

, where $W^T$ is as follows:

$W^T = mat(delim: "[", 1, \(omega\), \(omega\)^2, dots.h.c, \(omega\)^(n - 1); 1, \(omega^3\), \(omega^3\)^2, dots.h.c, \(omega^3\)^(n - 1); 1, \(omega^5\), \(omega^5\)^2, dots.h.c, \(omega^5\)^(n - 1); dots.v, dots.v, dots.v, dots.down, dots.v; 1, \(omega^(2 n - 1)\), \(omega^(2 n - 1)\)^2, dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$
\# $W^T$ is a transpose of $W$ described in
#link(<subsec:poly-vector-transformation>)[\[subsec:poly-vector-transformation\]]

$$

Note that the dot product between each row of $W^T$ and $arrow(m)$
computes the evaluation of $M\(X\)$ at each
$X = { w\,w^3\,w^5\,dots.h.c\,w^(2 n - 1) }$. In the BFV encoding
scheme, the Encoding#sub[1] process encodes an $n$-dimensional input
slot vector $arrow(v)$ $in bb(Z)_t$ into a plaintext polynomial
$M\(X\)in bb(Z)_t\[X\]\/\(X^n + 1\)$, and the Decoding#sub[2] process
decodes $M\(X\)$ back to $arrow(v)$. Since $W^T dot.op arrow(m)$ gives
us $arrow(v)$ which is a decoding of $M\(X\)$, we call $W^T$ a decoding
matrix. Meanwhile, the goal of Encoding#sub[1] is to encode $arrow(v)$
into $M\(X\)$ so that we can do homomorphic computations based on
$M\(X\)$. Given the relation $arrow(v) = W^T dot.op arrow(m)$, the
encoding formula can be derived as follows:

$\(W^T\)^(- 1)dot.op arrow(v) =\(W^T\)^(- 1)W^T dot.op arrow(m)$

$arrow(m) =\(W^T\)^(- 1)dot.op arrow(v)$

$$

Therefore, we need to find out what $\(W^T\)^(- 1)$ is, the inverse of
$W^T$ as the encoding matrix. But we already learned from
Theorem~@subsec:vandermonde-euler (in
#link(<subsec:vandermonde-euler>)[\[subsec:vandermonde-euler\]]) that
$V^(- 1) = frac(V^T dot.op I_n^R, n)$, where $V = W^T$ and $V^T = W$. In
other words, $\(W^T\)^(- 1)= frac(W dot.op I_n^R, n)$. Therefore, we can
express the BFV encoding formula as:

$arrow(m) =\(W^T\)^(- 1)dot.op arrow(v) = frac(W dot.op I_n^R dot.op arrow(v), n)$,
where

$$

$W = mat(delim: "[", 1, 1, 1, dots.h.c, 1; \(omega\), \(omega^3\), \(omega^5\), dots.h.c, \(omega^(2 n - 1)\); \(omega\)^2, \(omega^3\)^2, \(omega^5\)^2, dots.h.c, \(omega^(2 n - 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), \(omega^5\)^(n - 1), dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$

$= mat(delim: "[", 1, 1, dots.h.c, 1, 1, dots.h.c, 1, 1; \(omega\), \(omega^3\), dots.h.c, \(omega^(n / 2 - 1)\), \(omega^(-\(n / 2 - 1\))\), dots.h.c, \(omega^(- 3)\), \(omega^(- 1)\); \(omega\)^2, \(omega^3\)^2, dots.h.c, \(omega^(n / 2 - 1)\)^2, \(omega^(-\(n / 2 - 1\))\)^2, dots.h.c, \(omega^(- 3)\)^2, \(omega^(- 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), dots.h.c, \(omega^(n / 2 - 1)\)^(n - 1), \(omega^(-\(n / 2 - 1\))\)^(n - 1), dots.h.c, \(omega^(- 3)\)^(n - 1), \(omega^(- 1)\)^(n - 1); #none)$

$$

, where $omega$ is a primitive $2 n$-th root of unity modulo $t$ (which
implies $t equiv 1 med mod med 2 n$). This implies that
$omega = g^(frac(t - 1, 2 n)) med mod med t$ ($g$ is a generator of
$bb(Z)_t^times$ (see
#link(<subsubsec:poly-vector-transformation-modulus>)[\[subsubsec:poly-vector-transformation-modulus\]]).

In
#link(<subsec:poly-vector-transformation>)[\[subsec:poly-vector-transformation\]],
we learned that $W$ is a valid basis of the $n$-dimensional vector
space. Therefore, $frac(W dot.op arrow(v), n) = arrow(m)$ is guaranteed
to be a unique vector corresponding to each $arrow(v)$ in the
$n$-dimensional vector space $bb(Z)_t^n$ (refer to
Theorem~@subsec:projection in
#link(<subsec:projection>)[\[subsec:projection\]]), and thereby the
polynomial $M\(X\)$ comprising the $n$ elements of $arrow(m)$ as
coefficients is a unique polynomial bi-jective to $arrow(v)$.

Note that by computing $frac(W dot.op I_n^R dot.op arrow(v), n)$ , we
transform the input slot vector $arrow(v)$ into another vector
$arrow(m)$ in the same vector space $bb(Z)_t^n$, while preserving
isomorphism between these two vectors (i.e., bi-jective one-to-one
mappings and homomorphism on the $\(+\,dot.op\)$ operations).

=== Encoding#sub[2]
<encoding2>
Once we have the $n$-dimensional vector $arrow(m)$, we scale (i.e.,
multiply) it by some scaling factor $Delta = ⌊q / t⌋$, where $q$ is the
ciphertext modulus. We scale $arrow(m)$ by $Delta$ and make it
$Delta arrow(m)$. The $n$ integers in $Delta arrow(m)$ will be used as
$n$ coefficients of the plaintext polynomial for RLWE encryption. The
finally encoded plaintext polynomial
$Delta M = sum_(i = 0)^(n - 1) Delta m_i X^i$.

=== Decoding#sub[1]
<subsubsec:bfv-enc-dec-decoding1>
Once an RLWE ciphertext is (first-half) decrypted to
$Delta M = sum_(i = 0)^(n - 1) Delta m_i X^i$, we compute
$frac(Delta arrow(m), Delta) = arrow(m)$.

=== Decoding#sub[2]
<decoding2>
In #link(<subsubsec:bfv-encoding-1>)[0.2.1], we already derived the
decoding formula that transforms an $\(n - 1\)$-degree polynomial having
integer modulo $t$ coefficients into an $n$-dimensional input slot
vector as follows:

$arrow(v) = W^T dot.op arrow(m)$

=== Summary
<subsubsec:bfv-encoding-summary>
#block[
#strong[#underline[Input]:] An $n$-dimensional integer modulo $t$ vector
$arrow(v) =\(v_0\,v_1\,dots.h.c\,v_(n - 1)\)in bb(Z)_t^n$

#horizontalrule

#strong[#underline[Encoding]]

+ Convert $arrow(v) in bb(Z)_t^n$ into $arrow(m) in bb(Z)_t^n$ by
  applying the transformation
  $arrow(m) = n^(- 1) dot.op W dot.op I_n^R dot.op arrow(v)$

  , where $W$ is a basis of the $n$-dimensional vector space crafted as
  follows:

  $W = mat(delim: "[", 1, 1, 1, dots.h.c, 1; \(omega\), \(omega^3\), \(omega^5\), dots.h.c, \(omega^(2 n - 1)\); \(omega\)^2, \(omega^3\)^2, \(omega^5\)^2, dots.h.c, \(omega^(2 n - 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), \(omega^5\)^(n - 1), dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$

  $= mat(delim: "[", 1, 1, dots.h.c, 1, 1, dots.h.c, 1, 1; \(omega\), \(omega^3\), dots.h.c, \(omega^(n / 2 - 1)\), \(omega^(-\(n / 2 - 1\))\), dots.h.c, \(omega^(- 3)\), \(omega^(- 1)\); \(omega\)^2, \(omega^3\)^2, dots.h.c, \(omega^(n / 2 - 1)\)^2, \(omega^(-\(n / 2 - 1\))\)^2, dots.h.c, \(omega^(- 3)\)^2, \(omega^(- 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), dots.h.c, \(omega^(n / 2 - 1)\)^(n - 1), \(omega^(-\(n / 2 - 1\))\)^(n - 1), dots.h.c, \(omega^(- 3)\)^(n - 1), \(omega^(- 1)\)^(n - 1); #none)$

  $$

  , where $omega$ is a primitive $2 n$-th root of unity modulo $t$. This
  implies that $omega = g^(frac(t - 1, 2 n)) med mod med t$ ($g$ is a
  generator of $bb(Z)_t^times$ (see
  #link(<subsubsec:poly-vector-transformation-modulus>)[\[subsubsec:poly-vector-transformation-modulus\]]).

  $$

+ Convert $arrow(m)$ into a scaled integer vector $Delta arrow(m)$,
  where $1 lt.eq Delta lt.eq floor.l q / t floor.r$ is a scaling factor.
  If $Delta$ is too close to 1 (i.e., $t$ is too big), the #strong[noise
  budget] will become too small (making decryption fail easily). If
  $Delta$ is too close to $q$ (i.e., $t$ is too small), the
  #strong[message capacity] will become too small (i.e., the plaintext
  modulus $t$ limits the range of values that can be encoded). The
  finally encoded plaintext polynomial
  $Delta M = sum_(i = 0)^(n - 1) Delta m_i X^i upright(" ") in bb(Z)_q\[X\]\/\(X^n + 1\)$.

#horizontalrule

#strong[#underline[Decoding]:] From the plaintext polynomial
$Delta M = sum_(i = 0)^(n - 1) Delta m_i X^i$, recover
$arrow(m) = frac(Delta arrow(m), Delta)$. Then, compute
$arrow(v) = W^T dot.op arrow(m)$.

]
However, Summary~@subsubsec:bfv-encoding-summary is not the final
version of BFV's batch encoding. In #link(<subsec:bfv-rotation>)[0.9],
we will explain how to homomorphically rotate the input vector slots
without decrypting the ciphertext that encapsulates it. To support such
homomorphic rotation, we will need to slightly update the encoding
scheme explained in Summary~@subsubsec:bfv-encoding-summary. We will
explain how to do this in #link(<subsec:bfv-rotation>)[0.9], and BFV's
final encoding scheme is summarized in
Summary~@subsubsec:bfv-rotation-summary in
#link(<subsubsec:bfv-rotation-summary>)[0.9.3].

== Encryption and Decryption
<subsec:bfv-enc-dec>
BFV encrypts and decrypts ciphertexts based on the RLWE cryptosystem
(#link(<sec:rlwe>)[\[sec:rlwe\]]) with the sign of each $A dot.op S$
term flipped in the encryption and decryption formula. Specifically,
this is equivalent to the alternative version of the GLWE cryptosystem
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]]) with
$k = 1$. Thus, BFV's encryption and decryption formulas are as follows:

#block[
#strong[#underline[Initial Setup]:]
$Delta = ⌊q / t⌋ upright(" is a plaintext scaling factor for polynomial encoding")\,upright(" ") S arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)$

, where plaintext modulus $t$ is either a prime ($p$) or a power of
prime ($p^r$), and ciphertext modulus $q gt.double t$. As for the
coefficients of polynomial $S$, they are ternary (i.e.,
${ - 1\,0\,1 }$).

#horizontalrule

#strong[#underline[Encryption Input]:]
$Delta M in cal(R)_(chevron.l n\,q chevron.r)$,
$A_i arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)$,
$E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

$$

+ Compute
  $B = - A dot.op S + Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ $sans("RLWE")_(S\,sigma)\(Delta M + E\)=\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

#horizontalrule

#strong[#underline[Decryption Input]:]
$sans("ct") =\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

$sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= ⌈frac(B + A dot.op S med mod med q, Delta)⌋ med mod med t = ⌈frac(Delta M + E, Delta)⌋ med mod med t = M med mod med t$

\(The noise $E = sum_(i = 0)^(n - 1) e_i X^i$ gets eliminated by the
rounding process)

$$

#strong[#underline[Conditions for Correct Decryption]:]

As explained in Summary~@subsubsec:lwe-noise-bound (in
#link(<subsubsec:lwe-noise-bound>)[\[subsubsec:lwe-noise-bound\]]), the
noise bound is $\|- epsilon.alt k_i t + e_i\|< Delta / 2$, where $k_i$
is each coefficient of the polynomial $K$ that accounts for the
$t$-multiple overflows of the coefficients of the plaintext polynomial
updated across homomorphic operations.

]
In this section, we will often write
$sans("RLWE")_(S\,sigma)\(Delta M + E\)$ as
$sans("RLWE")_(S\,sigma)\(Delta M\)$ for simplicity, because
$sans("RLWE")_(S\,sigma)\(Delta M + E\)approx sans("RLWE")_(S\,sigma)\(Delta M\)$
(i.e., they decrypt to the same message). Even in the case that we write
$sans("RLWE")_(S\,sigma)\(Delta M\)$ instead of
$sans("RLWE")_(S\,sigma)\(Delta M + E\)$, you should assume this as an
encryption of $Delta M + E$ (i.e., the noise is included inside the
scaled message).

We will explain the conditions for BFV's correct decryption in more
detail in #link(<subsubsec:bfv-noise-analysis>)[0.4.1].

== Ciphertext-to-Ciphertext Addition
<subsec:bfv-add-cipher>
BFV's ciphertext-to-ciphertext addition uses RLWE's
ciphertext-to-ciphertext addition scheme with the sign of the
$A dot.op S$ term flipped in the encryption and decryption formula.
Specifically, this is equivalent to the alternative GLWE version's
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]])
ciphertext-to-ciphertext addition scheme with $k = 1$.

#block[
$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)+ sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)$

$=\(A^(chevron.l 1 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r)\)+\(A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 2 chevron.r)\)$

$=\(A^(chevron.l 1 chevron.r) + A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)$

$= sans("RLWE")_(S\,sigma)\(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)\)$

]
=== Noise Bound Analysis
<subsubsec:bfv-noise-analysis>
In the last part of Summary~@subsec:bfv-enc-dec (in
#link(<subsec:bfv-enc-dec>)[0.3]), we learned the noise bound conditions
for BFV's correct decryption. In this subsection, we will explain how
this condition holds in more detail by walking through BFV's
ciphertext-to-ciphertext addition.

Let's denote the homomorphically added ciphertext as follows:

$\(A^(chevron.l 3 chevron.r)\,upright(" ") B^(chevron.l 3 chevron.r)\)=\(A^(chevron.l 1 chevron.r) + A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)med mod med q$

$$

Applying the first step of decryption to it yields the following
intermediate result:

$B^(chevron.l 3 chevron.r) + A^(chevron.l 3 chevron.r) dot.op S med mod med q$

$B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r) + A^(chevron.l 1 chevron.r) dot.op S + A^(chevron.l 2 chevron.r) dot.op S med mod med q$

$=\(- A^(chevron.l 1 chevron.r) dot.op S + Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)+\(- A^(chevron.l 2 chevron.r) dot.op S + Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)+ A^(chevron.l 1 chevron.r) dot.op S + A^(chevron.l 2 chevron.r) dot.op S med mod med q$

$= Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q$

$$

The second step of decryption is to divide each coefficient of the above
intermediate polynomial by $Delta$, round it, and reduce it modulo $t$
as follows:

$$

$⌈frac(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$$

Correct decryption requires the above result to match the value
$M^(chevron.l 1 + 2 chevron.r) = M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r) med mod med t$,
where $M^(chevron.l 1 + 2 chevron.r)$ is the modulo $t$-reduced final
polynomial. Let's define
$epsilon.alt = q / t - ⌊q / t⌋ = q / t - Delta$. Given $q gt.double t$,
$epsilon.alt$ is a fractional value between $\[0\,1\)$. Now, we can
re-write the above decryption term as follows:

$$

$⌈frac(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$$

$⌈frac(\(q / t - epsilon.alt\)dot.op\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)+ E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$
$gt.tri$ applying $Delta = ⌊q / t⌋ = q / t - epsilon.alt$

$$

$= ⌈frac(\(q / t - epsilon.alt\)dot.op\(M^(chevron.l 1 + 2 chevron.r) + t dot.op K\)+ E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$gt.tri$ where $t dot.op K$ represents the $t$-multiple overflows
generated by the modulo addition of
$M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)$

$$

$$

$= ⌈frac(q / t dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op M^(chevron.l 1 + 2 chevron.r) + q / t dot.op t dot.op K - epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$$

$= ⌈frac(q / t dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$gt.tri$ since $q / t dot.op t = q$, and $q dot.op K med mod med q = 0$

$$

$$

$= ⌈frac(⌊q / t⌋ dot.op M^(chevron.l 1 + 2 chevron.r) + epsilon.alt dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$gt.tri$ applying $q / t = ⌊q / t⌋ + epsilon.alt$

$$

$$

$= ⌈frac(⌊q / t⌋ dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q, Delta)⌋ med mod med t$

$$

$$

$= ⌈frac(⌊q / t⌋ dot.op M^(chevron.l 1 + 2 chevron.r) - epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r), Delta)⌋ med mod med t$

$gt.tri$ applying the special assumption
$\|epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)\|< Delta / 2$
to all $n$ coefficients (see
#link(<subsubsec:lwe-noise-bound>)[\[subsubsec:lwe-noise-bound\]])

$$

$$

$= M^(chevron.l 1 + 2 chevron.r) + ⌈frac(E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) - epsilon.alt dot.op t dot.op K, Delta)⌋ med mod med t$
$gt.tri$ since $Delta = ⌊q / t⌋$, and
$ceil.l M^(chevron.l 1 + 2 chevron.r) floor.r = M^(chevron.l 1 + 2 chevron.r)$

$$

$$

$= M^(chevron.l 1 + 2 chevron.r) med mod med t$ $gt.tri$ applying the
special assumption
$epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) < Delta / 2$
to all $n$ coefficients

$$

The above final expression implies that correct decryption (i.e.,
$M^(chevron.l 1 + 2 chevron.r)$) is preserved if the special assumption
$epsilon.alt dot.op t dot.op K + E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r) < Delta / 2$
holds (for all $n$ coefficients of the polynomial). At a high level, the
greater the ciphertext modulus $q$ becomes compared to the plaintext
modulus $t$, the greater the scaling factor $Delta$ becomes, which can
sustain a greater noise budget
($E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)$) and greater
wrapping around $t$-multiple overflows of the plaintext
($epsilon.alt dot.op t dot.op K$).

This noise bound principle not only applies to homomorphic addition but
also to homomorphic multiplication and rotation, which will be explained
in later subsections. The term
$E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)$ can be
generalized as the cumulative noise across all homomorphic operations
(e.g., additions, multiplications, rotations), and the term
$epsilon.alt dot.op t dot.op K$ can be generalized as the amount of
$t$-multiple overflows of each coefficient of the plaintext polynomial
computed across homomorphic operations.

== Ciphertext-to-Plaintext Addition
<subsec:bfv-add-plain>
BFV's ciphertext-to-plaintext addition uses RLWE's
ciphertext-to-plaintext addition scheme with the sign of the
$A dot.op S$ term flipped in the encryption and decryption formulas.
Specifically, this is equivalent to the alternative GLWE version's
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]])
ciphertext-to-plaintext addition scheme
(#link(<sec:glwe-add-plain>)[\[sec:glwe-add-plain\]]) with $k = 1$.

#block[
$sans("RLWE")_(S\,sigma)\(Delta M + E\)+ Delta Lambda$

$=\(A\,upright(" ") B\)+ Delta Lambda$

$=\(A\,upright(" ") B + Delta dot.op Lambda\)$

$= sans("RLWE")_(S\,sigma)\(Delta\(M + Lambda\)+ E\)$

]
== Ciphertext-to-Plaintext Multiplication
<subsec:bfv-mult-plain>
BFV's ciphertext-to-plaintext multiplication uses RLWE's
ciphertext-to-plaintext multiplication scheme with the sign of the
$A dot.op S$ term flipped in the encryption and decryption formula.
Specifically, this is equivalent to the alternative GLWE version's
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]])
ciphertext-to-plaintext multiplication scheme
(#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]) with $k = 1$.

#block[
$sans("RLWE")_(S\,sigma)\(Delta M + E\)dot.op Lambda$

$=\(A\,upright(" ") B\)dot.op Lambda$

$=\(A dot.op Lambda\,upright(" ") B dot.op Lambda\)$

$= sans("RLWE")_(S\,sigma)\(Delta\(M dot.op Lambda\)+ Lambda E\)$

]
== Ciphertext-to-Ciphertext Multiplication
<subsec:bfv-mult-cipher>
#strong[\- Reference 1:]
#link("https://www.inferati.com/blog/fhe-schemes-bfv")[Introduction to the BFV encryption scheme]~@inferati-bfv

#strong[\- Reference 2:]
#link("https://eprint.iacr.org/2012/144.pdf")[Somewhat Partially Fully Homomorphic Encryption]~#cite(label("cryptoeprint:2012/144"))

Given two ciphertexts
$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r)\)$ and
$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r)\)$, the goal
of ciphertext-to-ciphertext multiplication is to derive a new ciphertext
whose decryption is
$Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$.
Ciphertext-to-ciphertext multiplication is more complex than
ciphertext-to-plaintext multiplication. It comprises four steps: (1)
ModRaise\; (2) polynomial multiplication; (3) relinearization; and (4)
rescaling.

For better understanding, we will explain BFV's ciphertext-to-ciphertext
multiplication based on the alternate version of RLWE
(Theorem~@subsec:glwe-alternative in
#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]]), where
the sign of the $A S$ term is flipped in the encryption and decryption
formulas.

=== ModRaise
<subsubsec:bfv-mult-cipher-modraise>
We learned from Summary~@subsec:bfv-enc-dec (in
#link(<subsec:bfv-enc-dec>)[0.3]) that a BFV ciphertext whose ciphertext
modulus is $q$ has the (decryption) relation:
$Delta M + E = A dot.op S + B - K dot.op q$, where $K dot.op q$ stands
for modulo reduction by $q$. ModRaise is a process of forcibly raising
the modulus of a ciphertext from $q arrow.r Q$, where $q lt.double Q$.
Suppose we modify the modulus of ciphertext $\(A\,B\)$ from $q$ to $Q$,
where $Q = q dot.op Delta$ (remember $Delta = ⌊q / t⌋$). Then, the
decryption of the #emph[mod-raised] ciphertext will output
$A dot.op S + B med mod med Q$. However, since each polynomial
coefficient of $A$ and $B$ is less than $q$ and each polynomial
coefficient of $S$ is either ${ - 1\,0\,1 }$, the resulting polynomial
of $A dot.op S + B$ is guaranteed to have each coefficient strictly less
than $Q$ even without modulo reduction by $Q$-- this is because
$\(q - 1\)dot.op n +\(q - 1\)< Q$, where $\(q - 1\)dot.op n$ is the
maximum possible coefficient of $A dot.op S$ and $\(q - 1\)$ is the
maximum possible coefficient of $B$. And as mentioned before, we know
the relation: $A dot.op S + B = Delta M + E + K q$. Therefore, the
decryption of the #emph[mod-raised] ciphertext $\(A\,B\)med mod med Q$
is as follows:

$Delta M + E + K q med mod med Q = Delta M + E + K q$ $gt.tri$ since
$Delta M + E + K q < Q$

$$

The first step of BFV's ciphertext-to-ciphertext multiplication is to
#emph[mod-raise] the two input ciphertexts
$\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)med mod med q$
and
$\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)med mod med q$
from $q arrow.r Q$ (where $Q = q dot.op Delta$) as follows:

$\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)med mod med Q$

$\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)med mod med Q$

$$

After ModRaise, the decryption of these two ciphertexts would be the
following:

$A^(chevron.l 1 chevron.r) dot.op S + B^(chevron.l 1 chevron.r) = Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q < Q$

$A^(chevron.l 2 chevron.r) dot.op S + B^(chevron.l 2 chevron.r) = Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q < Q$

$$

Therefore, the #emph[mod-raised] ciphertexts have the following form:

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r) + K_1 q\)=\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)med mod med Q$

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r) + K_2 q\)=\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)med mod med Q$

=== Polynomial Multiplication
<subsubsec:bfv-mult-cipher-multiplication>
Our next goal is to derive a new ciphertext which encrypts
$\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q\)$.

First, we can derive the following relation:

$\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q\)$

$=\(A^(chevron.l 1 chevron.r) dot.op S + B^(chevron.l 1 chevron.r)\)dot.op\(A^(chevron.l 2 chevron.r) dot.op S + B^(chevron.l 2 chevron.r)\)$

$= underbrace(B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r), D_0) + underbrace(\(B^(chevron.l 2 chevron.r) A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)\), D_1) dot.op S + underbrace(\(A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)\), D_2) dot.op S dot.op S$

$= D_0 + D_1 dot.op S + D_2 dot.op S^2$

$$

Meanwhile, we also have the following relations:

$sans("RLWE")_(S\,sigma)^(- 1)\(Delta M^(chevron.l 1 chevron.r) + K_1 q\)= Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q$

$sans("RLWE")_(S\,sigma)^(- 1)\(Delta M^(chevron.l 2 chevron.r) + K_2 q\)= Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q$

$$

Combining all these, we reach the following relation:

$sans("RLWE")_(S\,sigma)^(- 1)\(Delta M^(chevron.l 1 chevron.r) + K_1 q\)dot.op sans("RLWE")_(S\,sigma)^(- 1)\(Delta M^(chevron.l 2 chevron.r) + K_2 q\)= D_0 + D_1 dot.op S + D_2 dot.op S^2$

$$

Notice that $D_0\,D_1\,$ and $D_2$ are known values as ciphertext
components, whereas $S$ is only known to the private key owner.
Therefore, we can view $D_0 + D_1 dot.op S + D_2 dot.op S^2$ as a
decryption formula such that given the ciphertext components
$D_0\,D_1\,D_2$ and the private key $S$, one can derive
$\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q\)$.
In other words, we can let $\(D_0\,D_1\,D_2\)$ be a new form of
ciphertext which can be decrypted by $S$ into
$\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q\)$.

However, $\(D_0\,D_1\,D_2\)$ is not in the RLWE ciphertext format,
because it has 3 components instead of 2. Having 3 ciphertext components
is computationally inefficient, as its decryption involves a square root
of $S$ (i.e., $S^2$). Over consequent ciphertext-to-ciphertext
multiplications, this $S$ term will double its exponents as
$S^4\,S^8\,dots.h.c$ as well as the number of ciphertext components,
which would exponentially increase the computational overhead of
decryption. Therefore, we want to convert the intermediate ciphertext
format $\(D_0\,D_1\,D_2\)$ into a regular BFV ciphertext format that has
two polynomials as ciphertext components. This conversion process is
called a relinearization process (which will be explained in the next
subsection).

=== Relinearization
<subsubsec:bfv-mult-cipher-relinearization>
Relinearization is a process of converting the polynomial triplet
$\(D_0\,D_1\,D_2\)in cal(R)_(chevron.l n\,Q chevron.r)^3$ into two RLWE
ciphertexts $sans("ct")_alpha$ and $sans("ct")_beta$ which hold the
relation:
$D_0 + D_1 S + D_2 S^2 = sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")_alpha + sans("ct")_beta\)$.

In the formula $D_0 + D_1 S + D_2 S^2$, we can re-write $D_0 + D_1 S$ as
a #emph[synthetic] RLWE ciphertext $sans("ct")_alpha =\(D_1\,D_0\)$,
which can be decrypted by $S$ into $D_1 S + D_0$. Similarly, our next
task is to derive a synthetic RLWE ciphertext $sans("ct")_beta$ whose
decryption is $D_2 dot.op S^2$ (i.e.,
$sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")_beta\)= D_2 dot.op S^2$).

A naive way of creating a ciphertext that encrypts $D_2 dot.op S^2$ is
as follows: we encrypt $S^2$ into an RLWE ciphertext as
$sans("RLWE")_(S\,sigma)\(S^2\)=\(A^(chevron.l s chevron.r)\,B^(chevron.l s chevron.r)\)$
such that
$A^(chevron.l s chevron.r) dot.op S + B^(chevron.l s chevron.r) = S^2 + E^(chevron.l s chevron.r) med mod med Q$
(where the ciphertext modulus is $Q$ and the plaintext scaling factor
$Delta = 1$). Then, we perform a ciphertext-to-plaintext multiplication
(#link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]) with $D_2$,
treating $D_2$ as a plaintext polynomial in modulo $Q$. However, this
approach does not work in practice, because computing
$D_2 dot.op sans("RLWE")_(S\,sigma)\(S^2\)$ generates a huge noise as
follows:

$D_2 dot.op\(A^(chevron.l s chevron.r)\,B^(chevron.l s chevron.r)\)=\(D_2 dot.op A^(chevron.l s chevron.r)\,D_2 dot.op B^(chevron.l s chevron.r)\)$

$$

, whose decryption is:

$D_2 dot.op A^(chevron.l s chevron.r) dot.op S + D_2 dot.op B^(chevron.l s chevron.r) = D_2 dot.op S^2 + D_2 dot.op E^(chevron.l s chevron.r) med\(mod med Q\)$

$$

. In the above decrypted expression
$D_2 S^2 + D_2 E^(chevron.l s chevron.r) med mod med Q$, the term
$D_2 S^2$ is okay to be reduced modulo $Q$, because this term is
originally allowed to be reduced modulo $Q$ in the final decryption
formula $D_0 + D_1 S + D_2 S^2 med mod med Q$ as well. However, the
problematic term is the noise $D_2 dot.op E^(chevron.l s chevron.r)$,
because its coefficients can be any value in $\[0\,Q - 1\]$ (since each
coefficient of polynomial
$D_2 = A^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)$ can be any
value in $\[0\,Q - 1\]$). Such a huge noise is not allowed for correct
final decryption.

To avoid this noise issue, an improved solution is to express the RLWE
ciphertext that encrypts $D_2 S^2$ as additions of multiple RLWE
ciphertexts with small noises by using the gadget decomposition
technique
(#link(<subsec:gadget-decomposition>)[\[subsec:gadget-decomposition\]]).
For this, we use an RLev ciphertext (#link(<sec:glev>)[\[sec:glev\]])
that encrypts $S^2$. Suppose our gadget vector is
$arrow(g) = #scale(x: 300%, y: 300%)[\(] Q / beta\,Q / beta^2\,Q / beta^3\,dots.h.c\,Q / beta^l #scale(x: 300%, y: 300%)[\)]$.
Remember that our goal is to find
$sans("ct")_beta = sans("RLWE")_(S\,sigma)\(S^2 dot.op D_2\)$ given
known $D_2$, unknown $S$, and known
$sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)= {sans("RLWE")_(S\,sigma) (Q / beta^i dot.op S)}_(i = 1)^l$.
Then, we can derive $sans("ct")_beta$ as follows:

$sans("ct")_beta = sans("RLWE")_(S\,sigma)\(S^2 dot.op D_2\)$

$= sans("RLWE")_(S\,sigma) (S^2 dot.op (D_(2\,1) Q / beta + D_(2\,2) Q / beta^2 + dots.h.c D_(2\,l) Q / beta^l))$
$gt.tri$ by decomposing $D_2$

$= sans("RLWE")_(S\,sigma) (S^2 dot.op D_(2\,1) dot.op Q / beta) + sans("RLWE")_(S\,sigma) (S^2 dot.op D_(2\,2) dot.op Q / beta^2) + dots.h.c + sans("RLWE")_(S\,sigma) (S^2 dot.op D_(2\,l) dot.op Q / beta^l)$

$= D_(2\,1) dot.op sans("RLWE")_(S\,sigma) (S^2 dot.op Q / beta) + D_(2\,2) dot.op sans("RLWE")_(S\,sigma) (S^2 dot.op Q / beta^2) + dots.h.c + D_(2\,l) dot.op sans("RLWE")_(S\,sigma) (S^2 dot.op Q / beta^l)$
$gt.tri$ where each RLWE ciphertext is an encryption of
$S^2 Q / beta\,S^2 Q / beta^2\,dots.h.c\,S^2 Q / beta^l$ as plaintext
with the plaintext scaling factor $Delta = 1$

$$

$= bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$
$gt.tri$ inner product of Decomp and RLev treating them as vectors

$$

If we decrypt the above, we get the following:

$sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r) bold(\))$
$gt.tri$ the scaling factors of
$sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)$ are all 1

$= D_(2\,1) dot.op (E'_1 + S^2 Q / beta) + D_(2\,2) dot.op (E'_2 + S^2 Q / beta^2) + dots.h.c + D_(2\,l) dot.op (E'_l + S^2 Q / beta^l)$
\# where each $E'_i$ is a noise embedded in
$sans("RLWE")_(S\,sigma) (S^2 dot.op Q / beta^i)$

$$

$= sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)+ S^2 dot.op (D_(2\,1) Q / beta + D_(2\,2) Q / beta^2 + dots.h.c + D_(2\,l) Q / beta^l)$

$= sum_(i = 1)^l epsilon.alt_i + D_2 dot.op S^2$ \# where each
$epsilon.alt_i = E'_i dot.op D_(2\,i)$

$approx D_2 dot.op S^2$ \#
$sum_(i = 1)^l epsilon.alt_i lt.double D_2 dot.op E''$, where $E''$ is
the noise that could've been embedded in
$sans("RLWE")_(S\,sigma) bold(\() S^2 bold(\))$

$$

Therefore, we get the following comprehensive relation:

$sans("RLWE")_(S\,sigma)^(- 1)\(Delta M^(chevron.l 1 chevron.r) + K_1 q\)dot.op sans("RLWE")_(S\,sigma)^(- 1)\(Delta M^(chevron.l 2 chevron.r) + K_2 q\)med mod med Q$

$=\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q\)med mod med Q$

$=\(A^(chevron.l 1 chevron.r) dot.op S + B^(chevron.l 1 chevron.r)\)dot.op\(A^(chevron.l 2 chevron.r) dot.op S + B^(chevron.l 2 chevron.r)\)med mod med Q$

$= D_0 + D_1 dot.op S + D_2 dot.op S^2 med mod med Q$ $gt.tri$
$D_0 = B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r)$,
$D_1 = A^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r) + A^(chevron.l 2 chevron.r) B^(chevron.l 1 chevron.r)$,
$D_2 = A^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)$

$= sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")_alpha\)+ sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")_beta\)- sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)med mod med Q$

$gt.tri$ $sans("ct")_alpha =\(D_1\,D_0\)=\(A_alpha\,B_beta\)$,
$sans("ct")_beta = chevron.l sans("Decomp")^(beta\,l)\(D_2\)\,sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)chevron.r =\(A_beta\,B_beta\)$

$$

$= sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")_alpha + sans("ct")_beta\)- sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)med mod med Q$

$= sans("RLWE")_(S\,sigma)^(- 1) bold(\()\(A_(alpha + beta)\,B_(alpha + beta)\)bold(\)) - sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)med mod med Q$
$gt.tri$ $A_(alpha + beta) = A_alpha + A_beta$,
$B_(alpha + beta) = B_alpha + B_beta$

$$

From the above, we extract the following relation:

$\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + K_1 q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + K_2 q\)med mod med Q$

$= Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ q dot.op\(Delta M^(chevron.l 1 chevron.r) K_2 + Delta M^(chevron.l 2 chevron.r) K_1 + E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ K_1 K_2 q^2 + E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) med mod med Q$

$= sans("RLWE")_(S\,sigma)^(- 1) bold(\()\(A_(alpha + beta)\,B_(alpha + beta)\)bold(\)) - sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)med mod med Q$

$$

We can re-write the above relation as follows:

$sans("RLWE")_(S\,sigma)^(- 1) bold(\()\(A_(alpha + beta)\,B_(alpha + beta)\)bold(\)) = A_(alpha + beta) dot.op S + B_(alpha + beta) med mod med Q$

$= Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ q dot.op\(Delta M^(chevron.l 1 chevron.r) K_2 + Delta M^(chevron.l 2 chevron.r) K_1 + E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ K_1 K_2 q^2 + E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)med mod med Q$

$$

To verbally interpret the above relation, decrypting the synthetically
generated ciphertext $\(A_(alpha + beta)\,B_(alpha + beta)\)$ and
applying a reduction modulo $Q$ to it gives us
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$ with a lot
of noise terms. Meanwhile, as explained in the beginning of this
subsection, our goal is to derive a ciphertext whose decryption is
$Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$, also
ensuring that the decrypted ciphertext's noise is small enough to be
fully eliminated by scaling down the plaintext by $Delta$ at the end.
This goal is accomplished by the final rescaling step to be explained in
the next subsection.

=== Rescaling
<subsubsec:bfv-mult-cipher-rescaling>
The rescaling step is equivalent to converting the ciphertext
$\(A_(alpha + beta)\,B_(alpha + beta)\)med mod med Q$ into
$(⌈A_(alpha + beta) / Delta⌋ \, ⌈B_(alpha + beta) / Delta⌋) med mod med q$,
where $Delta = ⌊q / t⌋ approx q / t$. The decryption of this rescaled
ciphertext (and finally scaling down by $Delta$) is
$Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$. This is
demonstrated below:

$$

$⌈A_(alpha + beta) / Delta⌋ dot.op S + ⌈B_(alpha + beta) / Delta⌋ med mod med q$
$gt.tri$ decryption of ciphertext
$(⌈A_(alpha + beta) / Delta⌋ \, ⌈B_(alpha + beta) / Delta⌋) med mod med q$

$$

$= ⌈A_(alpha + beta) / Delta⌋ dot.op S + ⌈B_(alpha + beta) / Delta⌋ + K_3 q$
$gt.tri$ where $K_3 q$ stands for modulo reduction by $q$

$$

$= ⌈A_(alpha + beta) / Delta⌋ dot.op S + ⌈B_(alpha + beta) / Delta⌋ + frac(K_3 Q, Delta)$
$gt.tri$ since $Q = Delta dot.op q$

$$

$= ⌈1 / Delta dot.op \( A_(alpha + beta) dot.op S + B_(alpha + beta) + K_3 Q \)⌋ + E_r$
$gt.tri$ $E_r$ is a rounding error

$$

$= ⌈1 / Delta dot.op \( A_(alpha + beta) dot.op S + B_(alpha + beta) med mod med Q \)⌋ + E_r$

$$

$= #scale(x: 300%, y: 300%)[ceil.l] 1 / Delta dot.op\(Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+$

$q dot.op\(Delta M^(chevron.l 1 chevron.r) K_2 + Delta M^(chevron.l 2 chevron.r) K_1 + E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ K_1 K_2 q^2 + E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)med mod med Q\)#scale(x: 300%, y: 300%)[floor.r] + E_r$

$gt.tri$ as we derived at the end of
#link(<subsubsec:bfv-mult-cipher-relinearization>)[0.7.3]

$$

$= #scale(x: 300%, y: 300%)[ceil.l] 1 / Delta dot.op\(Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + Delta dot.op\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+$

$q dot.op\(Delta M^(chevron.l 1 chevron.r) K_2 + Delta M^(chevron.l 2 chevron.r) K_1 + E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ K_1 K_2 q^2 + E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)+ K_4 Q\)#scale(x: 300%, y: 300%)[floor.r] + E_r$

$gt.tri$ where $K_4 Q$ stands for modulo reduction by $Q$

$$

$$

$= #scale(x: 300%, y: 300%)[ceil.l] Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) +\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ q dot.op\(M^(chevron.l 1 chevron.r) K_2 + M^(chevron.l 2 chevron.r) K_1\)$

$+ 1 / Delta dot.op q dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ 1 / Delta dot.op\(K_1 K_2 q^2 + E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)\)+ K_5 q #scale(x: 300%, y: 300%)[floor.r]$

$gt.tri$ where
$K_5 q = K_4 q + M^(chevron.l 1 chevron.r) q K_2 + M^(chevron.l 2 chevron.r) K_1 q$

$$

$$

$= #scale(x: 300%, y: 300%)[ceil.l] Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) +\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ q dot.op\(M^(chevron.l 1 chevron.r) K_2 + M^(chevron.l 2 chevron.r) K_1\)+\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)$

$+ 1 / Delta dot.op\(K_1 K_2 q^2 + E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)\)+ K_5 q #scale(x: 300%, y: 300%)[floor.r]$

$gt.tri$ where
$epsilon.alt = q / Delta - q / q / t = q / ⌊q / t⌋ - q / q / t approx 0$,
thus we substituted $q / Delta = epsilon.alt + t$

$$

$$

$= #scale(x: 300%, y: 300%)[ceil.l] Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) +\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ q dot.op\(M^(chevron.l 1 chevron.r) K_2 + M^(chevron.l 2 chevron.r) K_1\)+\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)$

$+ frac(K_1 K_2 q^2, Delta) + frac(E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\), Delta) + K_5 q #scale(x: 300%, y: 300%)[floor.r]$

$gt.tri$ Now, let
$epsilon.alt' = frac(K_1 K_2 q^2, Delta) - frac(K_1 K_2 q^2, q / t) = frac(K_1 K_2 q^2, ⌊q / t⌋) - frac(K_1 K_2 q^2, q / t) approx 0$.

Thus, we will substitute
$frac(K_1 K_2 q^2, Delta) = frac(K_1 K_2 q^2, q / t) + epsilon.alt' = K_1 K_2 q t + epsilon.alt'$

$$

$$

$= Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) +\(M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r)\)+ q dot.op\(M^(chevron.l 1 chevron.r) K_2 + M^(chevron.l 2 chevron.r) K_1\)$

$+\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ K_1 K_2 q t + epsilon.alt' + K_5 q + #scale(x: 300%, y: 300%)[ceil.l] frac(E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\), Delta) #scale(x: 300%, y: 300%)[floor.r]$

$$

$$

$= Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + epsilon.alt'' + K_6 q$

$gt.tri$ where
$K_6 q = K_5 q + q dot.op\(M^(chevron.l 1 chevron.r) K_2 + M^(chevron.l 2 chevron.r) K_1\)+ K_1 K_2 q t\,$

$epsilon.alt'' = M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r) +\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)+ #scale(x: 300%, y: 300%)[ceil.l] frac(E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\), Delta) #scale(x: 300%, y: 300%)[floor.r]$

$$

$$

$= Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + epsilon.alt'' med mod med q$

$$

In conclusion, the ciphertext
$(⌈A_(alpha + beta) / Delta⌋ \, ⌈B_(alpha + beta) / Delta⌋) med mod med q$
successfully decrypts to
$Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$ if
$epsilon.alt'' < Delta / 2 approx frac(q, 2 t)$.

$$

Among the terms of $epsilon.alt''$, let's analyze the noise growth of
the
$\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)$
term after ciphertext-to-ciphertext multiplication. Each coefficient of
$K_1$ is at most $n$, because
$A^(chevron.l 1 chevron.r) dot.op S + B^(chevron.l 1 chevron.r) = Delta M + E^(chevron.l 1 chevron.r) + K_1 q$,
where the maximum possible coefficient value of
$A^(chevron.l 1 chevron.r) dot.op S + B^(chevron.l 1 chevron.r)$ is
$q dot.op n$. And the same is true for the coefficients of $K_2$.
Therefore, after scaling down
$\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)$
by $Delta$ upon the final decryption stage, this term's down-scaled
noise gets bound by:

$1 / Delta dot.op\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)approx t / q dot.op\(t + epsilon.alt\)dot.op\(E^(chevron.l 1 chevron.r) K_2 + E^(chevron.l 2 chevron.r) K_1\)< frac(n t dot.op\(t + epsilon.alt\), q) dot.op\(E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)\)$

$$

This implies that for correct decryption,
$frac(n t dot.op\(t + epsilon.alt\), q) dot.op\(E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)\)$
has to be smaller than $0.5$. In other words,
$E^(chevron.l 1 chevron.r) + E^(chevron.l 2 chevron.r)$ has to be
smaller than $frac(q, 2 n t dot.op\(t + epsilon.alt\))$. We can do noise
analysis for all other terms for $epsilon.alt''$ in a similar manner.
Importantly, upon decryption, the aggregation of all these noise terms'
down-scaled values has to be smaller than $0.5$ for correct decryption.

$$

Notice in the rescaling process, multiplying $1 / Delta$ to
$A_(alpha + beta)$ and $B_(alpha + beta)$ results in two effects: (1)
converts $Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$
into $Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$\; (2)
switches the modulus of the #emph[mod-raised] ciphertexts from
$Q arrow.r q$. In fact, modulus switch and rescaling are closely
equivalent to each other. Modulus switch is a process of changing a
ciphertext's modulus (e.g., $q arrow.r q'$), while preserving the
property that the decryption of both ciphertexts results in the same
plaintext. On the other hand, rescaling refers to the process of
changing the scaling factor of a plaintext within a ciphertext (e.g.,
$Delta arrow.r Delta'$). Modulus switch inevitably changes the scaling
factor of the plaintext within the target ciphertext, and rescaling also
inevitably changes the modulus of the ciphertext that contains the
plaintext (as shown in
#link(<subsubsec:bfv-mult-cipher-rescaling>)[0.7.4]). Therefore, these
two terms can be used interchangeably.

=== Summary
<subsubsec:bfv-mult-cipher-summary>
To put all things together, BFV's ciphertext-to-ciphertext
multiplication is summarized as follows:

#block[
Suppose we have the following two RLWE ciphertexts:

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r)\)=\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)med mod med q$,
where
$B^(chevron.l 1 chevron.r) = - A^(chevron.l 1 chevron.r) dot.op S + Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) med mod med q$

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r)\)=\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)med mod med q$,
where
$B^(chevron.l 2 chevron.r) = - A^(chevron.l 2 chevron.r) dot.op S + Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) med mod med q$

$$

Multiplication between these two ciphertexts is performed as follows:

$$

+ #strong[#underline[ModRaise]]

  Forcibly raise the modulus of the ciphertexts
  $\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)med mod med q$
  and
  $\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)med mod med q$
  to $Q$ (where $Q = q dot.op Delta$) as follows:

  $\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)med mod med Q$

  $\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)med mod med Q$

  $$

+ #strong[#underline[Multiplication]]

  Compute the following polynomial multiplications in modulo $Q$:

  $D_0 = B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r) med mod med Q$

  $D_1 = B^(chevron.l 2 chevron.r) A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r) med mod med Q$

  $D_2 = A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r) med mod med Q$

  $$

+ #strong[#underline[Relinearization]]

  Compute the following:

  $sans("ct")_alpha =\(D_1\,D_0\)$

  $sans("ct")_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$.

  $sans("ct")_(alpha + beta) = sans("ct")_alpha + sans("ct")_beta$

  $$

  Then, the following property holds:

  $sans("RLWE")_(S\,sigma)^(- 1) bold(\() sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)bold(\)) approx sans("RLWE")_(S\,sigma)^(- 1) bold(\() sans("ct")_(alpha + beta) bold(\))$

  $$

+ #strong[#underline[Rescaling]]

  Update
  $sans("ct")_(alpha + beta) =\(A_(alpha + beta)\,B_(alpha + beta)\)med mod med Q$
  to
  $sans("ct’")_(alpha + beta) = (⌈A_(alpha + beta) / Delta⌋ \, ⌈B_(alpha + beta) / Delta⌋) med mod med q$.

  $$

  This plaintext rescaling process can be also viewed as a modulus
  switch of the ciphertext $sans("ct")_(alpha + beta)$ from
  $Q arrow.r q$.

  $$

Note that after the ciphertext-to-ciphertext multiplication, the
plaintext scaling factor $Delta = ⌊q / t⌋$, the ciphertext modulus $q$,
and the private key $S$ stay the same as before.

]
When we multiply polynomials at the second step of
ciphertext-to-ciphertext multiplication
(#link(<subsubsec:bfv-mult-cipher-multiplication>)[0.7.2]), the
underlying plaintext within the ciphertext temporarily grows to
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$, which
exceeds the allowed maximum boundary $q$ for the plaintext
(Summary~@subsec:bfv-enc-dec in #link(<subsec:bfv-enc-dec>)[0.3]). After
this point, applying modulo-$q$ reduction to the intermediate result
will irrevocably corrupt the plaintext. To avoid the corruption of the
plaintext when it grows to
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$, we
temporarily increase the ciphertext modulus from $q arrow.r Q$, which is
sufficiently large to hold
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$ without
wrapping around the boundary of the ciphertext modulus.

$$

The order of relinearization and rescaling is interchangeable. Running
rescaling before relinearization reduces the size of the ciphertext
modulus, and therefore the subsequent relinearization can be executed
faster.

=== Application to TFHE's Ciphertext-to-Ciphertext Multiplication
<subsubsec:bfv-mult-cipher-tfhe>
In #link(<subsec:tfhe-mult-cipher>)[\[subsec:tfhe-mult-cipher\]], we
learned how TFHE performs ciphertext-to-ciphertext multiplication
between LWE and GSW ciphertexts. However, this method is computationally
expensive because it requires circuit bootstrapping to convert an LWE
ciphertext into a GSW ciphertext. Such an overhead can be avoided if we
directly apply BFV's ciphertext-to-ciphertext multiplication strategy to
TFHE's LWE ciphertexts. Given two LWE ciphertexts to multiply, they hold
the following relations:

$sans("LWE")_(arrow(s)\,sigma)\(Delta m^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r)\)=\(arrow(a)^(chevron.l 1 chevron.r)\,b^(chevron.l 1 chevron.r)\)arrow.r.double thin thin thin arrow(a)^(chevron.l 1 chevron.r) dot.op arrow(s) + b^(chevron.l 1 chevron.r) = Delta m^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r) + k_1 q$

$sans("LWE")_(arrow(s)\,sigma)\(Delta m^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r)\)=\(arrow(a)^(chevron.l 2 chevron.r)\,b^(chevron.l 2 chevron.r)\)arrow.r.double thin thin thin arrow(a)^(chevron.l 2 chevron.r) dot.op arrow(s) + b^(chevron.l 2 chevron.r) = Delta m^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r) + k_2 q$

$$

Multiplying these two equations yields the following relation:

$\(Delta m^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r) + k_1 q\)dot.op\(Delta m^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r) + k_2 q\)$
$gt.tri approx Delta^2 m^(chevron.l 1 chevron.r) m^(chevron.l 2 chevron.r) med mod med q$

$=\(arrow(a)^(chevron.l 1 chevron.r) dot.op arrow(s) + b^(chevron.l 1 chevron.r)\)dot.op\(arrow(a)^(chevron.l 2 chevron.r) dot.op arrow(s) + b^(chevron.l 2 chevron.r)\)$

$= b^(chevron.l 1 chevron.r) b^(chevron.l 2 chevron.r) +\(b^(chevron.l 2 chevron.r) arrow(a)^(chevron.l 1 chevron.r) + b^(chevron.l 1 chevron.r) arrow(a)^(chevron.l 2 chevron.r)\)dot.op arrow(s) +\(arrow(a)^(chevron.l 1 chevron.r) dot.op arrow(s)\)dot.op\(arrow(a)^(chevron.l 2 chevron.r) dot.op arrow(s)\)$

$= underbrace(b^(chevron.l 1 chevron.r) b^(chevron.l 2 chevron.r), d_0) + underbrace(\(b^(chevron.l 2 chevron.r) arrow(a)^(chevron.l 1 chevron.r) + b^(chevron.l 1 chevron.r) arrow(a)^(chevron.l 2 chevron.r)\), d_1) dot.op arrow(s) + underbrace(\(arrow(a)^(chevron.l 1 chevron.r) times.circle arrow(a)^(chevron.l 2 chevron.r)\), arrow(d)_2) dot.op\(arrow(s) times.circle arrow(s)\)$

$= d_0 + d_1 dot.op arrow(s) + arrow(d)_2 dot.op arrow(s)^times.circle$
$gt.tri$ where $arrow(s)^times.circle = arrow(s) times.circle arrow(s)$

$$

, where $times.circle$ denotes an outer product of two vectors. For
example, given two $n$-length vectors $arrow(v)$ and $arrow(u)$,
$arrow(v) times.circle arrow(u)$ is equivalent to an $n^2$-length vector
that concatenates the following $n$ distinct $n$-length vectors:
$v_0 dot.op arrow(u)\,thin thin v_1 dot.op arrow(u)\,thin thin dots.h.c v_(n - 1) dot.op arrow(u)$.
Notice that the above relation is similar to that we derived in BFV's
ciphertext-to-ciphertext multiplication. Therefore, similar to the
remaining steps in BFV, we can relinearize and rescale this LWE term as
follows:

#block[
Suppose we have the following two LWE ciphertexts:

$sans("LWE")_(arrow(s)\,sigma)\(Delta M^(chevron.l 1 chevron.r)\)=\(arrow(a)^(chevron.l 1 chevron.r)\,b^(chevron.l 1 chevron.r)\)med mod med q$,
where
$b^(chevron.l 1 chevron.r) = - arrow(a)^(chevron.l 1 chevron.r) dot.op arrow(s) + Delta m^(chevron.l 1 chevron.r) + e^(chevron.l 1 chevron.r) med mod med q$

$sans("LWE")_(arrow(s)\,sigma)\(Delta M^(chevron.l 2 chevron.r)\)=\(arrow(a)^(chevron.l 2 chevron.r)\,b^(chevron.l 2 chevron.r)\)med mod med q$,
where
$b^(chevron.l 2 chevron.r) = - arrow(a)^(chevron.l 2 chevron.r) dot.op arrow(s) + Delta m^(chevron.l 2 chevron.r) + e^(chevron.l 2 chevron.r) med mod med q$

$$

Multiplication between these two LWE ciphertexts is performed as
follows:

$$

+ #strong[#underline[ModRaise]]

  Forcibly raise the modulus of the ciphertexts
  $\(arrow(a)^(chevron.l 1 chevron.r)\,b^(chevron.l 1 chevron.r)\)med mod med q$
  and
  $\(arrow(a)^(chevron.l 2 chevron.r)\,b^(chevron.l 2 chevron.r)\)med mod med q$
  to $Q$ (where $Q = q dot.op Delta$) as follows:

  $\(arrow(a)^(chevron.l 1 chevron.r)\,b^(chevron.l 1 chevron.r)\)med mod med Q$

  $\(arrow(a)^(chevron.l 2 chevron.r)\,b^(chevron.l 2 chevron.r)\)med mod med Q$

  $$

+ #strong[#underline[Multiplication]]

  Compute the following polynomial multiplications in modulo $Q$:

  $d_0 = b^(chevron.l 1 chevron.r) b^(chevron.l 2 chevron.r) med mod med Q$

  $d_1 = b^(chevron.l 2 chevron.r) arrow(a)^(chevron.l 1 chevron.r) + b^(chevron.l 1 chevron.r) arrow(a)^(chevron.l 2 chevron.r) med mod med Q$

  $arrow(d)_2 = arrow(a)^(chevron.l 1 chevron.r) times.circle arrow(a)^(chevron.l 2 chevron.r) med mod med Q$

  $$

+ #strong[#underline[Relinearization]]

  Compute the following:

  $sans("ct")_alpha =\(d_1\,d_0\)$

  $sans("ct")_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(arrow(d)_2\)\,upright(" ") sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(arrow(s)^times.circle\)bold(chevron.r)$.

  $sans("ct")_(alpha + beta) = sans("ct")_alpha + sans("ct")_beta$

  $$

  Then, the following property holds:

  $sans("LWE")_(arrow(s)\,sigma)^(- 1) bold(\() sans("LWE")_(arrow(s)\,sigma)\(Delta^2 dot.op m^(chevron.l 1 chevron.r) dot.op m^(chevron.l 2 chevron.r)\)bold(\)) approx sans("LWE")_(arrow(s)\,sigma)^(- 1) bold(\() sans("ct")_(alpha + beta) bold(\))$

  $$

+ #strong[#underline[Rescaling]]

  Update
  $sans("ct")_(alpha + beta) =\(arrow(a)_(alpha + beta)\,b_(alpha + beta)\)med mod med Q$
  to
  $sans("ct’")_(alpha + beta) = (⌈arrow(a)_(alpha + beta) / Delta⌋ \, ⌈b_(alpha + beta) / Delta⌋) med mod med q$.

  $$

  This plaintext rescaling process can be also viewed as a modulus
  switch of the ciphertext $sans("ct")_(alpha + beta)$ from
  $Q arrow.r q$.

  $$

Note that after the ciphertext-to-ciphertext multiplication, the
plaintext scaling factor $Delta = q / t$, the ciphertext modulus $q$,
and the private key $arrow(s)$ stay the same as before.

]
== Homomorphic Key Switching
<subsec:bfv-key-switching>
BFV's key switching scheme changes an RLWE ciphertext's secret key from
$S$ to $S'$. This scheme is essentially RLWE's key switching scheme with
the sign of the $A dot.op S$ term flipped in the encryption and
decryption formula. Specifically, this is equivalent to the alternative
GLWE version's
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]]) key
switching scheme
(#link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]) with
$k = 1$ as follows:

#block[
$sans("RLWE")_(S'\,sigma)\(Delta M\)=\(0\,B\)+ bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$

]
== Homomorphic Rotation of Input Vector Slots
<subsec:bfv-rotation>
In this section, we will explain how to homomorphically rotate the
elements of an input vector $arrow(v)$ after it is already encoded as a
polynomial and encrypted as an RLWE ciphertext. In
#link(<subsec:coeff-rotation>)[\[subsec:coeff-rotation\]], we learned
how to rotate the coefficients of a polynomial. However, rotating the
plaintext polynomial $M\(X\)$ or RLWE ciphertext polynomials
$\(A\(X\)\,B\(X\)\)$ does not necessarily rotate the input vector, which
is the source of them.

The key requirement of homomorphic rotation of input vector slots (i.e.,
input vector) is that this operation should be performed on the RLWE
ciphertext such that after this operation, if we decrypt the RLWE
ciphertext and decode it, the recovered input vector will be in a
rotated state as we expect. We will divide this task into the following
two sub-problems:

+ How to indirectly rotate the input vector by updating the plaintext
  polynomial $M$ to $M'$?

+ How to indirectly update the plaintext polynomial $M$ to $M'$ by
  updating the RLWE ciphertext polynomials $\(A\,B\)$ to $\(A'\,B'\)$?

=== Rotating Input Vector Slots by Updating the Plaintext Polynomial
<rotating-input-vector-slots-by-updating-the-plaintext-polynomial>
In this task, our goal is to modify the plaintext polynomial $M\(X\)$
such that the first-half elements of the input vector $arrow(v)$ are
shifted to the left by $h$ positions in a wrapping manner among them,
and the second-half elements of $arrow(v)$ are also shifted to the left
by $h$ positions in a wrapping manner among them. Specifically, if
$arrow(v)$ is defined as follows:

$arrow(v) =\(v_0\,v_1\,dots.h.c\,v_(n - 1)\)$

$$

Then, we will denote the $h$-shifted vector
$arrow(v)^(chevron.l h chevron.r)$ as follows:

$arrow(v)^(chevron.l h chevron.r) =\(underbrace(v_h\,v_(h + 1)\,dots.h.c\,v_0\,v_1\,dots.h.c\,v_(h - 2)\,v_(h - 1)\,, upright("The first-half ") n / 2 upright(" elements ") h upright("-rotated to the left")) upright(" ") underbrace(v_(n / 2 + h)\,v_(n / 2 + h + 1)\,dots.h.c\,v_(n / 2 + h - 2)\,v_(n / 2 + h - 1), upright("The second-half ") n / 2 upright(" elements ") h upright("-rotated to the left"))\)$

$$

Remember from #link(<subsec:bfv-batch-encoding>)[0.2] that the BFV
encoding scheme's components are as follows:

$arrow(v) =\(v_0\,v_1\,v_2\,dots.h.c\,v_(n - 1)\)$ $gt.tri$
$n$-dimensional input vector

$$

$W = mat(delim: "[", 1, 1, 1, dots.h.c, 1; \(omega\), \(omega^3\), \(omega^5\), dots.h.c, \(omega^(2 n - 1)\); \(omega\)^2, \(omega^3\)^2, \(omega^5\)^2, dots.h.c, \(omega^(2 n - 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), \(omega^5\)^(n - 1), dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$

$= mat(delim: "[", 1, 1, dots.h.c, 1, 1, dots.h.c, 1, 1; \(omega\), \(omega^3\), dots.h.c, \(omega^(n / 2 - 1)\), \(omega^(-\(n / 2 - 1\))\), dots.h.c, \(omega^(- 3)\), \(omega^(- 1)\); \(omega\)^2, \(omega^3\)^2, dots.h.c, \(omega^(n / 2 - 1)\)^2, \(omega^(-\(n / 2 - 1\))\)^2, dots.h.c, \(omega^(- 3)\)^2, \(omega^(- 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), dots.h.c, \(omega^(n / 2 - 1)\)^(n - 1), \(omega^(-\(n / 2 - 1\))\)^(n - 1), dots.h.c, \(omega^(- 3)\)^(n - 1), \(omega^(- 1)\)^(n - 1); #none)$

, where $omega = g^(frac(t - 1, 2 n)) med mod med t$ ($g$ is a generator
of $bb(Z)_t^times$)

$gt.tri$ The encoding matrix that converts $arrow(v)$ into $arrow(m)$ (
i.e., $n$ coefficients of the plaintext polynomial $M\(X\)$ )

$$

$Delta arrow(m) = n^(- 1) dot.op Delta W dot.op I_n^R dot.op arrow(v)$

$gt.tri$ A vector containing the scaled $n$ integer coefficients of the
plaintext polynomial

$$

$Delta M = sum_(i = 0)^(n - 1)\(Delta m_i X^i\)$

$gt.tri$ The integer polynomial that isomorphically encodes the input
vector $arrow(v)$

$$

We learned from
#link(<subsec:poly-vector-transformation>)[\[subsec:poly-vector-transformation\]]
that decoding the polynomial $M\(X\)$ $arrow(v)$ is equivalent to
evaluating $M\(X\)$ at the following $n$ distinct primitive
$\(mu = 2 n\)$-th root of unity:
${ omega\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 3)\,omega^(2 n - 1) }$.
Thus, the above decoding process is equivalent to the following:

$arrow(v) = frac(W^T Delta arrow(m), Delta) = bold(\() W_0^T dot.op arrow(m)\,upright(" ") W_1^T dot.op arrow(m)\,upright(" ") W_2^T dot.op arrow(m)\,upright(" ") dots.h.c\,upright(" ") W_(n - 1)^T dot.op arrow(m) bold(\))$

$= bold(\() upright(" ") M\(omega\)\,upright(" ") M\(omega^3\)\,upright(" ") M\(omega^5\)\,dots.h.c\,M\(omega^(2 n - 3)\)\,upright(" ") M\(omega^(2 n - 1)\)upright(" ") bold(\))$

$= bold(\() upright(" ") M\(omega\)\,upright(" ") M\(omega^3\)\,upright(" ") M\(omega^5\)\,dots.h.c\,M\(omega^(n - 3)\)\,upright(" ") M\(omega^(n - 1)\)\,upright(" ") M\(omega^(-\(n - 1\))\)\,upright(" ") M\(omega^(-\(n - 3\))\)\,dots.h.c\,M\(omega^(- 3)\)\,upright(" ") M\(omega - 1\)upright(" ") bold(\))$

$$

Now, our next task is to modify $M\(X\)$ to $M'\(X\)$ such that decoding
$M'\(X\)$ will give us a modified input vector
$arrow(v)^(chevron.l h chevron.r)$ that is a rotation of the first half
elements of $arrow(v)$ by $h$ positions to the left (in a wrapping
manner among them), and the second half elements of it also rotated by
$h$ positions to the left (in a wrapping manner among them). To
accomplish this rotation, we will take a 2-step solution:

+ To convert $M\(X\)$ into $M'\(X\)$, we will define the new mapping
  $sigma_M$ as follows:

  $sigma_M :\(M\(X\)\,h\)in\(cal(R)_(chevron.l n\,t chevron.r)\,bb(Z)_n\)arrow.r M'\(X\)in cal(R)_(chevron.l n\,t chevron.r)$

  , where $h$ is the number of rotation positions to be applied to
  $arrow(v)$.

+ To decode $M'\(X\)$ into the rotated input vector
  $arrow(v)^(chevron.l h chevron.r)$, we need to re-design our decoding
  scheme by modifying Encoding#sub[1]'s
  (#link(<subsubsec:bfv-encoding-1>)[0.2.1]) isomorphic mapping
  $sigma : M\(X\)in cal(R)_(chevron.l n\,t chevron.r) arrow.r arrow(v) in bb(Z)^n$

$$

Our first task is to convert $M\(X\)$ into $M'\(X\)$, which is
equivalent to applying our new mapping
$sigma_M :\(M\(X\)\,h\)in\(cal(R)_(chevron.l n\,t chevron.r)\,bb(Z)_n\)arrow.r M'\(X\)in cal(R)_(chevron.l n\,t chevron.r)$,
such that decoding $M'\(X\)$ gives a rotated input vector
$arrow(v)^(chevron.l h chevron.r)$ whose first half of the elements in
$arrow(v)$ are rotated by $h$ positions to the left (in a wrapping
manner among them), and the second half of the elements are also rotated
by $h$ positions to the left (in a wrapping manner among them). To
design $sigma_M$ that satisfies this requirement, we will use the number
$5^j$ which has the following two special properties (based on number
theory):

- $\(5^j med mod med 2 n\)$ and $\(- 5^j med mod med 2 n\)$ generate all
  odd numbers between $\[0\,2 n\)$ for the integer $j$ where
  $0 lt.eq j < n / 2$.

- For each integer $j$ where $0 lt.eq j < n / 2$,
  $\(5^j med mod med 2 n\)+\(- 5^j med mod med 2 n\)equiv 0 med mod med 2 n$.

For example, suppose the modulus $2 n = 16$. Then,

#block[
2 $5^0 med mod med 16 = 1$ \ $5^1 med mod med 16 = 5$ \
$5^2 med mod med 16 = 9$ \ $5^3 med mod med 16 = 13$ \
$-\(5\)^0med mod med 16 = 15$ \ $-\(5\)^1med mod med 16 = 11$ \
$-\(5\)^2med mod med 16 = 7$ \ $-\(5\)^3med mod med 16 = 3$

]
As shown above, $0 lt.eq j < 4$ generate all odd numbers between
$\[0\,16\)$. Also, for each $j$ in $0 lt.eq j < 4$,
$\(5^j med mod med 16\)+\(- 5^j med mod med 16\)= 16$.

$$

Let's define $J\(h\)= 5^h med mod med 2 n$, and
$J_(*)\(h\)= - 5^h med mod med 2 n$. Based on $J\(h\)$ and $J_(*)\(h\)$,
we will define the mapping $sigma_M : M\(X\)arrow.r M'\(X\)$ as follows:

$sigma_M : M\(X\)arrow.r M\(X^(J\(h\))\)$

$$

Given a plaintext polynomial $M\(X\)$, in order to give its decoded
version of input vector $arrow(v)$ the effect of the first half of the
elements being rotated by $h$ positions to the left (in a wrapping
manner) and the second half of the elements also being rotated by $h$
positions to the left (in a wrapping manner), we update the current
plaintext polynomial $M\(X\)$ to a new polynomial
$M'\(X\)= M\(X^(J\(h\))\)= M\(X^(5^h)\)$ by applying the $sigma_M$
mapping, where $h$ is the number of positions for left rotations for the
first half and second half of the elements of $arrow(v)$.

$$

: Our second task is to modify our original decoding scheme in order to
successfully decode $M'\(X\)$ into the rotated input vector
$arrow(v)^(chevron.l h chevron.r)$. For this, we will modify our
original isomorphic mapping $sigma : M\(X\)arrow.r arrow(v)$, from:

$sigma : M\(X\)in cal(R)_(chevron.l n\,q chevron.r) arrow.r bold(\() M\(omega\)\,M\(omega^3\)\,M\(omega^5\)\,dots.h.c\,M\(omega^(2 n - 1)\)bold(\)) in bb(Z)^n$
\# designed in
#link(<subsec:poly-vector-transformation>)[\[subsec:poly-vector-transformation\]]

$$

, to the following:

$sigma_J : M\(X\)in cal(R)_(chevron.l n\,t chevron.r) arrow.r bold(\() M\(omega^(J\(0\))\)\,M\(omega^(J\(1\))\)\,M\(omega^(J\(2\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)\,$

$sigma_J : M\(X\)in cal(R)_(chevron.l n\,q chevron.r) arrow.r bold(\()$
$M\(omega^(J_(*)\(0\))\)\,upright(" ") M\(omega^(J_(*)\(1\))\)\,upright(" ") M\(omega^(J_(*)\(2\))\)\,dots.h.c\,M\(omega^(J_(*)\(n / 2 - 1)\)upright(" ") bold(\)) in bb(Z)^n$

$$

The common aspect between $sigma$ and $sigma_J$ is that they both
evaluate the polynomial $M\(X\)$ at $n$ distinct primitive
$\(mu = 2 n\)$-th roots of unity (i.e., $w^i$ for all odd $i$ between
$\[0\,2 n\]$ ). In the case of the $sigma_J$ mapping, note that
$J\(j\)= 5^j med mod med 2 n$ and $J_(*)\(j\)= - 5^j med mod med 2 n$
for each $j$ in $0 lt.eq j < n / 2$ cover all odd numbers between
$\[0\,2 n\]$. Therefore, $omega^(J\(j\))$ and $omega^(J_(*)\(j\))$
between $0 lt.eq j < n / 2$ cover all $n$ distinct primitive
$\(mu = 2 n\)$-th roots of unity.

Meanwhile, the difference between $sigma$ and $sigma_J$ is the order of
the output vector elements. In the $sigma$ mapping, the order of
evaluated coordinates for $M\(X\)$ is
$omega\,omega^3\,dots.h.c\,omega^(2 n - 1)$, whereas in the $sigma_J$
mapping, the order of evaluated coordinates is
$omega^(J\(0\))\,omega^(J\(1\))\,dots.h.c\,omega^(J\(n / 2 - 1\))\,omega^(J_(*)\(0\))\,omega^(J_(*)\(1\))\,dots.h.c\,omega^(J_(*)\(n / 2 - 1\))$.
We will later explain why we modified the ordering like this.

In the original Decoding#sub[2] process
(#link(<subsec:bfv-batch-encoding>)[0.2]), applying the $sigma$ mapping
to a plaintext polynomial $M\(X\)$ was equivalent to computing the
following:

$arrow(v)_(') = bold(\() upright(" ") M\(omega\)\,upright(" ") M\(omega^3\)\,upright(" ") M\(omega^5\)\,dots.h.c\,M\(omega^(2 n - 3)\)\,upright(" ") M\(omega^(2 n - 1)\)bold(\))$

$$

$= bold(\() upright(" ") M\(omega\)\,upright(" ") M\(omega^3\)\,upright(" ") M\(omega^5\)\,dots.h.c\,M\(omega^(n - 1)\)\,upright(" ") M\(omega^(-\(n - 1\))\)\,dots.h.c\,upright(" ") M\(omega^(- 3)\)\,upright(" ") M\(omega^(- 1)\)upright(" ") bold(\))$

$$

$= bold(\() upright(" ") W_0^T dot.op arrow(m)\,upright(" ") W_1^T dot.op arrow(m)\,upright(" ") W_2^T dot.op arrow(m)\,upright(" ") dots.h.c\,upright(" ") W_(n - 1)^T dot.op arrow(m) upright(" ") bold(\))$
$$ $gt.tri$ where $W_i^T$ is the $\(i + 1\)$-th row of $W^T$

$= W^T arrow(m)$

$$

Similarly, the modified $sigma_J$ mapping to the plaintext polynomial
$M\(X\)$ is equivalent to computing the following:

$arrow(v)_(') = bold(\() upright(" ") M\(omega^(J\(0\))\)\,upright(" ") M\(omega^(J\(1\))\)\,upright(" ") M\(omega^(J\(2\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J_(*)\(0\))\)\,upright(" ") M\(omega^(J_(*)\(1\))\)\,dots.h.c\,M\(omega^(J_(*)\(n / 2 - 1\))\)upright(" ") bold(\))$

$$

\$= \\bm{(} \\text{ } \\hathat{W}^\*\_0\\cdot \\vec{m}, \\text{ } \\hathat{W}^\*\_1\\cdot \\vec{m}, \\text{ } \\hathat{W}^\*\_2\\cdot \\vec{m}, \\text{ } \\cdots, \\text{ } \\hathat{W}^\*\_{n-1}\\cdot \\vec{m} \\text{ } \\bm{)}\$

$$

\$= \\hathat{W}^\* \\vec{m}\$, where

$$

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

$$

$$

\$\\hathat{W} = \\begin{bmatrix}
1 & 1 & \\cdots & 1 & 1 & 1 & \\cdots & 1\\\\
(\\omega^{J(\\frac{n}{2} - 1)}) & (\\omega^{J(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J(0)}) & (\\omega^{J\_\*(\\frac{n}{2} - 1)}) & (\\omega^{J\_\*(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J\_\*(0)})\\\\
(\\omega^{J(\\frac{n}{2} - 1)})^2 & (\\omega^{J(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J(0)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J\_\*(0)})^2 \\\\
\\vdots & \\vdots & \\ddots & \\vdots & \\vdots & \\vdots & \\vdots & \\vdots \\\\
(\\omega^{J(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J(\\frac{n}{2} - 2)})^{n-1} & \\cdots & (\\omega^{J(0)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^{n-1} & \\cdots  & (\\omega^{J\_\*(0)})^{n-1}
\\end{bmatrix}\$

$$

$$

From this point, we will replace $W$ in the Encoding#sub[1] process
(#link(<subsec:bfv-batch-encoding>)[0.2]) by \$\\hathat{W}\$, and $W^T$
in the Decoding#sub[2] process by \$\\hathat{W}^\*\$.

$$

To demonstrate that \$\\hathat{W}\$ is a valid encoding matrix like $W$
and \$\\hathat{W}^\*\$ is a valid decoding matrix like $W^T$, we need to
prove the following 2 aspects:

- #strong[\${\\hathat{\\bm W}}\$ is a basis of the $bold(n)$-dimensional
  vector space:] This is true, because \$\\hathat{W}\$ is simply a
  row-wise re-ordering of $W$, which is still a basis of the
  $bold(n)$-dimensional vector space.

- : This proof is split into 2 sub-proofs:

  + Each element along the anti-diagonal line of
    \$\\hathat{ W}^{ \*} \\cdot \\hathat{ W}\$ is computed as
    $sum_(i = 0)^(n - 1) omega^(2 n i k) = n$ where $k$ is some integer.

  + All other elements except for the ones along the anti-diagonal lines
    are
    $sum_(i = 0)^(n - 1) omega^(2 i) frac(omega^n - 1, omega - 1) = 0$
    (by Geometric Sum).

  We provide
  #link("https://github.com/fhetextbook/fhe-textbook/blob/main/source%20code/bfv_j_matrix_inverse_proof.py")[#underline[the Python script]]
  that empirically demonstrates this.

Therefore, \$\\hathat{W}^\*\$ and \$\\hathat{W}\$ are valid encoding &
decoding matrices that transform $arrow(v)$ into $M\(X\)$.

$$

Now, let's think about what will be the structure of
$arrow(v)^(chevron.l h chevron.r)$ (i.e., the first-half elements of
$arrow(v)$ being rotated $h$ positions to the left in a wrapping manner
among them and the second-half elements of it also being rotated $h$
positions to the left in a wrapping manner among them). Remember that
$arrow(v)$ is as follows:

$arrow(v) = bold(\() upright(" ") M\(omega^(J\(0\))\)\,upright(" ") M\(omega^(J\(1\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J_(*)\(0\))\)\,upright(" ") M\(omega^(J_(*)\(1\))\)\,dots.h.c\,M\(omega^(J_(*)\(n / 2 - 1\))\)bold(\))$

\$= \\bm{(} \\text{ } \\hathat{W}^\*\_0\\cdot \\vec{m}, \\text{ } \\hathat{W}^\*\_1\\cdot \\vec{m}, \\text{ } \\hathat{W}^\*\_2\\cdot \\vec{m}, \\text{ } \\cdots, \\text{ } \\hathat{W}^\*\_{n - 1}\\cdot \\vec{m} \\text{ } \\bm{)}\$

$$

Thus, the state of $arrow(v)^(chevron.l h chevron.r)$ which is
equivalent to rotating $arrow(v)$ by $h$ positions to the left for the
first-half and second-half element groups will be the following:

$arrow(v)^(chevron.l h chevron.r) = bold(\() upright(" ") M\(omega^(J\(h\))\)\,upright(" ") M\(omega^(J\(h + 1\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J\(0\))\)\,upright(" ") M\(omega^(J\(1\))\)\,dots.h.c\,upright(" ") M\(omega^(J\(h - 2\))\)\,upright(" ") M\(omega^(J\(h - 1\))\)\,$

$M\(omega^(J_(*)\(h\))\)\,upright(" ") M\(omega^(J_(*)\(h + 1\))\)\,dots.h.c\,M\(omega^(J_(*)\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J_(*)\(0\))\)\,upright(" ") M\(omega^(J_(*)\(1\))\)\,dots.h.c\,upright(" ") M\(omega^(J_(*)\(h - 2\))\)\,upright(" ") M\(omega^(J_(*)\(h - 1\))\)upright(" ") bold(\))$

$$

Notice that the above computation of $arrow(v)^(chevron.l h chevron.r)$
is equivalent to vertically rotating the upper $n / 2$ rows of
\$\\hathat{W}^\*\$ by $h$ positions upward (in a wrapping manner among
them), rotating the lower $n / 2$ rows of \$\\hathat{W}^{\*}\$ by $h$
positions upward (in a wrapping manner among them), and multiplying the
resulting matrix with $arrow(m)$. However, it is not desirable to
directly modify the decoding matrix \$\\hathat{W}^\*\$ like this in
practice, because then the decoding matrix loses its consistency.
Therefore, instead of directly modifying \$\\hathat{W}^\*\$, we will
modify $arrow(m)$ to $arrow(m)_(')$ (i.e., modify $M\(X\)$ to $M'\(X\)$)
such that the relation
\$\\vec{v}^{\\langle h \\rangle} = \\hathat{W}^\* \\cdot \\vec{m}\_{\'}\$
holds. Let's extract the upper-half rows of \$\\hathat{W}^\*\$ and
denote this $n / 2 times n$ matrix as \$\\hathat{H}\_1^\*\$. Then,
\$\\hathat{H}\_1^\*\$ is equivalent to a Vandermonde matrix
(Definition~@subsec:vandermonde in
#link(<subsec:vandermonde>)[\[subsec:vandermonde\]]) in the form of
$V\(omega^(J\(0\))\,omega^(J\(1\))\,dots.h.c\,omega^(J\(n / 2 - 1\))\)$.
Similarly, let's extract the lower-half rows of \$\\hathat{W}^\*\$ and
denote this $n / 2 times n$ matrix as \$\\hathat{H}\_2^\*\$. Then,
\$\\hathat{H}\_2^\*\$ is equivalent to a Vandermonde matrix
(Definition~@subsec:vandermonde in
#link(<subsec:vandermonde>)[\[subsec:vandermonde\]]) in the form of
$V\(omega^(J_(*)\(0\))\,omega^(J_(*)\(1\))\,dots.h.c\,omega^(J_(*)\(n / 2 - 1\))\)$.

Now, let's vertically rotate the rows of \$\\hathat{H}\_1^\*\$ by $h$
positions upward and denote it as
\$\\hathat{H}\_1^{\*\\langle h \\rangle}\$\; and vertically rotate the
rows of \$\\hathat{H}\_2^\*\$ by $h$ positions upward and denote it as
\$\\hathat{H}\_2^{\*\\langle h \\rangle}\$. And let's denote the
$n / 2$-dimensional vector comprising the first-half elements of
$arrow(v)^(chevron.l h chevron.r)$ as
$arrow(v)_1^(chevron.l h chevron.r)$, and the $n / 2$-dimensional vector
comprising the second-half elements of
$arrow(v)^(chevron.l h chevron.r)$ as
$arrow(v)_2^(chevron.l h chevron.r)$. Then, computing (i.e., decoding)
\$\\vec{v}\_1^{\\langle h \\rangle} = \\hathat{H}\_1^{\*\\langle h \\rangle}\\cdot \\vec{m}\$
is equivalent to modifying $M\(X\)$ to $M'\(X\)= M\(X^(J\(h\))\)$ (whose
coefficient vector is $arrow(m)^(chevron.l h chevron.r)$) and then
computing (i.e., decoding)
\$\\vec{v}\_1^{\\langle h \\rangle} = \\hathat{H}\_1^{\*}\\cdot \\vec{m}^{\\langle h \\rangle}\$.
This is because:

\$\\vec{v}\_1^{\\langle h \\rangle} =\\hathat{H}\_1^{\*\\langle h \\rangle}\\cdot \\vec{m}\$

\$= \\bm{(} \\text{ } \\hathat{W}^\*\_{h}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{h+1}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{h+2}\\cdot\\vec{m}, \\cdots, \\hathat{W}^\*\_{\\frac{n}{2}-1}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{0}\\cdot\\vec{m}, \\text{ }\\hathat{W}^\*\_{1}\\cdot\\vec{m}, \\cdots, \\text{ } \\hathat{W}^\*\_{h-2}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{h-1}\\cdot\\vec{m}  \\bm{)}\$

$$

$= bold(\() upright(" ") M\(\(omega^(J\(h\))\)^(J\(0\))\)\,upright(" ") M\(\(omega^(J\(h\))\)^(J\(1\))\)\,upright(" ") M\(\(omega^(J\(h\))\)^(J\(2\))\)\,dots.h.c\,M\(\(omega^(J\(h\))\)^(J\(n / 2 - 1\))\)upright(" ") bold(\))$

$gt.tri$ This is equivalent to evaluating the polynomial
$M\(X^(J\(h\))\)$ at the following $n / 2$ distinct $\(mu = 2 n\)$-th
roots of unity:
$omega^(J\(0\))\,omega^(J\(1\))\,omega^(J\(2\))\,dots.h.c\,omega^(J\(n / 2 - 1\))$

$$

$= bold(\() upright(" ") M\(omega^(J\(h\)dot.op J\(0\))\)\,upright(" ") M\(omega^(J\(h\)dot.op J\(1\))\)\,upright(" ") M\(omega^(J\(h\)dot.op J\(2\))\)\,dots.h.c\,M\(omega^(J\(h\)dot.op J\(n / 2 - 1\))\)upright(" ") bold(\))$

$= bold(\() upright(" ") M\(omega^(5^h dot.op 5^0)\)\,upright(" ") M\(omega^(5^h dot.op 5^1)\)\,upright(" ") M\(omega^(5^h dot.op 5^2)\)\,dots.h.c\,M\(omega^(5^h dot.op 5^(n\/2 - 1))\)upright(" ") bold(\))$

$= bold(\() upright(" ") M\(omega^(5^h)\)\,upright(" ") M\(omega^(5^(h + 1))\)\,upright(" ") M\(omega^(5^(h + 2))\)\,dots.h.c\,M\(omega^(5^(h + n\/2 - 1))\)upright(" ") bold(\))$
$gt.tri$ note that $5^(n / 2) med mod med 2 n = 1$

$$

$= bold(\() upright(" ") M\(omega^(J\(h\))\)\,upright(" ") M\(omega^(J\(h + 1\))\)\,upright(" ") M\(omega^(J\(h + 2\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J\(0\))\)\,upright(" ") M\(omega^(J\(1\))\)\,$

$dots.h.c\,upright(" ") M\(omega^(J\(h - 2\))\)\,upright(" ") M\(omega^(J\(h - 1\))\)bold(\))$

$$

$= tilde(H)_1^(*) dot.op arrow(m)^(chevron.l h chevron.r)$ \# where
$arrow(m)^(chevron.l h chevron.r)$ contains the $n$ coefficients of the
polynomial $M\(X^(J\(h\))\)$

$$

Similarly, computing (i.e., decoding)
\$\\vec{v}\_2^{\\langle h \\rangle} = \\hathat{H}\_2^{\*\\langle h \\rangle}\\cdot \\vec{m}\$
is equivalent to modifying $M\(X\)$ to $M'\(X\)= M\(X^(J\(h\))\)$ (whose
coefficient vector is $arrow(m)^(chevron.l h chevron.r)$) and then
computing (i.e., decoding)
\$\\vec{v}\_2^{\\langle h \\rangle} = \\hathat{H}\_2^{\*}\\cdot \\vec{m}^{\\langle h \\rangle}\$.
This is because,

\$\\vec{v}\_2^{\\langle h \\rangle} =\\hathat{H}\_2^{\*\\langle h \\rangle}\\cdot \\vec{m}\$

$$

\$= \\bm{(} \\text{ } \\hathat{W}^\*\_{\\frac{n}{2} +h}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{\\frac{n}{2} + h+1}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{\\frac{n}{2} +h+2}\\cdot\\vec{m}, \\cdots, \\hathat{W}^\*\_{n -1}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{\\frac{n}{2}}\\cdot\\vec{m}, \\text{ }\\hathat{W}^\*\_{\\frac{n}{2} + 1}\\cdot\\vec{m}, \\cdots,\$

\$\\text{ } \\hathat{W}^\*\_{\\frac{n}{2} + h-2}\\cdot\\vec{m}, \\text{ } \\hathat{W}^\*\_{\\frac{n}{2} + h-1}\\cdot\\vec{m}  \\bm{)}\$

$$

$= bold(\() upright(" ") M\(\(omega^(J\(h\))\)^(J_(*)\(0\))\)\,upright(" ") M\(\(omega^(J\(h\))\)^(J_(*)\(1\))\)\,upright(" ") M\(\(omega^(J\(h\))\)^(J_(*)\(2\))\)\,dots.h.c\,M\(\(omega^(J\(h\))\)^(J_(*)\(n / 2 - 1\))\)upright(" ") bold(\))$

$gt.tri$ This is equivalent to evaluating the polynomial
$M\(X^(J\(h\))\)$ at the following $n / 2$ distinct $\(mu = 2 n\)$-th
roots of unity:
$omega^(J_(*)\(0\))\,omega^(J_(*)\(1\))\,omega^(J_(*)\(2\))\,dots.h.c\,omega^(J_(*)\(n / 2 - 1\))$

$$

$= bold(\() upright(" ") M\(omega^(J\(h\)dot.op J_(*)\(0\))\)\,upright(" ") M\(omega^(J\(h\)dot.op J_(*)\(1\))\)\,upright(" ") M\(omega^(J\(h\)dot.op J_(*)\(2\))\)\,dots.h.c\,M\(omega^(J\(h\)dot.op J_(*)\(n / 2 - 1\))\)upright(" ") bold(\))$

$= bold(\() upright(" ") M\(omega^(5^h dot.op - 5^0)\)\,upright(" ") M\(omega^(5^h dot.op - 5^1)\)\,upright(" ") M\(omega^(5^h dot.op - 5^2)\)\,dots.h.c\,M\(omega^(5^h dot.op - 5^(n\/2 - 1))\)upright(" ") bold(\))$

$= bold(\() upright(" ") M\(omega^(- 5^h)\)\,upright(" ") M\(omega^(- 5^(h + 1))\)\,upright(" ") M\(omega^(- 5^(h + 2))\)\,dots.h.c\,M\(omega^(- 5^(h + n\/2 - 1))\)upright(" ") bold(\))$
$gt.tri$ note that $-\(5^(n / 2) med mod med 2 n\)= - 1$

$$

$= bold(\() upright(" ") M\(omega^(J_(*)\(h\))\)\,upright(" ") M\(omega^(J_(*)\(h + 1\))\)\,upright(" ") M\(omega^(J_(*)\(h + 2\))\)\,dots.h.c\,M\(omega^(J_(*)\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J_(*)\(0\))\)\,upright(" ") M\(omega^(J_(*)\(1\))\)\,$

$dots.h.c\,upright(" ") M\(omega^(J_(*)\(h - 2\))\)\,upright(" ") M\(omega^(J_(*)\(h - 1\))\)bold(\))$

$$

\$= \\hathat{H}\_2^{\*}\\cdot \\vec{m}^{\\langle h \\rangle}\$

$$

The above derivations demonstrate that
\$\\vec{v}\_1^{\\langle h \\rangle} = \\hathat{H}\_1^{\*}\\cdot \\vec{m}^{\\langle h \\rangle}\$,
and
\$\\vec{v}\_2^{\\langle h \\rangle} = \\hathat{H}\_2^{\*}\\cdot \\vec{m}^{\\langle h \\rangle}\$.
Combining these two findings, we reach the conclusion that
\$\\vec{v}^{\\langle h \\rangle} = \\hathat{W}^\* \\cdot \\vec{m}^{\\langle h \\rangle}\$:
rotating the first-half elements of the input vector $arrow(v)$ by $h$
positions to the left and the second-half elements of it by $h$
positions also to the left is equivalent to updating the plaintext
polynomial $M\(X\)$ to $M\(X^(J\(h\))\)$ and then decoding it with the
decoding matrix \$\\hathat{W}^\*\$.

However, now a new problem is that we cannot directly update the
plaintext $M\(X\)$ to $M\(X^(J\(h\))\)$, because $M\(X\)$ is encrypted
as an RLWE ciphertext. Therefore, we need to instead update the RLWE
ciphertext components $\(A\,B\)$ to #emph[indirectly] by updating
$M\(X\)$ to $M\(X^(J\(X\))\)$. We will explain this in the next
subsection.

=== Updating the Plaintext Polynomial by Updating the Ciphertext Polynomials
<updating-the-plaintext-polynomial-by-updating-the-ciphertext-polynomials>
Given an RLWE ciphertext $sans("ct") =\(A\,B\)$, our goal is to update
$sans("ct") =\(A\,B\)$ to
$C^(chevron.l h chevron.r) =\(A^(chevron.l h chevron.r)\,B^(chevron.l h chevron.r)\)$
such that decrypting it gives the input vector
$arrow(v)^(chevron.l h chevron.r)$. That is, the following relation
should hold:

$sans("RLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") C^(chevron.l h chevron.r) =\(A^(chevron.l h chevron.r)\,B^(chevron.l h chevron.r)\)upright(" ") bold(\)) = Delta M\(X^(J\(h\))\)+ E'$

$$

Remember that in the RLWE cryptosystem
(#link(<sec:rlwe>)[\[sec:rlwe\]])'s alternative version
(#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]]), the
plaintext and ciphertext pair have the following relation:

$Delta M\(X\)+ E\(X\)= A\(X\)dot.op S\(X\)+ B\(X\)approx Delta M\(X\)$

$$

If we apply $X = X^(J\(h\))$ in the above relation, we can derive the
following relation:

$Delta M\(X^(J\(h\))\)+ E\(X^(J\(h\))\)= A\(X^(J\(h\))\)dot.op S\(X^(J\(h\))\)+ B\(X^(J\(h\))\)approx Delta M\(X^(J\(h\))\)$

$$

This relation implies that if we decrypt the ciphertext
$C^(chevron.l h chevron.r) =\(A\(X^(J\(h\))\)\,B\(X^(J\(h\))\)\)$ with
$S\(X^(J\(h\))\)$ as the secret key, then we get
$Delta M\(X^(J\(h\))\)$. Therefore,
$C^(chevron.l h chevron.r) =\(A\(X^(J\(h\))\)\,B\(X^(J\(h\))\)\)$ is the
RLWE ciphertext we are looking for, because decrypting it and then
decoding its plaintext $M\(X^(J\(h\))\)$ will give us the input vector
$arrow(v)^(chevron.l h chevron.r)$.

We can easily convert $sans("ct") =\(A\(X\)\,B\(X\)\)$ into
$C^(chevron.l h chevron.r) =\(A\(X^(J\(h\))\)\,B\(X^(J\(h\))\)\)$ by
applying $X^(J\(h\))$ to $X$ for each of the $A\(X\)$ and $B\(X\)$
polynomials. However, after that, notice that the decryption key of the
RLWE ciphertext
$C^(chevron.l h chevron.r) =\(A\(X^(J\(h\))\)\,B\(X^(J\(h\))\)\)$ has
been changed from $S\(X\)$ to $S\(X^(J\(h\))\)$. Thus, we need to
additionally switch the ciphertext $C^(chevron.l h chevron.r)$'s key
from $S\(X^(J\(h\))\)arrow.r S\(X\)$, which is equivalent to converting
$sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() C^(chevron.l h chevron.r) =\(A\(X^(J\(h\))\)\,B\(X^(J\(h\))\)\)bold(\))$
into
$sans("RLWE")_(S\,sigma) bold(\() C^(chevron.l h chevron.r) =\(A\(X^(J\(h\))\)\,B\(X^(J\(h\))\)\)bold(\))$.
For this, we will apply the BFV key switching technique
(Summary~@subsec:bfv-key-switching) learned in
#link(<subsec:bfv-key-switching>)[0.8] as follows:

$$

$underbrace(sans("RLWE")_(S\(X\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\)), upright("the result of")\
upright("plaintext-to-ciphertext addition")) = underbrace(bold(\() upright(" ") 0\,B\(X^(J\(h\))\)upright(" ") bold(\)), upright("the plaintext ") B\(X^(J\(h\))\)\
upright("(trivial ciphertext)")) + bold(chevron.l) upright(" ") underbrace(sans("Decomp")^(beta\,l) bold(\() A\(X^(J\(h\))\)bold(\))\,upright(" ") sans("RLev")_(S\(X\)\,sigma)^(beta\,l) bold(\() S\(X^(J\(h\))\)bold(\)) upright(" ") bold(chevron.r), upright("an RLWE ciphertext encrypting ") A\(X^(J\(h\))\)dot.op S\(X^(J\(h\))\)\
upright("which is key-switched from ") S\(X^(J\(h\))\)arrow.r S\(X\))$

=== Summary
<subsubsec:bfv-rotation-summary>
We summarize the procedure of rotating the BFV input vectors as follows:

#block[
To support input vector slot rotation, we update the original encoding
matrix in Encoding#sub[1] as follows:

$$

\$\\hathat{W} = \\begin{bmatrix}
1 & 1 & \\cdots & 1 & 1 & 1 & \\cdots & 1\\\\
(\\omega^{J(\\frac{n}{2} - 1)}) & (\\omega^{J(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J(0)}) & (\\omega^{J\_\*(\\frac{n}{2} - 1)}) & (\\omega^{J\_\*(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J\_\*(0)})\\\\
(\\omega^{J(\\frac{n}{2} - 1)})^2 & (\\omega^{J(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J(0)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J\_\*(0)})^2 \\\\
\\vdots & \\vdots & \\ddots & \\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\
(\\omega^{J(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J(\\frac{n}{2} - 2)})^{n-1} & \\cdots & (\\omega^{J(0)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^{n-1} & \\cdots  & (\\omega^{J\_\*(0)})^{n-1}
\\end{bmatrix}\$

$$

$$

, and update the original decoding matrix in Decoding#sub[2] as follows:

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

$$

$$

, where $J\(h\)$ is the #emph[rotation helper formula]:
$J\(h\)= 5^h med mod med 2 n$, $J_(*)\(h\)= - 5^h med mod med 2 n$.

$$

Using \$\\hathat{W}\$, the encoding is perform as:
\$\\vec{m} = n^{-1}\\cdot \\hathat{W} \\cdot I\_n^R \\cdot \\vec{v}\$.
Using \$\\hathat{W}^\*\$, the decoding is performed as
\$\\vec{v} = \\hathat{W}^\* \\cdot \\vec{m}\$

$$

Suppose we have an RLWE ciphertext and a key-switching key as follows:

$sans("RLWE")_(S\,sigma)\(Delta M\)=\(A\,B\)$,
$sans("RLev")_(S\,sigma)^(beta\,l) bold(\() S\(X^(J\(h\))\)bold(\))$

$$

Then, the procedure of rotating the first-half elements of the
ciphertext's original input vector $arrow(v)$ by $h$ positions to the
left (in a wrapping manner among them) and the second-half elements of
$arrow(v)$ by $h$ positions to the left (in a wrapping manner among
them) is as follows:

+ Update $A\(X\)$, $B\(X\)$ to $A\(X^(J\(h\))\)$, $B\(X^(J\(h\))\)$.

+ Perform the following key switching
  (#link(<subsec:ckks-key-switching>)[\[subsec:ckks-key-switching\]])
  from $S\(X^(J\(h\))\)$ to $S\(X\)$:

  $sans("RLWE")_(S\(X\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\)) = bold(\() 0\,B\(X^(J\(h\))\)bold(\)) upright(" ") + upright(" ") bold(chevron.l) sans("Decomp")^(beta\,l) bold(\() A\(X^(J\(h\))\)bold(\))\,upright(" ") sans("RLev")_(S\(X\)\,sigma)^(beta\,l) bold(\() S\(X^(J\(h\))\)bold(\)) bold(chevron.r)$

]
=== Encoding Example
<subsubsec:bfv-batch-encoding-ex>
In the above example, we use the unsigned modulo representation (e.g.,
$\[0\,t - 1\]\,\[0\,q\]$) when computing $med mod med t$ and
$med mod med q$. However, the correctness of the result holds even if we
use the centered modulo representation (e.g., $\[- t / 2\,t / 2\)$,
$\[- q / 2\,q / 2\)$). In many actual FHE libraries, centered modulo
arithmetic is often used to manage noise growth more effectively.

Suppose we have the following setup:

$mu = 8\,thin n = mu / 2 = 4\,thin t = 17\,thin q = 2^8 = 256\,thin n^(- 1) = 13\,thin Delta = ⌊q / t⌋ = 15$

$$

$cal(R)_(chevron.l 4\,17 chevron.r) = bb(Z)_17\[X\]\/\(X^4 + 1\)$

$$

The roots of $X^4 + 1 med\(mod med 17\)$ are $X = { 2\,8\,15\,9 }$, as
demonstrated as follows:

$2^4 equiv 8^4 equiv 15^4 equiv 9^4 equiv 16 equiv - 1 med mod med 17$

$$

Definition~@subsec:cyclotomic-def (in
#link(<subsec:cyclotomic-def>)[\[subsec:cyclotomic-def\]]) states that
the roots of the $mu$-th cyclotomic polynomial are the primitive $mu$-th
roots of unity. And Definition~@subsec:roots-def (in
#link(<subsec:roots-def>)[\[subsec:roots-def\]]) states that the order
of the primitive $mu$-th roots of unity is $mu$. These definitions apply
to both the cyclotomic polynomials over $X in bb(C)$ (complex numbers)
and the cyclotomic polynomials over $X in bb(Z)_t$ (ring).

Since ${ 2\,8\,15\,9 }$ are the roots of the $\(mu = 8\)$-th cyclotomic
polynomial $X^4 + 1$ over the ring $bb(Z)_17$, they are also the
$\(mu = 8\)$-th primitive roots of unity of $bb(Z)_17$. Therefore, their
order (#link(<subsec:order-def>)[\[subsec:order-def\]]) is $mu = 8$ as
demonstrated as follows:

$2^8 equiv 8^8 equiv 15^8 equiv 9^8 equiv 1 med mod med 17$

$2^4 equiv 8^4 equiv 15^4 equiv 9^4 equiv 16 equiv.not 1 med mod med 17$

$$

Definition~@subsec:cyclotomic-def (in
#link(<subsec:cyclotomic-def>)[\[subsec:cyclotomic-def\]]) and
Theorem~@subsec:cyclotomic-theorem
(#link(<subsec:cyclotomic-theorem>)[\[subsec:cyclotomic-theorem\]]) also
state that for each primitive $mu$-th root of unity $omega$,
${ omega^k }_(sans("gcd")\(k\,mu\)= 1)$ generates all roots of the
$mu$-th cyclotomic polynomial. Notice that in the case of the
$\(mu = 8\)$-th cyclotomic polynomial $X^4 + 1$, its roots
${ 2\,8\,15\,9 }$ generate all $\(mu = 8\)$-th roots of unity as
follows:

${ 2^1\,2^3\,2^5\,2^7 } equiv { 8^1\,8^3\,8^5\,8^7 } equiv { 15^1\,15^3\,15^5\,15^7 } equiv { 9^1\,9^3\,9^5\,9^7 } equiv { 2\,8\,15\,9 } med mod med 17$

$$

Among ${ 2\,8\,15\,9 }$ as the roots of $X^4 + 1$, let's choose
$omega = 9$ as the base root to construct the encoding matrix
\$\\hathat{W}\$ and the decoding matrix \$\\hathat{W}^\*\$ as follows:

\$\\hathat{W} = \\begin{bmatrix}
1 & 1 & 1 & 1\\\\
\\omega^{J(1)} & \\omega^{J(0)} & \\omega^{J\_\*(1)} & \\omega^{J\_\*(0)}\\\\
(\\omega^{J(1)})^2 & (\\omega^{J(0)})^2 & (\\omega^{J\_\*(1)})^2 & (\\omega^{J\_\*(0)})^2\\\\
(\\omega^{J(1)})^3 & (\\omega^{J(0)})^3 & (\\omega^{J\_\*(1)})^3 & (\\omega^{J\_\*(0)})^3\\\\
\\end{bmatrix}\$ $gt.tri$ where $J\(h\)= 5^h med mod med 8$

$= mat(delim: "[", 1, 1, 1, 1; 9^5, 9^1, 9^3, 9^7; \(9^5\)^2, \(9^1\)^2, \(9^3\)^2, \(9^7\)^2; \(9^5\)^3, \(9^1\)^3, \(9^3\)^3, \(9^7\)^3; #none) equiv mat(delim: "[", 1, 1, 1, 1; 8, 9, 15, 2; 13, 13, 4, 4; 2, 15, 9, 8; #none) med mod med 17$

$$

\$\\hathat{W}^\* = \\begin{bmatrix}
1 & \\omega^{J(0)} & (\\omega^{J(0)})^2 & (\\omega^{J(0)})^3\\\\
1 & \\omega^{J(1)} & (\\omega^{J(1)})^2 & (\\omega^{J(1)})^3\\\\
1 & \\omega^{J\_\*(0)} & (\\omega^{J\_\*(0)})^2 & (\\omega^{J\_\*(0)})^3\\\\
1 & \\omega^{J\_\*(1)} & (\\omega^{J\_\*(1)})^2 & (\\omega^{J\_\*(1)})^3\\\\
\\end{bmatrix} \\equiv \\begin{bmatrix}
1 & 9 & 13 & 15\\\\
1 & 8 & 13 & 2\\\\
1 & 2 & 4 & 8\\\\
1 & 15 & 4 & 9\\\\
\\end{bmatrix}  \\bmod{17}\$

$$

Notice that Theorem~@subsec:vandermonde-euler-integer-ring (in
#link(<subsec:vandermonde-euler-integer-ring>)[\[subsec:vandermonde-euler-integer-ring\]])
is demonstrated as follows:

\$\\hathat{W}^\* \\cdot \\hathat{W} = \\begin{bmatrix}
1 & 9 & 13 & 15\\\\
1 & 8 & 13 & 2\\\\
1 & 2 & 4 & 8\\\\
1 & 15 & 4 & 9\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
1 & 1 & 1 & 1\\\\
8 & 9 & 15 & 2\\\\
13 & 13 & 4 & 4\\\\
2 & 15 & 9 & 8\\\\
\\end{bmatrix} = \\begin{bmatrix}
0 & 0 & 0 & 4\\\\
0 & 0 & 4 & 0\\\\
0 & 4 & 0 & 0\\\\
4 & 0 & 0 & 0\\\\
\\end{bmatrix} = n I\_n^{R} \\pmod{17}\$

$$

Now suppose that we encode the following two input vectors (i.e., input
vector slots) in $bb(Z)_17$:

$arrow(v)_1 =\(10\,3\,5\,13\)$

$arrow(v)_2 =\(2\,4\,3\,6\)$

$arrow(v)_1 + arrow(v)_2 =\(10\,3\,5\,13\)+\(2\,4\,3\,6\)equiv\(12\,7\,8\,2\)med mod med 17$

$$

These two vectors are encoded as follows:

$$

\$\\vec{m}\_1 = n^{-1} \\hathat{W} \\cdot I\_n^R \\cdot \\vec{v} = 13 \\cdot \\begin{bmatrix}
1 & 1 & 1 & 1\\\\
8 & 9 & 15 & 2\\\\
13 & 13 & 4 & 4\\\\
2 & 15 & 9 & 8\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
0 & 0 & 0 & 1\\\\
0 & 0 & 1 & 0\\\\
0 & 1 & 0 & 0\\\\
1 & 0 & 0 & 0\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
10\\\\
3\\\\
5\\\\
13\\\\
\\end{bmatrix} \\equiv (12, 11, 12, 1)  \\bmod 17\$

$$

\$\\vec{m}\_2 = n^{-1} \\hathat{W} \\cdot I\_n^R \\cdot \\vec{v} = 13 \\cdot \\begin{bmatrix}
1 & 1 & 1 & 1\\\\
8 & 9 & 15 & 2\\\\
13 & 13 & 4 & 4\\\\
2 & 15 & 9 & 8\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
0 & 0 & 0 & 1\\\\
0 & 0 & 1 & 0\\\\
0 & 1 & 0 & 0\\\\
1 & 0 & 0 & 0\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
2\\\\
4\\\\
3\\\\
6\\\\
\\end{bmatrix} \\equiv (8, 5, 14, 6) \\bmod 17\$

$$

$$

$Delta M_1\(X\)= 15 dot.op\(12 + 11 X + 12 X^2 + 1 X^3\)= 180 + 165 X + 180 X^2 + 15 X^3 med\(mod med q\)$
$gt.tri$ where $q = 256$

$Delta M_2\(X\)= 15 dot.op\(8 + 5 X + 14 X^2 + 6 X^3\)= 120 + 75 X + 210 X^2 + 90 X^3 med\(mod med q\)$

$Delta M_(1 + 2)\(X\)= Delta M_1\(X\)+ Delta M_2\(X\)= Delta\(M_1\(X\)+ M_2\(X\)\)= 44 + 240 X + 134 X^2 + 105 X^3 med\(mod med q\)$

$M_(1 + 2)\(X\)= ⌈frac(44 + 240 X + 134 X^2 + 105 X^3, 15)⌋ med mod med 17$

$= ⌈2.933 + 16 X + 8.933 X^2 + 7 X^3⌋ med mod med 17$

$3 + 16 X + 9 X^2 + 7 X^3 med mod med 17$

$$

This polynomial matches the value of $arrow(m)_(1 + 2)$ as follows:

$arrow(m)_1 + arrow(m)_2 =\(12\,11\,12\,1\)+\(8\,5\,14\,6\)=\(20\,16\,26\,7\)equiv\(3\,16\,9\,7\)med mod med 17$

$$

Finally, we decode $arrow(m)_(1 + 2)$ as follows:

\$\\vec{v}\_{1+2} = \\hathat{W}^\* \\cdot \\vec{m}\_{1+2} = \\begin{bmatrix}
1 & 9 & 13 & 15\\\\
1 & 8 & 13 & 2\\\\
1 & 2 & 4 & 8\\\\
1 & 15 & 4 & 9\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}3\\\\16\\\\9\\\\7\\end{bmatrix} = (12, 7, 8, 2) \\bmod{17}\$

$$

This result matches the expected vector sum $arrow(v)_1 + arrow(v)_2$.

=== Rotation Example
<subsubsec:bfv-rotation-ex>
Also in the above example, we use the unsigned modulo representation
(e.g., $\[0\,t - 1\]\,\[0\,q\]$) when computing $med mod med t$ and
$med mod med q$. However, the correctness of the result holds even if we
use the centered modulo representation (e.g., $\[- t / 2\,t / 2\)$,
$\[- q / 2\,q / 2\)$).

Suppose we have the following setup:

$mu = 16\,n = mu / 2 = 8\,upright(" ") t = 17\,upright(" ") q = 2^8 = 256\,upright(" ") n^(- 1) = 15\,upright(" ") Delta = 15$

$$

$cal(R)_(chevron.l 8\,17 chevron.r) = bb(Z)_17\[X\]\/\(X^8 + 1\)$

$$

The roots of $X^8 + 1 med\(mod med 17\)$ are
$X = { 3\,5\,6\,7\,10\,11\,12\,14 }$, as demonstrated as follows:

$3^8 equiv 5^8 equiv 6^8 equiv 7^8 equiv 10^8 equiv 11^8 equiv 12^8 equiv 14^8 equiv 16 equiv - 1 med mod med 17$

$$

Among ${ 3\,5\,6\,7\,10\,11\,12\,14 }$ as the roots of $X^8 + 1$, let's
choose $omega = 3$ as the base root to construct the encoding matrix
\$\\hathat{W}\$ and the decoding matrix \$\\hathat{W}^\*\$ as follows:

\$\\hathat{W} = \\begin{bmatrix}
1 & 1 & 1 & 1 & 1 & 1 & 1 & 1\\\\
\\omega^{J(3)} & \\omega^{J(2)} & \\omega^{J(1)} & \\omega^{J(0)} & \\omega^{J\_\*(3)} & \\omega^{J\_\*(2)} & \\omega^{J\_\*(1)} & \\omega^{J\_\*(0)}\\\\
(\\omega^{J(3)})^2 & (\\omega^{J(2)})^2 & (\\omega^{J(1)})^2 & (\\omega^{J(0)})^2 & (\\omega^{J\_\*(3)})^2 & (\\omega^{J\_\*(2)})^2 & (\\omega^{J\_\*(1)})^2 & (\\omega^{J\_\*(0)})^2\\\\
(\\omega^{J(3)})^3 & (\\omega^{J(2)})^3 & (\\omega^{J(1)})^3 & (\\omega^{J(0)})^3 & (\\omega^{J\_\*(3)})^3 & (\\omega^{J\_\*(2)})^3 & (\\omega^{J\_\*(1)})^3 & (\\omega^{J\_\*(0)})^3\\\\
(\\omega^{J(3)})^4 & (\\omega^{J(2)})^4 & (\\omega^{J(1)})^4 & (\\omega^{J(0)})^4 & (\\omega^{J\_\*(3)})^4 & (\\omega^{J\_\*(2)})^4 & (\\omega^{J\_\*(1)})^4 & (\\omega^{J\_\*(0)})^4\\\\
(\\omega^{J(3)})^5 & (\\omega^{J(2)})^5 & (\\omega^{J(1)})^5 & (\\omega^{J(0)})^5 & (\\omega^{J\_\*(3)})^5 & (\\omega^{J\_\*(2)})^5 & (\\omega^{J\_\*(1)})^5 & (\\omega^{J\_\*(0)})^5\\\\
(\\omega^{J(3)})^6 & (\\omega^{J(2)})^6 & (\\omega^{J(1)})^6 & (\\omega^{J(0)})^6 & (\\omega^{J\_\*(3)})^6 & (\\omega^{J\_\*(2)})^6 & (\\omega^{J\_\*(1)})^6 & (\\omega^{J\_\*(0)})^6\\\\
(\\omega^{J(3)})^7 & (\\omega^{J(2)})^7 & (\\omega^{J(1)})^7 & (\\omega^{J(0)})^7 & (\\omega^{J\_\*(3)})^7 & (\\omega^{J\_\*(2)})^7 & (\\omega^{J\_\*(1)})^7 & (\\omega^{J\_\*(0)})^7\\\\
\\end{bmatrix}\$

$equiv mat(delim: "[", 1, 1, 1, 1, 1, 1, 1, 1; 12, 14, 5, 3, 10, 11, 7, 6; 8, 9, 8, 9, 15, 2, 15, 2; 11, 7, 6, 10, 14, 5, 3, 12; 13, 13, 13, 13, 4, 4, 4, 4; 3, 12, 14, 5, 6, 10, 11, 7; 2, 15, 2, 15, 9, 8, 9, 8; 7, 6, 10, 11, 5, 3, 12, 14; #none) med mod med 17$

$$

\$\\hathat{W}^\* = \\begin{bmatrix}
1 & \\omega^{J(0)} & (\\omega^{J(0)})^2 & (\\omega^{J(0)})^3 & (\\omega^{J(0)})^4 & (\\omega^{J(0)})^5 & (\\omega^{J(0)})^6 & (\\omega^{J(0)})^7\\\\
1 & \\omega^{J(1)} & (\\omega^{J(1)})^2 & (\\omega^{J(1)})^3 & (\\omega^{J(1)})^4& (\\omega^{J(1)})^5& (\\omega^{J(1)})^6& (\\omega^{J(1)})^7\\\\
1 & \\omega^{J(2)} & (\\omega^{J(2)})^2 & (\\omega^{J(2)})^3 & (\\omega^{J(2)})^4 & (\\omega^{J(2)})^5 & (\\omega^{J(2)})^6 & (\\omega^{J(2)})^7\\\\
1 & \\omega^{J(3)} & (\\omega^{J(3)})^2 & (\\omega^{J(3)})^3 & (\\omega^{J(3)})^4& (\\omega^{J(3)})^5& (\\omega^{J(3)})^6& (\\omega^{J(3)})^7\\\\
1 & \\omega^{J\_\*(0)} & (\\omega^{J\_\*(0)})^2 & (\\omega^{J\_\*(0)})^3 & (\\omega^{J\_\*(0)})^4 & (\\omega^{J\_\*(0)})^5 & (\\omega^{J\_\*(0)})^6 & (\\omega^{J\_\*(0)})^7\\\\
1 & \\omega^{J\_\*(1)} & (\\omega^{J\_\*(1)})^2 & (\\omega^{J\_\*(1)})^3 & (\\omega^{J\_\*(1)})^4& (\\omega^{J\_\*(1)})^5& (\\omega^{J\_\*(1)})^6& (\\omega^{J\_\*(1)})^7\\\\
1 & \\omega^{J\_\*(2)} & (\\omega^{J\_\*(2)})^2 & (\\omega^{J\_\*(2)})^3 & (\\omega^{J\_\*(2)})^4 & (\\omega^{J\_\*(2)})^5 & (\\omega^{J\_\*(2)})^6 & (\\omega^{J\_\*(2)})^7\\\\
1 & \\omega^{J\_\*(3)} & (\\omega^{J\_\*(3)})^2 & (\\omega^{J\_\*(3)})^3 & (\\omega^{J\_\*(3)})^4& (\\omega^{J\_\*(3)})^5& (\\omega^{J\_\*(3)})^6& (\\omega^{J\_\*(3)})^7\\\\
\\end{bmatrix}\$

$equiv mat(delim: "[", 1, 3, 9, 10, 13, 5, 15, 11; 1, 5, 8, 6, 13, 14, 2, 10; 1, 14, 9, 7, 13, 12, 15, 6; 1, 12, 8, 11, 13, 3, 2, 7; 1, 6, 2, 12, 4, 7, 8, 14; 1, 7, 15, 3, 4, 11, 9, 12; 1, 11, 2, 5, 4, 10, 8, 3; 1, 10, 15, 14, 4, 6, 9, 5; #none) med mod med 17$

$$

$$

Notice that Theorem~@subsec:vandermonde-euler-integer-ring (in
#link(<subsec:vandermonde-euler-integer-ring>)[\[subsec:vandermonde-euler-integer-ring\]])
is demonstrated as follows:

\$\\hathat{W}^\* \\cdot \\hathat{W} = \\begin{bmatrix}
1&3&9&10&13&5&15&11\\\\
1&5&8&6&13&14&2&10\\\\
1&14&9&7&13&12&15&6\\\\
1&12&8&11&13&3&2&7\\\\
1&6&2&12&4&7&8&14\\\\
1&7&15&3&4&11&9&12\\\\
1&11&2&5&4&10&8&3\\\\
1&10&15&14&4&6&9&5\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
1 & 1 & 1 & 1 & 1 & 1 & 1 & 1\\\\
12&14&5&3&10&11&7&6\\\\
8&9&8&9&15&2&15&2\\\\
11&7&6&10&14&5&3&12\\\\
13&13&13&13&4&4&4&4\\\\
3&12&14&5&6&10&11&7\\\\
2&15&2&15&9&8&9&8\\\\
7&6&10&11&5&3&12&14\\\\
\\end{bmatrix}\$

$= mat(delim: "[", 0, 0, 0, 0, 0, 0, 0, 8; 0, 0, 0, 0, 0, 0, 8, 0; 0, 0, 0, 0, 0, 8, 0, 0; 0, 0, 0, 0, 8, 0, 0, 0; 0, 0, 0, 8, 0, 0, 0, 0; 0, 0, 8, 0, 0, 0, 0, 0; 0, 8, 0, 0, 0, 0, 0, 0; 8, 0, 0, 0, 0, 0, 0, 0; #none) = n I_n^R med\(mod med 17\)$

$$

Now suppose that we encode the following input vector (i.e., input
vector slots) in $bb(Z)_17$:

$arrow(v) =\(1\,2\,3\,4\,5\,6\,7\,8\)$

By rotating this vector by 3 positions to the left (i.e., the first-half
slots and the second-half slots separately wrapping around within their
own group), we get a new vector:

$arrow(v)_r =\(4\,1\,2\,3\,8\,5\,6\,7\)med mod med 17$

$$

$arrow(v)$ is encoded as follows:

$$

\$\\vec{m} = n^{-1} \\hathat{W} \\cdot I\_n^R \\cdot \\vec{v}\$

$= 15 dot.op mat(delim: "[", 1, 1, 1, 1, 1, 1, 1, 1; 12, 14, 5, 3, 10, 11, 7, 6; 8, 9, 8, 9, 15, 2, 15, 2; 11, 7, 6, 10, 14, 5, 3, 12; 13, 13, 13, 13, 4, 4, 4, 4; 3, 12, 14, 5, 6, 10, 11, 7; 2, 15, 2, 15, 9, 8, 9, 8; 7, 6, 10, 11, 5, 3, 12, 14; #none) dot.op mat(delim: "[", 0, 0, 0, 0, 0, 0, 0, 1; 0, 0, 0, 0, 0, 0, 1, 0; 0, 0, 0, 0, 0, 1, 0, 0; 0, 0, 0, 0, 1, 0, 0, 0; 0, 0, 0, 1, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0, 0, 0; 1, 0, 0, 0, 0, 0, 0, 0; #none) dot.op mat(delim: "[", 1; 2; 3; 4; 5; 6; 7; 8; #none)$

$equiv\(13\,16\,10\,5\,9\,12\,7\,1\)med mod med 17$

$$

$Delta M\(X\)= 15 dot.op\(13 + 16 X + 10 X^2 + 5 X^3 + 9 X^4 + 12 X^5 + 7 X^6 + X^7\)$

$= 195 + 240 X + 150 X^2 + 75 X^3 + 135 X^4 + 180 X^5 + 105 X^6 + 15 X^7 med\(mod med q\)$
$gt.tri$ where $q = 256$

$$

This polynomial matches the value of $Delta M\(X^(J\(3\))\)$ as follows:

$Delta M\(X^(J\(3\))\)= Delta M\(X^13\)$

$= 195 + 180 X - 150 X^2 - 15 X^3 + 135 X^4 - 240 X^5 - 105 X^6 + 75 X^7 med\(mod med q\)$

$$

Now, we decode $M\(X^(J\(3\))\)$ as follows:

$arrow(m)_(J\(3\)) = frac(Delta arrow(m)_(J\(3\)), Delta) = frac(\(195\,180\,- 150\,- 15\,135\,- 240\,- 105\,75\), 15) =\(13\,12\,- 10\,- 1\,9\,- 16\,- 7\,5\)med\(mod med 17\)$

$$

\$\\vec{v}\_{J(3)} = \\hathat{W}^\* \\cdot \\vec{m}\_{J(3)} = \\begin{bmatrix}
1&3&9&10&13&5&15&11\\\\
1&5&8&6&13&14&2&10\\\\
1&14&9&7&13&12&15&6\\\\
1&12&8&11&13&3&2&7\\\\
1&6&2&12&4&7&8&14\\\\
1&7&15&3&4&11&9&12\\\\
1&11&2&5&4&10&8&3\\\\
1&10&15&14&4&6&9&5\\\\
\\end{bmatrix} \\cdot \\begin{bmatrix}
13\\\\
12\\\\
-10\\\\
-1\\\\
9\\\\
-16\\\\
-7\\\\
5\\end{bmatrix}\$

$=\(4\,1\,2\,3\,8\,5\,6\,7\)med\(mod med 17\)$

$= arrow(v)_r$

$$

The decoded $arrow(v)_(J\(3\))$ matches the expected rotated input
vector $arrow(v)_r$.

$$

In practice, we do not directly update $Delta M\(X\)$ to
$Delta M\(X^(J\(3\))\)$, because we would not have access to the
plaintext polynomial $M\(X\)$ unless we have the secret key $S\(X\)$.
Therefore, we instead update
$sans("ct") = bold(\() A\(X\)\,B\(X\)bold(\))$ to
$sans("ct")^(chevron.l h = 3 chevron.r) = bold(\() A\(X^(J\(3\))\)\,B\(X^(J\(3\))\)bold(\))$,
which is equivalent to homomorphically rotating the encrypted input
vector slots. Then, decrypting $sans("ct")^(chevron.l h = 3 chevron.r)$
and decoding it would output $arrow(v)_r$.

$$

Examples of BFV's batch encoding and homomorphic input vector rotation
can be executed by running
#link("https://github.com/fhetextbook/fhe-textbook/blob/main/source%20code/bfv.py")[#underline[this Python script]]
(BFV addition) and
#link("https://github.com/fhetextbook/fhetextbook.github.io/blob/main/source%20code/bfv_rotation_only.py")[#underline[this one]]
(BFV rotation only).

== Application: Matrix Multiplication
<subsec:bfv-matrix-multiplication>
BFV has no clean way to do a homomorphic dot product between two vectors
(i.e., $arrow(v)_1 dot.op arrow(v)_2$), because the last step of a
vector dot product requires summation of all slot-wise intermediate
values (i.e.,
$v_(1\,1) v_(2\,1) + v_(1\,2) v_(2\,2) + dots.h.c + v_(1\,n) v_(2\,n)$).
However, each slot in BFV's batch encoding is independent from each
other, which cannot be simply added up across slots (i.e., input vector
elements). Instead, we need $n$ copies of the multiplied ciphertexts and
properly align their slots by many rotation operations before adding
them up. Meanwhile, the homomorphic input vector slot rotation scheme
can be effectively used when we homomorphically multiply a plaintext
matrix with an encrypted vector. Remember that given a matrix $A$ and
vector $arrow(x)$ (Definition~@subsec:matrix-arithmetic in
#link(<subsec:matrix-arithmetic>)[\[subsec:matrix-arithmetic\]]):

$A = mat(delim: "[", a_(chevron.l 0\,0 chevron.r), a_(chevron.l 0\,1 chevron.r), a_(chevron.l 0\,2 chevron.r), dots.h.c, a_(chevron.l 0\,n - 1 chevron.r); a_(chevron.l 1\,0 chevron.r), a_(chevron.l 1\,1 chevron.r), a_(chevron.l 1\,2 chevron.r), dots.h.c, a_(chevron.l 1\,n - 1 chevron.r); a_(chevron.l 2\,0 chevron.r), a_(chevron.l 2\,1 chevron.r), a_(chevron.l 2\,2 chevron.r), dots.h.c, a_(chevron.l 2\,n - 1 chevron.r); dots.v, dots.v, dots.v, dots.down, dots.v; a_(chevron.l m - 1\,0 chevron.r), a_(chevron.l m - 1\,1 chevron.r), a_(chevron.l m - 1\,2 chevron.r), dots.h.c, a_(chevron.l m - 1\,n - 1 chevron.r); #none) = mat(delim: "[", arrow(a)_(chevron.l 0\,* chevron.r); arrow(a)_(chevron.l 1\,* chevron.r); arrow(a)_(chevron.l 2\,* chevron.r); dots.v; arrow(a)_(chevron.l m - 1\,* chevron.r); #none)\,upright(" ") arrow(x) =\(x_0\,x_1\,dots.h.c\,x_(n - 1)\)$

$$

The result of $A dot.op arrow(x)$ is an $m$-dimensional vector computed
as:

$A dot.op arrow(x) = #scale(x: 180%, y: 180%)[\(] arrow(a)_(chevron.l 0\,* chevron.r) dot.op arrow(x)\,upright(" ") arrow(a)_(chevron.l 1\,* chevron.r) dot.op arrow(x)\,upright(" ") dots.h.c\,upright(" ") arrow(a)_(chevron.l m - 1\,* chevron.r) dot.op arrow(x) #scale(x: 180%, y: 180%)[\)] = (sum_(i = 0)^(n - 1) a_(0\,i) dot.op x_i \, upright(" ") sum_(i = 0)^(n - 1) a_(1\,i) dot.op x_i \, dots.h.c \, upright(" ") sum_(i = 0)^(n - 1) a_(m - 1\,i) dot.op x_i)$

$$

Let's define $rho\(arrow(v)\,h\)$ as the rotation of $arrow(v)$ by $h$
positions to the left. And remember that the Hadamard dot product
(Definition~@subsec:vector-arithmetic in
#link(<subsec:vector-arithmetic>)[\[subsec:vector-arithmetic\]]) is
defined as slot-wise multiplication of two vectors:

$arrow(a) dot.circle arrow(b) =\(a_0 b_0\,upright(" ") a_1 b_1\,upright(" ") dots.h.c\,upright(" ") a_(n - 1) b_(n - 1)\)$

$$

Let's define $n$ distinct diagonal vector $arrow(u)_i$ extracted from
matrix $A$ as follows:

$arrow(u)_i = { a_(chevron.l j med mod med m\,upright(" ")\(i + j\)med mod med n chevron.r) }_(j = 0)^(n - 1)$

$$

Then, the original matrix-to-vector multiplication formula can be
equivalently constructed as follows:

$A dot.op arrow(x) = arrow(u)_0 dot.circle rho\(arrow(x)\,0\)upright(" ") + upright(" ") arrow(u)_1 dot.circle rho\(arrow(x)\,1\)upright(" ") + upright(" ") dots.h.c upright(" ") + upright(" ") arrow(u)_(n - 1) dot.circle rho\(arrow(x)\,n - 1\)$

, whose computation result is equivalent to $A dot.op arrow(x)$. The
above formula is compatible with homomorphic computation, because BFV
supports Hadamard dot product between input vectors as a
ciphertext-to-plaintext multiplication between their polynomial-encoded
forms (#link(<subsec:bfv-mult-plain>)[0.6]), and BFV also supports
$rho\(arrow(v)\,h\)$ as homomorphic input vector slot rotation
(#link(<subsec:bfv-rotation>)[0.9]). After homomorphically computing the
above formula, we can consider only the first $m$ (out of $n$) resulting
input vector slots to store the result of $A dot.op arrow(x)$.

== Noise Bootstrapping
<subsec:bfv-bootstrapping>
#strong[\- Reference 1:]
#link("https://eprint.iacr.org/2022/1363.pdf")[Bootstrapping for BGV and BFV Revisited]~#cite(label("cryptoeprint:2022/1363"))

#strong[\- Reference 2:]
#link("https://eprint.iacr.org/2014/873.pdf")[Bootstrapping for HELib]~#cite(label("10.1007/s00145-020-09368-7"))

#strong[\- Reference 3:]
#link("https://arxiv.org/pdf/1906.02867")[A Note on Lower Digits Extraction Polynomial for Bootstrapping]~@huo2019notelowerdigitsextraction

#strong[\- Reference 4:]
#link("https://eprint.iacr.org/2024/1587.pdf")[Fully Homomorphic Encryption for Cyclotomic Prime Moduli]~#cite(label("cryptoeprint:2024/1587"))

$$

In BFV, continuous ciphertext-to-ciphertext multiplication increases the
noise in a multiplicative manner, and once the noise overflows the
message bits, then the message gets corrupted. Bootstrapping is a
process of resetting the grown noise.

=== High-level Idea
<subsubsec:bfv-bootstrapping-high-level>
In this subsection, we will assume the plaintext modulus $t = p$, a
prime number. Although $t$ can be generalized as $t = p^r$ where
$r in bb(Z)$ and $r gt.eq 1$ (Summary~@subsec:bfv-enc-dec in
#link(<subsec:bfv-enc-dec>)[0.3]), we will explain BFV's bootstrapping
assuming $t = p$ for simplicity, and then generalize $t$ as $t = p^r$ in
the end.

The core idea of the BFV bootstrapping is to homomorphically evaluate a
special polynomial $G_epsilon\(x\)$, a digit extraction polynomial
modulo $p^epsilon$ (for some positive integer $epsilon$), where the
input to $G_epsilon\(x\)$ is a noisy plaintext value modulo $p^epsilon$
and the output is a noise-free plaintext value modulo $p^epsilon$,
shifted to the right by 1 base-$p$ digit. Here, where the noise located
at the least significant digits in a base-$p$ (prime) representation is
zeroed out and shifted right. For example,
$G_epsilon\(3 p^3 + 4 p^2 + 6 p + 2\)= 3 p^2 + 4 p^1 + 6 med mod med p^epsilon$.
Given that the noise resides in the least significant $epsilon - 1$
digits in base-$p$ representation, we can homomorphically and
recursively evaluate $G_epsilon\(x\)$ total $epsilon - 1$ times in a
row, which zeroes out and removes the least significant (base-$p$)
$epsilon - 1$ digits of input $x$. To homomorphically evaluate the noisy
plaintext through $G_epsilon\(x\)med mod med p^epsilon$, we need to
first switch the plaintext modulus from $t$ to $p^epsilon$, where
$q gt.double p^epsilon > p = t$. The larger $epsilon$ is, the more
likely it is that the noise gets successfully zeroed out; however, the
computation overhead becomes larger. If $epsilon$ is small, the
computation gets faster, but the digit-wise distance between the noise
and the plaintext decreases, potentially corrupting the plaintext during
bootstrapping, because removing the most significant noise digit may
also remove the least significant plaintext digit. Therefore, $epsilon$
should be chosen carefully.

$$

The technical details of the BFV bootstrapping procedure are as follows.
Suppose we have an RLWE ciphertext
$\(A\,B\)= sans("RLWE")_(S\,sigma) bold(\() Delta M bold(\)) med mod med q$,
where $A dot.op S + B = Delta M + E$, $Delta = ⌊q / t⌋$, and $t = p$
(i.e., the plaintext modulus is a prime).

+ #strong[Modulus Switch ($q arrow.r p^epsilon$):] Scale down the
  ciphertext modulus from $\(A\,B\)med mod med q$ to
  $(⌈p^epsilon / q dot.op A⌋ \, ⌈p^epsilon / q dot.op B⌋) =\(A'\,B'\)med mod med p^epsilon$,
  where $p^epsilon lt.double q$. The purpose of this modulus switch is
  to change the plaintext modulus to $p^epsilon$, which is required to
  use the digit extraction polynomial $G_epsilon\(x\)$ (because we need
  to represent the input to $G_epsilon\(x\)$ as a base-$p$ number in
  order to interpret it as a $med mod med p^epsilon$ value). Notice that
  $sans("RLWE")_(S\,sigma)^(- 1) bold(\() sans("ct") =\(A'\,B'\)bold(\)) = p^(epsilon - 1) M + E'$,
  where
  $E' approx p^epsilon / q dot.op E + (⌊q / p⌋ dot.op p^epsilon / q - p^(epsilon - 1)) dot.op M$
  $gt.tri$ the modulus switch error of $E arrow.r E'$ plus the modulus
  switch error of the plaintext's scaling factor
  $⌊q / t⌋ arrow.r p^(epsilon - 1)$

  $$

+ #strong[Homomorphic Decryption:] Suppose we have the
  #emph[bootstrapping key]
  $sans("RLWE")_(Delta' S\,sigma)\(S\)med mod med q$, which is the
  secret key $S$ encrypted by $S$ (itself) modulo $q$ with the plaintext
  scaling factor $Delta'$. Using this #emph[encrypted] secret key, we
  #emph[homomorphically] decrypt $\(A'\,B'\)$ as follows:

  $A' dot.op sans("RLWE")_(S\,sigma) bold(\() Delta' S bold(\)) + B'$
  $gt.tri$ where $sans("RLWE")_(S\,sigma)\(Delta' S\)$ is a modulo-$q$
  ciphertext that encrypts a modulo-$p^epsilon$ plaintext $S$ whose
  scaling factor $Delta' = q / p^epsilon$

  $$

  $= sans("RLWE")_(S\,sigma) bold(\() Delta'\(A' dot.op S\)bold(\)) + B' med mod med q$

  $= sans("RLWE")_(S\,sigma)\(Delta' dot.op bold(\() A' dot.op S + B'\)bold(\)) med mod med q$

  $= sans("RLWE")_(S\,sigma) bold(\() Delta' dot.op\(p^(epsilon - 1) M + E' + K p^epsilon\)bold(\)) med mod med q$
  $gt.tri$ $K$ is some integer polynomials to represent the coefficient
  values that wrap around $p^epsilon$

  $$

  Let's see how we derived the above relation. Suppose we compute
  $A' dot.op S + B' med mod med p^epsilon$, whose output will be
  $p^(epsilon - 1) M + E'$. Now, instead of using the plaintext secret
  key $S$, we use an encrypted secret key
  $sans("RLWE")_(S\,sigma)\(Delta' S\)$, where $S$ is a plaintext modulo
  $p^epsilon$, its scaling factor $Delta' = ⌊q / p^epsilon⌋$, and the
  ciphertext encrypting $S$ is in modulo $q$. Then, the result of
  homomorphically computing
  $A' dot.op sans("RLWE")_(S\,sigma)\(Delta' S\)+ B'$ will be an
  encryption of $p^(epsilon - 1) M + E' + K p^epsilon$, where
  $K p^epsilon$ stands for the wrapping-around coefficient values of the
  multiples of $p^epsilon$.

  Notice that we did not reduce $K p^epsilon$ by modulo $p^epsilon$
  during homomorphic decryption (without modulo-$q$ reduction), because
  such a homomorphic modulo reduction is not directly doable. Instead,
  we will handle $K p^epsilon$ in the later digit extraction step.

  For simplicity, we will denote
  $Z = p^(epsilon - 1) M + E' med mod med p^epsilon$.

  $$

+ #strong[CoeffToSlot:] Move the (encrypted) polynomial $Z$'s
  coefficients $z_0\,z_i\,dots.h.c\,z_(n - 1)$ to the input vector slots
  of an RLWE ciphertext. This is done by computing:

  \$\\textsf{RLWE}\_{S, \\sigma}(Z) \\cdot n^{-1}\\cdot \\hathat{W}\\cdot I\_R^n\$

  , where \$n^{-1}\\cdot \\hathat{W}\\cdot I\_R^n\$ is the batch
  encoding matrix that converts input vector slot values into polynomial
  coefficients (Summary~@subsubsec:bfv-rotation-summary in
  #link(<subsubsec:bfv-rotation-summary>)[0.9.3]).

  $$

+ #strong[Digit Extraction:] We design a polynomial $G_epsilon\(x\)$
  (i.e., a digit extraction polynomial) that zeros out the least
  significant base-$p$ digit(s) modulo $p^epsilon$. The digit extraction
  procedure recursively applies
  $G_2 compose G_3 compose dots.h.c compose G_(epsilon - 1) compose G_epsilon\(x\)$
  to the input $x$ to eliminate the least significant (base-$p$)
  $epsilon - 2$ digits of input $x$ and shifts them to the right.
  Regarding the input $x$, we assume the noise resides in the least
  significant (base-$p$) $epsilon - 2$ digits, and the message $m$
  resides in the higher base-$p$ digits modulo $p^epsilon$. Therefore,
  digit extraction has the effect of zeroing out and deleting (i.e.,
  shifting to the right) the least significant $epsilon - 1$ digits of
  the base-$p$ representation of $p^(epsilon - 1) m + e$. This digit
  extraction is performed homomorphically. Throughout the digit
  extraction, the scaled plaintext message with noise stored at the
  input vector slots of the ciphertext gets updated from
  $p^(epsilon - 1) M + E' + K p^epsilon$ to $M + K' p$. During digit
  extraction, we also use a special method called scaling factor
  re-interpretation, which conceptually increases the scaling factor
  $Delta' = ⌊q / p^epsilon⌋$ over each round of digit extraction to
  $⌊frac(q, p^epsilon - 1)⌋\,⌊frac(q, p^epsilon - 2)⌋\,dots.h\,⌊q / p⌋$,
  which equivalently has the conceptual effect of dividing the scaled
  message and noise stored in the plaintext slots by $p$ (i.e., shift to
  the right by 1 base-$p$ digit) as follows:

  #strong[Input:]
  $⌊q / p^epsilon⌋ dot.op (p^(epsilon - 1) M + E' + K p^epsilon)$

  #strong[Round 1:]
  $⌊q / p^(epsilon - 1)⌋ dot.op (p^(epsilon - 2) M + ⌊E' / p⌋ + K p^(epsilon - 1))$

  #strong[Round 2:]
  $⌊q / p^(epsilon - 2)⌋ dot.op (p^(epsilon - 3) M + ⌊E' / p^2⌋ + K p^(epsilon - 2))$

  $dots.v$

  #strong[Round $epsilon - 1$:] $⌊q / p⌋ dot.op\(M + K p\)$

  $$

  Importantly, the scaling factor re-interpretation does not require any
  actual computation; we only change the way of interpreting the
  ciphertext. We will cover this in more detail. later.

  $$

+ #strong[SlotToCoeff:] Homomorphically move each input vector slot's
  value back to the (encrypted) polynomial coefficient position. This is
  done by homomorphically multiplying the decoding matrix
  \$\\hathat{W}^\*\$ to the ciphertext
  (Summary~@subsubsec:bfv-rotation-summary in
  #link(<subsubsec:bfv-rotation-summary>)[0.9.3]). The final output of
  this step is
  $= sans("RLWE")_(S\,sigma) (⌊q / p⌋ M + E^(chevron.l b chevron.r))$,
  where $E^(chevron.l upright("b") chevron.r)$ is a new small noise term
  generated during the homomorphic operation of CoeffToSlot, digit
  extraction, and SlotToCoeff. The size of
  $E^(chevron.l upright("b") chevron.r)$ is fixed and smaller than $E$
  and $E'$.

Next, we will explain each step in more detail.

=== Modulus Switch
<subsubsec:bfv-bootstrapping-modulus-switch>
The first step of the BFV bootstrapping is to do a modulus switch from
$q$ to some prime power modulus $p^epsilon$ where
$p^epsilon lt.double q$. Before the bootstrapping, suppose the encrypted
plaintext with noise is $Delta M + E med mod med q$. Then, after the
modulus switch from $q arrow.r p^epsilon$, the plaintext would scale
down to $p^(epsilon - 1) M + E' med mod med p^epsilon$, where $E'$
roughly contains $⌈p^epsilon / q E⌋$ plus the modulus switching noise of
the plaintext's scaling factor $Delta arrow.r p^(epsilon - 1)$. The goal
of the BFV bootstrapping is to zero out this noise $E'$.

=== Homomorphic Decryption
<subsubsec:bfv-bootstrapping-homomorphic-decryption>
Let's denote the modulus-switched noisy plaintext as
$Z = p^(epsilon - 1) M + E' med mod med p^epsilon$. We further denote
polynomial $Z$'s each degree term's coefficient $z_i$ as base-$p$ number
as follows:

$z_i = z_(i\,epsilon - 1) p^(epsilon - 1) + z_(i\,epsilon - 2) p^(epsilon - 2) + dots.h.c + z_(i\,1) p + z_(i\,0) med mod med p^epsilon$

$$

Then, $z_i med mod med p^epsilon$ is a base-$p$ number comprising
$epsilon$ digits:
${ z_(i\,epsilon - 1)\,z_(i\,epsilon - 2)\,dots.h.c\,z_(i\,0) }$

We assume that the highest base-$p$ digit index for the noise is
$epsilon - 2$, which is equivalent to the noise budget, and the pure
plaintext portion solely resides at the base-$p$ digit index
$epsilon - 1$ (i.e., the most significant base-$p$ digit in modulo
$p^epsilon$). Given this assumption, we extract the noise-free plaintext
by computing the following:

$⌈z_i / p^(epsilon - 1)⌋ med mod med p = z_(i\,epsilon - 1)$ $gt.tri$
where the noise is assumed to be smaller than $p^(epsilon - 1) / 2$

The above formula is equivalent to shifting the base-$p$ number $z_i$ by
$epsilon - 1$ digits to the right (and rounding the decimal value).
However, remember that we don't have direct access to polynomial
$Z = p^(epsilon - 1) M + E' med mod med p^epsilon$ unless we have the
secret key $S$ to decrypt the ciphertext storing the plaintext. Instead,
we can only derive $Z$ as an encrypted form. Specifically, we can
#emph[homomorphically] decrypt the modulus-switched ciphertext
$\(A'\,B'\)$ by using the #emph[encrypted] secret key
$sans("RLWE")_(S\,sigma)\(Delta' S\)$ as a #emph[bootstrapping key]. For
this ciphertext $sans("RLWE")_(S\,sigma)\(Delta' S\)$, the plaintext
modulus is $p^epsilon$, the plaintext scaling factor is
$Delta' = q / p^epsilon$, and the ciphertext modulus is $q$. With this
encrypted secret key $S$, we homomorphically decrypt the encrypted $Z$
as follows:

$(⌈p^epsilon / q dot.op A⌋ \, ⌈p^epsilon / q dot.op B⌋) =\(A'\,B'\)med mod med p^epsilon$

$$

$A' dot.op sans("RLWE")_(S\,sigma) bold(\() Delta' S bold(\)) + B' med mod med q$

$= sans("RLWE")_(S\,sigma) bold(\() Delta'\(A' dot.op S\)bold(\)) + B' med mod med q$

$= sans("RLWE")_(S\,sigma)\(Delta' dot.op bold(\() A' dot.op S + B'\)bold(\)) med mod med q$

$= sans("RLWE")_(S\,sigma) bold(\() Delta' dot.op\(p^(epsilon - 1) M + E' + K p^epsilon\)bold(\)) med mod med q$
$gt.tri$ $K$ is some integer polynomials to represent the coefficient
values that wrap around modulo $p^epsilon$ as multiples of $p^epsilon$

$$

$= sans("RLWE")_(S\,sigma) bold(\() Delta' Z bold(\)) med mod med q$

$$

During this homomorphic decryption, we did not reduce the plaintext
result by modulo $p^epsilon$, because the homomorphic decryption is a
ciphertext-to-plaintext multiplication and addition done in the
ciphertext modulus $q$ (not $p^epsilon$) by using $A'$ and $B'$ as
plaintexts (with the plaintext modulus $p^e$) and
$sans("RLWE")_(S\,sigma)\(Delta' S\)$ as a ciphertext (with the
ciphertext modulus $q$). This is why the wrapping term $K p^epsilon$ is
preserved in the plaintext after the homomorphic decryption-- we will
handle this term at the later stage of bootstrapping. Also, notice that
the computation of $A' dot.op sans("RLWE")_(S\,sigma)\(Delta' S\)$ would
not generate much noise. This is because $A'$ is a plaintext modulo
$p^epsilon$, and thus the new noise generated by ciphertext-to-plaintext
multiplication is $A' dot.op E_s$ (where $E_s$ is the encryption noise
of $sans("RLWE")_(S\,sigma)\(Delta' S\)$). Since the ciphertext modulus
$q gt.double p^epsilon$, $q gt.double A' dot.op E_s$.

Once we have derived
$sans("RLWE")_(S\,sigma) bold(\() Delta' Z bold(\))$, our next step is
to remove the noise in the lower $epsilon - 1$ digits (in terms of
base-$p$ representation) of each $z_i$ for $0 lt.eq i lt.eq n - 1$. This
is equivalent to transforming noisy
$sans("RLWE")_(S\,sigma)\(Delta' Z\)= sans("RLWE")_(S\,sigma) bold(\() Delta' dot.op\(p^(epsilon - 1) M + E' + K p^epsilon\)bold(\))$
into noise-free $sans("RLWE")_(S\,sigma) bold(\() Delta M\)bold(\))$
where $Delta = q / p$. BFV's solution to do this is to design a
$p$-degree polynomial function which computes the same logical result as
$⌈z_i / p^(epsilon - 1)⌋ med mod med p$. We will later explain how to
design this polynomial by using the digit extraction polynomial
$G_epsilon\(x\)$
(#link(<subsubsec:bfv-bootstrapping-digit-extraction>)[0.11.5]).

However, in order to #emph[homomorphically] evaluate this polynomial at
each coefficient $z_i$ given the ciphertext
$sans("RLWE")_(S\,sigma)\(Delta' Z\)$, we need to move polynomial $Z$'s
each coefficient $z_i$ to the input vector slots of an RLWE ciphertext.
This is because BFV supports homomorphic batched $\(+\,dot.op\)$
operations based on input vector slots of ciphertexts as operands.
Therefore, we need to evaluate the noise-removing polynomial
$G_epsilon\(x\)$ based on the values stored in the input vector slots of
a ciphertext.

In the next sub-section, we will explain the CoeffToSlot procedure, a
process of moving polynomial coefficients into input vector slots of a
ciphertext #emph[homomorphically].

=== CoeffToSlot and SlotToCoeff
<subsubsec:bfv-bootstrapping-coefftoslot>
The goal of the CoeffToSlot step is to homomorphically move polynomial
$Z$'s coefficients $z_i$ to input vector slots.

In Summary~@subsubsec:bfv-rotation-summary (in
#link(<subsubsec:bfv-rotation-summary>)[0.9.3]), we learned that the
encoding formula for converting a vector of input slots $arrow(v)$ into
a vector of polynomial coefficients $arrow(m)$ is:
\$\\vec{m} = n^{-1}\\cdot\\hathat{W} \\cdot I\_n^R \\cdot \\vec{v}\$,
where \$\\hathat{W}\$ is a basis of the $n$-dimensional vector space
crafted as follows:

\$\\hathat{W} = \\begin{bmatrix}
1 & 1 & \\cdots & 1 & 1 & 1 & \\cdots & 1\\\\
(\\omega^{J(\\frac{n}{2} - 1)}) & (\\omega^{J(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J(0)}) & (\\omega^{J\_\*(\\frac{n}{2} - 1)}) & (\\omega^{J\_\*(\\frac{n}{2} - 2)}) & \\cdots & (\\omega^{J\_\*(0)})\\\\
(\\omega^{J(\\frac{n}{2} - 1)})^2 & (\\omega^{J(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J(0)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^2 & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^2 & \\cdots & (\\omega^{J\_\*(0)})^2 \\\\
\\vdots & \\vdots & \\ddots & \\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\
(\\omega^{J(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J(\\frac{n}{2} - 2)})^{n-1} & \\cdots & (\\omega^{J(0)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 1)})^{n-1} & (\\omega^{J\_\*(\\frac{n}{2} - 2)})^{n-1} & \\cdots  & (\\omega^{J\_\*(0)})^{n-1}
\\end{bmatrix}\$

$$

$gt.tri$ where the rotation helper function
$J\(h\)= 5^h med mod med 2 n$

$$

Therefore, given the input ciphertext
$sans("ct") = sans("RLWE")_(S\,sigma) bold(\() Delta' Z bold(\)) med mod med q$,
we can understand its input vector slots as storing some values such
that multiplying \$n^{-1}\\cdot\\hathat{W} \\cdot I\_n^R\$ to each of
them turns them into a coefficient $z_i$ of polynomial $Z$. This implies
that if we #emph[homomorphically] multiply
\$n^{-1}\\cdot\\hathat{W} \\cdot I\_n^R\$ to the input vector slots of
$sans("RLWE")_(S\,sigma) bold(\() Delta' Z bold(\))$, then the resulting
ciphertext's $n$-dimensional input vector slots will contain the $n$
coefficients of $Z$, which is equivalent to moving the coefficients of
$Z$ to the input vector slots. Therefore, the CoeffToSlot step is
equivalent to homomorphically computing
\$n^{-1}\\cdot\\hathat{W} \\cdot I\_n^R \\cdot \\textsf{RLWE}\_{S, \\sigma}\\bm(\\Delta\' Z\\bm)\$.
We can homomorphically compute matrix-vector multiplication by using the
technique explained in #link(<subsec:bfv-matrix-multiplication>)[0.10].

After the CoeffToSlot step, we can homomorphically eliminate the noise
in the lower (base-$p$) $epsilon - 1$ digits of each $z_i$ by
homomorphically evaluating the noise-removing polynomial (to be
explained in the next subsection).

After we get noise-free coefficients of $Z$, we need to move them back
from the input vector slots to their original coefficient positions.
This step is called SlotToCoeff, which is an exact inverse procedure of
CoeffToSlot. We also learned in Summary~@subsubsec:bfv-rotation-summary
(in #link(<subsubsec:bfv-rotation-summary>)[0.9.3]) that the inverse
matrix of \$n^{-1}\\cdot\\hathat{W} \\cdot I\_n^R\$ is
\$\\hathat{W}^\*\$, where:

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

Therefore, the SlotToCoeff step is equivalent to homomorphically
multiplying \$\\hathat{W}^\*\$ to the output of the noise-eliminating
polynomial evaluation.

In the next subsection, we will learn how to design the core algorithm
of BFV, the noise elimination polynomial, based on the digit extraction
polynomial $G_epsilon\(x\)$.

=== Digit Extraction
<subsubsec:bfv-bootstrapping-digit-extraction>
Remember that we defined polynomial $Z$ as the scaled noisy plaintext:
$Z = p^(epsilon - 1) M + E' + K p^epsilon equiv p^(epsilon - 1) M + E' med mod med p^epsilon$,
and each $z_i$ is the $i$-th coefficient of $Z$ (where
$0 lt.eq i lt.eq n - 1$). The goal of the digit extraction step is to
homomorphically zero out and delete (i.e., shift to the right) the lower
(base-$p$) $epsilon - 1$ digits of each $z_i$, where the noise resides.

First, we always think of $z_i$ as a base-$p$ representation (since this
is a modulo-$p^epsilon$ value) as follows:

$z_i = z_(i\,epsilon - 1) p^(epsilon - 1) + z_(i\,epsilon - 2) p^(epsilon - 2) + dots.h.c + z_(i\,2) p^2 + z_(i\,1) p + z_(i\,0) med mod med p^epsilon$

$$

Next, we define a new notation that denotes $z_i$ in a different way as
follows:

$z_i = d_0 + d_(*) p^(epsilon')$

, where $d_0 in bb(Z)_p$, and $d_(*) in bb(Z)$, and $epsilon'$ is
$z_i$'s least significant base-$p$ digit index whose value is non-zero
after digit index 0. Therefore, each $z_i in bb(Z)_(p^epsilon)$ is
mapped to a unique set of $\(d_0\,d_(*)\,epsilon'\)$.

Next, we define a #emph[lifting] polynomial $F_(epsilon')$ in terms of
$z_i$ and its associated $\(d_0\,d_(*)\,epsilon'\)$ as follows:

$F_(epsilon')\(z_i\)equiv d_0 med mod med p^(epsilon' + 1)$

Verbally speaking, $F_(epsilon')\(z_i\)$ processes $z_i$ in such a way
that it keeps $z_(i\,0)$ (i.e., $z_i$'s value at the base-$p$ digit
index 0) the same as before, then finds the next least significant
base-$p$ digit whose value is non-zero (whose digit index is denoted as
$epsilon'$) and zeros it, during which the subsequent higher significant
base-$p$ digits may be updated to arbitrary values (i.e., the function
doesn't care about those values whose base-$p$ digit index is higher
than $epsilon'$ because they fall outside the modulo $p^(epsilon' + 1)$
range).

We will show an example of how $z_i$ is updated if it is evaluated by
the $F_(epsilon')$ function recursively a total of $epsilon - 1$ times
in a row as follows:

$underbrace(F_(epsilon - 1) dots.h.c F_3 compose F_2 compose F_1, epsilon - 1 upright(" times"))\(z_i\)$

$$

$F_1\(z_i\)= c_(i\,epsilon - 1) p^(epsilon - 1) + c_(i\,epsilon - 2) p^(epsilon - 2) + dots.h.c + c_(i\,2) p^2 + 0 p + z_(i\,0) med mod med p^epsilon$

$gt.tri$ $F_1\(z_i\)equiv z_(i\,0) med mod med p^2$

$$

$F_2 compose F_1\(z_i\)= c'_(i\,epsilon - 1) p^(epsilon - 1) + c'_(i\,epsilon - 2) p^(epsilon - 2) + dots.h.c + 0 p^2 + 0 p + z_(i\,0) med mod med p^epsilon$

$gt.tri$ $F_1 compose F_2\(z_i\)equiv z_(i\,0) med mod med p^3$

$$

$F_3 compose F_2 compose F_1\(z_i\)= c''_(i\,epsilon - 1) p^(epsilon - 1) + c''_(i\,epsilon - 2) p^(epsilon - 2) + dots.h.c + 0 p^3 + 0 p^2 + 0 p + z_(i\,0) med mod med p^epsilon$

$gt.tri$
$F_3 compose F_2 compose F_1\(z_i\)equiv z_(i\,0) med mod med p^4$

$dots.v$

$underbrace(F_(epsilon - 1) compose dots.h.c compose F_3 compose F_2 compose F_1, epsilon - 1 upright(" times"))\(z_i\)= 0 p^(epsilon - 1) + 0 p^(epsilon - 2) + dots.h.c + 0 p^2 + 0 p + z_(i\,0) med mod med p^epsilon$

$gt.tri$
$F_(epsilon - 1) dots.h.c F_3 compose F_2 compose F_1\(z_i\)equiv z_(i\,0) med mod med p^epsilon$

$$

In the above recursive computation, notice that the order of using
function $F_(epsilon')$ is specifically
$F_1 arrow.r F_2 arrow.r F_3 arrow.r dots.h.c arrow.r F_(epsilon - 1)$.
We choose this specific order because we assume that for the initial
input $z_i$, we do not know its associated $epsilon'$ value (i.e., the
least significant base-$p$ digit index whose value is non-zero after
digit index 0). If we choose the order
$F_1 arrow.r F_2 arrow.r F_3 arrow.r dots.h.c arrow.r F_(epsilon - 1)$,
then regardless of the value of $z_i$, we obtain the universal guaranty
that the final output will be $z_(i\,0) med mod med p^epsilon$ (i.e.,
the value of the base-$p$ digit index 0).

$$

Now, we define the digit extraction function $G_(epsilon\,v)\(z_i\)$ as
follows:

$G_epsilon\(z_i\)= ⌊z_i / p⌋_p =\(z_i -\(underbrace(F_(epsilon - 1) compose F_(epsilon - 2) compose F_(epsilon - 3) dots.h.c compose F_3 dots.h.c compose F_2 dots.h.c compose F_1, epsilon - 1 upright(" times"))\(z_i\)\)dot.op\|p^(- 1)\|_q$

, where $⌊⌋_p$ denotes division by $p$ and rounding down to the nearest
multiple of $p$. Verbally speaking, $G_(epsilon\,v)\(z_i\)$ is
equivalent to zeroing out the least significant base-$p$ digit of $z_i$
and then shifting to the right by 1 base-$p$ digit. The shifting is done
by inverse $p$ multiplication (i.e., $\|p^(- 1)\|_q$). Notice that the
last base-$p$ digit of
$z_i -\(F_(epsilon - 1) compose F_(epsilon - 2) compose F_(epsilon - 3) dots.h.c compose F_1\(z_i\)\)$
is 0, which is exactly divisible by $p$. Thus, multiplying by the
inverse $p$ has the effect of exact division (i.e., shifting the whole
base-$p$ representation by 1 digit to the right). The reason why the
inverse $p$ is in modulo $q$ is that we are currently under the BFV
ciphertext relation:
$sans("CoeffToSlot") bold(\()\(A'\,B'\)bold(\)) =\(A^(chevron.l c arrow.r s chevron.r)\,B^(chevron.l c arrow.r s chevron.r)\)med mod med q$,
whose plaintext slots store the coefficients of
$Delta' dot.op\(p^(epsilon - 1) M + E' + K^(chevron.l 1 chevron.r) p^epsilon\)med mod med q$.
Upon homomorphically computing
$\(z_i -\(F_(epsilon - 1) compose F_(epsilon - 2) compose F_(epsilon - 3) dots.h.c compose F_3 dots.h.c compose F_2 dots.h.c compose F_1\)$
as part of the 1st round of digit extraction, the ciphertext is updated
to
$\(A^(chevron.l g_1 chevron.r)\,B^(chevron.l g_1 chevron.r)\)med mod med q$,
whose plaintext slots store the coefficients of
$Delta' dot.op\(p^(epsilon - 1) M + floor.l E' floor.r_p + K^(chevron.l 1 chevron.r) p^epsilon\)med mod med q$,
where $floor.l E' floor.r_p$ is equivalent to rounding $E'$ down to the
nearest multiple of $p$. At this point (i.e., just before inverse-$p$
multiplication in the first round), the ciphertext holds the following
relation:

$A^(chevron.l g_1 chevron.r) dot.op S + B^(chevron.l g_1 chevron.r) = Delta' dot.op\(p^(epsilon - 1) M + ⌊E'⌋_p + K^(chevron.l 1 chevron.r) p^epsilon\)+ E^(chevron.l g_1 chevron.r) med mod med q$

$$

, where $E^(chevron.l g_1 chevron.r)$ is the combined noise of the
SlotToCoeff step and the first part of the 1st round of digit
extraction. We could consider multiplying $\|p^(- 1)\|_q$ to both sides
of the relation to scale down $p^(epsilon - 1) M\,⌊E'⌋_p\,$ and
$K^(chevron.l 1 chevron.r) p^epsilon$ by $p$. However, this causes a
noise explosion problem, because this scaling will be also applied to
the $E^(chevron.l g_1 chevron.r)$ term, and
$\|p^(- 1)\|_qE^(chevron.l g_1 chevron.r)$ is a huge value. To
selectively apply the inverse-$p$ multiplication only to those terms of
interest, we use the scaling factor re-interpretation technique.

$$

Although we previously explained that $G_epsilon$ involves the
multiplication by $\|p^(- 1)\|_q$, technically, we skip this
multiplication and instead conceptually re-interpret the scaling factor
$Delta'$ as
$⌊q / p^epsilon⌋ arrow.r ⌊frac(q, p^epsilon - 1)⌋ arrow.r ⌊frac(q, p^epsilon - 2)⌋ arrow.r dots.h.c\,⌊q / p⌋$
across $epsilon - 1$ rounds of digit extraction. During this
re-interpretation, each step's $p$ being decreased in the denominator of
the scaling factor is conceptually placed back into the bracket.
Applying the re-interpretation of the scaling factor, the digit
extraction procedure (without explicit multiplication by $\|p^(- 1)\|_q$
at each round) is performed as follows:

#strong[Input:]
$⌊q / p^epsilon⌋ dot.op\(p^(epsilon - 1) M + E' + K p^epsilon\)med mod med q$

#strong[1st Round:]
\$G\_{\\varepsilon}(z\_i) \\xRightarrow{\\text{effect}} \\left\\lfloor\\dfrac{q}{p^{\\varepsilon-1}}\\right\\rfloor \\cdot (p^{\\varepsilon - 2}M + \\left\\lfloor\\dfrac{E\'}{p}\\right\\rfloor + K^{\\langle 1 \\rangle}p^{\\varepsilon-1}) \\bmod q\$

#strong[2nd Round:]
\$G\_{\\varepsilon-1} \\circ G\_{\\varepsilon}(z\_i) \\xRightarrow{\\text{effect}} \\left\\lfloor\\dfrac{q}{p^{\\varepsilon-2}}\\right\\rfloor \\cdot (p^{\\varepsilon - 3}M + \\left\\lfloor\\dfrac{E\'}{p^2}\\right\\rfloor + K^{\\langle 2 \\rangle}p^{\\varepsilon-2}) \\bmod q\$

#strong[3rd Round:]
\$G\_{\\varepsilon-2} \\circ G\_{\\varepsilon-1} \\circ G\_{\\varepsilon}(z\_i)  \\xRightarrow{\\text{effect}} \\left\\lfloor\\dfrac{q}{p^{\\varepsilon-3}}\\right\\rfloor \\cdot (p^{\\varepsilon - 4}M + \\left\\lfloor\\dfrac{E\'}{p^3}\\right\\rfloor + K^{\\langle 3 \\rangle}p^{\\varepsilon-3}) \\bmod q\$

$dots.v$

#strong[$bold(epsilon - 1)$-th Round:]
\$G\_{2}\\circ \\cdots \\circ G\_{\\varepsilon} (z\_i) \\xRightarrow{\\text{effect}} \\left\\lfloor\\dfrac{q}{p}\\right\\rfloor \\cdot (M + K^{\\langle \\varepsilon - 1 \\rangle}p)  \\bmod q\$

$$

$$

Note that the scaling factor re-interpretation does not involve any
actual computation, but only changes our way of interpreting the scaling
factor. Notice that at the end of the final round, the plaintext scaling
factor becomes $⌊q / p⌋$, which is the desired plaintext scaling factor
for standard BFV ciphertexts. Therefore, the scaling factor
re-interpretation has three benefits: (1) we skip explicit
multiplication by $\|p^(- 1)\|_q$ at each round; (2) we prevent noise
explosion; (3) at the end of all rounds, the plaintext scaling factor
becomes the desired value for standard BFV ciphertexts, gracefully
completing the bootstrapping procedure.

Meanwhile, there are two important points to be aware of. First, each
$i$-th round of scaling factor re-interpretation creates a small drift
error in the scaling factor due to the difference
$epsilon.alt_i = p^(- 1) dot.op ⌊q / p^(epsilon - i)⌋ - ⌊q / p^(epsilon - i + 1)⌋$,
where $0 lt.eq epsilon.alt_i < p$. Therefore, an additional drift error
$E_i^(chevron.l upright("re") chevron.r)$ is created at each $i$-th
round, which is small enough to be bounded by:

$E_i^(chevron.l upright("re") chevron.r) lt.eq epsilon.alt_i dot.op\(p^(epsilon - i - 1) M + ⌊E' / p^i⌋ + K^(chevron.l i chevron.r) p^(epsilon - i)\)< p^(epsilon - 1) M + ⌊E' / p⌋ + K^(chevron.l i chevron.r) p^(epsilon + 1) lt.double ⌊q / p^epsilon⌋$

$$

Second, at each $i$-th round of digit extraction, the plaintext operands
used for ciphertext-to-plaintext homomorphic operations should encode
their values with the specific scaling factor interpreted at that round:
$Delta'_i = ⌊q / p^(epsilon - i + 1)⌋$.

$$

Now, our final remaining task is to design the actual #emph[lifting]
polynomial $F_(epsilon')\(z_i\)$ that implements $G_epsilon$.

$$

We will derive $F_(epsilon')\(z_i\)$ based on the following steps.

+ #strong[#emph[Claim:]] $z_i^p equiv z_(i\,0) med mod med p$

  #block[
  #emph[Proof.] It's true that $z_i equiv z_(i\,0) med mod med p$.
  Fermat's Little Theorem states $a^p equiv a med mod med p$ for all
  $a in bb(Z)_p$ and prime $p$. Therefore,
  $z_i equiv z_(i\,0) equiv z_(i\,0)^p equiv z^p med mod med p$.~◻

  ]

+ #strong[#emph[Claim:]]
  $z_i^p equiv z_(i\,0)^p med mod med p^(epsilon' + 1)$

  #block[
  $\(z_(i\,0) + k p^(epsilon')\)^pmed mod med p^(epsilon' + 1) = sum_(j = 0)^p binom(p, j) dot.op z_(i\,0)^j dot.op\(k p^(epsilon')\)^(p - j)med mod med p^(epsilon' + 1)$
  $gt.tri$ binomial expansion formula

  $equiv z_(i\,0)^p med mod med p^(epsilon' + 1)$ $gt.tri$ all terms
  where $j < p$ are $0 med mod med p^(epsilon' + 1)$

  ]
  $$

+ #strong[#emph[Claim:]] Given $p$ and $epsilon'$ are fixed, there
  exists $epsilon' + 1$ polynomials
  $f_0\,f_1\,f_2\,dots.h.c\,f_(epsilon')$ (where each polynomial is at
  most $p - 1$ degrees) such that any $z_i$ (i.e., any number whose
  base-$p$ representation has 0s between the base-$p$ digit index
  greater than 0 and smaller than $epsilon'$) can be expressed as the
  following formula:

  $z_i^p equiv sum_(j = 0)^(epsilon') f_j\(z_(i\,0)\)dot.op p^j med mod med p^(epsilon' + 1)$

  #block[
  $z_i^p med mod med p^(epsilon' + 1)$ can be expressed as a base-$p$
  number as follows:

  $z_i^p med mod med p^(epsilon' + 1) = c_0 + c_1 p + c_2 p^2 + dots.h.c + c_(epsilon') p^(epsilon')$

  $$

  Based on step 3's claim
  ($z_i^p equiv z_(i\,0)^p med mod med p^(epsilon' + 1)$), we know that
  the value of $z_i^p med mod med p^(epsilon' + 1)$ depends only on
  $z_(i\,0)$ (given $p$ and $epsilon'$ are fixed). Therefore, we can
  imagine that there exists some function $f\(z_(i\,0)\)$ whose input is
  $z_(i\,0) in\[0\,p - 1\]$ and the output is
  $z_i^p in\[0\,p^(epsilon' + 1) - 1\]$. Alternatively, we can imagine
  that there exist $epsilon' + 1$ different functions
  $f_0\,f_1\,dots.h.c\,f_(epsilon')$ such that each $f_j$ is a
  polynomial whose input is $z_(i\,0) in\[0\,p - 1\]$ and the output is
  $c_i in\[0\,p - 1\]$, and
  $z_i^p equiv sum_(j = 0)^(epsilon') f_j\(z_(i\,0)\)dot.op p^j med mod med p^(epsilon' + 1)$.
  In this case, the input and output domain of each polynomial $f_j$ is
  $\[0\,p - 1\]$. Therefore, we can design each $f_j$ as a
  $\(p - 1\)$-degree polynomial and derive each $f_j$ based on
  polynomial interpolation
  (#link(<sec:polynomial-interpolation>)[\[sec:polynomial-interpolation\]])
  by using $p$ coordinate values.

  Note that whenever we increase $epsilon'$ to $epsilon' + 1$, we add a
  new polynomial $f_(epsilon' + 1)$. However, the previous polynomials
  $f_0\,f_1\,dots.h.c\,f_(epsilon')$ stay the same as before, because
  increasing $epsilon'$ by 1 only adds a new base-$p$ constant
  $c_(epsilon' + 1)$ for the highest base-$p$ digit, while keeping the
  lower-digit constants $c_0\,c_1\,dots.h.c\,c_(epsilon')$ the same as
  before. Therefore, the polynomials $f_0\,f_1\,dots.h.c\,f_(epsilon')$,
  each of which computes $c_0\,c_1\,dots.h.c\,c_(epsilon')$, also stay
  the same as before.

  ]

+ #strong[#emph[Claim:]] The formula in step 4's claim can be further
  concretized as follows:

  $z_i^p equiv z_(i\,0) + sum_(j = 1)^(epsilon') f_j\(z_(i\,0)\)dot.op p^j med mod med p^(epsilon' + 1)$

  #block[
  According to step 2's claim ($z_i^p equiv z_(i\,0) med mod med p$), we
  know that the following base-$p$ representation of $z_i^p$:

  $z_i^p equiv c_0 + c_1 p + c_2 p^2 + dots.h.c + c_(epsilon') p^(epsilon') med mod med p^(epsilon' + 1)$

  $$

  will be the following:

  $z_i^p equiv z_(i\,0) + c_1 p + c_2 p^2 + dots.h.c + c_(epsilon') p^(epsilon') med mod med p^(epsilon' + 1)$

  $$

  , since step 2's claim implies that the least significant base-$p$
  digit of $z_i^p$ in the base-$p$ representation is always $z_(i\,0)$.
  Thus, the formula in step 4's claim:

  $z_i^p equiv sum_(j = 0)^(epsilon') f_j\(z_(i\,0)\)dot.op p^j med mod med p^(epsilon' + 1)$

  $$

  can be further concretized as follows:

  $$

  $z_i^p equiv z_(i\,0) + sum_(j = 1)^(epsilon') f_j\(z_(i\,0)\)dot.op p^j med mod med p^(epsilon' + 1)$

  ]

+ #strong[#emph[Claim:]]
  $z_i^p - sum_(j = 1)^(epsilon') f_j\(z_i\)dot.op p^j equiv z_(i\,0) med mod med p^(epsilon' + 1)$

+ Finally, we define the lifting polynomial $F_(epsilon')\(z_i\)$ as
  follows:

  $F_(epsilon')\(z_i\)= z_i^p - sum_(j = 1)^(epsilon') f_j\(z_i\)dot.op p^j$

  \$\\textcolor{white}{F\_{\\varepsilon\'}(z\_i) } \\equiv z\_{i,0} \\bmod p^{\\varepsilon\' + 1}\$

  The above relation implies that
  $F_(epsilon')\(x\)med mod med p^(epsilon' + 1)$ is equivalent to the
  least significant base-$p$ digit of $x$ (according to step 6's claim).
  Therefore, if we plug in $z_i$ into $F_(epsilon')\(x\)$ and regard
  $epsilon' = 1$, then the output is some number whose least significant
  base-$p$ digit is $z_(i\,0) med mod med p^2$ and the 2nd least
  significant base-$p$ digit is $0 med mod med p^2$. As we recursively
  apply the output back to $F_(epsilon')\(x\)$ and increment $epsilon'$
  by 1, we iteratively zero out the 2nd least significant base-$p$
  digit, the 3rd least significant base-$p$ digit, and so on. We repeat
  this process for $epsilon - 1$ times to zero out the upper
  $epsilon - 1$ base-$p$ digits, keeping only the least significant
  digit as it is (i.e., $z_(i\,0)$). Therefore, $F_(epsilon')\(x\)$ is a
  valid lifting polynomial that can be iteratively used to extract the
  least significant digit of $z_i med mod med p^epsilon$.

We use $F_(epsilon')\(x\)$ as the internal helper function within the
digit extraction function $G_epsilon\(z_i\)$ that calls
$F_(epsilon')\(x\)$ a total of $v - 1$ times.

=== Summary
<subsubsec:bfv-bootstrapping-summary>
We summarize the BFV bootstrapping procedure (with the generalization of
$t = p^r$) as follows.

#block[
Suppose we have an RLWE ciphertext
$\(A\,B\)= sans("RLWE")_(S\,sigma) bold(\() Delta M + E bold(\)) med mod med q$,
where $Delta = ⌊q / t⌋$ and $t = p^r$ (i.e., the plaintext modulus is a
power of some prime), $r in bb(Z)$, and $r gt.eq 1$.

$$

+ #strong[#underline[Modulus Switch] (from $q arrow.r p^epsilon$):]
  Scale down the ciphertext from $\(A\,B\)$ to
  $(⌈p^epsilon / q dot.op A⌋ \, ⌈p^epsilon / q dot.op B⌋) =\(A'\,B'\)$
  $gt.tri$ where $p^epsilon lt.double q$

  $$

  $A' S + B' = p^(epsilon - r) M + E' med mod med p^epsilon$ $gt.tri$
  where
  $E' approx p^epsilon / q dot.op E + (⌊q / p^r⌋ dot.op p^epsilon / q - p^(epsilon - r)) dot.op M$,
  which is a modulus switch noise plus the rounding noise caused by
  treating $Delta = ⌊q / p^r⌋ approx q / p^r$.

  $$

+ #strong[#underline[Homomorphic Decryption]:] With the bootstrapping
  key $sans("RLWE")_(S\,sigma)\(Delta' S\)med mod med q$,
  homomorphically decrypt $\(A'\,B'\)med mod med p^epsilon$ as follows:

  $A' dot.op sans("RLWE")_(S\,sigma)\(Delta' S\)+ B' = sans("RLWE")_(S\,sigma) bold(\() Delta' dot.op\(p^(epsilon - r) M + E' + K p^epsilon\)bold(\)) med mod med q$
  $gt.tri$ where $Delta' = ⌊q / p^epsilon⌋$

  $$

  Now, we denote the modulus-switched noisy plaintext polynomial as
  $Z = p^(epsilon - r) M + E' + K p^epsilon$.

  $$

+ #strong[#underline[CoeffToSlot]:] Move the (encrypted) polynomial
  $Z$'s coefficients $z_0\,z_i\,dots.h.c\,z_(n - 1)$ to the input vector
  slots. This is done by computing:

  \$\\textsf{RLWE}\_{S, \\sigma}(\\Delta\' Z) \\cdot n^{-1}\\cdot \\hathat{W}\\cdot I\_R^n\$

  $= sans("RLWE")_(S\,sigma)\(Delta' Z^(chevron.l 1 chevron.r)\)$

  , where \$n^{-1}\\cdot \\hathat{W}\\cdot I\_R^n\$ is the batch
  encoding matrix (Summary~@subsubsec:bfv-rotation-summary in
  #link(<subsubsec:bfv-rotation-summary>)[0.9.3]).

  $$

+ #strong[#underline[Digit Extraction]:] We design a polynomial
  $G_epsilon\(z_i\)$ (a digit extraction polynomial) as follows:

  $z_i = d_0 + (sum_(j = epsilon')^(epsilon - r) d_(*) p^j)$ $gt.tri$
  where $d_0 in bb(Z)_p$, and $epsilon'$ is $z_i$'s first least
  significant base-$p$ digit index whose value is non-zero (after digit
  index 0) currently being processed by the $F_(epsilon')\(Z_i\)$
  function

  $F_(epsilon')\(z_i\)equiv d_0 med mod med p^(epsilon' + 1)$ $gt.tri$ a
  $\(p - 1\)$-degree polynomial recursively used to finally extract the
  value $d_0 med mod med p^epsilon$

  $G_epsilon\(z_i\)equiv\(z_i - underbrace(F_(epsilon - 1) compose F_(epsilon - 2) compose F_(epsilon - 3) dots.h.c F_r, epsilon - r upright(" times"))\(z_i\)\)dot.op\|p^(- 1)\|_qmed mod med p^epsilon$

  $$

  We homomorphically evaluate the digit extraction polynomial
  $G_epsilon$ recursively total $epsilon - r$ times at each coefficient
  $z_i$ of $Z$ stored at input vector slots, which zeros out and
  right-shifts the least significant (base-$p$) $epsilon - r$ digits of
  $z_i$ as follows:

  $G_(r + 1) compose G_(r + 2) compose dots.h.c compose G_(epsilon - 1) compose G_epsilon\(z_i\)$

  $= m_i + k'_i p$

  $$

  , provided $E'$'s each coefficient is smaller than
  $∥p^(epsilon - r) / 2∥$. At this point, each input vector slot
  contains the noise-removed coefficient
  $m_i + k_i^(chevron.l epsilon - r - 1 chevron.r) p$.

  At each $i$-th round of digit extraction, we do not explicitly
  multiply $\|p^(- 1)\|_q$ to perform division by $p$, but instead
  conceptually borrow this term from the denominator of the plaintext
  scaling factor $Delta'$, conceptually updating the scaling factor to
  $⌊q / p^(epsilon - i)⌋$. This implies that at $i$-th round of digit
  extraction, the plaintext operations used for ciphertext-to-plaintext
  homomorphic operations should encode their values by using the scaling
  factor $⌊q / p^(epsilon - i)⌋$. At the end of digit extraction, the
  plaintext scaling factor becomes $Delta' = Delta = ⌊q / p^r⌋$.

  $$

+ #strong[#underline[SlotToCoeff]:] Homomorphically move each input
  vector slot's value
  $m_i + k_i^(chevron.l epsilon - r - 1 chevron.r) p^epsilon$ back to
  the (encrypted) polynomial coefficient positions. This is done by
  multiplying \$\\hathat{W}^\*\$ to the output ciphertext of the digit
  extraction step, where \$\\hathat{W}^\*\$ is the decoding matrix
  (Summary~@subsubsec:bfv-rotation-summary in
  #link(<subsubsec:bfv-rotation-summary>)[0.9.3]). The output of this
  computation is
  $sans("RLWE")_(S\,sigma) bold(\() Delta dot.op\(M + K^(chevron.l epsilon - r - 1 chevron.r) p\)+ E^(chevron.l upright("b") chevron.r)\)bold(\)) = sans("RLWE")_(S\,sigma) bold(\() Delta dot.op\(M + E^(chevron.l upright("final") chevron.r)\)bold(\)) med mod med q$,
  where $E^(chevron.l upright("b") chevron.r)$ is the new noise
  generated during bootstrapping (step $3 tilde.op 5$).

]
Its purpose is to temporarily adjust the scaling factor of the
ciphertext to preserve the correctness of bootstrapping. Before
homomorphic decryption, the ciphertext encrypts $p^(epsilon - r) M$, a
message with the scaling factor $p^(epsilon - r)$. After homomorphic
decryption, the ciphertext encrypts $Delta' p^(epsilon - r) M$, the
message $p^(epsilon - r) M$ with the scaling factor
$Delta' = ⌊q / p^epsilon⌋$. This specific adjustment is needed for the
scaling factor re-interpretation during each round of digit extraction
to conceptually divide by $p$ (i.e., multiply by $\|p^(- 1)\|_q$) and
eventually adjust the scaling factor back to $⌊q / p^r⌋$ as the original
form for standard BFV ciphertexts.
