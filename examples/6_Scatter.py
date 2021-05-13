

from mpi4py import MPI
import numpy as np

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()
size = COMM.Get_size()

array_local = np.empty(2, dtype = np.float64)

if rank == 0:
    array_global = np.linspace(0,25,2*size)
    print(array_global,flush = True)
else:
    array_global = None

COMM.Scatter(
        [array_global, MPI.DOUBLE],
        [array_local, MPI.DOUBLE],
        root = 0)

print(array_local)



