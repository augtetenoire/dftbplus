! **************************************************************************************************
! This module serves to dev the mimic loop and the corresponding subroutines
! **************************************************************************************************




! **************************************************************************************************
!>  MiMiC communicator subroutines in the module
! **************************************************************************************************

MODULE mimic_communicator

    IMPLICIT NONE

    PRIVATE



 END MODULE mimic_communicator

! **************************************************************************************************
!>  MiMiC loop module
! **************************************************************************************************


MODULE mimic_loop

    IMPLICIT NONE

    PRIVATE

    PUBLIC :: do_mimic_loop

CONTAINS

! **************************************************************************************************
!>  The main loop for a MiMiC run
! **************************************************************************************************

    SUBROUTINE do_mimic_loop()

        LOGICAL :: is_last_step

        print *, 'I am in do_mimic_loop subroutine of mimic_loop module.'
        stop
        
        is_last_step = .FALSE.
        ! DO WHILE (.NOT. is_last_step)

        !     request = mimic_comm%receive_request()
        !     SELECT CASE (request)
        !     CASE (MCL_SEND_CLIENT_ID)
        !         CALL mimic_comm%send_client_info("id")

        !     CASE (MCL_EXIT)
        !         is_last_step = .TRUE.
        !     CASE DEFAULT
        !         WRITE (request_str, "(I0)") request
        !         CPABORT("Unrecognized MiMiC request: "//TRIM(request_str))
        !     END SELECT

        ! END DO

        ! CALL mimic_comm%finalize()

    END SUBROUTINE do_mimic_loop

 END MODULE mimic_loop