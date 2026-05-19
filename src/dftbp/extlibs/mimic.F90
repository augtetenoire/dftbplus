! **************************************************************************************************
!>  MiMiC loop module
! **************************************************************************************************


MODULE mimic_loop

    USE mcl
    ! USE MPI
    USE dftbp_extlibs_mpifx
    USE dftbp_common_globalenv, only : globalMpiComm, abortProgram

    IMPLICIT NONE

    PRIVATE

    PUBLIC :: do_mimic_loop

    CONTAINS

! **************************************************************************************************
!>  The main loop for a MiMiC run
! **************************************************************************************************

    SUBROUTINE do_mimic_loop()

        LOGICAL :: is_last_step
        INTEGER :: request, server_id, client_id, ierr
        CHARACTER(LEN=32) :: request_str

        print *, 'I am in do_mimic_loop subroutine of mimic_loop module.'

        server_id = 0
        
        is_last_step = .FALSE.
        DO WHILE (.NOT. is_last_step)

            request = -1
            CALL mcl_receive(request, 1, MCL_REQUEST, server_id)
            print *, 'Received request:', request
            ! CALL MPI_Bcast(request, 1, MPI_INTEGER, 0, MPI_COMM_WORLD, ierr)
            ! CALL MPI_Bcast(request, 1, MPI_INTEGER, 0, globalMpiComm, ierr)
            call mpifx_bcast(globalMpiComm, request, error=ierr)
            
            print *, 'request broadcasted:', request
            print *, 'request broadcasted:', mcl_get_request_name(request)
            
            

            SELECT CASE (request)
            CASE (MCL_SEND_CLIENT_ID)
                call mcl_get_program_id(client_id)
                call mcl_send(client_id, 1, MCL_DATA, server_id)
                
            CASE (MCL_EXIT)
                is_last_step = .TRUE.
            CASE DEFAULT
                WRITE (request_str, "(I0)") request
                ! CALL error("Unrecognized MiMiC request: " // TRIM(request_str))
                call abortProgram()
            END SELECT

        END DO

        ! CALL mimic_comm%finalize()

    END SUBROUTINE do_mimic_loop

 END MODULE mimic_loop