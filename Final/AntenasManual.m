%% Algoritmo de optimización de ubicación de antenas en telecomunicaciones

% Número de zonas objetivos: 6 (A, B, C, D, E, F)
% Posibles ubicaciones de antenas: 5 puntos
% Antenas disponibles: 3
% 3 genes por cromosoma

% Primera generación
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF

% Se inicializa la población de la siguiente manera:
% 1) Población de 6 individuos
% a) Individuo 1: [L1, L3, L4]
% a) Individuo 2: [L2, L4, L5]
% a) Individuo 3: [L1, L2, L5]
% a) Individuo 4: [L3, L4, L5]
% a) Individuo 5: [L1, L2, L3]
% a) Individuo 6: [L2, L3, L4]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas AB, DE, EF
% El individuo 2 cubre a las zonas BCD, EF, ACF
% El individuo 3 cubre a las zonas AB, BCD, ACF
% El individuo 4 cubre a las zonas DE, EF, ACF
% El individuo 5 cubre a las zonas AB, BCD, DE
% El individuo 6 cubre a las zonas BCD, DE, EF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, D, E, F = 5
% Aptitud total: 5

% Para el individuo 2: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 3: Se cubren las ciudades A, B, C, D, F = 5
% Aptitud total: 5

% Para el individuo 4: Se cubren las ciudades A, C, D, E, F = 5
% Aptitud total: 5

% Para el individuo 5: Se cubren las ciudades A, B, C, D, E = 5
% Aptitud total: 5

% Para el individuo 6: Se cubren las ciudades B, C, D, E, F = 5
% Aptitud total: 5

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 5
% Individuo 2 | Fitness: 6
% Individuo 3 | Fitness: 5
% Individuo 4 | Fitness: 5
% Individuo 5 | Fitness: 5
% Individuo 6 | Fitness: 5

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (5) - Individuo 6 (5)
% Individuo 2 (6) - Individuo 4 (5)
% Individuo 3 (5) - Individuo 5 (5)
% Individuo 2 (6) - Individuo 1 (5)
% Individuo 4 (5) - Individuo 6 (5)
% Individuo 2 (6) - Individuo 3 (5)

% Por lo que los ganadores del torneo son:
% T1: I1 (empate, se selecciona aleatoriamente)
% T2: I2 
% T3: I3 (empate, se selecciona aleatoriamente)
% T4: I2
% T5: I4 (empate, se selecciona aleatoriamente)
% T6: I2

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [L1, L3, L4]
% a) Seleccionado 2: [L2, L4, L5]
% a) Seleccionado 3: [L1, L2, L5]
% a) Seleccionado 4: [L2, L4, L5]
% a) Seleccionado 5: [L3, L4, L5]
% a) Seleccionado 6: [L2, L4, L5]

% 4) Cruce de un punto (Intercambio de ubicaciones)
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [L1, L3, L5]
% Hijo 2 = [L2, L4, L4] -> [L2, L4, L1] (se corrige el duplicado)

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [L1, L4, L5]
% Hijo 2 = [L2, L2, L5] -> [L2, L3, L5] (se corrige el duplicado)

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [L1, L3, L5]
% a) Hijo 2: [L2, L4, L1]
% a) Hijo 3: [L1, L4, L5]
% a) Hijo 4: [L2, L3, L5]
% a) Hijo 5: [L3, L4, L5]
% a) Hijo 6: [L2, L4, L5]

% 5) Mutación del 0.1 por gen (Se cambia a otra ubicación no usada)
% Suponemos que los que mutan en este caso son los hijos 
% H1 (Gen 2)
% [L1, L3, L5] -> [L1, L2, L5]
% H3 (Gen 3)
% [L1, L4, L5] -> [L1, L4, L2]
% H5 (Gen 1)
% [L3, L4, L5] -> [L1, L4, L5]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [L1, L2, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L1, L4, L2]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L1, L4, L5]
% a) Individuo 6: [L2, L4, L5]

