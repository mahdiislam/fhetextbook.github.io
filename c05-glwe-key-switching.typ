#strong[\- Reference:]
#link("https://www.zama.ai/post/tfhe-deep-dive-part-3")[TFHE Deep Dive - Part III - Key switching and leveled multiplications]~@tfhe-3

$$

Key switching is a process to change a GLWE ciphertext's secret key from
$S$ to a new key $S'$ without decrypting the ciphertext. This is
equivalent to converting a ciphertext
$sans("GLWE")_(S\,sigma)\(Delta M + E\)$ into a new ciphertext
$sans("GLWE")_(S'\,sigma)\(Delta M + E - E'\)$.

$$

Remember that
$sans("GLWE")_(S\,sigma)\(Delta M + E\)=\(A_0\,A_1\,dots.h\,A_(k - 1)\,B\)in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

, where $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E$

, and the secret key $S$ is a list of $k$ polynomials:
$S =\(S_0\,S_1\,dots.h\,S_(k - 1)\)$

$$

Also, remember that GLev (#link(<sec:glev>)[\[sec:glev\]]) is defined as
follows:

$sans("GLev")_(S\,sigma)^(beta\,l)\(M\)= #scale(x: 180%, y: 180%)[{] upright("GLWE")_(S\,sigma) #scale(x: 180%, y: 180%)[\(] q / beta^i dot.op M + E_i #scale(x: 180%, y: 180%)[\)] #scale(x: 180%, y: 180%)[}]_(i = 1)^l in cal(R)_(chevron.l n\,q chevron.r)^(\(k + 1\)dot.op l)$

$$

Now, let us denote each of the $k$ key-switching keys as follows:

$italic(K S K)_i = sans("GLev")_(S'\,sigma)^(beta\,l)\(S_i\)$ \
$= (sans("GLWE")_(S'\,sigma) (q / beta^1 S_i + E_(i\,1)) \, sans("GLWE")_(S'\,sigma) (q / beta^2 S_i + E_(i\,2)) \, dots.h \, sans("GLWE")_(S'\,sigma) (q / beta^l S_i + E_(i\,l))) in cal(R)_(chevron.l n\,q chevron.r)^(\(k' + 1\)dot.op l)$

$$

, which is a list of GLWE encryptions of the secret key $S$ by $S'$, and
the new secret key $S'$ is a list of $k'$ polynomials,
$\(S'_0\,S'_1\,dots.h\,S'_(k' - 1)\)$. Then, the GLWE ciphertext's key
can be switched from $S arrow.r S'$ as follows:

#block[
Given $sans("GLWE")_(S\,sigma)\(Delta M + E\)=\(A\,B\)$,

$sans("GLWE")_(S'\,sigma)\(Delta M + E'\)=\(overbrace(0\,0\,dots.h\,0, k')\,B\)- sum_(i = 0)^(k - 1) A_i dot.op S_i$

$=\(0\,0\,dots.h\,0\,B\)- sum_(i = 0)^(k - 1) chevron.l sans("Decomp")^(beta\,l)\(A_i\)\,italic(K S K)_i chevron.r$

]
#block[
+ Given the principle of polynomial decomposition
  (#link(<subsec:poly-decomp>)[\[subsec:poly-decomp\]]) and the
  polynomial $A_i in bb(Z)_q\[x\]\/\(x^n + 1\)$, its decomposition is as
  follows:

  $$

  $sans("Decomp")^(beta\,l)\(A_i\)=\(A_(i\,1)\,A_(i\,2)\,dots.h\,A_(i\,l)\)$,
  where

  $$

  $A_i = A_(i\,1) q / beta^1 + A_(i\,2) q / beta^2 + dots.h.c + A_(i\,l) q / beta^l$

  $$

+ $chevron.l sans("Decomp")^(beta\,l)\(A_i\)\,italic(K S K)_i chevron.r$
  \
  $= A_(i\,1) dot.op sans("GLWE")_(S'\,sigma) (q / beta^1 S_i + E_(i\,1)) + A_(i\,2) dot.op sans("GLWE")_(S'\,sigma) (q / beta^2 S_i + E_(i\,2)) + dots.h.c + A_(i\,l) dot.op sans("GLWE")_(S'\,sigma) (q / beta^l S_i + E_(i\,l))$

  $gt.tri$ where each GLWE ciphertext is an encryption of
  $S_i q / beta\,S_i q / beta^2\,dots.h.c\,S_i q / beta^l$ as plaintext
  with the plaintext scaling factor 1

  $$

  $= sans("GLWE")_(S'\,sigma) ((A_(i\,1) q / beta^1 + A_(i\,2) q / beta^2 + dots.h.c + A_(i\,l) q / beta^l) dot.op S_i + E_i)$
  $gt.tri$ where $E_i = sum_(j = 1)^l A_(i\,j) E_(i\,j)$

  $= sans("GLWE")_(S'\,sigma) ((A_i) dot.op S_i + E_i) = sans("GLWE")_(S'\,sigma)\(A_i S_i + E_i\)$

  $$

+ $sum_(i = 0)^(k - 1) chevron.l sans("Decomp")^(beta\,l)\(A_i\)\,italic(K S K)_i chevron.r = sum_(i = 0)^(k - 1)\(sans("GLWE")_(S'\,sigma)\(A_i S_i + E_i\)\)$

  $= sans("GLWE")_(S'\,sigma) (sum_(i = 0)^(k - 1) A_i S_i + E_i)$

  $$

+ $B$ is equivalent to a trivial GLWE encryption with $S'$, where its
  every $A_0\,A_1\,dots.h\,A_(k' - 1)$ is 0. That is,
  $sans("GLWE")_(S'\,sigma)\(B\)=\(overbrace(0\,0\,dots.h, k')\,B\)$.
  Note that $sans("GLWE")_(S'\,sigma)\(B\)$ can be created without the
  knowledge of $S'$, because its all $A_i S_i$ terms are 0.

  $$

+ $sans("GLWE")_(S'\,sigma)\(B\)- sans("GLWE")_(S'\,sigma) (sum_(i = 0)^(k - 1) \( A_i S_i + E_i \))$

  $= sans("GLWE")_(S'\,sigma)\(B - sum_(i = 0)^(k - 1)\(A_i S_i + E_i\)\)$

  $= sans("GLWE")_(S'\,sigma)\(Delta M + E'\)$ $gt.tri$ where
  $E' = E - sum_(i = 0)^(k - 1) E_i$

  $$

+ If we explicitly expand the above relation,

  $sans("GLWE")_(S'\,sigma)\(B\)- sans("GLWE")_(S'\,sigma) (sum_(i = 0)^(k - 1) \( A_i S_i + E_i \))$

  $=\(overbrace(0\,0\,dots.h, k')\,B\)-\(overbrace(A'_0\,A'_1\,dots.h\,A'_(k' - 1), k')\,B'\)$
  $gt.tri$ where
  $B' = sum_(i = 0)^(k' - 1) A'_i S'_i + sum_(i = 0)^(k - 1) A_i S_i + sum_(i = 0)^(k - 1) E_i$

  $\(overbrace(- A'_0\,- A'_1\,dots.h\,- A'_(k' - 1), k')\,upright(" ") B - B'\)$

  $$

  The decryption of the above ciphertext gives us:

  $sans("GLWE")_(S'\,sigma)^(- 1) bold(#scale(x: 180%, y: 180%)[\(]) upright(" ")\(overbrace(- A'_0\,- A'_1\,dots.h\,- A'_(k' - 1), k')\,upright(" ") B - B'\)upright(" ") bold(#scale(x: 180%, y: 180%)[\)])$

  $= B - B' - sum_(i = 0)^(k' - 1) - A'_i S'_i$

  $= B - sum_(i = 0)^(k' - 1) A'_i S'_i - sum_(i = 0)^(k - 1) A_i S_i - sum_(i = 0)^(k - 1) E_i + sum_(i = 0)^(k' - 1) A'_i S'_i$

  $= B - sum_(i = 0)^(k - 1) A_i S_i - sum_(i = 0)^(k - 1) E_i$

  $= Delta M + E - sum_(i = 0)^(k - 1) E_i$

  $= Delta M + E' approx Delta M + E$ $gt.tri$ where
  $E' = E - sum_(i = 0)^(k - 1) E_i$

  Strictly speaking,
  $B - sum_(i = 0)^(k - 1) A_i S_i = Delta M + E + K q$ where $K$ is a
  polynomial representing the wrap-around coefficient values as
  multiples of $q$. However, since all the above computations are done
  in modulo $q$, the $K q$ term gets eliminated.

  $$

+ Thus,
  $\(0\,0\,dots.h\,B\)- sum_(i = 0)^(k - 1) chevron.l sans("Decomp")^(beta\,l)\(A_i\)\,italic(K S K)_i chevron.r = sans("GLWE")_(S'\,sigma)\(Delta M + E'\)approx sans("GLWE")_(S'\,sigma)\(Delta M + E\)$

  $sans("GLWE")_(S'\,sigma)\(Delta M + E'\)$ is an encryption of
  plaintext $Delta M$ with the plaintext scaling factor 1. However, we
  can re-interpret this ciphertext as an encryption of plaintext $M$
  with the plaintext scaling factor $Delta$. This way, we can recover
  the ciphertext's original scaling factor $Delta$ without any
  additional computation.

]
