# Kelvin CAS
Based on Java Algebra System's powerful engine, Kelvin is a powerful programming language built with Swift for algebraic computation. Find [more](https://github.com/JiachenRen/java-algebra-system) about JAS here.

## Capabilities

### Arithmetic
- [x] Standard binary operations
  - *Addition*
  - *Subtraction*
  - *Multiplication*
  - *Division*
  - *Exponentiation*
- [x] Unary operations (many, see below)

### Number
- [x] Greatest common divisor & least common multiple
- [x] Prime factors
- [ ] Fraction
- [ ] Exact vs. approximate

### Algebra
- [x] Commutative simplification
- [x] Preliminary factorization
- [x] Expand expressions
- [ ] Complete the square
- [ ] Exponential simplification
- [ ] Solve
  - [ ] Numerical solve
  - [ ] Zeros
  - [ ] Algebraic solve

### Calculus
- [x] Differentiation
  - *Logarithmic differentiation*
  - *nth derivative*
  - *Multivariate (Calculus III)*
    - Partial derivatives
    - Implicit differentiation
    - Directional differentiation
    - Gradient
  
- [ ] Integration

### Statistics
- [x] One variable statistics
  - *Summation*
  - *Average*
  - *Sum of difference squared*
  - *Variance*
  - *Std. deviation*
  - *Five-number summary, IQR*
  - *Outliers*
  
- [ ] Two variable statistics
- [x] Distributions
  - [x] Normal Cdf (-∞ to x, from lb to ub, from lb to ub with μ and σ)
  - [x] Random normal distribution (randNorm)
  - [x] Normal Pdf
  - [x] Inverse Normal
  - [ ] Inverse t
  - [ ] Binomial Cdf/Pdf
  - [ ] Geometric Cdf/Pdf
- [ ] Confidence intervals
- [ ] Regression
  - [ ] Linear
  - [ ] Quadratic, cubic, quartic, power
  - [ ] Exponential/logarithmic
  - [ ] Sinusoidal
  - [ ] Logistic

### Probability
- [x] Permutation/combination
- [x] Randomization

### Vector/Matrix
- [x] Vector
  - [x] Compilation
  - [x] Dot product
  - [x] Cross Product
  - [x] Subscript access
  - [x] Addition/subtraction
  - [x] Angle between

- [x] Matrix
  - [x] Conversion to/from list/matrix
  - [x] Determinant
  - [x] Identity
  - [x] Multiplication
  - [x] Addition/Subtraction
  - [x] Transposition

### List math/operations
- [x] Zip, map, and reduce w/ anonymous closure arguments.
- [x] Sort and filter
- [x] Append and remove
- [ ] Insert
- [x] Chained subscript access
  - Access by index
  - Access by range
- [x] Size

### Boolean logic
- [x] Basic boolean operators
  - *And, or, xor, and not.*
- [ ] Commutative simplification 
  - *Only handles and & or for now*

### Programs/functions
- [x] Definition & deletion of variables and functions
  - *Support function overloading*
  - *Automatic scope management*
- [x] Runtime compilation
- [x] Flow control
  - Execution
    - *Line break*
    - *Line feed*
  - Loops
    - *Copy*
    - *Repeat*
  - Conditional statements
    - Ternary operator '?'
- [x] I/O
  - *Program execution*
  - *Print, println*
- [x] Strings
  - *Concatenation*
  - *Subscript access*
- [x] Tuples
  - *Compilation*
  - *Subscript access*
- [x] Error handling with try
- [x] System
  - *Precise date & time (down to nano seconds)*
  - *Performance measurement*
- [x] Scope management
  - Lock/unlock variables
  - Save/restore
- [ ] Multi-line block
