# Assignment 9

 

For this assignment you will write an MPI program to solve the Laplace equation using Jacobi iteration and the parallel partitioning scheme described in the lecture slides.

 

Part 1 covers the MPI functions and program fragments required to implement the parallel algorithm. In part 2 you are asked to implement the alogorithm and compare it qualitatively to a provided result. Finally, in part three you will transfer your program to the QUISA workstation and examine its parallel performence.

 

 

 

### 1. (a) (marks 5)

 

The program shown below contains two bugs, identify the errors and correct them so the code executes successfully.

 

The program is designed for two MPI processes and should print "[0,0]" from rank 1 on completion.

 

```python

from mpi4py import MPI

import numpy as np

 

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()

 

if rank == 0:

    send_array = np.array(2*[rank], dtype = np.int)

 

if rank == 0:

    COMM.Send([send_array, MPI.INT], dest = 1)

else:

    COMM.Recv([recv_array, MPI.INT], source = 1)

    print(recv_array)

```

 

### 1. (b)

 

Starting with the following 2-dimensional array at rank 0:

 

```python

n = 3

 

COMM = MPI.COMM_WORLD

 

rank = COMM.Get_rank()

size = COMM.Get_size()

 

if rank == 0:

    A = np.zeros((size*n, size*n), dtype = np.float64)

 

    for i in range(n*size):

        A[i,:] = i

```

 

Write an MPI program that carries our the following steps:

 

1. At rank 0, partition a into `size` row-wise partitions with `n` rows each and store the partitions in a numpy array of dimensions `(size, n, size*n)`.

3. Use Scatter to send an `(n, size*n)` row partion from rank 0 to each process in the communicator. Recieve this partition into an `(n, size*n)` NumPy array `local_array`.

4. At each rank, compute `local_array  += rank`, and print the results using:

 

```python

print(local_array,'\n', flush = True)

```

 

With `n=3` and 3 MPI processes the expected output is:

 

Rank 0:

```

[[0 0 0 0 0 0 0 0 0]

[1 1 1 1 1 1 1 1 1]

[2 2 2 2 2 2 2 2 2]]

```

Rank 1:

```

[[4 4 4 4 4 4 4 4 4]

[5 5 5 5 5 5 5 5 5]

[6 6 6 6 6 6 6 6 6]]

```

Rank:2

```

[[ 8  8  8  8  8  8  8  8  8]

[ 9  9  9  9  9  9  9  9  9]

[10 10 10 10 10 10 10 10 10]]

```

 

### 1. (c)

 

Adding on to your code from 1 (b), implement a single pass of the communication pattern shown on slide 28 of the Lecture slides. Store incoming values from the 'above' rank in an a NumPy array `upper`, and those coming from a 'below' rank in the NumPy array `lower`.

 

The code below defines `lower` and `upper`, and partitally implements communication of the `upper` values. Use this as a starting point.

 

```python

 

if rank > 0:

    upper = np.empty(size*n, dtype = np.float64)

if rank < size - 1:

    lower = np.empty(size*n, dtype = np.float64)

 

 

if rank == 0:

 

    COMM.Send([local_array[-1,:], MPI.DOUBLE], dest = 1)

 

if rank > 0 and rank < size - 1:

 

    COMM.Recv([upper, MPI.DOUBLE], source = rank - 1)

    COMM.Send([local_array[-1,:], MPI.DOUBLE], dest = rank + 1)

```

 

For each MPI process, at the values of `lower` and `upper` to the rows of `local_array`, as shown below.

 

 

```python

for i in range(local_array.shape[0]):

    local_array[i,:] += lower

    local_array[i,:] += upper

```

 

If only `lower` or `upper` were sent to the MPI process, add them only.

 

Place an barrier (`COMM.Barrier()`) to keep the output of this question seperate from 1 (a) and print `local_array` at each rank using:

 

```python

print(local_array, '\n', flush = True)

```

For `n=3` and 3 MPI processes the expected output is:

 

Rank 0:

```

[[4 4 4 4 4 4 4 4 4]

[5 5 5 5 5 5 5 5 5]

[6 6 6 6 6 6 6 6 6]]

```

Rank 1:

```

[[14 14 14 14 14 14 14 14 14]

[15 15 15 15 15 15 15 15 15]

[16 16 16 16 16 16 16 16 16]]

```

Rank:2

```

[[14 14 14 14 14 14 14 14 14]

[15 15 15 15 15 15 15 15 15]

[16 16 16 16 16 16 16 16 16]]

```

 

### 1 (d):

 

Take the average of the all of the elements in the `local_array` and store the averages in an array of length `size` called `averages`. Use `Gather` to collect the averages to `rank=0`.

 

Use the code snippet below to calculate the sum of the averages and then broadcast the sum to each process in `COMM_WORLD`. 

 

```python

if rank == 0:

    average_sum = 0

    for av in averages:

        average_sum += av

else:

    average_sum = None

average_sum = COMM.bcast(average_sum, root = 0)

 

print(average_sum, flush = True)

```

 

Again use a `COMM.Barrier()` to keep this output seperate from the rest of the questions.

 

 

### 1 (e)

 

Use `COMM.Gather` to gather `local_array` to the `rank = 0`. At rank = 0, reshape the the recieved array into a matrix of dimensions `(2, 2)` using the NumPy `reshape` function.

 

### 2 (marks 3):

 

Writes function that performs Jocobi iteration on a 2D array. It should take a 2D array as input, and return the updated array, and the error (epsilon in the slides).

 

Use this 'kernel' in combination with the MPI code written in part 1 to implement a parallel Laplace solver.

 

Solve for a system of `60 x 60` vertices the Laplace equation with initial conditions:

 

```python

m=np.zeros((num_points,num_points),dtype=float)

pi_c=np.pi

x = np.linspace(0,pi_c,num_points)

m[0,:]=np.sin(x)

m[num_points-1,:]=np.sin(x)

```

 

Define array `m` ar `rank = 0` and distribute the array following the method you used in question 1 (b).

Plot your solution using the matplotlib function `matshow` and compare your result to `part_2_expected_output.png`. They should appear (very) similar.

 

### 3 (marks 2):

 

Transfer your code to the QUISA workstation. Using the example *.slurm file as a template, run your code on 2, 4, 6, 8 and 16 processes. Time the program wall time using `time`, as shown in the slurm file.

 

Start off with a grid of size `(1000 x 1000)`. If that that takes too long, work down from there.

 
