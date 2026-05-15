== Vector Arithmetic
<subsec:vector-arithmetic>
This section explains the basic arithmetic of vector and matrix
computations, as well as advanced concepts such as vector/plane
projection and the basis of planes (or spaces).

#block[
- #strong[Addition:] Given two $n times 1$ vectors (i.e.,
  $n$-dimensional vectors) composed of $n$ numbers each:

  $arrow(a) =\(a_0\,a_1\,dots.h.c\,a_(n - 1)\)$,
  $arrow(b) =\(b_0\,b_1\,dots.h.c\,b_(n - 1)\)$

  $$

  Vector addition is defined as:

  $arrow(a) + arrow(b) =\(a_0 + b_0\,upright(" ") a_1 + b_1\,upright(" ") dots.h.c\,upright(" ") a_(n - 1) + b_(n - 1)\)$

  $$

- #strong[Dot Product:] Given two $n$-dimensional vectors:

  $arrow(a) =\(a_0\,a_1\,dots.h\,a_(n - 1)\)$,
  $arrow(b) =\(b_0\,b_1\,dots.h\,b_(n - 1)\)$

  $$

  Dot product is defined as:

  $chevron.l arrow(a)\,arrow(b) chevron.r = arrow(a) dot.op arrow(b) = a_0 b_0 + a_1 b_1 + dots.h.c + a_(n - 1) b_(n - 1)$.

  $arrow(a) dot.op arrow(b)$ can also be expressed as
  $parallel arrow(a) parallel thin parallel arrow(b) parallel cos theta$,
  where $theta$ is the angle between $arrow(a)$ and $arrow(b)$. If
  $arrow(a)$ and $arrow(b)$ point in the same direction,
  $arrow(a) dot.op arrow(b)$ attains its maximum value
  ($parallel arrow(a) parallel thin parallel arrow(b) parallel$). If
  $arrow(a)$ and $arrow(b)$ are orthogonal, then
  $arrow(a) dot.op arrow(b) = 0$.

  $$

- #strong[Hadamard Product:] Given two $n$-dimensional vectors:

  $arrow(a) =\(a_0\,a_1\,dots.h\,a_(n - 1)\)$,
  $arrow(b) =\(b_0\,b_1\,dots.h\,b_(n - 1)\)$

  $$

  Hadamard product is defined as:

  $arrow(a) dot.circle arrow(b) =\(a_0 b_0\,upright(" ") a_1 b_1\,upright(" ") dots.h.c\,upright(" ") a_(n - 1) b_(n - 1)\)$

  $$

