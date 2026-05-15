The FHE parameters of BFV, BGV, or CKKS schemes, which are secure
enough, sometimes require the ring size of polynomial coefficients to be
1000 bits or more, consuming significant computational resources for
64-bit CPU architectures. To make the computation efficient, we can
alternatively represent the coefficients of ciphertext polynomials using
the number residue system
(RNS)~#link(<subsec:crt-application>)[\[subsec:crt-application\]], which
allows for modulo addition and multiplication of elements from a large
ring (e.g., 1000 bits) by combining values computed in small rings
(e.g., 32$tilde.op$64 bits), each of which compactly fits in 64 bit CPU
registers. Modern BFV, BGV, and CKKS schemes adopt this RNS approach by
default for the efficient computation of large values. These are called
RNS-variant FHE schemes.

While RNS can directly compute modulo addition and multiplication, it
does not directly support other operations such as ModRaise or modulus
switching, which are essential for all FHE schemes. This section
explains how we can design such corner-case operations based on RNS to
accomplish a complete design of RNS-based FHE schemes. Besides BFV, BGV,
and CKKS, TFHE can also theoretically use RNS for representing its
ciphertext coefficients. However, TFHE's practically used coefficient
size is less than $2^32$ (or $2^64$), which compactly fits within 32-bit
(or 64-bit) modern CPU registers. Therefore, TFHE does not need RNS.
Thus, this section will focus on RNS-based operations for BFV, BGV, and
CKKS.

