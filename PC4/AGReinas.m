% Resolver el problema de las 8 reinas
clear; 
clc; 
close all; 

% Parámetros del algoritmo genético
nReinas = 8; 
maxAptitud = (nReinas / 2) * (nReinas - 1); 
tamPoblacion = 100; 
nGeneraciones = 1000; 
tasaCruce = 0.85; 
tasaMutacion = 0.05; 
tamTorneo = 3; 

fprintf('Iniciando algoritmo genético para resolver el problema de las %d reinas', nReinas)
fprintf('Parámetros del AG:\n')
fprintf('Número de reinas: %d\n', nReinas)
fprintf('Función de aptitud: %d - #confictos\n', maxAptitud)
fprintf('Tamaño de la población: %d\n', tamPoblacion)
fprintf('Número de generaciones: %d\n', nGeneraciones)
fprintf('Tasa de cruce: %.3f\n', tasaCruce)
fprintf('Tasa de mutación: %.3f\n', tasaMutacion)

% Inicialización de la población inicial
poblacion = zeros(tamPoblacion, nReinas);
fprintf('La población inicial es la siguiente\n')
for i = 1:tamPoblacion
    add = randperm(nReinas, nReinas);
    fprintf('%d %d %d %d %d %d %d %d\n', add)
    poblacion(i, :) = add;
end

% Especificaciones
fprintf('\nLa función de aptitud es: %d - #confictos\n', maxAptitud)
fprintf('La selección se hará por torneo\n')
fprintf('El cruce se hará mediante cruce OX\n')
fprintf('La mutación se hará por intercambio\n')
fprintf('\nIniciando el algoritmo genético\n')

% Variables generales
soluciones_globales = []; 
num_mostrar = 4; 

% Algoritmo genético
for gen = 1:nGeneraciones
    % Impresión del avance
    if mod(gen, 10) == 0
        fprintf('Evaluando en la generacion %d\n', gen)
    end

    % Evaluación de aptitud
    fitness = evaluar_aptitud(poblacion, maxAptitud);

    % Mostrar soluciones en esta generacion si las hay
    soluciones_uni_gen = mostrar_soluciones(poblacion, fitness, maxAptitud, gen); 
    soluciones_globales = [soluciones_globales; soluciones_uni_gen];

    % Selección
    seleccionados = torneo(poblacion, fitness, tamTorneo); 

    % Cruce
    hijos = cruceOX(seleccionados, tasaCruce, nReinas);

    % Mutación
    mutados = mutacion_intercambio(hijos, tasaMutacion, nReinas);

    % Asignación de la nueva población
    poblacion = mutados;
end

fprintf('Algoritmo genético terminado\n')

% Imprimir soluciones únicas encontradas durante todo el algoritmo
soluciones_unicas_globales = unique(soluciones_globales, 'rows'); 
fprintf('Mostrando todas las soluciones únicas encontradas\n')
for i = 1:size(soluciones_unicas_globales, 1)
    fprintf('%d %d %d %d %d %d %d %d\n', soluciones_unicas_globales(i, :))
end

fprintf('En total se encontraron %d soluciones\n', size(soluciones_unicas_globales,  1))

fprintf('Mostrando las primeras 4 soluciones en un gráfico\n')
mostrar_grafico_soluciones(soluciones_unicas_globales, nReinas, num_mostrar);

% Funciones de soporte
function fitness = evaluar_aptitud(poblacion, maxAptitud)
    fitness = zeros(1, size(poblacion, 1)); 
    
    % Iteración para cada individuo de la población
    for i = 1:size(poblacion, 1)
        % Conflictos iniciales en cero
        conflictos  = 0;
        individuo = poblacion(i, :); 
        for j = 1:size(poblacion, 2)
            for k = j+1:size(poblacion, 2)
                % Conteo de conflictos en la diagonal
                if abs(j-k) == abs(individuo(j) - individuo(k))
                    conflictos = conflictos + 1; 
                end
            end
        end
        % Resultado de fitness
        fitness(i) = maxAptitud - conflictos; 
    end
