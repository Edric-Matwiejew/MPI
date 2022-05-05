program collective_gather_scatter

    use mpi

    implicit none

    integer, dimension(:,:), allocatable :: send_array
    integer, dimension(:,:), allocatable :: gather_array
    integer, dimension(3) :: recv_array

    integer :: i, j
    integer :: n_ranks
    integer :: rank
    integer :: ierr

    call mpi_init(ierr)
    call mpi_comm_rank(MPI_COMM_WORLD, rank, ierr)
    call mpi_comm_size(MPI_COMM_WORLD, n_ranks, ierr)

    if (rank == 0) then
        allocate(send_array(3, n_ranks)) 
        do i = 1, n_ranks
            send_array(:, i) = i - 1
        enddo 
    endif

    call mpi_scatter(send_array, 3, MPI_INTEGER, recv_array, 3, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

    !write(*,*) rank, recv_array

    recv_array = recv_array + rank

    if (rank == 0) then
        allocate(gather_array(3, n_ranks))
    endif

    call mpi_gather(recv_array, 3, MPI_INTEGER, gather_array, 3, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)

    if (rank == 0) then
        do i = 1, n_ranks
            write(*,*) gather_array(:, i)
        enddo
    endif
        
    call mpi_finalize(ierr)

end program collective_gather_scatter
