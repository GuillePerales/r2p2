(define (domain rover-Mars)
    (:requirements :strips :typing :negative-preconditions) ; requerimientos
    (:types location) ; tipos
    (:predicates ; predicados 
        (at ?l - location)
        (accessible ?l1 ?l2 - location)
        (moving)
        (picture_taken ?l - location)
        (drilled ?l - location)        
        (communicated)
        (analysed ?l - location)
    )
    ; acciones
    (:action move
        :parameters
            (?from - location
            ?to - location)        
        :precondition
          (and
            (not(moving))
            (at ?from); posición inicial
            (accessible ?from ?to); la meta es accesible desde la posición inical
          )
        :effect
          (and
            (moving)
            (not(moving))
            (not (at ?from)); ya no está en la posción inicial
            (at ?to) ;destino
          )
	)

  (:action take_picture
    :parameters
      (?l - location)
    :precondition
      (and
              (at  ?l);esta en el lugar indicado
              (not (moving));está quieto
              (not (picture_taken ?l));todavía no ha tomado la foto 
      )
      :effect
        (and
            (picture_taken ?l);Se hace la foto
        )
  )

  (:action drill
    :parameters
      (?l - location)
    :precondition
      (and
          (at  ?l);esta en el lugar indicado
          (not (moving));está quieto
          (not (drilled ?l));no ha taladrado aun
      )
      :effect
        (and
            (drilled ?l);todavía no ha taladrado
        )
  )

  (:action communicate_earth
    :parameters
      ()
    :precondition
      (and
          (not (moving));está quieto
      )
      :effect
        (and
            (communicated)
        )
  )

  (:action analyse_sample
    :parameters
      (?l - location)
    :precondition
        (and
            (at  ?l); esta en el lugar indicado
            (not (moving));está quieto
            (not (analysed ?l));todavía no ha tomado la muestra
        )
    :effect
          (and
              (analysed ?l);se analiza
          )
  )
)
