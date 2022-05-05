

from mpi4py import MPI
import numpy as np

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()
size = COMM.Get_size()

array_local = np.array(size*[rank], dtype = np.float64)

if rank == 0:
    array_reduced = np.empty(size, dtype = np.float64)
else:
    array_reduced= None

# Must be a multiple

COMM.Reduce(
        [array_local, MPI.DOUBLE],
        [array_reduced, MPI.DOUBLE],
        op = MPI.SUM,
        root = 0)

if rank == 0:
    print(array_reduced)



