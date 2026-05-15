The CKKS scheme is designed for homomorphic addition and multiplication
of complex numbers that contain imaginary components. Therefore, unlike
BFV, BGV, or TFHE, which can only compute over integers, CKKS can
compute real-world floating point arithmetic, such as in machine
learning.

The CKKS scheme's goal is to homomorphically compute the addition and
multiplication of complex numbers. However, while our targeted inputs
are complex numbers, CKKS's plaintext space is defined as a
$\(n - 1\)$-degree polynomial ring with real-number coefficients having
limited precision; that is,
$cal(R)_(chevron.l n chevron.r) = bb(R)\[x\]\/\(x^n + 1\)$. Therefore,
CKKS designs its unique encoding scheme, which converts the input
complex numbers into integers that can be used as coefficients of a
polynomial in $cal(R)_(chevron.l n chevron.r)$.

$$

Overall, CKKS's encryption procedure is as follows:

+ #underline[Encoding#sub[1]:] Encode the targeted input complex number
  as a real number

+ #underline[Encoding#sub[2]:] Encode the real number as an integer

+ #underline[Encryption:] Encrypt the integer using RLWE

The encrypted RLWE ciphertext supports homomorphic addition and
multiplication.

$$

At the end of all homomorphic operations, CKKS's decryption procedure is
as follows:

+ #underline[Decryption:] Decrypt the RLWE ciphertext into a plaintext
  integer

+ #underline[Decoding#sub[1]:] Decode the integer to a real number

+ #underline[Decoding#sub[2]:] Decode the real number to a complex
  number

$$

