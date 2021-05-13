from mpi4py import MPI

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()

print("Hello world from rank {}".format(rank))



