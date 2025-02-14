# Copyright (c) 2021, Eric Sabo
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

# include("tricolorcodes488trellis.jl")
# include("tricolorcodes666trellis.jl")

#############################
        # Misc codes
#############################

"""
    FiveQubitCode()
    Q513()

Return the `[[5, 1, 3]]` perfect qubit stabilizer code.
"""
# is a perfect code
FiveQubitCode() = QuantumCode(["XZZXI", "IXZZX", "XIXZZ", "ZXIXZ"])
Q513() = FiveQubitCode()

# should also do a test for other CSS construction via Hamming code and actually make that one default
"""
    Steanecode()
    Q713()

Return the `[[7, 1, 3]]` Steane code with stabilizers in standard ordering.
"""
SteaneCode() = CSSCode(["XXXXIII", "XXIIXXI", "XIXIXIX", "ZZZZIII", "ZZIIZZI", "ZIZIZIZ"])
Q713() = SteaneCode()
_SteaneCodeTrellis() = CSSCode(["XXIXXII", "IXXIXXI", "IIIXXXX", "ZZIZZII", "IZZIZZI", "IIIZZZZ"])
# also ZZIZZII, ZIZZIZI, IZZZIIZ, XXIXXII, XIXXIXI, IXXXIIX

"""
    Shorcode()
    Q913()

Return the `[[9, 1, 3]]` Shor code.
"""
ShorCode() = CSSCode(["ZZIIIIIII", "IZZIIIIII", "IIIZZIIII", "IIIIZZIII", "IIIIIIZZI", "IIIIIIIZZ", "XXXXXXIII", "IIIXXXXXX"])
Q913() = ShorCode()

Q412() = CSSCode(["XXXX", "ZZII", "IIZZ"])
Q422() = CSSCode(["XXXX", "ZZZZ"])
Q511() = QuantumCode(["ZXIII", "XZXII", "IXZXI", "IIXZX"])

function Q823()
    F, _ = FiniteField(2, 1, "α")
    S = matrix(F, [1 0 0 0 1 0 0 0 1 1 1 1 0 0 0 0;
    0 0 0 1 0 1 0 0 1 0 0 0 0 1 0 0;
    0 1 0 0 1 1 1 0 0 0 1 1 1 0 1 0;
    0 0 1 0 1 1 1 0 0 1 1 0 1 1 0 0;
    0 0 1 1 1 0 1 0 0 0 0 1 0 1 1 1;
    0 0 0 0 0 0 1 1 0 0 1 0 0 0 1 0]);
    return QuantumCode(S, true)
end

"""
    Q15RM()
    Q1513()

Return the `[[15, 1, 3]]` quantum Reed-Muller code with stabilizers in standard
ordering.
"""
Q15RM() = QuantumCode(["ZIZIZIZIZIZIZIZ", "IZZIIZZIIZZIIZZ", "IIIZZZZIIIIZZZZ",
    "IIIIIIIZZZZZZZZ", "IIZIIIZIIIZIIIZ", "IIIIZIZIIIIIZIZ", "IIIIIZZIIIIIIZZ",
    "IIIIIIIIIZZIIZZ", "IIIIIIIIIIIZZZZ", "IIIIIIIIZIZIZIZ",
    "XIXIXIXIXIXIXIX", "IXXIIXXIIXXIIXX", "IIIXXXXIIIIXXXX", "IIIIIIIXXXXXXXX"])
Q1513() = Q15RM()

"""
    Q1573()

Return the `[[15, 7, 3]]` quantum Hamming code.
"""
Q1573() = QuantumCode(["IIIIIIIXXXXXXXX", "IIIXXXXIIIIXXXX", "IXXIIXXIIXXIIXX",
    "XIXIXIXIXIXIXIX", "IIIIIIIZZZZZZZZ", "IIIZZZZIIIIZZZZ", "IZZIIZZIIZZIIZZ",
    "ZIZIZIZIZIZIZIZ"])
    # one can use a basis for this such that the first logical pair is transversal X, Z

#############################
 # Triangular Surface Codes
#############################

function _triangularlattice(L::Int)
    # 0 - vertical
    # 1 - horizontal
    # 2 - diagonal
    numbering = zeros(Int, L, L, 3)
    num = 1
    for i in 1:L
        for j in 1:L
            for k in 1:3
                numbering[i, j, k] = num
                num += 1
            end
        end
    end
    return numbering
