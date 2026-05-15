#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-2")[TFHE Deep Dive - Part II - Encodings and linear leveled operations]~@tfhe-2

$$

Suppose we have a GLWE ciphertext ct:

$sans("ct") = sans("GLWE")_(S\,sigma)\(Delta M + E\)=\(A_0\,A_1\,dots.h\,A_(k - 1)\,B\)in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

$$

and a new plaintext polynomial $Lambda$ as follows:

$Lambda = sum_(i = 0)^(n - 1)\(Lambda_i dot.op X_i\)in cal(R)_(chevron.l n\,q chevron.r)$

$$

Let's define the following ciphertext-to-plaintext multiplication
operation:

$Lambda dot.op sans("ct") =\(Lambda dot.op A_0\,Lambda dot.op A_1\,dots.h\,Lambda dot.op A_(k - 1)\,Lambda dot.op B\)$

$$

We assume that we always do polynomial-to-polynomial multiplications
efficiently in $O\(n log n\)$ by using the NTT technique
(#link(<sec:ntt>)[\[sec:ntt\]]). Then, the following is true:

#block[
$Lambda dot.op sans("GLWE")_(S\,sigma)\(Delta M + E\)$

$= Lambda dot.op\({ A_i^(chevron.l 1 chevron.r) }_(i = 0)^(k - 1)\,upright(" ") B^(chevron.l 1 chevron.r)\)$

$=\({ Lambda dot.op A_i^(chevron.l 1 chevron.r) }_(i = 0)^(k - 1)\,upright(" ") Lambda dot.op B^(chevron.l 1 chevron.r)\)$

$= sans("GLWE")_(S\,sigma)\(Delta\(M dot.op Lambda\)+ Lambda dot.op E\)$

]
This means that multiplying a plaintext polynomial $Lambda$ by a GLWE
ciphertext that encrypts $M$ and decrypting it yields $M dot.op Lambda$.

$$

#block[
+ Define the following notations: \ $A'_0 = Lambda dot.op A_0$ \
  $A'_1 = Lambda dot.op A_1$ \ $dots.v$ \
  $A'_(k - 1) = Lambda dot.op A_(k - 1)$ \ $E' = Lambda dot.op E$ \
  $B' = Lambda dot.op B$ \

+ Derive the following: \ $B' = Lambda dot.op B$ \
  $= Lambda dot.op\(sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E\)$
  $= sum_(i = 0)^(k - 1)\(Lambda dot.op A_i dot.op S_i\)+ Delta dot.op Lambda dot.op M + Lambda dot.op E$
  \ $gt.tri$ by the distributive property of a polynomial ring \
  $= sum_(i = 0)^(k - 1)\(\(Lambda dot.op A_i\)dot.op S_i\)+ Delta dot.op\(Lambda dot.op M\)+\(Lambda dot.op E\)$
  \
  $= sum_(i = 0)^(k - 1)\(A'_i dot.op S_i\)+ Delta dot.op\(Lambda dot.op M\)+\(E'\)$
  \

