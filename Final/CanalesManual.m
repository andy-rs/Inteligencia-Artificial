%% Algoritmo genético para optimización de distribución de canales en redes de telecomunicaciones celulares.

% Parámetros del algoritmo genético
% Cantidad de celdas: 4
% Identificación de celdas: C1, C2, C3, C4
% Canales disponibles: [1, 2, 3, 4, 5, 6]
% Estructura del cromosoma: 4 genes 
% Conectividad: C1 conecta con C2 y C3; C2 conecta con C1 y C4; C3 conecta con C1 y C4; C4 conecta con C2 y C3
% Criterios de penalización:
% 1) Canal idéntico -> penalización de +2
% 2) Canales consecutivos (diferencia de 1) -> penalización de +1
% Fitness = valor máximo alcanzable - penalización acumulada

% Generación inicial
% Inicialización de la población con:
% 1) Conjunto de 6 individuos
% a) Individuo 1: [3, 1, 4, 5] 
% a) Individuo 2: [2, 5, 1, 3] (C1 utiliza canal 2, C2 utiliza canal 5, C3 utiliza canal 1, C4 utiliza canal 3)
% a) Individuo 3: [1, 4, 6, 2] 
% a) Individuo 4: [5, 3, 2, 6] 
% a) Individuo 5: [4, 6, 3, 1] 
% a) Individuo 6: [1, 2, 5, 4] 

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [3, 1, 4, 5]
% C1-C2: 3 vs 1 -> diferencia de 2, sin penalización
% C1-C3: 3 vs 4 -> diferencia de 1, penalización de 1
% C2-C4: 1 vs 5 -> diferencia de 4, sin penalización
% C3-C4: 4 vs 5 -> diferencia de 1, penalización de 1
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 2: [2, 5, 1, 3]
% C1-C2: 2 vs 5 -> diferencia de 3, sin penalización
% C1-C3: 2 vs 1 -> diferencia de 1, penalización de 1
% C2-C4: 5 vs 3 -> diferencia de 2, sin penalización
% C3-C4: 1 vs 3 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 3: [1, 4, 6, 2]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 6 -> diferencia de 5, sin penalización
% C2-C4: 4 vs 2 -> diferencia de 2, sin penalización
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 0
% Fitness = 10 - 0 = 10

% Para el individuo 4: [5, 3, 2, 6]
% C1-C2: 5 vs 3 -> diferencia de 2, sin penalización
% C1-C3: 5 vs 2 -> diferencia de 3, sin penalización
% C2-C4: 3 vs 6 -> diferencia de 3, sin penalización
% C3-C4: 2 vs 6 -> diferencia de 4, sin penalización
% Penalización acumulada: 0
% Fitness = 10 - 0 = 10

% Para el individuo 5: [4, 6, 3, 1]
% C1-C2: 4 vs 6 -> diferencia de 2, sin penalización
% C1-C3: 4 vs 3 -> diferencia de 1, penalización de 1
% C2-C4: 6 vs 1 -> diferencia de 5, sin penalización
% C3-C4: 3 vs 1 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 6: [1, 2, 5, 4]
% C1-C2: 1 vs 2 -> diferencia de 1, penalización de 1
% C1-C3: 1 vs 5 -> diferencia de 4, sin penalización
% C2-C4: 2 vs 4 -> diferencia de 2, sin penalización
% C3-C4: 5 vs 4 -> diferencia de 1, penalización de 1
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% 2b) Resumen de resultados
%---------------------------------------------------------------------
% Individuo 1 | Cromosoma: [3, 1, 4, 5] | Penalización: 2 | Fitness: 8
% Individuo 2 | Cromosoma: [2, 5, 1, 3] | Penalización: 1 | Fitness: 9
% Individuo 3 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 4 | Cromosoma: [5, 3, 2, 6] | Penalización: 0 | Fitness: 10
% Individuo 5 | Cromosoma: [4, 6, 3, 1] | Penalización: 1 | Fitness: 9
% Individuo 6 | Cromosoma: [1, 2, 5, 4] | Penalización: 2 | Fitness: 8

% 3) Proceso de selección mediante torneo binario
% Se realizan 5 competencias para obtener 5 descendientes, aplicando
% estrategia elitista

% Los emparejamientos aleatorios son:
% Individuo 3 (10) - Individuo 1 (8)
% Individuo 4 (10) - Individuo 6 (8)
% Individuo 2 (9) - Individuo 5 (9)
% Individuo 3 (10) - Individuo 4 (10)
% Individuo 5 (9) - Individuo 1 (8)