Remember that BFV is an exact encryption scheme based on rings. On the
other hand, CKKS introduces a drifting error while its encoding process
of rounding square-root values (included in the Euler's formula) to the
nearest integer. Therefore, its decryption is not exactly the same as
before encryption. Such a small error occurring during encryption and
decryption makes CKKS an #emph[approximate] encryption scheme.

CKKS internally uses the same schemes as BFV for encryption, decryption,
ciphertext-to-plaintext addition, ciphertext-to-ciphertext addition, and
ciphertext-to-plaintext multiplication. Meanwhile, CKKS uses slightly
different schemes than BFV for encoding the input vector (i.e., input
vector slots) rotation (if BFV uses the batch encoding scheme),
ciphertext-to-ciphertext multiplication, and bootstrapping. This
difference comes from the fact that CKKS handles homomorphic operations
over complex numbers as inputs, whereas BFV handles homomorphic
operations over rings.

#block[
- #link(<sec:modulo>)[\[sec:modulo\]]:

- #link(<sec:group>)[\[sec:group\]]:

- #link(<sec:field>)[\[sec:field\]]:

- #link(<sec:order>)[\[sec:order\]]:

- #link(<sec:polynomial-ring>)[\[sec:polynomial-ring\]]:

- #link(<sec:decomp>)[\[sec:decomp\]]:

- #link(<sec:roots>)[\[sec:roots\]]:

- #link(<sec:cyclotomic>)[\[sec:cyclotomic\]]:

- #link(<sec:matrix>)[\[sec:matrix\]]:

- #link(<sec:euler>)[\[sec:euler\]]:

- #link(<sec:modulus-rescaling>)[\[sec:modulus-rescaling\]]:

- #link(<sec:chinese-remainder>)[\[sec:chinese-remainder\]]:

- #link(<sec:taylor-series>)[\[sec:taylor-series\]]:

- #link(<sec:polynomial-interpolation>)[\[sec:polynomial-interpolation\]]:

- #link(<sec:ntt>)[\[sec:ntt\]]:

- #link(<sec:lattice>)[\[sec:lattice\]]:

- #link(<sec:rlwe>)[\[sec:rlwe\]]:

- #link(<sec:glwe>)[\[sec:glwe\]]:

- #link(<sec:glev>)[\[sec:glev\]]:

- #link(<sec:glwe-add-cipher>)[\[sec:glwe-add-cipher\]]:

- #link(<sec:glwe-add-plain>)[\[sec:glwe-add-plain\]]:

- #link(<sec:glwe-mult-plain>)[\[sec:glwe-mult-plain\]]:

- #link(<subsec:modulus-switch-rlwe>)[\[subsec:modulus-switch-rlwe\]]:

- #link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]:

- #link(<sec:bfv>)[\[sec:bfv\]]:

]
== Encoding and Decoding
<subsec:ckks-encoding-decoding>
CKKS's encoding and decoding is fundamentally very similar to BFV's
batch encoding scheme. BFV designs its batch encoding scheme
(Summary~@subsec:bfv-enc-dec in
#link(<subsec:bfv-enc-dec>)[\[subsec:bfv-enc-dec\]]) based on the
updated \$\\hathat W\$ and \$\\hathat W^\*\$ matrices
(Summary~@subsubsec:bfv-rotation-summary in
#link(<subsec:bfv-rotation>)[\[subsec:bfv-rotation\]]). That is, BFV
decodes a polynomial into an input slot vector by evaluating the
polynomial at each root of $X^n + 1$, which is the primitive
$\(mu = 2 n\)$-th root of unity (i.e.,
\$\\vec{v} = \\hathat W^\* \\cdot \\vec{m}\$), and encodes an input slot
vector into a polynomial by inversing this operation (i.e.,
\$\\vec{m} = n^{-1} \\cdot \\hathat W \\cdot I\_n^R \\cdot \\vec{v}\$).
This encoding and decoding scheme is designed based on
Summary~@subsec:poly-vector-transformation-complex
(#link(<subsec:poly-vector-transformation-complex>)[\[subsec:poly-vector-transformation-complex\]])
which designs the isomorphic mapping between $n$-dimensional vectors in
a ring (finite field) and $\(n - 1\)$-degree (or lesser degree)
polynomials as follows:

$sigma : f\(x\)in bb(Z)_t\[X\]\/F\(X\)upright(" ") arrow.r upright(" ")\(f\(omega^1\)\,f\(omega^3\)\)\,dots.h.c\,f\(omega^(2 n - 1)\)\)in bb(Z)_t^n$

, where $omega = g^(frac(t - 1, 2 n))$ is a root of (i.e., primitive
$\(mu = 2 n\)$-th root of unity) of the $\(mu = 2 n\)$-th cyclotomic
polynomial $X^n + 1$ defined over a prime modulo $t$ ring.

$$

CKKS's batch encoding scheme uses exactly the same formula for encoding
and decoding (i.e., $arrow(v) = W^T dot.op arrow(m)$ and
$arrow(m) = frac(W dot.op I_n^R dot.op arrow(v), n)$), but the
$n$-dimensional input slot vector comprises not in a ring (i.e.,
$bb(Z)_p^n$), but complex numbers (i.e., $bb(hat(C))^n$). In
Summary~@subsec:poly-vector-transformation-complex
(#link(<subsec:poly-vector-transformation-complex>)[\[subsec:poly-vector-transformation-complex\]]),
we also designed the mapping $sigma_c$ between polynomials and vectors
over complex numbers as follows:

$sigma_c : f\(X\)in bb(R)\[X\]\/\(X^n + 1\)arrow.r\(f\(omega\)\,f\(omega^3\)\,f\(omega^5\)\,dots.h.c\,f\(omega^(2 n - 1)\)\)in bb(hat(C))^n upright(" ")\(arrow.r bb(C)^(n / 2)\)$

, where $omega = e^(i pi\/n)$ is a root (i.e., the primitive
$\(mu = 2 n\)$-th root) of the $\(mu = 2 n\)$-th cyclotomic polynomial
$X^n + 1$ defined over complex numbers, and $bb(hat(C))^n$ is
$n$-dimensional complex special vector space whose second-half elements
are reverse-ordered conjugates of the first-half elements. And
$bb(hat(C))^n$ is isomorphic to $bb(C)^(n / 2)$, because the second-half
elements of $bb(hat(C))^n$ are automatically determined by its
first-half elements. Therefore, the $sigma_c$ mapping is essentially an
isomorphism between $n / 2$-dimensional complex vectors
$arrow(v) in bb(C)^(n / 2)$ and $\(n - 1\)$-degree (or lesser degree)
real-number polynomials $bb(R)\[X\]\/\(X^n + 1\)$. Therefore, CKKS'
batch encoding scheme encodes an $n / 2$-dimensional complex input slot
vector into an $\(n - 1\)$-degree (or lesser degree) real-number
polynomial, and the decoding process is a reverse of this.

In addition, remember that in BFV, we updated $W$ and $W^T$ to
\$\\hathat W\$ and \$\\hathat W^\*\$
(Summary~@subsubsec:bfv-rotation-summary in
#link(<subsubsec:bfv-rotation-summary>)[\[subsubsec:bfv-rotation-summary\]])
to support homomorphic rotation of input vector slots. Likewise, the
CKKS batch encoding scheme uses \$\\hathat W\$ and \$\\hathat W^\*\$
instead of $W$ and $W^T$ in order to support homomorphic rotation.
Therefore, the CKKS batch encoding scheme's isomorphic mapping is
updated as follows:

$sigma_c : f\(X\)in bb(R)\[X\]\/\(X^n + 1\)arrow.r bold(\() f\(omega^(J\(0\))\)\,f\(omega^(J\(1\))\)\,f\(omega^(J\(2\))\)\,dots.h.c\,f\(omega^(J\(n / 2 - 1\))\)\,$

$f\(X\)in bb(R)\[X\]\/\(X^n + 1\)arrow.r bold(\()$
$dots.h.c\,f\(omega^(J_(*)\(0\))\)\,f\(omega^(J_(*)\(1\))\)\,f\(omega^(J_(*)\(2\))\)\,dots.h.c\,f\(omega^(J_(*)\(n / 2 - 1\))\)bold(\)) in bb(hat(C))^n upright(" ")\(arrow.r bb(C)^(n / 2)\)$

, where $J\(h\)= 5^h med mod med 2 n$, a rotation helper formula.

$$

The encoding schemes of BFV and CKKS have the following differences:

- #strong[Type of Input Slot Values:] BFV's input slot values are
  $n$-dimensional integers modulo $t$, which are encoded into
  $n$-dimensional polynomial coefficients (i.e., modulo-$t$ integers).
  On the other hand, CKKS's input slot values are $n / 2$-dimensional
  complex numbers, which are encoded into $n$-dimensional polynomial
  coefficients (i.e., real numbers).

- #strong[Type of Polynomial Coefficients:] BFV's encoded polynomial
  coefficients are integer moduli, whereas CKKS's encoded polynomial
  coefficients are real numbers.

- #strong[Scaling Factor:] Both BFV and CKKS scales their encoded
  polynomial coefficients $arrow(m)$ by $Delta$ to
  $ceil.l Delta dot.op arrow(m) floor.r$. BFV's suggested scaling factor
  is $Delta = floor.l q_0 / t floor.r$, but CKKS's scaling factor
  $Delta$ has no suggested formula because its polynomial coefficients
  are real numbers not bound by modulus, and thus it can be any value
  provided that the scaled coefficients do not overflow or underflow the
  range $\[1\,q_0 - 1\]$ (or $lr([- q_0 / 2 \, q_0 / 2))$).

- #strong[Encoding Precision:] In the case of BFV, during its decoding
  process, BFV's down-scaled polynomial coefficients
  $frac(Delta dot.op arrow(m), Delta)$ preserve the precision of input
  values . On the other hand, CKKS's down-scaled polynomial coefficients
  may lose their precision if their original input values have too many
  decimal digits so that the scaling factor cannot left-shift all of
  them to make them part of the integer domain, which means that some
  lower decimal digits of the input value may be rounded off, which
  loses precision of the original input. For example, suppose the
  polynomial coefficient $m_i = 1 / 3 = 0.33333 dots.h.c$, and the
  scaling factor $Delta = 100$. Then, the scaled coefficient
  $ceil.l Delta m_i floor.r = 33$, and down-scaling it gives
  $33 / 100 = 0.33$. Since $0.33 eq.not 0.33333 dots.h.c$, CKKS's
  encoding and decoding process does not always guarantee exact
  precision. Due to this encoding error, CKKS is called an
  #emph[approximate] encryption scheme. The impact of this encoding
  error can grow over homomorphic operations which increases the
  magnitude of error and the decoded result would gradually become more
  deviated from the expected exact value. One way to reduce CKKS's
  encoding error is to increase $Delta$, and thereby left-shift more
  decimal digits to make them part of the scaled integer digits.

$$

Note that the original decoding scheme for $arrow(v)_(')$ described in
Summary~@subsec:poly-vector-transformation-complex
(#link(<subsec:poly-vector-transformation-complex>)[\[subsec:poly-vector-transformation-complex\]])
was:

$arrow(v)_(') = bold(\() upright(" ") M\(omega\)\,upright(" ") M\(omega^3\)\,upright(" ") M\(omega^5\)\,dots.h.c\,M\(omega^(2 n - 3)\)\,upright(" ") M\(omega^(2 n - 1)\)bold(\))$

, which decodes to a Hermitian vector:

$arrow(v)_(') =\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\,overline(v)_(n / 2 - 1)\,dots.h.c\,overline(v)_1\,overline(v)_0\)$

, whose second-half elements are reverse-ordered conjugates of the
first-half elements.

$$

However, by replacing $W$ and $W^T$ with \$\\hathat W\$ and
\$\\hathat W^\*\$, we changed the above decoding scheme to the following
that supports homomorphic rotation:

$arrow(v)_(') = bold(\() upright(" ") M\(omega^(J\(0\))\)\,upright(" ") M\(omega^(J\(1\))\)\,upright(" ") M\(omega^(J\(2\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)\,upright(" ") M\(omega^(J_(*)\(0\))\)\,upright(" ") M\(omega^(J_(*)\(1\))\)\,dots.h.c\,M\(omega^(J_(*)\(n / 2 - 1\))\)upright(" ") bold(\))$

\$\\textcolor{white}{\\vec{v}\_{\'}} =  \\bm{(} \\text{ } 
M(\\omega^{J(0)}), \\text{ } M(\\omega^{J(1)}), \\text{ } M(\\omega^{J(2)}), \\cdots,  M(\\omega^{J(\\frac{n}{2}-1)}), \\text{ } M(\\overline\\omega^{J(0)}), \\text{ } M(\\overline\\omega^{J(1)}), \\cdots,  M(\\overline\\omega^{J(\\frac{n}{2}-1)}) \\text{ } \\bm{)}\$

$gt.tri$ because
$omega^(- 1) =\(e^(frac(i pi, n))\)^(- 1)= e^(frac(- i pi, n)) = overline(omega)$,
given $J\(h\)= 5^h med mod med 2 n$, and
$J_(*)\(h\)= - 5^h med mod med 2 n$

, which decodes to a #emph[forward-ordered] (not reverse-ordered)
Hermitian vector as follows:

$arrow(v)_(') =\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\,overline(v)_0\,overline(v)_1\,dots.h.c\,overline(v)_(n / 2 - 1)\)$

, whose second-half elements are conjugates of the first-half elements
with the same order. Upon homomorphic rotation (which will be explained
in #link(<subsec:ckks-rotation>)[0.9]), just like in BFV's homomorphic
rotation, the first-half elements and the second-half elements of
$arrow(v)_(')$ rotate within their own group in a wrapping manner.

We summarize CKKS's encoding and decoding procedure as follows, which is
similar to BFV's encoding and decoding procedure (described in
Summary~@subsubsec:bfv-encoding-summary in
#link(<subsubsec:bfv-encoding-summary>)[\[subsubsec:bfv-encoding-summary\]]):

#block[
#strong[#underline[Input]:] An $n / 2$-dimensional complex vector
$arrow(v) =\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\)in bb(C)^(n / 2)$

#horizontalrule

#strong[#underline[Encoding]:]

$$

+ Convert (i.e., isomorphically transform) $arrow(v)$ into an
  $n$-dimensional #emph[forward-ordered] Hermitian vector $arrow(v)_(')$
  as follows:

  $arrow(v)_(') =\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\,overline(v)_0\,overline(v)_1\,dots.h.c\,overline(v)_(n / 2 - 1)\)in bb(hat(C))^n$

+ Convert $arrow(v)_(')$ into a real number vector $arrow(m)$ by
  applying the transformation
  \$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$

  , where \$\\hathat{W}\$ is a basis of the $n$-dimensional vector space
  crafted as follows:

  $$

  $gt.tri$ where $omega = e^(i pi\/n) = cos (pi / n) + i sin (pi / n)$,
  $J\(h\)= 5^h med mod med 2 n$, and $J_(*)\(h\)= - 5^h med mod med 2 n$

  $= mat(delim: "[", 1, 1, dots.h.c, 1, 1, 1, dots.h.c, 1; \(omega^(J\(n / 2 - 1\))\), \(omega^(J\(n / 2 - 2\))\), dots.h.c, \(omega^(J\(0\))\), \(overline(omega)^(J\(n / 2 - 1\))\), \(overline(omega)^(J\(n / 2 - 2\))\), dots.h.c, \(overline(omega)^(J\(0\))\); \(omega^(J\(n / 2 - 1\))\)^2, \(omega^(J\(n / 2 - 2\))\)^2, dots.h.c, \(omega^(J\(0\))\)^2, \(overline(omega)^(J\(n / 2 - 1\))\)^2, \(overline(omega)^(J\(n / 2 - 2\))\)^2, dots.h.c, \(overline(omega)^(J\(0\))\)^2; dots.v, dots.v, dots.down, dots.v, dots.v, dots.down, dots.v, dots.v; \(omega^(J\(n / 2 - 1\))\)^(n - 1), \(omega^(J\(n / 2 - 2\))\)^(n - 1), dots.h.c, \(omega^(J\(0\))\)^(n - 1), \(overline(omega)^(J\(n / 2 - 1\))\)^(n - 1), \(overline(omega)^(J\(n / 2 - 2\))\)^(n - 1), dots.v, \(overline(omega)^(J\(0\))\)^(n - 1))$

  $gt.tri$ because
  $omega^(- 1) = e^(frac(- i pi, n)) = overline(e^(frac(i pi, n))) = overline(omega)$

  $$

+ Convert $arrow(m)$ into a scaled integer vector
  $ceil.l Delta arrow(m) floor.r approx Delta arrow(m)$, where $Delta$
  is a scaling factor bigger than 1 such that $Delta m_i$ never
  overflows or underflows $q_0$ (i.e., $0 lt.eq Delta m_i < q_0$ or
  $- q_0 / 2 lt.eq Delta m_i < q_0 / 2$) in all cases, even across all
  homomorphic operations. The finally encoded plaintext polynomial is
  $Delta M = sum_(i = 0)^(n - 1) ceil.l Delta m_i floor.r X^i upright(" ") in bb(Z)_q\[X\]\/\(X^n + 1\)$.
  The rounding process of $ceil.l Delta arrow(m) floor.r$ during the
  encoding process causes an encoding error, which makes CKKS an
  approximate encryption scheme.

#horizontalrule

#strong[#underline[Decoding]:] From the plaintext polynomial
$Delta M = sum_(i = 0)^(n - 1) Delta m_i X^i$, recover
$arrow(m) = frac(Delta arrow(m), Delta)$. Then, compute
\$\\vec{v}\_{\'} = \\hathat W^\* \\cdot \\vec{m}\$, where:

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

$= mat(delim: "[", 1, \(omega^(J\(0\))\), \(omega^(J\(0\))\)^2, dots.h.c, \(omega^(J\(0\))\)^(n - 1); 1, \(omega^(J\(1\))\), \(omega^(J\(1\))\)^2, dots.h.c, \(omega^(J\(1\))\)^(n - 1); 1, \(omega^(J\(2\))\), \(omega^(J\(2\))\)^2, dots.h.c, \(omega^(J\(2\))\)^(n - 1); dots.v, dots.v, dots.v, dots.down, dots.v; 1, \(omega^(J\(n / 2 - 1\))\), \(omega^(J\(n / 2 - 1\))\)^2, dots.h.c, \(omega^(J\(n / 2 - 1\))\)^(n - 1); 1, \(overline(omega)^(J\(0\))\), \(overline(omega)^(J\(0\))\)^2, dots.h.c, \(overline(omega)^(J\(0\))\)^(n - 1); 1, \(overline(omega)^(J\(1\))\), \(overline(omega)^(J\(1\))\)^2, dots.h.c, \(overline(omega)^(J\(1\))\)^(n - 1); 1, \(overline(omega)^(J\(2\))\), \(overline(omega)^(J\(2\))\)^2, dots.h.c, \(overline(omega)^(J\(2\))\)^(n - 1); dots.v, dots.v, dots.v, dots.down, dots.v; 1, \(overline(omega)^(J\(n / 2 - 1\))\), \(overline(omega)^(J\(n / 2 - 1\))\)^2, dots.h.c, \(overline(omega)^(J\(n / 2 - 1\))\)^(n - 1); #none)$

$$

$$

, and extract only the first $n / 2$ elements in the
#emph[forward-ordered] Hermitian vector $arrow(v)_(')$ to recover the
input vector $arrow(v)$.

]
In the encoding process, when we convert
$arrow(v)_(') arrow.r arrow(m) arrow.r Delta arrow(m)$, we multiply
$arrow(v)_(')$ by \$\\hathat{W}\$ which contains complex numbers with
infinite decimals (e.g., $sqrt(2)$) coming from Euler's formula, which
we should round to the nearest integer by computing
$ceil.l Delta m floor.r$ (which we will denote as $Delta m$ throughout
this section for simplicity) and thus we lose some precision. This
implies that if we later decode $Delta arrow(m)$ into $arrow(v)_(' d)$,
this value would be slightly different from the original input vector
$arrow(v)_(')$. As CKKS's encoding scheme is subject to such a small
rounding error, the decryption does not perfectly match the original
input vector. Such errors also propagate across homomorphic
computations, because those computations are done based on approximately
encoded plaintext $ceil.l Delta arrow(m) floor.r$. As these errors are
caused by throwing away the infinitely long decimal digits, they can be
corrected during the decoding process only if we use an infinitely big
scaling factor $Delta$, which is impossible because $Delta m_i$ should
not overflow the ciphertext modulus $q_0$ of the lowest multiplicative
level. Due to this limitation, CKKS is considered an #emph[approximate]
homomorphic encryption.

=== Example
<subsubsec:ckks-encoding-ex>
Suppose our input complex vector's dimension $n / 2 = 2$, the bounding
polynomial degree $n$ = 4, and the scaling factor $Delta = 1024$.

Our basis of the $n$-dimensional vector space

\$\\hathat{W}= \\begin{bmatrix}
1 & 1 & 1 & 1\\\\
\\omega^{J(1)} & \\omega^{J(0)} & \\overline{\\omega}^{J(1)} & \\overline{\\omega}^{J(0)}\\\\
(\\omega^{J(1)})^2 & ({\\omega^{J(0)}})^2 & (\\overline{\\omega}^{J(1)})^2 & (\\overline{\\omega}^{J(0)})^2\\\\
(\\omega^{J(1)})^3 & (\\omega^{J(0)})^3 & (\\overline{\\omega}^{J(1)})^3 & (\\overline{\\omega}^{J(0)})^3\\\\
\\end{bmatrix}\$
$= mat(delim: "[", 1, 1, 1, 1; omega^5, omega, overline(omega)^5, overline(omega); omega^2, omega^2, overline(omega^2), overline(omega)^2; omega^7, omega^3, overline(omega)^7, overline(omega)^3; #none)$

, where $omega = e^(i pi\/n) = cos (pi / n) + i sin (pi / n)$

$$

Given this setup, suppose we have the input complex vector
$arrow(v) =\(1.1 + 4.3 i\,upright(" ") 3.5 - 1.4 i\)$ to encode.

$$

First, construct the forward-ordered Hermitian vector
$arrow(v)_(') =\(1.1 + 4.3 i\,upright(" ") 3.5 - 1.4 i\,upright(" ") 1.1 - 4.3 i\,upright(" ") 3.5 + 1.4 i\)$.

$$

Next, convert the complex vector $arrow(v)_(')$ into a real number
vector $arrow(m)$ by applying the transformation:

\$\\vec{m} = \\dfrac{\\hathat{W} \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n} = \\dfrac{1}{4} \\cdot \\begin{bmatrix}
1 & 1 & 1 & 1\\\\
\\omega^5 & \\omega & \\overline{\\omega}^5 & \\overline{\\omega}\\\\
\\omega^2 & \\omega^2 & \\overline{\\omega}^2 & \\overline{\\omega}^2\\\\
\\omega^7 & \\omega^3 & \\overline{\\omega}^7 & \\overline{\\omega}^3\\\\
\\end{bmatrix} \\cdot 
\\begin{bmatrix}
0 & 0 & 0 & 1 \\\\
0 & 0 & 1 & 0 \\\\
0 & 1 & 0 & 0 \\\\
1 & 0 & 0 & 0 
\\end{bmatrix}
\\cdot
\\begin{bmatrix} 1.1 + 4.3i\\\\3.5 - 1.4i\\\\1.1 - 4.3i\\\\3.5 + 1.4i \\end{bmatrix}\$

$$

$= frac(W dot.op I_n^R dot.op arrow(v)_('), n) = 1 / 4 dot.op mat(delim: "[", 1, 1, 1, 1; overline(omega), overline(omega)^5, omega, omega^5; overline(omega)^2, overline(omega)^2, omega^2, omega^2; overline(omega)^3, overline(omega)^7, omega^3, omega^7; #none) dot.op mat(delim: "[", 1.1 + 4.3 i; 3.5 - 1.4 i; 1.1 - 4.3 i; 3.5 + 1.4 i)$

$$

$= 1 / 4 dot.op mat(delim: "[", \(1.1 + 4.3 i\)+\(3.5 - 1.4 i\)+\(1.1 - 4.3 i\)+\(3.5 + 1.4 i\); \(1.1 + 4.3 i\)overline(omega) +\(3.5 - 1.4 i\)overline(omega)^5 +\(1.1 - 4.3 i\)omega +\(3.5 + 1.4 i\)omega^5; \(1.1 + 4.3 i\)overline(omega^2) +\(3.5 - 1.4 i\)overline(omega^2) +\(1.1 - 4.3 i\)omega^2 +\(3.5 + 1.4 i\)omega^2; \(1.1 + 4.3 i\)overline(omega)^3 +\(3.5 - 1.4 i\)overline(omega)^7 +\(1.1 - 4.3 i\)omega^3 +\(3.5 + 1.4 i\)omega^7; #none)$

$$

$= 1 / 4 dot.op mat(delim: "[", \(1.1 + 4.3 i\)+\(3.5 - 1.4 i\)+\(1.1 - 4.3 i\)+\(3.5 + 1.4 i\); \(1.1 + 4.3 i\)+\(3.5 - 1.4 i\)overline(omega)^5 +\(1.1 - 4.3 i\)omega +\(3.5 + 1.4 i\)omega^5; \(1.1 + 4.3 i\)overline(omega^2) +\(3.5 - 1.4 i\)overline(omega^2) +\(1.1 - 4.3 i\)omega^2 +\(3.5 + 1.4 i\)omega^2; \(1.1 + 4.3 i\)overline(omega)^3 +\(3.5 - 1.4 i\)overline(omega)^7 +\(1.1 - 4.3 i\)omega^3 +\(3.5 + 1.4 i\)omega^7; #none)$

$$

$= 1 / 4 dot.op mat(delim: "[", 9.2; 1.1\(overline(omega) + omega\)+ 4.3 i\(overline(omega) - omega\)+ 3.5\(overline(omega)^5 + omega^5\)- 1.4 i\(overline(omega)^5 - omega^5\); 1.1\(overline(omega)^2 + omega^2\)+ 4.3 i\(overline(omega)^2 - omega^2\)+ 3.5\(overline(omega)^2 + omega^2\)- 1.4 i\(overline(omega)^2 - omega^2\); 1.1\(overline(omega)^3 + omega^3\)+ 4.3 i\(overline(omega)^3 - omega^3\)+ 3.5\(overline(omega)^7 + omega^7\)- 1.4 i\(overline(omega)^7 - omega^7\); #none)$

$$

$= 1 / 4 dot.op mat(delim: "[", 9.2; 1.1 (2 cos pi / 4) - 4.3 i (2 i sin pi / 4) + 3.5 (2 cos frac(5 pi, 4)) + 1.4 i (2 i sin frac(5 pi, 4)); 1.1 (2 cos pi / 2) - 4.3 i (2 i sin pi / 2) + 3.5 (2 cos pi / 2) + 1.4 i (2 i sin pi / 2); 1.1 (2 cos frac(3 pi, 4)) - 4.3 i (2 i sin frac(3 pi, 4)) + 3.5 (2 cos frac(7 pi, 4)) + 1.4 i (2 i sin frac(7 pi, 4)); #none)$

$$

$= 1 / 4 dot.op mat(delim: "[", 9.2; 1.1 (2 sqrt(2) / 2) + 4.3 (2 sqrt(2) / 2) + 3.5 (- 2 sqrt(2) / 2) - 1.4 (- 2 sqrt(2) / 2); 1.1\(2 dot.op 0\)+ 4.3\(2 dot.op 1\)+ 3.5\(2 dot.op 0\)- 1.4\(2 dot.op 1\); 1.1 (2 - sqrt(2) / 2) + 4.3 (2 sqrt(2) / 2) + 3.5 (2 sqrt(2) / 2) - 1.4 (- 2 sqrt(2) / 2); #none)$

$$

$= 0.25 dot.op mat(delim: "[", 9.2; 1.1 sqrt(2) + 4.3 sqrt(2) - 3.5 sqrt(2) + 1.4 sqrt(2); 1.1\(0\)+ 4.3\(2\)- 3.5\(0\)- 1.4\(2\); - 1.1 sqrt(2) + 4.3 sqrt(2) + 3.5 sqrt(2) + 1.4 sqrt(2); #none) = mat(delim: "[", 2.3; 0.825 sqrt(2); 1.45; 2.025 sqrt(2); #none) approx\(2.3\,upright(" ") 1.1657\,upright(" ") 1.45\,upright(" ") 2.8638\)$

$$

Convert the real number vector $arrow(m)$ into a scaled integer vector
$Delta arrow(m)$ by $Delta$-scaling and rounding as follows:

$Delta arrow(m) approx ceil.l Delta arrow(m) floor.r = ceil.l 1024 dot.op\(2.3\,upright(" ") 1.1657\,upright(" ") 1.45\,upright(" ") 2.8638\)floor.r =\(2355\,upright(" ") 1195\,upright(" ") 1485\,upright(" ") 2933\)$

$$

Finally, $arrow(v) =\(1.1 + 4.3 i\,upright(" ") 3.5 - 1.4 i\)$ has been
encoded into the plaintext polynomial $M\(X\)$ as follows:

$Delta M\(X\)= 2355 + 1195 X + 1485 X^2 + 2933 X^3 in cal(R)_(chevron.l 4 chevron.r)$

$$

To decode $arrow(m)$, we compute:

$arrow(v)_(') = frac(W^T dot.op Delta arrow(m), Delta) = mat(delim: "[", 1\,omega\,omega^2\,omega^3; 1\,omega^3\,omega^6\,omega; 1\,overline(omega)\,overline(omega^2)\,overline(omega^3); 1\,overline(omega^3)\,overline(omega^6)\,overline(omega))$
$dot.op mat(delim: "[", 2355; 1195; 1485; 2933) dot.op 1 / 1024$

$= mat(delim: "[", 1\,sqrt(2) / 2 + frac(i sqrt(2), 2)\,i\,- sqrt(2) / 2 + frac(i sqrt(2), 2); 1\,- sqrt(2) / 2 + frac(i sqrt(2), 2)\,- i\,sqrt(2) / 2 + frac(i sqrt(2), 2); 1\,sqrt(2) / 2 - frac(i sqrt(2), 2)\,- i\,- sqrt(2) / 2 - frac(i sqrt(2), 2); 1\,- sqrt(2) / 2 - frac(i sqrt(2), 2)\,i\,sqrt(2) / 2 - frac(i sqrt(2), 2))$
$dot.op mat(delim: "[", 2.2998046875; 1.1669921875; 1.4501953125; 2.8642578125)$

$$

$approx\(1.0997 + 4.3007 i\,upright(" ") 3.5000 - 1.4003 i\,upright(" ") 1.0997 - 4.3007 i\,upright(" ") 3.5000 + 1.4003 i\)$

$$

Extract the first $n / 2 = 2$ elements in the Hermitian vector
$arrow(v)_(')$ to recover the input vector:

$\(1.0997 + 4.3007 i\,upright(" ") 3.5000 - 1.4003 i\)$

$approx\(1.1 + 4.3 i\,upright(" ") 3.5 - 1.4 i\)= arrow(v)$ $gt.tri$ The
original input vector

$$

Because of the rounding drifts for converting square roots into
integers, the decoded value is slightly different from the original
input complex values. This is why CKKS is called an approximate
homomorphic encryption.

$$

Examples of CKKS encoding can be executed by running
#link("https://github.com/fhetextbook/fhe-textbook/blob/main/source%20code/ckks.py")[#underline[this Python script]].

== Encryption and Decryption
<subsec:ckks-enc-dec>
CKKS's encryption and decryption schemes are similar to BFV's encryption
and decryption schemes (Summary~@subsec:bfv-enc-dec in
#link(<subsec:bfv-enc-dec>)[\[subsec:bfv-enc-dec\]]).

#block[
#strong[#underline[Initial Setup]:]

$Delta upright(" is a plaintext scaling factor for polynomial encoding")\,upright(" ") S arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)$.
The coefficients of the polynomial $S$ are ternary (i.e.,
${ - 1\,0\,1 }$).

#horizontalrule

#strong[#underline[Encryption Input]:]
$Delta M in cal(R)_(chevron.l n\,q chevron.r)$,
$A_i arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)$,
$E arrow.l^(xi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

+ Compute
  $B = - A dot.op S + Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ $sans("RLWE")_(S\,sigma)\(Delta M + E\)=\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

#horizontalrule

#strong[#underline[Decryption Input]:]
$sans("ct") =\(A\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^2$

$sans("RLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= ⌈frac(B + A dot.op S med mod med q, Delta)⌋_(1 / Delta) = ⌈frac(Delta M + E, Delta)⌋_(1 / Delta) approx M$

$gt.tri$ $ceil.l x floor.r_k$ means rounding $x$ to the nearest multiple
of $k$

$$

#strong[#underline[Property of Approximate Decryption]:]

- Unlike BFV, CKKS's each plaintext value $m_i$ is originally not in a
  modulus ring, but a real number with infinite decimal digits.
  Therefore, it's not possible to exactly decrypt the ciphertext to the
  same original value.

- If each coefficient of the noise $E$ is smaller than $Delta / 2$, then
  the decryption ensures the precision level with the multiple of
  $1 / Delta$.

]
In this section, we will often write
$sans("RLWE")_(S\,sigma)\(Delta M + E\)$ as
$sans("RLWE")_(S\,sigma)\(Delta M\)$ for simplicity, because
$sans("RLWE")_(S\,sigma)\(Delta M + E\)approx sans("RLWE")_(S\,sigma)\(Delta M\)$
(i.e., they decrypt to approximately the same message). Even in the case
that we write $sans("RLWE")_(S\,sigma)\(Delta M\)$ instead of
$sans("RLWE")_(S\,sigma)\(Delta M + E\)$, you should assume this as an
encryption of $Delta M + E$ (i.e., the noise is included inside the
scaled message).

== Ciphertext-to-Ciphertext Addition
<subsec:ckks-add-cipher>
CKKS's ciphertext-to-ciphertext addition scheme is exactly the same as
BFV's ciphertext-to-ciphertext addition scheme
(Summary~@subsec:bfv-add-cipher in
#link(<subsec:bfv-add-cipher>)[\[subsec:bfv-add-cipher\]]).

#block[
$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r)\)+ sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r)\)$

$=\(A^(chevron.l 1 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r)\)+\(A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 2 chevron.r)\)$

$=\(A^(chevron.l 1 chevron.r) + A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r) + B^(chevron.l 2 chevron.r)\)$

$= sans("RLWE")_(S\,sigma)\(Delta\(M^(chevron.l 1 chevron.r) + M^(chevron.l 2 chevron.r)\)\)$

]
== Ciphertext-to-Plaintext Addition
<subsec:ckks-add-plain>
CKKS's ciphertext-to-plaintext addition scheme is exactly the same as
BFV's ciphertext-to-plaintext addition scheme
(Summary~@subsec:bfv-add-plain in
#link(<subsec:bfv-add-plain>)[\[subsec:bfv-add-plain\]]).

#block[
$sans("RLWE")_(S\,sigma)\(Delta M\)+ Delta Lambda$

$=\(A\,upright(" ") B\)+ Delta Lambda$

$=\(A\,upright(" ") B + Delta dot.op Lambda\)$

$= sans("RLWE")_(S\,sigma)\(Delta\(M + Lambda\)\)$

]
== Ciphertext-to-Ciphertext Multiplication
<subsec:ckks-mult-cipher>
CKKS's ciphertext-to-ciphertext multiplication is partially different
from that of BFV. In the case of BFV, its ciphertext modulus remains the
same after each multiplication. On the other hand, CKKS reduces its
ciphertext modulus size by 1 after each multiplication (which is
equivalent to reducing its multiplicative level by 1). When the level
reaches 0, no further multiplication can be performed (unless we
bootstrap the modulus). This difference arises because the two schemes
use different strategies in handling their plaintext scaling factors--
BFV's $Delta = ⌊q / t⌋$, whereas CKKS's $Delta$ can be any value such
that $Delta lt.double q_0$, where $q_0$ is the lowest multiplicative
level's ciphertext modulus. However, both schemes use a similar
relinearization technique.

To make it easy to understand, we will explain CKKS's
ciphertext-to-ciphertext multiplication based on this alternate version
of RLWE (Theorem~@subsec:glwe-alternative in
#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]]), where
the sign of the $A S$ term is flipped in the encryption and decryption
formulas.

Suppose we have the following two (CKKS) RLWE ciphertexts:

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r)\)=\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)$,
where
$B^(chevron.l 1 chevron.r) = - A^(chevron.l 1 chevron.r) dot.op S + Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)$

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r)\)=\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)$,
where
$B^(chevron.l 2 chevron.r) = - A^(chevron.l 2 chevron.r) dot.op S + Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)$

$$

RLWE ciphertext-to-ciphertext multiplication comprises the following 2
steps:

$$

+ Find a formula for the #emph[synthetic] ciphertext that is equivalent
  to
  $sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
  by leveraging the following congruence relation:

  $sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)= sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r)\)dot.op sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 2 chevron.r)\)$

  $$

+ Rescale
  $sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
  to
  $sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$.

$$

We will explain each of these steps.

=== Synthetic Ciphertext Derivation
<subsubsec:ckks-mult-cipher-relation>
The 1st step of RLWE ciphertext-ciphertext multiplication is to find a
way to express the following congruence relation:

$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)= sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r)\)dot.op sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 2 chevron.r)\)$

$$

in terms of our following known values:
$A^(chevron.l 1 chevron.r)\,upright(" ") B^(chevron.l 1 chevron.r)\,upright(" ") A^(chevron.l 2 chevron.r)\,upright(" ") B^(chevron.l 2 chevron.r)\,upright(" ") S$.
First, notice that the following is true:

$$

$sans("RLWE")_(S\,sigma)^(- 1)\(upright(" ") sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)sans(" ")\)= sans("RLWE")_(S\,sigma)^(- 1)\(upright(" ") sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r)\)upright(" ")\)dot.op sans("RLWE")_(S\,sigma)^(- 1)\(upright(" ") sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 2 chevron.r)\)upright(" ")\)$

$$

, because encrypting and decrypting the multiplication of two plaintexts
should give the same result as decrypting two encrypted plaintexts and
then multiplying them. As the encryption and decryption functions cancel
out, we get the following:

$Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r) approx\(Delta dot.op M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)dot.op\(Delta dot.op M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)$

$= sans("RLWE")_(S\,sigma)^(- 1)\(upright(" ") sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r)\)upright(" ")\)dot.op sans("RLWE")_(S\,sigma)^(- 1)\(upright(" ") sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 2 chevron.r)\)upright(" ")\)$

$gt.tri$ where
$\(Delta dot.op M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)dot.op\(Delta dot.op M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)= Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r) + Delta dot.op M^(chevron.l 1 chevron.r) dot.op E^(chevron.l 2 chevron.r) + Delta dot.op M^(chevron.l 2 chevron.r) dot.op E^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) dot.op E^(chevron.l 2 chevron.r)$,
where $E^(chevron.l 1 chevron.r) dot.op E^(chevron.l 2 chevron.r)$ is
small enough to be eliminated upon decryption, and
$Delta dot.op M^(chevron.l 1 chevron.r) dot.op E^(chevron.l 2 chevron.r)$
and
$Delta dot.op M^(chevron.l 2 chevron.r) dot.op E^(chevron.l 1 chevron.r)$
will be scaled down to
$M^(chevron.l 1 chevron.r) dot.op E^(chevron.l 2 chevron.r)$ and
$M^(chevron.l 2 chevron.r) dot.op E^(chevron.l 1 chevron.r)$ upon
modulus switch later, becoming sufficiently small to be eliminated
during decryption