%% Segunda generación
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF
% 1) Población de 6 individuos
% a) Individuo 1: [L1, L2, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L1, L4, L2]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L1, L4, L5]
% a) Individuo 6: [L2, L4, L5]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas AB, BCD, ACF
% El individuo 2 cubre a las zonas BCD, EF, AB
% El individuo 3 cubre a las zonas AB, EF, BCD
% El individuo 4 cubre a las zonas BCD, DE, ACF
% El individuo 5 cubre a las zonas AB, EF, ACF
% El individuo 6 cubre a las zonas BCD, EF, ACF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, C, D, F = 5
% Aptitud total: 5

% Para el individuo 2: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 3: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 4: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 5: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% Para el individuo 6: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 5
% Individuo 2 | Fitness: 6
% Individuo 3 | Fitness: 6
% Individuo 4 | Fitness: 6
% Individuo 5 | Fitness: 5
% Individuo 6 | Fitness: 6

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (5) - Individuo 6 (6)
% Individuo 2 (6) - Individuo 4 (6)
% Individuo 3 (6) - Individuo 5 (5)
% Individuo 2 (6) - Individuo 1 (5)
% Individuo 4 (6) - Individuo 6 (6)
% Individuo 3 (6) - Individuo 5 (5)

% Por lo que los ganadores del torneo son:
% T1: I6
% T2: I2 (empate, se selecciona aleatoriamente)
% T3: I3
% T4: I2
% T5: I4 (empate, se selecciona aleatoriamente)
% T6: I3

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [L2, L4, L5]
% a) Seleccionado 2: [L2, L4, L1]
% a) Seleccionado 3: [L1, L4, L2]
% a) Seleccionado 4: [L2, L4, L1]
% a) Seleccionado 5: [L2, L3, L5]
% a) Seleccionado 6: [L1, L4, L2]

% 4) Cruce de un punto (Intercambio de ubicaciones)
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [L2, L4, L1]
% Hijo 2 = [L2, L4, L5]

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [L1, L4, L1] -> [L1, L4, L3] (se corrige duplicado)
% Hijo 2 = [L2, L4, L2] -> [L2, L4, L5] (se corrige duplicado)

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [L2, L4, L1]
% a) Hijo 2: [L2, L4, L5]
% a) Hijo 3: [L1, L4, L3]
% a) Hijo 4: [L2, L4, L5]
% a) Hijo 5: [L2, L3, L5]
% a) Hijo 6: [L1, L4, L2]

% 5) Mutación del 0.1 por gen (Se cambia a otra ubicación no usada)
% Suponemos que los que mutan en este caso son los hijos 
% H2 (Gen 1)
% [L2, L4, L5] -> [L1, L4, L5]
% H4 (Gen 2)
% [L2, L4, L5] -> [L2, L3, L5]
% H6 (Gen 3)
% [L1, L4, L2] -> [L1, L4, L5]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [L2, L4, L1]
% a) Individuo 2: [L1, L4, L5]
% a) Individuo 3: [L1, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L1, L4, L5]

%% Tercera generación
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF

% 1) Población de 6 individuos
% a) Individuo 1: [L2, L4, L1]
% a) Individuo 2: [L1, L4, L5]
% a) Individuo 3: [L1, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L1, L4, L5]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas BCD, EF, AB
% El individuo 2 cubre a las zonas AB, EF, ACF
% El individuo 3 cubre a las zonas AB, EF, DE
% El individuo 4 cubre a las zonas BCD, DE, ACF
% El individuo 5 cubre a las zonas BCD, DE, ACF
% El individuo 6 cubre a las zonas AB, EF, ACF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 2: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% Para el individuo 3: Se cubren las ciudades A, B, D, E, F = 5
% Aptitud total: 5

% Para el individuo 4: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 5: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 6: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 6
% Individuo 2 | Fitness: 5
% Individuo 3 | Fitness: 5
% Individuo 4 | Fitness: 6
% Individuo 5 | Fitness: 6
% Individuo 6 | Fitness: 5

% 3) Selección por torneo binario
% Se desean hacer 6 torneos en total
% Los participantes del torneo aleatoriamente son:

% Individuo 1 (6) - Individuo 6 (5)
% Individuo 2 (5) - Individuo 4 (6)
% Individuo 3 (5) - Individuo 5 (6)
% Individuo 1 (6) - Individuo 2 (5)
% Individuo 4 (6) - Individuo 6 (5)
% Individuo 5 (6) - Individuo 3 (5)