% Los victoriosos en cada torneo son:
% T1: I3
% T2: I4
% T3: I2
% T4: I3
% T5: I5

% Los individuos seleccionados resultan:
% a) Seleccionado 1: [1, 4, 6, 2]
% a) Seleccionado 2: [5, 3, 2, 6]
% a) Seleccionado 3: [2, 5, 1, 3]
% a) Seleccionado 4: [1, 4, 6, 2]
% a) Seleccionado 5: [4, 6, 3, 1]

% 4) Operación de cruce en un punto
% Entre S1 y S2 ejecutamos cruce después del índice 2
% Padre 1: [1, 4, 6, 2] -> Hijo 1: [1, 4, 2, 6]
% Padre 2: [5, 3, 2, 6] -> Hijo 2: [5, 3, 6, 2]

% Entre S3 y S4 ejecutamos cruce después del índice 2
% Padre 3: [2, 5, 1, 3] -> Hijo 3: [2, 5, 6, 2]
% Padre 4: [1, 4, 6, 2] -> Hijo 4: [1, 4, 1, 3]

% S5 permanece sin alteración
% Hijo 5: [4, 6, 3, 1]

% Los descendientes obtenidos son:
% a) Hijo 1: [1, 4, 2, 6]
% a) Hijo 2: [5, 3, 6, 2]
% a) Hijo 3: [2, 5, 6, 2]
% a) Hijo 4: [1, 4, 1, 3]
% a) Hijo 5: [4, 6, 3, 1]

% 5) Proceso de mutación (10% de probabilidad: H1; C3 a C5 y H4: C4 a C6)
% Asumiendo que ambas mutaciones especificadas ocurren, entonces:
% H1: [1, 4, 2, 6] -> [1, 4, 5, 6] (C3 cambia de 2 a 5)
% H4: [1, 4, 1, 3] -> [1, 4, 1, 6] (C4 cambia de 3 a 6)

% 6) Nueva población aplicando elitismo: El mejor individuo y 5 descendientes
% El mejor de la generación previa fue el individuo 3 [1, 4, 6, 2] (fitness de 10)
% Los 5 hijos con mutaciones:
% a) Hijo 1: [1, 4, 5, 6]
% a) Hijo 2: [5, 3, 6, 2]
% a) Hijo 3: [2, 5, 6, 2]
% a) Hijo 4: [1, 4, 1, 6]
% a) Hijo 5: [4, 6, 3, 1]

%% Segunda generación
% 1) Conjunto de 6 individuos
% a) Individuo 1: [1, 4, 6, 2]
% a) Individuo 2: [1, 4, 5, 6]
% a) Individuo 3: [5, 3, 6, 2]
% a) Individuo 4: [2, 5, 6, 2]
% a) Individuo 5: [1, 4, 1, 6]
% a) Individuo 6: [4, 6, 3, 1]

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [1, 4, 6, 2] 
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 2: [1, 4, 5, 6]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 5 -> diferencia de 4, sin penalización
% C2-C4: 4 vs 6 -> diferencia de 2, sin penalización
% C3-C4: 5 vs 6 -> diferencia de 1, penalización de 1
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 3: [5, 3, 6, 2]
% C1-C2: 5 vs 3 -> diferencia de 2, sin penalización
% C1-C3: 5 vs 6 -> diferencia de 1, penalización de 1
% C2-C4: 3 vs 2 -> diferencia de 1, penalización de 1
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 4: [2, 5, 6, 2]
% C1-C2: 2 vs 5 -> diferencia de 3, sin penalización
% C1-C3: 2 vs 6 -> diferencia de 4, sin penalización
% C2-C4: 5 vs 2 -> diferencia de 3, sin penalización
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 0
% Fitness = 10 - 0 = 10

% Para el individuo 5: [1, 4, 1, 6]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 1 -> canal idéntico, penalización de 2
% C2-C4: 4 vs 6 -> diferencia de 2, sin penalización
% C3-C4: 1 vs 6 -> diferencia de 5, sin penalización
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 6: [4, 6, 3, 1]
% C1-C2: 4 vs 6 -> diferencia de 2, sin penalización
% C1-C3: 4 vs 3 -> diferencia de 1, penalización de 1
% C2-C4: 6 vs 1 -> diferencia de 5, sin penalización
% C3-C4: 3 vs 1 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% 2b) Resumen de resultados con valores de fitness
%---------------------------------------------------------------------
% Individuo 1 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 2 | Cromosoma: [1, 4, 5, 6] | Penalización: 1 | Fitness: 9
% Individuo 3 | Cromosoma: [5, 3, 6, 2] | Penalización: 2 | Fitness: 8
% Individuo 4 | Cromosoma: [2, 5, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 5 | Cromosoma: [1, 4, 1, 6] | Penalización: 2 | Fitness: 8
% Individuo 6 | Cromosoma: [4, 6, 3, 1] | Penalización: 1 | Fitness: 9

% 3) Proceso de selección mediante torneo binario
% Se ejecutan 5 competencias
% Los emparejamientos aleatorios son:

