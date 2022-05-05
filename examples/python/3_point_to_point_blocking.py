from mpi4py import MPI
import numpy as np

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()

array = np.empty(5, dtype = np.float64)

if rank == 0:
    array[:] = np.linspace(0,1,5)
    COMM.Send([array, MPI.DOUBLE], dest = 1)

if rank == 1:
    COMM.Recv([array, MPI.DOUBLE], source = 0)
    print("Array received at rank {}: {}".format(rank, array))