end

function _triangularlatticeXstabilizers(L::Int, numbering::Array{Int64, 3}, symp::Bool=true)
    F, _ = FiniteField(2, 1, "α")
    stabilizers = zero_matrix(F, L^2, 3 * L^2)
    r = 1
    for i in 1:L
        for j in 1:L
            stabilizers[r, numbering[i, j, 1]] = 1
            stabilizers[r, numbering[i, j, 2]] = 1
            stabilizers[r, numbering[i, j, 3]] = 1
            if i == 1
                stabilizers[r, numbering[end, j, 1]] = 1
            else
                stabilizers[r, numbering[i - 1, j, 1]] = 1
            end
            if j == 1
                stabilizers[r, numbering[i, end, 2]] = 1
            else
                stabilizers[r, numbering[i, j - 1, 2]] = 1
            end
            if i == 1 && j == 1
                stabilizers[r, numbering[end, end, 3]] = 1
            elseif i != 1 && j == 1
                stabilizers[r, numbering[i - 1, end, 3]] = 1
            elseif i == 1 && j != 1
                stabilizers[r, numbering[end, j - 1, 3]] = 1
            else
                stabilizers[r, numbering[i - 1, j - 1, 3]] = 1
            end
            r += 1
        end
    end
    if symp
        return hcat(stabilizers, zero_matrix(F, L^2, 3 * L^2))
    end
    return stabilizers
end

function _triangularlatticeZstabilizers(L::Int, numbering::Array{Int64, 3}, symp::Bool=true)
    F, _ = FiniteField(2, 1, "α")
    stabilizers = zero_matrix(F, 2 * L^2, 3 * L^2)
    r = 1
    for i in 1:L
        for j in 1:L
            stabilizers[r, numbering[i, j, 2]] = 1
            stabilizers[r, numbering[i, j, 3]] = 1
            if j == L
                stabilizers[r, numbering[i, 1, 1]] = 1
            else
                stabilizers[r, numbering[i, j + 1, 1]] = 1
            end

            r += 1
            stabilizers[r, numbering[i, j, 1]] = 1
            stabilizers[r, numbering[i, j, 3]] = 1
            if i == L
                stabilizers[r, numbering[1, j, 2]] = 1
            else
                stabilizers[r, numbering[i + 1, j, 2]] = 1
            end
            r += 1
        end
    end
    if symp
        return hcat(zero_matrix(F, 2 * L^2, 3 * L^2), stabilizers)
    end
    return stabilizers
end

function _triangularlatticeXlogicals(L::Int, numbering::Array{Int64, 3}, symp::Bool=true)
    # should be 0110110110
    z = zeros(UInt8, 3 * L^2)
    logical1 = zeros(UInt8, 3 * L^2)
    for j in 0:L - 1
        for k in 0:2
            if k == 0
                logical1[3 * j + k + 1] = 0x01
            elseif k == 1
                logical1[3 * j + k + 1] = 0x00
            else
                logical1[3 * j + k + 1] = 0x01
            end
        end
    end
    if symp
        logical1 = [logical1; z]
    end

    logical2 = zeros(UInt8, 3 * L^2)
    for j in 1:L
        for k in 0:2
            if k == 0
                logical2[3 * j + k + 1] = 0x01
            elseif k == 1
                logical2[3 * j + k + 1] = 0x00
            else
                logical2[3 * j + k + 1] = 0x01
            end
        end
    end
    if symp
        logical2 = [logical2; z]
    end

  return [logical1, logical2]
end

function _triangularlatticeZlogicals(L::Int, numbering::Array{Int64, 3}, symp::Bool=true)
    # should be 1001001001
    x = zeros(UInt8, 3 * L^2)
    logical1 = zeros(UInt8, 3 * L^2)
    for j in 0:L - 1
        for k in 0:2
            if k == 0
                logical1[3 * j + k + 1] = 0x01
            elseif k == 1
                logical1[3 * j + k + 1] = 0x00
            else
                logical1[3 * j + k + 1] = 0x01
            end
        end
    end
    if symp
        logical1 = [z; logical1]
    end

    logical2 = zeros(UInt8, 3 * L^2)
    for j in 1:L
        for k in 0:2
            if k == 0
                logical2[3 * j + k + 1] = 0x01
            elseif k == 1
                logical2[3 * j + k + 1] = 0x00
            else
                logical2[3 * j + k + 1] = 0x01
            end
        end
    end
    if symp
        logical2 = [z; logical2]
    end

  return [logical1, logical2]
