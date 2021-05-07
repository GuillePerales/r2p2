(define (problem rover)
    (:domain rover-Mars)
    (:objects ; objetos
        P0506 P0304 P0503 - location
    )

    (:init ; estado inicial
        (at P0506) 
        (accessible  P0506 P0304)
        (accessible  P0506 P0503)
        (accessible  P0304 P0503)
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
)
