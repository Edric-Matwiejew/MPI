program reduction

    use mpi

    implicit none

    real(8), dimension(3) :: array
    real(8), dimension(3) :: array_sum

    integer :: rank
    integer :: ierr

    call mpi_init(ierr)
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
    
    array = rank

    call mpi_reduce(array, array_sum, 3, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    if (rank == 0) then
        write(*,*) array_sum
    endif
    
    call mpi_finalize(ierr)

end program reduction