end

function TriangularSurfaceCode(L::Int)
    numbering = _triangularlattice(L)
    Xstabs = _triangularlatticeXstabilizers(L, numbering, false)
    # println(rank(Xstabs))
    Zstabs = _triangularlatticeZstabilizers(L, numbering, false)
    # println(Zstabs)
    # logicals = [triangularlatticeXlogicals(L, numbering), triangularlatticeZlogicals(L, numbering)]
    return CSSCode(Xstabs[1:end - 1, :], Zstabs[1:end - 1, :])
end

#############################
   # Rotated Surface Codes
#############################

function _RSurfstabslogs(d::Int)
    n = d^2
    E, ω = FiniteField(2, 2, "ω")
    X = E(1)
    S = zero_matrix(E, n - 1, n)
    row = 1

    # X's
    i = 1
    while i <= n - d
        S[row, i] = X
        S[row, i + 1] = X
        S[row, i + d] = X
        S[row, i + d + 1] = X
        row += 1
        if (i + 2) % d == 0
            i += 4
        else
            i += 2
        end
    end

    # top row X's
    i = 2
    while i <= d - 1
        S[row, i] = X
        S[row, i + 1] = X
        row += 1
        i += 2
    end

    # bottom row X's
    i = d * (d - 1) + 1
    while i <= d * d - 2
        S[row, i] = X
        S[row, i + 1] = X
        row += 1
        i += 2
    end

    # Z's
    i = 2
    while i < n - d
        S[row, i] = ω
        S[row, i + 1] = ω
        S[row, i + d] = ω
        S[row, i + d + 1] = ω
        row += 1
        if (i + 2) % d == 0
            i += 4
        else
            i += 2
        end
    end

    # left Z's
    i = 1
    while i < d * (d - 1)
        S[row, i] = ω
        S[row, i + d] = ω
        row += 1
        i += 2 * d
    end

    # right Z's
    i = 2 * d
    while i < d * d
        S[row, i] = ω
        S[row, i + d] = ω
        row += 1
        i += 2 * d
    end

    logs = zero_matrix(E, 2, n)
    i = d
    while i <= d * d
        logs[1, i] = 0x01
        i += d
    end
    i = 1
    while i <= d
        logs[2, i] = ω
        i += 1
    end

    return S, logs
end

# flint is being ridiculous here
# julia> @time Q = rotatedsurfacecode(21);
# 226.128107 seconds (1.73 G allocations: 80.659 GiB, 18.33% gc time, 0.09% compilation time)
# julia> Base.summarysize(Q)
# 16872
"""
    RotatedSurfaceCode(d::Int)

Return the `[[d^2, 1, d]]` rotated surface code.

This is the surface-13/17 configuration found in "Low-distance surface codes under realistic quantum noise"
by Tomita and Svore. The standard planar surface code is equivalent to their surface-25 configuration, which
can be seen by viewing the stabilizers of PlanarSurfaceCode as an adjacency matrix.
"""
function RotatedSurfaceCode(d::Int)
    d >= 3 || error("Current implementation requires d ≥ 3.")

    S, logs = _RSurfstabslogs(d)
    Q = QuantumCode(S)
    setlogicals!(Q, logs)
    return Q
end

#############################
     # XZZX Surface Codes
#############################

