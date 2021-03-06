      ALLOCATE( AP( LM+1 ), STAT=STATUS ); VERIFY_(STATUS)
      AP = 1d0

      ALLOCATE( BP( LM+1 ), STAT=STATUS ); VERIFY_(STATUS)
      BP = 0d0

#if   defined( GEOS_5 ) || defined( MERRA ) || defined( GEOS_FP )

      !=================================================================
      ! GEOS-5/MERRA vertical coordinates (47 or 72 levels)
      !=================================================================

#if   defined( GRIDREDUCED )

      !-----------------------------------------------------------------
      ! GEOS-5/MERRA 47-level reduced vertical grid
      !  
      !  Bottom   Bottom    # levels
      !  edge of  edge prs  lumped 
      !  level    (hPa)     together
      !
      !   PTOP       0.010   
      !    47        0.066     4
      !    46        0.211     4
      !    45        0.617     4
      !    44        1.651     4
      !    43        4.077     4
      !    42        9.293     4
      !    41       19.792     4
      !    40       28.368     2
      !    39       40.175     2
      !    38       56.388     2
      !    37       78.512     2
      ! %%%% START LUMPING LEVELS ABOVE HERE %%%%%
      !    36       92.366       
      !    35      108.663
      !    34      127.837
      !    33      150.393
      !    32      176.930
      ! %%%% FIXED-PRESSURE LEVELS BEGIN HERE %%%%
      !-----------------------------------------------------------------

      ! Ap [hPa] for 47 levels (48 edges)
      AP = (/ 0.000000d+00, 4.804826d-02, 6.593752d+00, 1.313480d+01, &
              1.961311d+01, 2.609201d+01, 3.257081d+01, 3.898201d+01, &
              4.533901d+01, 5.169611d+01, 5.805321d+01, 6.436264d+01, &
              7.062198d+01, 7.883422d+01, 8.909992d+01, 9.936521d+01, &
              1.091817d+02, 1.189586d+02, 1.286959d+02, 1.429100d+02, &
              1.562600d+02, 1.696090d+02, 1.816190d+02, 1.930970d+02, &
              2.032590d+02, 2.121500d+02, 2.187760d+02, 2.238980d+02, &
              2.243630d+02, 2.168650d+02, 2.011920d+02, 1.769300d+02, &
              1.503930d+02, 1.278370d+02, 1.086630d+02, 9.236572d+01, &
              7.851231d+01, 5.638791d+01, 4.017541d+01, 2.836781d+01,  &
              1.979160d+01, 9.292942d+00, 4.076571d+00, 1.650790d+00,  &
              6.167791d-01, 2.113490d-01, 6.600001d-02, 1.000000d-02 /)

      ! Bp [unitless] for 47 levels (48 edges)
      BP = (/ 1.000000d+00, 9.849520d-01, 9.634060d-01, 9.418650d-01, &
              9.203870d-01, 8.989080d-01, 8.774290d-01, 8.560180d-01, &
              8.346609d-01, 8.133039d-01, 7.919469d-01, 7.706375d-01, &
              7.493782d-01, 7.211660d-01, 6.858999d-01, 6.506349d-01, &
              6.158184d-01, 5.810415d-01, 5.463042d-01, 4.945902d-01, &
              4.437402d-01, 3.928911d-01, 3.433811d-01, 2.944031d-01, &
              2.467411d-01, 2.003501d-01, 1.562241d-01, 1.136021d-01, &
              6.372006d-02, 2.801004d-02, 6.960025d-03, 8.175413d-09, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00 /)

      !--------------------------------
      ! GEOS-5 72 level grid
      !--------------------------------

      ! Ap [hPa] for 72 levels (73 edges)
      AP_FULLGRID =
           (/ 0.000000d+00, 4.804826d-02, 6.593752d+00, 1.313480d+01, &
              1.961311d+01, 2.609201d+01, 3.257081d+01, 3.898201d+01, &
              4.533901d+01, 5.169611d+01, 5.805321d+01, 6.436264d+01, &
              7.062198d+01, 7.883422d+01, 8.909992d+01, 9.936521d+01, &
              1.091817d+02, 1.189586d+02, 1.286959d+02, 1.429100d+02, &
              1.562600d+02, 1.696090d+02, 1.816190d+02, 1.930970d+02, &
              2.032590d+02, 2.121500d+02, 2.187760d+02, 2.238980d+02, &
              2.243630d+02, 2.168650d+02, 2.011920d+02, 1.769300d+02, &
              1.503930d+02, 1.278370d+02, 1.086630d+02, 9.236572d+01, &
              7.851231d+01, 6.660341d+01, 5.638791d+01, 4.764391d+01, &
              4.017541d+01, 3.381001d+01, 2.836781d+01, 2.373041d+01, &
              1.979160d+01, 1.645710d+01, 1.364340d+01, 1.127690d+01, &
              9.292942d+00, 7.619842d+00, 6.216801d+00, 5.046801d+00, &
              4.076571d+00, 3.276431d+00, 2.620211d+00, 2.084970d+00, &
              1.650790d+00, 1.300510d+00, 1.019440d+00, 7.951341d-01, &
              6.167791d-01, 4.758061d-01, 3.650411d-01, 2.785261d-01, &
              2.113490d-01, 1.594950d-01, 1.197030d-01, 8.934502d-02, &
              6.600001d-02, 4.758501d-02, 3.270000d-02, 2.000000d-02, &
              1.000000d-02 /)

      ! Bp [unitless] for 72 levels (73 edges)
      BP_FULLGRID =
           (/ 1.000000d+00, 9.849520d-01, 9.634060d-01, 9.418650d-01, &
              9.203870d-01, 8.989080d-01, 8.774290d-01, 8.560180d-01, &
              8.346609d-01, 8.133039d-01, 7.919469d-01, 7.706375d-01, &
              7.493782d-01, 7.211660d-01, 6.858999d-01, 6.506349d-01, &
              6.158184d-01, 5.810415d-01, 5.463042d-01, 4.945902d-01, &
              4.437402d-01, 3.928911d-01, 3.433811d-01, 2.944031d-01, &
              2.467411d-01, 2.003501d-01, 1.562241d-01, 1.136021d-01, &
              6.372006d-02, 2.801004d-02, 6.960025d-03, 8.175413d-09, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00 /)