% Individuo 1 (10) - Individuo 5 (8)
% Individuo 4 (10) - Individuo 3 (8)
% Individuo 2 (9) - Individuo 6 (9)
% Individuo 1 (10) - Individuo 4 (10)
% Individuo 2 (9) - Individuo 5 (8)

% Los victoriosos en cada torneo son:
% T1: I1
% T2: I4
% T3: I2
% T4: I1
% T5: I2

% Los individuos seleccionados resultan:
% a) Seleccionado 1: [1, 4, 6, 2]
% a) Seleccionado 2: [2, 5, 6, 2]
% a) Seleccionado 3: [1, 4, 5, 6]
% a) Seleccionado 4: [1, 4, 6, 2]
% a) Seleccionado 5: [1, 4, 5, 6]

% 4) Operación de cruce en un punto
% Entre S1 y S2 ejecutamos cruce después del índice 2
% Padre 1: [1, 4, 6, 2] -> Hijo 1: [1, 4, 6, 2]
% Padre 2: [2, 5, 6, 2] -> Hijo 2: [2, 5, 6, 2]

% Entre S3 y S4 ejecutamos cruce después del índice 1
% Padre 3: [1, 4, 5, 6] -> Hijo 3: [1, 4, 6, 2]
% Padre 4: [1, 4, 6, 2] -> Hijo 4: [1, 4, 5, 6]

% S5 permanece sin alteración
% Hijo 5: [1, 4, 5, 6]

% Los descendientes obtenidos son:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [2, 5, 6, 2]
% a) Hijo 3: [1, 4, 6, 2]
% a) Hijo 4: [1, 4, 5, 6]
% a) Hijo 5: [1, 4, 5, 6]

% 5) Proceso de mutación (10% de probabilidad)
% En este caso se producen las siguientes mutaciones:
% H2: [2, 5, 6, 2] -> [2, 1, 6, 2] (C2 cambia del canal 5 al canal 1)
% H5: [1, 4, 5, 6] -> [1, 4, 5, 3] (C4 cambia del canal 6 al canal 3)

% 6) Nueva población aplicando elitismo: El mejor individuo y 5 descendientes
% El mejor de la generación previa: Individuo 1 [1, 4, 6, 2] (fitness de 10)
% Los 5 hijos con mutaciones:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [2, 1, 6, 2]
% a) Hijo 3: [1, 4, 6, 2]
% a) Hijo 4: [1, 4, 5, 6]
% a) Hijo 5: [1, 4, 5, 3]

%% Tercera generación
% 1) Conjunto de 6 individuos
% a) Individuo 1: [1, 4, 6, 2]
% a) Individuo 2: [1, 4, 6, 2]
% a) Individuo 3: [2, 1, 6, 2]
% a) Individuo 4: [1, 4, 6, 2]
% a) Individuo 5: [1, 4, 5, 6]
% a) Individuo 6: [1, 4, 5, 3]

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [1, 4, 6, 2]
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 2: [1, 4, 6, 2]
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 3: [2, 1, 6, 2]
% C1-C2: 2 vs 1 -> diferencia de 1, penalización de 1
% C1-C3: 2 vs 6 -> diferencia de 4, sin penalización
% C2-C4: 1 vs 2 -> diferencia de 1, penalización de 1
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 2
% Fitness = 10 - 2 = 8

% Para el individuo 4: [1, 4, 6, 2]
% Ya calculado anteriormente
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 5: [1, 4, 5, 6]
% Ya calculado anteriormente
% Penalización acumulada: 1, Fitness: 9

% Para el individuo 6: [1, 4, 5, 3]
% C1-C2: 1 vs 4 -> diferencia de 3, sin penalización
% C1-C3: 1 vs 5 -> diferencia de 4, sin penalización
% C2-C4: 4 vs 3 -> diferencia de 1, penalización de 1
% C3-C4: 5 vs 3 -> diferencia de 2, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% 2b) Resumen de resultados con valores de fitness
%---------------------------------------------------------------------
% Individuo 1 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 2 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 3 | Cromosoma: [2, 1, 6, 2] | Penalización: 2 | Fitness: 8
% Individuo 4 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 5 | Cromosoma: [1, 4, 5, 6] | Penalización: 1 | Fitness: 9
% Individuo 6 | Cromosoma: [1, 4, 5, 3] | Penalización: 1 | Fitness: 9