Particularly in this section, we assume that the modulo reduction
$a med mod med q =\|a\|_q$ implicitly uses a centered (i.e., signed)
residue representation
(#link(<subsec:modulo-centered>)[\[subsec:modulo-centered\]]), whose
modulo overflow & underflow boundaries are $q / 2 - 1$ and $- q / 2$,
respectively. This assumption is necessary to eliminate a certain modulo
reduction operation when designing FastBconvEx
(#link(<subsec:rns-fastbconvex>)[0.8]) by using the assumption of
limiting the possible range of certain residue arithmetic, as discussed
in #link(<subsec:modulo-centered>)[\[subsec:modulo-centered\]].

#block[
- #link(<sec:modulo>)[\[sec:modulo\]]:

- #link(<sec:group>)[\[sec:group\]]:

- #link(<sec:field>)[\[sec:field\]]:

- #link(<sec:polynomial-ring>)[\[sec:polynomial-ring\]]:

- #link(<sec:decomp>)[\[sec:decomp\]]:

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

- #link(<sec:bgv>)[\[sec:bgv\]]:

]
== Fast Base Conversion: FastBConv
<subsec:rns-fastbconv>
#strong[\- Reference 1:]
#link("https://eprint.iacr.org/2016/510")[A Full RNS Variant of FV-like Somewhat Homomorphic Encryption Schemes]~@rns-bfv

#strong[\- Reference 2:]
#link("https://eprint.iacr.org/2022/657")[BASALISC: Programmable Hardware Accelerator for BGV FHE]~@rns-bfv2

$$

Suppose we have $x in bb(Z)_q$ (where $q$ is a big modulus). Then, we
can express $x$ by using RNS
(#link(<subsec:crt-application>)[\[subsec:crt-application\]]) as
$\(x_1\,x_2\,dots.h.c\,x_k\)$, where each $x_i in bb(Z)_(q_i)$,
$product_(i = 1)^k q_i = q$, and ${ q_1\,q_2\,dots.h.c\,q_k }$ are
co-prime. In RNS, we define base conversion as an operation of
converting the RNS residues
$\(x_1\,x_2\,dots.h.c\,x_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$
into
$\(c_1\,c_2\,dots.h.c\,c_k\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$,
where ${ b_1\,b_2\,dots.h.c\,b_l }$ is a new base, and
${ q_1\,q_2\,dots.h.c\,q_k }$ and ${ b_1\,b_2\,dots.h.c\,b_l }$ are all
co-prime. The relationship between $x$ and $c$ is: $c =\|x\|_b$ (where
$x in bb(Z)_q$ and $c in bb(Z)_b$). The standard way of performing base
conversion is assembling $\(x_1\,x_2\,dots.h.c\,x_k\)$ into $x$ by
computing $x = sum_(i = 1)^k\|x_i z_i\|_(q_i)dot.op y_i med mod med q$
(where
$y_i = q / q_i upright(" and ") z_i = y_i^(- 1) med mod med q_i$), and
then computing $c_j equiv x med mod med b_j$ for $j in\[1\,l\]$.
However, this computation is slow if the modulus $q$ is large. To
compute the base conversion #emph[fast], we design the fast base
conversion operation $sans("FastBConv")$ as follows:

#block[
#strong[#underline[Input]:]
$\(x_1\,x_2\,dots.h.c\,x_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$
$gt.tri$ which represents the big value $x in bb(Z)_q$, where
$q = product_(i = 1)^k q_i$, and ${ q_1\,q_2\,dots.h.c\,q_k }$ are
co-prime

$$

$sans("FastBConv")\(x\,q\,b\)= sans("FastBConv")\({ x_i }_(i = 1)^k\,{ q_i }_(i = 1)^k\,{ b_i }_(i = 1)^l\)$

$= (sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i med mod med b_j)_(j in\[1\,l\])$

$gt.tri$ where
$y_i = q / q_i upright(", ") z_i = y_i^(- 1) med mod med q_i$, and
$b = product_(i = 1)^l b_i$

$$

$=\(c_1\,c_2\,dots.h.c\,c_l\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$
$gt.tri$ which represents the big value $c in bb(Z)_b$

$$

$$

The input to this FastBConv function is a list of RNS residues
$\(x_1\,x_2\,dots.h.c\,x_k\)$ having the prime moduli
$\(q_1\,q_2\,dots.h.c\,q_k\)$ as the base. This RNS vector represents
the big value:

$x = (sum_(i = 1)^k x_i dot.op y_i dot.op z_i) med mod med q = (sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i) med mod med q$
$gt.tri$ Theorem~@sec:chinese-remainder\.1

$$

The output of this FastBConv function is a list of RNS residues
$\(c_1\,c_2\,dots.h.c\,c_l\)$ having the prime moduli
$\(b_1\,b_2\,dots.h.c\,b_l\)$ as the base. This RNS vector represents
the big value

$c = (sum_(i = 1)^l c_i dot.op y'_i dot.op z'_i) med mod med b = (sum_(i = 1)^l \| c_i dot.op z'_i \|_(b_i) dot.op y'_i) med mod med b$
$gt.tri$ where $y'_i = b / b_i$ and $z'_i = y'_i^(- 1) med mod med b_i$

$$

The relationship between $c$ and $x$ is as follows:

$c = x + u q med mod med b$ (where $u$ is an integer with the magnitude
$\|u\|lt.eq k / 2 + 1$)

$gt.tri$ i.e. the fast-base-converted $c$ gets noise $\|u q\|_b$

]
#block[
We will prove why a fast base conversion of $x$ into $c$ gets an
additional noise $\|u dot.op q\|_b$ (where integer
$\|u\|lt.eq k / 2 + 1$) compared to a standard base conversion. If we
did a standard (i.e., exact) base conversion of $x$ from base moduli
$\(q_1\,dots.h.c\,q_k\)$ to $\(b_1\,dots.h.c\,b_l\)$, then we would
compute the following:

$ ((sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i med mod med q) med mod med b_j)_(j in\[1\,l\]) = (x med mod med b_j)_(j in\[1\,l\]) $

But $sans("FastBConv")$ omits the intermediate (big) reduction modulo
$q$ and directly applies (small) reduction modulo $b_j$ for the sake of
fast computation, so that our conversion process does not need to handle
large values whose magnitude can be as large as $plus.minus q / 2$. In
this approach of fast base conversion, for each $i in\[1\,k\]$, the
computation result of $\|x_i dot.op z_i\|_(q_i)dot.op y_i$ is some value
between $[- ⌈q / 2⌉ \, ⌊q / 2⌋]$, because $\|x_i dot.op z_i\|_(q_i)$ is
some integer between $[- ⌈q_i / 2⌉ \, ⌊q_i / 2⌋]$ and $y_i = q / q_i$.
Therefore,
$- frac(q + 1, 2) lt.eq\|x_i dot.op z_i\|_(q_i)dot.op y_i lt.eq q / 2$.
If we sum $k$ such values for $i in\[1\,k\]$, then the total sum
$x' = sum_(i = 1)^k\|x_i dot.op z_i\|_(q_i)dot.op y_i = x + u dot.op q$
(Summary~@sec:chinese-remainder in
#link(<sec:chinese-remainder>)[\[sec:chinese-remainder\]]) for some
integer $u$ (where $u dot.op q$ represents the $q$-multiple overflows).
And since we have shown that
$- frac(q + 1, 2) lt.eq\|x_i dot.op z_i\|_(q_i)dot.op y_i lt.eq q / 2$
for each $i in\[1\,k\]$, $u q$ has to be greater than
$- k dot.op frac(q + 1, 2)$ and smaller than $k dot.op q / 2$ (i.e., $u$
is an integer between $- k / 2 - 1 lt.eq u lt.eq k / 2$). Therefore,
$sum_(i = 1)^k\|x_i dot.op z_i\|_(q_i)dot.op y_i$ can have maximum
$- (k / 2 + 1) dot.op q$ underflows and $k / 2 dot.op q$ overflows.
Thus, while standard (i.e., exact) base conversion computes each residue
as
$hat(c)_j = (sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i med mod med q) med mod med b_j$
(i.e., $hat(c)_j = x med mod med b_j$), fast (i.e., approximate) base
conversion computes each residue as
$c_j = (sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i) med mod med b_j$
(i.e., $c_j = x + u q med mod med b_j$, where integer
$\|u\|lt.eq k / 2 + 1$). Notice that the residual difference (i.e.,
error) between each $hat(c)_j$ and $c_j$ is $u q med mod med b_j$, and
the collective noise generated by fast base conversion from
$q arrow.r b$ is $u q med mod med b$. Also, note that the RNS residue
vector
$\(c_1\,c_2\,dots.h.c\,c_l\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$
represents the big value $c = x + u q med mod med b$.

Importantly, FastBConv does not guarantee the correctness of base
conversion, because the $q$-multiple overflow would generate a
non-negligible error. Yet, FastBConv is used as an essential building
block for various RNS-based operations such as ModRaise#sub[RNS]
(#link(<subsec:rns-modraise>)[0.3]) and ModSwitch#sub[RNS]
(#link(<subsec:rns-modswitch>)[0.5]).

]
== Small Montgomery Reduction Algorithm: SmallMont
<subsec:rns-smallmont>
One problem of the FastBConv (i.e., the fast base conversion) operation
is that it creates a non-negligible noise. Specifically, suppose we use
FastBConv to convert the base of $x in bb(Z)_q$ (where
$q = q_1 dot.op q_2 dot.op dots.h.c dot.op q_k$ moduli) into
$c = x + u q med mod med b$ (where
$b = b_1 dot.op b_2 dot.op dots.h.c dot.op b_l$ moduli), where integer
$\|u\|lt.eq k / 2 + 1$. Then, the noise generated by this conversion is
between $- (k / 2 + 1) dot.op q med mod med b$ and
$(k / 2 + 1) dot.op q med mod med b$. To reduce this noise, we will
explain the small Montgomery algorithm (SmallMont) which reduces the
noise generated by fast base conversion from $u q$ to $u' q$, such that
$u' in { - 1\,0\,1 }$. The small Montgomery algorithm is designed as
follows:

#block[
#strong[#underline[Input]:]
$c =\(c_1\,c_2\,dots.h.c\,c_l\,c_(l + 1)\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l) times bb(Z)_(b_alpha)$
$gt.tri$ $b_alpha$ is a prime and co-prime to $b$, where
$b = product_(i = 1)^l b_i$

$$

, where
$c = sans("FastBConv") bold(\()\|b_alpha dot.op x\|_q\,q\,b b_alpha bold(\)) =\|b_alpha dot.op x\|_q+ u q$
$gt.tri$ where $x in bb(Z)_q$ and integer $\|u\|lt.eq k / 2 + 1$

$$

#strong[#underline[Main Steps]]

#strong[$sans("SmallMont")\(c\,b b_alpha\,b_alpha\,q\):$]

+ $c' =\|c dot.op q^(- 1)\|_(b_alpha)$

+ For each $i in\[1\,l\]$, compute
  $r_i = #scale(x: 180%, y: 180%)[\|]\(c_(b_i) -\|q\|_(b_i)dot.op c'\)dot.op b_alpha^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_i)$

$$

#strong[#underline[Output:]]
$r =\(overbrace(r_1\,r_2\,dots.h.c\,r_l, l)\)in overbrace(bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l), l)$
$gt.tri$ without $r_alpha in bb(Z)_(b_alpha)$

$$

The output satisfies the relation: $r = x + u' q med mod med b$ (where
$u' in { - 1\,0\,1 }$)

]
#block[
+ Given $c' =\|c dot.op q^(- 1)\|_(b_alpha)$, notice that
  $c - q dot.op c'$ is exactly divisible by $b_alpha$ as shown below:

  $c - q dot.op c' med mod med b_alpha$

  $= c - q dot.op\|c dot.op q^(- 1)\|_(b_alpha)med mod med b_alpha$
  $gt.tri$ substituting $c' =\|c dot.op q^(- 1)\|_(b_alpha)$

  $= c - c med mod med b_alpha$ $gt.tri$ by canceling out
  $\|q\|_(b_alpha)$ and $\|q\|_(b_alpha)^(- 1)$

  $= 0 med mod med b_alpha$

  $$

  Since $c - q dot.op c' = 0 med mod med b_alpha$, this implies that
  $c - q dot.op c'$ is a multiple of $b_alpha$ (i.e., $c - q dot.op c'$
  is exactly divisible by $b_alpha$). This also implies that
  $frac(c - q dot.op c', b_alpha)$ is an integer.

  $$

+ Given $c =\|b_alpha dot.op x\|_q+ u q med mod med b$ and
  $c' =\|c dot.op q^(- 1)\|_(b_alpha)$, we can express
  $frac(c - q dot.op c', b_alpha) med mod med b$ as follows:

  $lr(|frac(c - q dot.op c', b_alpha)|)_b$

  $= lr(|frac(c - q dot.op\|c dot.op q^(- 1)\|_(b_alpha), b_alpha)|)_b$
  $gt.tri$ by substituting $c' =\|c dot.op q^(- 1)\|_(b_alpha)$

  $= lr(|frac(\|b_alpha dot.op x\|_q+ u q - q dot.op #scale(x: 300%, y: 300%)[\|] #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x\|_q+ u q #scale(x: 180%, y: 180%)[\|]_b dot.op q^(- 1) #scale(x: 300%, y: 300%)[\|]_(b_alpha), b_alpha)|)_b$
  $gt.tri$ by substituting
  $c = #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x\|_q+ u q #scale(x: 180%, y: 180%)[\|]_b$

  $= #scale(x: 300%, y: 300%)[\|] frac(b_alpha dot.op x + v q + u q - q dot.op #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x + v q + u q\|_bdot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_alpha), b_alpha) #scale(x: 300%, y: 300%)[\|]_b$
  $gt.tri$ by rewriting $\|b_alpha dot.op x\|_q$ as
  $b_alpha dot.op x + v q$ (where $v$ is some integer representing the
  $q$-overflows of $b_alpha dot.op x$)

  $$

  $= #scale(x: 300%, y: 300%)[\|] x + frac(v q + u q - q dot.op #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x + v q + u q\|_bdot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_alpha), b_alpha) #scale(x: 300%, y: 300%)[\|]_b$
  $gt.tri$ since $x = frac(b_alpha dot.op x, b_alpha)$

  $= #scale(x: 300%, y: 300%)[\|] x + q dot.op frac(v + u - #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x + v q + u q\|_bdot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_alpha), b_alpha) #scale(x: 300%, y: 300%)[\|]_b$
  $gt.tri$ taking out the common multiple $q$

  $$

  The above computation result is guaranteed to be an integer (as we
  proved in the proof step 1). And $q$ and $b_alpha$ are co-prime (by
  the input definition). This leads to the conclusion that

  $frac(v + u - #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x + v q + u q\|_bdot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_alpha), b_alpha)$
  is guaranteed to be an integer. Therefore, if we choose $b_alpha$
  (i.e., a prime and co-prime to both $q$ and $b$) as a sufficiently
  large value, then
  $frac(v + u - #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x + v q + u q\|_bdot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_alpha), b_alpha)$
  will converge to ${ - 1\,0\,1 }$. This is because as $b_alpha$
  increases: (1) $v$ grows slower than $b_alpha$ (since
  $\|b_alpha dot.op x\|_q= b_alpha dot.op x + v q$); (2) the magnitude
  of $u$ stays smaller than $k / 2 + 1$ (as integer
  $\|u\|lt.eq k / 2 + 1$); and (3)
  $#scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x + v q + u q\|_bdot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(b_alpha)$
  is guaranteed to be an integer between
  $[- frac(b_alpha + 1, 2) \, b_alpha / 2 - 1]$. In conclusion, if
  $b_alpha$ is sufficiently large, then we get the following relation:

  $lr(|frac(c - q dot.op c', b_alpha)|)_b = x + u' q med mod med b$
  $gt.tri$ where $u' in { - 1\,0\,1 }$

  $$

  Also, the following is true:

  $frac(c - q dot.op c', b_alpha) med mod med b =\(c - q dot.op c'\)dot.op b_alpha^(- 1) med mod med b$
  $gt.tri$ because $b_alpha$ divides $c - q dot.op c'$ and $b_alpha$ is
  co-prime to $b$

  $$

+ It is possible to express the final output $x + u' q med mod med b$ as
  an RNS vector with the residues of the base moduli
  $\(b_1\,dots.h.c\,b_l\)$. For this, we convert
  $\(c - q dot.op c'\)dot.op b_alpha^(- 1)$ into the RNS vector
  $\(r_1\,r_2\,dots.h.c\,r_l\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$
  by computing the following for each $i in\[1\,l\]$:

  $r_i =\|\(c - q dot.op c'\)dot.op b_alpha^(- 1)\|_(b_i)$

  $=\|\(c_(b_i) -\|q\|_(b_i)dot.op c'\)dot.op b_alpha^(- 1)\|_(b_i)$

]
=== Improving FastBConv by Using SmallMont
<subsubsec:rns-smallmont-fastbconv>
Notice that by using SmallMont in Summary~@subsec:rns-smallmont, the
accuracy of the raw output of
$sans("FastBConv")\(x\,q\,b\)=\|x + u q\|_b$ (where integer
$\|u\|lt.eq k / 2 + 1$) is improved to $\|x + u' q\|_b$ (where
$u' in { - 1\,0\,1 }$) as follows:

$sans("SmallMont") bold(\() sans("FastBConv") bold(\()\|b_alpha dot.op x\|_q\,q\,b b_alpha bold(\))\,b b_alpha\,b_alpha\,q bold(\))$

$sans("SmallMont") bold(\() #scale(x: 180%, y: 180%)[\|]\|b_alpha dot.op x\|_q+ u q #scale(x: 180%, y: 180%)[\|]_(b b_alpha)\,b b_alpha\,b_alpha\,q bold(\))$

$=\|x + u' q\|_b$ $gt.tri$ where $u' in { - 1\,0\,1 }$

$$

== RNS-based ModRaise: ModRaise#sub[RNS]
<subsec:rns-modraise>
#strong[\- Reference:]
#link("https://eprint.iacr.org/2018/931.pdf")[A Full RNS Variant of Approximate Homomorphic Encryption]~@rns-ckks

$$

ModRaise is an operation that raises a ciphertext's modulus from $q$ to
$q b$ (where $q lt.double q b$). We used ModRaise in BFV's
ciphertext-to-ciphertext multiplication
(Summary~@subsubsec:bfv-mult-cipher-summary in
#link(<subsubsec:bfv-mult-cipher-summary>)[\[subsubsec:bfv-mult-cipher-summary\]])
and in CKKS's modulus bootstrapping
(Summary~@subsubsec:ckks-bootstrapping-summary in
#link(<subsubsec:ckks-bootstrapping-summary>)[\[subsubsec:ckks-bootstrapping-summary\]]).
The RNS-based ModRaise operation is designed as follows:

#block[
#strong[#underline[Input]:]
$\(x_1\,x_2\,dots.h.c\,x_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$
$gt.tri$ which represents the big value $x in bb(Z)_q$

$$

\$\\textsf{ModRaise\\textsubscript{RNS}}({\\{x\_i\\}\_{i=1}}^k, q, qb)\$
$gt.tri$ where $q$ and $b$ are co-prime

\$= \\textsf{FastBConv\\textsubscript{RNS}}({\\{x\_i\\}\_{i=1}}^k, q, qb)\$

$=\(x_1\,x_2\,dots.h.c\,x_k\,sans("FastBConv")\({ x_i }_(i = 1)^k\,q\,b\)\)$

$=\(x_1\,x_2\,dots.h.c\,x_k\,c_1\,c_2\,dots.h.c\,c_l\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k) times bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$

$=\(chi_1\,chi_2\,dots.h.c\,chi_(k + l)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k) times bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$

$gt.tri$ which represents the value $chi in bb(Z)_(q b)$

$$

The relationship between $chi$ and $x$ is as follows:

$chi equiv x + u dot.op q med mod med q b$ $gt.tri$ the noise generated
by ModRaise#sub[RNS] is $\|u q\|_(q b)$ (where integer
$\|u\|lt.eq k / 2 + 1$)

$chi equiv x med mod med q$

]
#block[
In #link(<subsec:rns-fastbconv>)[0.1], we proved that
$x' = sum_(i = 1)^k\|x_i dot.op z_i\|_(q_i)dot.op y_i = x + u dot.op q$
(where integer $\|u\|lt.eq k / 2 + 1$). Therefore, the following holds:

$x' equiv x_i med mod med q_i$ for $i in\[1\,k\]$ $gt.tri$ since
$x' = x + u dot.op q equiv x_i med mod med q_i$ (as $q_i$ divides $q$,
thus $u dot.op q equiv 0 med\(mod med q_i\)$, and
$x equiv x_i med mod med q_i$)

$x' equiv c_j med mod med b_j$ for $j in\[1\,l\]$ $gt.tri$ where each
$c_j = x + u q med mod med b_j$

$$

Therefore, $x' med mod med q b$ can be represented as the following RNS
residues:

$\(x_1\,x_2\,dots.h.c\,x_k\,c_1\,c_2\,dots.h.c\,c_l\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k) times bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$

$=\(x_1\,x_2\,dots.h.c\,x_k\,sans("FastBConv")\({ x_i }_(i = 1)^k\,q\,b\)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k) times bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$

$$

Our ideal goal of mod-raising $x in bb(Z)_q$ from $q arrow.r q b$ is to
derive an RNS vector of $x med mod med q b$. However, the above RNS
vector represents $x' med mod med q b$, where $x' = x + u q$ (with
integer $\|u\|lt.eq k / 2 + 1$). Therefore, we can interpret the above
RNS vector as representing $x med mod med q b$ with the additional noise
$\|u q\|_(q b)$.

]
== RNS-based ModDrop: ModDrop#sub[RNS]
<subsec:rns-moddrop>
ModDrop (#link(<subsec:ckks-moddrop>)[\[subsec:ckks-moddrop\]],
#link(<subsec:bgv-moddrop>)[\[subsec:bgv-moddrop\]]) is an operation of
decreasing a ciphertext's modulus from $q arrow.r q'$ (where $q'$
divides $q$) without affecting the plaintext's scaling factor(in the
case of CKKS) or the noise's scaling factor (in the case of BGV).

In an RNS-based ciphertext representation, ModDrop is equivalent to
removing some of the base moduli in the ciphertext without affecting the
scaling factor $Delta$. This can be achieved by converting the
ciphertext's base from $q$ to $macron(q)$ where the base moduli set of
$macron(q)$ are a subset of that of $q$\; that is, $macron(q)$ divides
$q$. Specifically, suppose that we have an input
$\(x_1\,x_2\,dots.h.c\,x_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$,
and a new subset base
$macron(q) = q_1 dot.op q_2 dot.op dots.h.c dot.op q_(k')$, where
$k' < k$. In this setup, the fast base conversion from
$q arrow.r macron(q)$ is equivalent to simply extracting the input
value's RNS residues associated with the base moduli
$\(q_1\,q_2\,dots.h.c\,q_(k')\)$. This is because of the following
reasoning:

$sans("FastBConv")\({ x_i }_(i = 1)^k\,q\,macron(q)\)= (sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i med mod med q_j)_(j in\[1\,k'\])$

$= x + u q med mod med macron(q)$ $gt.tri$ Summary~@subsec:rns-fastbconv
in #link(<subsec:rns-fastbconv>)[0.1]

$= x med mod med macron(q)$ $gt.tri$ $u q$ gets eliminated because
$macron(q)$ divides $u q$

$=\(x_1\,x_2\,dots.h.c\,x_(k')\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_(k'))$

$$

Notice that the above fast base conversion from $q arrow.r macron(q)$
(where $macron(q)$ divides $q$) does not generate any noise. This is
different from the case of fast base conversion from $q arrow.r b$
(Summary~@subsec:rns-fastbconv in #link(<subsec:rns-fastbconv>)[0.1])
where $q$ and $b$ are co-prime, which generates the noise $\|u q\|_b$
(where integer $\|u\|lt.eq k / 2 + 1$).

The ModDrop operation is supported in all of BFV, BGV, and CKKS
ciphertexts that are represented in RNS forms. However, note that
ModDrop is possible only if the scaled plaintext (in the case of BFV and
CKKS) or the scaled noise (in the case of BGV) does not exceed the
ciphertext modulus after the mod-drop operation, because otherwise
correct decryption is not possible. ModDrop#sub[RNS] is summarized as
follows:

#block[
#strong[#underline[Input]:]
$\(x_1\,x_2\,dots.h.c\,x_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

$$

$sans("FastBConv")\({ x_i }_(i = 1)^k\,q\,macron(q)\)= (sum_(i = 1)^k \| x_i dot.op z_i \|_(q_i) dot.op y_i med mod med q_j)_(j in\[1\,k'\])$

$gt.tri$ where $macron(q)$ is a product of co-primes
$q_1 dot.op q_2 dot.op dots.h.c dot.op q_(k')$, and $macron(q)$ divides
$q$

$=\(x_1\,x_2\,dots.h.c\,x_(k')\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_(k'))$
$gt.tri$ no noise generated during the conversion

]
== RNS-based Modulus Switch: ModSwitch#sub[RNS]
<subsec:rns-modswitch>
Modulus switch is an operation of reducing a ciphertext's modulus from
$q$ to $q'$ (where $q' < q$) and updating the target value from $x$ to
$⌈x dot.op q' / q⌋$. Modulus switch is used for lowering the
multiplicative level of a ciphertext upon each ciphertext-to-ciphertext
multiplication (in the case of BFV, CKKS, or BGV) or even upon each
ciphertext-to-plaintext multiplication (in the case of CKKS). Upon each
modulus switch from $q arrow.r q'$ of a ciphertext, the scaling factor
of the underlying plaintext in the ciphertext also gets reduced by the
same proportion: $q' / q$.

The modulus switch operation of an RNS-based ciphertext is denoted as
ModSwitch#sub[RNS], which requires that the output base moduli are a
subset of the input base moduli. In other words, like the case of
ModDrop#sub[RNS], it only supports a modulus switch from
$q b arrow.r q$, where $q$ and $b$ are co-prime.

Suppose we have
$\(chi_1\,chi_2\,dots.h.c\,chi_(k + l)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k) times bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$,
which represents the value
$chi = (sum_(i = 1)^k lr(|chi_i dot.op (frac(q b, q_i))^(- 1)|)_(q_i) dot.op frac(q b, q_i)) + (sum_(j = k + 1)^(k + l) lr(|chi_j dot.op (frac(q b, b_j))^(- 1)|)_(b_j) dot.op frac(q b, b_j)) med mod med q b$.

$$

Given $chi in bb(Z)_(q b)$, ModSwitch#sub[RNS] from $q b arrow.r q$ is
an operation of updating $chi in bb(Z)_(q b)$ to some $y in bb(Z)_q$
where $y approx ⌈chi / b⌋$. Unlike in regular modulus switch where we
can directly arithmetically divide $chi$ by $b$ and round it, an RNS
vector is incompatible with direct arithmetic division on the residues.
Therefore, our alternative strategy is to find some small value
$hat(chi)$ such that $chi equiv hat(chi) med mod med b$. Once we find
such $hat(chi)$, then $chi - hat(chi) med mod med q b$ becomes divisible
by $b$ (since their difference is some multiple of $b$), and thus we can
compute $frac(chi - hat(chi), b) approx ⌈chi / b⌋$. Note that in this
computation, the additionally introduced error of modulus switch caused
by replacing $chi$ with $chi - hat(chi)$ is equivalent to:
$#scale(x: 300%, y: 300%)[\|] ⌈chi / b⌋ - frac(chi - hat(chi), b) #scale(x: 300%, y: 300%)[\|] approx ⌈hat(chi) / b⌋$.
After the (exact) division of $frac(chi - hat(chi), b)$, we directly
replace the modulus $q b$ with $q$. This direct replacement of modulus
is arithmetically allowed because the computation result of
$frac(chi - hat(chi), b)$ is guaranteed to be within $- q / 2$ and
$q / 2 - 1$ (since $- frac(q b, 2) lt.eq chi lt.eq frac(q b, 2) - 1$).
Therefore, we can derive the following formula:

$frac(chi - hat(chi), b) med mod med q =\|b^(- 1)\|_qdot.op\(chi - hat(chi)\)med mod med q$

$$

In the above relation, we can arithmetically replace $b$ with
$\|b^(- 1)\|_q$, because $chi - hat(chi)$ is divisible by $b$ and $b$ is
guaranteed to have an inverse modulo $q$ (since $b$ and $q$ are
co-prime). Next, we can compute
$\|b^(- 1)\|_qdot.op\(chi - hat(chi)\)med mod med q$ based on their RNS
residues as follows:

$\|b^(- 1)\|_qdot.op\(chi - hat(chi)\)med mod med q$

$= bold(\()\|b^(- 1)\|_(q_1)dot.op\(chi_1 - hat(chi)_1\)\,upright(" ")\|b^(- 1)\|_(q_2)dot.op\(chi_2 - hat(chi)_2\)\,upright(" ") dots.h.c\,upright(" ")\|b^(- 1)\|_(q_k)dot.op\(chi_k - hat(chi)_k\)bold(\)) in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

$=\(y_1\,y_2\,dots.h.c\,y_k\)$ $gt.tri$ where each
$y_i =\|b^(- 1)\|_(q_i)dot.op\(chi_i - hat(chi)_i\)med mod med q_i$

$$

Now, our task is to derive an expression for some small $hat(chi)$ such
that $chi - hat(chi)$ is divisible by $b$. We propose that
$hat(chi) =\|chi\|_b+ u b$ for some small integer
$\|u\|lt.eq l / 2 + 1$. Then, notice that $chi - hat(chi)$ is divisible
by $b$ as follows:

$\|chi - hat(chi)\|_b= #scale(x: 180%, y: 180%)[\|]\|chi\|_b-\(\|chi\|_b+ u b\)#scale(x: 180%, y: 180%)[\|]_b =\|- u b\|_b= 0$

$$

Now, we will derive the RNS vector of
$hat(chi) med mod med q =\|chi\|_b+ u b med mod med q$, which is to be
plugged into $\|b^(- 1)\|_qdot.op\(chi - hat(chi)\)med mod med q$.
First, we derive the RNS vector of $\|chi\|_b$ as follows:

$\(\|chi\|_(b_1)\,\|chi\|_(b_2)\,dots.h.c\,\|chi\|_(b_l)\)=\(chi_(k + 1)\,chi_(k + 2)\,dots.h.c\,chi_(k + l)\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$

$$

Next, we can compute its fast base conversion from $b arrow.r q$ as
follows:

$sans("FastBConv")\({ chi_(k + i) }_(i = 1)^l\,b\,q\)$

$=\(hat(chi)_1\,hat(chi)_2\,dots.h.c\,hat(chi)_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

$$

Now, notice that the above RNS residue vector
$\(hat(chi)_1\,hat(chi)_2\,dots.h.c\,hat(chi)_k\)$ represents the value
$hat(chi) =\|chi\|_b+ u dot.op b med mod med q$ (where integer
$\|u\|lt.eq l / 2 + 1$), which is our desired formula for $hat(chi)$.
Therefore,
$hat(chi) = sans("FastBConv")\({ chi_(k + i) }_(i = 1)^l\,b\,q\)$.

Note that $hat(chi) lt.double q / 2 - 1$ and
$- q / 2 lt.double hat(chi)$, because
$#scale(x: 180%, y: 180%)[\|]\|chi\|_b+ u dot.op b #scale(x: 180%, y: 180%)[\|] < (l / 2 + 1) dot.op b + b / 2 lt.double q / 2$
(here we assume that $b lt.double q$, as we assume the modulus switch
operation is used to remove only a single prime factor from the large
base $q$). Therefore, the magnitude of the error generated by computing
$b^(- 1) dot.op\(chi - hat(chi)\)$ is approximately
$⌈hat(chi) / b⌋ < ⌈frac((l / 2 + 1) dot.op b + b / 2, b)⌋ = ⌈frac(l b + 3 b, 2 b)⌋ = ⌈frac(l + 3, 2)⌋ < l / 2 + 2$.

$$

We summarize the ModSwitch#sub[RNS] operation as follows:

#block[
#strong[#underline[Input]:]
$\(chi_1\,chi_2\,dots.h.c\,chi_(k + l)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k) times bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l)$

$gt.tri$ which represents
$chi = (sum_(i = 1)^k lr(|chi_i dot.op (frac(q b, q_i))^(- 1)|)_(q_i) dot.op frac(q b, q_i)) + (sum_(j = k + 1)^(k + l) lr(|chi_j dot.op (frac(q b, b_j))^(- 1)|)_(b_j) dot.op frac(q b, b_j)) med mod med q b$

$$

#strong[#underline[Notations]]

- The RNS vector
  $\(chi_1\,chi_2\,dots.h.c\,chi_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$
  represents the value: $\|chi\|_qin bb(Z)_q$

- $sans("FastBConv")\({ chi_(k + 1) }_(i = 1)^l\,b\,q\)=\(hat(chi)_1\,hat(chi)_2\,dots.h.c\,hat(chi)_k\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

  , which represents the value $hat(chi) =\|chi\|_b+ u b in bb(Z)_q$
  $gt.tri$ where $\|u\|lt.eq l / 2 + 1$

$$

#strong[#underline[Main Steps]]

\$\\textsf{ModSwitch\\textsubscript{RNS}}(\\{\\chi\_i\\}\_{i=1}^{k+l}, qb, q)\$

$= {\|b^(- 1)\|_(q_i)dot.op\(chi_i - hat(chi)_i\)med mod med q_i }_(i = 1)^k in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

$$

, whose RNS residue vector represents the value
$\|b^(- 1)\|_qdot.op\(chi - hat(chi)\)med mod med q$. The magnitude of
noise generated by ModSwitch#sub[RNS] is roughly
$⌈hat(chi) / b⌋ < l / 2 + 2$.

]
=== Comparing ModSwitch#sub[RNS], ModRaise#sub[RNS], and ModDrop#sub[RNS]
<comparing-modswitchrns-modraiserns-and-moddroprns>
Given a big value $x in bb(Z)_q$ in an RNS vector, ModSwitch#sub[RNS]
reduces its modulus from $q arrow.r q'$ and explicitly decreases the
modulo value $x$ by the proportion of $q' / q$ (i.e., it updates $x$ to
$⌈x dot.op q' / q⌋$). On the other hand, ModDrop#sub[RNS] from
$q arrow.r q'$ updates the modulo value from $x arrow.r\|x\|_(q')$
(where $q'$ divides $q$), which is different from decreasing $x$ by the
proportion of $q' / q$ like modulus switch. ModRaise#sub[RNS] from
$q arrow.r q b$ (where $q$ divides $q b$) increases the modulus without
explicitly modifying the modulo value $x$, but it generates some
$q$-overflow noise. ModSwitch#sub[RNS] and ModRaise#sub[RNS] generate
some noise, whereas ModDrop#sub[RNS] does not generate any noise.

== RNS-based Decryption
<subsec:rns-dec>
This subsection will explain how to efficiently decrypt RNS-based
ciphertexts for BFV, CKKS, and BGV.

=== BFV Decryption: $sans("Dec")_(sans("RNS"))^(sans("BFV"))$
<subsubsec:rns-dec-bfv>
Suppose we have a BFV ciphertext $\(A\,B\)$ such that
$B = A dot.op S + Delta M + E$ (where $Delta = ⌊q / t⌋$). We decrypt the
ciphertext as follows: $M = ⌈frac(B - A dot.op S, Delta)⌋$
(Summary~@subsec:bfv-enc-dec in
#link(<subsec:bfv-enc-dec>)[\[subsec:bfv-enc-dec\]]). However, RNS does
not allow direct division and rounding. Therefore, we need to express
this divide-and-round operation in terms of addition and multiplication.

Let's denote $sans("ct")\(s\)= Delta m + e + k q$ (i.e., a decryption of
ciphertext $sans("ct")$ without modulo-$q$ reduction). In this
description, we will consider only a single set of coefficients $m$,
$e$, and $k$ extracted from polynomials $M$, $E$, and $K$ for
simplicity.

As explained in
#link(<subsec:modulo-division>)[\[subsec:modulo-division\]], modulo
arithmetic does not support direct division. Meanwhile, the special
relation $a / b med mod med p = a dot.op b^(- 1) med mod med p$ holds if
$b$ divides $a$ and an inverse of $b$ modulo $p$ exists (i.e., $b$ and
$p$ are co-prime). Inspired by this, we can express the decrypted
plaintext $m$ as follows:

$m = ⌈frac(\|sans("ct")\(s\)\|_q, Delta)⌋ = ⌊frac(\|sans("ct")\(s\)\|_q, Delta)⌋ + e_r$
$gt.tri$ where $e_r in\[0\,1\]$ is a rounding error

$= ⌊\| sans("ct") \( s \) \|_q dot.op t / q⌋ + e_r + e_d$ $gt.tri$ where
$e_d = ⌊frac(\|sans("ct")\(s\)\|_q, Delta)⌋ - ⌊\| sans("ct") \( s \) \|_q dot.op t / q⌋$
is a scaling error

$= ⌊frac(t dot.op\|sans("ct")\(s\)\|_q, q)⌋ + e_r + e_d$

$= frac(t dot.op\|sans("ct")\(s\)\|_q-\|t dot.op sans("ct")\(s\)\|_q, q) + e_r + e_d$
$gt.tri$ where
$\|t dot.op sans("ct")\(s\)\|_qequiv t dot.op\|sans("ct")\(s\)\|_qmed mod med q$,
and therefore
$t dot.op\|sans("ct")\(s\)\|_q-\|t dot.op sans("ct")\(s\)\|_q$ is
divisible by $q$

$$

Now, we choose some prime number $gamma$ which is co-prime to $t$ and
$q$. Then, we derive the expression for $gamma dot.op m$ as follows:

$gamma dot.op m = gamma dot.op ⌈frac(\|sans("ct")\(s\)\|_q, Delta)⌋$

$= ⌈frac(gamma dot.op\|sans("ct")\(s\)\|_q, Delta)⌋ + e'_s$ $gt.tri$
where
$e'_s = gamma dot.op ⌈frac(\|sans("ct")\(s\)\|_q, Delta)⌋ - ⌈frac(gamma dot.op\|sans("ct")\(s\)\|_q, Delta)⌋$
is a multiplication error

$= ⌊frac(gamma dot.op\|sans("ct")\(s\)\|_q, Delta)⌋ + e'_s + e'_r$
$gt.tri$ where $e'_r in\[0\,1\]$ is a rounding error

$= ⌊gamma dot.op \| sans("ct") \( s \) \|_q dot.op t / q⌋ + e'_s + e'_r + e'_d$
$gt.tri$ where
$e'_d = (⌊frac(gamma dot.op\|sans("ct")\(s\)\|_q, Delta)⌋ - ⌊gamma dot.op \| sans("ct") \( s \) \|_q dot.op t / q⌋)$
is a scaling error

$= ⌊frac(gamma dot.op t dot.op\|sans("ct")\(s\)\|_q, q)⌋ + e'_s + e'_r + e'_d$

$= frac(gamma dot.op t dot.op\|sans("ct")\(s\)\|_q-\|gamma dot.op t dot.op sans("ct")\(s\)\|_q, q) + e'_s + e'_r + e'_d$

$$

Next, we derive the expression for $\|gamma dot.op m\|_(gamma t)$ as
follows:

$\|gamma dot.op m\|_(gamma t)= lr(|frac(gamma dot.op t dot.op\|sans("ct")\(s\)\|_q-\|gamma dot.op t dot.op sans("ct")\(s\)\|_q, q) + e'_s + e'_r + e'_d|)_(gamma t)$

$= lr(|frac(gamma dot.op t dot.op\|sans("ct")\(s\)\|_q-\|gamma dot.op t dot.op sans("ct")\(s\)\|_q, q)|)_(gamma t) +\|e'_s\|_(gamma t)+\|e'_r\|_(gamma t)+\|e'_d\|_(gamma t)$

$= lr(|frac(gamma dot.op t dot.op\|sans("ct")\(s\)\|_q-\|gamma dot.op t dot.op sans("ct")\(s\)\|_q, q)|)_(gamma t) + e'_s + e'_r + e'_d$
$gt.tri$ assuming $\|e'_s\|lt.double frac(gamma t, 2)$ and
$\|e'_r\|lt.double frac(gamma t, 2)$ and
$\|e'_d\|lt.double frac(gamma t, 2)$

$= #scale(x: 180%, y: 180%)[\|]\(gamma dot.op t dot.op\|sans("ct")\(s\)\|_q-\|gamma dot.op t dot.op sans("ct")\(s\)\|_q\)dot.op q^(- 1) #scale(x: 180%, y: 180%)[\|]_(gamma t) + e'_s + e'_r + e'_d$
$gt.tri$ since
$gamma dot.op t dot.op\|sans("ct")\(s\)\|_q-\|gamma dot.op t dot.op sans("ct")\(s\)\|_q$
is divisible by $q$, and $q$ is co-prime to $gamma t$

$$

$= lr(|- \| gamma dot.op t dot.op sans("ct") \( s \) \|_q dot.op q^(- 1)|)_(gamma t) + e'_s + e'_r + e'_d$
$gt.tri$ since $gamma dot.op t dot.op\|sans("ct")\(s\)\|_q$ is a
multiple of $gamma t$

$= #scale(x: 180%, y: 180%)[\|]\|gamma dot.op t dot.op sans("ct")\(s\)\|_q#scale(x: 180%, y: 180%)[\|]_(gamma t) dot.op\|- q^(- 1)\|_(gamma t)+ e'_s + e'_r + e'_d$

$$

Given the above relation, notice that the computation result of
$sans("FastBConv") bold(\() gamma dot.op t dot.op sans("ct")\(s\)\,q\,gamma t bold(\)) dot.op\|- q^(- 1)\|_(gamma t)$
can be expressed as follows:

$sans("FastBConv") bold(\() gamma dot.op t dot.op sans("ct")\(s\)\,q\,gamma t bold(\)) dot.op\|- q^(- 1)\|_(gamma t)$

$= #scale(x: 180%, y: 180%)[\|]\|gamma t dot.op sans("ct")\(s\)\|_q+ u q #scale(x: 180%, y: 180%)[\|]_(gamma t) dot.op\|- q^(- 1)\|_(gamma t)$
$gt.tri$ where $\|u\|lt.eq k / 2 + 1$ for the base moduli
$q_1\,q_2\,dots.h.c\,q_k$

$= #scale(x: 180%, y: 180%)[\|]\|gamma t dot.op sans("ct")\(s\)\|_qdot.op\|- q^(- 1)\|_(gamma t)- u #scale(x: 180%, y: 180%)[\|]_(gamma t)$

$=\|gamma dot.op m\|_(gamma t)- e'_s - e'_r - e'_d - u$ $gt.tri$ as we
previously showed that
$\|gamma dot.op m\|_(gamma t)= #scale(x: 180%, y: 180%)[\|]\|gamma dot.op t dot.op sans("ct")\(s\)\|_q#scale(x: 180%, y: 180%)[\|]_(gamma t) dot.op\|- q^(- 1)\|_(gamma t)+ e'_s + e'_r + e'_d$

$= y$ $gt.tri$ let's denote the above expression as $y$

$$

Then, if $e'_s\,e'_r\,e'_d\,u$ are small enough such that
$\|e'_s + e'_r + e'_d + u\|< gamma$, then
$\|y\|_gamma= - e'_s - e'_r - e'_d - u$ (as
$\|gamma dot.op m\|_(gamma t)med mod med gamma = 0$ as a multiple of
$gamma$). Therefore, we can effectively remove the noise terms
$e'_s\,e'_r\,e'_d\,u$ and derive $m$ as follows:

$bold(#scale(x: 180%, y: 180%)[\|])\(y -\|y\|_gamma\)dot.op\|gamma^(- 1)\|_tbold(#scale(x: 180%, y: 180%)[\|])_t$

$= bold(#scale(x: 180%, y: 180%)[\|])\|gamma dot.op m\|_(gamma t)dot.op\|gamma^(- 1)\|_tbold(#scale(x: 180%, y: 180%)[\|])_t$

$= bold(#scale(x: 180%, y: 180%)[\|])\|gamma dot.op m\|_tdot.op\|gamma^(- 1)\|_tbold(#scale(x: 180%, y: 180%)[\|])_t$
$gt.tri$ since
$#scale(x: 180%, y: 180%)[\|]\|gamma dot.op m\|_(gamma t)#scale(x: 180%, y: 180%)[\|]_t =\|gamma dot.op m\|_t$

$=\|m\|_t$

$$

, which is the final decryption of ct we wanted to compute. Let's denote
the RNS vector of $y$ as a
$\(y_gamma\,y_t\)in bb(Z)_gamma times bb(Z)_t$. Then, we can efficiently
compute the term
$#scale(x: 180%, y: 180%)[\|]\(y -\|y\|_gamma\)dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t$
as follows:

$#scale(x: 180%, y: 180%)[\|]\(y -\|y\|_gamma\)dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t$

$= #scale(x: 300%, y: 300%)[\|] #scale(x: 180%, y: 180%)[\(] overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma+ y_t dot.op gamma dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_(gamma t), y) - overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma+ y_t dot.op gamma dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_gamma, \|y\|_gamma) #scale(x: 180%, y: 180%)[\)] dot.op\|gamma^(- 1)\|_t#scale(x: 300%, y: 300%)[\|]_t$

$= #scale(x: 300%, y: 300%)[\|] #scale(x: 180%, y: 180%)[\(] overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma+ y_t dot.op gamma dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t, y) - overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma+ y_t dot.op gamma dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_gamma, \|y\|_gamma) #scale(x: 180%, y: 180%)[\)] dot.op\|gamma^(- 1)\|_t#scale(x: 300%, y: 300%)[\|]_t$
$gt.tri$ since
$#scale(x: 180%, y: 180%)[\|]\|y\|_(gamma t)#scale(x: 180%, y: 180%)[\|]_t =\|y\|_t$

$= #scale(x: 300%, y: 300%)[\|] #scale(x: 180%, y: 180%)[\(] overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma+ y_t dot.op gamma dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t, y) - overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma#scale(x: 180%, y: 180%)[\|]_gamma, \|y\|_gamma) #scale(x: 180%, y: 180%)[\)] dot.op\|gamma^(- 1)\|_t#scale(x: 300%, y: 300%)[\|]_t$
$gt.tri$ since
$y_t dot.op gamma dot.op\|gamma^(- 1)\|_tmed mod med gamma = 0$

$= #scale(x: 300%, y: 300%)[\|] #scale(x: 180%, y: 180%)[\(] overbrace(#scale(x: 180%, y: 180%)[\|] y_t dot.op gamma dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t, y) - overbrace(#scale(x: 180%, y: 180%)[\|] y_gamma dot.op t dot.op\|t^(- 1)\|_gamma#scale(x: 180%, y: 180%)[\|]_gamma, \|y\|_gamma) #scale(x: 180%, y: 180%)[\)] dot.op\|gamma^(- 1)\|_t#scale(x: 300%, y: 300%)[\|]_t$
$gt.tri$ since
$y_gamma dot.op t dot.op\|t^(- 1)\|_gammamed mod med t = 0$

$= #scale(x: 180%, y: 180%)[\|]\(y_t - y_gamma\)dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t$
$gt.tri$ since $\|gamma dot.op gamma^(- 1)\|_t= 1$ and
$\|t dot.op t^(- 1)\|_gamma= 1$

$$

We summarize $sans("Dec")_(sans("RNS"))^(sans("BFV"))$ as follows:

#block[
#strong[#underline[Input]:] $sans("ct")\(s\)= Delta m + e + k q$

+ Pick some prime number $gamma$ which is co-prime to $t$ and $q$.

+ Compute
  $sans("FastBConv")\(\|gamma dot.op t dot.op sans("ct")\(s\)\|_q\,q\,gamma t\)dot.op\|- q^(- 1)\|_(gamma t)$

  $=\(y_gamma\,y_t\)in bb(Z)_gamma times bb(Z)_t$

+ Compute
  $\|m\|_t= #scale(x: 180%, y: 180%)[\|]\(y_t - y_gamma\)dot.op\|gamma^(- 1)\|_t#scale(x: 180%, y: 180%)[\|]_t$

]
=== CKKS and BGV Decryption
<subsubsec:rns-dec-ckks-bgv>
CKKS and BGV ciphertexts can be decrypted efficiently by performing the
ModDrop operation (Summary~@subsec:rns-moddrop in
#link(<subsec:rns-moddrop>)[0.4]) to the lowest multiplicative level.
After this, there remains only a single ciphertext modulus in the RNS
base, so the regular decryption algorithm can be executed efficiently
without any RNS components.

== BGV's RNS-based Modulus Switch: $sans("ModSwitch")_(sans("RNS"))^(sans("BGV"))$
<subsec:rns-modswitch-bgv>
BGV's RNS-based modulus switch is not computed by using the standard
ModSwitch#sub[RNS], because BGV's original non-RNS modulus switch
(Summary~@subsec:bgv-modulus-switch in
#link(<subsec:bgv-modulus-switch>)[\[subsec:bgv-modulus-switch\]]) is
performed in a different manner than BFV or CKKS's non-RNS modulus
switch (Summary~@subsec:modulus-switch-rlwe in
#link(<subsec:modulus-switch-rlwe>)[\[subsec:modulus-switch-rlwe\]]).
BGV's non-RNS modulus switch is computed as follows:

$\(A'\,B'\)= (⌈hat(q) / q_l A⌋ \, ⌈hat(q) / q_l dot.op B⌋) in cal(R)_(chevron.l n\,hat(q) chevron.r)^2$

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

Therefore, BGV's RNS-based modulus switch only needs to compute the
above formulas for $hat(A)$ and $hat(B)$ based on RNS's $\(+\,dot.op\)$
arithmetic. In the above computations, the only part that cannot be
directly computed by RNS-based $\(+\,dot.op\)$ operations is the
rounding in $⌈hat(q) / q_l A⌋$ and $⌈hat(q) / q_l dot.op B⌋$. This
rounding can be performed in RNS by using
$sans("Dec")_(sans("RNS"))^(sans("BFV"))$, by setting $q = q_l$ and
$t = hat(q)$.

== Exact Fast Base Conversion: FastBConvEx
<subsec:rns-fastbconvex>
FastBConv (#link(<subsec:rns-fastbconv>)[0.1]) converts an input value
$x$'s base moduli from $q arrow.r b$, but generates a noise equivalent
to $u q med mod med b$ where integer $\|u\|lt.eq k / 2 + 1$. If we use
FastBConv with SmallMont (#link(<subsec:rns-smallmont>)[0.2]), we can
reduce the generated noise from $u q$ to $u' q$ where
$u' in { - 1\,0\,1 }$. In this subsection, we introduce FastBConvEx, an
algorithm for an exact fast base conversion that can eliminate the
entire noise. However, using FastBConvEx has a restriction that the
input value $x$ should be relatively much smaller than its modulus. This
is different from the case of using FastBConv with SmallMont which has
no restriction on the input $x$ (i.e., $x$ can be any value within its
modulus range). FastBConvEx is designed as follows:

#block[
#strong[#underline[Input]:]
$x =\(x_1\,x_2\,dots.h.c\,x_l\,x_alpha\)in bb(Z)_(b_1) times bb(Z)_(b_2) times dots.h.c times bb(Z)_(b_l) times bb(Z)_(b_alpha)$

$$

#strong[#underline[Requirement]:] The size of $b_alpha$ should be
$b_alpha gt.eq 2 dot.op\(l + lambda\)$, where
$\|x\|_b= x + mu dot.op b$, and $mu in\[- lambda\,lambda\]$ (i.e.,
$lambda$ and $- lambda$ are the maximum and minimum possible values of
$mu$).

$gt.tri$ The constraint that $b_alpha > mu$ implies that the input $x$
should be much smaller than its modulus $b b_alpha$ (i.e.,
$\|x\|lt.double frac(b b_alpha, 2)$)

$$

#strong[#underline[Main Steps]]

+ $hat(x) =\|x\|_b= sans("ModDrop")\(x\,b b_alpha\,b\)$

+ $x_alpha =\|x\|_(b_alpha)= sans("ModDrop")\(x\,b b_alpha\,b_alpha\)$

+ $gamma =\|\(sans("FastBConv")\(hat(x)\,b\,b_alpha\)- x_alpha\)dot.op b^(- 1)\|_(b_alpha)$

+ $sans("FastBConvEx")\(x\,b b_alpha\,q\)= #scale(x: 180%, y: 180%)[\|] sans("FastBConv")\(hat(x)\,b\,q\)- gamma dot.op b #scale(x: 180%, y: 180%)[\|]_q =\|x\|_q$

]
We will prove why
$#scale(x: 180%, y: 180%)[\|] sans("FastBConv")\(hat(x)\,b\,q\)- gamma dot.op b #scale(x: 180%, y: 180%)[\|]_q =\|x\|_q$.

#block[
+ $sans("FastBConv")\(hat(x)\,b\,b_alpha\)$

  $=\|hat(x) + u b\|_(b_alpha)$ $gt.tri$ where integer
  $\|u\|lt.eq l / 2 + 1$

  $= #scale(x: 180%, y: 180%)[\|]\|x\|_b+ u b #scale(x: 180%, y: 180%)[\|]_(b_alpha)$
  $gt.tri$ since $\|x\|_b= hat(x)$ by definition

  $=\|x + mu b + u b\|_(b_alpha)$ $gt.tri$ since $\|x\|_b= x + mu b$ by
  definition

  $$

+ $gamma =\|\(sans("FastBConv")\(hat(x)\,b\,b_alpha\)- x_alpha\)dot.op b^(- 1)\|_(b_alpha)$

  $=\|\(sans("FastBConv")\(hat(x)\,b\,b_alpha\)- x_alpha - mu b\)dot.op b^(- 1) + mu\|_(b_alpha)$
  $gt.tri$ by adding $\|\(- mu b + mu b\)dot.op b^(- 1)\|_(b_alpha)$

  $=\|\(x + mu b + u b - x_alpha - mu b\)dot.op b^(- 1) + mu\|_(b_alpha)$
  $gt.tri$ step 1 proved
  $sans("FastBConv")\(hat(x)\,b\,b_alpha\)=\|x + mu b + u dot.op b\|_(b_alpha)$

  $=\|u + mu\|_(b_alpha)$

  $= u + mu$ $gt.tri$ because
  $- b_alpha / 2 lt.eq u + mu lt.eq b_alpha / 2 - 1$ (since
  $u + mu < l + lambda lt.eq b_alpha / 2$, and
  $- b_alpha / 2 lt.eq -\(l + lambda\)< u + mu$)

  $$

+ $sans("FastBConvEx")\(x\,b\,q\)= #scale(x: 180%, y: 180%)[\|] sans("FastBConv")\(hat(x)\,b\,q\)- gamma dot.op b\)#scale(x: 180%, y: 180%)[\|]_q$

  $= #scale(x: 180%, y: 180%)[\|] hat(x) + u b - gamma dot.op b\)#scale(x: 180%, y: 180%)[\|]_q$
  $gt.tri$ applying $sans("FastBConv")\(hat(x)\,b\,q\)= hat(x) + u b$

  $= #scale(x: 180%, y: 180%)[\|]\(x + mu b\)+ u b - gamma dot.op b\)#scale(x: 180%, y: 180%)[\|]_q$
  $gt.tri$ applying $hat(x) =\|x\|_b= x + mu b$

  $= #scale(x: 180%, y: 180%)[\|]\(x + mu b\)+ u b -\(u + mu\)dot.op b\)#scale(x: 180%, y: 180%)[\|]_q$
  $gt.tri$ applying $gamma = u + mu$ from proof step 2

  $=\|x + mu b + u b - u b - mu b\|_q$

  $=\|x\|_q$

]
In the proof step 2, we treated $\|u + mu\|_(b_alpha)= u + mu$. To
remove the modulo reduction operation, the canonical (i.e., unsigned)
residue representation is inappropriate, because if $u + mu$ becomes
negative, then the residue will underflow and have to be wrapped around,
which requires a modulo reduction operation. To prevent the occurrence
of both overflow and underflow cases, we need the centered (i.e.,
signed) residue representation.

== Decomposing Multiplication: DecompMult#sub[RNS]
<subsec:rns-decompmult>
In FHE, gadget decomposition
(#link(<subsec:gadget-decomposition>)[\[subsec:gadget-decomposition\]])
is used to compute ciphertext-to-plaintext multiplication with small
noise. For example, BFV and CKKS's homomorphic key switching
(Summary~@sec:glwe-key-switching in
#link(<sec:glwe-key-switching>)[\[sec:glwe-key-switching\]]) uses gadget
decomposition to compute
$sans("RLWE")_(S'\,sigma)\(Delta M\)= B + A dot.op sans("RLWE")_(S'\,sigma)\(S\)$
with small noise (where each coefficient of the polynomial $A$ can be
any value within the range of the ciphertext modulus $q$). As another
example, the relinearization process of ciphertext-to-ciphertext
multiplication in BFV (Summary~@subsubsec:bfv-mult-cipher-summary in
#link(<subsubsec:bfv-mult-cipher-summary>)[\[subsubsec:bfv-mult-cipher-summary\]]),
CKKS (Summary~@subsubsec:ckks-mult-cipher-summary in
#link(<subsubsec:ckks-mult-cipher-summary>)[\[subsubsec:ckks-mult-cipher-summary\]]),
and BGV (Summary~@subsec:bgv-mult-cipher in
#link(<subsec:bgv-mult-cipher>)[\[subsec:bgv-mult-cipher\]]) uses gadget
decomposition to derive the synthetic ciphertext
$sans("RLWE")_(S'\,sigma)\(D_2 dot.op S^2\)$ when computing
$sans("RLWE")_(S'\,sigma)\(Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)\)= D_0 + D_1 dot.op S + D_2 dot.op S^2 = sans("ct")_alpha + sans("ct")_beta$,
where $sans("ct")_alpha =\(D_0\,D_1\)$,
$sans("ct")_beta = sans("RLWE")_(S'\,sigma)\(D_2 dot.op S^2\)$,
$D_0 = B_1 B_2$, $D_1 = A_1 B_2 + A_2 B_1$, and $D_2 = A_1 A_2$. Using
gadget decomposition, we showed the following relations:

$sans("RLWE")_(S'\,sigma)\(A dot.op S\)= bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$
$gt.tri$ used in key switching

$sans("RLWE")_(S'\,sigma)\(D_2 dot.op S^2\)= bold(chevron.l) sans("Decomp")^(beta\,l)\(D_2\)\,upright(" ") sans("RLev")_(S\,sigma)^(beta\,l)\(S^2\)bold(chevron.r)$
$gt.tri$ used in relinearization

$$

However, if we convert a value (e.g., $x$) into an RNS vector, then it
cannot be directly expressed in a gadget-decomposed form based on the
$beta$ and $l$ parameters. Instead, given the relationship between the
value $x$ and its RNS residues is
$x = sum_(i = 1)^k x dot.op q / q_i dot.op lr(|(q / q_i^(- 1))|)_(q_i) med mod med q$,
we can treat each RNS residue as a gadget-decomposed element. For
example, suppose our goal is to decompose
$sans("RLWE")_(S'\,sigma)\(A dot.op S\)$, where the RNS vector of
$A =\(A_1\,A_2\,dots.h.c\,A_k\)$ has base moduli
$\(q_1\,q_2\,dots.h.c\,q_k\)$. In other wods, the RNS representation of
the polynomial $A$ is the set of polynomials ${ A_i }_(i = 1)^k$ such
that $A_i = A med mod med q_i$. We can decompose
$sans("RLWE")_(S'\,sigma)\(A dot.op S\)$ as follows:

$sans("RLWE")_(S'\,sigma)\(A dot.op S\)med mod med q$

$= sans("RLWE")_(S'\,sigma) (S dot.op (A_1 q / q_1 dot.op lr(|(q / q_1)^(- 1)|)_(q_1) + A_2 q / q_2 dot.op lr(|(q / q_2)^(- 1)|)_(q_2) + dots.h.c + A_k q / q_k dot.op lr(|(q / q_k)^(- 1)|)_(q_k))) med mod med q$

$= sans("RLWE")_(S'\,sigma) (S dot.op A_1 q / q_1 dot.op lr(|(q / q_1)^(- 1)|)_(q_1)) + sans("RLWE")_(S'\,sigma) (S dot.op A_2 q / q_2 dot.op lr(|(q / q_2)^(- 1)|)_(q_2)) +$

$dots.h.c + sans("RLWE")_(S'\,sigma) (S dot.op A_k q / q_k dot.op lr(|(q / q_k)^(- 1)|)_(q_k)) med mod med q$

$$

$$

$= A_1 dot.op sans("RLWE")_(S'\,sigma) (S dot.op q / q_1 dot.op lr(|(q / q_1)^(- 1)|)_(q_1)) + A_2 dot.op sans("RLWE")_(S'\,sigma) (S dot.op q / q_2 dot.op lr(|(q / q_2)^(- 1)|)_(q_2)) +$

$dots.h.c + A_k dot.op sans("RLWE")_(S'\,sigma) (S dot.op q / q_k dot.op lr(|(q / q_k)^(- 1)|)_(q_k)) med mod med q$

$$

$$

$= sum_(i = 1)^k (A_i dot.op sans("RLWE")_(S'\,sigma) (S dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i))) med mod med q$

$$

$$

, where
${sans("RLWE")_(S'\,sigma) (S dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i))}_(i = 1)^k$
can be pre-generated as RNS key-switching keys.

$$

$$

Applying the same reasoning as above, we can also derive the following
for relinearization:

$sans("RLWE")_(S\,sigma)\(D_2 dot.op S^2\)= sum_(i = 1)^k #scale(x: 300%, y: 300%)[\(] D_(2\,i) dot.op sans("RLWE")_(S\,sigma) (S^2 dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i)) #scale(x: 300%, y: 300%)[\)] med mod med q$

$$

$$

, where
${sans("RLWE")_(S\,sigma) (S^2 dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i))}_(i = 1)^k$
can be pre-generated as relinearization keys.

$$

$$

RNS-based multiplication decomposition is summarized as follows:

#block[
For key-switching:

$$

#strong[#underline[Input]:]
$A =\(A_1\,A_2\,dots.h.c\,A_k\)in cal(R)_(chevron.l n\,q_1 chevron.r) times cal(R)_(chevron.l n\,q_2 chevron.r) times dots.h.c times cal(R)_(chevron.l n\,q_k chevron.r)$,

$S_(chevron.l S'\,sans("RNS") chevron.r) = {sans("RLWE")_(S'\,sigma) (S dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i))}_(i = 1)^k$
$gt.tri$ key-switching keys

$$

$$

\$\\textsf{DecompMult\\textsubscript{RNS}}(A, S\_{\\langle S\', \\textsf{RNS}\\rangle}) = \\textsf{RLWE}\_{S\', \\sigma}(A \\cdot S)\$

$= sum_(i = 1)^k #scale(x: 300%, y: 300%)[\(] A_i dot.op sans("RLWE")_(S'\,sigma) (S dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i)) #scale(x: 300%, y: 300%)[\)] med mod med q$

$$

#horizontalrule

For relinearization:

$$

#strong[#underline[Input]:]
$D_2 =\(D_(2\,1)\,D_(2\,2)\,dots.h.c\,D_(2\,k)\)in cal(R)_(chevron.l n\,q_1 chevron.r) times cal(R)_(chevron.l n\,q_2 chevron.r) times dots.h.c times cal(R)_(chevron.l n\,q_k chevron.r)$,

$S_(chevron.l S\,sans("RNS") chevron.r)^2 = {sans("RLWE")_(S\,sigma) (S^2 dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i))}_(i = 1)^k$
$gt.tri$ relinearization keys

$$

$$

\$\\textsf{DecompMult\\textsubscript{RNS}}(D\_2, S^2\_{\\langle S, \\textsf{RNS}\\rangle}) = \\textsf{RLWE}\_{S, \\sigma}(D\_2 \\cdot S^2)\$

$= sum_(i = 1)^k #scale(x: 300%, y: 300%)[\(] D_(2\,i) dot.op sans("RLWE")_(S\,sigma) (S^2 dot.op q / q_i dot.op lr(|(q / q_i)^(- 1)|)_(q_i)) #scale(x: 300%, y: 300%)[\)] med mod med q$

]
== Applying RNS Techniques to FHE Operations
<subsec:rns-application>
This subsection will explain how the RNS primitives we have learned so
far are used to handle FHE operations for RNS-based ciphertexts in BFV,
CKKS, and BGV.

=== Addition and Multiplication of Polynomials
<subsubsec:rns-application-basic>
In BFV, CKKS, and BGV, ciphertext-to-plaintext addition,
ciphertext-to-ciphertext addition, and ciphertext-to-plaintext
multiplication are performed by only involving modulo additions and
multiplications among polynomial coefficients. Therefore, we can
represent each polynomial coefficient as an RNS residue vector and
compute coefficient-wise additions and multiplications by using
RNS-based addition and multiplication of residues, as explained in
Summary~@subsec:crt-application
(#link(<subsec:crt-application>)[\[subsec:crt-application\]]). For
example, suppose we have the following two polynomials
$P^(chevron.l 1 chevron.r)$ and $P^(chevron.l 2 chevron.r)$:

$P^(chevron.l 1 chevron.r) = sum_(a = 0)^(n - 1) c_a^(chevron.l 1 chevron.r) dot.op X^a in cal(R)_(chevron.l n\,q chevron.r)$

$P^(chevron.l 2 chevron.r) = sum_(b = 0)^(n - 1) c_b^(chevron.l 2 chevron.r) dot.op X^b in cal(R)_(chevron.l n\,q chevron.r)$

$$

In the RNS-variant FHE schemes, we express each coefficient of the
polynomial as an RNS residue vector as follows:

$c_a^(chevron.l 1 chevron.r) =\(c_(a\,1)^(chevron.l 1 chevron.r)\,c_(a\,2)^(chevron.l 1 chevron.r)\,dots.h.c\,c_(a\,k)^(chevron.l 1 chevron.r)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$
$gt.tri$ for $a in\[0\,n - 1\]$

$c_b^(chevron.l 2 chevron.r) =\(c_(b\,1)^(chevron.l 2 chevron.r)\,c_(b\,2)^(chevron.l 2 chevron.r)\,dots.h.c\,c_(b\,k)^(chevron.l 2 chevron.r)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$
$gt.tri$ for $b in\[0\,n - 1\]$

$$

Given the above RNS setup, when we add or multiply two polynomials, each
coefficient-to-coefficient addition is computed as element-wise
additions of two RNS residue vectors as follows:

$c_a^(chevron.l 1 chevron.r) + c_b^(chevron.l 2 chevron.r) equiv sum_(i = 1)^k\(c_(a\,i)^(chevron.l 1 chevron.r) + c_(b\,i)^(chevron.l 2 chevron.r)\)y_i z_i med mod med q$
$gt.tri$ where $y_i = q / q_i$, $z_i =\|y_i^(- 1)\|_(q_i)$

$arrow.l.r.double\(c_(a\,1)^(chevron.l 1 chevron.r) + c_(b\,1)^(chevron.l 2 chevron.r)\,upright(" ") c_(a\,2)^(chevron.l 1 chevron.r) + c_(b\,2)^(chevron.l 2 chevron.r)\,dots.h.c\,upright(" ") c_(a\,k)^(chevron.l 1 chevron.r) + c_(b\,k)^(chevron.l 2 chevron.r)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

$$

Similarly, each coefficient-to-coefficient multiplication is computed as
element-wise multiplications of two RNS residue vectors as follows:

$c_a^(chevron.l 1 chevron.r) dot.op c_b^(chevron.l 2 chevron.r) equiv sum_(i = 1)^k\(c_(a\,i)^(chevron.l 1 chevron.r) dot.op c_(b\,i)^(chevron.l 2 chevron.r)\)y_i z_i med mod med q$

$arrow.l.r.double\(c_(a\,1)^(chevron.l 1 chevron.r) dot.op c_(b\,1)^(chevron.l 2 chevron.r)\,upright(" ") c_(a\,2)^(chevron.l 1 chevron.r) dot.op c_(b\,2)^(chevron.l 2 chevron.r)\,dots.h.c\,upright(" ") c_(a\,k)^(chevron.l 1 chevron.r) dot.op c_(b\,k)^(chevron.l 2 chevron.r)\)in bb(Z)_(q_1) times bb(Z)_(q_2) times dots.h.c times bb(Z)_(q_k)$

$$

Using the above isomorphism, we can efficiently compute
ciphertext-to-plaintext addition, ciphertext-to-ciphertext addition, and
ciphertext-to-plaintext multiplication of big polynomial coefficients
(e.g., 1000 bits big) based on small RNS residues (e.g., 30 bits each).

=== Key Switching
<subsubsec:rns-application-key-switching>
In BFV or CKKS, an RNS-based ciphertext's key-switching operation from
$S arrow.r S'$ is performed by computing the following formula in RNS
vectors:

$sans("RLWE")_(S'\,sigma)\(Delta M\)= B + bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$

$$

In the above formula, the computation of
$bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$
can be performed by using \$\\textsf{DecompMult\\textsubscript{RNS}}\$
(Summary~@subsec:rns-decompmult in #link(<subsec:rns-decompmult>)[0.9]),
after which $B$ can be added to it by using regular RNS-based addition.

$$

Similarly, in the case of the BGV, an RNS-based key-switching operation
on a ciphertext from $S arrow.r S'$ is performed by computing the
following in RNS vectors:

$sans("RLWE")_(S'\,sigma)\(M\)= B + bold(chevron.l) sans("Decomp")^(beta\,l)\(A\)\,upright(" ") sans("RLev")_(S'\,sigma)^(beta\,l)\(S\)bold(chevron.r)$

=== Input Slot Rotation
<subsubsec:rns-rotation>
In BFV or CKKS, an RNS-based ciphertext's input slot rotation is
performed by computing the following formulas in RNS vectors:

$$

+ $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\)) = bold(\() A\(X^(J\(h\))\)$,
  $B\(X^(J\(h\))\)bold(\))$ $gt.tri$ where $J\(h\)= 5^h med mod med 2 n$

+ Key-switch
  $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\))$
  to
  $sans("RLWE")_(S\(X\)\,sigma) bold(\() Delta M\(X^(J\(h\))\)bold(\))$

$$

Step 1 is equivalent to re-positioning the coefficients within each
polynomial and flipping their signs whenever they cross the boundary of
the $n$-th degree term. This step can be done with RNS-based
coefficients by moving around each set of RNS residue vectors as a whole
whenever the coefficient they represent is re-positioned to a new degree
term, and flipping the signs of the residues in the same RNS vector
altogether whenever their representing coefficient's sign is to be
flipped. Step 2's RNS-based key switching can be done in the same way as
explained in the previous subsection
(#link(<subsubsec:rns-application-key-switching>)[0.10.2]).

$$

Similarly, in BGV, an RNS-based ciphertext's input slot rotation is
performed by computing the following formulas in RNS vectors:

$$

+ $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() M\(X^(J\(h\))\)bold(\)) = bold(\() A\(X^(J\(h\))\)$,
  $B\(X^(J\(h\))\)bold(\))$ $gt.tri$ where $J\(h\)= 5^h med mod med 2 n$

+ Key-switch
  $sans("RLWE")_(S\(X^(J\(h\))\)\,sigma) bold(\() M\(X^(J\(h\))\)bold(\))$
  to $sans("RLWE")_(S\(X\)\,sigma) bold(\() M\(X^(J\(h\))\)bold(\))$

$$

We can compute the above formulas in RNS by using the same strategy
explained for BFV or CKKS.

=== BFV's Ciphertext-to-Ciphertext Multiplication
<subsubsec:rns-cipher-mult-bfv>
BFV's ciphertext-to-ciphertext multiplication
(Summary~@subsubsec:bfv-mult-cipher-summary in
#link(<subsubsec:bfv-mult-cipher-summary>)[\[subsubsec:bfv-mult-cipher-summary\]])
comprises ModRaise $arrow.r$ polynomial multiplication $arrow.r$
relinearization $arrow.r$ rescaling, where the order of relinearization
and rescaling can be swapped. In RNS-based ciphertext-to-ciphertext
multiplication, we will swap the order of these two steps. The procedure
is as follows: (1) ModRaise#sub[RNS] from $q arrow.r q b$\; (2)
polynomial multiplication; (3) constant multiplication by $t$\; (4)
ModSwitch from $q b arrow.r b$\; (5) FastBConvEx from $b arrow.r q$\;
and (6) relinearization. Among these, step $3 tilde.op 5$ corresponds to
the rescaling operation. We will explain how each of these steps works.

$$

+ #strong[#underline[ModRaise#sub[RNS]] from $q arrow.r q b b_alpha$:]

  Let $b$ be a new RNS base where $b > Delta$ so that $q b$ is large
  enough to prevent a multiplied scaled plaintext in ciphertexts (i.e.,
  $Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$) from
  exceeding its allowed limit (Summary~@subsec:bfv-enc-dec in
  #link(<subsec:bfv-enc-dec>)[\[subsec:bfv-enc-dec\]]) during
  ciphertext-to-ciphertext multiplication. $b_alpha$ is also added for
  exact fast base conversion to be performed later. Specifically, we
  mod-raise the modulus of each polynomial coefficient of ciphertexts
  $\(A^(chevron.l 1 chevron.r)\,B^(chevron.l 1 chevron.r)\)$ and
  $\(A^(chevron.l 2 chevron.r)\,B^(chevron.l 2 chevron.r)\)$ as follows:

  $\(hat(A)^(chevron.l 1 chevron.r)\,hat(B)^(chevron.l 1 chevron.r)\)=\(A^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q\,B^(chevron.l 1 chevron.r) + U_B^(chevron.l 1 chevron.r) q\)med mod med q b b_alpha$

  $\(hat(A)^(chevron.l 2 chevron.r)\,hat(B)^(chevron.l 2 chevron.r)\)=\(A^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q\,B^(chevron.l 2 chevron.r) + U_B^(chevron.l 2 chevron.r) q\)med mod med q b b_alpha$

  $$

  , where each coefficient of
  $U_A^(chevron.l 1 chevron.r)\,U_B^(chevron.l 1 chevron.r)\,U_A^(chevron.l 2 chevron.r)\,U_B^(chevron.l 2 chevron.r)$
  is either ${ - 1\,0\,1 }$. Decrypting these two (noisy) ciphertexts
  with the private key $S$ would give the following outputs:

  $hat(A)^(chevron.l 1 chevron.r) dot.op S + hat(B)^(chevron.l 1 chevron.r) med mod med q b b_alpha$

  $=\(A^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q\)dot.op S +\(B^(chevron.l 1 chevron.r) + U_B^(chevron.l 1 chevron.r) q\)med mod med q b b_alpha$

  $= A^(chevron.l 1 chevron.r) dot.op S + B^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q dot.op S + U_B^(chevron.l 1 chevron.r) q med mod med q b b_alpha$

  $= Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q dot.op S + U_B^(chevron.l 1 chevron.r) q + K^(chevron.l 1 chevron.r) q med mod med q b b_alpha$
  $gt.tri$ where $+ K^(chevron.l 1 chevron.r) q$ is the $q$-overflows of
  the decryption process

  $$

  $hat(A)^(chevron.l 2 chevron.r) dot.op S + hat(B)^(chevron.l 2 chevron.r) med mod med q b b_alpha$

  $=\(A^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q\)dot.op S +\(B^(chevron.l 2 chevron.r) + U_B^(chevron.l 2 chevron.r) q\)med mod med q b b_alpha$

  $= A^(chevron.l 2 chevron.r) dot.op S + B^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q med mod med q b b_alpha$

  $= Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q med mod med q b b_alpha$

  $$

+ #strong[#underline[Polynomial Multiplication:]]

  Compute
  $\(hat(B)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r)\,hat(A)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r) + hat(A)^(chevron.l 2 chevron.r) B^(chevron.l 1 chevron.r)\,hat(A)^(chevron.l 1 chevron.r) hat(A)^(chevron.l 2 chevron.r)\)med mod med q b b_alpha$,
  whose decryption relation is as follows:

  $hat(B)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r) +\(hat(A)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r) + hat(A)^(chevron.l 2 chevron.r) B^(chevron.l 1 chevron.r)\)dot.op S +\(hat(A)^(chevron.l 1 chevron.r) hat(A)^(chevron.l 2 chevron.r)\)dot.op S^2 med mod med q b b_alpha$

  $=\(hat(A)^(chevron.l 1 chevron.r) dot.op S + hat(B)^(chevron.l 1 chevron.r)\)dot.op\(hat(A)^(chevron.l 2 chevron.r) dot.op S + hat(B)^(chevron.l 2 chevron.r)\)med mod med q b b_alpha$

  $=\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q dot.op S + U_B^(chevron.l 1 chevron.r) q + K^(chevron.l 1 chevron.r) q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q\)med mod med q b b_alpha$

  $$

+ #strong[#underline[Constant Multiplication] by $bold(t)$:]

  Step $3 tilde.op 5$ are equivalent to rescaling the plaintext's
  scaling factor from $Delta^2 arrow.r Delta$ as well as switching the
  ciphertext's modulus from $q b b_alpha$ to $q$. In this step, we
  multiply $t$ to each coefficient of the resulting polynomials from the
  previous step as follows:

  $\(t dot.op hat(B)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r)\,upright(" ") t dot.op hat(A)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r) + t dot.op hat(A)^(chevron.l 2 chevron.r) B^(chevron.l 1 chevron.r)\,upright(" ") t dot.op hat(A)^(chevron.l 1 chevron.r) hat(A)^(chevron.l 2 chevron.r)\)med mod med q b b_alpha$

  $$

  , which is equivalent to a ciphertext encrypting the following
  plaintext:

  $t dot.op\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q dot.op S + U_B^(chevron.l 1 chevron.r) q + K^(chevron.l 1 chevron.r) q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q\)med mod med q b b_alpha$

  $$

+ #strong[#underline[ModSwitch#sub[RNS]] from
  $q b b_alpha arrow.r b b_alpha$:]

  We switch the modulus of the ciphertext from $q b$ to $b$ by using
  ModSwitch#sub[RNS] as follows:

  $(⌈frac(t dot.op hat(B)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r), q)⌋ \, ⌈frac(t dot.op hat(A)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r) + t dot.op hat(A)^(chevron.l 2 chevron.r) B^(chevron.l 1 chevron.r), q)⌋ \, ⌈frac(t dot.op hat(A)^(chevron.l 1 chevron.r) hat(A)^(chevron.l 2 chevron.r), q)⌋) med mod med b b_alpha$

  $$

  , which is (almost, considering the rounding error) equivalent to a
  ciphertext encrypting the following plaintext:

  $⌈frac(t dot.op\(Delta M^(chevron.l 1 chevron.r) + E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) q dot.op S + U_B^(chevron.l 1 chevron.r) q + K^(chevron.l 1 chevron.r) q\)dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q\), q)⌋ med mod med b b_alpha$

  $$

  $= ⌈\( M^(chevron.l 1 chevron.r) + t / q dot.op E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) t dot.op S + U_B^(chevron.l 1 chevron.r) t + K^(chevron.l 1 chevron.r) t + epsilon.alt_d \) dot.op \( Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q \)⌋ med mod med b b_alpha$

  $gt.tri$ where
  $epsilon.alt_d = t / q dot.op Delta M^(chevron.l 1 chevron.r) - M^(chevron.l 1 chevron.r)$
  is a rounding error caused by treating $q / t approx ⌊q / t⌋ = Delta$

  $$

+ #strong[#underline[FastBConvEx#sub[RNS]] from $b arrow.r q$:]

  We exactly convert the base of the ciphertext from
  $b b_alpha arrow.r q$ as follows:

  $(⌈frac(t dot.op hat(B)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r), q)⌋ \, ⌈frac(t dot.op hat(A)^(chevron.l 1 chevron.r) hat(B)^(chevron.l 2 chevron.r) + t dot.op hat(A)^(chevron.l 2 chevron.r) B^(chevron.l 1 chevron.r), q)⌋ \, ⌈frac(t dot.op hat(A)^(chevron.l 1 chevron.r) hat(A)^(chevron.l 2 chevron.r), q)⌋) med mod med q$

  $$

  , which is equivalent to a ciphertext encrypting the following
  plaintext:

  $= ⌈\( M^(chevron.l 1 chevron.r) + t / q dot.op E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) t dot.op S + U_B^(chevron.l 1 chevron.r) t + K^(chevron.l 1 chevron.r) t + epsilon.alt_d \) dot.op \( Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q \)⌋ med mod med q$

  $= #scale(x: 180%, y: 180%)[ceil.l] Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) + t / q dot.op Delta M^(chevron.l 2 chevron.r) E^(chevron.l 1 chevron.r) + U_A^(chevron.l 1 chevron.r) t Delta M^(chevron.l 2 chevron.r) dot.op S + U_B^(chevron.l 1 chevron.r) t Delta M^(chevron.l 2 chevron.r) + M^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) + t / q dot.op E^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r)$

  $+ U_A^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) t dot.op S + U_B^(chevron.l 1 chevron.r) E^(chevron.l 2 chevron.r) t + K^(chevron.l 1 chevron.r) t Delta M^(chevron.l 2 chevron.r) + K^(chevron.l 1 chevron.r) t E^(chevron.l 2 chevron.r) + epsilon.alt_d dot.op\(Delta M^(chevron.l 2 chevron.r) + E^(chevron.l 2 chevron.r) + U_A^(chevron.l 2 chevron.r) q dot.op S + U_B^(chevron.l 2 chevron.r) q + K^(chevron.l 2 chevron.r) q\)#scale(x: 180%, y: 180%)[floor.r] med mod med q$

  $approx Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r) med mod med q$
  $gt.tri$ all other terms are relatively much smaller than
  $Delta M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$ in modulo
  $q$

  $$

+ #strong[#underline[Relinearization]:]

  Once we have derived the rescaled polynomial triple
  $\(D'_0\,D'_1\,D'_2\)med mod med q$, the final relinearization step is
  equivalent to deriving the synthetic ciphertexts $sans("ct")_alpha$
  and $sans("ct")_beta$ and then computing
  $sans("ct")_alpha + sans("ct")_beta$. $sans("ct")_alpha$ is simply
  $\(D'_0\,D'_1\)$, and we can derive
  $sans("ct")_beta = sans("RLWE")_(S\,sigma)\(D_2 dot.op S^2\)$ by using
  the DecompMult#sub[RNS] operation (Summary~@subsec:rns-decompmult in
  #link(<subsec:rns-decompmult>)[0.9]). The final
  ciphertext-to-ciphertext addition of
  $sans("ct")_alpha + sans("ct")_beta$ can be performed by using regular
  RNS addition.

=== CKKS's Ciphertext-to-Ciphertext Multiplication
<subsubsec:rns-cipher-mult-ckks>
CKKS's ciphertext-to-ciphertext multiplication
(Summary~@subsubsec:ckks-mult-cipher-summary in
#link(<subsubsec:ckks-mult-cipher-summary>)[\[subsubsec:ckks-mult-cipher-summary\]])
is almost the same as BFV's, except that CKKS does not need the ModRaise
operation in the beginning (because each multiplicative level's modulus
$q_l$ is large enough to hold a multiplied scaled plaintext
$Delta^2 M^(chevron.l 1 chevron.r) M^(chevron.l 2 chevron.r)$).
Therefore, CKKS's RNS-based multiplication is the same as BFV's except
that it does not require step 1 (ModRaise), step 3 (constant
multiplication by $t$), and step 5 (exact fast base conversion). Since a
CKKS ciphertext's scaling factor $Delta$ is approximately the same as
the prime modulus factor of each multiplicative level, each
ciphertext-to-ciphertext multiplication only needs to perform a modulus
switch to a lower level.

=== BGV's Ciphertext-to-Ciphertext Multiplication
<subsubsec:rns-cipher-mult-bgv>
BGV's ciphertext-to-ciphertext multiplication
(Summary~@subsec:bgv-mult-cipher in
#link(<subsec:bgv-mult-cipher>)[\[subsec:bgv-mult-cipher\]]) is almost
the same as CKKS's, except that BGV uses its own modulus switch
($sans("ModSwitch")_(sans("RNS"))^(sans("BGV"))$ as described in
Summary~@subsec:bgv-modulus-switch in
#link(<subsec:bgv-modulus-switch>)[\[subsec:bgv-modulus-switch\]])
during the rescaling step. Therefore, BGV's RNS-based
ciphertext-to-ciphertext multiplication is the same as CKKS's, except
that ModSwitch#sub[RNS] is replaced by
$sans("ModSwitch")_(sans("RNS"))^(sans("BGV"))$.

=== BFV's Bootstrapping
<subsubsec:rns-bfv-bootstrapping>
BFV's original bootstrapping procedure
(Summary~@subsubsec:bfv-bootstrapping-summary in
#link(<subsubsec:bfv-bootstrapping-summary>)[\[subsubsec:bfv-bootstrapping-summary\]])
is as follows: (1) modulus switch from $q arrow.r p^epsilon$\; (2)
homomorphic decryption; (3) CoeffToSlot\; (4) EvalExp\; (5)
SlotToCoeff\; and (6) re-interpretation.

However, in RNS, we cannot mod-switch to $p^epsilon$ because RNS's base
moduli have to be co-prime to each other, whereas the factors of
$p^epsilon$ are not. To avoid this issue, RNS-based BFV's bootstrapping
instead performs the following: (1) ModRaise#sub[RNS] from
$q arrow.r q b b_alpha$, where $b b_alpha$ is an auxiliary base; (2)
coefficient multiplication by $p^epsilon$\; (3) ModSwitch#sub[RNS] from
$q b b_alpha arrow.r b b_alpha$\; (4) FastBConvEx from
$b b_alpha arrow.r q$\; (5) homomorphic decryption to adjust the scaling
factor of the plaintext; (6) CoeffToSlot\; (7) EvalExp\; (8)
SlotToCoeff\; and (9) re-interpretation. The detailed procedure is
described as follows:

$$

#strong[#underline[Input]:] The input BFV ciphertext to bootstrap is
$\(A\,B\)med mod med q$, which would decrypt to:

$A dot.op S + B = Delta M + E + K q$ $gt.tri$ where $Delta = q / p^r$

$$

+ #strong[#underline[ModRaise#sub[RNS]] from $q arrow.r q b b_alpha$:]

  Mod-raise ciphertext $\(A\,B\)med mod med q$ to
  $\(A\,B\)med mod med q b b_alpha$, which would decrypt to:

  $A dot.op S + B = Delta M + E + K q + U q med\(mod med q b b_alpha\)$

  $gt.tri$ where $U q$ is the FastBConv + SmallMont error, and $U$'s
  coefficients are either ${ - 1\,0\,1 }$

  $$

+ #strong[#underline[Coefficient Multiplication] by $p^epsilon$:]

  Multiply the coefficients of $\(A\,B\)med mod med q$ by $p^epsilon$ to
  update the ciphertext to
  $\(p^epsilon A\,p^epsilon B\)med mod med q b b_alpha$, which would
  decrypt to:

  $p^epsilon A dot.op S + p^epsilon B = Delta p^epsilon M + p^epsilon E + p^epsilon K q + p^epsilon U q med\(mod med q b b_alpha\)$

  $$

+ #strong[#underline[ModSwitch#sub[RNS]] from
  $q b b_alpha arrow.r b b_alpha$:]

  Mod-switch the ciphertext
  $\(p^epsilon A\,p^epsilon B\)med mod med p b b_alpha$ to
  $(⌈frac(p^epsilon A, q)⌋ \, ⌈frac(p^epsilon B, q)⌋) med\(mod med b b_alpha\)$,
  which would decrypt to:

  $⌈frac(p^epsilon A, q)⌋ dot.op S + ⌈frac(p^epsilon B, q)⌋ = frac(Delta p^epsilon M, q) + frac(p^epsilon E, q) + frac(p^epsilon K q, q) + frac(p^epsilon U q, q) + epsilon.alt med\(mod med b b_alpha\)$

  $gt.tri$ $epsilon.alt$ is a small rounding error

  $= p^(epsilon - r) M + frac(p^epsilon E, q) + p^epsilon K + p^epsilon U + epsilon.alt med\(mod med b b_alpha\)$

  $$

+ #strong[#underline[FastBConvEx] from $b b_alpha arrow.r q$:]

  Exact fast base conversion of
  $\(p^epsilon A\,p^epsilon B\)med mod med b b_alpha$ to
  $\(p^epsilon A\,p^epsilon B\)med mod med q$, which would decrypt to:

  $p^(epsilon - r) M + frac(p^epsilon E, q) + p^epsilon K + p^epsilon U + epsilon.alt med mod med q$

  $$

+ #strong[#underline[Homomorphic Decryption]:]

  Now, we have the ciphertext
  $\(p^epsilon A\,p^epsilon B\)med mod med q = sans("RLWE")_(S\,sigma) (p^(epsilon - r) M + frac(p^epsilon E, q) + p^epsilon K + p^epsilon U + epsilon.alt) med mod med q$.
  We do homomorphic decryption by using the encrypted private key
  $sans("RLWE")_(S\,sigma)\(hat(Delta) S\)$, where
  $hat(Delta) = ⌊q / p^epsilon⌋$. The output is
  $sans("RLWE")_(S\,sigma) bold(\() hat(Delta) dot.op\(p^(epsilon - r) M + frac(p^epsilon E, q) + p^epsilon K + p^epsilon U + epsilon.alt\)bold(\)) med mod med q$.

  $$

+ Perform CoeffToSlot, digit extraction, and SlotToCoeff. These
  operations can be performed by only regular RNS-based additions and
  multiplications. The final digit-extracted ciphertext is
  $sans("RLWE")_(S\,sigma) bold(\() hat(Delta) dot.op\(p^(epsilon - r) dot.op M + K p^epsilon + U p^epsilon\)bold(\))$,
  where all noise values smaller than the (base-$p$)
  $\(epsilon - r\)$-th digits are eliminated.

=== CKKS's Bootstrapping
<subsubsec:rns-ckks-bootstrapping>
CKKS's original bootstrapping procedure
(Summary~@subsubsec:ckks-bootstrapping-summary in
#link(<subsubsec:ckks-bootstrapping-summary>)[\[subsubsec:ckks-bootstrapping-summary\]])
is as follows: (1) Modraise\; (2) homomorphic decryption; (3)
CoeffToSlot\; (4) EvalExp\; (5) SlotToCoeff\; (6) Re-interpretation. In
the RNS-based CKKS bootstrapping, we perform ModRaise#sub[RNS] at step
1, and all other steps are computed using regular RNS-based addition and
multiplication operations. Step 1's ModRaise#sub[RNS] operation
generates a $u dot.op q_0$ noise (where $u in { - 1\,0\,1 }$ using
SmallMont) for each polynomial coefficient during FastBConv. Therefore,
step 2's homomorphic decryption outputs
$Delta M + E + W dot.op q_0 + K dot.op q_0$, where $W dot.op q_0$
represents the aggregation of all coefficient noise terms that are
multiplied by the $q_0$-overflow noises generated by FastBConv and
SmallMont. The $W dot.op q_0 + K dot.op q_0$ term is eliminated by step
4's EvalExp, which performs approximated modulo reduction based on a
sine-graph evaluation whose period is $q_0$.

=== BGV's Bootstrapping
<subsubsec:rns-bgv-bootstrapping>
BGV's original bootstrapping procedure
(#link(<subsec:bgv-bootstrapping>)[\[subsec:bgv-bootstrapping\]]) is as
follows: (1) modulus switch from $q_l arrow.r hat(q)$\; (2) ciphertext
coefficient multiplication by $p^(epsilon - 1)$\; (3) ModRaise\; (4)
CoeffToSlot\; (5) digit extraction; (6) homomorphic multiplication by
$\|p^(-\(epsilon - 1\))\|_(q^(l'))$\; (7) SlotToCoeff\; (8) noise term
re-interpretation. Given this procedure, the RNS-based bootstrapping
steps are as follows.

$$

Suppose the target BGV ciphertext to bootstrap is
$\(A\,B\)med mod med q_l$, where the plaintext modulus (i.e., noise
scaling factor) is $p$.

+ #strong[#underline[$sans("ModSwitch")_(sans("RNS"))^(sans("BGV"))$]]
  from $q_l arrow.r hat(q)$ where $hat(q)$ is a special modulus
  satisfying the following requirements:
  $hat(q) equiv 1 med mod med p^epsilon$, $hat(q)$ is a prime and is
  co-prime with $q_l$, and $p^epsilon < hat(q) < q_l$.

  $$

+ #strong[#underline[Constant multiplication]] by $p^(epsilon - 1)$ to
  the coefficients of the ciphertext polynomials $\(hat(A)\,hat(B)\)$,
  which increases the underlying plaintext's noise scaling factor
  $Delta$ and the plaintext modulus from $p arrow.r p^epsilon$. This
  effectively updates the underlying plaintext to
  $p^(epsilon - 1) M + p^epsilon E$.

  $$

+ #strong[#underline[ModRaise#sub[RNS]]] from $hat(q) arrow.r q_L$,
  which generates additional noise $\|u dot.op hat(q)\|_(q_L)$ (where
  $u in { - 1\,0\,1 }$ using SmallMont). At this point, the ciphertext
  is
  $sans("RLWE")_(S\,sigma)\(p^(epsilon - 1) M + p^epsilon E + hat(q) K\)med mod med q_L$,
  whose underlying plaintext is:

  $p^(epsilon - 1) M + p^epsilon E + hat(q) K$

  $= p^(epsilon - 1) M + K med mod med p^epsilon$ $gt.tri$ since
  $hat(q) equiv 1 med mod med p^epsilon$

$$

After the above steps, the remaining steps (i.e., CoeffToSlot, EvalExp,
homomorphic multiplication by $\|p^(-\(epsilon - 1\))\|_(q^(l'))$,
SlotToCoeff, and re-interpretation) can be performed using regular
RNS-based addition and multiplication operations.

=== Noise Impact of RNS Operations
<subsubsec:rns-noise>
When RNS techniques are used in FHE operations, the noise generated by
FastBConv, ModRaise#sub[RNS], and ModSwitch#sub[RNS] is directly added
to each coefficient of the ciphertext polynomials $A$ and $B$. Since the
decryption relation is $A dot.op S + B$, even the noise added to the
coefficients of the polynomial $A$ is multiplied by a large factor due
to the polynomial multiplication with $S$. Therefore, it is important to
always ensure that the generated noise of each FastBConvEx#sub[RNS] is
reduced by using it with SmallMont.

=== Python Source Code of RNS Primitives
<subsubsec:rns-source-code>
We provide a
#link("https://github.com/fhetextbook/fhe-textbook/blob/main/source%20code/rns.py")[#underline[Python script]]
implementing the following exemplary RNS primitives: FastBConv,
ModRaise#sub[RNS], ModDrop#sub[RNS], ModSwitch#sub[RNS], SmallMont, and
FastBConvEx.
