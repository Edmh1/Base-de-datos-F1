-- 1 funcion
CREATE OR REPLACE FUNCTION tiempoEnVuelta(idVuelta INT)
RETURNS TIME AS 
$$
DECLARE tiempoTotal TIME;
BEGIN
	SELECT SUM(ps.tiempo) INTO tiempoTotal
	FROM participacionesEnVuelta pv
	INNER JOIN participacionesEnSector ps USING(idParticipacionEnVuelta)
	WHERE pv.idParticipacionEnVuelta = idVuelta;
	RETURN tiempoTotal;
END;
$$
LANGUAGE plpgsql;

-- 2 funcion
CREATE OR REPLACE FUNCTION tiempoEnCarrera(idParticipacionACalcular INT)
RETURNS TIME AS 
$$
DECLARE tiempoTotal TIME;
BEGIN
	SELECT SUM(tiempoEnVuelta(pv.idParticipacionEnVuelta)) INTO tiempoTotal
	FROM participaciones p
	INNER JOIN participacionesEnVuelta pv USING(idParticipacion)
	WHERE p.idParticipacion = idParticipacionACalcular;
	RETURN tiempoTotal;
END;
$$
LANGUAGE plpgsql;

-- 3 funcion
CREATE OR REPLACE FUNCTION clasificacionDeCarrera(idCarreraACalcular INT)
RETURNS TABLE(
	idParticipacion INT,
	tiempoTotal TIME
) AS
$$
BEGIN
	RETURN QUERY
	SELECT p.idParticipacion, tiempoEnCarrera(p.idParticipacion) as tiempo
	FROM carreras c
	INNER JOIN participaciones p USING(idCarrera)
	WHERE idCarreraACalcular = c.idCarrera
	ORDER BY tiempo;
	
END;
$$
LANGUAGE plpgsql;

-- 4 funcion
CREATE OR REPLACE FUNCTION escuderiasPorTemporada(idTemporadaABuscar INT)
RETURNS TABLE(
	escuderias VARCHAR(45)
) AS
$$
BEGIN
	RETURN QUERY
	SELECT e.nombre
	FROM EdicionesDeGranPremio
	INNER JOIN Carreras USING(idEdicionDeGranPremio)
	INNER JOIN Participaciones USING(idCarrera)
	INNER JOIN Monoplazas USING(idMonoplaza)
	INNER JOIN Escuderias e USING(idEscuderia)
	WHERE idEdicionDeGranPremio = idTemporadaABuscar 
	GROUP BY e.nombre;
END;
$$
LANGUAGE plpgsql;

-- 5 Funcion para dado un puesto retornar los puntos que gano (check)
CREATE OR REPLACE FUNCTION calcularPuntos(puesto INT, tipoCarrera INT)
RETURNS INT AS
$$
DECLARE
	puntos INT;
	idFinal INT;
	idSpring INT;
BEGIN
	puntos := 0;
	SELECT idTipoCarrera INTO idFinal
  	FROM tiposCarreras
  	WHERE nombre = 'Final';

	SELECT idTipoCarrera INTO idSpring
	FROM tiposCarreras
	WHERE nombre = 'Spring';
	CASE
		WHEN tipoCarrera = idFinal THEN 
            CASE puesto
                WHEN 1 THEN puntos := 25;
                WHEN 2 THEN puntos := 19;
                WHEN 3 THEN puntos := 15;
                WHEN 4 THEN puntos := 12;
                WHEN 5 THEN puntos := 10;
                WHEN 6 THEN puntos := 8;
                WHEN 7 THEN puntos := 6;
                WHEN 8 THEN puntos := 4;
                WHEN 9 THEN puntos := 2;
                WHEN 10 THEN puntos := 1;
            END CASE;
        WHEN tipoCarrera = idSpring THEN 
            IF puesto <= 8 AND puesto != 0 THEN
                puntos := 9 - puesto;
            END IF;
    END CASE;

    RETURN puntos;  
END;
$$
LANGUAGE plpgsql;

