SELECT *
FROM reserva
WHERE extract(year FROM fecha_reserva)=2024
ORDER BY fecha_reserva DESC
LIMIT 50 OFFSET 4*50;

SELECT count(COALESCE(descuento,0))
FROM vuelo;

SELECT descuento , count(*)
FROM vuelo
GROUP BY descuento
ORDER BY COUNT(*) DESC;


--ponemos en el group by lo que este en el select y no sea una funcion de agregacion.
SELECT ciudad, count(*)
FROM vuelo JOIN aeropuerto ON(desde = id_aeropuerto)
GROUP BY ciudad;

SELECT origen.ciudad, destino.ciudad, count(*)
FROM vuelo JOIN aeropuerto origen ON (desde = origen.id_aeropuerto)
	JOIN aeropuerto destino ON (hasta = destino.id_aeropuerto)
WHERE origen.ciudad = 'Sevilla' 
GROUP BY origen.ciudad, destino.ciudad
ORDER BY origen.ciudad;

SELECT origen.ciudad, destino.ciudad, count(id_reserva)
FROM vuelo v JOIN aeropuerto origen ON (desde = origen.id_aeropuerto)
	JOIN aeropuerto destino ON (hasta = destino.id_aeropuerto)
	JOIN reserva r ON (r.id_vuelo = v.id_vuelo) 
GROUP BY origen.ciudad, destino.ciudad
ORDER BY origen.ciudad;


