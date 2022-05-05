from mpi4py import MPI
import numpy as np

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()
size = COMM.Get_size()

send_array = np.array([rank], dtype = np.int)
recv_array = np.empty(1, dtype = np.int)

if rank == 0:

    COMM.Isend(
            [send_array, MPI.INT],
            dest = 1,
            tag = rank)

    COMM.Irecv(
            [recv_array, MPI.INT],
            source = size - 1,
            tag = size - 1)

elif rank == size - 1:

    COMM.Isend(
            [send_array,MPI.INT],
            dest = 0,
            tag = rank)

    COMM.Irecv(
            [recv_array, MPI.INT],
            source = rank - 1,
            tag = rank - 1)

else:

    COMM.Isend(
            [send_array, MPI.INT],
            dest = rank + 1,
            tag = rank)

    COMM.Irecv(
            [recv_array, MPI.INT],
            source = rank - 1,
            tag = rank - 1)


COMM.barrier()

print("rank {} recieved {}".format(rank, recv_array))