-- 6 funcion
CREATE OR REPLACE FUNCTION escuderiasPorPiloto(idPilotoABuscar INT)
RETURNS TABLE(
	piloto VARCHAR(45),
	escuderia VARCHAR(45)
)
AS $$
BEGIN
	RETURN QUERY
		SELECT per.nombre, e.nombre
		FROM pilotos pil
		INNER JOIN personas per ON(pil.idPiloto = per.idPersona)
		INNER JOIN participaciones USING(idPiloto)
		INNER JOIN monoplazas USING(idMonoPlaza)
		INNER JOIN escuderias e USING(idEscuderia)
		WHERE pil.idPiloto = idPilotoABuscar
		GROUP BY per.nombre, e.nombre;
END;
$$ LANGUAGE plpgsql;

-- 7 funcion
CREATE OR REPLACE FUNCTION verClimasPorVueltas(idPilotoABuscar INT, idCarreraABuscar INT)
RETURNS TABLE(
	clima VARCHAR(45),
	vuelta INT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT c.nombre
	FROM participaciones p
	INNER JOIN participacionesEnVuelta pv USING(idParticipacion)
	INNER JOIN climas c USING(idClima)
	WHERE p.idPiloto = idPilotoABuscar AND idCarreraABuscar = p.idCarrera
	;
END;
$$ LANGUAGE plpgsql;

-- 8 funcion
CREATE OR REPLACE FUNCTION mejorYPeorTiempo(idEscuderiaABuscar INT)
RETURNS TABLE(
	escuderia VARCHAR(45),
	maxtiempo TIME,
	mintiempo TIME
)AS
$$
BEGIN
	RETURN QUERY
	SELECT	e.nombre,
			MAX(tiempoEnCarrera(p.idParticipacion))AS MaxtiempoEnParticipacion,
			MIN(tiempoEnCarrera(p.idParticipacion))AS MintiempoEnParticipacion
	FROM escuderias e
		INNER JOIN monoplazas m USING(idEscuderia)
		INNER JOIN participaciones p USING(idMonoplaza)
	WHERE e.idEscuderia =idEscuderiaABuscar
	GROUP BY e.nombre;
END;
$$
LANGUAGE plpgsql;

-- 9 funcion
CREATE OR REPLACE FUNCTION circuitosPorCiudades()
RETURNS INT AS
$$
BEGIN
	SELECT ciu.nombre AS ciudad ,COUNT(cir.nombre)
	FROM circuitos cir
		RIGHT JOIN ciudades ciu ON ciu.idCiudad = cir.idCiudad 
	GROUP BY ciu.nombre;
END;
$$
LANGUAGE plpgsql;

-- 1 vista para identificar los ganadores de cada carrera final de las ediciones de gran premio
CREATE OR REPLACE VIEW ganadoresPorCarrerasFinales
AS
SELECT DISTINCT c.idCarrera, MIN(tiempoEnCarrera(p.idParticipacion)) OVER(PARTITION BY c.idCarrera) AS tiempo
FROM Carreras c
INNER JOIN TiposDeCarreras tc USING(idTipoCarrera)
INNER JOIN Participaciones p USING(idCarrera)
WHERE tc.nombre = 'Final';

-- 2 Vista para identificar los circuitos en los que han ocurrido accidente (check)
CREATE OR REPLACE VIEW circuitosConRegistroDeAccidentes 
AS
SELECT ci.idCircuito,
       COUNT(*) AS numeroDeAccidentes
FROM Accidentes a
INNER JOIN participacionesEnSector ps ON a.idParticipacionEnSector = ps.idParticipacionEnSector
INNER JOIN participacionesEnVuelta pv ON ps.idParticipacionEnVuelta = pv.idparticipacionEnVuelta
INNER JOIN participaciones p ON pv.idparticipacion = p.idparticipacion
INNER JOIN carreras c ON p.idCarrera = c.idCarrera
INNER JOIN edicionesDeGranPremio e ON c.idEdicionDeGranPremio = e.idEdicionDeGranPremio
INNER JOIN circuitos ci ON e.idCircuito = ci.idCircuito
GROUP BY ci.idCircuito
HAVING COUNT(*) >= 1;

-- 3 Vista para identificar los ganadores dhl(vuelta más rapida de un gran premio en una temporada)(check)
CREATE OR REPLACE VIEW ganadoresDeDhl
AS
SELECT DISTINCT idEdicionDeGranPremio, MIN(tiempoEnVuelta(idParticipacionEnVuelta)) OVER(PARTITION BY idEdicionDeGranPremio) AS menorTiempo
FROM EdicionesDeGranPremio
INNER JOIN Carreras USING (idEdicionDeGranPremio)
INNER JOIN Participaciones USING(idCarrera)
INNER JOIN ParticipacionesEnVuelta USING(idParticipacion);

-- 4 Vista para identificar los pilotos que han pertenecido a más de 1 escuderia en una temporada (CHECK)
CREATE OR REPLACE VIEW pilotosCambiosEquipoTemporada 
AS
SELECT t.idTemporada,
       per.nombre, per.apellido,
       COUNT(DISTINCT e.idEscuderia) AS "Cambios Escuderias"
FROM participaciones p
INNER JOIN pilotos pil ON p.idPiloto = pil.idPiloto
INNER JOIN personas per ON pil.idPiloto = per.idPersona
INNER JOIN monoplazas m ON p.idMonoplaza = m.idMonoplaza
INNER JOIN escuderias e ON m.idEscuderia = e.idEscuderia
INNER JOIN carreras c ON p.idCarrera = c.idCarrera
INNER JOIN edicionesDeGranPremio epg ON c.idEdicionDeGranPremio = epg.idEdicionDeGranPremio
INNER JOIN temporadas t ON epg.idTemporada = t.idTemporada
GROUP BY t.idTemporada, pil.idPiloto, per.nombre, per.apellido
HAVING COUNT(DISTINCT e.idEscuderia) > 1;

-- 5 Vista para identificar que eventos de f1 tendran lugar en 3 meses
CREATE OR REPLACE VIEW proximosEventos AS
SELECT idCarrera,
       idTipoCarrera,
       idEdicionDeGranPremio,
       fecha
FROM carreras
WHERE fecha BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '3 MONTH');