$$

Remember from
#link(<subsec:glwe-alternative>)[\[subsec:glwe-alternative\]] the
following:

$sans("RLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") C =\(A\,B\)upright(" ") bold(\)) = Delta M + E = B + A dot.op S$

$$

Thus, the above congruence relation can be rewritten as follows:

$$

$Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)$
$approx\(Delta dot.op M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)\)dot.op\(Delta dot.op M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)\)$

$=\(B^(chevron.l 1 chevron.r) + A^(chevron.l 1 chevron.r) dot.op S - E^(chevron.l 1 chevron.r)\)dot.op\(B^(chevron.l 2 chevron.r) + A^(chevron.l 2 chevron.r) dot.op S - E^(chevron.l 2 chevron.r)\)$

$approx\(B^(chevron.l 1 chevron.r) + A^(chevron.l 1 chevron.r) dot.op S\)dot.op\(B^(chevron.l 2 chevron.r) + A^(chevron.l 2 chevron.r) dot.op S\)$

$= B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r) +\(B^(chevron.l 2 chevron.r) A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)\)dot.op S +\(A^(chevron.l 1 chevron.r) S\)dot.op\(A^(chevron.l 2 chevron.r) S\)$

$$

$= underbrace(B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r), D_0) + underbrace(\(B^(chevron.l 2 chevron.r) A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)\), D_1) dot.op S + underbrace(\(A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)\), D_2) dot.op underbrace(\(S dot.op S\), S^2)$

$= D_0 + D_1 dot.op S + D_2 dot.op S^2$

$$

$= sans("RLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") C_alpha =\(D_1\,D_0\)upright(" ") bold(\)) + D_2 dot.op S^2$
\# since
$D_0 + D_1 dot.op S = sans("RLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") C_alpha =\(D_1\,D_0\)upright(" ") bold(\))$

$$

In the final step above, we converted $D_0 + D_1 dot.op S$ into
$sans("RLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") C_alpha =\(D_1\,D_0\)upright(" ") bold(\))$,
where $C_alpha$ is the synthetic RLWE ciphertext $\(D_1\,D_0\)$
encrypted by $S$. Similarly, our next task is to derive a synthetic RLWE
ciphertext $C_beta$ such that
$D_2 dot.op S^2 = sans("RLWE")_(S\,sigma)^(- 1)\(C_beta\)$. The reason
why we want this synthetic ciphertext is that we do not want the square
of $S$ (i.e., $S^2$), because if we continue to keep $S^2$, then over
more consequent ciphertext-to-ciphertext multiplications, this term will
aggregate exponentially growing bigger exponents such as
$S^4\,S^8\,dots.h.c . . .$, which would exponentially increase the
computational overhead of decryption. In the next subsection, we will
explain how to derive the synthetic RLWE ciphertext $C_beta$ such that
$D_2 dot.op S^2 = sans("RLWE")_(S\,sigma)^(- 1)\(C_beta\)$.

=== Relinearization Method 1 -- Ciphertext Decomposition
<subsubsec:relinearization-gadget-decomposition>
As explained in BFV's ciphertext-to-ciphertext multiplication
(#link(<subsubsec:bfv-mult-cipher-relinearization>)[\[subsubsec:bfv-mult-cipher-relinearization\]]),
relinearization is a process of converting the polynomial triplet
$\(D_0\,D_1\,D_2\)in cal(R)_(chevron.l n\,q chevron.r)^3$, which can be
decrypted into $Delta M$ using $S$ and $S^2$ as keys, into the
polynomial pairs
$\(C_alpha\,C_beta\)in cal(R)_(chevron.l n\,q chevron.r)^2$, which can
be decrypted into the same $Delta M$ by using $S$ as key. In the
previous subsection, we learned that we can convert $D_0$ and $D_1$ into
$C_alpha$ simply by viewing $D_0$ and $D_1$ as $C_alpha =\(D_1\,D_0\)$.
The process of converting $D_2$ into $C_beta$ is exactly the same as the
technique explained in
#link(<subsubsec:bfv-mult-cipher-relinearization>)[\[subsubsec:bfv-mult-cipher-relinearization\]],
which applies the gadget decomposition
(#link(<subsec:gadget-decomposition>)[\[subsec:gadget-decomposition\]])
on $D_2$ and computes an inner product with the RLev encryption
(#link(<sec:glev>)[\[sec:glev\]]) of $S^2$. Specifically, we compute the
following:

$sans("RLWE")_(S\,sigma)^(- 1)\(C_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r) bold(\))$
$gt.tri$ the scaling factors of
$sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)$ are all 1

$= D_(2\,1)\(E'_1 + S^2 q / beta\)+ D_(2\,2)\(E'_2 + S^2 q / beta^2\)+ dots.h.c + D_(2\,l)\(E'_l + S^2 q / beta^l\)$

$= sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)+ S^2 dot.op\(D_(2\,1) q / beta + D_(2\,2) q / beta^2 + dots.h.c + D_(2\,l) q / beta^l\)$

\=============

$= D_(2\,1)\(E'_1 + S^2 beta^0\)+ D_(2\,2)\(E'_2 + S^2 beta^1\)+ dots.h.c + D_(2\,l)\(E'_l + S^2 beta^(l - 1)\)$

$= sum_(i = 1)^l\(E'_i dot.op D_(2\,i)\)+ S^2 dot.op\(D_(2\,1) beta^0 + D_(2\,2) beta^1 + dots.h.c + D_(2\,l) beta^(l - 1)\)$

\=============

$= sum_(i = 1)^l epsilon.alt_i + D_2 dot.op S^2$ \# where
$epsilon.alt_i = E'_i dot.op D_(2\,i)$

$approx D_2 dot.op S^2$ \# because
$sum_(i = 1)^l epsilon.alt_i lt.double D_2 dot.op E''$ (where $E''$ is
the noise embedded in $sans("RLWE")_(S\,sigma) bold(\() S^2 bold(\))$

$$

Finally, we get the following relation:

$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)approx C_alpha + C_beta$
, where
$C_alpha =\(D_1\,D_0\)\,upright(" ") C_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$

$$

In the next subsection, we introduce another (older) relinearization
technique.

=== Relinearization Method 2 -- Ciphertext Modulus Switch
<subsubsec:relinearization-modulus-switch>
At the setup stage of the RLWE scheme, we craft a special pair of
polynomials modulo $q$ as follows:

$A' arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$

$E' arrow.l^sigma cal(R)_(chevron.l n\,q chevron.r)$

$italic(e v k) =\(A'\,upright(" ") - A' dot.op S + E' + S^2\)in cal(R)_(chevron.l n\,q chevron.r)^2$

$italic(e v k)$ is called an evaluation key, which is essentially a RLWE
ciphertext of $S^2$ encrypted by the secret key $S$ without any scaling
factor $Delta$. Remember that our goal is to find a synthetic RLWE
ciphertext $C_beta$ such that decrypting it gives us $D_2 dot.op S^2$,
that is: $sans("RLWE")_(S\,sigma)^(- 1)\(C_beta\)= D_2 dot.op S^2$.
Let's suppose that $C_beta = D_2 dot.op italic(e v k)$. Then, decrypting
$C_beta$ gives us the following:

$sans("RLWE")_(S\,sigma)^(- 1) bold(\() C_beta =\(D_2 dot.op italic(e v k)\)bold(\)) = sans("RLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") C =\(D_2 A'\,upright(" ") - D_2 A' dot.op S + D_2 E' + D_2 dot.op S^2\)upright(" ") bold(\))$

$= D_2 A' dot.op S - D_2 A' dot.op S + D_2 E' + D_2 dot.op S^2$

$= D_2 E' + D_2 dot.op S^2$

$$

But unfortunately, $D_2 E' + D_2 dot.op S^2 approx.not D_2 dot.op S^2$,
because $D_2 E' approx.not 0$ (as $D_2$ is not necessarily a small
number).This is because
$D_2 = A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)$,
$D_2 E'$ can be any arbitrary value between $\[0\,q\)$.

To solve the above problem, we modify the evaluation key as a set of
polynomials in big modulo $g$ as follows:

$A' arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$

$E' arrow.l^sigma cal(R)_(chevron.l n\,q chevron.r)$

$g arrow.l^(\$) bb(Z)_(q_L^2)$ $gt.tri$ where $g$ is some large integer
power of 2, $q_L$ is the largest modulo before any relinearization

$italic(e v k_g) =\(A'\,- A' dot.op S + E' + g S^2\)in cal(R)_(chevron.l n\,g q chevron.r)^2$

$$

$italic(e v k_g)$ is essentially an RLWE ciphertext of $g S^2$ encrypted
by $S$. We can derive the following:

$italic(e v k_g) =\(A'\,- A' dot.op S + E' + g S^2\)in cal(R)_(chevron.l n\,g q chevron.r)^2$

$=\(A' upright(" mod ") g q\,upright(" ") - A' dot.op S + E' + g S^2 upright(" mod ") g q\)$

$=\(A' + k_2 g q\,upright(" ") - A' dot.op S + E' + g S^2 + k_1 g q\)$
(for some integers $k_1\,k_2$)

$$

Note that
$D_2 = A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r) in cal(R)_(chevron.l n\,q chevron.r)$

$= D_2 upright(" mod ") q$

$= D_2 + k_3 q$ (for some integer $k_3$)

$$

Now, let's multiply $D_2$ to each component of $italic(e v k_g)$ as
follows:

$\(A' + k_2 g q\,upright(" ") - A' dot.op S + E' + g S^2 + k_1 g q\)dot.op\(D_2 + k_3 q\)$

$=\(upright(" ") D_2 A' + D_2 k_2 g q + k_3 q A' + k_3 q k_2 g q\,$

$- D_2 A' dot.op S + D_2 E' + g D_2 dot.op S^2 + D_2 k_1 g q - k_3 q A' dot.op S + k_3 q E' + k_3 q g S^2 + k_3 q k_1 g q\)$

$$

Now, we switch the modulus of this RLWE ciphertext from $g q arrow.r q$
based on the technique in
#link(<subsec:modulus-switch-glwe>)[\[subsec:modulus-switch-glwe\]]:

$#scale(x: 300%, y: 300%)[\(] #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 k_2 g q, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q k_2 g q, g) #scale(x: 300%, y: 300%)[floor.r]\,upright(" ") upright(" ") - #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(g D_2 dot.op S^2, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 k_1 g q, g) #scale(x: 300%, y: 300%)[floor.r] - #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q g S^2, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q k_1 g q, g) #scale(x: 300%, y: 300%)[floor.r] #scale(x: 300%, y: 300%)[\)]$

$$

$= #scale(x: 300%, y: 300%)[\(] #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A', g) #scale(x: 300%, y: 300%)[floor.r] + D_2 k_2 q + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A', g) #scale(x: 300%, y: 300%)[floor.r] + k_3 q k_2 q\,$

$upright(" ") - #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] + D_2 dot.op S^2 + D_2 k_1 q - #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r] + k_3 q S^2 + k_3 q k_1 q #scale(x: 300%, y: 300%)[\)]$

$$

$= #scale(x: 300%, y: 300%)[\(] #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A', g) #scale(x: 300%, y: 300%)[floor.r] upright(" mod ") q\,upright(" ") - #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] + D_2 dot.op S^2 - #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r] upright(" mod ") q #scale(x: 300%, y: 300%)[\)]$

$$

$= C_beta in cal(R)_(n\,q)^2$

Now, we finally got $C_beta$ which is in the form of RLWE ciphertext
modulo $q$. Remember that our goal is to express $D_2 dot.op S^2$ as a
decryption of RLWE ciphertext. If we treat $C_beta$ as a synthetic RLWE
ciphertext and decrypt it, we get the following:

$sans("RLWE")_(S\,sigma)^(- 1)\(C_beta\)$ $gt.tri$ where $C_beta$ is
treated as a synthetic RLWE ciphertext

$= sans("RLWE")_(S\,sigma)^(- 1) #scale(x: 300%, y: 300%)[\(] #scale(x: 300%, y: 300%)[\(] - #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] + D_2 dot.op S^2 - #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r]\,upright(" ") #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A', g) #scale(x: 300%, y: 300%)[floor.r] #scale(x: 300%, y: 300%)[\)] #scale(x: 300%, y: 300%)[\)]$

$$

$= - #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] + D_2 dot.op S^2 - #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A', g) #scale(x: 300%, y: 300%)[floor.r] dot.op S + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A', g) #scale(x: 300%, y: 300%)[floor.r] dot.op S$

$$

$approx #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] + D_2 dot.op S^2 + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r]$
$gt.tri$
$- #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 A', g) #scale(x: 300%, y: 300%)[floor.r] dot.op S = - #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A' dot.op S, g) #scale(x: 300%, y: 300%)[floor.r] + #scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q A', g) #scale(x: 300%, y: 300%)[floor.r] dot.op S approx 0$

$$

$approx D_2 dot.op S^2$ $gt.tri$
$#scale(x: 300%, y: 300%)[ceil.l] frac(D_2 E', g) #scale(x: 300%, y: 300%)[floor.r] approx 0$,
$#scale(x: 300%, y: 300%)[ceil.l] frac(k_3 q E', g) #scale(x: 300%, y: 300%)[floor.r] approx 0$

$$

As shown in the above, decrypting $C_beta$ gives us $D_2 dot.op S^2$.
Therefore, we reach the following conclusion:

$Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r) approx sans("RLWE")_(S\,sigma)^(- 1)\(C_alpha\)+ sans("RLWE")_(S\,sigma)^(- 1)\(C_beta\)$
, where
$C_alpha =\(D_1\,D_0\)\,upright(" ") C_beta = #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 dot.op italic(e v k_g), g) #scale(x: 300%, y: 300%)[floor.r]$

$$

Therefore, we finally get the following congruence relation:

$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)approx C_alpha + C_beta$
, where
$C_alpha =\(D_1\,D_0\)\,upright(" ") C_beta = #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 dot.op italic(e v k_g), g) #scale(x: 300%, y: 300%)[floor.r]$

$$

$$

Our last step of ciphertext-to-ciphertext multiplication is to convert
$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
into
$sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$,
because if the result of ciphertext-to-ciphertext multiplication is
$M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r) = M^(chevron.l 3 chevron.r)$,
then for consistency purposes, the resulting RLWE ciphertext is supposed
to be:

$sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)= sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 3 chevron.r)\)$

We will explain this process in the next subsection.

=== Rescaling
<subsubsec:ckks-mult-cipher-rescale>
To convert
$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
into
$sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$,
we cannot simply divide the ciphertext
$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
by $Delta$, because as explained in
#link(<subsec:modulo-division>)[\[subsec:modulo-division\]], modulo
arithmetic does not support direct division. Multiplying the RLWE
ciphertext by $Delta^(- 1)$ (i.e., an inverse of $Delta$) does not work
either, because the only useful property we can use for inverse
multiplication is: $a dot.op a^(- 1) equiv 1$. If an inverse is
multiplied to any other values other than its counterpart, the result is
an arbitrary value. For example, if $Delta^(- 1)$ is multiplied to a
noise (i.e., $Delta^(- 1) E$), then the result can be a very huge value.
Thus, multiplying the RLWE ciphertext by $Delta^(- 1)$ does not help due
to the unpredictable result of the noise term.

The safest way to convert
$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
into
$sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$
is modulus switch
(#link(<subsec:modulus-switch-glwe>)[\[subsec:modulus-switch-glwe\]]),
which is essentially modulo rescaling
(#link(<sec:modulus-rescaling>)[\[sec:modulus-rescaling\]]). For this to
work, the RLWE setup stage should design the ciphertext domain $q$ as
$q_0 dot.op Delta^L$, where $L$ is denoted as the level of
multiplication, and $q_0 gt.double Delta$ (which is important for the
accuracy of homomorphic modulo reduction during bootstrapping in
#link(<subsec:ckks-bootstrapping>)[0.13]). Upon each
ciphertext-to-ciphertext multiplication, we switch the modulus of the
RLWE ciphertext from
$q_0 dot.op Delta^i arrow.r q_0 dot.op Delta^(i - 1)$, which effectively
converts the plaintext's squared scaling factor $Delta^2$ (in
$sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$)
into $Delta$ (in
$sans("RLWE")_(S\,sigma)\(Delta dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)$).
Once the RLWE ciphertext's level reaches 0 (i.e., ciphertext modulus
$q_0$), we cannot do any more ciphertext-to-ciphertext multiplication,
in which case we need a special process called bootstrapping to
re-initialize the modulus level to $L$.

However, one problem with this setup is that $Delta^L$ will be a huge
number. Performing homomorphic addition or multiplication over modulo
$Delta^L$ is computationally expensive. To reduce the overhead of
ciphertext size, we use the Chinese remainder theorem
(#link(<sec:chinese-remainder>)[\[sec:chinese-remainder\]]): given an
integer $x upright(" mod ") W$ where $W$ is a multiplication of $L + 1$
co-primes such that $W = w_0 w_1 w_2 w_3 dots.h.c w_L$, the following
congruence relationships hold:

$x equiv d_0 upright(" mod ") w_0$

$x equiv d_1 upright(" mod ") w_1$

$x equiv d_2 upright(" mod ") w_2$

$dots.v$

$x equiv d_L upright(" mod ") w_L$

$$

, where
$x = sum_(m = 0)^L d_m y_m z_m upright(" mod ") W\,upright(" ") upright(" ") y_m = W / w_m\,upright(" ") upright(" ") z_m = y_m^(- 1) upright(" mod ") w_m$,
and $w_0 = q_0$

$$

In other words, $x med mod med W$ can be isomorphically mapped to a
vector of smaller numbers $\(d_0\,d_1\,dots.h.c\,d_l\)$ each in modulo
$w_0\,w_1\,dots.h.c\,w_l$, addition/multiplication with big elements in
modulo $W$ can be done by using their encoded smaller-magnitude CRT
vectors element-wise, and later decode the intended big-number result.
By leveraging this property, we design the CKKS scheme's maximal
ciphertext modulus as $W = product_(m = 0)^L w_m$, where $L$ is the
maximum multiplicative level, $w_0 = q_0 gt.double Delta$, and all other
$w_i approx Delta$. Then, whenever reaching from the $l$-th to the next
lower $l - 1$-th multiplicative level, we switch its modulus from
$q = product_(m = 0)^l w_m$ to $hat(q) = product_(m = 0)^(l - 1) w_m$ as
follows:

$\(upright(" ") C =\(A\,B\)upright(" ")\)in cal(R)_(chevron.l n\,q chevron.r) arrow.r sans("RLWE")_(S\,sigma)\(upright(" ") hat(C) =\(hat(A)\,hat(B)\)upright(" ")\)in cal(R)_(chevron.l n\,hat(q) chevron.r)$

$q = product_(m = 0)^l w_m$, \# where all $w_m$ are prime numbers,
$w_0 = q_0 gt.double Delta dot.op p$ to ensure the scaled plaintext
$Delta M$ during homomorphic operations never overflows the ciphertext
modulus even at the lowest multiplicative level, and all other
$w_i approx Delta$

$hat(q) = q / w_l$

$hat(A_i) = ⌈hat(q) / q dot.op A_i⌋ = hat(a)_(i\,0) + hat(a)_(i\,1) X + hat(a)_(i\,2) X^2 + dots.h.c + hat(a)_(i\,n - 1) X^(n - 1)$,
where each
$hat(a)_(i\,j) = #scale(x: 180%, y: 180%)[ceil.l] a_(i\,j) hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = #scale(x: 180%, y: 180%)[ceil.l] a_(i\,j) / w_l #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$hat(B) = ⌈hat(q) / q dot.op B⌋ = hat(b)_0 + hat(b)_1 X + hat(b)_2 X^2 + dots.h.c + hat(b)_(n - 1) X^(n - 1)$,
where each
$hat(b)_j = #scale(x: 180%, y: 180%)[ceil.l] b_j hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = #scale(x: 180%, y: 180%)[ceil.l] b_j / w_l #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$sans("RLWE")_(S\,sigma)\(Delta M\)=\(hat(A)\,hat(B)\)in cal(R)_(chevron.l n\,hat(q) chevron.r)$

$$

The above update of $\({ A_i }_(i = 0)^(k - 1)\,B\)$ to
$\({ hat(A)_i }_(i = 0)^(k - 1)\,hat(B)\)$ effectively changes
$Delta\,E$ to $hat(Delta)\,hat(E)$ as follows:

$hat(E) = hat(e)_0 + hat(e)_1 X + hat(e)_2 X^2 + dots.h.c + hat(e)_(n - 1) X^(n - 1)$,
where each
$hat(e)_j = #scale(x: 180%, y: 180%)[ceil.l] e_j hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = #scale(x: 180%, y: 180%)[ceil.l] e_j / w_l #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

$hat(Delta) = ⌈Delta^2 hat(q) / q⌋ = ⌈Delta^2 / w_l⌋ approx Delta$
$gt.tri$ If we treat $hat(Delta)$ as $Delta$, the rounding error
slightly increases the noise $hat(E)$ to $hat(E) + E_Delta$, while the
decryption of $\(hat(A)\,hat(B)\)$ outputs the same $M$

$$

Note that after the rescaling, the plaintext scaling factor of
$\(hat(A)\,hat(B)\)$ is also updated to $hat(Delta)$. Meanwhile, $M$ and
$S$ stay the same as before.

$$

After we switch the modulus of the ciphertext $C$ from
$q arrow.r hat(q)$ by multiplying $hat(q) / q$ to $A$ and $B$, the
encrypted original plaintext term
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$ will
become
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) dot.op hat(q) / q = frac(Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r), w_l) =\(Delta + epsilon.alt_Delta\)dot.op M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$,
where $epsilon.alt_Delta approx 0$, because as explained before, we
chose ${ w_i }_(i = 1)^L$ such that $w_i approx Delta$. Therefore,
$\(Delta + epsilon.alt_Delta\)dot.op M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) = Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + epsilon.alt_Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$,
where
$epsilon.alt_Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) approx 0$,
which becomes part of the noise term of the modulus-switched (i.e.,
rescaled) new ciphertext $hat(C)$.

