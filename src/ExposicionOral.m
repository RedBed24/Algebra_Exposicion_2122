clc, clear

% edges
sourceIni=[1 1 2 3 4 5 5 6 7 7];
targetIni=[3 7 6 5 2 1 4 7 4 6];

% matriz de adyacencia
AdyIni=zeros(max([sourceIni targetIni]));
%AdyIni(sourceIni + (targetIni-1)*max([sourceIni targetIni])) = 1;
for i=1:size(sourceIni, 2)
    AdyIni(sourceIni(i), targetIni(i))=1;
end
AdyIni

%% A) Visualización del grafo
Digr=digraph(sourceIni, targetIni);
plot(Digr);

%% B) Identificación de las componentes fuertmente conexas
% inicialización de C, Identidad(size(A)) 
ConexIni= eye(size(AdyIni));

% suma de todos los caminos posibles
for i=1:size(AdyIni, 1)
    ConexIni=ConexIni+AdyIni^i;
end
ConexIni

%i = mod(find(AdyIni == 0), length - 1);
%i = i(i == 0) = length;
%j = rem(find(AdyIni == 0), length - 1);
%j = j(j == 0) = length;
for i=1:size(AdyIni,1 )
    for j=1:size(AdyIni, 2)
        if ConexIni(i, j)==0
            display("No hay camino desde "+ i +" a "+ j)
        end
    end
end

% Componentes fuertemente conexas:
% v y u son fuertemente conexos cuando existe un camino entre v y u y
% viceversa

% vamos a guardar las aristas si i y j son fuertemente
% conexos, como es en ambos sentidos, esto representará un grafo
sourceConexF=[]; targetConexF=[];
contador=1;
for i=1:size(AdyIni, 1)
    for j=1+i:size(AdyIni, 2)
        if ConexIni(i, j)~=0 && ConexIni(j, i)~=0
            display("Los vértices "+ i +" y "+ j +" son fuertemente conexos")
            sourceConexF(contador)=i;
            targetConexF(contador)=j;
            contador=contador+1;
        end
    end
end
clear contador;

figure(2)
ConexFuert=graph(sourceConexF, targetConexF);
plot(ConexFuert);
% observamos que obtenemos un grafo dividido en 2 subgrafos, estos
% representan las distintas componentes fuertemente conexas, por eso mismo,
% todos los nodos de una misma componente están unidos entre sí
% Esta representación se dificulta para grafos más grandes y complejos,
% pero por simplicidad del ejercicio, vamos a parar aquí

%% C) Hay dos aristas tales que si se cambia la dirección de una de ellas,
% D es fuertemente conexo. ¿Cuáles son?

% Para que el grafo sea fuertemente conexo, debe existir un camino entre 2
% vértices cuales quiera de este. 
% Como ya hemos visto, Conex está compuesto por dos componentes fuertemente
% conexas Conex_1 y Conex_2, es decir que dentro de estas, podemos ir a cualquier 
% vértice, entonces si desde una componente Conex_1 podemos llegar a un vértice
% de otra Conex_2, ahora esas componentes estarán conexas en un sentido, si 
% además de esto, encontramos un camino en el otro sentido Conex_2 a Conex_1 
% podremos decir que estas dos componentes ahora son una, haciendo que Conex 
% sea fuertemente conexo.

% Entonces, necesitamos encontrar una arista que si cambiamos su dirección,
% al hacer todos los cálculos antes realizados indiquen que el grafo es
% fuertemente conexo. Para ello, podemos ir una a una y calcular todo de
% nuevo, lo cual eventualmente nos dará el resultado pero es una forma muy
% ineficiente ya que tiene que comprobar cada arista hasta encontrar la
% posible. Una forma de mejorar esto es sólo fijarnos en aquellas que unen
% un vértice de una componente con otro vértice de la otra. Necesitaremos
% la matriz de adyacencia y la lista de vértices que pertenecen a cada
% componente, ahora comprobaremos si el primer vértice de una componente es
% adyacente a un vértice de otra componente, si esto fuese así, esa arista
% sería una candidata.

% v adyacente a u en Conex indica pertenencia a la misma componente:
%   Debemos encontrar dos vértices en Conex con adyacencia 0
%   Y que sean una 'unión' entre las componentes

% Calculo AdyConex
AdyConex=zeros(max([sourceIni targetIni]));
for i=1:size(sourceConexF, 2)
    AdyConex(sourceConexF(i), targetConexF(i))=1;
end
AdyConex

% Calculo arista candidata
for i=1:size(AdyConex, 1)
    for j=1+i:size(AdyConex, 2) % por ser un grafo, es simétrico, por ello sólo
                                % recorremos lo que está encima de la diagonal
        if (AdyConex(i, j)==0) % i j son de diferentes componentes
            if AdyIni(i, j)~=0 % i adyacente a j en digrafo 'union'
                cambiarArista=[i j]
            elseif AdyIni(j, i)~=0 % j adyacente a i en digrafo
                cambiarArista=[j i]
            end
        end
    end
end

% Una vez encontrada la arista, hacemos el cambio de sentido y comprobamos
% si ahora es fuertemente conexo, lo sabremos si al calcular la conexión
% del grafo no hay nigún 0

% Comprobación con la última arista
% cambiamos el sentido de la arista
DigrMod=flipedge(Digr, cambiarArista(1), cambiarArista(2));
% lo mostramos
figure(3)
plot(DigrMod)

% Calculo de la matriz de adyacencia del nuevo digrafo
AdyMod=zeros(max([sourceIni targetIni]));
for i=1:size(sourceIni, 2)
    if sourceIni(i)== cambiarArista(1) && targetIni(i)== cambiarArista(2)
     % si la arista a poner en la matriz es la que queremos cambiar
     % la añadimos en el sentido contrario
       AdyMod(targetIni(i), sourceIni(i))=1;
    else
       AdyMod(sourceIni(i), targetIni(i))=1;
    end
end
AdyMod

% calculo de la conexión del digrafo
ConexMod= eye(size(AdyMod));
for i=1:size(AdyIni, 1)
    ConexMod=ConexMod+AdyMod^i;
end
ConexMod