function _XZZXstabslogs(d::Int)
    n = d^2
    E, ω = FiniteField(2, 2, "ω")
    S = zero_matrix(E, n - 1, n)
    row = 1
    X = E(1)

    i = 1
    for i in 1:n - d
        if i % d != 0
            S[row, i] = X
            S[row, i + 1] = ω
            S[row, i + d] = ω
            S[row, i + d + 1] = X
            row += 1;
        end
    end

    # top row ZX's
    i = 2
    while i <= d - 1
        S[row, i] = ω
        S[row, i + 1] = X
        row += 1
        i += 2
    end

    # bottom row XZ's
    i = d * (d - 1) + 1
    while i <= d * d - 2
        S[row, i] = X
        S[row, i + 1] = ω
        row += 1
        i += 2
    end

    # left ZX's
    i = 1
    while i < d * (d - 1)
        S[row, i] = ω
        S[row, i + d] = X
        row += 1
        i += 2 * d
    end

    # right XZ's
    i = 2 * d
    while i < d * d
        S[row, i] = X
        S[row, i + d] = ω
        row += 1
        i += 2 * d
    end

    logs = zero_matrix(E, 2, n)
    i = d
    count = 1
    while i <= d * d
        if count % 2 == 1
            logs[1, i] = X
        else
            logs[1, i] = ω
        end
        i += d
        count += 1
    end
    i = 1
    count = 1
    while i <= d
        if count % 2 == 1
            logs[2, i] = ω
        else
            logs[2, i] = X
        end
        i += 1
        count += 1
    end

    return S, logs
end

"""
    XZZXSurfaceCode(d::Int)

Return the `[[d^2, 1, d]]` XZZX surface code.
"""
function XZZXSurfaceCode(d::Int)
    d >= 3 || error("Current implementation requires d ≥ 3.")

    S, logs = _XZZXstabslogs(d)
    Q = QuantumCode(S)
    setlogicals!(Q, logs)
    return Q
end

################################
 # Triangular Color Codes 4.8.8
################################

"""
    TriangularColorCode488(d::Int)

Return the 4.8.8 triangular color code of distance `d` with trellis numbering.
"""
function TriangularColorCode488(d::Int)
    3 <= d <= 21 || error("Current implementation requires 3 ≤ d ≤ 21.")

    if d == 3
        # S, logs = _488d3trellis()
        @load "data/488d3stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 5
        # S, logs = _488d5trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d5stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 7
        # S, logs = _488d7trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d7stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 9
        # S, logs = _488d9trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d9stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 11
        # S, logs = _488d11trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d11stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 13
        # S, logs = _488d13trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d13stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 15
        # S, logs = _488d15trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d15stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 17
        # S, logs = _488d17trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d17stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 19
        # S, logs = _488d19trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d19stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 21
        # S, logs = _488d21trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d21stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    end
end

################################
 # Triangular Color Codes 6.6.6
################################

"""
    TriangularColorCode666(d::Int)

Return the 6.6.6 triangular color code of distance `d` with trellis numbering.
"""
function TriangularColorCode666(d::Int)
    3 <= d <= 21 || error("Current implementation requires 3 ≤ d ≤ 21.")

    if d == 3
        # same as 4.8.8
        # S, logs = _488d3trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/488d3stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 5
        # S, logs = _666d5trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d5stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 7
        # S, logs = _666d7trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d7stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 9
        # S, logs = _666d9trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d9stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 11
        # S, logs = _666d11trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d11stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 13
        # S, logs = _666d13trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d13stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 15
        # S, logs = _666d15trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d15stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 17
        # S, logs = _666d17trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d17stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 19
        # S, logs = _666d19trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d19stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    elseif d == 21
        # S, logs = _666d21trellis()
        # Q = QuantumCode(S)
        # setlogicals!(Q, logs)
        @load "data/666d21stabslogs_trellis.jld2" S l
        F, _ = FiniteField(2, 1, "α")
        S = matrix(F, S)
        Q = QuantumCode(S, true)
        l = symplectictoquadratic(matrix(F, l))
        Q.logicals = [(l[1, :], l[2, :])]
        return Q
    end
end

################################
         # Toric Codes
################################

