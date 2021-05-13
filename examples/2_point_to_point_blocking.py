from mpi4py import MPI

COMM = MPI.COMM_WORLD

rank = COMM.Get_rank()

if rank == 0:
    data = {'a':2, 'b':3}
    COMM.send(data, dest = 1)

if rank == 1:
    data = COMM.recv(source = 0)
    print(data)
