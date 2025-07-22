clear;
clc;
close all;

load fisheriris

% a) Analizar y describir el dataset de Iris
fprintf('Análisis del dataset Fisheriris\n')
fprintf('El dataset tiene los grupos meas y species\n')
fprintf('Meas contiene información como:\n')
fprintf('\t Longitud del sépalo en cm\n')
fprintf('\t Ancho del sépalo en cm\n')
fprintf('\t Longitud del pétalo en cm\n')
fprintf('\t Ancho del pétalo en cm\n\n')
fprintf('El arreglo meas tiene dimensiones (%d, %d)\n', size(meas,1), size(meas,2))
fprintf('El arreglo species tiene la clasificación de la flor a la que pertenecen esas características\n')
fprintf('Este arreglo tiene %d filas y %d columnas\n', size(species, 1), size(species, 2))
fprintf('Se tienen los tipos: Setosa, Versicolor y Virginica\n')

% Normalización de datos (CRÍTICO para convergencia)
fprintf('\nNormalizando datos para mejorar convergencia...\n')
X_raw = meas';
X = (X_raw - min(X_raw, [], 2)) ./ (max(X_raw, [], 2) - min(X_raw, [], 2));
fprintf('Datos normalizados en rango [0,1]\n')

% Crear la red de Kohonen de 3x3 nodos y entrenar
rng(42)
filas = 3; 
columnas = 3; 
num_caracteristicas = 4; 

% Inicialización mejorada de pesos (pequeños valores aleatorios)
W = randn(filas, columnas, num_caracteristicas);
alfa_o = 0.5; 
alfa_f = 0.01; 
radio_o = 2.0; 
radio_f = 0.5; 
max_epochs = 5000; 
epoch = 1;
JE = size(X, 2);
pesos = zeros(1, num_caracteristicas);
ganadoras = zeros(2, JE);
distancias = zeros(1, JE); 

% Arrays para monitoreo de convergencia
error_cuantico = zeros(1, max_epochs);

