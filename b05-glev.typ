A GLev ciphertext is a list of GLWE ciphertexts that encrypt the list of
plaintexts $q / beta^1 M\,q / beta^2 M\,dots.h\,q / beta^l M$, where $M$
is a plaintext encoded in a polynomial. Note that each $i$-th GLWE
ciphertext of a GLev ciphertext uses a different plaintext scaling
factor, which is: $Delta_i = q / beta^i$. The structure of GLev
ciphertext is visually depicted in #link(<fig:glev>)[1].

Note that $beta$ should be some value between $t$ and $q$. Specifically,
$t$ should be smaller than or equal to $beta$ because if $t$ is greater
than $beta$, then the higher bits of $M$ will overflow beyond $q$ when
computing $q / beta^1 M$.

== Encryption
<subsec:glev-enc>
#block[
$sans("GLev")_(S\,sigma)^(beta\,l)\(M\)= #scale(x: 180%, y: 180%)[{] sans("GLWE")_(S\,sigma) (q / beta^i M + E_i) #scale(x: 180%, y: 180%)[}]_(i = 1)^l in cal(R)_(chevron.l n\,q chevron.r)^(\(k + 1\)dot.op l)$

]
#figure(image("figures/TFHE-fig2.pdf", width: 100.0%),
  caption: [
    An illustration of a GLev ciphertext
  ]
)
<fig:glev>

== Decryption
<decryption>
We decrypt the first GLWE ciphertext ($i = 1$) using the secret $S$,
with the scaling factor $Delta_1 = q / beta$. This is because while the
ciphertext contains $l$ encryptions, the higher indices $i > 1$ have
progressively smaller scaling factors $Delta_i = q\/beta^i$. If
$Delta_i$ becomes smaller than the noise threshold, those specific
components cannot be decrypted correctly.

== Lev and RLev
<lev-and-rlev>
Lev is GLev with $n = 1$. RLev is GLev with $k = 1$.