-- 6 vista
CREATE OR REPLACE VIEW todasLasParadasEnBoxes
AS
SELECT pv.numeroDeVuelta, pb.tiempo, ta.nombre, ta.descripcion
FROM participacionesEnVuelta pv
INNER JOIN paradasEnBox pb USING(idParticipacionEnVuelta)
INNER JOIN ArreglosPorParadaEnBox apb USING(idParadaEnBox)
INNER JOIN TiposDeArreglo ta USING(idTipoDeArreglo);

-- 7 vista
CREATE OR REPLACE VIEW todasLasSancionesEnEscuderia 
AS
SELECT t.anio, g.nombre, e.nombre AS escuderia, ts.nombre AS tipoSancion
FROM tiposDeSancion ts
INNER JOIN sanciones s USING(idTipoDeSancion)
INNER JOIN participacionesEnSector ps USING(idParticipacionEnSector)
INNER JOIN participacionesEnVuelta pv USING(idParticipacionEnVuelta)
INNER JOIN participaciones p USING(idParticipacion)
INNER JOIN monoplazas m USING(idMonoplaza)
INNER JOIN escuderias e USING(idEscuderia)
INNER JOIN carreras c USING(idCarrera)
INNER JOIN edicionesDeGranPremio ed USING(idEdicionDeGranPremio)
INNER JOIN temporadas t USING(idTemporada)
INNER JOIN grandesPremios g USING (idGranPremio);

-- 8 vista todos los patrocinadores de la formula 1
CREATE OR REPLACE VIEW patrocinadoresDeLaFormula1
AS
SELECT p.nombre as patrocinadorPrincipal,
		gp.nombre as granPremio,
		t.anio
FROM patrocinadores p
INNER JOIN edicionesDeGranPremio egp USING (idPatrocinador)
INNER JOIN grandesPremios gp USING(idGranPremio)
INNER JOIN temporadas t USING(idTemporada);

-- 9 vista pilotos retirados
CREATE OR REPLACE VIEW pilotosRetirados
AS
SELECT per.nombre, per.apellido, fechaDeDebut, fechaDeRetiro
FROM personas per
INNER JOIN pilotos pil ON(per.idPersona = pil.idPiloto)
WHERE pil.fechaDeRetiro IS NOT NULL;