+ Since
  $B' = sum_(i = 0)^(k - 1)\(A'_i dot.op S_i\)+ Delta dot.op\(Lambda dot.op M\)+\(E'\)$,

  $\(A'_0\,A'_1\,dots.h\,A'_(k - 1)\,B'\)$ form the ciphertext
  $sans("GLWE")_(S\,sigma)\(Delta dot.op Lambda dot.op M\)$.

+ Thus, \ $Lambda dot.op sans("GLWE")_(S\,sigma)\(Delta M + E\)$ \
  $=\(Lambda dot.op A_0\,upright(" ") Lambda dot.op A_1\,dots.h\,Lambda dot.op A_(k - 1)\,upright(" ") Lambda dot.op B\)$
  \ $=\({ A'_i }_(i = 0)^(k - 1)\,upright(" ") Lambda dot.op B\)$ \
  $= sans("GLWE")_(S\,sigma)\(Delta\(M dot.op Lambda\)+ Lambda dot.op E\)$

]
If we decrypt
$sans("GLWE")_(S\,sigma)\(Delta dot.op Lambda dot.op M + Lambda dot.op E\)$
by using $S$, then we get the plaintext $Lambda dot.op M$. Meanwhile,
$A'_0\,A'_1\,dots.h\,A'_(k - 1)\,E'$ get eliminated by rounding during
decryption, regardless of whatever their values were randomly sampled
during encryption.

The noise is a bigger problem now, because after decryption, the
original ciphertext ct's noise has increased from $E$ to
$E' = Lambda dot.op E$. This means that if we continue multiplication
computations without decrypting the ciphertext to eliminate the noise
$E'$, it will continue growing more and eventually the noise in the
lower bit area in $B$ will overflow to the scaled plaintext bit area. If
this happens, the noise $E'$ won't be eliminated during decryption,
ending up corrupting the plaintext $M$. Therefore, if the constant
$Lambda$ is big, it is recommended to use gadget decomposition
(#link(<subsec:gadget-decomposition>)[\[subsec:gadget-decomposition\]]),
which we will explain in the next subsection.

== Gadget Decomposition for Noise Suppression
<subsubsec:gadget-decomposition-noise-suppression>
In the ciphertext-to-plaintext multiplication
$Lambda dot.op sans("GLWE")_(S\,sigma)\(Delta M\)$, the noise $E$ grows
to $E' = Lambda dot.op E$. To limit this noise growth, we introduce a
technique based on decomposing $Lambda$
(#link(<subsec:number-decomp>)[\[subsec:number-decomp\]]) and a GLev
encryption (#link(<subsec:glev-enc>)[\[subsec:glev-enc\]]) of $M$ as
follows:

$Lambda = Lambda_1 q / beta^1 + Lambda_2 q / beta^2 + dots.h.c + Lambda_l q / beta^l arrow.r sans("Decomp")^(beta\,l)\(Lambda\)=\(Lambda_1\,Lambda_2\,dots.h.c\,Lambda_l\)$

$$

$sans("GLev")_(S\,sigma)^(beta\,l)\(Delta M\)= #scale(x: 300%, y: 300%)[{] sans("GLWE")_(S\,sigma) (Delta M q / beta^1 + E_1)\,sans("GLWE")_(S\,sigma) (Delta M q / beta^2 + E_2)\,dots.h.c sans("GLWE")_(S\,sigma) (Delta M q / beta^l + E_l) #scale(x: 300%, y: 300%)[}]$

$$

We will encrypt the plaintext $M$ as
$sans("GLev")_(S\,sigma)^(beta\,l)\(Delta M\)$ instead of
$sans("GLWE")_(S\,sigma)\(Delta M\)$, and compute
$sans("Decomp")^(beta\,l)\(Lambda\)dot.op sans("GLev")_(S\,sigma)^(beta\,l)\(Delta M\)$
instead of $Lambda dot.op sans("GLWE")_(S\,sigma)\(Delta M\)$. Notice
that the results of both computations are the same as follows:

$sans("Decomp")^(beta\,l)\(Lambda\)dot.op sans("GLev")_(S\,sigma)^(beta\,l)\(Delta M\)$

$=\(Lambda_1\,Lambda_2\,dots.h.c\,Lambda_l\)dot.op (sans("GLWE")_(S\,sigma) (q / beta Delta M + E_1) \, upright(" ") sans("GLWE")_(S\,sigma) (q / beta^2 Delta M + E_2) \, upright(" ") dots.h.c \, upright(" ") sans("GLWE")_(S\,sigma) (q / beta^l Delta M + E_l))$

$= Lambda_1 dot.op sans("GLWE")_(S\,sigma) (q / beta Delta M + E_1) + Lambda_2 dot.op sans("GLWE")_(S\,sigma) (q / beta^2 Delta M + E_2) + dots.h.c + Lambda_l dot.op sans("GLWE")_(S\,sigma) (q / beta^l Delta M + E_l)$

$= sans("GLWE")_(S\,sigma) (Lambda_1 dot.op q / beta Delta M + Lambda_1 E_1) + sans("GLWE")_(S\,sigma) (Lambda_2 dot.op q / beta^2 Delta M + Lambda_2 E_2) + dots.h.c + sans("GLWE")_(S\,sigma) (Lambda_l dot.op q / beta^l Delta M + Lambda_l E_l)$

$= sans("GLWE")_(S\,sigma) (Lambda_1 dot.op q / beta Delta M + Lambda_2 dot.op q / beta^2 Delta M + dots.h.c + Lambda_l dot.op q / beta^l Delta M)$

$= sans("GLWE")_(S\,sigma) ((Lambda_1 dot.op q / beta + Lambda_2 dot.op q / beta^2 + dots.h.c + Lambda_l dot.op q / beta^l) dot.op Delta M + E_(italic("all")))$
$gt.tri$ where $E_(italic("all")) = sum_(i = 1)^l Lambda_i E_i$

$= sans("GLWE")_(S\,sigma) (Lambda dot.op Delta M + E_(italic("all")))$
$gt.tri$ whose decryption is $Lambda dot.op M$

$$

While the decrypted results are the same, as we decompose $Lambda$ into
smaller plaintext polynomials $Lambda_1\,Lambda_2\,dots.h.c\,Lambda_l$,
the noise generated by each of $l$ plaintext-to-ciphertext
multiplications becomes smaller. Given the noise of each GLWE ciphertext
in the GLev ciphertext is $E_i$, the final noise of the
ciphertext-to-plaintext multiplication is
$E_(italic("all")) = sum_(i = 1)^l Lambda_i dot.op E_i$, which is much
smaller than $Lambda dot.op E$, because the coefficients of each
decomposed polynomial $Lambda_i$ are significantly smaller than those of
$Lambda$ (i.e., $parallel Lambda_i parallel_oo lt.eq beta\/2$, whereas
$parallel Lambda parallel_oo$ can be as large as $q\/2$). This is
visually depicted in~#link(<fig:decomp2>)[1].

#figure(image("figures/decomp2.pdf", width: 80.0%),
  caption: [
    Noise reduction in ciphertext-to-plaintext multiplication by gadget
    decomposition.
  ]
)
<fig:decomp2>

=== Discussion
<subsubsec:glwe-mult-plain-discuss>
Nevertheless, the decomposition technique is still very useful: for GLWE
key-switching
(#link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]), we will
show how to key-switch by combining decomposed mask polynomials
$sans("Decomp")^(beta\,l)\(A_i\)$ with a precomputed key-switching key
$sans("KSK")_i = sans("GLev")_(S'\,sigma)^(beta\,l)\(S_i\)$, so gadget
decomposition can be repeatedly leveraged across key-switching calls
even though each individual application outputs a standard GLWE
ciphertext.

Meanwhile, for the technique to repeatedly re-initialize the noise $E$
of regular ciphertexts, we will describe TFHE's noise bootstrapping
technique in
#link(<subsec:tfhe-noise-bootstrapping>)[\[subsec:tfhe-noise-bootstrapping\]].