"""
    ToricCode(d::Int)

Return the `[[2d^2, 2, d]]` toric code.

The lattice orientation used here follows the picture at https://errorcorrectionzoo.org/c/surface.
"""
function ToricCode(d::Int)
    2 <= d || throw(ArgumentError("Distance must be at least two."))

    F, _ = FiniteField(2, 1, "α")
    Fone = F(1)
    A = zero_matrix(F, d^2, 2 * d^2) # stars, X stabilizers
    B = zero_matrix(F, d^2, 2 * d^2) # faces, Z stabilizers
    qubit = 1
    rowA = 1
    rowB = 1
    for r in 1:2 * d
        if isodd(r)
            for c in 1:d
                # println("r = $r, c = $c, rowA = $rowA")
                if r != 2 * d - 1 && c != d
                    A[rowA, qubit] = A[rowA, qubit + d] = A[rowA, qubit + d + 1] = A[rowA, qubit + 2 * d] = Fone
                elseif r == 2 * d - 1 && c != d
                    A[rowA, qubit] = A[rowA, qubit + d] = A[rowA, qubit + d + 1] = A[rowA, c] = Fone
                elseif r != 2 * d - 1 && c == d
                    A[rowA, qubit] = A[rowA, qubit + d] = A[rowA, qubit + 1] = A[rowA, qubit + 2 * d] = Fone
                elseif r == 2 * d - 1 && c == d
                    A[rowA, qubit] = A[rowA, qubit + d] = A[rowA, qubit + 1] = A[rowA, c] = Fone
                else
                    error("Ran into unaccounted for case in creating the toric code lattice.")
                end
                rowA += 1
                qubit += 1
            end
        else
            for c in 1:d
                # println("r = $r, c = $c, rowB = $rowB")
                if r != 2 * d && c == 1
                    B[rowB, qubit] = B[rowB, qubit + d] = B[rowB, qubit + 2 * d] = B[rowB, qubit + 2 * d - 1] = Fone
                elseif r != 2 * d && c != 1
                    B[rowB, qubit] = B[rowB, qubit + d - 1] = B[rowB, qubit + d] = B[rowB, qubit + 2 * d] = Fone
                elseif r == 2 * d && c == 1
                    B[rowB, qubit] = B[rowB, d] = B[rowB, d + 1] = B[rowB, 1] = Fone
                elseif r == 2 * d && c != 1
                    B[rowB, qubit] = B[rowB, c - 1] = B[rowB, c] = B[rowB, c + d] = Fone
                else
                    println("here")
                    error("Ran into unaccounted for case in creating the toric code lattice.")
                end
                rowB += 1
                qubit += 1
            end
        end
    end
    # display(A)
    # println(" ")
    # display(B)
    # println(" ")
    S = CSSCode(A, B, missing)
    Eone = S.E(1)
    ω = gen(S.E)
    X1 = zero_matrix(S.E, 1, 2 * d^2)
    for c in 1:d
        X1[1, c + d] = Eone
    end
    # display(X1)
    # println(" ")
    Z1 = zero_matrix(S.E, 1, 2 * d^2)
    for r in 1:2:2 * d
        Z1[1, r * d + 1] = ω
    end
    # display(Z1)
    # println(" ")
    X2 = zero_matrix(S.E, 1, 2 * d^2)
    for r in 1:2:2 * d
        X2[1, (r - 1) * d + 1] = Eone
    end
    # display(X2)
    # println(" ")
    Z2 = zero_matrix(S.E, 1, 2 * d^2)
    for c in 1:d
        Z2[1, c] = ω
    end
    # display(Z2)
    S.logicals = [(X1, Z1), (X2, Z2)]
    S.dx = d
    S.dz = d
    S.d = d
    return S
end

################################
     # Planar Surface Codes
################################