#else

      !-----------------------------------------------------------------
      ! GEOS-5 72 level grid
      !-----------------------------------------------------------------

      ! Ap [hPa] for 72 levels (73 edges)
      AP = (/ 0.000000d+00, 4.804826d-02, 6.593752d+00, 1.313480d+01, &
              1.961311d+01, 2.609201d+01, 3.257081d+01, 3.898201d+01, &
              4.533901d+01, 5.169611d+01, 5.805321d+01, 6.436264d+01, &
              7.062198d+01, 7.883422d+01, 8.909992d+01, 9.936521d+01, &
              1.091817d+02, 1.189586d+02, 1.286959d+02, 1.429100d+02, &
              1.562600d+02, 1.696090d+02, 1.816190d+02, 1.930970d+02, &
              2.032590d+02, 2.121500d+02, 2.187760d+02, 2.238980d+02, &
              2.243630d+02, 2.168650d+02, 2.011920d+02, 1.769300d+02, &
              1.503930d+02, 1.278370d+02, 1.086630d+02, 9.236572d+01, &
              7.851231d+01, 6.660341d+01, 5.638791d+01, 4.764391d+01, &
              4.017541d+01, 3.381001d+01, 2.836781d+01, 2.373041d+01, &
              1.979160d+01, 1.645710d+01, 1.364340d+01, 1.127690d+01, &
              9.292942d+00, 7.619842d+00, 6.216801d+00, 5.046801d+00, &
              4.076571d+00, 3.276431d+00, 2.620211d+00, 2.084970d+00, &
              1.650790d+00, 1.300510d+00, 1.019440d+00, 7.951341d-01, &
              6.167791d-01, 4.758061d-01, 3.650411d-01, 2.785261d-01, &
              2.113490d-01, 1.594950d-01, 1.197030d-01, 8.934502d-02, &
              6.600001d-02, 4.758501d-02, 3.270000d-02, 2.000000d-02, &
              1.000000d-02 /)

      ! Bp [unitless] for 72 levels (73 edges)
      BP = (/ 1.000000d+00, 9.849520d-01, 9.634060d-01, 9.418650d-01, &
              9.203870d-01, 8.989080d-01, 8.774290d-01, 8.560180d-01, &
              8.346609d-01, 8.133039d-01, 7.919469d-01, 7.706375d-01, &
              7.493782d-01, 7.211660d-01, 6.858999d-01, 6.506349d-01, &
              6.158184d-01, 5.810415d-01, 5.463042d-01, 4.945902d-01, &
              4.437402d-01, 3.928911d-01, 3.433811d-01, 2.944031d-01, &
              2.467411d-01, 2.003501d-01, 1.562241d-01, 1.136021d-01, &
              6.372006d-02, 2.801004d-02, 6.960025d-03, 8.175413d-09, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00, 0.000000d+00, 0.000000d+00, 0.000000d+00, &
              0.000000d+00 /)
      
