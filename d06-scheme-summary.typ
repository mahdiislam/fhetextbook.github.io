We summarize and compare TFHE, BFV, CKKS, and BGV as follows:

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], [#strong[Hard Problem Basis]],),
    table.hline(),
    [#strong[TFHE]], [LWE],
    [#strong[BFV]], [],
    [#strong[CKKS]], [RLWE],
    [#strong[BGV]], [],
  )]
  , caption: [#strong[Hard Problem Basis]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], [#strong[Unit Data Type]],),
    table.hline(),
    [#strong[TFHE]], [Vector],
    [#strong[BFV]], [],
    [#strong[CKKS]], [Polynomial],
    [#strong[BGV]], [],
  )]
  , caption: [#strong[Unit Data Type]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Plaintext]],),
    table.hline(),
    [#strong[TFHE]], [Number $m in bb(Z)_t$ $gt.tri$ $t$ is a power of
    2],
    [#strong[BFV]], [Polynomial $M in bb(Z)_t\[X\]\/X^n + 1$ $gt.tri$
    $t$ is a prime, and $n$ is a power of 2],
    [#strong[CKKS]], [Polynomial $M in bb(R)\[X\]\/X^n + 1$ $gt.tri$ $n$
    is a power of 2],
    [#strong[BGV]], [Polynomial $M in bb(Z)_t\[X\]\/X^n + 1$ $gt.tri$
    $t$ is a prime, and $n$ is a power of 2],
  )]
  , caption: [#strong[Plaintext]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Secret Key]],),
    table.hline(),
    [#strong[TFHE]], [Vector $arrow(s) arrow.l^(\$) bb(Z)_2^k$ sampled
    from ${ 0\,1 }$ $gt.tri$ $\$$ is a uniform random distribution],
    [#strong[BFV]], [],
    [#strong[CKKS]], [Polynomial $S arrow.l^(\$) bb(Z)_3\[X\]\/X^n + 1$,
    where $bb(Z)_3 = { - 1\,0\,1 }$],
    [#strong[BGV]], [],
  )]
  , caption: [#strong[Secret Key]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Ciphertext]],),
    table.hline(),
    [#strong[TFHE]], [\(Vector $arrow(a)$, Number $b$) =
    $\(arrow(a) arrow.l^(\$) bb(Z)_q^k$, $upright(" ") b in bb(Z)_q\)$
    $gt.tri$ $q gt.double t$, and $t$ divides $q$],
    [#strong[BFV]], [],
    [#strong[CKKS]], [\(Polynomial $A\,B$) =
    $\(A arrow.l^(\$) bb(Z)_q\[X\]\/X^n + 1$,
    $B in bb(Z)_q\[X\]\/X^n + 1\)$ $gt.tri$ $q gt.double t$],
    [#strong[BGV]], [],
  )]
  , caption: [#strong[Ciphertext]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Noise]],),
    table.hline(),
    [#strong[TFHE]], [Number $e arrow.l^chi bb(Z)_q$ $gt.tri$ $chi$ is a
    Gaussian random distribution],
    [#strong[BFV]], [],
    [#strong[CKKS]], [Polynomial $E arrow.l^chi bb(Z)_q\[X\]\/X^n + 1$],
    [#strong[BGV]], [],
  )]
  , caption: [#strong[Noise]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Scaling Factor]],),
    table.hline(),
    [#strong[TFHE]], [Used for $Delta m$, where $Delta = q / t$ $gt.tri$
    $t$ divides $q$],
    [#strong[BFV]], [Used for $Delta M$, where $Delta = ⌊q / t⌋$
    $gt.tri$ $t$ is a prime],
    [#strong[CKKS]], [Used for $Delta M$, where
    $Delta dot.op\|\|M\|\|_oolt.double q_0$],
    [], [ $gt.tri$ $q_0$ is the lowest multiplicative level's ciphertext
    modulus],
    [#strong[BGV]], [Used for $Delta E$, where $Delta = t$ $gt.tri$$t$
    is a prime],
  )]
  , caption: [#strong[Scaling Factor]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Encryption]],),
    table.hline(),
    [#strong[TFHE]], [$\(arrow(a)\,b\)$ where
    $arrow(a) arrow.l^(\$) bb(Z)_q^k$,
    $upright(" ") b = Delta m + e - a dot.op s med mod med q$,
    $e arrow.l^chi bb(Z)_q$],
    [], [ $gt.tri$ After using $e$ each time, throw it away],
    [#strong[BFV]], [$\(A\,B\)$ where
    $A arrow.l^(\$) bb(Z)_q\[X\]\/\(X^n + 1\)$,
    $upright(" ") B = Delta M + E - A dot.op S med mod med q$,
    $E arrow.l^chi bb(Z)_q\[X\]\/\(X^n + 1\)$],
    [#strong[CKKS]], [ $gt.tri$ After using $E$ each time, throw it
    away],
    [#strong[BGV]], [$\(A\,B\)$ where
    $A arrow.l^(\$) bb(Z)_q\[X\]\/\(X^n + 1\)$,
    $upright(" ") B = M + Delta E - A dot.op S med mod med q$,
    $E arrow.l^chi bb(Z)_q\[X\]\/\(X^n + 1\)$],
    [], [ $gt.tri$ After using $E$ each time, throw it away],
  )]
  , caption: [#strong[Encryption]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Cryptographic
      Relation]],),
    table.hline(),
    [#strong[TFHE]], [$b + a dot.op s = Delta m + e med\(mod med q\)$,
    where $Delta = q / t$ $gt.tri$ $t$ divides $q$],
    [#strong[BFV]], [$B + A dot.op S = Delta M + E med\(mod med q\)$,
    where $Delta = ⌊q / t⌋$ $gt.tri$ $t$ is a prime],
    [#strong[CKKS]], [$B + A dot.op S = Delta M + E med\(mod med q\)$,
    where $Delta dot.op\|\|M\|\|_oolt.double q_0$],
    [], [ $gt.tri$ $q_0$ is the lowest multiplicative level's ciphertext
    modulus],
    [#strong[BGV]], [$B + A dot.op S = M + Delta E med\(mod med q\)$,
    where $Delta = t$ $gt.tri$ $t$ is a prime],
  )]
  , caption: [#strong[Cryptographic Relation]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Decryption
      Formula]],),
    table.hline(),
    [#strong[TFHE]], [$m = ⌈frac(\(b + a dot.op s med mod med q\), Delta)⌋ med mod med t$],
    [], [\$\\textcolor{white}{m} = \\left\\lceil\\dfrac{(\\Delta m + e)}{\\Delta}\\right\\rfloor \\bmod t\$
    $gt.tri$ $e$ gets eliminated if $e < Delta / 2$],
    [#strong[BFV]], [$M = ⌈frac(\(B + A dot.op S med mod med q\), Delta)⌋ med mod med t$],
    [], [\$\\textcolor{white}{M} = \\left\\lceil\\dfrac{(\\Delta M + E)}{\\Delta}\\right\\rfloor  \\bmod t\$
    $gt.tri$ $E$ gets eliminated if $\|\|E\|\|_oo< Delta / 2$],
    [#strong[CKKS]], [$M = ⌈frac(\(B + A dot.op S med mod med q\), Delta)⌋_(1 / Delta)$],
    [], [\$\\textcolor{white}{M} = \\left\\lceil\\dfrac{\\Delta M + E}{\\Delta}\\right\\rfloor\_{\\frac{1}{\\Delta}}\$
    $gt.tri$ The final noise remains as $E / Delta$ (increase $Delta$ to
    reduce it)],
    [#strong[BGV]], [$M =\(B + A dot.op S med mod med q\)med mod med t$],
    [], [\$\\textcolor{white}{M} = (M + \\Delta E) \\bmod t\$ $gt.tri$
    $E$ gets removed if $Delta E < q$],
  )]
  , caption: [#strong[Decryption Formula]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Ciphertext
      Modulus]],),
    table.hline(),
    [#strong[TFHE]], [A single number $q$ $gt.tri$ $q gt.double t$, and
    $t$ divides $q$],
    [#strong[BFV]], [A single number $q$ $gt.tri$ $q gt.double t$],
    [#strong[CKKS]], [An $L$-multiplicative-level modulus chain
    ${ q_0\,q_1\,dots.h.c\,q_L }$],
    [], [ $gt.tri$ each $q_i = product_(j = 0)^l w_j$, and each $w_j$ is
    a CRT modulus],
    [], [ having the property:
    $w_0 gt.double Delta dot.op\|\|M\|\|_oo\,upright(" ") w_j approx Delta$
    (for $1 lt.eq j lt.eq L$)],
    [#strong[BGV]], [An $L$-multiplicative-level modulus chain
    ${ q_0\,q_1\,dots.h.c\,q_L }$],
    [], [ $gt.tri$ each $q_i = product_(j = 0)^l w_j$, and each $w_j$ is
    a CRT modulus],
    [], [ having the property:
    $w_0 equiv w_1 equiv dots.h.c equiv w_L med mod med t$],
  )]
  , caption: [#strong[Ciphertext Modulus]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Ciphertext-to-Ciphertext
      Addition]],),
    table.hline(),
    [#strong[TFHE]], [- Ciphertext
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)=\(arrow(a)_1\,b_1\)=\(a_(1\,0)\,a_(1\,1)\,dots.h.c\,a_(1\,k - 1)\,b_1\)med mod med q$],
    [], [- Ciphertext
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_2\)=\(arrow(a)_2\,b_2\)=\(a_(2\,0)\,a_(2\,1)\,dots.h.c\,a_(2\,k - 1)\,b_2\)med mod med q$],
    [], [$sans("LWE")_(arrow(s)\,sigma)\(Delta\(m_1 + m_2\)\)=\(arrow(a)_1 + arrow(a)_2\,b_1 + b_2\)med mod med q$],
    [#strong[BFV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q$],
    [], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_2\)=\(A_2\,B_2\)med mod med q$],
    [], [$sans("RLWE")_(S\,sigma)\(Delta\(M_1 + M_2\)\)=\(A_1 + A_2\,B_1 + B_2\)med mod med q$],
    [#strong[CKKS]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_2\)=\(A_2\,B_2\)med mod med q_l$],
    [], [$sans("RLWE")_(S\,sigma)\(Delta\(M_1 + M_2\)\)=\(A_1 + A_2\,B_1 + B_2\)med mod med q_l$],
    [#strong[BGV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(M_2\)=\(A_2\,B_2\)med mod med q_l$],
    [], [$sans("RLWE")_(S\,sigma)\(M_1 + M_2\)=\(A_1 + A_2\,B_1 + B_2\)med mod med q_l$],
  )]
  , caption: [#strong[Ciphertext-to-Ciphertext Addition]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Ciphertext-to-Plaintext
      Addition]],),
    table.hline(),
    [#strong[TFHE]], [- Ciphertext
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)=\(arrow(a)_1\,b_1\)=\(a_(1\,0)\,a_(1\,1)\,dots.h.c\,a_(1\,k - 1)\,b_1\)med mod med q$],
    [], [- Plaintext number $c in bb(Z)_t$],
    [], [$sans("LWE")_(arrow(s)\,sigma)\(Delta\(m_1 + c\)\)=\(arrow(a)_1\,b_1 + Delta c\)med mod med q$],
    [#strong[BFV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q$],
    [], [- Plaintext polynomial $C in bb(Z)_t\[X\]\/\(X^n + 1\)$],
    [], [$sans("RLWE")_(S\,sigma)\(Delta\(M_1 + C\)\)=\(A_1\,B_1 + Delta C\)med mod med q$],
    [#strong[CKKS]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Plaintext polynomial $C in bb(R)\[X\]\/\(X^n + 1\)$],
    [], [$sans("RLWE")_(S\,sigma)\(Delta\(M_1 + C\)\)=\(A_1\,B_1 + Delta C\)med mod med q_l$],
    [#strong[BGV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Plaintext polynomial $C in bb(Z)_t\[X\]\/\(X^n + 1\)$],
    [], [$sans("RLWE")_(S\,sigma)\(M_1 + C\)=\(A_1\,B_1 + C\)med mod med q_l$],
  )]
  , caption: [#strong[Ciphertext-to-Plaintext Addition]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Ciphertext-to-Plaintext
      Multiplication]],),
    table.hline(),
    [#strong[TFHE]], [- Ciphertext
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)=\(arrow(a)_1\,b_1\)=\(a_(1\,0)\,a_(1\,1)\,dots.h.c\,a_(1\,k - 1)\,b_1\)med mod med q$],
    [], [- Plaintext number $c in bb(Z)_t$],
    [], [$sans("LWE")_(arrow(s)\,sigma)\(Delta\(m_1 dot.op c\)\)=\(arrow(a)_1 dot.op c\,upright(" ") b_1 dot.op c\)med mod med q$],
    [#strong[BFV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q$],
    [], [- Plaintext polynomial $C in bb(Z)_t\[X\]\/\(X^n + 1\)$],
    [], [$sans("RLWE")_(S\,sigma)\(Delta\(M_1 dot.op C\)\)=\(A_1 dot.op C\,upright(" ") B_1 dot.op C\)$],
    [#strong[CKKS]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Plaintext polynomial $C in bb(R)\[X\]\/\(X^n + 1\)$],
    [], [1. #underline[Basic Multiplication]],
    [], [1.
    $sans("ct") = sans("RLWE")_(S\,sigma)\(Delta^2\(M_1 dot.op C\)\)=\(A_1 dot.op Delta C\,upright(" ") B_1 dot.op Delta C\)med mod med q_l$],
    [], [2. #underline[Rescaling] by $1 / Delta$:
    $⌈sans("ct") / Delta⌋ = sans("RLWE")_(S\,sigma)\(Delta M_1 C\)med mod med q_(l - 1)$],
    [#strong[BGV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Plaintext polynomial $C in bb(Z)_t\[X\]\/\(X^n + 1\)$],
    [], [$sans("RLWE")_(S\,sigma)\(M_1 dot.op C\)=\(A_1 dot.op C\,upright(" ") B_1 dot.op C\)med mod med q_l$],
  )]
  , caption: [#strong[Ciphertext-to-Plaintext Multiplication]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Ciphertext-to-Ciphertext
      Multiplication]],),
    table.hline(),
    [#strong[TFHE]], [- Ciphertext
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)=\(arrow(a)_1\,b_1\)=\(a_(1\,0)\,a_(1\,1)\,dots.h.c\,a_(1\,k - 1)\,b_1\)med mod med q$],
    [], [- Ciphertext
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_2\)=\(arrow(a)_2\,b_2\)=\(a_(2\,0)\,a_(2\,1)\,dots.h.c\,a_(2\,k - 1)\,b_2\)med mod med q$],
    [], [1. #underline[Programmable Bootstrapping]:],
    [], [1. Convert $sans("LWE")_(arrow(s)\,sigma)\(Delta m_2\)$ into
    $sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$.],
    [], [2. #underline[Homomorphic Multiplication]:],
    [], [2. Compute
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m_1\)dot.op sans("GSW")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)$],
    [], [$= sum_(i = 0)^(k - 1) chevron.l sans("Decomp")^(beta\,l)\(a_(1\,i)\)\,sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(- s_i dot.op m_2\)chevron.r + chevron.l sans("Decomp")^(beta\,l)\(b_1\)\,sans("Lev")_(arrow(s)\,sigma)^(beta\,l)\(m_2\)chevron.r$],
    [], [$= sans("LWE")_(arrow(s)\,sigma)\(Delta m_1 m_2\)$],
    [#strong[BFV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q$],
    [], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_2\)=\(A_2\,B_2\)med mod med q$],
    [], [1. #underline[ModRaise] from $q$ to $Q = q dot.op Delta$],
    [], [1. - Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med Q$],
    [], [1. - Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_2\)=\(A_2\,B_2\)med mod med Q$],
    [], [2. #underline[Polynomial Multiplication]:],
    [], [1.
    $\(A_1 A_2\,upright(" ") A_1 B_2 + A_2 B_1\,upright(" ") B_1 B_2\)equiv\(D_2\,D_1\,D_0\)med\(mod med Q\)$],
    [], [3. #underline[Relinearization]:
    $sans("ct")_alpha =\(D_1\,D_0\)\,$
    $sans("ct")_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$],
    [], [3. Relinearization:
    $sans("ct")_alpha + sans("ct")_beta = sans("ct")_(alpha + beta) = sans("RLWE")_(S\,sigma)\(Delta^2 M_1 M_2\)med mod med Q$],
    [], [4. #underline[Rescaling] by $1 / Delta$:
    $⌈sans("ct")_(alpha + beta) / Delta⌋ = sans("RLWE")_(S\,sigma)\(Delta M_1 M_2\)med mod med q$],
    [#strong[CKKS]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(Delta M_2\)=\(A_2\,B_2\)med mod med q_l$],
    [], [1. #underline[Polynomial Multiplication]:],
    [], [1.
    $\(A_1 A_2\,upright(" ") A_1 B_2 + A_2 B_1\,upright(" ") B_1 B_2\)equiv\(D_2\,D_1\,D_0\)med\(mod med q_l\)$],
    [], [2. #underline[Relinearization]:
    $sans("ct")_alpha =\(D_1\,D_0\)\,$
    $sans("ct")_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$],
    [], [3. Relinearization:
    $sans("ct")_alpha + sans("ct")_beta = sans("ct")_(alpha + beta) = sans("RLWE")_(S\,sigma)\(Delta^2 M_1 M_2\)med mod med q_l$],
    [], [3. #underline[Rescaling] by $1 / Delta$:
    $⌈sans("ct")_(alpha + beta) / Delta⌋ = sans("RLWE")_(S\,sigma)\(Delta M_1 M_2\)med mod med q_(l - 1)$],
    [#strong[BGV]], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(M_1\)=\(A_1\,B_1\)med mod med q_l$],
    [], [- Ciphertext
    $sans("RLWE")_(S\,sigma)\(M_2\)=\(A_2\,B_2\)med mod med q_l$],
    [], [1. #underline[Polynomial Multiplication]:],
    [], [1.
    $\(A_1 A_2\,upright(" ") A_1 B_2 + A_2 B_1\,upright(" ") B_1 B_2\)equiv\(D_2\,D_1\,D_0\)med\(mod med q_l\)$],
    [], [2. #underline[Relinearization]:
    $sans("ct")_alpha =\(D_1\,D_0\)\,$
    $sans("ct")_beta = bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$],
    [], [3. Relinearization:
    $sans("ct")_alpha + sans("ct")_beta = sans("ct")_(alpha + beta) = sans("RLWE")_(S\,sigma)\(M_1 M_2\)med mod med q_l$],
    [], [3. (Optional) #underline[Rescaling] by $1 / Delta$:
    $⌈sans("ct")_(alpha + beta) / Delta⌋_t = sans("RLWE")_(S\,sigma)\(M_1 M_2\)med mod med q_(l - 1)$],
    [], [ $gt.tri$ $ceil.l floor.r_t$ means rounding to the nearest
    multiple of $t$],
    [], [ $gt.tri$ The future noise growth rate gets reduced if the
    ciphertext is rescaled],
  )]
  , caption: [#strong[Ciphertext-to-Ciphertext Multiplication]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Maximum Possible
      Multiplications (without Bootstrapping)]],),
    table.hline(),
    [#strong[TFHE]], [Unlimited with programming bootstrapping (but not
    possible without it)],
    [#strong[BFV]], [Unlimited],
    [#strong[CKKS]], [As many times as the length of the modulus chain],
    [#strong[BGV]], [As many times as the length of the modulus chain],
  )]
  , caption: [#strong[Maximum Possible Multiplications (without
  Bootstrapping)]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Key Switching]],),
    table.hline(),
    [#strong[TFHE]], [Key-switching from
    $arrow(s) arrow.r arrow(s)_(')$:],
    [], [$sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m\)= b + a dot.op sans("LWE")_(arrow(s)_(')\,sigma)\(s\)$],
    [], [$sans("LWE")_(arrow(s)_(')\,sigma)\(Delta m\)$
    $= b + bold(chevron.l) sans("Decomp")^(beta\,l)\(arrow(a)\)\,upright(" ") sans("Lev")_(arrow(s)_(')\,sigma)^(beta\,l)\(arrow(s)\)bold(chevron.r)$],
    [#strong[BFV]], [Key-switching from $S arrow.r S'$:],
    [#strong[CKKS]], [$sans("RLWE")_(S'\,sigma)\(Delta M\)= B + A dot.op sans("RLWE")_(S'\,sigma)\(S\)$],
    [], [$sans("RLWE")_(S'\,sigma)\(Delta M\)$
    $= B + bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$],
    [#strong[BGV]], [Key-switching from $S arrow.r S'$:],
    [], [$sans("RLWE")_(S'\,sigma)\(M\)= B + A dot.op sans("RLWE")_(S'\,sigma)\(S\)$],
    [], [$sans("RLWE")_(S'\,sigma)\(M\)$
    $= B + bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$],
  )]
  , caption: [#strong[Key Switching]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Modulus Drop
      (ModDrop)]],),
    table.hline(),
    [#strong[CKKS]], [- Ciphertext with the multiplicative level $l$:
    $sans("RLWE")_(S\,sigma)\(Delta M\)=\(A\,B\)med mod med q_l$],
    [#strong[BGV]], [- Ciphertext with the multiplicative level
    $l - 1$:],
    [], [ -
    $sans("RLWE")_(S\,sigma)\(Delta M\)=\(A'\,B'\)=\(A med mod med q_(l - 1)\,B med mod med q_(l - 1)\)$],
  )]
  , caption: [#strong[Modulus Drop (ModDrop)]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Encoding and
      Decoding the Plaintext]],),
    table.hline(),
    [#strong[TFHE]], [No need, because each plaintext is a single
    number],
    [#strong[BFV]], [Must convert the input slots into polynomial
    coefficients to support batch processing:],
    [#strong[CKKS]], [- Encoding input slots $arrow(v)$ into polynomial
    coefficients:
    \$\\vec{m} = n^{-1}\\cdot\\vec{v}\\cdot I\_n^R \\cdot \\hathat W\$],
    [#strong[BGV]], [- Decoding polynomial coefficients $arrow(m)$ into
    input slots: \$\\vec{v} = \\vec{m} \\cdot \\hathat W^{\*}\$],
  )]
  , caption: [#strong[Encoding and Decoding the Plaintext]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Input Slot
      Rotation]],),
    table.hline(),
    [#strong[TFHE]], [Not applicable, because its plaintext is a single
    number (i.e., a single slot)],
    [#strong[BFV]], [Given
    $sans("ct") = sans("RLWE")_(S\(X\)\,sigma) bold(\() Delta M\(X\)bold(\)) = bold(\() A\(X\)\,B\(X\)bold(\))$,],
    [], [to rotate the input slots by $h$ positions to the left:],
    [#strong[CKKS]], [1. Update $sans("ct")$ to
    $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\)) = bold(\() A\(X^(J\(h\))\)$,
    $B\(X^(J\(h\))\)bold(\))$],
    [], [\(where $J\(h\)= 5^h med mod med 2 n$)],
    [], [2. Key-switch
    $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\))$
    to
    $sans("RLWE")_(S\(X\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\))$.],
    [#strong[BGV]], [Given
    $sans("ct") = sans("RLWE")_(S\(X\)\,sigma) bold(\() M\(X\)bold(\)) = bold(\() A\(X\)\,B\(X\)bold(\))$,],
    [], [to rotate the input slots by $h$ positions to the left:],
    [], [1. Update $sans("ct")$ to
    $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() M\(X^(J\(h\))\)bold(\)) = bold(\() A\(X^(J\(h\))\)$,
    $B\(X^(J\(h\))\)bold(\))$],
    [], [2. Key-switch
    $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() M\(X^(J\(h\))\)bold(\))$
    to
    $sans("RLWE")_(S\(X\)\,sigma) bold(\() M\(X^(J\(h\))\)bold(\))$.],
  )]
  , caption: [#strong[Input Slot Rotation]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Bootstrapping
      Goal]],),
    table.hline(),
    [#strong[TFHE]], [To reset the noise.],
    [#strong[BFV]], [],
    [#strong[CKKS]], [To reset the ciphertext modulus from
    $q_0 arrow.r q_L$ (technically, to $q_(l')$ where
    $q_0 < q_(l') < q_L$).],
    [#strong[BGV]], [],
  )]
  , caption: [#strong[Bootstrapping Goal]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Bootstrapping
      Details]],),
    table.hline(),
    [#strong[TFHE]], [1. #underline[Modulus Switch] from $q arrow.r 2 n$
    to convert
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)arrow.r sans("LWE")_(arrow(s)\,sigma)\(hat(Delta) m\)=\(arrow(hat(a))\,hat(b)\)med mod med 2 n$,],
    [], [where $hat(Delta) = frac(2 n, t)$. $gt.tri$ where $t$ divides
    $2 n$],
    [], [2. #underline[Blind Rotation]: Homomorphically rotate the
    GLWE-encrypted look-up table],
    [], [polynomial $sans("GLWE")_(arrow(S)\,sigma)\(Delta V\)$ by
    $Delta m + e$ positions to the left. This is done by],
    [], [by homomorphically deriving
    $sans("GLWE")_(arrow(S)\,sigma)\(Delta V_k\)$ as follows:],
    [], [$sans("GLWE")_(arrow(S)\,sigma)\(Delta V_0\)= sans("GLWE")_(arrow(S)\,sigma)\(Delta V\)dot.op X^(- hat(b))$],
    [], [$sans("GLWE")_(arrow(S)\,sigma)\(Delta V_i\)= sans("GLWE")_(arrow(S)\,sigma)\(Delta V_(i - 1)\)dot.op X^(hat(a)_i s_(i - 1))$],
    [], [$= sans("GGSW")_(arrow(S)\,sigma)^(beta\,l)\(s_(i - 1)\)dot.op bold(\() sans("GLWE")_(arrow(S)\,sigma)\(Delta V_(i - 1)\)dot.op X^(hat(a)_(i - 1)) - sans("GLWE")_(arrow(S)\,sigma)\(Delta V_(i - 1)\)bold(\)) + sans("GLWE")_(arrow(S)\,sigma)\(Delta V_(i - 1)\)$],
    [], [3. #underline[Coefficient Extraction]: The rotated encrypted
    polynomial $V_k$'s constant term value is],
    [], [$Delta m$. Extract this encrypted constant term as
    $sans("LWE")_(arrow(s)\,sigma)\(Delta m\)$ from
    $sans("GLWE")_(arrow(S)\,sigma)\(Delta V_k\)$.],
    [#strong[BFV]], [1. #underline[Modulus Switch] from
    $q arrow.r p^epsilon$ to convert
    $sans("RLWE")_(S\,sigma)\(Delta M\)arrow.r sans("RLWE")_(S\,sigma)\(p^(epsilon - 1) M\)med mod med p^epsilon$],
    [], [2. #underline[Homomorphic Decryption]:],
    [], [$B + A dot.op sans("RLWE")_(S\,sigma)\(Delta' S\)= sans("RLWE")_(S\,sigma)\(Delta' dot.op\(p^(epsilon - 1) M + E + K p^epsilon\)\)med mod med q$,
    where $Delta' = ⌊q / p^epsilon⌋$],
    [], [3. #underline[CoeffToSlot]: Multiply to the ciphertext by
    \$n^{-1}\\cdot I\_n^R \\cdot \\hathat W\$ to move],
    [], [the plaintext coefficients of
    $p^(epsilon - 1) M + E + K p^epsilon$ to the input slots.],
    [], [4. #underline[Digit Extraction]: Given the digit extraction
    polynomial $G_epsilon\(x\)$,],
    [], [homomorphically compute:],
    [], [$G_2 compose G_3 compose dots.h.c compose G_(epsilon - 1)\(p^(epsilon - 1) M + E + K p^epsilon\)$],
    [], [, and then the output
    $M + K^(chevron.l epsilon - 1 chevron.r) p$ is stored in the
    plaintext slots.],
    [], [Use scaling factor re-interpretation to handle inverse-$p$
    multiplications.],
    [], [5. #underline[SlotToCoeff]: Multiply to the ciphertext by
    \$\\hathat W^\*\$ to move
    $M + K^(chevron.l epsilon - 1 chevron.r) p$ to the],
    [], [polynomial coefficient positions and get
    $sans("RLWE")_(S\,sigma)\(Delta' dot.op\(M + K^(chevron.l epsilon - 1 chevron.r) p\)\)med mod med q$],
    [], [$= sans("RLWE")_(S\,sigma)\(Delta M\)med mod med q$],
  )]
  , caption: [#strong[Bootstrapping Details: TFHE, BFV]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Bootstrapping
      Details]],),
    table.hline(),
    [#strong[CKKS]], [1. #underline[ModRaise:] View the ciphertext
    $\(A\,B\)med mod med q_0$ as $\(A\,B\)med mod med q_L$],
    [], [2. #underline[CoeffToSlot]: Move the coefficients of
    $Delta M + E + K q_0$ to the input slots.],
    [], [3. #underline[EvalExp]: Homomorphically evaluate the polynomial
    approximation of],
    [], [the sine function with period $q_0$ at $Delta M + E + K q_0$,],
    [], [which outputs an encryption of $Delta M + E$ in the plaintext
    slots.],
    [], [4. #underline[SlotToCoeff]: Move $Delta M + E$ to the
    polynomial coefficient positions],
    [], [to get $sans("RLWE")_(S\,sigma)\(Delta M + E\)$.],
    [#strong[BGV]], [1. #underline[Modulus Switch] from
    $q_l arrow.r hat(q)$ to convert],
    [], [$sans("RLWE")_(S\,sigma)\(M\)=\(A\,B\)med mod med q_l arrow.r sans("RLWE")_(S\,sigma)\(M\)=\(hat(A)\,hat(B)\)med mod med hat(q)$],
    [], [, where $hat(q) equiv 1 med mod med p^epsilon$],
    [], [2. #underline[Ciphertext Coefficient Multiplication by
    $p^(epsilon - 1)$]:],
    [], [Compute
    $\(p^(epsilon - 1) hat(A)\,p^(epsilon - 1) hat(B)\)=\(A'\,B'\)med mod med hat(q)$
    (where $hat(q) equiv 1 med mod med p^epsilon$)],
    [], [, which the ciphertext
    $sans("RLWE")_(S\,sigma)\(p^(epsilon - 1) M\)med mod med hat(q)$
    with noise $p^epsilon E$.],
    [], [3. #underline[ModRaise]:
    $\(A'\,B'\)med mod med hat(q) arrow.r\(A'\,B'\)med mod med q_L$],
    [], [, which is the ciphertext
    $sans("RLWE")_(S\,sigma)\(p^(epsilon - 1) M + p^epsilon E + K' hat(q)\)med mod med q_L$.],
    [], [4. #underline[CoeffToSlot]: Multiply to the ciphertext by
    \$n^{-1}\\cdot I\_n^R \\cdot \\hathat W\$ to move],
    [], [the plaintext coefficients of
    $p^(epsilon - 1) M + p^epsilon E + K' hat(q)$ to the input slots.],
    [], [5. #underline[Digit Extraction]: Given the digit extraction
    polynomial $G_epsilon\(x\)$,],
    [], [homomorphically compute:],
    [], [$bold(\() upright(" ") G_2 compose G_3 compose dots.h.c compose G_epsilon\(p^(epsilon - 1) M + p^epsilon E + K' hat(q)\)upright(" ") bold(\))$],
    [], [, and then the output $M + K'' p$ is stored in the plaintext
    slots.],
    [], [To handle inverse-$p$ multiplication in each $i$-th round,
    multiply $\|p^(- 1)\|_(q^(chevron.l i chevron.r))$ to all],
    [], [ciphertext polynomial coefficients to update their plaintext
    portion from],
    [], [$M p^(epsilon - i) + K''' p^(epsilon - i + 1) med\(mod med q^(chevron.l i chevron.r)\)$
    to
    $M^(epsilon - i - 1) + K^(chevron.l i chevron.r) p^(epsilon - i) med\(mod med q^(chevron.l i chevron.r)\)$],
    [], [ $gt.tri$ where $q^(chevron.l i chevron.r)$ is the ciphertext
    modulus at each specific round],
    [], [6. #underline[SlotToCoeff]: Multiply to the ciphertext by
    \$\\hathat W^\*\$ to move
    $M + K^(chevron.l epsilon - 1 chevron.r) p$ to the],
    [], [polynomial coefficient positions to get
    $sans("RLWE")_(S\,sigma)\(M + K^(chevron.l italic("last") chevron.r) p\)$],
    [], [$= sans("RLWE")_(S\,sigma)\(M + Delta K^(chevron.l italic("last") chevron.r)\)med mod med q_(l')$
    $gt.tri$ where $Delta = p$, and the final noise is
    $K^(chevron.l italic("last") chevron.r)$],
  )]
  , caption: [#strong[Bootstrapping Details: CKKS, BGV]]
  , kind: table
  )

#figure(
  align(center)[#table(
    columns: 2,
    align: (center,left,),
    table.header([], table.cell(align: center)[#strong[Noise
      Management]],),
    table.hline(),
    [#strong[TFHE]], [Their bootstrapping resets the noise.],
    [#strong[BFV]], [],
    [#strong[CKKS]], [- The noise grows without stopping, because its
    bootstrapping resets only the],
    [], [modulus chain. To slow down the noise growth, we should
    increase the plaintext's],
    [], [scaling factor $Delta$.],
    [], [- CKKS's EvalExp cannot use the digit extraction polynomial to
    remove the noise,],
    [], [because CKKS's plaintext is not in a modulus ring, but is a
    real number.],
    [#strong[BGV]], [BGV's modulus switch has the special property of
    resetting the noise, and BGV's],
    [], [bootstrapping resets the modulus chain to enable indefinite
    modulus switches.],
  )]
  , caption: [#strong[Noise Management]]
  , kind: table
  )