"""
    PlanarSurfaceCode(dx::Int, dz::Int)
    PlanarSurfaceCode(d::Int)

Return the `[[dx * dz + (dx - 1) * (dz - 1), 1, dx/dz]]` planar surface code.

The top and bottom boundaries are "smooth" (`Z`) and the left and right are "rough" (`X`).
"""
function PlanarSurfaceCode(dx::Int, dz::Int)
    (2 <= dx && 2 <= dz) || throw(ArgumentError("Distances must be at least two."))

    F, _ = FiniteField(2, 1, "α")
    Fone = F(1)
    numV = dx * dz + (dx - 1) * (dz - 1)
    A = zero_matrix(F, dx * (dz - 1) + 1, numV) # stars, X stabilizers
    B = zero_matrix(F, dz * (dx - 1), numV) # faces, Z stabilizers
    qubit = 1
    rowA = 1
    rowB = 1
    for r in 1:dz
        for c in 1:dx
            # println("r = $r, c = $c, qubit = $qubit")
            if r != dz
                if c == 1
                    B[rowB, qubit] = B[rowB, qubit + dx] = B[rowB, qubit + 2 * dx - 1] = Fone
                    # println("$qubit $(qubit + dx) $(qubit + 2 * dx - 1)")
                    rowB += 1
                elseif c == dx
                    B[rowB, qubit] = B[rowB, qubit + dx - 1] = B[rowB, qubit + 2 * dx - 1] = Fone
                    # println("$qubit $(qubit + dx - 1) $(qubit + 2 * dx - 1)")
                    rowB += 1
                else
                    B[rowB, qubit] = B[rowB, qubit + dx - 1] = B[rowB, qubit + dx] = B[rowB, qubit + 2 * dx - 1] = Fone
                    # println("$qubit $(qubit + dx - 1) $(qubit + dx) $(qubit + 2 * dx - 1)")
                    rowB += 1
                end
            end

            if c != dx
                if r == 1
                    # println("$qubit $(qubit + 1) $(qubit + dx)")
                    A[rowA, qubit] = A[rowA, qubit + 1] = A[rowA, qubit + dx] = Fone
                    rowA += 1
                elseif r == dz
                    # println("$qubit $(qubit + 1) $(qubit - dx + 1)")
                    A[rowA, qubit] = A[rowA, qubit + 1] = A[rowA, qubit - dx + 1] = Fone
                    rowA += 1
                else
                    # println("$qubit $(qubit + 1) $(qubit + dx) $(qubit - dx + 1)")
                    A[rowA, qubit] = A[rowA, qubit + 1] = A[rowA, qubit + dx] = A[rowA, qubit - dx + 1] = Fone
                    rowA += 1
                end
            end
            qubit += 1
        end
        qubit += dx - 1
    end
    # display(A)
    # println(" ")
    # display(B)
    # println(" ")
    # display(A * transpose(B))
    S = CSSCode(A, B, missing)
    Eone = S.E(1)
    ω = gen(S.E)
    X1 = zero_matrix(S.E, 1, numV)
    for r in 1:2:dx
        X1[1, dz * (r - 1) + (dz - 1) * (r - 1) + 1] = Eone
    end
    Z1 = zero_matrix(S.E, 1, numV)
    for c in 1:dz
        Z1[1, c] = ω
    end
    S.logicals = [(X1, Z1)]
    S.dx = dx
    S.dz = dz
    S.d = minimum([dx, dz])
    return S
end
PlanarSurfaceCode(d::Int) = PlanarSurfaceCode(d, d)

################################
       # XY Surface Codes
################################

"""
    XYSurfaceCode(dx::Int, dz::Int)
    XYSurfaceCode(d::Int)

Return the `[[dx * dy + (dx - 1) * (dy - 1), 1, dx/dy]]` XY surface code of
"Ultrahigh Error Threshold for Surface Codes with Biased Noise" by Tuckett, Bartlett, and Flammia.

The top and bottom boundaries are "smooth" (`Y`) and the left and right are "rough" (`X`).
"""
function XYSurfaceCode(dx::Int, dy::Int)
    (2 <= dx && 2 <= dy) || throw(ArgumentError("Distances must be at least two."))

    E, ω = FiniteField(2, 2, "ω")
    Eone = E(1)
    numV = dx * dy + (dx - 1) * (dy - 1)
    M = zero_matrix(E, numV - 1, numV)
    qubit = 1
    row = 1
    for r in 1:dy
        for c in 1:dx
            if r != dz
                if c == 1
                    M[row, qubit] = M[row, qubit + dx] = M[row, qubit + 2 * dx - 1] = Eone + ω
                    row += 1
                elseif c == dx
                    M[row, qubit] = M[row, qubit + dx - 1] = M[row, qubit + 2 * dx - 1] = Eone + ω
                    row += 1
                else
                    M[row, qubit] = M[row, qubit + dx - 1] = M[row, qubit + dx] = M[row, qubit + 2 * dx - 1] = Eone + ω
                    row += 1
                end
            end

            if c != dx
                if r == 1
                    M[row, qubit] = M[row, qubit + 1] = M[row, qubit + dx] = Eone
                    row += 1
                elseif r == dz
                    M[row, qubit] = M[row, qubit + 1] = M[row, qubit - dx + 1] = Eone
                    row += 1
                else
                    M[row, qubit] = M[row, qubit + 1] = M[row, qubit + dx] = M[row, qubit - dx + 1] = Eone
                    row += 1
                end
            end
            qubit += 1
        end
        qubit += dx - 1
    end
    S = QuantumCode(M, false, missing)
    # Eone = S.E(1)
    # ω = gen(S.E)
    # X1 = zero_matrix(S.E, 1, numV)
    # for r in 1:2:dx
    #     X1[1, dz * (r - 1) + (dz - 1) * (r - 1) + 1] = Eone
    # end
    # Z1 = zero_matrix(S.E, 1, numV)
    # for c in 1:dz
    #     Z1[1, c] = ω
    # end
    # S.logicals = [(X1, Z1)]
    # S.dx = dx
    # S.dz = dz
    # S.d = minimum([dx, dz])
    return S