% 3) Proceso de selección mediante torneo binario
% Se ejecutan 5 competencias
% Los emparejamientos aleatorios son:

% Individuo 1 (10) - Individuo 3 (8)
% Individuo 2 (10) - Individuo 6 (9)
% Individuo 4 (10) - Individuo 5 (9)
% Individuo 1 (10) - Individuo 2 (10)
% Individuo 4 (10) - Individuo 6 (9)

% Los victoriosos en cada torneo son:
% T1: I1
% T2: I2
% T3: I4
% T4: I1
% T5: I4

% Los individuos seleccionados resultan:
% a) Seleccionado 1: [1, 4, 6, 2]
% a) Seleccionado 2: [1, 4, 6, 2]
% a) Seleccionado 3: [1, 4, 6, 2]
% a) Seleccionado 4: [1, 4, 6, 2]
% a) Seleccionado 5: [1, 4, 6, 2]

% 4) Operación de cruce en un punto

% Considerando que entre S2 y S3 ejecutamos cruce después del índice 1
% Padre 2: [1, 4, 6, 2] -> Hijo 2: [1, 4, 6, 2]
% Padre 3: [1, 4, 6, 2] -> Hijo 3: [1, 4, 6, 2]

% S1, S4 y S5 permanecen sin alteración
% Hijo 5: [1, 4, 6, 2]

% Los descendientes obtenidos son:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [1, 4, 6, 2]
% a) Hijo 3: [1, 4, 6, 2]
% a) Hijo 4: [1, 4, 6, 2]
% a) Hijo 5: [1, 4, 6, 2]

% 5) Proceso de mutación (10% de probabilidad)
% Considerando que se produce esta mutación específicamente:
% H3: [1, 4, 6, 2] -> [1, 3, 6, 2] (C2 cambia del canal 4 al canal 3)

% 6) Nueva población aplicando elitismo: El mejor individuo y 5 descendientes
% El mejor de la generación previa: Individuo 1 [1, 4, 6, 2] (fitness 10)
% Los 5 hijos con mutaciones:
% a) Hijo 1: [1, 4, 6, 2]
% a) Hijo 2: [1, 4, 6, 2]
% a) Hijo 3: [1, 3, 6, 2]
% a) Hijo 4: [1, 4, 6, 2]
% a) Hijo 5: [1, 4, 6, 2]

%% Evaluación de la población resultante
% 1) Conjunto de 6 individuos
% a) Individuo 1: [1, 4, 6, 2] 
% a) Individuo 2: [1, 4, 6, 2]
% a) Individuo 3: [1, 4, 6, 2]
% a) Individuo 4: [1, 3, 6, 2]
% a) Individuo 5: [1, 4, 6, 2]
% a) Individuo 6: [1, 4, 6, 2]

% 2a) Cálculo de aptitud: Análisis de interferencia entre celdas vecinas
% Para el individuo 1: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 2: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 3: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 4: [1, 3, 6, 2]
% C1-C2: 1 vs 3 -> diferencia de 2, sin penalización
% C1-C3: 1 vs 6 -> diferencia de 5, sin penalización
% C2-C4: 3 vs 2 -> diferencia de 1, penalización de 1
% C3-C4: 6 vs 2 -> diferencia de 4, sin penalización
% Penalización acumulada: 1
% Fitness = 10 - 1 = 9

% Para el individuo 5: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% Para el individuo 6: [1, 4, 6, 2] (ya calculado)
% Penalización acumulada: 0, Fitness: 10

% 2b) Resumen de resultados con valores de fitness
%----------------------------------------------------------------------
% Individuo 1 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 2 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 3 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 4 | Cromosoma: [1, 3, 6, 2] | Penalización: 1 | Fitness: 9
% Individuo 5 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10
% Individuo 6 | Cromosoma: [1, 4, 6, 2] | Penalización: 0 | Fitness: 10

%% Observaciones finales

% Es evidente que el algoritmo logró identificar una solución óptima desde la primera generación.

% El individuo [1, 4, 6, 2] alcanzó el fitness máximo de 10, representando
% la distribución perfecta de canales sin interferencia.

% La estrategia elitista resultó fundamental para preservar la mejor solución
% a través de las generaciones sucesivas.

% El proceso de mutación facilitó la exploración de nuevas configuraciones
% en el espacio de búsqueda.

% Este algoritmo demuestra ser efectivo para determinar la distribución
% óptima de canales que elimina la interferencia en sistemas celulares de telecomunicaciones.