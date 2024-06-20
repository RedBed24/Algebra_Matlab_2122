% Autor: Samuel Espejo Gil

%% Primer caso: eliminar calles
Gpeatonal=G;
Gpeatonal= rmedge(Gpeatonal, find(Gpeatonal.Edges.name=="Calle Elisa Cendreros"));
Gpeatonal= rmedge(Gpeatonal, find(Gpeatonal.Edges.name=="Calle de la Paloma"));

% vuelta a calcular el flujo, exactamente igual que antes, pero el camino
% mínimo ha podido cambiar al eliminar aristas
Gpeatonal.Edges.flow=zeros(size(Gpeatonal.Edges.flow));
for i=1:size(ODmatrix.IDcentroid)
    for j=1:size(ODmatrix.IDcentroid)
        if i~=j
            [spt, foo, idx]=shortestpath(Gpeatonal, ODmatrix.IDcentroid(i), ODmatrix.IDcentroid(j));
            % se saca el camino mínimo, y para las aristas del camino se
            % incrementa el flujo como se indica en la fórmula
            Gpeatonal.Edges.flow(idx)= Gpeatonal.Edges.flow(idx)+ODmatrix.generated(i)*ODmatrix.attracted(j)/totalDemand;
        end
    end
end

%% Caso 2: reducir la velocidad de la ronda
Gronda=G;
indicesDeRonda= find(startsWith(Gronda.Edges.name, "Ronda"));
Gronda.Edges.Weight(indicesDeRonda)=60*Gronda.Edges.length(indicesDeRonda)/(0.9*30*1000);

% vuelta a calcular el flujo, exactamente igual que antes, pero el camino
% mínimo ha podido cambiar, al aumentar el travelTime de las calles
Gronda.Edges.flow=zeros(n_edges+anadidos, 1);
for i=1:size(ODmatrix.IDcentroid)
    for j=1:size(ODmatrix.IDcentroid)
        if i~=j
            [spt, foo, idx]=shortestpath(Gronda, ODmatrix.IDcentroid(i), ODmatrix.IDcentroid(j));
            % se saca el camino mínimo, y para las aristas del camino se
            % incrementa el flujo como se indica en la fórmula
            Gronda.Edges.flow(idx)= Gronda.Edges.flow(idx)+ODmatrix.generated(i)*ODmatrix.attracted(j)/totalDemand;
        end
    end
end

%% Caso 3: cambiar el sentido de la Toledo
Gtoledo=G;
Gtoledo= flipedge(Gtoledo, find(Gtoledo.Edges.name=="Calle Toledo"));

% vuelta a calcular el flujo, exactamente igual que antes, pero el camino
% mínimo ha podido cambiar
Gtoledo.Edges.flow=zeros(n_edges+anadidos, 1);
for i=1:size(ODmatrix.IDcentroid)
    for j=1:size(ODmatrix.IDcentroid)
        if i~=j
            [spt, foo, idx]=shortestpath(Gtoledo, ODmatrix.IDcentroid(i), ODmatrix.IDcentroid(j));
            % se saca el camino mínimo, y para las aristas del camino se
            % incrementa el flujo como se indica en la fórmula
            Gtoledo.Edges.flow(idx)= Gtoledo.Edges.flow(idx)+ODmatrix.generated(i)*ODmatrix.attracted(j)/totalDemand;
        end
    end
end

%% Calculo del tiempo total
% Tras ello, calcular el tiempo de cruzar toda ciudad real, atendiendo a
% diferentes parámetros, el tiempo*flujo

Casos= {'Inicial'; '1'; '2'; '3'};

% al usar la operación .* se hace elemento a elemento
tiempoI= sum(G.Edges.Weight.*G.Edges.flow);
tiempo1= sum(Gpeatonal.Edges.Weight.*Gpeatonal.Edges.flow);
tiempo2= sum(Gronda.Edges.Weight.*Gronda.Edges.flow);
tiempo3= sum(Gtoledo.Edges.Weight.*Gtoledo.Edges.flow);

Tiempos= [tiempoI; tiempo1; tiempo2; tiempo3];

% se muestran todos

table(Casos, Tiempos)

% menor repercusión?

disp("El caso con menor repercusión es el: ")
Casos(find(Tiempos== min(Tiempos(2:4))))
disp("Ya que tiene el menor tiempo de todos. Esto es porque se eliminan aristas.")
disp(" ")

%% Limpieza de variables no necesarias para otros hitos:
clear i j spt foo idx totalDemand ODmatrix Gpeatonal Gronda indicesDeRonda Gtoledo Casos tiempoI tiempo1 tiempo2 tiempo3 Tiempos anadidos n_edges ans