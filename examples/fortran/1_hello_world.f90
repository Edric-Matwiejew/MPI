program hello_world

    use mpi

    implicit none

    integer :: ierr
    integer :: rank

    call mpi_init(ierr)

    call mpi_comm_rank(mpi_comm_world, rank, ierr)

    write(*,*) "Hello world from rank", rank

    call mpi_finalize(ierr)

end program hello_world
