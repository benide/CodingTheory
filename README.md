# CodingTheory

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://esabo.github.io/CodingTheory/dev/)
[![Build Status](https://github.com/esabo/CodingTheory/actions/workflows/Tests.yml/badge.svg?branch=master)](https://github.com/esabo/CodingTheory/actions/workflows/Tests.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/esabo/CodingTheory/branch/master/graph/badge.svg)](https://codecov.io/gh/esabo/CodingTheory)

A coding theory library for Julia.

The goal of this package is to develop a classical and quantum error-correcting codes package in as much native Julia as possible. The library is built around the Oscar.jl framework, and many thanks to Tommy Hofmann of these packages for helping this repo get off the ground. Anyone is welcome to contribute, although the final form of any accepted code may be standardized to maintain intra-package consistency.

At the moment, all functions work as intended for test cases but have not been unit tested thoroughly enough to guarantee accuracy and error free usage. All results from this library should be mentally checked and any bugs reported (or fixed and pushed). This is particularly true for the quantum part where algorithms become increasingly more complicated.

The generation of hyperbolic tilings (in tilings.jl) requires the [LINS package](https://github.com/FriedrichRober/LINS). Please use the [temporary fork](https://github.com/esabo/LINS.git) at the address below to fix a compatibility issue with the Sonata package. The probabilistic quantum minimum distance algorithm [QDistRnd](https://github.com/QEC-pages/QDistRnd.git) requires the corresponding GAP package. To install these, run 
    GAP.Packages.install(URL)
    GAP.Packages.install("https://github.com/QEC-pages/QDistRnd.git")
    GAP.Packages.install("https://github.com/esabo/LINS.git")
and then
    GAP.Packages.load("QDistRnd");
    GAP.Packages.load("LINS");
These are not automatically installed and loaded.

## Current features
### Classical
- Basic linear codes
- Subcode checking
- Syndrome/encoding calculation
- Quotients of subcodes
- Duals, Hermitian duals
- Direct sums, tensor products, Schur product
- Extending, puncturing, expurgating, augmenting, shortening, lengthening (these definitions may vary from text to text)
- Plotkin-(u | u + v) construction, (u + w, v + w, u + v + w) construction, construction X, construction X3, juxtaposition
- Expanding codes over field extensions
- Cylotomic cosets, defining sets
- Cyclic, BCH, Reed-Solomon, quadratic residue codes
- BCH Bound with Hartmann-Tzeng Bound refinement
- Complement, dual, intersection, and union of cyclic codes
- Generalized Reed-Solomon codes
- Binary Reed-Muller code
- Golay codes
- Binary Hamming codes
- Binary simplex codes
- Hadamard codes
- Weight enumerators (complete and Hamming), distribution, and minimum distance
- MacWilliams identities
- LDPC codes: degree distributions/polynomials, Tanner graph
- Matrix product codes
- Tanner codes

### Quantum
- Stabilizer codes over $\mathbb{F}_q$ with auto CSS and graph state detection
- CSS constructions over $\mathbb{F}_q$ from linear codes or matrices
- Qubit code constructions using Pauli strings
- Able to keep an over complete set of stabilizers
- Keeps track of signs of elements
- Quadratic to symplectic, symplectic to quadratic functions
- Symplectic and trace inner product
- Logical operators
- Track logicals through process of adding and removing stabilizers
- X, Z, and full syndrome computations
- Generate all elements and their signs
- Weight enumerators (signed complete and Hamming), distribution, and minimum distance (with an interface to QDistRnd)
- Hardcoded [[5, 1, 3]] perfect, Steane, Shor, and [[15, 1, 3]] Reed Muller codes
- Toric, planar, and rotated surface codes (surface-17 configuration)
- XY, XZZX, and XYZ^2 surface codes
- 4.8.8 and 6.6.6 triangular color codes for odd distances 3 to 21
- Hypergraph product, generalized Shor, Bacon-Casaccino construction,
    hyperbicycle, generalized bicycle, bicycle generalized hypergraph product, lifted generalized hypergraph product
- Graph states (from graph object), cluster states

Quantum minimum distance and sectionalized trellises temporarily disabled. QDistRnd is still accessible.