#endif

#elif defined( GEOS_4 )
      
      !=================================================================
      ! GEOS-4 vertical coordinates (30 or 55 levels)
      !=================================================================

#if   defined( GRIDREDUCED )

      !-----------------------------------------------------------------
      ! GEOS-4 30-level reduced vertical grid
      !  
      !  Bottom    Bottom    # levels
      !  edge of   edge prs  lumped 
      !  level     (hPa)     together
      !  
      !   PTOP       0.010   
      !    30        0.066      4
      !    29        0.211      4
      !    28        0.617      4
      !    27        1.651      4
      !    26        4.077      4
      !    25        9.293      4
      !    24       19.792      4
      !    23       28.368      2
      !    22       40.175      2
      !    21       56.388      2
      !    20       78.512      2
      ! %%%% START LUMPING LEVELS ABOVE HERE %%%%%
      !    19       92.366       
      !    18      108.663
      !    17      127.837
      !    16      150.393
      !    15      176.930
      ! %%%% FIXED-PRESSURE LEVELS BEGIN HERE %%%%
      !-----------------------------------------------------------------

      ! Ap [hPa] for 30 levels (31 edges)
      AP = (/  0.000000d0,   0.000000d0,  12.704939d0,  35.465965d0,  &
              66.098427d0, 101.671654d0, 138.744400d0, 173.403183d0,  &
             198.737839d0, 215.417526d0, 223.884689d0, 224.362869d0,  &
             216.864929d0, 201.192093d0, 176.929993d0, 150.393005d0,  &
             127.837006d0, 108.663429d0,  92.365662d0,  78.512299d0,  &
              56.387939d0,  40.175419d0,  28.367815d0,  19.791553d0,  &
               9.292943d0,   4.076567d0,   1.650792d0,   0.616779d0,  &
               0.211349d0,   0.066000d0,   0.010000d0 /)

      ! Bp [unitless] for 30 levels (31 edges)
      BP = (/  1.000000d0,   0.985110d0,   0.943290d0,   0.867830d0,  &
               0.764920d0,   0.642710d0,   0.510460d0,   0.378440d0,  &
               0.270330d0,   0.183300d0,   0.115030d0,   0.063720d0,  &
               0.028010d0,   0.006960d0,   0.000000d0,   0.000000d0,  &
               0.000000d0,   0.000000d0,   0.000000d0,   0.000000d0,  &
               0.000000d0,   0.000000d0,   0.000000d0,   0.000000d0,  &
               0.000000d0,   0.000000d0,   0.000000d0,   0.000000d0,  &
               0.000000d0,   0.000000d0,   0.000000d0 /)

      !-----------------------------------
      ! GEOS-4 55 level grid
      !-----------------------------------

      ! AP [hPa] for 55 levels (56 edges)
      AP_FULLGRID =
           (/ 0.000000d0,   0.000000d0,  12.704939d0,  35.465965d0,  &
             66.098427d0, 101.671654d0, 138.744400d0, 173.403183d0, &
            198.737839d0, 215.417526d0, 223.884689d0, 224.362869d0, &
            216.864929d0, 201.192093d0, 176.929993d0, 150.393005d0, &
            127.837006d0, 108.663429d0,  92.365662d0,  78.512299d0,  &
             66.603378d0,  56.387939d0,  47.643932d0,  40.175419d0,  &
             33.809956d0,  28.367815d0,  23.730362d0,  19.791553d0,  &
             16.457071d0,  13.643393d0,  11.276889d0,   9.292943d0, &
              7.619839d0,   6.216800d0,   5.046805d0,   4.076567d0,  &
              3.276433d0,   2.620212d0,   2.084972d0,   1.650792d0, &
              1.300508d0,   1.019442d0,   0.795134d0,   0.616779d0,  &
              0.475806d0,   0.365041d0,   0.278526d0,   0.211349d0,  &
              0.159495d0,   0.119703d0,   0.089345d0,   0.066000d0,  &
              0.047585d0,   0.032700d0,   0.020000d0,   0.010000d0 /) 

      ! BP [unitless] for 55 levels (56 edges)
      BP_FULLGRID =
           (/  1.000000d0,  0.985110d0,   0.943290d0,   0.867830d0, &
               0.764920d0,  0.642710d0,   0.510460d0,   0.378440d0, &
               0.270330d0,  0.183300d0,   0.115030d0,   0.063720d0, &
               0.028010d0,  0.006960d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0 /)

