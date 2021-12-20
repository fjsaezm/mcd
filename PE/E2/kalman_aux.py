#
#  Project: Auxiliary code for the Stochastic Systems class
#  File:    kalman-aux.py
#  Vers.    1.0
#  Date:    11/26/2021
#
#  
#  Utility function that builds a matrix with given eigenvalues. This
#  is to be used to obtain the matrix A of the dynamic system that we
#  shall try to control with a Kalman filter.
#
#  The dimensionality of tha matrix will be congruent with the number
#  of eigenvalues that are desired. Note that there is a plethora
#  (viz., an infinite number) of matrices with the given eigenvalues,
#  depending on whet the eigenvectors are. This program will just
#  build one.
#
#  And... yes... I know... I could have done this in an easier way
#  using numpy. I didn't use it for two reasons:
#
#  i) I don't like to create dependencies on libraries just to do
#     something simple. A dependency on a library represents a cost
#     for that program, and a loss of self-standinghood (the word
#     doesn't exist, but it should). It is a price that I am not
#     wiling to pay to do something as simple as a few vector
#     multiplications.
#
#  ii) If I do something myself, I understand it better than having a
#      black box do it for me. Since this is not a production system,
#      I put a premium on understaning.
#
#  (C) Simone Santini, 2021
#

import math
import random
import numpy as np

#########################################################################
#
#   A U X I L I A R Y    F U N C T I O N S
#
#


#
# Cross product of two vectors. No check is made to ensure that the
# two have the same dimension so, whach out!
#
def cross(x, y):
    return sum([a*b for (a,b) in zip(x, y)])

#
# Normalizes a vector. Returns a copy of teh vector with norm equal to
# one.
#
def norm(x):
    q = math.sqrt(sum([a*a for a in x]))
    return [a/q for a in x]

#
# Auxiliary function for the Grahm-Schmidt method: takes two vectors
# and returns a vector that is equal to the first minus the second
# multiplied by the cross product of the two
#
def minus_proj(x, y):
    q = sum([a*b for (a,b) in zip(x, y)])
    w = [a-q*b for (a,b) in zip(x, y)]
    return w

#
# Multiplies two matrices. Dimensions are checked for consistency (Why
# do I do it here and not in the scalar product of two vectors?
# Well... because it suited me to do it that way. Any problem? Do you
# want a piece of me? :D)
#
#
def mulmat(A, B):
    if len(A[0]) != len(B):
        print("Matrix multiplication error")
        sys.exit(1)
    n = len(A)
    u = len(A[0])
    m = len(B[0])
    R = [[0.0 for _ in range(m)] for _ in range(n)]
    for i in range(n):
        for j in range(m):
            for k in range(u):
                R[i][j] = R[i][j] + A[i][k]*B[k][j]
    return np.array(R)
    

#
# Multiply a matrix by a vector. In principle, of course, this coule
# be done using mulmat, but this function is more convenient. This
# function takes the vector as a list, while in order to use mulmat
# one should consider it a matrix. That is, if A is a 3x3 matrix, you
# can vall mulvec as
#
#   q = mulvec(A, [v1, v2, v3])
#
# while you should call mulmat as
#
#   q = mulmat(A, [[v1], [v2], [v3]])
#
# which is kin of a pain in the neck
#
def mulvec(A, v):
    if len(A[0]) != len(v):
        print("Vector multiplication error")
        sys.exit(1)
    n = len(A)
    u = len(A[0])
    R = [0.0 for _ in range(n)]
    for i in range(n):
        for k in range(u):
            R[i] = R[i] + A[i][k]*v[k]
    return np.array(R)


#
#  Builds an unitary matrix of given dimension. This is a bit
#  tricky. The idea is to start with a generic matrix, considering its
#  columns as vectors, and apply normalization and Grahm-Schmidt to
#  obtain a matrix with normalized, orthogonal vectors in the
#  columns. This, of course, can be done as long as the original
#  matrix is non-singular. But, how can we guarantee that?
#
#  Since this is a didactic program and no lives will be lost if it
#  fails, I decided to adopt the simpler and most obvious solution: I
#  generate a random matrix and hope for the best. Singular matrices
#  in low dimensions (we are not going to use this to create huge
#  matrices) are relatively rare so, crossing our fingers, things
#  should work out quite fine.
#
#  Another minor point:the matrix that we are to produce has to have
#  vectors in the columns, but the matrix with the initial vectors has
#  vectors in the rows, as this is simpler to manage in python. The
#  final orthogonal matrix will then be transposed to obtain the
#  vectors on the columns, as per standard.
#
#
#   Returns:
#
#   (U, UT)
#
#   where U is the unitary matrix with the vectors in the columns, and
#   UT its transpose (we need them both to compute the final matrix)
#
def mk_ortho(n):
    V0 = [ [random.uniform(-2*n,2*n) for _ in range(n)] for _ in range(n)]

    UT = [norm(V0[0])]

    for k in range(1,n):
        v = norm(V0[k])
        for i in range(k):
            v = minus_proj(v, UT[i])
        v = norm(v)
        UT = UT + [v]

    U = np.array([[UT[j][i] for j in range(n)] for i in range(n)])
    return (U, np.array(UT))


#########################################################################
#
#   P U B L I C    F U N C T I O N S   A N D   C O N S T A N T S
#
#

#
# Given a list of n values, creates a nxn matrix (non-trivial: it will
# not be a diagonal matrix) with those values as eigenvalues.
#
def mk_mat(lb):
    n = len(lb)
    L = [ [0.0 for _ in range(n)] for _ in range(n)]
    for k in range(n):
        L[k][k] = lb[k]
    (U, UT) = mk_ortho(n)
    A = mulmat(U, mulmat(L, UT))
    return np.array(A)

Tstep = 50

#
# Just in case you need it, this is a function that defines the input
# u
#
def u_f(t):
    return 0.0 if t < Tstep else 1.0


#
# The matrices B and C are fixed, the matrix A must be defined using
# the function mk_mat.
#
#
# Note that this is not really the atrix B, it is the transpose of B. 
#
# I write it in this way because it was easier for me to implement the
# system considering that all the vectors were rows, so as to avoid
# awkward lists of lists definition. If it is more convenient for your
# implementation to define it as a column, you can define it as 
#
#B = [[1.0],
#     [1.0],
#     [1.0],
#     [1.0]
#     ]

B = np.array([1.0, 1.0, 1.0, 1.0])

C = np.array([ [1.0, 0.0, 0.0, 0.0],
      [0.0, 1.0, 0.0, 0.0]
    ])

#
# This is an example of matrix A. You will have to generate your own
# using the eigenvalues specified in the text

eigens = [0.6, 0.3, 0.2, -0.2]   # This is just an example, NOT one of the lists of eigenvectors of the assignment

A = np.array(mk_mat(eigens))

#
#  Variance of the input noise, and covariance matrix
#
sigma_w = 0.1

Q = np.array([ [(sigma_w if i == j else 0.0) for i in range(4)] for j in range(4)])


#
#  Variance of the output noise, and covariance matrix
#
sigma_v = 0.1

R = np.array([ [(sigma_v if i == j else 0.0) for i in range(2)] for j in range(2)])