$$

The benefit of this design of the CRT (Chinese remainder problem)-based
ciphertext modulus and rescaling is that we can isomorphically decompose
the huge coefficients (bigger than 64 bits) of polynomials in
ciphertexts into $l$-dimensional Chinese remainder vectors
(Theorem~@sec:chinese-remainder\.2 in
#link(<sec:chinese-remainder>)[\[sec:chinese-remainder\]]) and perform
element-wise addition or multiplication for computing coefficients over
the small vector elements. This promotes computational efficiency for
homomorphic addition and multiplication over a large ciphertext modulus
(although the number of addition/multiplication operations increases).
This technique is called Residue Number System (RNS). When CRT is used
in ciphertexts, the security regarding the ciphertext modulus depends on
the smallest and the largest CRT elements.

To support multi-level multiplicative levels (using CRT), we need to
modify the generic scaling factor setup presented in
Summary~@subsec:glwe-enc (#link(<subsec:glwe-enc>)[\[subsec:glwe-enc\]])
from $Delta = q / t$ to $Delta = w_L$.

Upon each step of rescaling during ciphertext-ciphertext multiplication,
the noise also gets scaled down by $1 / Delta$ (or by $1 / w_l$ at
multiplicative level $l$ in the case of using CRT). Therefore, rescaling
reduces the absolute magnitude of the noise by a factor of $Delta$ (or
$w_l$). However, during each ciphertext-to-ciphertext multiplication,
the encrypted (noisy) plaintext is
$\(Delta M_1 + E_1\)dot.op\(Delta M_2 + E_2\)= Delta^2 M_1 M_2 + Delta dot.op\(M_1 E_2 + M_2 E_1\)+ E_1 E_2$,
and rescaling roughly has the effect of dividing this by $Delta$, which
approximately gives us
$Delta M_1 M_2 + M_1 E_2 + M_2 E_1 + frac(E_1 E_2, Delta)$. Because of
the $\(M_1 E_2 + M_2 E_1\)$ term, the noise actually grows compared to
before ciphertext-to-ciphertext multiplication. Therefore,
ciphertext-to-ciphertext multiplication inevitably increases the noise.

=== Comparing BFV and CKKS Bootstrapping
<subsubsec:bfv-bootstrapping-ckks-comparison>
CKKS bootstrapping shares several common aspects with BFV bootstrapping.
CKKS's ModRaise and Homomorphic Decryption steps are equivalent to BFV's
Homomorphic Decryption (without modulo-$q$ reduction) step. BFV
homomorphically multiplies polynomial $A$ and $B$ whose coefficients are
in $bb(Z)_(p^e)$ with the encrypted secret key whose ciphertext modulus
is $q$, which generates the modulo wrap-around coefficient values
$p^e K$. Similarly, CKKS coefficients are in $bb(Z)_(q_0)$ with the
encrypted secret key whose ciphertext modulus is $q_L$, which generates
the modulo wrap-around coefficient values $q_0 K$. However, they use
different strategies to handle their modulo wrap-around values. CKKS
uses evaluation of the sine function having a period of $q_0$ to
approximately eliminate $q_0 K$ (i.e., EvalExp). On the other hand, BFV
uses digit extraction to scale down $p^e K$ by $p^(e - 1)$ and then
treats the remaining small $p K$ as part of the modulo wrap-around value
of the plaintext. The requirement of the digit extraction algorithm is
that the plaintext inputs should be represented as base-$p$ values, and
because of this, BFV bootstrapping includes the initial step of modulus
switch from $q arrow.r p^e$, where $p^e$ is used as the plaintext
modulus after homomorphic decryption.

Both BFV and CKKS use the same strategy for their CoeffToSlot,
SlotToCoeff, and Scaling Factor Re-interpretation steps.

A critical difference between BFV and CKKS is that in BFV, the
ciphertext modulus $q$ stays the same after ciphertext-ciphertext
multiplication, and there is no restriction on the number of
ciphertext-ciphertext multiplications. On the other hand, in CKKS, the
ciphertext modulus changes from $q_l arrow.r q_(l - 1)$ after each
multiplication, and when it reaches $q_0$, no more multiplication can be
done, unless we reset the ciphertext modulus to $q_L$ by using the
modulus bootstrapping technique
(#link(<subsec:ckks-bootstrapping>)[0.13]).

Although CKKS's rescaling during ciphertext-to-ciphertext multiplication
reduces the magnitude of noise $E$ by $Delta$, it also reduces the
ciphertext modulus by the same amount, and thus the relative
noise-to-ciphertext-modulus ratio does not get decreased by rescaling.
In order to reduce (or reset) the noise-to-modulus ratio, we need to do
bootstrapping (#link(<subsec:ckks-bootstrapping>)[0.13]), which will be
explained at the end of this section.

=== Summary
<subsubsec:ckks-mult-cipher-summary>
To put all things together, CKKS's ciphertext-to-ciphertext
multiplication is summarized as follows:

#block[
Suppose we have the following two RLWE ciphertexts:

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 1 chevron.r)\)=\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)$,
where
$B^(chevron.l 1 chevron.r) = - A^(chevron.l 1 chevron.r) dot.op S + Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r)$

$sans("RLWE")_(S\,sigma)\(Delta M^(chevron.l 2 chevron.r)\)=\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)$,
where
$B^(chevron.l 2 chevron.r) = - A^(chevron.l 2 chevron.r) dot.op S + Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r)$

$$

Multiplication between these two ciphertexts is performed as follows:

$$

+ #strong[#underline[Basic Multiplication]]

  Compute the following:

  $$

  $D_0 = B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r)$

  $D_1 = B^(chevron.l 2 chevron.r) A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)$

  $D_2 = A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)$

  $$

  , where
  $Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) approx underbrace(B^(chevron.l 1 chevron.r) B^(chevron.l 2 chevron.r), D_0) + underbrace(\(B^(chevron.l 2 chevron.r) A^(chevron.l 1 chevron.r) + B^(chevron.l 1 chevron.r) A^(chevron.l 2 chevron.r)\), D_1) dot.op S + underbrace(\(A^(chevron.l 1 chevron.r) dot.op A^(chevron.l 2 chevron.r)\), D_2) dot.op underbrace(S dot.op S, S^2)$

  $= D_0 + D_1 dot.op S + D_2 dot.op S^2$

  $$

