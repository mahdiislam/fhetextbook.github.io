The GLWE cryptosystem is a generalized form to encompass both the LWE
and RLWE cryptosystems. The GLWE cryptosystem's ciphertext is a tuple
$\({ A_i }_(i = 0)^(k - 1)\,B\)$, where
$B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E$. The
public key ${ A_i }_(i = 0)^(k - 1)$ and the secret key
${ S_i }_(i = 0)^(k - 1)$ are a list of $k$ $\(n - 1\)$-degree
polynomials, each. The message $M$ and the noise $E$ are
$\(n - 1\)$-degree polynomials, each. Like in LWE and RLWE, a random
public mask $A$ is created for each ciphertext, whereas the same secret
key $S$ is used for all ciphertexts. In this section, we denote each
ciphertext instance as $\({ A_i }_(i = 0)^(k - 1)\,B\)$ instead of
$\({ A_i }_(i = 0)^(k - 1\,chevron.l j chevron.r)\,B^(chevron.l j chevron.r)\)$
for simplicity.

== Setup
<setup>
Let $t$ be the size of plaintext, and $q$ the size of ciphertext, where
$t < q$ ($t$ is much smaller than $q$) and $t\|q$ (i.e., $t$ divides
$q$). Randomly pick a list of $k$ $\(n - 1\)$-degree polynomials as a
secret key, where each polynomial coefficient is a randomly picked
ternary number in ${ - 1\,0\,1 }$ (i.e.,
${ S_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)^k$).
Let $Delta = ⌊q / t⌋$ be the scaling factor of plaintext.

Notice that GLWE's setup parameters are similar to that of RLWE. One
difference is that $S$ is not an $\(n - 1\)$-degree polynomial encoding
$n$ secret coefficients, but a list of $k$ such $\(n - 1\)$-degree
polynomials encoding total $n dot.op k$ secret coefficients.

== Encryption
<subsec:glwe-enc>
Suppose we have an $\(n - 1\)$-degree polynomial
$M in cal(R)_(chevron.l n\,t chevron.r)$ whose coefficients represent
the plaintext numbers to encrypt.