#else

      !-----------------------------------------------------------------
      ! GEOS-4 55 level grid
      !-----------------------------------------------------------------

      ! AP [hPa] for 55 levels (56 edges)
      AP = (/ 0.000000d0,   0.000000d0,  12.704939d0,  35.465965d0,  &
             66.098427d0, 101.671654d0, 138.744400d0, 173.403183d0, &
            198.737839d0, 215.417526d0, 223.884689d0, 224.362869d0, &
            216.864929d0, 201.192093d0, 176.929993d0, 150.393005d0, &
            127.837006d0, 108.663429d0,  92.365662d0,  78.512299d0,  &
             66.603378d0,  56.387939d0,  47.643932d0,  40.175419d0,  &
             33.809956d0,  28.367815d0,  23.730362d0,  19.791553d0,  &
             16.457071d0,  13.643393d0,  11.276889d0,   9.292943d0, &
              7.619839d0,   6.216800d0,   5.046805d0,   4.076567d0,  &
              3.276433d0,   2.620212d0,   2.084972d0,   1.650792d0, &
              1.300508d0,   1.019442d0,   0.795134d0,   0.616779d0,  &
              0.475806d0,   0.365041d0,   0.278526d0,   0.211349d0,  &
              0.159495d0,   0.119703d0,   0.089345d0,   0.066000d0,  &
              0.047585d0,   0.032700d0,   0.020000d0,   0.010000d0 /)

      ! BP [unitless] for 55 levels (56 edges)
      BP = (/  1.000000d0,  0.985110d0,   0.943290d0,   0.867830d0, &
               0.764920d0,  0.642710d0,   0.510460d0,   0.378440d0, &
               0.270330d0,  0.183300d0,   0.115030d0,   0.063720d0, &
               0.028010d0,  0.006960d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0, &
               0.000000d0,  0.000000d0,   0.000000d0,   0.000000d0 /)


#endif
#endif

! Reverse AP & BP because the daggum models flip the atmosphere.
!      AP = AP( LM+1:1:-1 )
!      BP = BP( LM+1:1:-1 )
