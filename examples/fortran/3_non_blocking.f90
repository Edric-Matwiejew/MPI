program non_blocking

    use mpi

    implicit none

    integer, dimension(:), allocatable :: array 
    integer :: i
    integer :: n_ranks
    integer :: rank
    integer, dimension(:), allocatable :: mpi_request_send
    integer, dimension(:), allocatable ::, mpi_request_recv
    integer :: mpi_status(MPI_STATUS_SIZE)
    integer :: ierr

    call mpi_init(ierr)
    
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
    call mpi_comm_size(MPI_COMM_WORLD, n_ranks, ierr)

    allocate(array(n_ranks))
    allocate(mpi_request_send(n_ranks))
    allocate(mpi_request_recv(n_ranks))

    array(rank + 1) = rank

    do i = 1,  n_ranks
        if (i - 1 /= rank) then
            call mpi_isend(array(rank + 1), 1, MPI_INTEGER, &
                 i - 1, rank*10 + (i - 1), MPI_COMM_WORLD, &
                 mpi_request_send(i), ierr)
        endif
    enddo
    
    do i = 1, n_ranks
        if (i - 1 /= rank) then
            call mpi_irecv(array(i), 1, MPI_INTEGER, &
                 i - 1, (i - 1) * 10 + rank, MPI_COMM_WORLD, &
                 mpi_request_recv(i), ierr)
        endif
    enddo

    do i = 1, n_ranks 
        if (i - 1 /= rank) then
            call mpi_wait(mpi_request_recv(i), mpi_status, ierr)
        endif
    enddo

    if (rank == 0) then
        write(*,*) array
    endif
 
    if (rank == 1) then
        write(*,*) array
    endif
        
    call mpi_finalize(ierr)

end program non_blocking
