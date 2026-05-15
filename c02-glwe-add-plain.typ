Suppose we have a GLWE ciphertext ct and a new plaintext polynomial
$Lambda$ as follows:

$sans("ct") = sans("GLWE")_(S\,sigma)\(Delta M + E\)=\(A_0\,A_1\,dots.h\,A_(k - 1)\,B\)in cal(R)_(chevron.l n\,q chevron.r)^(k + 1)$

$Lambda$: a new plaintext polynomial

$Delta Lambda$: a $Delta$-scaled new plaintext polynomial

$$

Let's define the following ciphertext-to-plaintext addition operation:

$sans("ct") + Delta Lambda =\(A_0\,upright(" ") A_1\,dots.h\,A_(k - 1)\,upright(" ") B + Delta Lambda\)$

$$

Then, the following is true:

#block[
$sans("GLWE")_(S\,sigma)\(Delta M + E\)+ Delta Lambda$

$=\({ A_i }_(i = 0)^(k - 1)\,upright(" ") B\)+ Delta Lambda$

$=\({ A_i }_(i = 0)^(k - 1)\,upright(" ") B + Delta Lambda\)$

$= sans("GLWE")_(S\,sigma)\(Delta\(M + Lambda\)+ E\)$

]
This means that adding a ($Delta$-scaled) plaintext polynomial $Lambda$
to a GLWE ciphertext that encrypts $M$ and decrypting it yields
$M + Lambda$.

#block[
+ Since $B = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E$,

  $B + Delta dot.op Lambda = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op M + E + Delta dot.op Lambda = sum_(i = 0)^(k - 1)\(A_i dot.op S_i\)+ Delta dot.op\(M + Lambda\)+ E$
  \ This means that
  $\(A_0\,A_1\,. . . upright(" ") A_(k - 1)\,B + Delta Lambda\)$ form
  the ciphertext $sans("GLWE")_(S\,sigma)\(Delta\(Lambda + M\)+ E\)$

+ Thus, \ $sans("GLWE")_(S\,sigma)\(Delta M + E\)+ Delta Lambda$ \
  $=\(A_0\,upright(" ") A_1\,. . . upright(" ") A_(k - 1)\,upright(" ") B + Delta Lambda\)$
  \ $=\({ A_i }_(i = 0)^(k - 1)\,upright(" ") B + Delta Lambda\)$ \
  $= sans("GLWE")_(S\,sigma)\(Delta\(M + Lambda\)+ E\)$

]
Note that after decryption, the original ciphertext
$sans("ct") + Delta Lambda$'s noise $E$ stays the same as before. This
means that ciphertext-to-plaintext addition does not increase the noise
level.