+ #strong[#underline[Relinearization]]

  $sans("RLWE")_(S\,sigma)\(Delta^2 dot.op M^(chevron.l 1 chevron.r) dot.op M^(chevron.l 2 chevron.r)\)approx sans("RLWE")_(S\,sigma) bold(\() upright(" ")\(D_0 + D_1 dot.op S + D_2 dot.op S^2\)upright(" ") bold(\)) approx C_alpha + C_beta$

  $$

  $\,upright(" where ") upright(" ") C_alpha =\(D_1\,D_0\)\,$

  $C_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r) upright(" or ") #scale(x: 300%, y: 300%)[ceil.l] frac(D_2 dot.op italic(e v k_g), g) #scale(x: 300%, y: 300%)[floor.r]$,

  $italic(e v k_g) =\(A'\,- A' dot.op S + E' + g S^2\)in cal(R)_(chevron.l n\,g q chevron.r)^2\,upright(" ") upright(" ") g = q_L^2\,upright(" ") L : upright(" the maximum level")$

  $$

+ #strong[#underline[Rescaling]]

  Switch the relinearlized ciphertext's modulus from $q arrow.r hat(q)$
  by updating $\(A\,B\)$ to $\(hat(A)\,hat(B)\)$ as follows:

  $$

  $\(upright(" ") C =\(A\,B\)upright(" ")\)in cal(R)_(chevron.l n\,q chevron.r) arrow.r\(upright(" ") hat(C) =\(hat(A)\,hat(B)\)upright(" ")\)in cal(R)_(chevron.l n\,hat(q) chevron.r)$

  $q = product_(m = 0)^l w_m$, \# where all $w_m$ are prime numbers,
  $w_0 = q_0 gt.double Delta dot.op p$ to ensure the plaintext $Delta M$
  during homomorphic operations never overflows the ciphertext modulus
  even at the lowest multiplicative level, and all other
  $w_i approx Delta$

  $hat(q) = q / w_l$

  $hat(A) = ⌈hat(q) / q dot.op A⌋ = hat(a)_0 + hat(a)_1 X + hat(a)_2 X^2 + dots.h.c + hat(a)_(n - 1) X^(n - 1)$,
  where each
  $hat(a)_i = #scale(x: 180%, y: 180%)[ceil.l] a_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = #scale(x: 180%, y: 180%)[ceil.l] a_i / w_l #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

  $hat(B) = ⌈hat(q) / q dot.op B⌋ = hat(b)_0 + hat(b)_1 X + hat(b)_2 X^2 + dots.h.c + hat(b)_(n - 1) X^(n - 1)$,
  where each
  $hat(b)_i = #scale(x: 180%, y: 180%)[ceil.l] b_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = #scale(x: 180%, y: 180%)[ceil.l] b_i / w_l #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

  $$

  The above update of $\(A\,B\)$ to $\(hat(A)\,hat(B)\)$ effectively
  changes $Delta\,E$ to $hat(Delta)\,hat(E)$ as follows:

  $hat(E) = hat(e)_0 + hat(e)_1 X + hat(e)_2 X^2 + dots.h.c + hat(e)_(n - 1) X^(n - 1)$,
  where each
  $hat(e)_i = #scale(x: 180%, y: 180%)[ceil.l] e_i hat(q) / q #scale(x: 180%, y: 180%)[floor.r] = #scale(x: 180%, y: 180%)[ceil.l] e_i / w_l #scale(x: 180%, y: 180%)[floor.r] in bb(Z)_(hat(q))$

  $hat(Delta) = ⌈Delta^2 hat(q) / q⌋ = ⌈Delta^2 / w_l⌋ approx Delta$
  $gt.tri$ This rounding error slightly increases the noise $hat(E)$ to
  $hat(E) + E_Delta$, while the decryption of $\(hat(A)\,hat(B)\)$
  outputs the same plaintext $M$

  $$

  Note that after the rescaling, the ciphertext modulus changes from
  $q arrow.r hat(q)$, and the plaintext scaling factor of
  $\(hat(A)\,hat(B)\)$ is also updated to $hat(Delta)$. Meanwhile, the
  plaintext $M$ and the secret key $S$ stay the same as before.

  $$

The order of relinearization and rescaling is interchangeable. Running
rescaling before relinearization reduces the size of the ciphertext
modulus, and therefore the subsequent relinearization can be executed
faster.

]
== Ciphertext-to-Plaintext Multiplication
<subsec:ckks-mult-plain>
Remember that BFV's ciphertext-to-plaintext multiplication
(#link(<subsec:bfv-mult-plain>)[\[subsec:bfv-mult-plain\]]) is performed
as follows:

$sans("RLWE")_(S\,sigma)\(Delta M\)dot.op Lambda$

$=\(A\,upright(" ") B\)dot.op Lambda$

$=\(A dot.op Lambda\,upright(" ") B dot.op Lambda\)$

$= sans("RLWE")_(S\,sigma)\(Delta\(M dot.op Lambda\)\)$

, where the plaintext polynomial $Lambda$ is not scaled by $Delta$.
However, the above relation cannot be used in CKKS's
ciphertext-to-plaintext multiplication because when CKKS encodes the
input vector slots into polynomial coefficients, the encoding is
computed as
\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$
(Summary~@subsec:ckks-encoding-decoding in
#link(<subsec:ckks-encoding-decoding>)[0.1]), where the $n$-th
root-of-unity base
$omega = e^(i pi\/n) = cos (pi / n) + i sin (pi / n)$. Since $omega$ is
usually not an integer, the encoded polynomial $Lambda$'s coefficients
are usually not integers (will usually have infinite decimal digits).
Therefore, we need to follow the CKKS encoding procedure's last step
(Summary~@subsec:ckks-encoding-decoding in
#link(<subsec:ckks-encoding-decoding>)[0.1]), which scales $Lambda$ by
$Delta$ to shift an enough number of its decimal values to the integer
digits, which effectively approximates the decimal coefficients to
integers with high precision. Then, the resulting encrypted plaintext
becomes $Delta M dot.op Delta Lambda = Delta^2 M Lambda$. To convert
$Delta^2 M Lambda$ into $Delta M Lambda$, we need to do a rescaling
operation as we did in CKKS's ciphertext-to-ciphertext multiplication's
(Summary~@subsubsec:ckks-mult-cipher-summary in
#link(<subsubsec:ckks-mult-cipher-summary>)[0.5.6]) last step.
Therefore, CKKS's ciphertext-to-plaintext multiplication consumes one
multiplicative level (whereas BFV's ciphertext-to-plaintext
multiplication does not consume any multiplicative level). CKKS's
ciphertext-to-plaintext multiplication is summarized as follows:

#block[
+ #strong[#underline[Basic Multiplication]]

  $sans("RLWE")_(S\,sigma)\(Delta M\)dot.op Delta Lambda$

  $=\(A\,upright(" ") B\)dot.op Delta Lambda$

  $=\(A dot.op Delta Lambda\,upright(" ") B dot.op Delta Lambda\)$

  $= sans("RLWE")_(S\,sigma)\(Delta^2\(M dot.op Lambda\)\)$

  $$

+ #strong[#underline[Rescaling]]

  Switch the relinearlized ciphertext's modulus from $q arrow.r hat(q)$
  as done in CKKS's ciphertext-to-ciphertext multiplication's
  (Summary~@subsubsec:ckks-mult-cipher-summary in
  #link(<subsubsec:ckks-mult-cipher-summary>)[0.5.6]) last step.

]
== ModDrop
<subsec:ckks-moddrop>
Remember that CKKS's ciphertext decryption relation is as follows:

$Delta M + E = A dot.op S + B med mod med q_l$

$Delta M + E = A dot.op S + B - K dot.op q_l$ $gt.tri$ where
$K dot.op q_l$ represents a modulo reduction by $q_l$

$$

ModDrop is an operation of lowering the multiplicative level of a
ciphertext by sequentially throwing away its modulus's one or more prime
elements $(upright("i.e.,") {q_i / q_(i - 1)}_(i = 0)^L)$ except for the
last one $q_0$, while ensuring that the plaintext's scaling factor
$Delta$ stays the same as before. Specifically, a ModDrop operation that
decreases its modulus from $q_l arrow.r q_(l - 1)$ is performed by
updating the ciphertext $\(A\,B\)$ to a new one:
$bold(\() A' = A med mod med q_(l - 1)$,
$B' = B med mod med q_(l - 1)\)$. After the ModDrop, the ciphertext's
modulus decreases from $q_l arrow.r q_(l - 1)$, yet its decryption
relation still holds the same as follows:

$A' dot.op S + B' - K dot.op q_l$

$=\(A med mod med q_(l - 1)\)dot.op S +\(B med mod med q_(l - 1)\)- K dot.op q_l$

$=\(A - K_A dot.op q_(l - 1)\)dot.op S +\(B - K_B dot.op q_(l - 1)\)- K dot.op q_l$

$= A dot.op S + B -\(K_A + K_B + K q / q_(l - 1)\)dot.op q_(l - 1)$
$gt.tri$ where $q / q_(l - 1)$ is an integer (the $l$-the prime element
of $q_L$)

$= A dot.op S + B - K' dot.op q_(l - 1)$ $gt.tri$ where
$K' = K_A + K_B + K q / q_(l - 1)$ is an integer

$= A dot.op S + B med mod med q_(l - 1)$

$= Delta M + E$ $gt.tri$ since $Delta M + E < q_0 < q_(l - 1)$

$$

As shown above, $\(A'\,B'\)med mod med q_(l - 1)$ decrypts to the same
$Delta M + E$, a scaled plaintext with an error.

$$

CKKS's ModDrop is summarized as follows:

#block[
Given a CKKS ciphertext with the $l$-th multiplicative level
$sans("RLWE")_(S\,sigma)\(Delta M\)=\(A\,B\)med mod med q_l$, a ModDrop
operation is as follows:

$\(A'\,B'\)med mod med q_(l - 1) =\(A med mod med q_(l - 1)\,B med mod med q_(l - 1)\)$

$$

, after which the ciphertext's multiplicative level decreases by 1,
while the plaintext's scaling factor $Delta$ and the noise are
unaffected.

]
=== Difference between Modulus Switch and ModDrop
<subsubsec:ckks-moddrop-vs-modswitch>
In CKKS, both modulus switch (i.e., rescaling explained in
#link(<subsubsec:ckks-mult-cipher-rescale>)[0.5.4]) and ModDrop lower a
ciphertext's modulus from $q_l arrow.r q_(l - 1)$. However, the key
difference is that rescaling also decreases the plaintext's scaling
factor by the $q_l / q_(l - 1) approx Delta$, whereas ModDrop does not
affect the plaintext's scaling factor and the noise. Therefore,
rescaling is used only during ciphertext-to-ciphertext multiplication
when scaling down the plaintext's scaling factor in the intermediate
ciphertext from $Delta^2 arrow.r Delta$. Meanwhile, ModDrop is used to
reduce the modulo computation time during an application's routine when
it becomes certain that the ciphertext will not undergo any additional
ciphertext-to-ciphertext multiplication (i.e., no need to further
decrease the ciphertext's modulus).

== Homomorphic Key Switching
<subsec:ckks-key-switching>
CKKS's homomorphic key switching scheme changes an RLWE ciphertext's
secret key from $S$ to $S'$. This scheme is exactly the same as BFV's
key switching scheme (Summary~@subsec:bfv-key-switching in
#link(<subsec:bfv-key-switching>)[\[subsec:bfv-key-switching\]]).

#block[
$sans("RLWE")_(S'\,sigma)\(Delta M\)=\(0\,B\)+ bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$

]
== Homomorphic Rotation of Input Vector Slots
<subsec:ckks-rotation>
CKKS's batch encoding scheme (Summary~@subsec:ckks-encoding-decoding in
#link(<subsec:ckks-encoding-decoding>)[0.1]) implicitly supports
homomorphic rotation of input slot vectors like that of BFV's
homomorphic rotation (Summary~@subsubsec:bfv-rotation-summary in
#link(<subsubsec:bfv-rotation-summary>)[\[subsubsec:bfv-rotation-summary\]]).
This is because CKKS uses the same encoding and decoding matrices
(\$\\hathat W\$ and \$\\hathat{W}^\*\$) designed for the BFV encoding
and decoding scheme that supports homomorphic rotation of input vector
slots. Although the roots of the $\(mu = 2 n\)$-th cyclotomic polynomial
$X^n + 1$ are different for the BFV and CKKS schemes (as one is designed
over $X in bb(Z)_t$ and the other is over $X in bb(R)$), CKKS still can
use the same \$\\hathat W\$ (and \$\\hathat{W}^\*\$) matrices as BFV,
because the $\(mu = 2 n\)$-th cyclotomic polynomial over $X in bb(Z)_t$
exhibits the same essential properties as the $\(mu = 2 n\)$-th
cyclotomic polynomial over $X in bb(R)$ (as explained in
#link(<sec:cyclotomic-polynomial-integer-ring>)[\[sec:cyclotomic-polynomial-integer-ring\]]).
Especially, the roots of both $\(mu = 2 n\)$ cyclotomic polynomials are
the primitive $\(mu = 2 n\)$-th roots of unity having the order $2 n$,
and those $n$ distinct roots are defined as
$omega^1\,omega^3\,dots.h.c\,omega^(2 n - 1)$, where $omega$ can be any
root. Therefore, substituting CKKS's $\(mu = 2 n\)$-th roots of unity
into the $omega$ terms in BFV's encoding matrix \$\\hathat{W}\$ (and
decoding matrix \$\\hathat{W}^\*\$) preserves the same computational
correctness for the encoding and decoding schemes, as well as for input
vector slot rotation.

Importantly, the \$\\hathat{W}\$ and \$\\hathat{W}^\*\$ matrices in both
the BFV and CKKS schemes satisfy the exact requirement for supporting
input vector slot rotation. That is, given the following relations:

- The $arrow(v) arrow.r arrow(m)$ encoding formula:
  \$\\vec{m} = n^{-1}\\cdot I\_n^R\\cdot \\hathat{W}\\cdot \\vec{v}\$

- The $arrow(m) arrow.r arrow(v)$ decoding formula:
  \$\\vec{v} = \\hathat{W}^\* \\cdot \\vec{m}\$

- The encoded polynomial $M\(X\)= sum_(i = 0)^(n - 1) m_i X^i$

, updating the polynomial $M\(X\)$ to $M\(X^(J\(h\))\)$ results in the
effect of rotating the first half of the $n$-dimensional input vector
slots ($arrow(v) in bb(Z)_p^n$ in the case of BFV, and the
forward-ordered Hermitian vector
$arrow(v)_(') in bb(hat(C))^n arrow.r bb(C)^(n / 2)$ in the case of
CKKS) by $h$ positions to the left (in a wrapping manner among them) and
the second half of the slots also by $h$ positions to the right (in a
wrapping manner among them).

BFV uses CKKS's same rotation scheme described in
Summary~@subsubsec:bfv-rotation-summary (in
#link(<subsubsec:bfv-rotation-summary>)[\[subsubsec:bfv-rotation-summary\]])
as follows:

#block[
Suppose we have an RLWE ciphertext and a key-switching key as follows:

$sans("RLWE")_(S\,sigma)\(Delta M\)=\(A\,B\)$,
$sans("RLev")_(S\,sigma)^(beta\,l)\(S^(J\(h\))\)$

$$

Then, the procedure of rotating all $n / 2$ elements of the ciphertext's
original input vector $arrow(v)$ by $h$ positions to the left is as
follows:

+ Update $A\(X\)$, $B\(X\)$ to $A\(X^(J\(h\))\)$, $B\(X^(J\(h\))\)$.

+ Perform the following key switching
  (#link(<subsec:ckks-key-switching>)[0.8]) from $S\(X^(J\(h\))\)$ to
  $S\(X\)$:

  $sans("RLWE")_(S\(X\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\)) = bold(\() 0\,B\(X^(J\(h\))\)bold(\)) upright(" ") + upright(" ") bold(chevron.l) sans("Decomp")^(beta\,l) bold(\() A\(X^(J\(h\))\)bold(\))\,upright(" ") sans("RLev")_(S\(X\)\,sigma)^(beta\,l) bold(\() S\(X^(J\(h\))\)bold(\)) bold(chevron.r)$

]
Like BFV, CKKS rotates the first half of the forward-ordered Hermitian
input vector slots $arrow(v)_(') in bb(hat(C))^n$ and the second half of
its slots separately in a partitioned manner. This is because the first
half rows of \$\\hathat{W}^\*\$ comprise the terms $omega^(J\(h\))$ for
$h = { 0\,1\,dots.h.c\,n / 2 - 1 }$ (i.e., evaluates $M\(X\)$ at
$X = { omega^(J\(0\))\,omega^(J\(1\))\,dots.h.c\,omega^(J\(n / 2 - 1\)) }$),
whereas the second half rows of \$\\hathat{W}^\*\$ comprise the terms
$omega^(J_(*)\(h\))$ (i.e., evaluates $M\(X\)$ at
$X = { omega^(J_(*)\(0\))\,omega^(J_(*)\(1\))\,dots.h.c\,omega^(J_(*)\(n / 2 - 1\)) }$),
and the computed values of $J\(h\)$ and $J_(*)\(h\)$ repeat (i.e.,
rotate) within their own rotation group across
$h = { 0\,1\,dots.h.c\,n / 2 - 1 }$. Because of this structure of
\$\\hathat W\$ and \$\\hathat W^\*\$, BFV and CKKS cannot design a
wrapping rotation scheme across all $n$ slots of the input vector
homogeneously, but can instead design a wrapping rotation scheme across
each group of the first-half and the second-half $n / 2$ slots of the
input vector in a partitioned manner. That being said, CKKS can
meaningfully only use the first $n / 2$ slots for homomorphic
computations anyway, because the latter $n / 2$ slots are conjugates of
the first $n / 2$ slots which cannot be chosen by the user but are
deterministically configured based on the first $n / 2$. On the other
hand, in BFV, the user can choose the entire $n / 2$ according to
his/her needs, so BFV's utility of slots is full $n$. Therefore, the
user can use BFV's first-half slots and second-half slots together to
perform parallel computations.

=== Example
<subsubsec:ckks-rotation-ex>
In this subsection, we will show the following 2 examples:

+ Encode an input vector $arrow(v)$ into a plaintext polynomial $M\(X\)$
  based on our updated updated encoding & decoding matrices
  \$\\hathat W\$ and \$\\hathat W^\*\$

+ Rotate all elements of the input vector $arrow(v)$ $h$ positions to
  the left by updating the encoded plaintext $M\(X\)$ to
  $M\(X^(J\(h\))\)$

$$

We will use the same example of the input vector $arrow(v)$ used in
#link(<subsubsec:ckks-encoding-ex>)[0.1.1]:
$arrow(v)^(chevron.l h = 1 chevron.r) =\(1.1 + 4.3 i\,3.5 - 1.4 i\)$.

Remember that the encoded plaintext polynomial of $arrow(v)$ is as
follows:

$Delta M\(X\)= 2355 + 1195 X + 1485 X^2 + 2933 X^3 in cal(R)_(chevron.l 4 chevron.r) in bb(R)\[X\]\/X^4 + 1$

Suppose we want to rotate the input vector $arrow(v)$ by 1 position to
the left as follows:

$arrow(v)^(chevron.l h = 1 chevron.r) =\(3.5 - 1.4 i\,1.1 + 4.3 i\)$

$$

Therefore, we update $Delta M\(X\)$ to $Delta M\(X^(J\(1\))\)$ as
follows:

$Delta M\(X^(J\(1\))\)= Delta M\(X^5\)= 2355 + 1195\(X^5\)+ 1485\(X^5\)^2+ 2933\(X^5\)^3$

$= 2355 + 1195 X^5 + 1485 X^10 + 2933 X^15$

$= 2355 + 1195 X dot.op\(- 1\)+ 1485 X^2 dot.op\(- 1\)dot.op\(- 1\)+ 2933 X^3 dot.op\(- 1\)dot.op\(- 1\)dot.op\(- 1\)$

$= 2355 - 1195 X + 1485 X^2 - 2933 X^3$

$$

The rotated #emph[forward-ordered] Hermitian input vector is computed as
follows:

\$\\dfrac{\\hathat W^\* \\cdot \\Delta \\vec{m}}{\\Delta} = \\begin{bmatrix}
1,\\omega,\\omega^2, \\omega^3\\\\
1,\\omega^5, \\omega^{10},\\omega^{15}\\\\
1,\\overline{\\omega}, \\overline{\\omega^2}, \\overline{\\omega^3}\\\\
1,\\overline{\\omega^5}, \\overline{\\omega^{10}}, \\overline{\\omega^{15}}
\\end{bmatrix} \\cdot \\begin{bmatrix}
2355\\\\- 1195\\\\1485\\\\-2933
\\end{bmatrix}\\cdot \\dfrac{1}{1024}\$

\$= \\dfrac{\\hathat W^\* \\cdot \\Delta \\vec{m}}{\\Delta} = \\begin{bmatrix}
1,\\omega,\\omega^2, \\omega^3\\\\
1,\\omega^5, \\omega^{2},\\omega^{7}\\\\
1,\\overline{\\omega}, \\overline{\\omega^2}, \\overline{\\omega^3}\\\\
1,\\overline{\\omega^5}, \\overline{\\omega^{2}}, \\overline{\\omega^{7}}
\\end{bmatrix} \\cdot \\begin{bmatrix}
2355\\\\- 1195\\\\1485\\\\-2933
\\end{bmatrix}\\cdot \\dfrac{1}{1024}\$

\$= \\dfrac{\\hathat W^\* \\cdot \\Delta \\vec{m}}{\\Delta} = \\begin{bmatrix}
1,\\omega,\\omega^2, \\omega^3\\\\
1,\\omega^5, \\omega^{2},\\omega^{7}\\\\
1,\\omega^7, \\omega^6, \\omega^5\\\\
1,\\omega^3, \\omega^{6}, \\omega
\\end{bmatrix} \\cdot \\begin{bmatrix}
2355\\\\- 1195\\\\1485\\\\-2933
\\end{bmatrix}\\cdot \\dfrac{1}{1024}\$

$= mat(delim: "[", 1\,sqrt(2) / 2 + frac(i sqrt(2), 2)\,i\,- sqrt(2) / 2 + frac(i sqrt(2), 2); 1\,- sqrt(2) / 2 - frac(i sqrt(2), 2)\,i\,sqrt(2) / 2 - frac(i sqrt(2), 2); 1\,sqrt(2) / 2 - frac(i sqrt(2), 2)\,- i\,- sqrt(2) / 2 - frac(i sqrt(2), 2); 1\,- sqrt(2) / 2 + frac(i sqrt(2), 2)\,- i\,sqrt(2) / 2 + frac(i sqrt(2), 2))$
$dot.op mat(delim: "[", 2.2998046875; - 1.1669921875; 1.4501953125; - 2.8642578125)$

$$

$approx\(3.500 - 1.4003 i\,upright(" ") 1.0997 + 4.3007 i\,upright(" ") 3.500 + 1.4003 i\,upright(" ") 1.0997 - 4.3007 i\)$

$$

Extract the first $n / 2 = 2$ elements in the above Hermitian vector to
recover the input vector:

$\(3.500 - 1.4003 i\,upright(" ") 1.0997 + 4.3007 i\)$

$approx\(3.5 - 1.4 i\,upright(" ") 1.1 + 4.3 i\)$
$= arrow(v)^(chevron.l h = 1 chevron.r)$ $gt.tri$ The original input
vector $arrow(v)$ rotated by 1 position to the left

$$

In practice, we do not directly update $Delta M\(X\)$ to
$Delta M\(X^(J\(1\))\)$, because we would not have access to the
plaintext polynomial $M\(X\)$ unless we have the secret key $S\(X\)$.
Therefore, we instead update
$sans("ct") = bold(\() A\(X\)\,B\(X\)bold(\))$ to
$sans("ct")^(chevron.l h = 1 chevron.r) = bold(\() A\(X^(J\(1\))\)\,B\(X^(J\(1\))\)bold(\))$,
which is equivalent to homomorphically rotating the encrypted input
vector slots. Then, decrypting $sans("ct")^(chevron.l h = 1 chevron.r)$
and decoding it would output $arrow(v)^(chevron.l h = 1 chevron.r)$.

$$

Examples of CKKS's homomorphic input vector slot rotation can be
executed by running
#link("https://github.com/fhetextbook/fhe-textbook/blob/main/source%20code/ckks.py")[#underline[this Python script]].

== Contemplation on CKKS Encoding
<subsec:ckks-encoding-contemplate>
At this point, it becomes clear why the CKKS encoding and decoding
scheme uses the (power-of-2)-th cyclotomic polynomial (i.e., $X^n + 1$)
over $X in bb(C)$ (complex numbers)
(#link(<subsec:ckks-encoding-decoding>)[0.1]). The first reason is that
CKKS's first requirement for designing a valid encoding and decoding
formula for an input complex vector is to isomorphically convert it into
a unique real number vector (and we scale this real number vector as an
integer vector and use it as a list of coefficients for polynomial
encoding, because CKKS's homomorphic encryption and decryption are
supported only based on polynomials with integer coefficients). As for
the decoding formula of an input complex vector, our high-level idea was
to treat the encoded real number vector as coefficients of an
$\(n - 1\)$-degree polynomial and evaluate this polynomial at $n$
distinct $X$ coordinates, whose resulting set of $n$ distinct $Y$ values
is guaranteed to be unique within the $n$-th degree polynomial ring.
Based on this insight, we designed a decoding matrix
(#link(<subsec:ckks-encoding-decoding>)[0.1]) in the form of a
Vandermonde matrix
(#link(<subsec:vandermonde>)[\[subsec:vandermonde\]]). Then, the
encoding formula is equivalent to multiplying the input complex vector
by the inverse of this decoding matrix. However, in linear algebra, not
all matrices are guaranteed to have a counterpart inverse matrix.
Therefore, for the guarantee of the existence of a valid encoding matrix
(i.e., an inverse of the decoding matrix), we leveraged the following
arithmetic property: if a Vandermonde matrix
$V = italic(V a n d e r)\(x_0\,x_1\,dots.h.c\,x_(n - 1)\)$ is made of
$n$ distinct primitive $\(mu = 2 n\)$-th roots of unity (where $n$ is a
power of 2), then such a Vandermonde matrix is guaranteed to have an
inverse
(#link(<subsec:vandermonde-euler>)[\[subsec:vandermonde-euler\]])
counterpart. In fact, the $\(mu = 2 n\)$-th roots of unity are $n$
distinct roots of the $\(mu = 2 n\)$-th cyclotomic polynomial: $X^n + 1$
(#link(<subsec:cyclotomic-def>)[\[subsec:cyclotomic-def\]]). Therefore,
CKKS uses $X^n + 1$ as the polynomial ring of its subsequent encryption
and decryption scheme (#link(<subsec:ckks-enc-dec>)[0.2]) as well.

The CKKS encoding's second reason for using the $\(mu = 2 n\)$-th
cyclotomic polynomial is to design a valid input vector slot rotation
scheme (#link(<subsec:ckks-rotation>)[0.9]). In this rotation scheme,
updating the encoded polynomial $M\(X\)$ to $M\(X^(J\(h\))\)$ (where
$J\(h\)= 5^h med mod med 2 n$) is equivalent to updating the CKKS
decoding process's each evaluation coordinate of $M\(X\)$ from $x_i$ to
$x_i^(J\(h\))$ (where each $x_i$ is the primitive $\(mu = 2 n\)$-th
roots of unity), which gives the same effect as vertically rotating the
encoding matrix (i.e., the inverse of the Vandermonde matrix whose roots
are the primitive $\(mu = 2 n\)$-th roots of unity) upward by $h$
positions. And this vertical rotation of the encoding matrix (while the
input vector is fixed) gives the same effect of rotating the input
vector $arrow(v)$ by $h$ positions to the left (without modifying the
encoding matrix). Therefore, the $\(mu = 2 n\)$-th cyclotomic polynomial
$X^n + 1$ is an ideal tool to design input vector slot rotation.

== Homomorphic Conjugation
<subsec:ckks-conjugation>
As explained in Summary~@subsec:ckks-encoding-decoding
(#link(<subsec:ckks-encoding-decoding>)[0.1]), given the
$n / 2$-dimensional input vector
$arrow(v) =\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\)$, its corresponding
$n$-dimensional Hermitian vector is
$arrow(v)_(') =\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\,overline(v)_0\,overline(v)_1\,dots.h.c\,overline(v)_(n / 2 - 1)\)$.
To compute the conjugation of $arrow(v)$, which is essentially
conjugating $arrow(v)_(')$, we can conjugate $M\(X\)$ as follows:

$overline(arrow(v))_(') =\(overline(v)_0\,overline(v)_1\,dots.h.c\,overline(v)_(n / 2 - 1)\,v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\)$

$= bold(\() M\(overline(omega)\)\,M\(overline(omega^3)\)\,dots.h.c\,M\(overline(omega^(n - 1))\)\,M\(omega\)\,M\(omega^3\)\,dots.h.c\,M\(omega^(n - 1)\)bold(\))$
$gt.tri$ where $omega = e^(frac(i pi, n))$

$= bold(\() M\(\(omega\)^(- 1)\)\,M\(\(omega^3\)^(- 1)\)\,dots.h.c\,M\(\(omega^(n - 1)\)^(- 1)\)\,M\(omega\)\,M\(omega^3\)\,dots.h.c\,M\(omega^(n - 1)\)bold(\))$

$gt.tri$ since
$overline(omega^k) = e^(overline(frac(k i pi, n))) = e^(- frac(k i pi, n)) = omega^(- k)$
and $omega^k =\(overline(omega^k)\)^(- 1)$ for
$k = { 1\,3\,dots.h.c\,n - 1 }$

$$

$= { M\(X^(- 1)\)}$

$gt.tri$ where
$X = { omega\,omega^3\,dots.h.c\,omega^(n - 1)\,omega^(- 1)\,omega^(- 3)\,dots.h.c\,omega^(-\(n - 1\)) } = { omega\,omega^3\,dots.h.c\,omega^(n - 1)\,omega^(2 n - 1)\,omega^(2 n - 3)\,dots.h.c\,omega^(n + 1) }$

$$

Therefore, homomorphic conjugation of the input vector is equivalent to
updating the ciphertext $bold(\() A\(X\)\,B\(X\)bold(\))$ to
$bold(\() A\(X^(- 1)\)\,B\(X^(- 1)\)bold(\))$ and then key-switching it
from $S\(X^(- 1)\)arrow.r S\(X\)$.

#block[
Homomorphic conjugation of the input vector of a ciphertext is
equivalent to the following:

+ Update the ciphertext $bold(\() A\(X\)\,B\(X\)bold(\))$ to
  $bold(\() A\(X^(- 1)\)\,B\(X^(- 1)\)bold(\))$.

+ Key-switch $bold(\() A\(X^(- 1)\)\,B\(X^(- 1)\)bold(\))$ from
  $S\(X^(- 1)\)$ to $S\(X\)$.

]
== Sparsely Packing Ciphertexts
<subsec:ckks-sparse-packing>
In #link(<subsec:ckks-encoding-decoding>)[0.1], we learned the CKKS
encoding scheme, which encodes an input vector with $n / 2$ slots (i.e.,
$n / 2$-dimensional input vector) into an $\(n - 1\)$-degree polynomial.
While the polynomial ring's degree $n$ is fixed at the setup stage of
CKKS as a security parameter, some applications may only need to use
fewer than $n / 2$ input vector slots. Suppose we only need to use
$n' / 2$ slots out of $n / 2$ slots, where $n'$ is some number that
divides $n$. Then, the corresponding input vector and encoded polynomial
acquire a special property as described below:

#block[
Suppose that an $n / 2$-dimensional input vector gets encoded into a
polynomial in $bb(R)\[X\]\/\(X^n + 1\)$. And suppose that $n'$ is some
number that divides $n$. We define polynomial
$M\(X\)in bb(R)\[X\]\/\(X^n + 1\)$ as the one which has non-zero
constants at the terms whose power is a multiple of $n / n'$ and all
other terms have zero constants (i.e.,
$M\(X\)= c_0 + c_(n / n') X^(n / n') + c_(frac(2 n, n')) X^(frac(2 n, n')) + dots.h.c + c_(n - n / n') X^(n - n / n')$).
We can express $M\(X\)$ as some $M_Y\(Y\)in bb(R)\[Y\]\/\(Y^(n') + 1\)$
where $Y = X^(n / n')$ and thus $M\(X\)= M_Y\(X^(n / n')\)$.

$$

Then, the following are true:

+ Every $M_Y\(Y\)in bb(R)\[Y\]\/\(Y^(n') + 1\)$ is isomorphically mapped
  to (i.e., decoded into) some $n / 2$-dimensional input vector which
  comprises $n / n'$ repetitions of $n' / 2$ consecutive slot values.

+ Conversely, if an $n / 2$-dimensional input vector comprises $n / n'$
  repetitions of the first $n' / 2$ consecutive slot values, then the
  vector gets encoded into some $M_Y\(Y\)in bb(R)\[Y\]\/\(Y^(n') + 1\)$
  (i.e., some polynomial in $bb(R)\[X\]\/\(X^n + 1\)$ that has zero
  constants at the terms whose degree is not a multiple of $n / n'$).

]
We could show both directions of proof: (1) the forward
(decoding-direction) proof; and (2) the backward (encoding-direction)
proof. However, it is sufficient to prove only either direction because
the encoding ($sigma^(- 1)$) and decoding ($sigma$) processes are
isomorphic. Among these two, we will show only the forward proof for
simplicity.

=== Forward Proof: Decoding of Sparsely Packed Ciphertext
<forward-proof-decoding-of-sparsely-packed-ciphertext>
We will prove that for each $M_Y\(Y\)in bb(R)\[Y\]\/\(Y^(n') + 1\)$
(i.e., a polynomial in $bb(R)\[X\]\/\(X^n + 1\)$ that has non-zero
constants only at those terms with a power that is a multiple of
$n / n'$ and zero constants in all other terms), the polynomial is
decoded into some $n / 2$-dimensional input vector which comprises
$n / n'$ repetitions of the first $n' / 2$ consecutive slot values.

To decode $M\(X\)$ into an input vector, we need to evaluate $M\(X\)$ at
$n / 2$ distinct roots of $X^n + 1$ (i.e., $n$ distinct primitive
$\(mu = 2 n\)$-th roots of unity), which are:

$bold(\() upright(" ") M\(omega^(J\(0\))\)\,upright(" ") M\(omega^(J\(1\))\)\,dots.h.c\,M\(omega^(J\(n / 2 - 1\))\)bold(\))$

$gt.tri$ where $omega = e^(frac(i pi, n))$, the base and generator of
the primitive ($mu = 2 n$)-th roots of unity

$$

But since $M\(X\)= M_Y\(X^(n / n')\)$, the above evaluation is
equivalent to evaluating:

$bold(\() upright(" ") M_Y\(\(omega^(J\(0\))\)^(n / n')\)\,upright(" ") M_Y\(\(omega^(J\(1\))\)^(n / n')\)\,dots.h.c\,M_Y\(\(omega^(J\(n / 2 - 1\))\)^(n / n')\)bold(\))$

$$

$= bold(\() upright(" ") M_Y\(\(omega^(n / n')\)^(J\(0\))\)\,upright(" ") M_Y\(\(omega^(n / n')\)^(J\(1\))\)\,dots.h.c\,M_Y\(\(omega^(n / n')\)^(J\(n / 2 - 1\))\)bold(\))$

$$

$= bold(\() upright(" ") M_Y\(xi^(J\(0\))\)\,upright(" ") M_Y\(xi^(J\(1\))\)\,dots.h.c\,M_Y\(xi^(J\(n / 2 - 1\))\)bold(\))$

$gt.tri$ where $xi = e^(frac(i pi, n'))$, the base and generator of the
primitive $\(mu = 2 n'\)$-th roots of unity

$$

Notice that $xi = omega^(n / n')$. Therefore, the above evaluation of
$M_Y\(Y\)$ outputs $n / n'$ repeated values of $M_Y\(Y\)$ evaluated at
$n' / 2$ distinct primitive $\(mu = 2 n'\)$-th roots of unity.

== Modulus Bootstrapping
<subsec:ckks-bootstrapping>
#strong[\- Reference:]
#link("https://eprint.iacr.org/2018/153.pdf")[Bootstrapping for Approximate Homomorphic Encryption]~@ckks

During CKKS's ciphertext-to-ciphertext multiplication, each ciphertext
is associated with a particular multiplicative level and it decreases by
1 upon each ciphertext-to-ciphertext multiplication (by its internal
modulus rescaling operation). Reaching multiplicative level 0 is
equivalent to reaching the end of a ciphertext's modulus chain and no
more ciphertext-to-ciphertext multiplication can be performed. To
continue with further ciphertext-to-ciphertext multiplication, CKKS
provides a special operation called #emph[bootstrapping], which is a
process of resetting the ciphertext's end-of-chain modulus $q_0$ to the
initial maximum modulus $q_L$ (which is either $q_0 dot.op Delta^L$ in
the vanilla rescaling scheme, or $product_(m = 0)^L w_m$ in the case of
using CRT, as explained in
#link(<subsubsec:ckks-mult-cipher-rescale>)[0.5.4]).

Suppose we have a ciphertext $\(A\,B\)$ with multiplicative depth 0. If
we decrypt a ciphertext whose multiplicative level is 0 (i.e., the
ciphertext's modulus is $q_0$), then decrypting it #emph[without]
reduction modulo $q_0$ would output:

$sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")")$

$= B + A dot.op S = Delta M + E + q_0 dot.op K$ $gt.tri$ since
$B + A dot.op S med mod med q_0 = Delta M + E$

, where $q_0 dot.op K$ accounts for wrap-around modulo $q_0$ values--
each coefficient of polynomial $q_0 K$ is some multiple of $q_0$. CKKS's
bootstrapping procedure is equivalent to #emph[safely] transforming a
ciphertext's modulus from $q_0$ to $q_L$ (where $q_L gt.double q_0$).

=== High-level Idea
<subsubsec:ckks-bootstrapping-high-level>
As the first step of bootstrapping, we forcibly change the modulus of
the ciphertext $\(A\,B\)$ from $q_0$ to $q_L$. Then, its decryption with
reduction modulo $q_L$ would output:

$sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") med mod med q_L$

$= B + A dot.op S med mod med q_L$

$= Delta M + E + q_0 K med mod med q_L$

Here, we assume that $q_L$ is large enough such that
$Delta M + E + q_0 K lt.double q_L$. This is true given $S$ has small
coefficients which are either ${ - 1\,0\,1 }$, and thus the coefficients
of $B + A dot.op S$ would not grow much.

In the $Delta M + E + q_0 K med mod med q_L$ term, notice that because
of the $q_0 K$ term which is not modulo-reduced by $q_0$ anymore, the
ciphertext's decrypted plaintext polynomial's each $i$-th term would get
a corrupted coefficient
$Delta m_i + e_i + q_0 dot.op k_i med mod med q_L$ instead of
$Delta m_i + e_i med mod med q_L$. So, we now need to eliminate the
garbage term $q_0 dot.op k_i med mod med q_L$ in each coefficient and
distill the pure plaintext coefficient $Delta m_i + e_i$.

#figure(image("figures/modulo-reduction-sine.png", width: 100.0%),
  caption: [
    Sine function
    $f\(x\)= frac(q_0, 2 pi) dot.op sin (frac(2 pi x, q_0))$ such that
    $f\(Delta m_i + e_i + q_0 k_i\)approx Delta m_i + e_i$ (provided
    $Delta m_i + e_i lt.double q_0$)
    #link("https://eprint.iacr.org/2018/153.pdf")[\(Source)]
  ]
)
<fig:modulo-reduction-sine>

To do so, we will take an approximated approach by using a sine function
described in #link(<fig:modulo-reduction-sine>)[1], which has a period
of $q_0$ with the amplitude $frac(q_0, 2 pi)$. This sine function has
the following two useful properties:

+ When $f\(x\)$ is evaluated at $x$ values near the multiple of $q_0$,
  the result approximates to that of a line function $y = x$. This is
  because the derivative (slope) of $sin x$ is $y' = cos x$, and if $x$
  is a multiple of $2 pi$, the slope is: $y' = cos 2 pi = 1$.

+ The evaluation of $f\(x\)$ eliminates the multiples of $q_0$ from the
  input (i.e., modulo reduction $q_0$)

$$

Combining these two properties, given input
$x = Delta m_i + e_i + q_0 k_i$,

$f\(Delta m_i + e_i + q_0 k_i\)= frac(q_0, 2 pi) dot.op sin (frac(2 pi dot.op\(Delta m_i + e_i + q_0 k_i\)\), q_0)) = frac(q_0, 2 pi) dot.op sin (frac(2 pi dot.op\(Delta m_i + e_i\)\), q_0)) approx Delta m_i + e_i$

$$

, provided $Delta m_i + e_i$ is very close to 0 relative to $q_0$ (i.e.,
$Delta m_i + e_i lt.double q_0$). This is true, because by construction
of the CKKS scheme, the plaintext modulus (even with scaling it up by
$Delta$), is significantly smaller than the ciphertext modulus.
Therefore, to remove $q_0 K$ from $Delta M + E + q_0 K$, we can update
each coefficient of the polynomial $Delta M + E + q_0 K$ by evaluating
it with the $f\(x\)$ sine function. However, we cannot directly update
the coefficients of the polynomial, because the CKKS scheme (the RLWE
scheme in general) only supports the input vector's slot-wise
$\(+\,dot.op\)$ operations. Therefore, to update the polynomial
coefficients, we need to express the update logic in terms of slot-wise
input vector arithmetic $\(+\,dot.op\)$. Considering all these, CKKS's
overall bootstrapping procedure is described in
#link(<tab:ckks-bootstrapping-procedure>)[1].

#block[
#figure(
  align(center)[#table(
    columns: 2,
    align: (left,left,),
    [1], [#strong[#underline[ModRaise:]] Given ciphertext
    $\(A\,B\)med mod med q_0$, we forcibly raise its modulus from $q_0$
    to $q_L$.],
    [], [Then, it ends up encrypting $Delta M + E + q_0 k$ instead of
    $Delta M + E$.],
    [2], [#strong[#underline[CoeffToSlot:]] Based on step 1's ciphertext
    $\(A\,B\)med mod med q_L$, we generate a new ciphertext],
    [], [that encrypts an input vector whose its each $i$-th slot stores
    $Delta m_i + e_i + q_0 k_i$.],
    [], [This is equivalent to moving the coefficients of polynomial
    $Delta M + E + q_0 K$ to],
    [], [the input vector slots.],
    [3], [#strong[#underline[EvalExp:]] We convert the sine function
    into an approximated polynomial by using],
    [], [the Taylor series, as well as other optimizations such as],
    [], [Euler's formula
    ($e^(i theta) = cos\(theta\)+ i dot.op sin\(theta\)$). Then, we
    generate a CKKS plaintext that encodes],
    [], [this approximated sine function, and then use this to
    homomorphically evaluate],
    [], [step 2's encrypted vector elements (to homomorphically remove
    every coefficient's $q_0 k_i$).],
    [4], [#strong[#underline[SlotToCoeff:]] Based on the resulting
    ciphertext from step 3, we generate a new ciphertext],
    [], [whose encrypted polynomial's each $i$-th coefficient is
    (approximately) $Delta m_i + e_i$.],
    [], [This is equivalent to moving the $q_0 k_i$-eliminated values
    stored in the input vector slots in],
    [], [step 3 back to the positions of the polynomial coefficients.
    The final ciphertext is],
    [], [our goal ciphertext that (approximately) encrypts $Delta M + E$
    under modulus $q_L$.],
  )]
  , caption: [High-level Description of CKKS's Bootstrapping Procedure]
  , kind: table
  )

] <tab:ckks-bootstrapping-procedure>
=== Mathematical Expansion of the High-level Idea
<subsubsec:ckks-bootstrapping-high-level-correctness>
We will mathematically walk through how the bootstrapping procedure
(#link(<tab:ckks-bootstrapping-procedure>)[1]) correctly updates the
modulus of the input ciphertext from $q_0$ to $q_L$.

For ease of understanding, we will first explain how we would do modulus
bootstrapping for a ciphertext with multiplicative level 0 (i.e., its
modulus is $q_0$) in case we have access to the secret key $S\(X\)$.
Using this key, we can decrypt the ciphertext as follows:

$sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")")$ $gt.tri$
where
$sans("ct") =\(A\,B\)= sans("RLWE")_(S\,sigma) bold(\() Delta M bold(\))$

$= B + A dot.op S = Delta M + E med mod med q_0$

$= Delta M + E + q_0 K$ $gt.tri$ where $q_0 K$ accounts for any
potential wrap-around modulo $q_0$ values

Our initial goal is to bootstrap the modulus of the ciphertext from
$q_0$ to $q_L$ by using only the following three tools:

- Secret key $S$

- Batch-encoding ($sigma^(- 1)$) and decoding ($sigma$) formulas

- Batched slot-wise $\(+\,dot.op\)$ operation of input vectors based on
  their batch-encoded polynomials

$$

After explaining the above, we will then explain how to achieve the same
bootstrapping without having access to the secret key $S$.

$$

This step forcibly changes the ciphertext's modulus from $q_0$ to $q_L$
and then decrypts the ciphertext as follows:

$sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") = B + A dot.op S = Delta M + E + q_0 K med mod med q_L$

Notice that the ciphertext's decrypted plaintext polynomial's each
$i$-th coefficient gets corrupted to
$Delta m_i + e_i + q_0 dot.op k_i med mod med q_L$. So, we now need to
eliminate the garbage term $q_0 k_i med mod med q_L$ in each coefficient
and distill the pure plaintext coefficient $Delta m_i + e_i$.

$$

This step generates a new plaintext polynomial whose each $i$-th input
vector slot stores the corrupted coefficient $\(m_i + e_i + q_0 k_i\)$.
The trick of doing this is to apply CKKS's batch-encoding mapping
$sigma^(- 1)$ (which represents the transformation
\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$
as explained in #link(<subsec:ckks-encoding-decoding>)[0.1]) to the
input vector slots that encode the polynomial
$Delta M + E + q_0 K med mod med q_L$. Let $arrow(v)_c$ be the input
vector that corresponds to polynomial $Delta M + E + q_0 K$. Then,
$arrow(v)_c$ and $Delta M + E + q_0 K$ satisfy the following relation
over the encoding mapping $sigma^(- 1)$:

$sigma^(- 1) bold(\() arrow(v)_c bold(\)) = M_c = sum_(i = 0)^(n - 1)\(Delta m_i + e_i + q_0 k_i\)dot.op X^i$
$gt.tri$ i.e., polynomial $Delta M + E + q_0 K$

This implies that if we #emph[homomorphically] apply the $sigma^(- 1)$
transformation to the elements of the input vector $arrow(v)_c$, then
the resulting input vector $arrow(v)_s$ will store $arrow(v)_c$'s
encoded polynomial coefficient values as follows:

$sigma^(- 1) compose arrow(v)_c = arrow(v)_s =\(Delta m_0 + e_0 + q_0 k_0\,upright(" ") Delta m_1 + e_1 + q_0 k_1\,upright(" ") dots.h.c\,upright(" ") Delta m_(n - 1) + e_(n - 1) + q_0 k_(n - 1)\)$

$gt.tri$ where $compose$ represents a linear transformation operation
comprising $\(+\,dot.op\)$

$$

However, remember that at the end of the ModRaise step, we get the
decrypted (but corrupted by $q_0 k$) polynomial
$M_c = sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(\)) = Delta M + E + q_0 K$
and we are not allowed to decode it into $arrow(v)_c$. Therefore, we
will instead #emph[encode] the matrix \$\\hathat W \\cdot I\_n^R\$ in
the encoding transformation $sigma^(- 1)$
(\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$)
into its equivalent polynomials (treating a matrix as a combination of
vectors) and then perform batched slot-wise $\(+\,dot.op\)$ operation
between $M_c$ and the polynomial version of
\$\\hathat W \\cdot I\_n^R\$. We express this polynomial-based
computation as follows:

$M_s = sigma_(sigma^(- 1))^(- 1) compose M_c med mod med q_L$ $gt.tri$
$sigma_(sigma^(- 1))^(- 1)$ is the polynomial-encoded version of the
$sigma^(- 1)$ transformation

Then, the resulting polynomial $M_s$'s corresponding input vector slots
(i.e., the decoded version of $M_s$) will store
$arrow(v)_s =\(Delta m_0 + e_0 + q_0 k_0\,upright(" ") Delta m_1 + e_1 + q_0 k_1\,upright(" ") dots.h.c\,upright(" ") Delta m_(n - 1) + e_(n - 1) + q_0 k_(n - 1)\)$.
In other words, the above computation effectively #emph[moves] the
coefficients of $M_c$ to the input vector slots of a new plaintext
polynomial.

However, remember that in CKKS, an input vector can store only up to
$n / 2$ slots, whereas we need to store a total of $n$ coefficients of
$M_c$ in the input vector slots. Therefore, we technically need to
create 2 pieces of $M_s$ as $M_(s 1)$ and $M_(s 2)$, where the input
vector of $M_(s 1)$ stores
$\(Delta m_0 + e_0 + q_0 k_0\,upright(" ") Delta m_1 + e_1 + q_0 k_1\,upright(" ") dots.h.c\,upright(" ") Delta m_(n / 2 - 1) + e_(n / 2 - 1) + q_0 k_(n / 2 - 1)\)$,
and the input vector of $M_(s 2)$ stores
$\(Delta m_(n / 2) + e_(n / 2) + q_0 k_(n / 2)\,upright(" ") dots.h.c\,upright(" ") Delta m_(n - 1) + e_(n - 1) + q_0 k_(n - 1)\)$.

$$

Our next step is to update $arrow(v)_s$'s each element
$m_i + e_i + q_0 k_i$ to $m_i + e_i$ by evaluating it with the sine
function $f\(x\)$. Since the output of the CoeffToSlot step is
polynomial $M_s$ (technically $M_(s 1)$ and $M_(s 2)$), we need to apply
the evaluation transformation in an encoded form. First, we approximate
$f\(x\)$ as a linear combination comprising only $\(+\,dot.op\)$
operations by using the Taylor series and Euler's formula (will be
explained later). Then, we encode (i.e., $sigma$) the approximated
formula into a polynomial form, and we denote it as $sigma_f$. Finally,
we apply the $sigma_f$ transformation to $M_s$ as follows:

$sigma_f^(- 1) compose M_s med mod med q_L$ $gt.tri$ Applying the sine
function's linear transformation to $arrow(v)_s$'s each slot storing
$Delta m_i + e_i + q_0 k_i$

$= M_t = sigma bold(\() arrow(v)_t bold(\)) = sigma bold(\()\(Delta m_i + e_i\)_(i = 0)^(n - 1)bold(\)) med mod med q_L$

$$

After the linear transformation by the sine function, notice that each
$q_0 k_i$ term gets eliminated from $arrow(v)_s$'s slots (i.e. modulo
reduction by $q$) and the resulting vector $arrow(v)_t$ stores only the
$Delta m_i + e_i$ terms.

$$

Now that we have a polynomial $M_t$ whose corresponding input vector
$arrow(v)_t$'s slots store garbage-removed coefficients of (i.e.,
$Delta m_i + e_i$) our initial plaintext polynomial, our next step is to
put these coefficients stored in $arrow(v)_t$ back to the polynomial.
This is an exact reverse operation of CoeffToSlot as follows:

$sigma_sigma^(- 1) compose M^t = M_b$ $gt.tri$ $sigma_sigma^(- 1)$ is a
polynomial-encoded form of the batch-decoding formula
\$\\vec{v}\_{\'} = \\hathat W^\* \\cdot \\vec{m}\$
(#link(<subsec:ckks-encoding-decoding>)[0.1])

The result is polynomial $M_b$ whose coefficients are garbage-eliminated
(i.e., $q_0 k_i$-free) versions of $M_c$. Finally, we re-encrypt $M_b$
as $sans("RLWE")_(S\,sigma)\(M_b\)$ as the final modulus-bootstrapped
ciphertext.

$$

So far, we have assumed that we have access to the secret key $S$. With
decryption and re-encryption enabled, the above bootstrapping steps
described are mathematically equivalent to computing the following:

+ #strong[#underline[INPUT]:] $sans("ct") =\(A\,B\)med mod med q_0$
  $gt.tri$ where
  $sans("ct") =\(A\,B\)= sans("RLWE")_(S\,sigma) bold(\() Delta M bold(\))$

+ #strong[#underline[ModRaise]:] $sans("ct") =\(A\,B\)med mod med q_L$

+ #strong[#underline[Decryption]:]
  $sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") bold(")") med mod med q_L$

+ #strong[#underline[CoeffToSlot]:]
  $sigma_(sigma^(- 1))^(- 1) compose sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") bold(")") med mod med q_L$

+ #strong[#underline[EvalExp]:]
  $sigma_f^(- 1) compose\(sigma_(sigma^(- 1))^(- 1) compose sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") bold(")")\)med mod med q_L$

+ #strong[#underline[SlotToCoeff]:]
  $sigma_sigma^(- 1) compose\(sigma_f^(- 1) compose\(sigma_(sigma^(- 1))^(- 1) compose sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") bold(")")\)\)med mod med q_L$

+ #strong[#underline[Re-encryption]:]
  $sans("RLWE")_(S\,sigma) bold(\() sigma_sigma^(- 1) compose\(sigma_f^(- 1) compose\(sigma_(sigma^(- 1))^(- 1) compose sans("RLWE")^(- 1) bold("(") sans("ct") =\(A\,B\)bold(")") bold(")")\)\)bold(\)) med mod med q_L$

$$

However, the ultimate goal of CKKS bootstrapping is to reset the modulus
of a ciphertext from $q_0$ to $q_L$ without having access to $S$.

Meanwhile, one important insight is that CKKS's ModRaise procedure on
the ciphertext $\(A\,B\)med mod med q_0$ from $q_0 arrow.r q_L$
effectively transforms the ciphertext into a new one which is an
encryption of $Delta M + q_0 K$. Before ModRaise, ciphertext
$\(A\,B\)med mod med q_0$'s decryption relation is as follows:

$A dot.op A + B = Delta M + E + K q_0 med mod med q_0 = Delta M + E$

$$

After ModRaise to $\(A\,B\)med mod med q_L$, its decryption relation is
as follows:

$A dot.op S + B = Delta M + E + K q_0 med mod med q_L = Delta M + E + K q_0$
$gt.tri$ because $Delta M + E + K q_0 lt.double q_L$

$$

Therefore, the #emph[mod-raised] ciphertext
$\(A\,B\)med mod med q_L = sans("RLWE")_(S\,sigma)\(Delta M + K q_0\)$
with noise $E$. Thus, CKKS's #emph[homomorphic] bootstrapping strategy
is to run the subsequent CoeffToSlot, EvalExp, and SlotToCoeff steps
homomorphically based on the ciphertext $\(A\,B\)med mod med q_L$.
Running these 3 steps consumes a few multiplicative levels due to the
ciphertext-to-ciphertext multiplication operations when homomorphically
multiplying the coefficient-to-slot and slot-to-coefficient
transformation matrices and homomorphically computing powers of $X$
(i.e., $X^k$) during sine approximation. Therefore, upon completion of
these 3 steps, the ciphertext modulus reduces from $q_L arrow.r q_l$
(where $l$ is some integer such that $l < L$).

Note that the result of homomorphic bootstrapping is equal to the
explicit bootstrapping based on decryption & re-encryption (if we ignore
the small differences in the final ciphertext modulus and the noise). In
the following subsections, we will explain the algebraic details of
CoeffToSlot, EvalExp and SlotToCoeff steps.

=== Details: CoeffToSlot
<subsubsec:ckks-bootstrapping-coefftoslot-details>
Homomorphically moving the coefficients of $M_c$ (i.e.,
$Delta m_i + e_i + q_0 k_i$ for $0 lt.eq i lt.eq n - 1$) to a new
ciphertext's input vector slots is mathematically equivalent to
homomorphically computing
$sigma_(sigma^(- 1))^(- 1) compose\(sans("RLWE")_(S\,sigma) bold(\() sans("ct") =\(A\,B\)bold(\))\)$,
which is equivalent to applying the encoding formula to the input vector
slot values of
$sans("RLWE")_(S\,sigma) bold(\() sans("ct") =\(A\,B\)bold(\))$.

As explained in Summary~@subsec:ckks-rotation (in
#link(<subsec:ckks-rotation>)[0.9]), the encoding formula for converting
an input vector into a list of polynomial coefficients is
\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$,
where \$\\hathat W\$ is a basis of the $n$-dimensional vector space
crafted as follows:

$$

$$

$gt.tri$ where the rotation helper function
$J\(h\)= 5^h med mod med 2 n$

$$

Therefore, given the input ciphertext
$sans("ct")_(sans("c")) = sans("RLWE")_(S\,sigma) bold(\() sans("ct") =\(A\,B\)bold(\)) med mod med q_L$
whose plaintext polynomial $M_c$ contains corrupted coefficients,
computing
$sigma_(sigma^(- 1))^(- 1) upright(" ") compose upright(" ") sans("ct")_(sans("c"))$
is equivalent to computing
\$\\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\textsf{ct\\textsubscript{c}}}{n}\$.
However, one problem here is that each CKKS ciphertext encodes only
$n / 2$ input vector slots, whereas our goal is to move $n$ (corrupted)
coefficients of the plaintext polynomial $M_c$ encrypted in
\$\\textsf{ct\\textsubscript{c}}\$. Therefore, we will instead generate
2 ciphertexts, $sans("ct")_(sans("s1"))$ and $sans("ct")_(sans("s2"))$,
such that each $sans("ct")_(sans("s1"))$'s input vector slots store
$\(Delta m_i + e_i + q_0 k_i\)_(0 lt.eq i < n / 2)$ and
$sans("ct")_(sans("s2"))$'s input vector slots store
$\(Delta m_i + e_i + q_0 k_i\)_(n / 2 lt.eq i < n)$.

We will leverage the following matrix split technique. When we split an
$n times n$ matrix \$\\hathat{W}\$ into four $n / 2 times n / 2$ blocks
to multiply it by the vector $arrow(v)'$, the standard matrix
multiplication is as follows:

\$\$\\begin{bmatrix} \\hathat{W}\_{11} & \\hathat{W}\_{12} \\\\ \\hathat{W}\_{21} & \\hathat{W}\_{22} \\end{bmatrix} \\begin{bmatrix} \\vec{a} \\\\ \\vec{b} \\end{bmatrix} = \\begin{bmatrix} \\hathat{W}\_{11}\\vec{a} + \\hathat{W}\_{12}\\vec{b} \\\\ \\hathat{W}\_{21}\\vec{a} + \\hathat{W}\_{22}\\vec{b} \\end{bmatrix}\$\$

In our case, $arrow(a) =\(v_0\,dots.h\,v_(n / 2 - 1)\)$ (the first half
of $arrow(v)'$), and
$arrow(b) =\(overline(v)_0\,dots.h\,overline(v)_(n / 2 - 1)\)$ (the
second half of $arrow(v)'$).

$$

Therefore, We split the $n times n$ matrix \$\\hathat W\$ into four
$n / 2 times n / 2$ matrices as follows:

- \$\[\\hathat W\]\_{11}\$: a matrix comprising the upper left-half
  section of \$\\hathat W\$

- \$\[\\hathat W\]\_{12}\$: a matrix comprising the upper right-half
  section of \$\\hathat W\$

- \$\[\\hathat W\]\_{21}\$: a matrix comprising the lower left-half
  section of \$\\hathat W\$

- \$\[\\hathat W\]\_{22}\$: a matrix comprising the lower right-half
  section of \$\\hathat W\$

$$

Then, we can compute $sans("ct")_(sans("s1"))$ and
$sans("ct")_(sans("s2"))$ as follows:

\$\\textsf{ct}\_{\\textsf{s1}} = \\dfrac{\[\\hathat W\]\_{11} \\cdot I\_{\\frac{n}{2}}^R \\cdot \\mathit{\\overline{\\textsf{ct\\textsubscript{c}}}} + \[\\hathat W\]\_{12} \\cdot I\_{\\frac{n}{2}}^R \\cdot \\textsf{ct\\textsubscript{c}}}{n}\$

\$\\textsf{ct}\_{\\textsf{s2}} = \\dfrac{\[\\hathat W\]\_{21} \\cdot I\_{\\frac{n}{2}}^R \\cdot \\mathit{\\overline{\\textsf{ct\\textsubscript{c}}}} + \[\\hathat W\]\_{22} \\cdot I\_{\\frac{n}{2}}^R \\cdot \\textsf{ct\\textsubscript{c}}}{n}\$

, where \$\\mathit{\\overline{\\textsf{ct\\textsubscript{c}}}}\$ can be
computed by applying homomorphic conjugation to ct#sub[c]
(#link(<subsec:ckks-conjugation>)[0.11]). Each homomorphic matrix-vector
multiplication (e.g.,
\$\[\\hathat W\]\_{21} \\cdot I^R\_{\\frac{n}{2}}\\overline{\\textsf{ct\\textsubscript{c}}}\$)
can be done in an efficient manner that reduces the number of
homomorphic rotations
(#link(<subsec:bfv-matrix-multiplication>)[\[subsec:bfv-matrix-multiplication\]]).

=== Details: EvalExp
<subsubsec:ckks-bootstrapping-evalexp-details>
We will use the sine function
$f\(x\)= frac(q_0, 2 pi) dot.op sin (frac(2 pi x, q_0))$ to
approximately eliminate $q_0 k_i$ from $Delta m_i + e_i + q_0 k_i$ by
computing $f\(Delta m_i + e_i + q_0 k_i\)approx Delta m_i + e_i$. This
approximation works if $Delta m_i + e_i$ is very close to $x = 0$
relative to $q_0$ (i.e., $Delta m_i + e_i lt.double q_0$). Still, the
elimination of $q_0 k_i$ is approximate (i.e.,
$approx Delta m_i + e_i$), because $f\(x\)$ is $y approx x$ nearby
$x = 0$, not exactly $y = x$.

One issue is that we need to evaluate $f\(x\)$ homomorphically based on
ct#sub[s1] and ct#sub[s2] as inputs (i.e.,
\$f(\\textsf{ct\\textsubscript{s1}})\$ and
\$f(\\textsf{ct\\textsubscript{s2}})\$), but FHE supports only
$\(+\,dot.op\)$ operations, whereas the sine graph cannot be formulated
by only $\(+\,dot.op\)$. Therefore, we will approximate the sine
function $f\(x\)$ by using the Taylor series
(#link(<sec:taylor-series>)[\[sec:taylor-series\]]):

$f\(x\)= f\(a\)+ frac(f'\(a\), 1 !)\(x - a\)+ frac(f''\(a\), 2 !)\(x - a\)^2+ frac(f'''\(a\), 3 !)\(x - a\)^3+ dots.h.c = sum_(d = 0)^oo frac(f^(\(d\))\(a\), d !)\(x - a\)^d$

$$

If we approximate $f\(x\)$ around $x = 0$, then the approximated
polynomial is as follows:

$f\(x\)= frac(q_0, 2 pi) dot.op sin (frac(2 pi, q_0) dot.op 0) + frac(q_0, 2 pi) dot.op frac(2 pi, q_0) dot.op frac(cos (frac(2 pi, q_0) dot.op 0), 1 !) dot.op x + frac(q_0, 2 pi) dot.op (frac(2 pi, q_0))^2 dot.op frac(- sin (frac(2 pi, q_0) dot.op 0), 2 !) dot.op x^2 + dots.h.c$

$= frac(q_0, 2 pi) dot.op sum_(j = 0)^oo (frac(\(- 1\)^j, \(2 j + 1\)!) dot.op (frac(2 pi x, q_0))^(2 j + 1))$

$approx frac(q_0, 2 pi) dot.op sum_(j = 0)^h (frac(\(- 1\)^j, \(2 j + 1\)!) dot.op (frac(2 pi x, q_0))^(2 j + 1)) = hat(f)\(x\)$

$$

, where $hat(f)\(x\)$ is a $\(2 h + 1\)$-degree polynomial.

Remember that in the RLWE cryptosystem,
$B + A S med mod med q_0 = Delta M + E$, or
$B + A S = Delta M + E + q_0 K$ with some polynomial $K$ representing
the wrapping around values of modulo $q_0$. Since the secret key $S$ is
an $\(n - 1\)$-degree polynomial whose coefficients are small (i.e.,
$s_i in { - 1\,0\,1 }$), the coefficients of $K$ will have some
#emph[reasonably small] upper bound, which decreases with the sparsity
of $S$ (i.e., the frequency of 0 coefficients in $S$). Therefore, the
degree of our approximated $hat(f)\(x\)$ only needs to be high enough to
accurately evaluate $y$ values between
$- q_0 dot.op italic(k_(m a x)) lt.eq x lt.eq q_0 dot.op italic(k_(m a x))$.
The required minimum degree of our approximated Taylor polynomial
$hat(f)\(x\)$ increases with $q_0 italic(k_(m a x))$ (i.e., the upper
bound of $x$). Our one issue is that the computation overhead for
homomorphic evaluation of a polynomial generally increases exponentially
with the degree of the polynomial, which will slow down bootstrapping.
To reduce this computation cost, we will leverage Euler's formula
(#link(<sec:euler>)[\[sec:euler\]]) and its square arithmetic:

$ {e^(i dot.op theta) = cos theta + i dot.op sin theta\
\(e^(i dot.op theta)\)^2= e^(i dot.op 2 theta)\
 $

By substituting $theta = frac(2 pi x, q_0)$, we will use Euler's
formula. We will also approximate $e^(i theta)$ with the Taylor series,
but instead of directly approximating $e^(i theta)$, we will first
approximate $e^(frac(i theta, 2^r))$ for some large $2^r$. After that,
we will iteratively square $e^(frac(i theta, 2^r))$ a total $r$ times.
Then, we get an approximation of
$\(e^(frac(i theta, 2^r))\)^(2^r)= e^(i theta)$. The reason why we start
with the approximation of $e^(frac(i theta, 2^r))$ instead of
$e^(i theta)$ is that its approximation requires a small degree of
polynomial, as $theta / 2^r$ (i.e., the input to the complex exponential
function) is small provided $2^r$ is sufficiently large. Specifically,
we learned that $x$ ($= Delta m_i + e_i + q_0 k_i$) is upper-bounded by
$q_0 italic(k_(m a x))$, thus $theta = frac(2 pi x, q_0)$ is
upper-bounded by $frac(2 pi italic(k_(m a x)), 2^r)$. As the targeted
range of $x$ for approximation in $f\(x\)$ is small, we need a small
degree of Taylor series polynomial.

Using the Taylor series with degree $d_0$ around $x = 0$, we can
approximate $e^(frac(2 pi i x, 2^r q_0))$ as:

$f_e\(x\)= e^(frac(2 pi i x, 2^r q_0)) approx sum_(d = 0)^(d_0) frac(1, d !) (frac(2 pi i x, 2^r q_0))^d = hat(f)_e\(x\)$

$$

Then, we iteratively square $hat(f)_e$ total $r$ times to get:

$\(hat(f)_e\(x\)\)^(2^r)approx\(f_e\(x\)\)^(2^r)= e^(i frac(2 pi x, q_0)) = e^(i theta)$

$$

Then, based on Euler's formula
$e^(i dot.op theta) = cos theta + i dot.op sin theta$, we can derive the
following relations:

$$

$overline(e^(i dot.op theta)) = cos theta + overline(i dot.op sin theta)$

$e^(- i dot.op theta) = cos theta - i dot.op sin theta$

$e^(i dot.op theta) - e^(- i dot.op theta) =\(cos theta + i dot.op sin theta\)-\(cos theta - i dot.op sin theta\)= 2 i sin theta$

$sin theta = frac(- i, 2) dot.op\(e^(i dot.op theta) - e^(- i dot.op theta)\)$

$frac(q_0, 2 pi) dot.op sin theta = frac(q_0, 2 pi) dot.op frac(- i, 2) dot.op\(e^(i dot.op theta) - e^(- i dot.op theta)\)$

$$

Substituting $theta = frac(2 pi x, q_0)$, we finally get:

$frac(q_0, 2 pi) dot.op sin (frac(2 pi x, q_0)) = frac(q_0, 2 pi) dot.op frac(- i, 2) dot.op\(e^(i dot.op frac(2 pi x, q_0)) - e^(- i dot.op frac(2 pi x, q_0))\)$

$$

Using the final relation above, the EvalExp step homomorphically
evaluates the approximation of
$frac(q_0, 2 pi) dot.op sin (frac(2 pi x, q_0))$ where
$x = Delta m_i + e_i + q_0 k_i$ as follows:

+ Homomorphically approximately compute
  $hat(f)\(x\)= e^(i dot.op frac(2 pi x, q_0))$.

+ Homomorphically approximately compute
  $overline(hat(f)\(x\)) = e^(- i dot.op frac(2 pi x, q_0))$ by applying
  homomorphic conjugation. (#link(<subsec:ckks-conjugation>)[0.11]) to
  $hat(f)\(x\)$

+ Homomorphically compute
  $hat(f)\(x\)- overline(hat(f)\(x\)) = e^(i dot.op frac(2 pi x, q_0)) - e^(- i dot.op frac(2 pi x, q_0))$,
  and then multiply the result by $frac(- i, 2)$ encoded as CKKS
  plaintext.

$$

The result of EvalExp is two ciphertexts whose input vector slots store
the bootstrapped coefficients of $M_c$, which are modulo-reduced $q_0$
from $Delta m_i + e_i + q_0 k_i$ to $Delta m_i + e_i + e_(b i)$. Note
that $e_(b i)$ is a bootstrapping error introduced by the following
three factors: (1) the intrinsic homomorphic $\(+\,dot.op\)$ computation
noises of the CoeffToSlot, EvalExp, and SlotToCoeff steps; (2) the
EvalExp step's Taylor polynomial approximation error of the exponential
function $e^(i theta)$\; (3) the EvalExp step's sine graph error, since
the graph is not exactly $y = x$ around $x = 0$, but only $y approx x$.

Note that since the output of the CoeffToSlot step was split into 2
ciphertexts (ct#sub[s1] and ct#sub[s2]), the output of the EvalExp step
is also in 2 ciphertexts: (ct#sub[b1] and ct#sub[b2]). The input vector
slots of ct#sub[b1] store
$\(Delta m_i + e_i + e_(b i)\)_(i = 0)^(n / 2 - 1)$, whereas the input
vector slots of ct#sub[b2] store
$\(Delta m_i + e_i + e_(b i)\)_(i = n / 2)^(n - 1)$.

=== Details: SlotToCoeff
<subsubsec:ckks-bootstrapping-slottocoeff-details>
This step is the exact inverse of the CoeffToSlot step, which is moving
the bootstrapped (i.e. modulo-reduced $q_0$) coefficients of $M_v$
stored in the input vector slots back to the final plaintext polynomial
$M_f$. Remember that the decoding formula from a polynomial to an input
vector (#link(<subsec:ckks-encoding-decoding>)[0.1]) is
\$\\vec{v}\_{\'} = \\hathat W^\* \\cdot \\vec{m}\$, where:

\$\\hathat{W}^\* = \\begin{bmatrix}
1 & (\\omega^{J(0)}) & (\\omega^{J(0)})^2 & \\cdots & (\\omega^{J(0)})^{n-1}\\\\
1 & (\\omega^{J(1)}) & (\\omega^{J(1)})^2 & \\cdots & (\\omega^{J(1)})^{n-1}\\\\
1 & (\\omega^{J(2)}) & (\\omega^{J(2)})^2 & \\cdots & (\\omega^{J(2)})^{n-1}\\\\
\\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\
1 & (\\omega^{J(\\frac{n}{2}-1)}) & (\\omega^{J(\\frac{n}{2}-1)})^2 & \\cdots & (\\omega^{J(\\frac{n}{2}-1)})^{n-1}\\\\
1 & (\\omega^{J\_\*(\\frac{n}{2}-1)}) & (\\omega^{J\_\*(\\frac{n}{2}-1)})^2 & \\cdots & (\\omega^{J\_\*(\\frac{n}{2}-1)})^{n-1}\\\\
\\vdots & \\vdots & \\vdots & \\ddots & \\vdots \\\\
1 & (\\omega^{J\_\*(1)}) & (\\omega^{J\_\*(1)})^2 & \\cdots & (\\omega^{J\_\*(1)})^{n-1}\\\\
1 & (\\omega^{J\_\*(0)}) & (\\omega^{J\_\*(0)})^2 & \\cdots & (\\omega^{J\_\*(0)})^{n-1}\\\\
\\end{bmatrix}\$

$$

$$

We denote \$\[\\hathat W^\*\]\_{11}\$, \$\[\\hathat W^\*\]\_{12}\$,
\$\[\\hathat W^\*\]\_{21}\$, and \$\[\\hathat W^\*\]\_{22}\$ as
$n / 2 times n / 2$ matrices corresponding to the upper-left,
upper-right, lower-left, and lower-right sections of \$\\hathat W^\*\$.
Then, homomorphically applying the decoding formula results in the final
bootstrapped ciphertext ct#sub[final] modulo $q_L$ whose plaintext
polynomial is garbage-eliminated from
$Delta M + E + q_0 K med mod med q_L$ to
$Delta M + E + E_b med mod med q_l$ (where $E_b$ is the bootstrapping
error polynomial). Note that the ciphertext modulus changed from
$q_L arrow.r q_l$ (for some $l < L$) because we consumed some
multiplicative levels for computing ciphertext-to-ciphertext
multiplications during polynomial evaluation (i.e., $X^k$).

\$\$\\begin{bmatrix} \\hathat{W}^\*\_{11} & \\hathat{W}^\*\_{12} \\\\ \\hathat{W}^\*\_{21} & \\hathat{W}^\*\_{22} \\end{bmatrix} \\begin{bmatrix} \\vec{m}\_1 \\\\ \\vec{m}\_2 \\end{bmatrix} = \\begin{bmatrix} \\hathat{W}^\*\_{11}\\vec{m}\_1 + \\hathat{W}^\*\_{12}\\vec{m}\_2 \\\\ \\hathat{W}^\*\_{21}\\vec{m}\_1 + \\hathat{W}^\*\_{22}\\vec{m}\_2 \\end{bmatrix}\$\$

$$

In our case, \$\\vec{m}\_1 = \\textsf{ct\\textsubscript{b1}}\$, and
\$\\vec{m}\_2 = \\textsf{ct\\textsubscript{b2}}\$. We can derive
ct#sub[final] by homomorphically applying the decoding transformation
\$\\hathat{W}^\*\$ to the results of the EvalExp step (ct#sub[b1] and
ct#sub[b2]) as follows:

\$\\textsf{ct\\textsubscript{final}} = \\textsf{RLWE}\_{S, \\sigma}\\bm(\\Delta M + E + E\_{b}\\bm) = \[\\hathat W^\*\]\_{11} \\cdot \\textsf{ct\\textsubscript{b1}} + \[\\hathat W^\*\]\_{12} \\cdot \\textsf{ct\\textsubscript{b2}}\$

\$\\overline{\\textsf{ct\\textsubscript{final}}} = \\textsf{RLWE}\_{S, \\sigma}\\bm(\\Delta M + E + E\_{b}\\bm) = \[\\hathat W^\*\]\_{21} \\cdot \\textsf{ct\\textsubscript{b1}} + \[\\hathat W^\*\]\_{22} \\cdot \\textsf{ct\\textsubscript{b2}}\$

$$

Note that we do not need to compute
\$\\overline{\\textsf{ct\\textsubscript{final}}}\$ (i.e., a homomorphic
conjugation of \$\\textsf{ct\\textsubscript{final}}\$), because we only
need to derive the $n / 2$ input vector slots whose decoding would
result in the $n$ coefficients
$\(Delta m_i + e_i + e_(b i)\)_(i = 0)^(n - 1)$ of the final
$\(n - 1\)$-degree polynomial. Once we generate a new ciphertext
ct#sub[final] whose $n / 2$ input vector slots store
$\(Delta m_i + e_i + e_(b i)\)_(i = 0)^(n - 1)$, then its latter $n / 2$
conjugate slots get automatically filled with the conjugates of the
first $n / 2$ slot values.

\$\\textsf{ct\\textsubscript{final}} = \\textsf{RLWE}\_{S, \\sigma}(\\Delta M + E + E\_b)\$
\$= \\textsf{SlotToCoeff}(\\textsf{ct\\textsubscript{b1}}, \\textsf{ct\\textsubscript{b2}})\$

=== Reducing the Bootstrapping Overhead by Sparsely Packing Ciphertext
<subsubsec:ckks-bootstrapping-time-reduction>
In many cases, the application of CKKS may use only a small number of
input vector slots (e.g., $n' / 2$) out of $n / 2$ slots. Suppose that
such $n'$ is some number that divides $n$. Then, we can do a series of
homomorphic rotations and multiplications to make the input vector slots
store $n / n'$ repetitions of the $n' / 2$-slot values. Specifically, we
can do this in total $n / n'$ rounds of rotations and additions:
initially, we zero-mask between the $n' / 2$-th slot and the
$n / 2 - 1$-th slots and save as ct, and then in each $i$-th round we
compute
$sans("ct") = sans("ct") + sans("Rotate") bold(\() sans("ct")\,- n' dot.op 2^i bold(\))$.

Then, we apply the optimization of sparsely packing ciphertext in
Summary~@subsec:ckks-sparse-packing
(#link(<subsec:ckks-sparse-packing>)[0.12]): if an $n / 2$-dimensional
input vector is structured as $n / n'$ consecutive repetitions of the
first $n' / 2$ slot values, then its encoded polynomial
$M\(X\)in bb(Z)\[X\]\/\(X^n + 1\)$ has the structure such that all its
coefficients whose degree term is not a multiple of $n / n'$ are zero as
follows:

$M\(X\)= c_0 + c_(n / n') X^(n / n') + c_(frac(2 n, n')) X^(frac(2 n, n')) + dots.h.c + c_(n - n / n') X^(n - n / n')$.

Remember that in the CoeffToSlot step
(#link(<subsubsec:ckks-bootstrapping-coefftoslot-details>)[0.13.3]), we
use the formula
\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$
to move the $q_0 k$-contaminated polynomial's coefficients to the input
vector slots. But by the principle of sparsely packed ciphertext, we
know that all the slots of $arrow(m)$ which are not a multiple of
$n / n'$ slots would store a zero coefficient. This means that we will
get the same computation result even if we only compute the
\$\\vec{m} = \\dfrac{\\hathat W \\cdot I\_n^R \\cdot \\vec{v}\_{\'}}{n}\$
formula with the rows of \$\\hathat W\$ whose row index is a multiple of
$n / n'$. Mathematically, we can update the encoding formula to
\$\\vec{m\_s} = \\dfrac{ \\text{\\rotatecharone{E}} \\cdot I\_{n\'}^R \\cdot \\vec{v}\_{\'}}{n\'}\$
where the $n times n / n'$ matrix is an elimination of all those columns
from \$\\hathat W\$ whose column index is not a multiple of $n / n'$:

\$\\text{\\rotatecharone{E}} = \\begin{bmatrix}
1 & 1 & \\cdots & 1 & 1 & \\cdots & 1 & 1\\\\
(\\xi^{J(\\frac{0\\cdot n}{n\'}-n\')}) & (\\xi^{J(\\frac{1\\cdot n}{n\'})}) & \\cdots & (\\xi^{J(n-\\frac{n}{n\'})}) & (\\xi^{J\_\*(n-\\frac{n}{n\'})}) & \\cdots & (\\xi^{J\_\*(\\frac{1\\cdot n}{n\'})}) & (\\xi^{J\_\*(\\frac{0\\cdot n}{n\'}-n\')})\\\\
(\\xi^{J(\\frac{0\\cdot n}{n\'}-n\')})^2 & (\\xi^{J(\\frac{1\\cdot n}{n\'}-n\')})^2 & \\cdots & (\\xi^{J(n-\\frac{n}{n\'})})^2 & (\\xi^{J\_\*(n-\\frac{n}{n\'})})^2 & \\cdots & (\\xi^{J\_\*(\\frac{1\\cdot n}{n\'}-n\')})^2 & (\\xi^{J\_\*(\\frac{0\\cdot n}{n\'}-n\')})^2 \\\\
\\vdots & \\vdots & \\ddots & \\vdots & \\vdots & \\ddots & \\vdots & \\vdots \\\\
(\\xi^{J(\\frac{0\\cdot n}{n\'}-n\')})^{n-1} & (\\xi^{J(\\frac{1\\cdot n}{n\'}-n\')})^{n-1} & \\cdots & (\\xi^{J(n-\\frac{n}{n\'})})^{n-1} & (\\xi^{J\_\*(n-\\frac{n}{n\'})})^{n-1} & \\vdots & (\\xi^{J\_\*(\\frac{1\\cdot n}{n\'}-n\')})^{n-1} & (\\xi^{J\_\*(\\frac{0\\cdot n}{n\'}-n\')})^{n-1} 
\\end{bmatrix}\$

$$

Remember that in the original CoeffToSlot step
(#link(<subsubsec:ckks-bootstrapping-coefftoslot-details>)[0.13.3]), we
had to split ct#sub[s] into ct#sub[s1] and ct#sub[s2] because in CKKS
each input vector can store a maximum of $n / 2$ slots but we need to
move a total of $n$ coefficient values to the input vector slots for
bootstrapping. On the other hand, the computation result of the above
updated encoding formula (using a sparsely packed ciphertext) is
$arrow(m)_s$, having only $n / n'$ coefficient slots instead of $n$
coefficient slots, and each slot index $i$ in $arrow(m)_s$ corresponds
to the encoded polynomial's coefficient with degree term
$i dot.op n / n'$ (we do not compute any other coefficient terms,
because we know that they are 0 anyway, so no need to bootstrap them).
And notice that $n / n' lt.eq n / 2$, because $n'$ divides $n$.
Therefore, without computing two ciphertexts
\$\\textsf{ct}\_{\\textsf{s1}} = \[\\hathat WI\_n^R\]\_{11} \\cdot \\textsf{ct\\textsubscript{c}} + \[\\hathat WI\_n^R\]\_{12} \\cdot I\_{\\frac{n}{2}}^R \\cdot \\mathit{\\overline{\\textsf{ct\\textsubscript{c}}}}\$
and
\$\\textsf{ct}\_{\\textsf{s2}} = \[\\hathat WI\_n^R\]\_{21} \\cdot \\textsf{ct\\textsubscript{c}} + \[\\hathat WI\_n^R\]\_{22} \\cdot I\_{\\frac{n}{2}}^R \\cdot \\mathit{\\overline{\\textsf{ct\\textsubscript{c}}}}\$
separately, we can directly compute
\$\\textsf{ct\\textsubscript{c}} = \\dfrac{ \\text{\\rotatecharone{E}} \\cdot I\_{n\'}^R \\cdot \\textsf{ct\\textsubscript{c}}}{n\'}\$,
because all coefficients for bootstrapping fit in $n / 2$ slots.
Therefore, the number of homomorphic computations and memory requirement
for the CoeffToSlot step can be reduced by half. And the same is true
for the EvalExp step
(#link(<subsubsec:ckks-bootstrapping-evalexp-details>)[0.13.4]).

Similarly, as for the SlotToCoeff step
(#link(<subsubsec:ckks-bootstrapping-slottocoeff-details>)[0.13.5]), we
update the decoding formula
\$\\vec{v}\_{\'} = \\hathat W^\* \\cdot \\vec{m}\$ to
\$\\vec{v}\_{\'} = \\text{\\rotatecharone{E}}^{T} \\cdot \\vec{m}\_c\$.
This again reduces the number of homomorphic computations and memory
requirements for the SlotToCoeff step by half. Notice that
\$\\text{\\rotatecharone{E}}^{T}\$ is a matrix where those columns whose
column index is not a multiple of $n / n'$ are zero. This
zero-enforcement to the columns of \$\\text{\\rotatecharone{E}}^{T}\$
still outputs the same computation result, because $arrow(m)_c$ is a
vector such that those slots whose slot index is not a multiple of
$n / n'$ are zero, which makes the computation result with their
corresponding columns of \$\\text{\\rotatecharone{E}}^{T}\$ (i.e., the
columns whose index is not a multiple of $n / n'$) zero, anyway.

=== Summary
<subsubsec:ckks-bootstrapping-summary>
We summarize the CKKS bootstrapping procedure as follows.

#block[
+ #strong[#underline[INPUT]:] $sans("ct") =\(A\,B\)med mod med q_0$
  $gt.tri$ where
  $sans("ct") =\(A\,B\)= sans("RLWE")_(S\,sigma) bold(\() Delta M bold(\))$

  $$

  , which satisfies the decryption relation:
  $A dot.op S + B = Delta M + E + K q_0$

  $$

+ #strong[#underline[ModRaise]:] View the polynomials $A$ and $B$ as
  plaintext polynomials whose each coefficient is in $bb(Z)_(q_L)$
  (i.e., $\(A\,B\)med mod med q_L$). This change of viewpoint
  automatically changes the ciphertext as
  $sans("RLWE")_(S\,sigma)\(Delta M + K q_0\)$. The ModRaise step does
  not require any actual computation.

  $$

+ #strong[#underline[CoeffToSlot]:]

  Move the coefficients of the encrypted plaintext $Delta M + E + q_0 K$
  to the input vector slots by homomorphically multiplying
  \$n^{-1}\\cdot \\hathat W \\cdot I\_n^R\$ to it follows:

  \$\\textsf{RLWE}\_{S, \\sigma}(Z\_1) = n^{-1}\\cdot \\hathat W \\cdot I\_n^R \\cdot \\textsf{RLWE}\_{S, \\sigma}(\\Delta M + E + q\_0K) \\bmod q\_L\$

  $$

+ #strong[#underline[EvalExp]:]

  Remove the wrap-around garbage value $q_0 K$ in $Delta M + E + q_0 K$
  by homomorphically evaluating the polynomial $sigma_f$ which
  approximates a sine function with period $q_0$ as follows:

  $sans("RLWE")_(S\,sigma)\(Z_2\)= sigma_f compose sans("RLWE")_(S\,sigma)\(Z_1\)med mod med q_l$

  $$

  This step is equivalent to #emph[homomorphically] performing modulo
  reduction by $q_0$ to the input value. This step reduces the
  ciphertext modulus from $q_L arrow.r q_l$ as it consumes
  multiplicative levels when homomorphically evaluating the polynomial
  approximation of the sine function.

  $$

+ #strong[#underline[SlotToCoeff]:]

  Move the modulo-$q_0$-reduced plaintext value $Delta M + E$ stored in
  the input vector slots back to the plaintext coefficient positions by
  homomorphically multiplying the encoding matrix \$\\hathat W^\*\$ as
  follows:

  \$\\textsf{RLWE}\_{S, \\sigma}(\\Delta M + E) = \\hathat W^\* \\cdot \\textsf{RLWE}\_{S, \\sigma}(Z\_2)  \\bmod q\_l\$

  $$

$$

#strong[Limitation:] The noise slowly grows over each bootstrapping due
to the bootstrapping error and will eventually overflow the message and
the ciphertext modulus.

]
In the case of CKKS's bootstrapping, it does not reduce the magnitude of
the old noise $E$ and keeps it the same as before, because the sine
approximation function converts $Delta M + E + K q_0$ into
$Delta M + E$. However, as the ciphertext modulus gets increased from
$q_0 arrow.r q_L$, the noise-to-ciphertext-modulus ratio decreases,
since $E / q_L lt.double E / q_0$. On the other hand, the bootstrapping
procedure introduces a new bootstrapping noise, which can be viewed as a
fixed amount. However, this fixed amount of new noise accumulates over
each bootstrapping. Therefore, after a very large number of
bootstrappings, the noise will eventually overflow the message and even
the ciphertext modulus.

In the case of BFV's bootstrapping, it reduces the noise, but does not
change the ciphertext modulus. However, there is no need to reset the
ciphertext modulus, because BFV does not have a leveled ciphertext
modulus chain, and BFV's ciphertext-to-ciphertext multiplication does
not consume ciphertext modulus. Furthermore, since BFV's bootstrapping
directly removes the noise, the noise is guaranteed to be kept under a
certain threshold even after an infinite number of bootstrappings.

Another important difference is that CKKS's bootstrapping does not
require homomorphic decryption, primarily because it maintains the
plaintext's scaling factor to be the same across the entire
bootstrapping procedure. On the other hand, BFV's bootstrapping needs to
change the plaintext's scaling factor to run the digit extraction
algorithm. Therefore, homomorphic decryption is required to change the
plaintext scaling factor ($p^epsilon$) while preserving the same
ciphertext modulus ($q$).

=== Reducing the Bootstrapping Noise
<subsubsec:ckks-bootstrapping-noise-reduction>
As explained in
#link(<subsubsec:ckks-bootstrapping-evalexp-details>)[0.13.4], the
bootstrapping procedure generates three types of noises:

- #underline[Type-1 Noise]: the intrinsic homomorphic $\(+\,dot.op\)$
  computation noises of the CoeffToSlot, EvalExp, and SlotToCoeff steps

- #underline[Type-2 Noise]: the EvalExp step's approximation error of
  the exponential function $e^(i theta)$

- #underline[Type-3 Noise]: the EvalExp step's sine graph error (i.e.,
  not exactly $y = x$ around $x = 0$, but only $y approx x$)

$$

The Type-1 noise is inevitable by the design of FHE. The Type-2 noise
can be either avoided or unavoidable depending on the tradeoff setup
between the bootstrapping accuracy and efficiency. Unlike these two
types of noises, the Type-3 noise can be effectively reduced by newer
bootstrapping techniques.

#figure(image("figures/arc-sine.png", width: 100.0%),
  caption: [
    Arc-sine graph for smaller approximation error
    #link("https://www.google.com/search?sca_esv=c744cb070de47b7e&sxsrf=ADLYWIKKaF93fcAFvJC4ehJso1E5qFTaow:1732546684173&q=arcsin(sin(x))&source=lnms&fbs=AEQNm0DmKhoYsBCHazhZSCWuALW8l8eUs1i3TeMYPF4tXSfZ95GzcfXnm5XYTvJV_9Qreh2py964ICpZJthXkELijctC8pFBYULoa3-fvQmwK0VJF0ntzsbN_W2CCJL9N57SWFNwWI58jCKaBJSdPgkprHQVK8H1PYOYWXMHTCCV-rDbC44rR6ANM870jZCZRtTKwFWtMIe2&sa=X&ved=2ahUKEwjZy6qt3_eJAxXbhlYBHXD2IvEQ0pQJegQIDxAB&cshid=1732546705369143&biw=1280&bih=635&dpr=1.5")[\(Source)]
  ]
)
<fig:arc-sine>

$$

Using the $arcsin\(sin\(x\)\)$ function instead of the $sin x$ function
can reduce the Type-3 noise, because its line is not curved but
straight, as shown in #link(<fig:arc-sine>)[2] (comprising a series of
$y = x$ and $y = - x$ segments). This technique also uses the Remez
algorithm that evenly distributes the approximation error over a
specified region. However, one downside of this technique is that it
consumes 3 multiplicative levels.

$$

This is thus far the most computationally efficient and accurate
bootstrapping technique, whose procedure is as follows:

+ Perform the regular bootstrapping based on the sine graph to the input
  ciphertext.

+ Rescale step 1's bootstrapped ciphertext to modulus $q_0$.

+ Subtract step 2's ciphertext from the initial un-bootstrapped
  ciphertext (where both ciphertexts are modulo $q_0$), whose result is
  a modulo $q_0$ ciphertext storing the bootstrapping error.

+ Bootstrap the output ciphertext of step 3 (storing the bootstrapping
  error) to modulus $q_l$.

+ Subtract step 4's ciphertext from step 1's ciphertext (where both
  ciphertexts are modulo $q_l$), which gives a new modulo $q_l$
  ciphertext with a reduced bootstrapping error.

$$

The above bootstrapping techniques can reduce the Type-3 noise, because
the bootstrapping error is smaller than the plaintext message and a
smaller input value $x$ to the approximating sine function outputs a
value closer to $y = x$. Running this algorithm multiple times, the
Type-3 noise becomes exponentially smaller, because the size of the
target plaintext (i.e., the extracted bootstrapping error as the output
of step 3 above) is much smaller than before. Meanwhile, Type-1 and
Type-2 noises do not decrease over multiple bootstrapping rounds,
relatively keeping their same level, because each round generates new
Type-1 and Type-2 noises.
