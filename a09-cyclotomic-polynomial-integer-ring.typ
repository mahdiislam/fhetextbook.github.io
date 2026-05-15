In #link(<sec:roots>)[\[sec:roots\]] and
#link(<sec:cyclotomic>)[\[sec:cyclotomic\]], we learned about the
definition and properties of the $mu$-th roots of unity and the $mu$-th
cyclotomic polynomial over complex numbers (i.e., $X in bb(C)$) as
follows:

- #strong[The $bold(mu)$-th roots of unity] are the solutions in $bb(C)$
  to the equation $X^mu = 1$. In other words, all $mu$-th roots of unity
  can be written as $X = e^(2 pi i k\/mu)$ for integers $k$ with
  $0 lt.eq k < mu$.

- #strong[The primitive $bold(mu)$-th roots of unity (denoted as
  $bold(omega)$)] are those $mu$-th roots of unity whose order
  (#link(<subsec:order-def>)[\[subsec:order-def\]]) is $mu$ (i.e.,
  $omega^mu = 1$ and $omega^d eq.not 1$ for any $1 lt.eq d < mu$ with
  $d divides mu$).

- Given any primitive $mu$-th roots of unity $omega$, one can generate
  all primitive $mu$-th roots of unity by computing $omega^(k')$ such
  that $k'$ is an integer $0 < k' < mu$ and $sans("gcd")\(k'\,mu\)= 1$
  (Theorem~@subsec:roots-theorem\.4 in
  #link(<subsec:order-theorem>)[\[subsec:order-theorem\]]).

- #strong[The $bold(mu)$-th cyclotomic polynomial] is defined as a
  polynomial whose roots are the primitive $mu$-th roots of unity. That
  is,
  $ Phi_mu\(x\)= product_(omega in P\(mu\))\(x - omega\)= product_(0 lt.eq k lt.eq mu - 1\,\
  sans("gcd")\(k\,mu\)= 1)\(x - omega^k\) $

In this section, we will explain the $mu$-th cyclotomic polynomial over
$bb(Z)_p$ (with $p$ prime), which is structured as follows:

#block[
- #strong[The $bold(mu)$-th roots of unity (denoted as $bold(omega)$)]
  are the solutions for $X^mu equiv 1 med mod med p$. Note that in
  contrast to the complex case, these solutions cannot be expressed as
  $X = e^(2 pi i k\/mu)$.

- #strong[The primitive $bold(mu)$-th roots of unity] are defined as
  those $mu$-th roots of unity whose order is $mu$ (i.e.,
  $omega^mu equiv 1 med mod med p$, and
  $omega^d equiv.not 1 med mod med p$ for any $1 lt.eq d < mu$ with
  $d divides mu$).

- Given any primitive $mu$-th roots of unity $omega$, it can generate
  all primitive $mu$-th roots of unity by computing $omega^(k')$ such
  that $k'$ is an integer $0 < k' < mu$ and $sans("gcd")\(k'\,mu\)= 1$.

- #strong[The $bold(mu)$-th cyclotomic polynomial] is defined as a
  polynomial whose roots are the primitive $mu$-th roots of unity. That
  is,
  $ Phi_mu\(x\)= product_(omega in P\(mu\))\(x - omega\)= product_(0 lt.eq k lt.eq mu - 1\,\
  sans("gcd")\(k\,mu\)= 1)\(x - omega^k\) $

]
#block[
#figure(
  align(center)[#table(
    columns: 3,
    align: (center,center,center,),
    [], [#strong[Polynomial over $bold(bb(C))$]], [#strong[Polynomial
    over $bold(bb(Z))_(bold(p))$]],
    [], [#strong[\(Complex Number)]], [#strong[\(Ring)]],
    [#strong[Definition]], [All $X in bb(C)$ such that $X^mu = 1$,
    (which are], [All $X in bb(Z)_p$ such that
    $X^mu equiv 1 med mod med p$],
    [#strong[of the]], [computed as $X = e^(2 pi i k\/mu)$ for integer
    $k$], [],
    [#strong[$bold(mu)$-th]], [where $0 lt.eq k lt.eq mu - 1$)], [],
    [#strong[Root of Unity]], [], [],
    [#strong[Definition]], [Those $mu$-th roots of unity $omega$ such
    that], [Those $mu$-th roots of unity $omega$ such that],
    [#strong[of the]], [$omega^mu = 1$, and
    $omega^d eq.not 1$], [$omega^mu equiv 1 med mod med p$, and
    $omega^d equiv.not 1 med mod med p$],
    [#strong[Primitive]], [for any $1 lt.eq d < mu$ with
    $d divides mu$], [for any $1 lt.eq d < mu$ with $d divides mu$],
    [#strong[$bold(mu)$-th]], [], [],
    [#strong[Root of]], [], [],
    [#strong[Unity]], [], [],
    [#strong[Definition]], table.cell(align: center, colspan: 2)[The
    polynomial whose roots are the $mu$-th primitive roots of unity as
    follows:],
    [#strong[of
    the]], table.cell(align: center, colspan: 2)[$Phi_mu\(x\)= product_(omega in P\(mu\))\(x - omega\)$
    (see Definition~@subsec:cyclotomic-def in
    #link(<subsec:cyclotomic-def>)[\[subsec:cyclotomic-def\]])],
    [#strong[$bold(mu)$-th]], table.cell(align: center, colspan: 2)[],
    [#strong[Cyclotomic]], table.cell(align: center, colspan: 2)[],
    [#strong[Polynomial]], table.cell(align: center, colspan: 2)[],
    [#strong[Finding]], [For $omega = e^(2 pi i\/mu)$, compute all
    $omega^k$ such that], [Find one primitive $omega$ that is a root
    of],
    [#strong[Primitive]], [$0 < k < mu$ and
    $sans("gcd")\(k\,mu\)= 1$], [the $mu$-th cyclotomic polynomial,
    and],
    [#strong[$bold(mu)$-th]], [\(Theorem~@subsec:roots-theorem\.4 in
    #link(<subsec:roots-theorem>)[\[subsec:roots-theorem\]])], [compute
    all $omega^k med mod med p$ such that],
    [#strong[Roots of]], [], [$0 < k < mu$ and
    $sans("gcd")\(k\,mu\)= 1$],
    [#strong[Unity]], [], [],
  )]
  , caption: [The roots of unity and cyclotomic polynomials over
  $X in bb(C)$ vs. over $X in bb(Z)_p$]
  , kind: table
  )

] <tab:cyclotomic-polynomial-comparison>
Note that in the $mu$-th cyclotomic polynomial, in both cases of over
$X in bb(C)$ and over $X in bb(Z)_p$, each of their roots $omega$ (i.e.,
the primitive $mu$-th root of unity) has the order $mu$ (i.e.,
$omega^mu = 1$ over $X in bb(C)$, and $omega^mu equiv 1 med mod med p$
over $X in bb(Z)_p$). Also note that each root $omega$ can generate all
roots of the $mu$-th cyclotomic polynomial by computing $omega^(k')$
such that $sans("gcd")\(k'\,mu\)= 1$.

#link(<tab:cyclotomic-polynomial-comparison>)[1] compares the properties
of the roots of unity and the $mu$-th cyclotomic polynomial over $bb(C)$
(the complex numbers) and over $bb(Z)_p$ (the ring).
