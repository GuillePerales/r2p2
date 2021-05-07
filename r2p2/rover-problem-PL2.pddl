(define (problem rover)
    (:domain rover-Mars)
    (:objects ; objetos
        P0506 P0304 P0503 P0307 P0102 - location
    )

    (:init ; estado inicial
        (at P0506) 
        (accessible  P0506 P0304)
        (accessible  P0506 P0503)
        (accessible  P0304 P0503)
        (accessible  P0506 P0307)
        (accessible  P0506 P0102)
        (accessible  P0304 P0307)
        (accessible  P0304 P0102)
        (accessible  P0503 P0307)
        (accessible  P0503 P0102)
        (accessible  P0307 P0102)

        (dangerous P0307)
        (dangerous P0102)

        (=(slow_speed)15)
        (=(fast_speed)30)

        (=(distance P0506 P0304)1)
        (=(distance P0506 P0503)2)
        (=(distance P0506 P0307)3)
        (=(distance P0506 P0102)4)

        (=(distance P0304 P0503)1)
        (=(distance P0304 P0307)2)
        (=(distance P0304 P0102)3)

        (=(distance P0503 P0307)1)
        (=(distance P0503 P0102)2)

        (=(distance P0307 P0102)1)


        (=(battery) 100) ;Empieza con la batería al 100%
        (=(used_battery) 0)
        
        (=(battery_required_move_slow P0506 P0304)25)
        (=(battery_required_move_slow P0506 P0503)25)
        (=(battery_required_move_slow P0304 P0503)25)

        (=(battery_required_move_fast P0506 P0304)45)
        (=(battery_required_move_fast P0506 P0503)45)
        (=(battery_required_move_fast P0304 P0503)45)
        
        (=(battery_required_take_picture)10)
        (=(battery_required_drill)10)
        (=(battery_required_communicate_earth)10)
        (=(battery_required_analyse_sample)10)
    )

    (:goal (and ; estado meta
                (analysed P0503)
                (picture_taken P0503)
                (drilled P0503)
                (communicated)
                (analysed P0304)
                (analysed P0506)
                (communicated)
            )
    )

    (:constraints 
        (and
            ;(preference placed (always(not(dangerous P0506)))) ; SGPLan solo permite una preferencia a la vez                  
                                                                ; Optic no funciona pero por tener precondiciones negadas
            (preference picture (sometime(picture_taken P0506))) ;P0506 sería como X=5 Y=6      
        )
    )
    
)
