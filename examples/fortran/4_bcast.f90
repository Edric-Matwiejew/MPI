program collective_bcast

    use mpi

    implicit none

    real(8), dimension(3) :: array

    integer :: rank
    integer :: ierr

    call mpi_init(ierr)
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
    
    if (rank == 0) then
        call random_number(array)    
    endif

    call mpi_bcast(array, 3, MPI_DOUBLE, 0, MPI_COMM_WORLD, ierr)

    write(*,*) array
    
    call mpi_finalize(ierr)

end program collective_bcast