% Bucle principal
fprintf('Iniciando entrenamiento...\n')
for epoch = 1:max_epochs

    if mod(epoch, 500) == 0
        fprintf('Entrenando en la época %d\n', epoch)
    end
    
    % Variables para cálculo de error cuántico
    sum_min_dist = 0;
    
    % Iteración para cada JE
    for i = 1:JE
        entrada = X(:, i);
        min_distancia = inf;

        % Iteración para cada neurona
        for j = 1:filas
            for k = 1:columnas
                pesos(1) = W(j, k, 1); pesos(2) = W(j, k, 2);
                pesos(3) = W(j, k, 3); pesos(4) = W(j, k, 4);
                
                % Distancia euclidiana vectorizada
                distancia = norm(entrada - pesos);
                
                % Se encuentra la distancia mínima
                if distancia < min_distancia
                    min_distancia = distancia;
                    idx = j;
                    idy = k; 
                end
            end
        end
        
        % Acumular error cuántico
        sum_min_dist = sum_min_dist + min_distancia;
        
        %  Cálculo de alfa y el radio según época
        alfa = alfa_o * (alfa_f/alfa_o) ^ (epoch/max_epochs);
        radio = radio_o * (radio_f/radio_o) ^ (epoch/max_epochs);
        sigma = radio; 

        % Iteración para cada neurona y actualización
        for l = 1:filas
            for m = 1:columnas
                pesos(1) = W(l, m, 1); pesos(2) = W(l, m, 2);
                pesos(3) = W(l, m, 3); pesos(4) = W(l, m, 4);

                dist_neurona = sqrt((l-idx)^2 + (m-idy)^2);

                activacion = exp(- (dist_neurona^2) / (2 * sigma^2));

                % Corrección: actualización correcta de pesos
                pesos = pesos + alfa * activacion * (entrada' - pesos);
                W(l, m, 1) = pesos(1); W(l, m, 2) = pesos(2);
                W(l, m, 3) = pesos(3); W(l, m, 4) = pesos(4);
            end
        end
        % Almacenar ganadoras en la última época
        if epoch == max_epochs
            ganadoras(1, i) = idx; ganadoras(2, i) = idy;
            distancias(1, i) = min_distancia; 
        end
    end
    
    % Calcular errores de época
    error_cuantico(epoch) = sum_min_dist / JE;
end

fprintf('Entrenamiento finalizado con éxito!\n')
fprintf('Error cuántico final: %.4f\n', error_cuantico(end))

% Gráfico de convergencia
figure(1);
plot(1:max_epochs, error_cuantico, 'b-', 'LineWidth', 2);
xlabel('Época');
ylabel('Error Cuántico');
title('Convergencia del Error Cuántico');
grid on;

% Mostrar resultados del procesamiento
colores = ones(filas, columnas, 3);
conteo_setosa = zeros(filas, columnas);
conteo_virginica = zeros(filas, columnas); 
conteo_versicolor = zeros(filas, columnas); 

total_setosa = 0;
total_virginica = 0; 
total_versicolor = 0;

% Iteración para cada juego de entradas
for i = 1:JE
    idx = ganadoras(1, i); 
    idy = ganadoras(2, i); 
    switch species{i}
        case 'setosa'
            conteo_setosa(idx, idy) = conteo_setosa(idx, idy) + 1;
            total_setosa = total_setosa + 1;
        case 'versicolor'
            conteo_versicolor(idx, idy) = conteo_versicolor(idx, idy) + 1;
            total_versicolor = total_versicolor + 1; 
        case 'virginica'
            conteo_virginica(idx, idy) = conteo_virginica(idx, idy) + 1; 
            total_virginica = total_virginica + 1; 
    end
end

% Escalado de cero a a uno
conteo_setosa = conteo_setosa / total_setosa; 
conteo_virginica = conteo_virginica / total_virginica;
conteo_versicolor = conteo_versicolor / total_versicolor;

colores(:, :, 1) = conteo_setosa;
colores(:, :, 2) = conteo_virginica;
colores(:, :, 3) = conteo_versicolor;

% Mapa autoorganizado mejorado
figure(2);
imagesc(colores)
colorbar
xlabel('Columna de la grilla')
ylabel('Fila de la grilla')
title('Distribución normalizada de clases en cada neurona')

% Añadir etiquetas en cada celda
for i = 1:filas
    for j = 1:columnas
        % Encontrar clase dominante
        [~, clase_dom] = max([conteo_setosa(i,j), conteo_virginica(i,j), conteo_versicolor(i,j)]);
        clases = {'S', 'Vi', 'Ve'};
        
        % Contar muestras totales en esta neurona
        total_muestras = sum(ganadoras(1,:) == i & ganadoras(2,:) == j);
        
        if total_muestras > 0
            text(j, i, sprintf('%s\n(%d)', clases{clase_dom}, total_muestras), ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                'Color', 'white', 'FontWeight', 'bold', 'FontSize', 10);
        end
    end
end

% Análisis adicional de la calidad del mapa
figure(3);
distancias_reshape = reshape(distancias, 1, []);
histogram(distancias_reshape, 20);
xlabel('Distancia a neurona ganadora');
ylabel('Frecuencia');
title('Distribución de distancias cuánticas finales');
grid on;

fprintf('\nAnálisis de calidad del mapa:\n')
fprintf('Distancia cuántica promedio: %.4f\n', mean(distancias_reshape))
fprintf('Desviación estándar: %.4f\n', std(distancias_reshape))

% Matriz de confusión simplificada
fprintf('\nDistribución de clases por neurona:\n')
for i = 1:filas
    for j = 1:columnas
        neurona_samples = ganadoras(1,:) == i & ganadoras(2,:) == j;
        if sum(neurona_samples) > 0
            fprintf('Neurona (%d,%d): ', i, j)
            clases_neurona = species(neurona_samples);
            setosa_count = sum(strcmp(clases_neurona, 'setosa'));
            versicolor_count = sum(strcmp(clases_neurona, 'versicolor'));
            virginica_count = sum(strcmp(clases_neurona, 'virginica'));
            fprintf('Setosa=%d, Versicolor=%d, Virginica=%d\n', ...
                setosa_count, versicolor_count, virginica_count);
        end
    end
end