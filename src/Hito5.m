% Autor: Samuel Espejo Gil

%% Calculo del nuevo peso atendiendo al flujo
G.Edges.Weight= G.Edges.Weight.*(1+0.2*(G.Edges.flow/500).^4);

%% Se vuelve a hacer el Hito2
Hito2;

%% Preguntas
disp("Preguntas:")
disp("¿Se produciría un cambio de ruta para un nuevo usuario que dese realizar estos itinerarios?")
disp("Sí, ya que las aristas que tenían flujo (aquellas que pertenecían a los")
disp("caminos mínimos calculados entre centroides) han aumentado su peso.")
disp(" ")
disp("¿Qué rutas se ven alteradas y por qué?")
disp("Aquellas donde este peso aumentado supere a otros posibles caminos (2 y 3).")
disp(" ")
disp("¿Cambia el tiempo de viaje de las rutas no alteradas? ¿Por qué?")
disp("Sí ya que las aristas antes usadas (pero no todas, solo aquellas que pertenecen al camino")
disp("mínimo entre centroides) tienen mayores pesos (travelTime).")