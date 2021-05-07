(define (domain rover-Mars)
    (:requirements :strips :typing :negative-preconditions :durative-actions :fluents :constraints :preferences) ; requerimientos
    (:types location) ; tipos
    (:predicates ; predicados 
        (at ?l - location)
        (accessible ?from ?to - location)
        (moving)
        (picture_taken ?l - location)
        (drilled ?l - location)        
        (communicated)
        (analysed ?l - location)
        (dangerous ?l - location)
)
    ;funciones
    (:functions
      (battery)
      (used_battery)      
      (battery_required_move_slow ?from ?to - location)
      (battery_required_move_fast ?from ?to - location)
      (battery_required_take_picture)
      (battery_required_drill)
      (battery_required_communicate_earth)
      (battery_required_analyse_sample)
      (distance ?from - location ?to - location)
      (slow_speed) 
      (fast_speed)
      
)
    ; acciones
    (:durative-action move-slow
        :parameters (?from - location ?to - location)
        :duration (= ?duration (/ (distance ?from ?to) (slow_speed))) ;duración variable        
        :condition
          (and
            (at start (not(moving)))
            (at start (at ?from)); posición inicial
            (over all (accessible ?from ?to))
            (at start (>= (battery) (battery_required_move_slow ?from ?to)))
            (over all (not(dangerous ?to)))
            ;(at start (>= (battery) (umbral_bateria))))
          )
        :effect
            (and
              (at start (moving))
              (at end (not(moving)))
              (at end (not (at ?from)))
              (at end (at ?to)) 
              (at end(decrease (battery)(battery_required_move_slow ?from ?to)))
              (at end(increase (used_battery)(battery_required_move_slow ?from ?to)))
            )
    )

    (:durative-action move-fast
        :parameters (?from - location ?to - location)
        :duration (= ?duration (/ (distance ?from ?to) (fast_speed))) ;duración variable    
        :condition
          (and
            (at start (not(moving)))
            (at start (at ?from)); posición inicial
            (over all (accessible ?from ?to))
            (at start (>= (battery) (battery_required_move_fast ?from ?to)))
            (over all (not(dangerous ?to)))
            ;(at start (>= (battery) (umbral_bateria))))
          )
        :effect
            (and
                (at start (moving))
                (at end (not(moving)))
                (at end (not (at ?from)))
                (at end (at ?to)) 
                (at end(decrease (battery)(battery_required_move_fast ?from ?to)))
                (at end(increase (used_battery)(battery_required_move_fast ?from ?to)))
            )
    )

  (:durative-action take_picture
    :parameters (?l - location)
    :duration (= ?duration 1) ;duración fija
    :condition
      (and
          (over all(at ?l))
          (at start(not (moving))) 
          (at start(not (picture_taken ?l))) 
          (at start (>= (battery) (battery_required_take_picture)))
      )
      :effect
        (and
          (at end(picture_taken ?l))
          (at end(decrease (battery)(battery_required_take_picture)))
          (at end(increase (used_battery)(battery_required_take_picture)))
        )
  )

  (:durative-action drill
    :parameters (?l - location)
    :duration (= ?duration 1) ;duración fija
    :condition
      (and
        (over all(at ?l))
        (at start(not (moving)))
        (at start(not (drilled ?l)))
        (at start (>= (battery) (battery_required_drill)))
      )
      :effect
        (and
          (at end(drilled ?l))
          (at end(decrease (battery)(battery_required_drill)))
          (at end(increase (used_battery)(battery_required_drill)))
        )
  )

  (:durative-action communicate_earth
    :parameters ()
    :duration (= ?duration 1) ;duración fija
    :condition    
      (and
        (over all(not (moving)))
        (at start (>= (battery) (battery_required_communicate_earth)))
      )
      :effect
        (and
          (at end(communicated))
          (at end(decrease (battery)(battery_required_communicate_earth)))
          (at end(increase (used_battery)(battery_required_communicate_earth)))
        )
  )

  (:durative-action analyse_sample
    :parameters (?l - location)
    :duration (= ?duration 1) ;duración fija
    :condition
        (and
            (over all(at  ?l))
            (over all(not (moving)))
            (at start(not (analysed ?l)))
            (at start (>= (battery) (battery_required_analyse_sample)))
        )
    :effect
          (and
            (at end(analysed ?l))
            (at end(decrease (battery)(battery_required_analyse_sample)))
            (at end(increase (used_battery)(battery_required_analyse_sample)))
          )
  )

  (:durative-action recharge_battery
      :parameters ()
      :duration (= ?duration (- (used_battery) (battery))) ;duración variable
      :condition 
              (and
                (at start (>(battery)20)) ;Cuando tenga menos de 20% de batería, esta se recargará
                (at start (not (moving)))
              )
      :effect 
            (and 
              (at end (assign(battery) 100)) ;Asginar el 100% de batería
            )
  )  
)