% Por lo que los ganadores del torneo son:
% T1: I1
% T2: I4
% T3: I5
% T4: I1
% T5: I4
% T6: I5

% Entonces los seleccionados actuales son:
% a) Seleccionado 1: [L2, L4, L1]
% a) Seleccionado 2: [L2, L3, L5]
% a) Seleccionado 3: [L2, L3, L5]
% a) Seleccionado 4: [L2, L4, L1]
% a) Seleccionado 5: [L2, L3, L5]
% a) Seleccionado 6: [L2, L3, L5]

% 4) Cruce de un punto (Intercambio de ubicaciones)
% Entre el S1 y el S2 hacemos cruce en el punto 2
% Hijo 1 = [L2, L4, L5]
% Hijo 2 = [L2, L3, L1]

% Entre el S3 y S4 hacemos cruce en el punto 1
% Hijo 1 = [L2, L4, L1]
% Hijo 2 = [L2, L3, L5]

% En los otros no se realiza cruce
% Con lo que los hijos quedarían de la forma
% a) Hijo 1: [L2, L4, L5]
% a) Hijo 2: [L2, L3, L1]
% a) Hijo 3: [L2, L4, L1]
% a) Hijo 4: [L2, L3, L5]
% a) Hijo 5: [L2, L3, L5]
% a) Hijo 6: [L2, L3, L5]

% 5) Mutación del 0.1 por gen (Se cambia a otra ubicación no usada)
% Suponemos que los que mutan en este caso son los hijos 
% H1 (Gen 1)
% [L2, L4, L5] -> [L1, L4, L5]
% H2 (Gen 2)
% [L2, L3, L1] -> [L2, L4, L1]
% H3 (Gen 3)
% [L2, L4, L1] -> [L2, L4, L3]

% 6) Con lo que la nueva población resultante sería
% a) Individuo 1: [L1, L4, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L2, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L2, L3, L5]

%% Evaluación de la nueva población
% L1/AB, L2/BCD, L3/DE, L4/EF, L5/ACF

% 1) Población de 6 individuos
% a) Individuo 1: [L1, L4, L5]
% a) Individuo 2: [L2, L4, L1]
% a) Individuo 3: [L2, L4, L3]
% a) Individuo 4: [L2, L3, L5]
% a) Individuo 5: [L2, L3, L5]
% a) Individuo 6: [L2, L3, L5]

% 2a) Evaluación de aptitud: Número de zonas cubiertas
% Evaluación para el individuo 1:
% El individuo 1 cubre a las zonas AB, EF, ACF
% El individuo 2 cubre a las zonas BCD, EF, AB
% El individuo 3 cubre a las zonas BCD, EF, DE
% El individuo 4 cubre a las zonas BCD, DE, ACF
% El individuo 5 cubre a las zonas BCD, DE, ACF
% El individuo 6 cubre a las zonas BCD, DE, ACF

% Se considerará como función de aptitud lo siguiente:
% f(x) = num_ciudades_cubiertas

% Para el individuo 1: Se cubren las ciudades A, B, C, E, F = 5
% Aptitud total: 5

% Para el individuo 2: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 3: Se cubren las ciudades B, C, D, E, F = 5
% Aptitud total: 5

% Para el individuo 4: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 5: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% Para el individuo 6: Se cubren las ciudades A, B, C, D, E, F = 6
% Aptitud total: 6

% 2b) Tabla resumen indicando el fitness
%-------------------------
% Individuo 1 | Fitness: 5
% Individuo 2 | Fitness: 6
% Individuo 3 | Fitness: 5
% Individuo 4 | Fitness: 6
% Individuo 5 | Fitness: 6
% Individuo 6 | Fitness: 6

%% Conclusiones
% Se puede ver que el algoritmo genético mostró una convergencia rápida hacia
% soluciones que cubren las 6 zonas objetivo (A, B, C, D, E, F).

% Las mejores soluciones encontradas incluyen combinaciones como:
% [L2, L4, L1], [L2, L3, L5], las cuales logran cobertura completa de las 6 zonas.

