# SHPC4001 MPI Workshop

## Part 1: Job Scheduling and Environment Modules.

### 1. (a)

Log on to the QUISA workstation and read through the tutorials 'Using Environment Modules' and 'Job scheduling with Slurm'.

### 1. (b)

Apply the commands and concepts introduced in (a) to:

* Look at the modules available on the workstation.
* Load the python module.
* Check the status of the node using 'sinfo'.
* Look at the list of jobs that are queued or running on the workstation.
* Compile and run 'examples/fortran/1\_hello\_mpi.f90' on 2 CPU cores in an interactive Slurm session.
* Comile and run 'examples.fortran/2\_point\_to\_point.f90' on 2 CPU cores using a slurm script and view the program's output.



## Part 2: Using MPI in Python.

This workshop will introduce you to the MPI functions and program fragments needed to solve the Laplace equation using Jacobi iteration and the parallel partitioning scheme described in the lecture slides.


### 2. (a)

 

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

 

### 2. (b)

 

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

 

### 2. (c)

 

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

 

### 2 (d):

 

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

