program point_to_point

    use mpi

    implicit none

    integer, dimension(2) :: array 

    integer :: mpi_size
    integer :: rank
    integer :: mpi_status(MPI_STATUS_SIZE)
    integer :: ierr

    call mpi_init(ierr)
    
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)

    if (rank == 0) then
        array = 42
        call mpi_send(array, size(array), MPI_INTEGER, & 
                      1, 10, MPI_COMM_WORLD, ierr)
    elseif (rank == 1) then
        call mpi_recv(array, size(array), MPI_INTEGER, &
                0, 10, MPI_COMM_WORLD, mpi_status, ierr)
    endif

    if (rank == 1) then
        write(*,*) array
    endif
        
    call mpi_finalize(ierr)

end program point_to_point