+ Randomly pick a list of $k$ $\(n - 1\)$-degree polynomials
  ${ A_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$
  as a one-time public key.

+ Randomly pick a small polynomial
  $E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$ as a
  one-time noise, whose $n$ coefficients are small numbers in $bb(Z)_q$
  randomly sampled from the Gaussian distribution $chi_sigma$.

+ Scale $M$ by $Delta$, which is to compute $Delta dot.op M$. This
  converts $M in cal(R)_(chevron.l n\,t chevron.r)$ into
  $Delta dot.op M in cal(R)_(chevron.l n\,q chevron.r)$.

+ Compute
  $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E in cal(R)_(chevron.l n\,q chevron.r)$.

$$

The GLWE encryption formula is summarized as follows:

$$

#block[
#strong[#underline[Initial Setup]:] $Delta = ⌊q / t⌋$,
${ S_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)^k$

$$

$$

#strong[#underline[Encryption Input]:]
$M in cal(R)_(chevron.l n\,t chevron.r)$,
${ A_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$,
$E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

$$

+ Scale up
  $M arrow.r Delta M upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Compute
  $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ $sans("GLWE")_(S\,sigma)\(Delta M + E\)=\({ A_i }_(i = 0)^(k - 1)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

]
== Decryption
<subsec:glwe-dec>
+ Given the ciphertext $\({ A_i }_(i = 0)^(k - 1)\,B\)$ where
  $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E in cal(R)_(chevron.l n\,q chevron.r)$,
  compute
  $B - sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)= Delta dot.op M + E$.

+ Round each coefficient of the polynomial
  $Delta dot.op M + E in cal(R)_(chevron.l n\,q chevron.r)$ to the
  nearest multiple of $Delta$ (i.e., round it as a base $Delta$ number),
  which is denoted as $ceil.l Delta dot.op M + E floor.r_Delta$. This
  operation successfully eliminates $E$ and gives $Delta dot.op M$. One
  caveat is that $E$'s each coefficient $e_i$ has to be
  $\|e_i\|< Delta / 2$ to be eliminated during the rounding. Otherwise,
  some of $e_i$'s higher bits will overlap the plaintext $m_i$
  coefficient's lower bit and won't be eliminated during decryption,
  corrupting the plaintext $m_1$.

+ Compute $frac(Delta dot.op M, Delta)$, which is equivalent to scaling
  down each polynomial coefficient in $Delta dot.op M$ by $Delta$.

$$

In summary, the GLWE decryption formula is summarized as follows:

$$

#block[
#strong[#underline[Decryption Input]:]
$sans("ct") =\({ A_i }_(i = 0)^(k - 1)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

+ $sans("GLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= B - sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)= Delta M + E upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Scale down
  $#scale(x: 180%, y: 180%)[ceil.l] frac(Delta M + E, Delta) #scale(x: 180%, y: 180%)[floor.r] med mod med t = M upright(" ") in cal(R)_(chevron.l n\,t chevron.r)$

For correct decryption, every noise coefficient $e_i$ of polynomial $E$
should be: $\|e_i\|< Delta / 2$.

]
=== Discussion
<discussion>
+ #strong[LWE] is a special case of GLWE where the polynomial ring's
  degree $n = 1$. That is, all polynomials in
  ${ A_i }_(i = 0)^(k - 1)\,{ S_i }_(i = 0)^(k - 1)\,E$, and $M$ are
  zero-degree polynomial constants. Instead, there are $k$ such
  constants for $A_i$ and $S_i$, so each of them forms a vector.

+ #strong[RLWE] is a special case of GLWE where $k = 1$. That is, the
  secret key $S$ is a single polynomial $S_0$, and each encryption is
  processed by only a single polynomial $A_0$ as a public key.

+ #strong[Size of $bold(n)$:] A large polynomial degree $n$ increases
  the number of the secret key's coefficient terms (i.e.,
  $S_i = s_(i\,0) + s_(i\,1) X + dots.h.c + s_(i\,n - 1) X^(n - 1)$),
  which makes it more difficult to guess the complete secret key. The
  same applies to the noise polynomial $E$ and the public key
  polynomials $A_i$, thus making it harder to solve the search-hard
  problem
  (#link(<subsec:lattice-overview>)[\[subsec:lattice-overview\]]). Also,
  higher-degree polynomials can encode more plaintext terms in the same
  plaintext polynomial $M$, improving the throughput efficiency of
  processing ciphertexts.

+ #strong[Size of $bold(k)$:] A large $k$ increases the number of the
  secret key polynomials $\(S_0\,S_1\,dots.h\,S_k\)$ and the number of
  the one-time public key polynomials $\(A_0\,A_1\,dots.h\,A_k\)$, which
  makes it more difficult for the attacker to guess the complete secret
  keys. Meanwhile, there is only a single $M$ and $E$ polynomials per
  GLWE ciphertext, regardless of the size of $k$.

+ #strong[Reducing the Ciphertext Size:] The public key
  ${ A_i }_(i = 0)^(k - 1)$ has to be created for each ciphertext, which
  is a big size. To reduce this size, each ciphertext can instead
  include the seed $d$ for the pseudo-random number generation hash
  function $H$. Then, the public key can be dynamically computed $k - 1$
  times upon each encryption & decryption as
  ${ H\(s\)\,H\(H\(s\)\)\,H\(H\(H\(s\)\)\,dots.h }$. Note that $H$, by
  nature, generates the same sequence of numbers given the same random
  initial seed $d$.

== An Alternative Version of GLWE
<subsec:glwe-alternative>
The following is an alternative version of , where the sign of each
$A_i S_i$ is flipped in the encryption and decryption formula as
follows:

#block[
#strong[#underline[Initial Setup]:] $Delta = ⌊q / t⌋$,
${ S_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)^k$

$$

#horizontalrule

#strong[#underline[Encryption Input]:]
$M in cal(R)_(chevron.l n\,t chevron.r)$,
${ A_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$,
$E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

$$

+ Scale up
  $M arrow.r Delta M upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Compute
  \$B = \\textcolor{red}{-\\sum\\limits\_{i=0}^{k-1}{(A\_i \\cdot S\_i)}} + \\Delta  M + E \\text{ } \\in \\mathcal{R}\_{\\langle n,q \\rangle}\$

+ $sans("GLWE")_(S\,sigma)\(Delta M + E\)=\({ A_i }_(i = 0)^(k - 1)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

#horizontalrule

#strong[#underline[Decryption Input]:]
$sans("ct") =\({ A_i }_(i = 0)^(k - 1)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

+ \$\\textsf{GLWE}^{-1}\_{S,\\sigma}(\\textsf{ct}) = B \\text{ } \\textcolor{red}{ + \\sum\\limits\_{i=0}^{k-1}{(A\_i \\cdot S\_i)}} = \\Delta  M + E \\text{ } \\in \\mathcal{R}\_{\\langle n,q \\rangle}\$

+ Scale down
  $#scale(x: 180%, y: 180%)[ceil.l] frac(Delta M + E, Delta) #scale(x: 180%, y: 180%)[floor.r] = M upright(" ") in cal(R)_(chevron.l n\,t chevron.r)$

For correct decryption, every noise coefficient $e_i$ of polynomial $E$
should be: $\|e_i\|< Delta / 2$.

]
Even if the $A_i S_i$ terms flip their signs, the decryption stage
cancels out those terms by adding their equivalent double-sign-flipped
terms; thus, the same correctness of decryption is preserved as in the
original version.

== Public Key Encryption
<subsec:glwe-public-key-enc>
The encryption scheme in #link(<subsec:glwe-enc>)[0.2] assumes that it
is the secret key owner who encrypts each plaintext. In this section, we
explain a public key encryption scheme in which we create a public key
counterpart of the secret key. Anyone who knows the public key can
encrypt the plaintext in such a way that only the secret key owner can
decrypt it. The high-level idea is that a portion of the components to
be used in the encryption stage is pre-computed at the setup stage and
published as a public key. At the actual encryption stage, the public
key is multiplied by an additional randomness ($U$) and added to
additional noise ($E_1\,arrow(E)_2$) to create unpredictable randomness
for each encrypted ciphertext. The actual scheme is as follows:

#block[
#strong[#underline[Initial Setup]:]

- The scaling factor $Delta = ⌊q / t⌋$

- The secret key
  $arrow(S) = { S_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)^k$

- The public key pair
  \$(\\mathit{PK}\_1, \\vv{\\mathit{PK}}\_2) \\in \\mathcal{R}\_{\\langle n, q \\rangle}^{k+1}\$
  is generated as follows:

  $arrow(A) = { A_i }_(i = 0)^(k - 1) arrow.l^(\$) cal(R)_(chevron.l n\,q chevron.r)^k$,
  $E arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)$

  $italic(P K)_1 = arrow(A) dot.op arrow(S) + E in cal(R)_(chevron.l n\,q chevron.r)$

  \$\\vv{\\mathit{PK}}\_2 = \\vec{A} \\in \\mathcal{R}\_{\\langle n, q \\rangle}^{k}\$

#horizontalrule

#strong[#underline[Encryption Input]:]
$M in cal(R)_(chevron.l n\,t chevron.r)$,
$U arrow.l^(\$) cal(R)_(chevron.l n\,italic("tern") chevron.r)\,upright(" ") E_1 arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)\,upright(" ") arrow(E)_2 arrow.l^(chi_sigma) cal(R)_(chevron.l n\,q chevron.r)^k$

$$

+ Scale up
  $M arrow.r Delta M upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Compute the following:

  $B = italic(P K)_1 dot.op U + Delta M + E_1 upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

  \$\\vec{D} = \\vv{{\\mathit{PK}}}\_2 \\cdot U + \\vec{E}\_2 \\in \\mathcal{R}\_{\\langle n,q \\rangle}^{k}\$
  $gt.tri$ \$\\vv{\\mathit{PK}}\_2 \\cdot U\$ multiplies each element of
  \$\\vv{\\mathit{PK}}\_2\$ by $U$

+ $sans("GLWE")_(S\,sigma)\(Delta M + E_(italic(a l l))\)=\(arrow(D)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$
  $gt.tri$ where
  $E_(italic(a l l)) = E dot.op U + E_1 - arrow(E)_2 dot.op arrow(S)$

#horizontalrule

#strong[#underline[Decryption Input]:]
$sans("ct") =\(arrow(D)\,B\)upright(" ") in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

+ $sans("GLWE")_(S\,sigma)^(- 1)\(sans("ct")\)= B - arrow(D) dot.op arrow(S) = Delta M + E_(italic(a l l)) upright(" ") in cal(R)_(chevron.l n\,q chevron.r)$

+ Scale down
  $#scale(x: 180%, y: 180%)[ceil.l] frac(Delta M + E_(italic(a l l)), Delta) #scale(x: 180%, y: 180%)[floor.r] = M upright(" ") in cal(R)_(chevron.l n\,t chevron.r)$

For correct decryption, every noise coefficient $e_i$ of polynomial
$E_(italic(a l l))$ should be: $\|e_i\|< Delta / 2$.

]
The equation in the 1st step of the decryption process is derived as
follows:

$sans("GLWE")_(S\,sigma)^(- 1) bold(\() upright(" ") sans("ct") =\(arrow(D)\,B\)upright(" ") bold(\)) = B - arrow(D) dot.op arrow(S)$

\$= (\\mathit{PK}\_1\\cdot U + \\Delta  M + E\_1) - (\\vv{\\mathit{PK}}\_2 \\cdot U + \\vec{E}\_2)\\cdot \\vec{S}\$

$=\(arrow(A) dot.op arrow(S) + E\)dot.op U + Delta M + E_1 -\(arrow(A) dot.op U\)dot.op arrow(S) - arrow(E)_2 dot.op arrow(S)$

$=\(U dot.op arrow(A)\)dot.op arrow(S) + E dot.op U + Delta M + E_1 -\(U dot.op arrow(A)\)dot.op arrow(S) - arrow(E)_2 dot.op arrow(S)$

$= Delta M + E dot.op U + E_1 - arrow(E)_2 dot.op arrow(S)$

$= Delta M + E_(italic(a l l))$ $gt.tri$ where
$E_(italic(a l l)) = E dot.op U + E_1 - arrow(E)_2 dot.op arrow(S)$

$$

The GLWE encryption scheme's encryption formula
(Summary~@subsec:glwe-enc in #link(<subsec:glwe-enc>)[0.2]) is as
follows:

$sans("GLWE")_(S\,sigma)\(Delta M + E\)= bold(\() upright(" ") arrow(A)\,upright(" ") B = arrow(A) dot.op arrow(S) + Delta M + E upright(" ") bold(\))$

$$

, where the hardness of the LWE and RLWE problems guarantees that
guessing $arrow(S)$ is difficult given $arrow(A)$ and $E$ are randomly
picked at each encryption. On the other hand, the public key encryption
scheme is as follows:

\$\\textsf{GLWE}\_{S, \\sigma}(\\Delta M  + E\_{\\textit{all}}) = \\bm{(} \\text{ } \\vec{D} = \\vv{{\\mathit{PK}}}\_2 \\cdot U + \\vec{E}\_2, \\text{ } B = \\mathit{PK}\_1\\cdot U + \\Delta  M + E\_1 \\text{ } \\bm{)}\$

$$

, where $italic(P K)_1$, \$\\vv{\\mathit{PK}}\_2\$ are fixed and $U$,
$E_1$, $arrow(E)_2$ are randomly picked at each encryption. Given the
polynomial degree $n$ is large, both schemes provide the equivalent
level of hardness to solve the problem.