end
XYSurfaceCode(d::Int) = XYSurfaceCode(d, d)

# ################################
#          # XYZ^2 Codes
# ################################

# """
#     XYZ2Code(d::Int)

# Return the `[[2d^2, 1, d]]` XYZ^2 (XYZXYZ) code of "The XYZ^2 hexagonal stabilizer code"
# by Srivastava, Kockum, and Granath.
# """
# function XYZ2Code(d::Int)
#     3 <= d && isodd(d) || throw(ArgumentError("The distance must be an odd, positive integer."))

#     E, ω = FiniteField(2, 2, "ω")
#     Eone = E(1)
#     M = zero_matrix(E, 2 * d^2 - 1, 2 * d^2) # stars, X stabilizers
#     qubit = d + 1
#     row = 1
#     # comments refer to rotating Figure 1 of paper to the right by 45 degrees such that it's a rectangle
#     for r in 2:2 * d - 1
#         for c in 1:d
#             if isodd(r)
#                 # weight-3 stabilizers on bottom
#                 if r == 2 * d - 1 && isodd(c) && c != d
#                     M[row, qubit] = M[row, qubit + d] = M[row, qubit + d + 1] = Eone
#                     row += 1
#                 # weight-3 stabilizers on left
#                 elseif c == 1 && (r + 1) % 4 == 0 # r != 2 * d - 1 && - never need this since restricting to d odd
#                     M[row, qubit] = M[row, qubit - d] = M[row, qubit + d] = Eone
#                     row += 1
#                 end
#             else
#                 # full hex
#                 if c != d
#                     M[row, qubit] = M[row, qubit - d] = M[row, qubit + 1] =  M[row, qubit + d] = M[row, qubit + d + 1] = M[row, qubit + 2 * d + 1] = Eone
#                     row += 1
#                 end
#                 # weight-3 stabilizers on top
#                 if r == 2 && isodd(c) && c != 1
#                     M[row, qubit] = M[row, qubit - d] = M[row, qubit - d - 1] = Eone
#                     row += 1
#                 # weight-3 stabilizers on right
#                 elseif r != 2 && c == d && r % 4 == 0
#                     M[row, qubit] = M[row, qubit - d] = M[row, qubit + d] = Eone
#                     row += 1
#                 end
#             end
#             qubit += 1
#         end
#     end
#     display(M)
#     return
#     S.d = d
#     S.dx = d
#     S.dz = 2 * d^2
#     # Y distance is also 2 * d^2
# end

################################
           # H Codes
################################

function HCode(k::Int)
    (2 <= k && iseven(k)) || throw(ArgumentError("Input must be >= 2 and even."))    
    F, _ = FiniteField(2, 1, "α")
    Fone = F(1)
    X = zero_matrix(F, 2, k + 4)
    Z = zero_matrix(F, 2, k + 4)
    X[1, 1] = X[1, 2] = X[1, 3] = X[1, 4] = Fone
    Z[1, 1] = Z[1, 2] = Z[1, 3] = Z[1, 4] = Fone
    X[2, 1] = X[2, 2] = Fone
    Z[2, 1] = Z[2, 2] = Fone
    for c in 5:k + 4
        X[2, c] = X[2, c + 1] = Fone
        Z[2, c] = Z[2, c + 1] = Fone
    end
    return CSSCode(X, Z)
end