end

% Seleccion por torneo
function seleccionados = torneo(poblacion, fitness, tamTorneo)
    seleccionados = zeros(size(poblacion));

    for i = 1:size(poblacion, 1)
        indices_torneo = randperm(size(poblacion, 1), tamTorneo);
        [~, indice] = max(fitness(indices_torneo)); 
        idx_ganador = indices_torneo(indice); 
        seleccionados(i, :) = poblacion(idx_ganador, :);
    end
end

% Función para el cruce OX
function hijos = cruceOX(seleccionados, prob, reinas)
    hijos = zeros(size(seleccionados));
    
    for i = 1:2:size(seleccionados, 1)
        if rand() < prob
            puntos = sort(randperm(reinas, 2), 'ascend');
            p1 = puntos(1); p2 = puntos(2);
            
            % Inicializar hijos con -1
            hijo1 = -ones(1, reinas);
            hijo2 = -ones(1, reinas);
            
            % Copiar segmento entre puntos de corte
            hijo1(p1:p2) = seleccionados(i, p1:p2);
            hijo2(p1:p2) = seleccionados(i+1, p1:p2);
            
            % Llenar hijo1 con elementos del padre2
            pos = 1;
            for k = 1:reinas
                valor = seleccionados(i+1, k);
                if ~ismember(valor, hijo1)
                    % Encontrar siguiente posición libre
                    while pos <= reinas && hijo1(pos) ~= -1
                        pos = pos + 1;
                    end
                    if pos <= reinas
                        hijo1(pos) = valor;
                    end
                end
            end
            
            % Llenar hijo2 con elementos del padre1
            pos = 1;
            for k = 1:reinas
                valor = seleccionados(i, k);
                if ~ismember(valor, hijo2)
                    % Encontrar siguiente posición libre
                    while pos <= reinas && hijo2(pos) ~= -1
                        pos = pos + 1;
                    end
                    if pos <= reinas
                        hijo2(pos) = valor;
                    end
                end
            end
            
            hijos(i, :) = hijo1;
            hijos(i+1, :) = hijo2;
        else
            hijos(i, :) = seleccionados(i, :);
            hijos(i+1, :) = seleccionados(i+1, :);
        end
    end
end

% Función para la mutación por intercambio
function mutados = mutacion_intercambio(hijos, prob, reinas)
    mutados = hijos; 

    for i = 1:size(hijos, 1)
        if rand() < prob
            individuo = mutados(i, :); 
            [p1, p2] = sort(randperm(reinas, 2), 'ascend');
            temp = individuo(p1); 
            individuo(p1) = individuo(p2); 
            individuo(p2) = temp; 
            mutados(i, :) = individuo; 
        end
    end
end

% Imprimir soluciones
function soluciones_unicas = mostrar_soluciones(poblacion, fitness, maxAptitud, gen)
    indices = fitness == maxAptitud; 
    soluciones = poblacion(indices, :); 
    soluciones_unicas = unique(soluciones, 'rows');
    fprintf('Para la generacion: %d\n', gen)
    for i = 1:size(soluciones_unicas, 1)
        fprintf('Se encontro la siguiente solucion\n')
        disp(soluciones_unicas(i, :))
    end
    if ~isempty(soluciones_unicas)
        fprintf('Estas son soluciones porque el número de conflictos es cero\n')
    else
        fprintf('No se encontraron soluciones\n')
    end
end

function mostrar_grafico_soluciones(soluciones_unicas_globales, nReinas, num_mostrar)
    for k = 1:min(num_mostrar, size(soluciones_unicas_globales, 1))
        solucion = soluciones_unicas_globales(k, :); 
        for i = 1:nReinas
            for j = 1:nReinas
                if i == solucion(j)
                    fprintf(' Q ')
                else
                    fprintf(' * ')
                end
            end
            fprintf('\n')
        end
        fprintf('\n')
    end
end