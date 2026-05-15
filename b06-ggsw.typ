The GGSW cryptosystem is a list of GLev ciphertexts. In the GGSW
cryptosystem, the secret key $S$ is a list of $k$ polynomials (i.e.,
$S_0\,S_1\,. . . upright(" ") S_(k - 1)$), and each $i$-th GLev
ciphertext in the GGSW ciphertext encrypts the plaintext
$- S_0 dot.op M\,- S_1 dot.op M\,dots.h\,- S_(k - 1) dot.op M$, and $M$.
This is visually depicted in #link(<fig:ggsw>)[1].

== Encryption
<subsec:ggsw-enc>
#block[
$sans("GGSW")_(S\,sigma)^(beta\,l)\(M\)= #scale(x: 180%, y: 180%)[{] { sans("GLev")_(S\,sigma)^(beta\,l)\(- S_i dot.op M\)}_(i = 0)^(k - 1)\,sans("GLev")_(S\,sigma)^(beta\,l)\(M\)#scale(x: 180%, y: 180%)[}] in cal(R)_(chevron.l n\,q chevron.r)^(\(k + 1\)dot.op l dot.op\(k + 1\))$

]
#figure(image("figures/TFHE-fig3.pdf", width: 100.0%),
  caption: [
    An illustration of a GGSW ciphertext
  ]
)
<fig:ggsw>

== Decryption
<decryption>
To recover the message $M$, it is sufficient to decrypt the last GLev
ciphertext (the one encrypting $M$) using the secret $S$. Decrypting the
other rows yields $- S_i dot.op M$, but recovering $M$ from these rows
is only possible if $S_i$ is invertible (i.e., $S_i eq.not 0$).

== GSW and RGSW
<gsw-and-rgsw>
GSW is GGSW with $n = 1$. RGSW is GGSW with $k = 1$.