- #strong[Hermitian Product:] Given two $n$-dimensional complex vectors:

  $arrow(a) =\(a_0 + i dot.op a'_0\,upright(" ") a_1 + i dot.op a'_1\,upright(" ") dots.h\,upright(" ") a_(n - 1) + i dot.op a'_(n - 1)\)$

  $arrow(b) =\(b_0 + i dot.op b'_0\,upright(" ") b_1 + i dot.op b'_1\,upright(" ") dots.h\,upright(" ") b_(n - 1) + i dot.op b'_(n - 1)\)$

  $$

  Hermitian product is a dot product with the 2nd operand as a conjugate
  (#link(<subsec:imaginary>)[\[subsec:imaginary\]]):

  $chevron.l chevron.l arrow(a)\,arrow(b) chevron.r chevron.r = arrow(a) dot.op overline(arrow(b))$

  $=\(a_0 + i dot.op a'_0\,upright(" ") a_1 + i dot.op a'_1\,upright(" ") dots.h.c\,upright(" ") a_(n - 1) + i dot.op a'_(n - 1)\)dot.op\(b_0 - i dot.op b'_0\,upright(" ") b_1 - i dot.op b'_1\,upright(" ") dots.h.c\,upright(" ") b_(n - 1) - i dot.op b'_(n - 1)\)$

]
== Various Types of Matrix
<subsec:vandermonde>
#block[
- An $n times n$ #strong[identity matrix] and a #strong[reverse identity
  matrix] are defined as:

  $I_n = mat(delim: "[", 1, 0, 0, dots.h.c, 0; 0, 1, 0, dots.h.c, 0; 0, 0, 1, dots.h.c, 0; dots.v, dots.v, dots.v, dots.down, dots.v; 0, 0, 0, dots.h.c, 1; #none)$,
  $I_n^R = mat(delim: "[", 0, dots.h.c, 0, 0, 1; 0, dots.h.c, 0, 1, 0; 0, dots.h.c, 1, 0, 0; dots.v, dots.up, dots.v, dots.v, dots.v; 1, 0, 0, dots.h.c, 0; #none)$

  $$

- The #strong[transpose of a matrix] $X$ is defined as element-wise
  swapping along the diagonal line, denoted as $X^T$, which is:

  $X = mat(delim: "[", a_1, a_2, a_3, dots.h.c, a_n; b_1, b_2, b_3, dots.h.c, b_n; c_1, c_2, c_3, dots.h.c, c_n; dots.v, dots.v, dots.v, dots.down, dots.v; m_1, m_2, m_3, dots.h.c, m_n; #none)$,
  $X^T = mat(delim: "[", a_1, b_1, c_1, dots.h.c, m_1; a_2, b_2, c_2, dots.h.c, m_2; a_3, b_3, c_3, dots.h.c, m_3; dots.v, dots.v, dots.v, dots.down, dots.v; a_n, b_n, c_n, dots.h.c, m_n; #none)$

  $$

- A #strong[Vandermonde matrix] is an $\(m + 1\)times\(n + 1\)$ matrix
  defined as:

  $V\(x_0\,x_1\,dots.h.c\,x_m\)= mat(delim: "[", 1, x_0, x_0^2, dots.h.c, x_0^n; 1, x_1, x_1^2, dots.h.c, x_1^n; 1, x_2, x_2^2, dots.h.c, x_2^n; dots.v, dots.v, dots.v, dots.down, dots.v; 1, x_m, x_m^2, dots.h.c, x_m^n; #none)$

]
== Matrix Arithmetic
<subsec:matrix-arithmetic>
Matrix-to-vector multiplication and matrix-to-matrix multiplication are
defined as follows:

#block[
- #strong[Matrix-to-Vector Multiplication:] Given a $m times n$ matrix
  $A$ and a $n$-dimensional vector $x$:

  $A = mat(delim: "[", a_(1\,1), a_(1\,2), a_(1\,3), dots.h.c, a_(1\,n); a_(2\,1), a_(2\,2), a_(2\,3), dots.h.c, a_(2\,n); a_(3\,1), a_(3\,2), a_(3\,3), dots.h.c, a_(3\,n); dots.v, dots.v, dots.v, dots.down, dots.v; a_(m\,1), a_(m\,2), a_(m\,3), dots.h.c, a_(m\,n); #none) = mat(delim: "[", arrow(a)_(1\,*); arrow(a)_(2\,*); arrow(a)_(3\,*); dots.v; arrow(a)_(m\,*); #none)\,upright(" ") arrow(x) =\(x_1\,x_2\,dots.h.c\,x_n\)$

  $$

  The result of $A dot.op arrow(x)$ is an $m$-dimensional vector
  computed as:

  $A dot.op arrow(x) = #scale(x: 180%, y: 180%)[\(] arrow(a)_(1\,*) dot.op arrow(x)\,upright(" ") arrow(a)_(2\,*) dot.op arrow(x)\,upright(" ") dots.h.c\,upright(" ") arrow(a)_(m\,*) dot.op arrow(x) #scale(x: 180%, y: 180%)[\)] = (sum_(i = 1)^n a_(1\,i) dot.op x_i \, upright(" ") sum_(i = 1)^n a_(2\,i) dot.op x_i \, dots.h.c \, upright(" ") sum_(i = 1)^n a_(m\,i) dot.op x_i)$

  $$

- #strong[Matrix-to-Matrix Multiplication:] Given a $m times n$ matrix
  $A$ and a $n times k$ matrix $B$:

  $A = mat(delim: "[", a_(1\,1), a_(1\,2), a_(1\,3), dots.h.c, a_(1\,n); a_(2\,1), a_(2\,2), a_(2\,3), dots.h.c, a_(2\,n); a_(3\,1), a_(3\,2), a_(3\,3), dots.h.c, a_(3\,n); dots.v, dots.v, dots.v, dots.down, dots.v; a_(m\,1), a_(m\,2), a_(m\,3), dots.h.c, a_(m\,n); #none)$,
  $B = mat(delim: "[", b_(1\,1), b_(1\,2), b_(1\,3), dots.h.c, b_(1\,k); b_(2\,1), b_(2\,2), b_(2\,3), dots.h.c, b_(2\,k); b_(3\,1), b_(3\,2), b_(3\,3), dots.h.c, b_(3\,k); dots.v, dots.v, dots.v, dots.down, dots.v; b_(n\,1), b_(n\,2), b_(n\,3), dots.h.c, b_(n\,k); #none)$

  $$

  The result of $A dot.op B$ is a $m times k$ matrix computed as:

  $A dot.op B = mat(delim: "[", sum_(i = 1)^n a_(1\,i) b_(i\,1), sum_(i = 1)^n a_(1\,i) b_(i\,2), sum_(i = 1)^n a_(1\,i) b_(i\,3), dots.h.c, sum_(i = 1)^n a_(1\,i) b_(i\,k); sum_(i = 1)^n a_(2\,i) b_(i\,1), sum_(i = 1)^n a_(2\,i) b_(i\,2), sum_(i = 1)^n a_(2\,i) b_(i\,3), dots.h.c, sum_(i = 1)^n a_(2\,i) b_(i\,k); sum_(i = 1)^n a_(3\,i) b_(i\,1), sum_(i = 1)^n a_(3\,i) b_(i\,2), sum_(i = 1)^n a_(3\,i) b_(i\,3), dots.h.c, sum_(i = 1)^n a_(3\,i) b_(i\,k); dots.v, dots.v, dots.v, dots.down, dots.v; sum_(i = 1)^n a_(m\,i) b_(i\,1), sum_(i = 1)^n a_(m\,i) b_(i\,2), sum_(i = 1)^n a_(m\,i) b_(i\,3), dots.h.c, sum_(i = 1)^n a_(m\,i) b_(i\,k); #none)$

]
Given the above definitions of matrix and vector arithmetic, the
following algebraic properties can be derived:

#block[
- #strong[Associative:]

  $\(A B\)C = A\(B C\)$

  $A\(B x\)=\(A B\)x$

  $$

- #strong[Distributive:]

  $A\(x + y\)= A x + A y$

  $$

  However, $A x dot.op A y eq.not A\(x dot.op y\)$, because the
  resulting dimensions do not match. Also,
  $A\(x dot.circle y\)eq.not A x dot.circle A y$. Further, note that
  $A chevron.l x\,y chevron.r eq.not chevron.l A x\,A y chevron.r$, and
  $A chevron.l chevron.l x\,y chevron.r chevron.r eq.not chevron.l chevron.l A x\,A y chevron.r chevron.r$.

  $$

- #strong[NOT Commutative:]

  $A x eq.not x A$

  $A B eq.not B A$

]
#block[
#emph[Proof.] $$

The properties described in @subsec:matrix-arithmetic can be
demonstrated by expanding the formulas on both sides of each equation
using a variable representation for each element in the vectors/matrices
and comparing the resulting formulas. We leave this expansion as an
exercise for the reader.~◻

]
== Projection
<subsec:projection>
There are two types of projections: a vector projection and an
orthogonal (i.e., plane) projection.

#figure([],
  caption: [
  ]
)

Given two vectors $arrow(a)$ and $arrow(b)$ in the same $n$-dimensional
vector space, the vector projection
$sans("Proj")_(arrow(b))\(arrow(a)\)$ measures the component of
$arrow(a)$ in the direction of $arrow(b)$ (i.e., the part of $arrow(a)$
that is parallel to $arrow(b)$). In the example of
#link(<fig:vector-projection>)[\[fig:vector-projection\]], $arrow(a)$'s
projection on $arrow(b)$ is $arrow(a)_1$, where the length of
$arrow(a)_1$ is geometrically
$\|\|a_1\|\|=\|\|a\|\|cos theta =\|\|a\|\|frac(a dot.op b, \|\|a\|\|dot.op\|\|b\|\|) = frac(a dot.op b, \|\|b\|\|)$.
Let $arrow(b')$ be a unit vector of $arrow(b)$, that is
$arrow(b') = frac(arrow(b), \|\|b\|\|)$. Then,
$arrow(a)_1 =\|\|a_1\|\|dot.op arrow(b') = frac(a dot.op b, \|\|b\|\|) dot.op frac(arrow(b), \|\|b\|\|) = frac(a dot.op b, \|\|b\|\|^2) arrow(b)$.
Thus,
$sans("Proj")_(arrow(b))\(arrow(a)\)= frac(a dot.op b, \|\|b\|\|^2) arrow(b)$.

Given the vector $arrow(x)$ and a set of mutually orthogonal vectors
$arrow(p)_0\,arrow(p)_1\,dots.h.c\,arrow(p)_(n - 1)$ that span the
subspace $P$, the orthogonal projection $sans("Proj")_P\(arrow(x)\)$
measures how much of $arrow(x)$ lies in $P$ (i.e., the component of
$arrow(x)$ within $P$). In the example, $arrow(x)$'s projection onto $P$
(red arrow) equals the sum of the projections of $arrow(x)$ onto each
orthogonal basis vector $arrow(p)_i$ spanning $P$:
$sans("Proj")_P\(arrow(x)\)= sum_(i = 0)^(n - 1) sans("Proj")_(arrow(p)_i)\(arrow(x)\)$.
This computation can be viewed as expressing $arrow(x)$ in a coordinate
system defined by the $n$ orthogonal vectors.

#block[
- #strong[Vector Projection:] Given two vectors $arrow(a)$ and
  $arrow(b)$ in the same vector space, the vector projection of
  $arrow(a)$ on $arrow(b)$ is:

  $sans("Proj")_(arrow(b))\(arrow(a)\)= arrow(a)_p = frac(arrow(a) dot.op arrow(b), \|\|b\|\|^2) arrow(b)$
  $gt.tri$ where $\|\|arrow(a)_p\|\|=\|\|arrow(a)\|\|cos theta$

  $$

- #strong[Orthogonal Basis:] If the $n$-dimensional plane (or subspace)
  $P$ is spanned by the mutually orthogonal $n$-dimensional vectors
  $arrow(p)_0\,arrow(p)_1\,dots.h.c\,arrow(p)_(n - 1)$,

  then the matrix
  $P = mat(delim: "[", arrow(p)_0; arrow(p)_1; dots.v; arrow(p)_(n - 1); #none)$
  is defined to be an orthogonal basis of plane $P$.

- #strong[Orthogonal Projection:] Given the orthogonal basis matrix
  $P = mat(delim: "[", arrow(p)_0; arrow(p)_1; dots.v; arrow(p)_(n - 1); #none)$,

  vector $arrow(a)$'s orthogonal projection on $P$ is:

  $sans("Proj")_P\(arrow(a)\)= sum_(i = 0)^(n - 1) sans("Proj")_(arrow(p)_i)\(arrow(a)\)$

]
Based on the definition of orthogonal projection, the following
properties are derived:

In an $n$-dimensional vector space, any mutually orthogonal $n$ vectors
in the vector space span the subspace $P$ that is identical to the
entire vector space. Further, the orthogonal projection of any vector in
the vector space on $P$ is guaranteed to be a unique vector.

In an $n$-dimensional vector space, suppose some $n$ non-orthogonal
vectors satisfy the following two conditions: (i) they span the entire
vector space; (ii) they are linearly independent (i.e., one vector
cannot be expressed as a linear combination of the other vectors). Then,
the $n times n$ matrix $P$ comprised of these $n$ vectors forms a basis
for the entire vector space $V$, and the matrix-to-vector multiplication
$P arrow(v)$ for each $arrow(v)$ in the vector space is guaranteed to
yield a unique vector. However, the formula $sans("Proj")_P\(arrow(v)\)$
is not a valid geometric projection of the vector $arrow(v)$ on $P$,
because the $n$ basis vectors are non-orthogonal. Yet, the computation
of $P arrow(v)$ can be thought of as uniquely transforming $arrow(v)$
into a different coordinate system that expresses the vector space with
respect to $n$ non-orthogonal vectors in $P$.

#block[
- #strong[Orthogonal Basis:] If some $n$ vectors are a orthogonal basis
  of the plane $P$ in the $n$-dimensional vector space, then $P$ is the
  same as the entire vector space, and $sans("Proj")_P\(v\)$ for every
  vector $arrow(v)$ in the vector space is guaranteed to be a unique
  vector.

- #strong[Non-orthogonal Basis:] If some $n$ vectors are a
  non-orthogonal basis of the plane $P$ in the $n$-dimensional vector
  space (i.e., each vector is linearly independent and they span $P$),
  then $P$ is the same as the entire vector space, and $P arrow(v)$ is
  guaranteed to result in a unique vector.

]
== Basis of a Polynomial Ring
<subsec:polynomial-ring-basis>
Given an $\(n - 1\)$-degree polynomial ring $bb(Z)\[X\]\/\(X^n + 1\)$, a
basis of the polynomial ring is defined as a set of polynomials that
satisfies the following two requirements:

- #strong[Linear Independence]: Each polynomial in the basis set cannot
  be expressed as a linear combination of the other polynomials in the
  same set

- #strong[Spanning the Polynomial Ring:] A linear combination of the
  polynomials in the basis set can express any polynomial in the
  polynomial ring

Note that for a $\(n - 1\)$-degree polynomial ring, the number of
polynomials that form a basis of the polynomial ring is exactly $n$.

== Isomorphism between Polynomials and Vectors over Integers
<subsec:poly-vector-transformation>
Now, let's define a mapping $sigma$ from the $\(n - 1\)$-degree
polynomial ring to the $n$-dimensional vector space, such that an input
polynomial's list of $y$ values evaluated at $n$ distinct $x in bb(Z)$
coordinates (e.g., $x_0\,x_1\,dots.h.c\,x_(n - 1)$) forms the mapping's
output vector. Technically, $sigma$ is defined as:

$sigma : f\(x\)in bb(Z)\[X\]\/\(X^n + 1\)upright(" ") arrow.r upright(" ")\(f\(x_0\)\,f\(x_1\)\,f\(x_2\)\,dots.h.c\,f\(x_(n - 1)\)\)in bb(Z)^n$

Now, we will explain why the mapping $sigma$ is isomorphic, which means
that $sigma$ is a bijective one-to-one mapping from
$bb(Z)\[X\]\/\(X^n + 1\)$ to $bb(Z)^n$, and it preserves the algebraic
operations $\(+\,dot.op\)$ (i.e., $sigma$ is a homomorphism for addition
and multiplication).

$$

In the $\(n - 1\)$-degree polynomial ring, a list of $y$ values
evaluated at some statically chosen $n$ distinct $x$ coordinates defines
a unique polynomial because, algebraically, there exists only one
$\(n - 1\)$-degree (or a lesser degree) polynomial that passes through
each given set of $n$ distinct $\(x\,y\)$ coordinates. We proved this in
Lagrange Polynomial Interpolation (Theorem~@sec:polynomial-interpolation
in
#link(<sec:polynomial-interpolation>)[\[sec:polynomial-interpolation\]]).

$$

The homomorphism of the mapping $sigma$ on the $\(+\,dot.op\)$
operations means that the following two relationships hold:

$sigma\(f_a\(X\)+ f_b\(X\)\)= sigma\(f_a\(X\)\)+ sigma\(f_b\(X\)\)$

$sigma\(f_a\(X\)dot.op f_b\(X\)\)= sigma\(f_a\(X\)\)dot.circle sigma\(f_b\(X\)\)$
\# $dot.circle$ is Hadamard vector multiplication
(Summary~@subsec:vector-arithmetic)

$$

To prove our $sigma$ mapping's homomorphism, let's denote the input
polynomials $f_a\(X\)$, $f_b\(X\)$, and their $sigma$-mapped output
vectors as follows:

$f_a\(X\)= a_0 + a_1 X + a_2 X^2 + dots.h.c + a_(n - 1) X^(n - 1)$

$sigma\(f_a\(X\)\)= (f_a\(x_0\) \, f_a\(x_1\) \, f_a\(x_2\) \, dots.h.c \, f_a\(x_(n - 1) \)) = (sum_(i = 0)^(n - 1) a_i \( x_0 \)^i \, sum_(i = 0)^(n - 1) a_i \( x_1 \)^i \, sum_(i = 0)^(n - 1) a_i \( x_2 \)^i \, dots.h.c \, sum_(i = 0)^(n - 1) a_i \( x_(n - 1) \)^i)$

$$

$f_b\(X\)= b_0 + b_1 X + b_2 X^2 + dots.h.c + b_(n - 1) X^(n - 1)$

$sigma\(f_b\(X\)\)= (f_b\(x_0\) \, f_b\(x_1\) \, f_b\(x_2\) \, dots.h.c \, f_b\(x_(n - 1) \)) = (sum_(i = 0)^(n - 1) b_i \( x_0 \)^i \, sum_(i = 0)^(n - 1) b_i \( x_1 \)^i \, sum_(i = 0)^(n - 1) b_i \( x_2 \)^i \, dots.h.c \, sum_(i = 0)^(n - 1) b_i \( x_(n - 1) \)^i)$

$$

Given the above setup, we can see that $sigma$ preserves homomorphism on
the $\(+\)$ operation as follows:

$bold(sigma) bold(\() f_a\(X\)+ f_b\(X\)bold(\)) = bold(sigma #scale(x: 240%, y: 240%)[\(])\(a_0 + b_0\)+\(a_1 + b_1\)X +\(a_2 + b_2\)X^2 + dots.h.c +\(a_(n - 1) + b_(n - 1)\)X^(n - 1) bold(#scale(x: 240%, y: 240%)[\)])$

$= (sum_(i = 0)^(n - 1) \( a_i + b_i \) \( x_0 \)^i \, upright(" ") sum_(i = 0)^(n - 1) \( a_i + b_i \) \( x_1 \)^i \, upright(" ") sum_(i = 0)^(n - 1) \( a_i + b_i \) \( x_2 \)^i \, dots.h.c \, upright(" ") sum_(i = 0)^(n - 1) \( a_i + b_i \) \( x_(n - 1) \)^i)$

$= (sum_(i = 0)^(n - 1) a_i \( x_0 \)^i \, upright(" ") sum_(i = 0)^(n - 1) a_i \( x_1 \)^i \, upright(" ") sum_(i = 0)^(n - 1) a_i \( x_2 \)^i \, dots.h.c \, upright(" ") sum_(i = 0)^(n - 1) a_i \( x_(n - 1) \)^i)$

$+ (sum_(i = 0)^(n - 1) b_i \( x_0 \)^i \, upright(" ") sum_(i = 0)^(n - 1) b_i \( x_1 \)^i \, upright(" ") sum_(i = 0)^(n - 1) b_i \( x_2 \)^i \, dots.h.c \, upright(" ") sum_(i = 0)^(n - 1) b_i \( x_(n - 1) \)^i)$

$= bold(sigma\() f_a\(X\)bold(\)) + bold(sigma\() f_b\(X\)bold(\))$

$$

Also, we can see that $sigma$ preserves homomorphism on the $\(dot.op\)$
operation as follows:

$bold(sigma\() f_a\(X\)dot.op f_b\(X\)bold(\)) = bold(sigma #scale(x: 240%, y: 240%)[\(]) (sum_(i = 0)^(n - 1) a_i X^i) dot.op (sum_(i = 0)^(n - 1) b_i X^i) bold(#scale(x: 240%, y: 240%)[\)])$

$$

$= #scale(x: 300%, y: 300%)[\(] (sum_(i = 0)^(n - 1) a_i x_0^i) (sum_(i = 0)^(n - 1) b_i x_0^i)\,upright(" ") (sum_(i = 0)^(n - 1) a_i x_1^i) (sum_(i = 0)^(n - 1) b_i x_1^i)\,upright(" ") (sum_(i = 0)^(n - 1) a_i x_2^i) (sum_(i = 0)^(n - 1) b_i x_2^i)\,$

$upright(" ") upright(" ") upright(" ") upright(" ") upright(" ") upright(" ") dots.h.c\,(sum_(i = 0)^(n - 1) a_i x_(n - 1)^i) (sum_(i = 0)^(n - 1) b_i x_(n - 1)^i) #scale(x: 300%, y: 300%)[\)]$

$$

$= #scale(x: 300%, y: 300%)[\(] sum_(i = 0)^(n - 1) a_i\(x_0\)^i\,upright(" ") sum_(i = 0)^(n - 1) a_i\(x_1\)^i\,upright(" ") dots.h.c\,upright(" ") sum_(i = 0)^(n - 1) a_i\(x_(n - 1)\)^i#scale(x: 300%, y: 300%)[\)]$

$upright(" ") upright(" ") upright(" ") upright(" ") dot.circle #scale(x: 300%, y: 300%)[\(] sum_(i = 0)^(n - 1) b_i\(x_0\)^i\,upright(" ") sum_(i = 0)^(n - 1) b_i\(x_1\)^i\,upright(" ") dots.h.c\,upright(" ") sum_(i = 0)^(n - 1) b_i\(x_(n - 1)\)^i#scale(x: 300%, y: 300%)[\)]$

$$

$= bold(sigma\() f_a\(X\)bold(\)) dot.circle bold(sigma\() f_b\(X\)bold(\))$

$$

In summary, $sigma$ preserves the following homomorphism:

$sigma\(f_a\(X\)+ f_b\(X\)\)= sigma\(f_a\(X\)\)+ sigma\(f_b\(X\)\)$

$sigma\(f_a\(X\)dot.op f_b\(X\)\)= sigma\(f_a\(X\)\)dot.circle sigma\(f_b\(X\)\)$

$$

However, for
$sigma\(f_a\(X\)dot.op f_b\(X\)\)= sigma\(f_a\(X\)\)dot.circle sigma\(f_b\(X\)\)$,
we need further reasoning to justify that this relation holds in
polynomial rings, which is explained below.

Suppose that we did not have the polynomial ring setup $X^n + 1$. Then,
if we multiply $f_a\(X\)$ and $f_b\(X\)$, then $f_a\(X\)dot.op f_b\(X\)$
may become a new polynomial whose degree is higher than $n - 1$. This
higher-degree polynomial would still decode into the expected correct
vector. Suppose the following:

$sigma\(f_a\(X\)\)=\(f_a\(x_0\)\,f_a\(x_1\)\,dots.h.c\,f_a\(x_(n - 1)\)\)=\(v_0\,v_1\,dots.h.c\,v_(n - 1)\)$

$sigma\(f_b\(X\)\)=\(f_b\(x_0\)\,f_b\(x_1\)\,dots.h.c\,f_b\(x_(n - 1)\)\)=\(u_0\,u_1\,dots.h.c\,u_(n - 1)\)$

$$

Then, the following is true:

$sigma\(f_a\(X\)dot.op f_b\(X\)\)=\(f_a\(x_0\)dot.op f_b\(x_0\)\,f_a\(x_1\)dot.op f_b\(x_1\)\,dots.h.c\,f_a\(x_(n - 1)\)dot.op f_b\(x_(n - 1)\)\)=\(v_0 u_0\,v_1 u_1\,dots.h.c\,v_(n - 1) u_(n - 1)\)$

$=\(v_0\,v_1\,dots.h.c\,v_(n - 1)\)dot.circle\(u_0\,u_1\,dots.h.c\,u_(n - 1)\)$

$$

As shown above, even if $f_a\(X\)dot.op f_b\(X\)$ results in a
polynomial with a degree higher than $n - 1$, it can be decoded into the
expected correct vector. However, the $sigma$ mapping loses the property
of isomorphism between a polynomial and a vector because if a
polynomial's degree is higher than $n - 1$, then there can be more than
1 polynomial that passes through the given $n$ distinct $X$ coordinates:
${ x_0\,x_1\,dots.h.c\,x_(n - 1) }$. This is a problem because, if the
$sigma$ mapping supports only polynomial-to-vector mappings and not
vector-to-polynomial mappings, then we cannot convert vectors into
polynomials in the first place and do isomorphic computations. Another
minor issue is that if the polynomial degree term is higher than
$n - 1$, then the computational overhead of decoding (i.e., polynomial
evaluation) becomes larger than before.

To resolve these two minor issues, we let the $n$ distinct $X$
coordinates of evaluation be the solutions of the polynomial ring modulo
$X^n + 1$ (where $n$ is some power of 2) and reduce
$f_a\(X\)dot.op f_b\(X\)$ to a new polynomial modulo $X^n + 1$ whose
degree is at most $n - 1$. Let $f_(a b)\(X\)= f_a\(X\)dot.op f_b\(X\)$,
and $f'_(a b)\(X\)$ be the reduced polynomial such that
$f_(a b)\(X\)= Q\(X\)dot.op\(X^n + 1\)+ f'_(a b)\(X\)$ for some quotient
polynomial $Q\(X\)$. Then, as illustrated in Summary
@subsubsec:polynomial-ring-discuss
(#link(<subsubsec:polynomial-ring-discuss>)[\[subsubsec:polynomial-ring-discuss\]]),
$f_(a b)\(X\)$ and $f'_(a b)\(X\)$ evaluate to the same value if they
are evaluated at the roots of $X^n + 1$ (by zeroing out the $Q\(X\)$
term). Therefore, if we let the $n$ distinct evaluating points
${ x_0\,x_1\,dots.h.c\,x_(n - 1) }$ be the roots of $X^n + 1$, then we
can ensure that the decoded vector of $f'_(a b)\(X\)$ is identical to
that of $f_(a b)\(X\)$, which we expect. Therefore, we can replace the
higher-degree polynomial $f_(a b)\(X\)$ with the reduced polynomial
$f'_(a b)\(X\)$ and continue with any further polynomial additions or
multiplications using $f'_(a b)\(X\)$. Also, by applying polynomial ring
reduction, we can enhance the computational efficiency of polynomial
addition and multiplication, as well as preserve the isomorphism of the
$sigma$ mapping. Therefore, we can freely convert between vectors &
polynomials and perform additions and multiplications.

For applying this polynomial ring reduction, the polynomial modulus can
be any polynomial as long as it has at least $n$ distinct roots. In
practice, we often choose $X^n + 1$ as the polynomial ring modulus,
which is the $\(mu = 2 n\)$-th cyclotomic polynomial
(#link(<subsec:cyclotomic-def>)[\[subsec:cyclotomic-def\]]). The reason
we let the polynomial ring modulus be a cyclotomic polynomial
(especially the $\(mu = 2 n\)$-th cyclotomic polynomial, $X^n + 1$) is
that its $n$ distinct roots are well-defined (i.e., primitive
$\(mu = 2 n\)$-th roots of unity) and thus can be quickly computed even
when $n$ is large.

$$

In addition, we often reduce the polynomial coefficients based on some
modulus $t$ to keep the size of the coefficients lower than a certain
limit for the purpose of computational efficiency. Suppose two
polynomials $f_c\(X\)$ and $f_d\(X\)$ have congruent coefficients modulo
$t$ as follows:

$f_c\(X\)= w_0 + w_1 dot.op x_i + w_2 dot.op x_i^2 + dots.h.c + w_(n - 1) dot.op x_i^(n - 1)$

$f_d\(X\)= w'_0 + w'_1 dot.op x_i + w'_2 dot.op x_i^2 + dots.h.c + w'_(n - 1) dot.op x_i^(n - 1)$

$w_i equiv w'_i med mod med t$

$$

Then, their evaluated value $f_c\(x_i\)$ and $f_d\(x_i\)$ for any $x_i$
is guaranteed to be congruent modulo $t$, as shown below:

$f_c\(x_i\)= w_0 + w_1 dot.op x_i + w_2 dot.op x_i^2 + dots.h.c + w_(n - 1) dot.op x_i^(n - 1)$

$equiv\(w_0 + w_1 dot.op x_i + w_2 dot.op x_i^2 + dots.h.c + w_(n - 1) dot.op x_i^(n - 1)\)med mod med t$

$equiv\(w_0 med mod med t\)+\(w_1 med mod med t\)dot.op x_i +\(w_2 med mod med t\)dot.op x_i^2 + dots.h.c +\(w_(n - 1) med mod med t\)dot.op x_i^(n - 1)\)$

$equiv w'_0 + w'_1 dot.op x_i + w'_2 dot.op x_i^2 + dots.h.c + w'_(n - 1) dot.op x_i^(n - 1)$

$= f_d\(x_i\)$

Since $sigma$ is bijective and homomorphic, $sigma$ is an isomorphic
mapping between the $\(n - 1\)$-degree polynomial ring
$bb(Z)_t\[X\]\/X^n + 1$ and the $n$-dimensional vector space
$bb(Z)_t^n$.

$$

=== Finding Appropriate Modulus $t$
<subsubsec:poly-vector-transformation-modulus>
To isomorphically evaluate a polynomial in $bb(Z)_t\[X\]\/X^n + 1$ into
an $n$-dimensional vector, we need to evaluate the polynomial at $n$
distinct roots of $X^n + 1 med mod med t$. However,
$X^n + 1 med mod med t$ does not have $n$ distinct roots for all
combinations of (degree, modulus) $=\(n\,t\)$. For example, if $n = 2$
and $t = 3$, then $X^2 + 1 equiv.not 0 med mod med 3$ for any possible
values of $X = { 0\,1\,2 }$. Therefore, our goal is to find a
satisfactory $t$ given a fixed $n$ such that $n$ distinct roots of
$X^n + 1 med\(mod med t\)$ exist in order to use the isomorphic $sigma$
mapping.

We start with two constraints: (1) choose $t$ to be a prime number; (2)
ensure $t - 1$ is a multiple of $2 n$.

We learned from Fermat's Little Theorem in
Theorem~@subsec:order-theorem\.4
(#link(<subsec:order-theorem>)[\[subsec:order-theorem\]]) the following:
$a^(t - 1) equiv 1 med mod med t$ if and only if $a$ and $t$ are
co-prime. This means that if $t$ is a prime, then
$a^(t - 1) equiv 1 med mod med t$ for all $a in bb(Z)_t^times$ (i.e.,
$bb(Z)_t$ without ${ 0 }$). Suppose $g$ is the generator of
$bb(Z)_t^times$ whose powered values generate all elements of
$bb(Z)_t^times$. Then, $sans("Ord")_(bb(Z)_t)\(g\)= t - 1$ and
$g^(t - 1) equiv 1 med mod med t$. Since $t - 1 = k dot.op 2 n$ for some
$k$, $g^(k dot.op 2 n) equiv\(g^k\)^(2 n)equiv 1 med mod med t$. Then,
$sans("Ord")_(bb(Z)_t)\(g^k\)lt.eq 2 n$. However, since
$sans("Ord")_(bb(Z)_t)\(g\)= t - 1$, for all $a$ such that
$a < t - 1 = k dot.op 2 n$, $g^a equiv.not 1 med mod med t$. In other
words, for all $b$ such that $b < 2 n$,
$\(g^k\)^bequiv.not 1 med mod med t$. Thus,
$sans("Ord")_(bb(Z)_t)\(g^k\)= 2 n$.

Let $c = g^k$. Since $sans("Ord")_(bb(Z)_t)\(c\)= 2 n$,
$c^(2 n) equiv 1 med mod med t$. In other words,
$\(c^n\)^2equiv 1 med mod med t$. Now, $c^n$ can be only 1 or -1. The
reason is that in the relation $X^2 equiv 1 med mod med t$, $X$ can be
mathematically only $1$ or $- 1 equiv t - 1 med mod med t$. If we
substitute $X = c^n$, then $c^n$ can be only $1$ or
$- 1 equiv t - 1 med mod med t$. But $sans("Ord")_(bb(Z)_t)\(c\)= 2 n$,
thus $c^n$ cannot be 1 (because $1^1 = 1$ and 1 is smaller than the
order of $c$: $2 n > 1$). Thus, $c^n$ can be only
$- 1 equiv t - 1 med mod med t$. If
$c^n = - 1 equiv t - 1 med mod med t$, then $c$ is the root of
$X^n + 1 med mod med t$, because
$X^n + 1 = c^n + 1 equiv\(t - 1\)+ 1 equiv 0 med mod med t$.

In conclusion, given a cyclotomic polynomial $X^n + 1$, if we choose a
prime $t$ such that $t - 1 = k dot.op 2 n$ for some integer $k$, then
one root of $X^n + 1 med mod med t$ is: $X = c = g^k$.

Once we have found one root of $X^n + 1$, then we can derive all $n$
distinct roots of $X^n + 1$. Suppose $omega$ is one root of
$X^n + 1 med mod med t$. Then we derive the following:

$omega^n + 1 equiv 0 med mod med t$

$omega^n equiv t - 1 med mod med t$

$omega^(2 n) equiv\(t - 1\)dot.op\(t - 1\)equiv t^2 - 2 t + 1 equiv 1 med mod med t$

While $omega^(2 n) equiv 1 med mod med t$,
$omega^n equiv.not 1 med mod med t$, because if so,
$X^n + 1 = omega^n + 1 = 1 + 1 = 2 eq.not 0$, which contradicts the fact
that $omega$ is a root of $X^n + 1$. Therefore,
$sans("Ord")_(bb(Z)_t)\(c\)= 2 n$.

Now, we derive the remaining $n - 1$ distinct roots of
$X^n + 1 med mod med t$ as follows:

$\(omega^3\)^n+ 1 equiv\(omega^(2 n)\)dot.op omega^n + 1 equiv omega^n + 1 equiv t - 1 + 1 equiv 0 med mod med t$

$\(omega^5\)^n+ 1 equiv\(omega^(4 n)\)dot.op omega^n + 1 equiv omega^n + 1 equiv t - 1 + 1 equiv 0 med mod med t$

$dots.v$

$\(omega^(2 n - 1)\)^n+ 1 equiv 0 med mod med t$ \ $gt.tri$ for any odd
$k = 2 j + 1$,
$\(omega^(2 j + 1)\)^n=\(omega^(2 n)\)^jdot.op omega^n = 1^j dot.op\(- 1\)= - 1$,
so $\(omega^k\)^n+ 1 = 0$

$$

Note that $omega\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 1)$ are all
distinct values in $bb(Z)_t^times$, because
$sans("Ord")_(bb(Z)_t)\(c\)= 2 n$. Thus,
${ omega^(2 i + 1) }_(i = 0)^(n - 1)$ are $n$ distinct roots of
$X^n + 1$. At the same time, since these are the roots of the cyclotomic
polynomial $X^n + 1$, these are $n$ distinct primitive $\(mu = 2 n\)$-th
roots of unity.

$$

We summarize our findings as follows:

#block[
- Suppose we have an $\(n - 1\)$-degree polynomial ring
  $bb(Z)_t\[X\]\/F\(X\)$ where $F\(X\)$ is an $n$-degree polynomial
  having $n$ distinct roots ${ x_0\,dots.h.c\,x_(n - 1) }$, and an
  $n$-dimensional vector space $bb(Z)_t^n$ (integers mod $t$) with
  vector $arrow(v)$.

  $sigma : f\(x\)in bb(Z)_t\[X\]\/F\(X\)upright(" ") arrow.r upright(" ")\(f\(x_0\)\,f\(x_1\)\,f\(x_2\)\,dots.h.c\,f\(x_(n - 1)\)\)in bb(Z)_t^n$

  $$

  Then, $sigma$ preserves isomorphism over the $\(+\,dot.op\)$
  operations:

  $sigma\(f_a\(X\)+ f_b\(X\)\)= sigma\(f_a\(X\)\)+ sigma\(f_b\(X\)\)$

  $sigma\(f_a\(X\)dot.op f_b\(X\)\)= sigma\(f_a\(X\)\)dot.circle sigma\(f_b\(X\)\)$

  $$

- Suppose we have the $\(mu = 2 n\)$-th cyclotomic polynomial
  $X^n + 1 med mod med t$ such that $t$ is a prime and $t - 1$ is some
  multiple of $2 n$, and $g$ is a generator of $bb(Z)_t^times$. Then,
  $n$ distinct roots of $X^n + 1$ (i.e., primitive $\(mu = 2 n\)$-th
  roots of unity) can be efficiently computed as:
  ${ omega^(2 i + 1) }_(i = 0)^(n - 1)$ where
  $omega = g^(frac(t - 1, 2 n)) med mod med t$.

]
== Isomorphism between Polynomials and Vectors over Complex Numbers
<subsec:poly-vector-transformation-complex>
In Theorem~@subsec:polynomial-ring-basis
(#link(<subsec:polynomial-ring-basis>)[0.5]), we learned the isomorphic
mapping
$sigma : f\(X\)in bb(Z)_t\[X\]\/\(X^n + 1\)arrow.r\(f\(x_0\)\,f\(x_1\)\,f\(x_2\)\,dots.h.c\,f\(x_(n - 1)\)\)in bb(Z)_t^n$,
where $x_0\,x_1\,x_2\,dots.h.c\,x_(n - 1) in bb(Z)$ are the
($\(mu = 2 n\)$-th primitive) roots of the cyclotomic polynomial
$X^n + 1$, which are
$omega\,omega^3\,omega^5\,dots.h.c\,omega^(2 n - 1)$, where $omega$ can
be any root of $X^n + 1$ (i.e., since each $omega$ is a generator of all
roots). In this subsection, we will demonstrate the isomorphism between
a vector space and a polynomial ring over complex numbers as follows:

$sigma_c : f\(X\)in bb(R)\[X\]\/\(X^n + 1\)arrow.r\(f\(omega\)\,f\(omega^3\)\,f\(omega^5\)\,dots.h.c\,f\(omega^(2 n - 1)\)\)in bb(hat(C))^n$

$$

, where $X in bb(C)$, and $omega = e^(i pi\/n)$, the root (i.e., the
primitive $\(mu = 2 n\)$-th root) of the cyclotomic polynomial $X^n + 1$
over complex numbers (Theorem~@subsec:cyclotomic-theorem\.1 in
#link(<subsec:cyclotomic-theorem>)[\[subsec:cyclotomic-theorem\]]). We
define $bb(hat(C))^n$ to be an $n$-dimensional #emph[special] vector
space whose second-half elements of each vector are reverse-ordered
conjugates of the first-half elements (e.g.,
$\(v_0\,v_1\,dots.h.c\,v_(n / 2 - 1)\,overline(v)_(n / 2 - 1)\,dots.h.c\,overline(v)_1\,overline(v)_0\)$).

=== Isomorphism between $bb(C)^(n / 2)$ and $bb(hat(C))^n$
<subsec:poly-vector-transformation-complex-isomorphism1>
Technically, $bb(hat(C))^n$ is bijective to $bb(C)^(n / 2)$, because the
second-half $n / 2$ elements of each vector in $bb(hat(C))^n$ are
passively (automatically) determined by the first-half $n / 2$ elements.
Therefore, each vector in $bb(hat(C))^n$ has one-to-one correspondences
with some unique vector in $bb(C)^(n / 2)$, and thus these two vector
spaces are bijective.

To demonstrate their homomorphism over the $\(+\,dot.circle\)$
operations, we can apply the following reasoning: for all
$arrow(hat(v)) in bb(hat(C))^n$ and $arrow(v) in bb(C)^(n / 2)$, there
exists an $n / 2 times n$ linear transformation matrix $M$ that
satisfies $M dot.op arrow(hat(v)) = arrow(v)$. Such $M$ is an
$n / 2 times n$ matrix comprising horizontal concatenation of
$I_(n / 2)$ and $\[0\]_(n / 2)$, where $I_(n / 2)$ is an
$n / 2 times n / 2$ identity matrix and $\[0\]_(n / 2)$ is an
$n / 2 times n / 2$ zero matrix. Also, there exists an $n times n / 2$
(non-linear) transformation matrix $N$ that satisfies
$N dot.op arrow(v) = arrow(hat(v))$. Such $N$ is a vertical
concatenation of $I_(n / 2)$ and $bold(nothing)_(n / 2)^R$, where
$bold(nothing)_(n / 2)^R$ is an $n / 2 times n / 2$ matrix whose
reverse-diagonal elements are unary conjugate operators and all other
elements are zero. For example, if $n = 8$, then $M$ and $N$ are
structured as follows:

$M = mat(delim: "[", 1, 0, 0, 0, 0, 0, 0, 0; 0, 1, 0, 0, 0, 0, 0, 0; 0, 0, 1, 0, 0, 0, 0, 0; 0, 0, 0, 1, 0, 0, 0, 0; #none)$,
$N = mat(delim: "[", 1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1; 0, 0, 0, nothing; 0, 0, nothing, 0; 0, nothing, 0, 0; nothing, 0, 0, 0; #none)$

$$

The reason $N$ is not a linear transformation matrix is because it
contains conjugate operators $nothing$. Yet, notice that the following
homomorphism holds between $arrow(hat(v)) in bb(hat(C))^n$ and
$arrow(v) in bb(C)^(n / 2)$:

$N dot.op\(M dot.op arrow(hat(v))_1 + M dot.op arrow(hat(v))_2\)= arrow(hat(v))_1 + arrow(hat(v))_2$,
$M dot.op\(N dot.op arrow(v)_1 + N dot.op arrow(v)_2\)= arrow(v)_1 + arrow(v)_2$

$N dot.op\(M dot.op arrow(hat(v))_1 dot.circle M dot.op arrow(hat(v))_2\)= arrow(hat(v))_1 dot.circle arrow(hat(v))_2$,
$M dot.op\(N dot.op arrow(v)_1 dot.circle N dot.op arrow(v)_2\)= arrow(v)_1 dot.circle arrow(v)_2$

Thus, the $bb(hat(C))^n$ and $bb(C)^(n / 2)$ vector spaces are bijective
and homomorphic over the $\(+\,dot.circle\)$ operations, and therefore
they preserve isomorphism.

$$

=== Isomorphism between $bb(hat(C))^n$ and $bb(R)\[X\]\/X^n + 1$
<subsec:poly-vector-transformation-complex-isomorphism2>
Now, we will demonstrate $sigma_c$'s isomorphism (i.e., bijective and
homomorphic) between $bb(hat(C))^n$ and $bb(R)\[X\]\/X^n + 1$ by
applying the same reasoning as described in the beginning of
#link(<subsec:poly-vector-transformation>)[0.6].

#figure(image("figures/cyclotomic-polynomial.pdf", width: 30.0%),
  caption: [
    An illustration of the four roots of the 8th cyclotomic polynomial
    $x^4 + 1$
  ]
)
<fig:cyclotomic-polynomial>

$$

Based on Euler's formula $e^(i theta) = cos theta + i dot.op sin theta$
(#link(<subsec:euler>)[\[subsec:euler\]]), we can derive the following
arithmetic relations:
$omega = overline(omega^(2 n - 1))\,upright(" ") omega^3 = overline(omega^(2 n - 3))\,dots.h.c\,omega^(n - 1) = overline(omega^(n + 1))$.
In other words, the one-half roots are conjugates of the other-half
roots. This can also be pictorially understood based on a complex plane
in #link(<fig:cyclotomic-polynomial>)[1], where red arrows represent the
roots of the 8th cyclotomic polynomial $X^4 + 1$, comprising imaginary
number and real number components. As shown in this figure, one half of
the red arrows (i.e., roots) are a reflection of the other half on the
$x$-axis (i.e., real number axis). This means that we can express these
roots as an $n$-dimensional vector whose elements are the roots of
$X^n + 1$, such that its second-half elements are a reverse-ordered
conjugate of the first-half elements. Based on this vector design, the
$sigma$ mapping can be re-written as follows:

$sigma\(f\(X\)\)=\(f\(omega\)\,f\(omega^3\)\,f\(omega^5\)\,dots.h.c\,f\(omega^(n - 1)\)\,f\(overline(omega^(n - 1))\)\,f\(overline(omega^(n - 3))\)\,dots.h.c\,f\(overline(omega^3)\)\,f\(overline(omega)\)\)$

$$

Since $f\(overline(X)\)= overline(f\(X\))$, we can rewrite $sigma$ as:

$sigma\(f\(X\)\)=\(f\(omega\)\,f\(omega^3\)\,f\(omega^5\)\,dots.h.c\,f\(omega^(n - 3)\)\,f\(omega^(n - 1)\)\,overline(f\(omega^(n - 1)\))\,overline(f\(omega^(n - 3)\))\,dots.h.c\,overline(f\(omega^3\))\,overline(f\(omega\)\))$

$$

This structure of vector exactly aligns with the definition of
$hat(bb(C))^n$: the first half of the elements of the $n$-dimensional
vector $arrow(hat(v))$ is a conjugate of the second half.

For bijectiveness, we also need to demonstrate that every
$f\(X\)in bb(R)\[X\]\/X^n + 1$ is mapped to some
$arrow(hat(v)) in hat(bb(C))^(n / 2)$, and no two different
$f_1\(X\)\,f_2\(X\)in bb(R)\[X\]\/X^n + 1$ map to the same
$arrow(hat(v)) in hat(bb(C))^n$. The first requirement is satisfied
because each polynomial $f\(X\)in bb(R)\[X\]\/X^n + 1$ can be evaluated
at the $n$ distinct roots of $X^n + 1$ to a valid number. The second
requirement is also satisfied because in the $\(n - 1\)$-degree
polynomial ring, each list of $n$ distinct $\(x\,y\)$ coordinates (where
we fix the $X$ values as the $n$ distinct roots of $X^n + 1$ as
${ omega\,omega^3\,dots.h.c\,omega^(2 n - 1) }$) can be mapped only to a
single polynomial within the $\(n - 1\)$-degree polynomial ring, as
proved by Lagrange Polynomial Interpolation
(Theorem~@sec:polynomial-interpolation in
#link(<sec:polynomial-interpolation>)[\[sec:polynomial-interpolation\]]).

$$

$sigma_c$ is homomorphic, because based on the reasoning shown in
#link(<subsec:poly-vector-transformation>)[0.6], the relations
$sigma\(f_a\(X\)+ f_b\(X\)\)= sigma\(f_a\(X\)\)+ sigma\(f_b\(X\)\)$ and
$sigma\(f_a\(X\)dot.op f_b\(X\)\)= sigma\(f_a\(X\)\)dot.circle sigma\(f_b\(X\)\)$
mathematically hold regardless of whether the type of $X$ is modulo
integer or complex number,

$$

Since $sigma_c$ is both bijective and homomorphic over the
$\(+\,dot.op\)$ operations, it is isomorphic.

#block[
The following mapping $sigma_c$ between polynomials and vectors over
complex numbers is isomorphic:

$sigma_c : f\(X\)in bb(R)\[X\]\/\(X^n + 1\)arrow.r\(f\(omega\)\,f\(omega^3\)\,f\(omega^5\)\,dots.h.c\,f\(omega^(2 n - 1)\)\)in bb(hat(C))^n upright(" ")\(arrow.r bb(C)^(n / 2)\)$

$$

, where $omega = e^(i pi\/n)$, the root (i.e., the primitive
$\(mu = 2 n\)$-th root) of the cyclotomic polynomial $X^n + 1$ over
complex numbers, and $bb(hat(C))^n$ is $n$-dimensional complex special
vector space whose second-half elements are reverse-ordered conjugates
of the first-half elements.

]
== Transforming Basis between Polynomial Ring and Vector Space
<subsec:poly-vector-basis-transfer>
Suppose some polynomials $f_0\(X\)\,f_1\(X\)\,dots.h.c\,f_(n - 1)\(X\)$
form a basis of the $\(n - 1\)$-degree polynomial ring and $sigma$ is an
isomorphic mapping from the $\(n - 1\)$-degree polynomial ring to the
$n$-dimensional vector space $in bb(Z)^n$. Then,
$\(sigma\(f_0\(X\)\)\,sigma\(f_1\(X\)\)\,dots.h.c\,sigma\(f_(n - 1)\(X\)\)\)$
form a basis of the $n$-dimensional vector space. This is because the
$sigma$-mapped output vectors homomorphically preserve the same
algebraic relationships on the $\(+\,dot.op\)$ operations and the basis
relationship between basis vectors and a subspace can be expressed as a
linear algebraic formula consisting of the $\(+\,dot.op\)$ operations
(i.e., linear independence and spanning of the space). Therefore, if a
set of polynomials satisfies a basis relationship, their $sigma$-mapped
vectors also preserve a basis relationship.

The same principle holds between a polynomial ring and vector space over
complex numbers. Given the polynomial ring $bb(R)\[X\]\/\(x^n + 1\)$,
the most intuitive way to set up a basis of $bb(R)\[X\]\/\(x^n + 1\)$ is
as follows:

$f_0\(X\)= 1$

$f_1\(X\)= X$

$f_2\(X\)= X^2$

$dots.v$

$f_(n - 1)\(X\)= X^(n - 1)$

$$

These $n$ polynomials are linearly independent, because each polynomial
exclusively has its own unique exponent term, whereas one term cannot be
expressed by a linear combination of the other terms. Also, these $n$
polynomials span the polynomial ring $bb(R)\[X\]\/\(x^n + 1\)$, because
each polynomial's scalar multiplication can express any coefficient
value of its own exponent term, and summing all such polynomials can
express any polynomial in the polynomial ring $bb(R)\[X\]\/\(X^n + 1\)$.

Now, we will apply the $sigma_c$ mapping to the above $n$ polynomials
that are a basis of the $\(n - 1\)$-degree polynomial ring
$bb(R)\[X\]\/\(x^n + 1\)$. Then, according to the principle of
polynomial-to-vector basis transfer (explained in
Theorem~@subsec:polynomial-ring-basis in
#link(<subsec:polynomial-ring-basis>)[0.5]), we can use these $n$
polynomials (i.e., the basis of the $\(n - 1\)$-degree polynomial ring)
and the isomorphic polynomial-to-vector mapping $sigma_c$ to compute the
basis of the $n$-dimensional special vector space $hat(bb(C))^n$ as
follows:

$W = mat(delim: "[", sigma_c\(f_0\(X\)\); sigma_c\(f_1\(X\)\); sigma_c\(f_2\(X\)\); dots.v; sigma_c\(f_(n - 1)\(X\)\); #none) = mat(delim: "[", sigma_c\(1\); sigma_c\(X\); sigma_c\(X^2\); dots.v; sigma_c\(X^(n - 1)\); #none)$
$= mat(delim: "[", 1, 1, dots.h.c, 1, 1; \(omega\), \(omega^3\), \(omega^5\), dots.h.c, \(omega^(2 n - 1)\); \(omega\)^2, \(omega^3\)^2, \(omega^5\)^2, dots.h.c, \(omega^(2 n - 1)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), \(omega^5\)^(n - 1), dots.h.c, \(omega^(2 n - 1)\)^(n - 1); #none)$

$= mat(delim: "[", 1, 1, 1, dots.h.c, 1; \(omega\), \(omega^3\), dots.h.c, \(overline(omega)\)^3, \(overline(omega)\); \(omega\)^2, \(omega^3\)^2, dots.h.c, \(overline(omega)^3\)^2, \(overline(omega)\)^2; dots.v, dots.v, dots.v, dots.down, dots.v; \(omega\)^(n - 1), \(omega^3\)^(n - 1), dots.h.c, \(overline(omega)^3\)^(n - 1), \(overline(omega)\)^(n - 1); #none)$

$$

$W$ is a valid basis of the $n$-dimensional special vector space
$hat(bb(C))^n$.

#block[
If $n$ polynomials form a basis of an $\(n - 1\)$-degree polynomial ring
and they are converted into $n$ distinct vectors via an isomorphic
mapping $sigma$ (or $sigma_c$ in the case of the complex number domain)
from the $\(n - 1\)$-degree polynomial ring to the $n$-dimensional
vector space, then those converted $n$ vectors form a basis of the
$n$-dimensional (or $n / 2$ in the case of the complex number domain)
vector space.

]
