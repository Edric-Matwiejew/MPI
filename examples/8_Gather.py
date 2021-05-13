

from mpi4py import MPI
import numpy as np

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()
size = COMM.Get_size()

array_local = np.empty(2, dtype = np.float64)

array_local[:] = rank

if rank == 0:
    array_global = np.empty(2*size, dtype = np.float64)
else:
    array_global = None

# Must be a multiple

COMM.Gather(
        [array_local, MPI.DOUBLE],
        [array_global, MPI.DOUBLE],
        root = 0)

if rank == 0:
    print(array_global)
