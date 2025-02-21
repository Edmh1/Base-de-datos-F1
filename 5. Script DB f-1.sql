--1 Tabla Continentes
CREATE TABLE Continentes (
  idContinente SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL
);

--2 Tabla Paises
CREATE TABLE Paises (
  idPais SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  idContinente INT NOT NULL,
  FOREIGN KEY(idContinente) REFERENCES Continentes(idContinente)
);

--3 Tabla Ciudades
CREATE TABLE Ciudades (
  idCiudad SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  idPais INT NOT NULL,
  FOREIGN KEY(idPais) REFERENCES Paises(idPais)
);

-- Añadir la capital a pais
ALTER TABLE Paises ADD COLUMN idCapital INT;
ALTER TABLE Paises ADD FOREIGN kEY (idCapital) REFERENCES Ciudades(idCiudad);

--4 Tabla Circuitos
CREATE TABLE Circuitos (
  idCircuito SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  distanciaEnKilometros NUMERIC(5,2) NOT NULL CHECK(distanciaEnKilometros > 0),
  idCiudad INT NOT NULL,
  FOREIGN KEY(idCiudad) REFERENCES Ciudades(idCiudad)
);

--5 Tabla TiposDeTerreno
CREATE TABLE TiposDeTerrenos (
  idTipoDeTerreno SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(100)
);

--6 Tabla Sectores
CREATE TABLE Sectores (
  idSector SERIAL PRIMARY KEY,
  tiempoIdeal TIME,
  numeroDeCurvas INT NOT NULL CHECK(numeroDeCurvas > 0),
  numeroDeRectas INT NOT NULL CHECK(numeroDeRectas > 0 ),
  porcentajeDelCircuito NUMERIC(5,2) NOT NULL CHECK(porcentajeDelCircuito > 0  AND porcentajeDelCircuito <= 100),
  idCircuito INT NOT NULL,
  idTipoDeTerreno INT NOT NULL,
  FOREIGN KEY (idCircuito) REFERENCES Circuitos(idCircuito),
  FOREIGN KEY (idTipoDeTerreno) REFERENCES TiposDeTerrenos(idTipoDeTerreno)
);

--7 Tabla GrandesPremios
CREATE TABLE GrandesPremios (
  idGranPremio SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL
);

--8 Tabla Temporadas
CREATE TABLE Temporadas (
  idTemporada SERIAL PRIMARY KEY,
  anio INT NOT NULL CHECK(anio >= 1950)
);

--9 Tabla Patrocinadores
CREATE TABLE Patrocinadores (
  idPatrocinador SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(100)
);

--10 Tabla EdicionesDeGranPremio
CREATE TABLE EdicionesDeGranPremio (
  idEdicionDeGranPremio SERIAL PRIMARY KEY,
  idCircuito INT NOT NULL,
  idGranPremio INT NOT NULL,
  idTemporada INT NOT NULL,
  idPatrocinador INT,
  FOREIGN KEY (idCircuito) REFERENCES Circuitos(idCircuito),
  FOREIGN KEY (idGranPremio) REFERENCES GrandesPremios(idGranPremio),
  FOREIGN KEY (idTemporada) REFERENCES Temporadas(idTemporada),
  FOREIGN KEY (idPatrocinador) REFERENCES Patrocinadores(idPatrocinador)
);

--11 Tabla TiposDeCarreras
CREATE TABLE TiposDeCarreras (
  idTipoCarrera SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(100)
);

--12 Table Carreras
CREATE TABLE Carreras (
  idCarrera SERIAL PRIMARY KEY,
  fecha DATE NOT NULL CHECK(fecha > '01-01-1950'),
  numeroDeVueltas INT NOT NULL CHECK(numeroDeVueltas > 0),
  idEdicionDeGranPremio INT NOT NULL,
  idTipoCarrera INT NOT NULL,  
  FOREIGN KEY(idEdicionDeGranPremio) REFERENCES EdicionesDeGranPremio(idEdicionDeGranPremio),
  FOREIGN KEY (idTipoCarrera) REFERENCES TiposDeCarreras(idTipoCarrera)
);

--13 Tabla Personas
CREATE TABLE Personas (
  idPersona SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  fechaDeNacimiento DATE NOT NULL CHECK(EXTRACT(YEAR FROM  AGE(CURRENT_DATE, fechaDeNacimiento)) >= 18),
  sexoBiologico VARCHAR(1) NOT NULL CHECK(sexoBiologico IN('M', 'F')),
  idCiudadDeNacimiento INT NOT NULL,
  FOREIGN KEY(idCiudadDeNacimiento) REFERENCES Ciudades(idCiudad)
);

--14 Tabla Pilotos
CREATE TABLE Pilotos (
  idPiloto INT NOT NULL,
  fechaDeDebut DATE NOT NULL CHECK(fechaDeDebut > '01-01-1950'),
  fechaDeRetiro DATE,
  PRIMARY KEY(idPiloto),
  FOREIGN KEY(idPiloto) REFERENCES Personas(idPersona)
);

--15 Tabla Escuderias
CREATE TABLE Escuderias (
  idEscuderia SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  idCiudadBase INT NOT NULL,
  FOREIGN KEY(idCiudadBase) REFERENCES Ciudades(idCiudad)
);

--16 Tabla Monoplazas
CREATE TABLE Monoplazas (
  idMonoplaza SERIAL PRIMARY KEY,
  tipoDeMotor VARCHAR(45) NOT NULL,
  potenciaEnCaballosDeFuerza INT NOT NULL CHECK(potenciaEnCaballosDeFuerza > 0),
  cilindradaEnLitros VARCHAR(45) NOT NULL CHECK(potenciaEnCaballosDeFuerza > 0),
  nombreDelModelo VARCHAR(45) NOT NULL,
  idEscuderia INT NOT NULL,
  FOREIGN KEY(idEscuderia) REFERENCES Escuderias(idEscuderia)
);

--17 Tabla Participaciones
CREATE TABLE Participaciones (
  idParticipacion SERIAL PRIMARY KEY,
  idCarrera INT NOT NULL,
  idPiloto INT NOT NULL,
  idMonoplaza INT NOT NULL,
  FOREIGN KEY(idCarrera) REFERENCES Carreras(idCarrera),
  FOREIGN KEY(idPiloto) REFERENCES Pilotos(idPiloto),
  FOREIGN KEY(idMonoplaza) REFERENCES Monoplazas(idMonoplaza)
);

--18 Tabla PatrocinadoresDeEscuderiaPorTemporada
CREATE TABLE PatrocinadoresDeEscuderiaPorTemporada (
  idTemporada INT NOT NULL,
  idEscuderia INT NOT NULL,
  idPatrocinador INT NOT NULL,
  PRIMARY KEY(idTemporada, idEscuderia, idPatrocinador),
  FOREIGN KEY(idTemporada) REFERENCES Temporadas(idTemporada),
  FOREIGN KEY(idEscuderia) REFERENCES Escuderias(idEscuderia),
  FOREIGN KEY(idPatrocinador) REFERENCES Patrocinadores(idPatrocinador)
);

--19 Tabla Climas
CREATE TABLE Climas (
  idClima SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(100)
);

--20 Tabla TiposDeNeumatico
CREATE TABLE TiposDeNeumatico (
  idTipoDeNeumatico SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL
);

--21 Tabla TiposDeEstrategia
CREATE TABLE TiposDeEstrategia (
  idTipoDeEstrategia SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(200)
);

--22 Tabla ParticipacionesEnVuelta
CREATE TABLE ParticipacionesEnVuelta (
  idParticipacionEnVuelta SERIAL PRIMARY KEY,
  numeroDeVuelta INT NOT NULL,
  consumoDeCombustibleEnLitros FLOAT NOT NULL CHECK(consumoDeCombustibleEnLitros > 0),
  idParticipacion INT NOT NULL,
  idClima INT NOT NULL,
  idTipoDeNeumatico INT NOT NULL,
  idTipoDeEstrategia INT NOT NULL,
  FOREIGN KEY (idParticipacion) REFERENCES Participaciones(idParticipacion),
  FOREIGN KEY(idClima) REFERENCES Climas(idClima),
  FOREIGN KEY(idTipoDeNeumatico) REFERENCES TiposDeNeumatico(idTipoDeNeumatico),
  FOREIGN KEY(idTipoDeEstrategia) REFERENCES TiposDeEstrategia(idTipoDeEstrategia)
);

--23 Table TiposDeAccidente
CREATE TABLE TiposDeAccidente (
  idTipoDeAccidente SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  desccripcion VARCHAR(100)
);

--24 Tabla ParadasEnBox
CREATE TABLE ParadasEnBox (
  idParadaEnBox SERIAL PRIMARY KEY,
  tiempo TIME NOT NULL,
  idParticipacionEnVuelta INT NOT NULL,
  FOREIGN KEY (idParticipacionEnVuelta) REFERENCES ParticipacionesEnVuelta(idParticipacionEnVuelta)
);

--25 Tabla ParticipacionesEnSector
CREATE TABLE ParticipacionesEnSector (
  idParticipacionEnSector SERIAL PRIMARY KEY,
  idParticipacionEnVuelta INT NOT NULL,
  idSector INT NOT NULL,
  tiempo TIME NOT NULL,
  velocidadMaxima NUMERIC(5,2) NOT NULL CHECK(velocidadMaxima > 0),
  FOREIGN KEY(idParticipacionEnVuelta) REFERENCES ParticipacionesEnVuelta(idParticipacionEnVuelta),
  FOREIGN KEY(idSector) REFERENCES Sectores(idSector)
);


--26 Tabla Accidentes
CREATE TABLE Accidentes (
  idParticipacionEnSector INT NOT NULL,
  idTipoDeAccidente INT NOT NULL,
  PRIMARY KEY(idParticipacionEnSector, idTipoDeAccidente),
  FOREIGN KEY(idParticipacionEnSector) REFERENCES ParticipacionesEnSector(idParticipacionEnSector),
  FOREIGN KEY(idTipoDeAccidente) REFERENCES TiposDeAccidente(idTipoDeAccidente)
);

--27 Tabla TiposDeSancion
CREATE TABLE TiposDeSancion (
  idTipoDeSancion SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(100),
  valorMulta NUMERIC(5,2) NOT NULL
);

--28 Tabla Sanciones
CREATE TABLE Sanciones (
  idSancion SERIAL PRIMARY KEY,
  vigencia BOOLEAN NOT NULL,
  idTipoDeSancion INT NOT NULL,
  idParticipacionEnSector INT NOT NULL,
  FOREIGN KEY(idTipoDeSancion)REFERENCES TiposDeSancion(idTipoDeSancion),
  FOREIGN KEY(idParticipacionEnSector) REFERENCES ParticipacionesEnSector(idParticipacionEnSector)
);

--29 Tabla TiposDeArreglo
CREATE TABLE TiposDeArreglo (
  idTipoDeArreglo SERIAL PRIMARY KEY,
  nombre VARCHAR(45) NOT NULL,
  descripcion VARCHAR(200)
);

--30 Tabla ArreglosPorParada
CREATE TABLE ArreglosPorParadaEnBox (
  idArregloPorParadaEnBox SERIAL PRIMARY KEY,
  idTipoDeArreglo INT NOT NULL,
  idParadaEnBox INT NOT NULL,
  FOREIGN KEY(idTipoDeArreglo) REFERENCES TiposDeArreglo(idTipoDeArreglo),
  FOREIGN KEY(idParadaEnBox) REFERENCES ParadasEnBox(idParadaEnBox)
);



-- Tabla 1 Continentes
INSERT INTO Continentes (nombre) VALUES ('África');
INSERT INTO Continentes (nombre) VALUES ('Asia');
INSERT INTO Continentes (nombre) VALUES ('Europa');
INSERT INTO Continentes (nombre) VALUES ('América');
INSERT INTO Continentes (nombre) VALUES ('Oceanía');

-- Tabla 2 paises
INSERT INTO Paises (nombre, idContinente) VALUES ('Baréin', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('China', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('Azerbaiyán', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('Singapur', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('Japón', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('Arabia Saudita', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('Abu Dabi', 2);
INSERT INTO Paises (nombre, idContinente) VALUES ('España', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Mónaco', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Francia', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Austria', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Reino Unido', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Hungría', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Bélgica', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Países Bajos', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Italia', 3);
INSERT INTO Paises (nombre, idContinente) VALUES ('Canadá', 4);
INSERT INTO Paises (nombre, idContinente) VALUES ('Estados Unidos', 4);
INSERT INTO Paises (nombre, idContinente) VALUES ('México', 4);
INSERT INTO Paises (nombre, idContinente) VALUES ('Brasil', 4);
INSERT INTO Paises (nombre, idContinente) VALUES ('Australia', 5);

--Tabla 3 Ciudades
-- Australia (idPais = 21)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Canberra', 21); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Sídney', 21);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Melbourne', 21);
-- Baréin (idPais = 1)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Manama', 1); -- Capital
-- China (idPais = 2)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Pekín', 2); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Shanghái', 2);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Guangzhou', 2);
-- España (idPais = 8)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Madrid', 8); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Barcelona', 8);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Valencia', 8);
-- Mónaco (idPais = 9)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Mónaco', 9); -- Capital
-- Azerbaiyán (idPais = 3)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Bakú', 3); -- Capital
-- Canadá (idPais = 17)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Ottawa', 17); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Toronto', 17);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Vancouver', 17);
-- Francia (idPais = 10)
INSERT INTO Ciudades (nombre, idPais) VALUES ('París', 10); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Marsella', 10);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Lyon', 10);
-- Austria (idPais = 11)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Viena', 11); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Salzburgo', 11);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Graz', 11);
-- Reino Unido (idPais = 12)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Londres', 12); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Manchester', 12);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Edimburgo', 12);
-- Hungría (idPais = 13)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Budapest', 13); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Debrecen', 13);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Szeged', 13);
-- Bélgica (idPais = 14)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Bruselas', 14); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Amberes', 14);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Gante', 14);
-- Países Bajos (idPais = 15)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Ámsterdam', 15); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Róterdam', 15);
INSERT INTO Ciudades (nombre, idPais) VALUES ('La Haya', 15);
-- Italia (idPais = 16)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Roma', 16); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Milán', 16);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Nápoles', 16);
-- Singapur (idPais = 4)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Singapur', 4); -- Ciudad-estado, capital
-- Japón (idPais = 5)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Tokio', 5); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Osaka', 5);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Kioto', 5);
-- Estados Unidos (idPais = 18)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Miami', 18);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Las Vegas', 18);
-- México (idPais = 19)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Ciudad de México', 19); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Guadalajara', 19);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Monterrey', 19);
-- Brasil (idPais = 20)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Brasilia', 20); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('São Paulo', 20);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Río de Janeiro', 20);
-- Arabia Saudita (idPais = 6)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Riad', 6); -- Capital
INSERT INTO Ciudades (nombre, idPais) VALUES ('Yeda', 6);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Dammam', 6);
-- Abu Dabi (Emiratos Árabes Unidos) (idPais = 7)
INSERT INTO Ciudades (nombre, idPais) VALUES ('Abu Dabi', 7); -- Capital de EAU
INSERT INTO Ciudades (nombre, idPais) VALUES ('Dubái', 7);
INSERT INTO Ciudades (nombre, idPais) VALUES ('Sharjah', 7);


-- tabla 4 circuitos
-- Insertar datos en la tabla Circuitos
-- Gran Premio de Montecarlo - Mónaco, Mónaco (idCiudad = 11)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Circuito de Montecarlo', 3.34, 11);
-- Gran Premio de Monza - nápoles, Italia (idCiudad = 36)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Autodromo Nazionale Monza', 5.79, 36);
-- Gran Premio de Suzuka - Suzuka, Japón (más cerca de Nagoya, Japón) (idCiudad = 38) tokio
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Suzuka International Racing Course', 5.81, 38);
-- Gran Premio de Spa-Francorchamps - Spa, Bélgica (más cerca de Liège, Bélgica) (idCiudad = 28) bruselas
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Circuit de Spa-Francorchamps', 7.00, 28);
-- Gran Premio de Silverstone - Silverstone, Reino Unido (más cerca de Northampton, Reino Unido) (idCiudad = 23) manchester
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Silverstone Circuit', 5.89, 23);
-- Gran Premio de Melbourne - Melbourne, Australia (idCiudad = 3)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Albert Park Circuit', 5.303, 3);
-- Gran Premio de Interlagos - São Paulo, Brasil (idCiudad = 47)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Autódromo José Carlos Pace', 4.309, 47);
-- Gran Premio de Mónaco - Mónaco, Mónaco (idCiudad = 11)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Circuito de Mónaco', 3.34, 11);
-- Gran Premio de Singapur - Singapur (idCiudad = 37)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Marina Bay Street Circuit', 5.063, 37);
-- Gran Premio de Abu Dhabi - Abu Dhabi, Emiratos Árabes Unidos (idCiudad = 52)
INSERT INTO Circuitos (nombre, distanciaEnKilometros, idCiudad)
VALUES ('Yas Marina Circuit', 5.554, 52);

-- tabla 5 Tipos de terrono
INSERT INTO TiposDeTerrenos (nombre, descripcion) VALUES
('Asfalto', 'Superficie lisa y uniforme, común en la mayoría de los circuitos de Fórmula 1.'),
('Grava', 'Superficie suelta compuesta de pequeñas piedras, rara vez utilizada en circuitos modernos.'),
('Hierba', 'Superficie natural compuesta de césped o hierba, generalmente alrededor de la pista.'),
('Tierra', 'Superficie natural sin pavimentar, a menudo utilizada en pistas de rally.'),
('Pavimento desigual', 'Asfalto con irregularidades y baches, lo que puede ser desafiante para los pilotos.');

-- tabla 6 sectores
INSERT INTO Sectores (numeroDeCurvas, numeroDeRectas, porcentajeDelCircuito, idCircuito, idTipoDeTerreno) VALUES
(3, 1, 20, 1, 3),
(4, 1, 30, 1, 2),
(1, 3, 50, 1, 3),
(2, 2, 17, 2, 1),
(1, 3, 46, 2, 3),
(1, 4, 34, 2, 2),
(4, 3, 10, 3, 5),
(2, 2, 67, 3, 1),
(3, 1, 23, 3, 4),
(1, 3, 25, 4, 2),
(3, 1, 75, 4, 4),
(2, 2, 18, 5, 4),
(1, 4, 82, 5, 5),
(3, 1, 55, 6, 2),
(2, 2, 45, 6, 3),
(1, 3, 22, 7, 3),
(1, 3, 78, 7, 1),
(1, 4, 67, 8, 1),
(3, 1, 33, 8, 4),
(2, 2, 57, 9, 5),
(4, 3, 43, 9, 2),
(3, 1, 80, 10, 4),
(2, 2, 20, 10, 5);

-- Tabla 7 Grandes premios
INSERT INTO GrandesPremios (nombre) VALUES
('Gran Premio de Montecarlo'),
('Gran Premio de Monza'),
('Gran Premio de Suzuka'),
('Gran Premio de Spa-Francorchamps'),
('Gran Premio de Silverstone'),
('Gran Premio de Melbourne'),
('Gran Premio de Interlagos'),
('Gran Premio de Mónaco'),
('Gran Premio de Singapur'),
('Gran Premio de Abu Dhabi');


-- Tabla 8 temporadas
INSERT INTO Temporadas (anio)
VALUES
(1950),(1951),(1952),(1953),(1954),(1955),(1956),(1957),
(1958),(1959),(1960),(1961),(1962),(1963),(1964),(1965),
(1966),(1967),(1968),(1969),(1970),(1971),(1972),(1973),
(1974),(1975),(1976),(1977),(1978),(1979),(1980),(1981),
(1982),(1983),(1984),(1985),(1986),(1987),(1988),(1989),
(1990),(1991),(1992),(1993),(1994),(1995),(1996),(1997),
(1998),(1999),(2000),(2001),(2002),(2003),(2004),(2005),
(2006),(2007),(2008),(2009),(2010),(2011),(2012),(2013),
(2014),(2015),(2016),(2017),(2018),(2019),(2020),(2021),
(2022),(2023),(2024);

-- tabla 9 patrocinadores
INSERT INTO Patrocinadores (nombre, descripcion) VALUES
('Pirelli', 'Proveedor oficial de neumáticos para la Fórmula 1.'),
('Rolex', 'Patrocinador de cronometraje y tiempo oficial de la Fórmula 1.'),
('Petronas', 'Patrocinador principal y proveedor de lubricantes para Mercedes AMG Petronas F1 Team.'),
('Red Bull', 'Patrocinador principal del equipo Red Bull Racing.'),
('Shell', 'Proveedor de combustible y lubricantes para Scuderia Ferrari.'),
('Emirates', 'Aerolínea oficial y patrocinador global de la Fórmula 1.'),
('Heineken', 'Patrocinador oficial de eventos y promociones de la Fórmula 1.'),
('DHL', 'Socio logístico oficial de la Fórmula 1.'),
('Aramco', 'Patrocinador global de la Fórmula 1.'),
('Haas Automation', 'Patrocinador principal del equipo Haas F1 Team.'),
('Cognizant', 'Patrocinador principal del equipo Aston Martin Cognizant F1 Team.'),
('Infiniti', 'Patrocinador y socio técnico del equipo Renault F1 Team.'),
('Monster Energy', 'Patrocinador del equipo Mercedes AMG Petronas F1 Team.'),
('AT&T', 'Socio tecnológico oficial de la Fórmula 1.'),
('Alfa Romeo', 'Patrocinador principal del equipo Alfa Romeo Racing.'),
('McLaren', 'Patrocinador y equipo de Fórmula 1.'),
('Williams Racing', 'Patrocinador y equipo de Fórmula 1.'),
('Total', 'Proveedor de combustible y lubricantes para varios equipos de F1.'),
('Honda', 'Proveedor de motores y patrocinador del equipo Red Bull Racing.'),
('Renault', 'Proveedor de motores y patrocinador del equipo Renault F1 Team.'),
('Microsoft', 'Socio tecnológico oficial de varios equipos de F1.'),
('Amazon Web Services', 'Socio de servicios en la nube y análisis de datos de la Fórmula 1.'),
('Cisco', 'Proveedor de infraestructura de red para la Fórmula 1.'),
('IBM', 'Socio tecnológico y proveedor de soluciones de inteligencia artificial.'),
('Intel', 'Proveedor de tecnología y análisis de datos.'),
('IBM', 'Proveedor de tecnología y análisis de datos.'),
('Hewlett Packard Enterprise', 'Proveedor de soluciones de TI y análisis de datos.'),
('Logitech', 'Proveedor de equipos de simulación y tecnología para la Fórmula 1.'),
('SAP', 'Proveedor de soluciones de software y análisis de datos para equipos de F1.'),
('Adobe', 'Socio de marketing digital y contenido para la Fórmula 1.'),
('Salesforce', 'Proveedor de soluciones de CRM y análisis de datos.'),
('Vodafone', 'Proveedor de telecomunicaciones y patrocinador de la Fórmula 1.'),
('Tata Communications', 'Proveedor de soluciones de conectividad y transmisión para la Fórmula 1.'),
('NetApp', 'Proveedor de soluciones de almacenamiento y gestión de datos.'),
('Accenture', 'Proveedor de soluciones de consultoría y tecnología para la Fórmula 1.'),
('Capgemini', 'Proveedor de soluciones de TI y consultoría para equipos de F1.'),
('Kaspersky', 'Proveedor de soluciones de ciberseguridad para equipos de F1.');

-- tabla 10 ediciones de gran premio
INSERT INTO EdicionesDeGranPremio (idCircuito, idGranPremio, idTemporada, idPatrocinador) VALUES
(1, 1, 75, 1), 
(2, 2, 75, 2),
(3, 3, 74, 3),
(4, 4, 74, 4),
(5, 5, 74, 5),
(6, 6, 73, 6),
(7, 7, 73, 7),
(8, 8, 73, 8),
(9, 9, 72, 9),
(10, 10, 72, 10);

-- tabla 11 Tipos de carrera
INSERT INTO TiposDeCarreras (nombre, descripcion) VALUES
('Sprint', 'Carrera corta que determina la parrilla de salida para el Gran Premio.'),
('Sprint Qualifying', 'Carrera corta que determina la parrilla de salida para el Gran Premio.'),
('Qualy', 'Sesión para determinar las posiciones de salida para la carrera.'),
('Final', 'Carrera principal del fin de semana, generalmente el domingo.'),
('Práctica 1', 'Primera sesión de práctica libre del fin de semana.'),
('Práctica 2', 'Segunda sesión de práctica libre del fin de semana.'),
('Práctica 3', 'Tercera sesión de práctica libre del fin de semana.');

-- tabla 12 carreras
INSERT INTO Carreras(fecha, numeroDeVueltas, idEdicionDeGranPremio, idTipoCarrera) VALUES
('2024-01-01', 5, 1, 1),
('2024-01-02', 5, 1, 3),
('2024-01-03', 5, 1, 4),

('2024-02-01', 5, 2, 5),
('2024-02-02', 5, 2, 3),
('2024-02-03', 5, 2, 4),

('2023-03-01', 5, 3, 1),
('2023-03-02', 5, 3, 3),
('2023-03-03', 5, 3, 4),

('2023-04-01', 5, 4, 5),
('2023-04-02', 5, 4, 3),
('2023-04-03', 5, 4, 4),

('2023-05-01', 5, 5, 5),
('2023-05-02', 5, 5, 3),
('2023-05-03', 5, 5, 4),

('2022-06-01', 5, 6, 1),
('2022-06-02', 5, 6, 3),
('2022-06-03', 5, 6, 4),

('2022-07-01', 5, 7, 5),
('2022-07-02', 5, 7, 3),
('2022-07-03', 5, 7, 4),

('2022-08-01', 5, 8, 1),
('2022-08-02', 5, 8, 3),
('2022-08-03', 5, 8, 4),

('2021-09-01', 5, 9, 5),
('2021-09-02', 5, 9, 3),
('2021-09-03', 5, 9, 4),

('2021-10-01', 5, 10, 5),
('2021-10-02', 5, 10, 3),
('2021-10-03', 5, 10, 4);


-- tabla 13 y 14 pilotos y personas
CREATE OR REPLACE PROCEDURE insertar_persona_y_piloto(
    IN nombre VARCHAR(45),
    IN apellido VARCHAR(45),
    IN fechaDeNacimiento DATE,
    IN sexoBiologico VARCHAR(1),
    IN idCiudadDeNacimiento INT,
    IN fechaDeDebut DATE,
    IN fechaDeRetiro DATE DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    nueva_persona_id INT;
BEGIN
    -- Insertar en la tabla Personas
    INSERT INTO Personas (nombre, apellido, fechaDeNacimiento, sexoBiologico, idCiudadDeNacimiento)
    VALUES (nombre, apellido, fechaDeNacimiento, sexoBiologico, idCiudadDeNacimiento)
    RETURNING idPersona INTO nueva_persona_id;

    -- Insertar en la tabla Pilotos
    INSERT INTO Pilotos (idPiloto, fechaDeDebut, fechaDeRetiro)
    VALUES (nueva_persona_id, fechaDeDebut, fechaDeRetiro);
END;
$$;
-- Insertar datos en las tablas Personas y Pilotos
CALL insertar_persona_y_piloto(
    'Lewis', 'Hamilton', '1985-01-07', 'M', 22, -- Londres, Reino Unido
    '2007-03-18', NULL
);
CALL insertar_persona_y_piloto(
    'Max', 'Verstappen', '1997-09-30', 'M', 28, -- Hasselt, Bélgica
    '2015-03-15', NULL
);
CALL insertar_persona_y_piloto(
    'Charles', 'Leclerc', '1997-10-16', 'M', 11, -- Mónaco, Mónaco
    '2018-03-25', NULL
);
CALL insertar_persona_y_piloto(
    'Sebastian', 'Vettel', '1987-07-03', 'M', 31, -- Heppenheim, Alemania
    '2007-06-17', '2022-11-20'
);
CALL insertar_persona_y_piloto(
    'Fernando', 'Alonso', '1981-07-29', 'M', 8, -- Oviedo, España
    '2001-03-04', NULL
);
CALL insertar_persona_y_piloto(
    'Sergio', 'Pérez', '1990-01-26', 'M', 44, -- Guadalajara, México
    '2011-03-27', NULL
);
CALL insertar_persona_y_piloto(
    'Daniel', 'Ricciardo', '1989-07-01', 'M', 3, -- Perth, Australia
    '2011-07-10', NULL
);
CALL insertar_persona_y_piloto(
    'Kimi', 'Raikkonen', '1979-10-17', 'M', 18, -- Lyon, Francia
    '2001-03-04', '2021-12-12'
);
CALL insertar_persona_y_piloto(
    'Carlos', 'Sainz', '1994-09-01', 'M', 8, -- Madrid, España
    '2015-03-15', NULL
);
CALL insertar_persona_y_piloto(
    'Pierre', 'Gasly', '1996-02-07', 'M', 16, -- Rouen, Francia
    '2017-10-01', NULL
);

-- tabla 15 escuderías
INSERT INTO Escuderias (nombre, idCiudadBase) VALUES
('Red Bull Racing', 24), -- Milton Keynes (idCiudad: 24 - Reino Unido)
('Mercedes AMG Petronas', 24), -- Brackley (idCiudad: 24 - Reino Unido)
('Scuderia Ferrari', 35), -- Maranello (idCiudad: 35 - Italia)
('McLaren', 24), -- Woking (idCiudad: 24 - Reino Unido)
('Alpine F1 Team', 24), -- Enstone (idCiudad: 24 - Reino Unido)
('AlphaTauri', 35), -- Faenza (idCiudad: 35 - Italia)
('Aston Martin', 24), -- Silverstone (idCiudad: 24 - Reino Unido)
('Williams Racing', 24), -- Grove (idCiudad: 24 - Reino Unido)
('Alfa Romeo', 35), -- Hinwil (idCiudad: 35 - Italia)
('Haas F1 Team', 42); -- Kannapolis (idCiudad: 42 - Estados Unidos)

-- tabla 16 monoplazas
INSERT INTO Monoplazas (tipoDeMotor, potenciaEnCaballosDeFuerza, cilindradaEnLitros, nombreDelModelo, idEscuderia) VALUES
('V6 Turbo Híbrido', 1000, '1.6L', 'RB19', 1),
('V6 Turbo Híbrido', 1000, '1.6L', 'RB20', 1),
('V6 Turbo Híbrido', 950, '1.6L', 'W13', 2),
('V6 Turbo Híbrido', 950, '1.6L', 'W14', 2),
('V6 Turbo Híbrido', 950, '1.6L', 'SF21', 3),
('V6 Turbo Híbrido', 950, '1.6L', 'SF22', 3),
('V6 Turbo Híbrido', 940, '1.6L', 'MCL35M', 4),
('V6 Turbo Híbrido', 940, '1.6L', 'MCL36', 4),
('V6 Turbo Híbrido', 940, '1.6L', 'A521', 5),
('V6 Turbo Híbrido', 940, '1.6L', 'A522', 5),
('V6 Turbo Híbrido', 930, '1.6L', 'AT02', 6),
('V6 Turbo Híbrido', 930, '1.6L', 'AT03', 6),
('V6 Turbo Híbrido', 930, '1.6L', 'AMR21', 7),
('V6 Turbo Híbrido', 930, '1.6L', 'AMR22', 7),
('V6 Turbo Híbrido', 920, '1.6L', 'FW43B', 8),
('V6 Turbo Híbrido', 920, '1.6L', 'FW44', 8),
('V6 Turbo Híbrido', 920, '1.6L', 'C41', 9),
('V6 Turbo Híbrido', 920, '1.6L', 'C42', 9),
('V6 Turbo Híbrido', 900, '1.6L', 'VF-21', 10),
('V6 Turbo Híbrido', 900, '1.6L', 'VF-22', 10);


--tabla 17 participaciones
INSERT INTO Participaciones(idCarrera, idPiloto, idMonoplaza) VALUES
(1, 1, 1),(1, 2, 2),(1, 3, 3),(1, 4, 4),(1, 5, 5),
(2, 1, 1),(2, 2, 2),(2, 3, 3),(2, 4, 4),(2, 5, 5),
(3, 1, 1),(3, 2, 2),(3, 3, 3),(3, 4, 4),(3, 5, 5),
(4, 1, 1),(4, 2, 2),(4, 3, 3),(4, 4, 4),(4, 5, 5),
(5, 1, 1),(5, 2, 2),(5, 3, 3),(5, 4, 4),(5, 5, 5),
(6, 1, 1),(6, 2, 2),(6, 3, 3),(6, 4, 4),(6, 5, 5),
(7, 1, 1),(7, 2, 2),(7, 3, 3),(7, 4, 4),(7, 5, 5),
(8, 1, 1),(8, 2, 2),(8, 3, 3),(8, 4, 4),(8, 5, 5),
(9, 1, 1),(9, 2, 2),(9, 3, 3),(9, 4, 4),(9, 5, 5),
(10, 1, 1),(10, 2, 2),(10, 3, 3),(10, 4, 4),(10, 5, 5),
(11, 1, 1),(11, 2, 2),(11, 3, 3),(11, 4, 4),(11, 5, 5),
(12, 1, 1),(12, 2, 2),(12, 3, 3),(12, 4, 4),(12, 5, 5),
(13, 1, 1),(13, 2, 2),(13, 3, 3),(13, 4, 4),(13, 5, 6),
(14, 1, 1),(14, 2, 2),(14, 3, 7),(14, 4, 4),(14, 5, 5),
(15, 1, 1),(15, 2, 2),(15, 3, 7),(15, 4, 4),(15, 5, 5),
(16, 1, 1),(16, 2, 2),(16, 6, 7), (16, 8, 8),(16, 5, 6),
(17, 1, 6),(17, 2, 1),(17, 6, 8), (17, 8, 7),(17, 5, 5),
(18, 1, 1),(18, 2, 1),(18, 6, 3), (18, 8, 7),(18, 5, 5),
(19, 1, 6),(19, 2, 1),(19, 6, 8), (19, 8, 7),(19, 5, 5),
(20, 1, 1),(20, 2, 2),(20, 6, 7), (20, 8, 8),(20, 5, 6),
(21, 1, 6),(21, 2, 1),(21, 6, 8), (21, 8, 3),(21, 5, 5),
(22, 1, 1),(22, 2, 2),(22, 6, 7), (22, 8, 4),(22, 5, 6),
(23, 1, 6),(23, 2, 1),(23, 6, 8), (23, 4, 3),(23, 5, 5),
(24, 1, 1),(24, 2, 2),(24, 6, 7), (24, 4, 4),(24, 5, 6),
(25, 1, 6),(25, 2, 1),(25, 6, 8), (25, 4, 3),(25, 5, 6),
(26, 1, 1),(26, 2, 2),(26, 6, 7), (26, 4, 4),(26, 5, 6),
(27, 1, 6),(27, 2, 1),(27, 6, 8), (27, 4, 3),(27, 5, 5),
(28, 7, 10),(28, 2, 9),(28, 6, 7), (28, 4, 4),(28, 5, 5),
(29, 7, 9),(29, 2, 10),(29, 6, 8), (29, 4, 4),(29, 5, 5),
(30, 7, 9),(30, 2, 10),(30, 6, 7), (30, 4, 4),(30, 5, 5);

-- tabla 18 patrocinadores de escudería por temporada
INSERT INTO PatrocinadoresDeEscuderiaPorTemporada (idTemporada, idEscuderia, idPatrocinador)
SELECT 
    (random() * 74 + 1)::INT AS idTemporada, 
    (random() * 9 + 1)::INT AS idEscuderia, 
    (random() * 36 + 1)::INT AS idPatrocinador
FROM generate_series(1, 120);

-- tabla 19 climas
INSERT INTO Climas (nombre, descripcion) VALUES
('Soleado', 'Condiciones climáticas sin nubes, con sol brillante.'),
('Nublado', 'Cielo cubierto de nubes, sin precipitación.'),
('Lluvia Ligera', 'Lluvia leve, puede afectar la adherencia.'),
('Lluvia Moderada', 'Lluvia constante, condiciones desafiantes.'),
('Lluvia Intensa', 'Lluvia fuerte, visibilidad y adherencia reducidas.'),
('Tormenta', 'Condiciones severas con posibilidad de rayos y truenos.'),
('Viento Fuerte', 'Ráfagas de viento que pueden afectar la aerodinámica.'),
('Neblina', 'Visibilidad reducida debido a la neblina.'),
('Calor Extremo', 'Temperaturas muy altas, afecta el rendimiento del coche.'),
('Frío Extremo', 'Temperaturas muy bajas, afecta la tracción y el rendimiento.');

-- tabla 20 neumáticos
INSERT INTO TiposDeNeumatico (nombre) VALUES
('Duro'),
('Medio'),
('Blando'),
('Superblando'),
('Ultrablando'),
('Hipersuave'),
('Intermedio'),
('De Lluvia'),
('De Mojado Extremo'),
('De Clasificación');

-- tabla 21 tipos de estrategias
INSERT INTO TiposDeEstrategia (nombre, descripcion) VALUES
('Coche de Seguridad', 'Aprovechar las situaciones de Coche de Seguridad para realizar una parada en boxes y ganar posiciones.'),
('Estrategia Mixta', 'Combinar diferentes tipos de neumáticos y paradas en boxes para adaptarse a las condiciones de la pista.'),
('Sobrecarga de Combustible', 'Cargar más combustible del necesario para alargar los periodos de carrera y ganar posiciones al evitar paradas extras en boxes.'),
('A Tope', 'Utilizar el máximo rendimiento del coche durante toda la carrera sin preocuparse por la gestión de neumáticos o combustible.'),
('Ahorro de Combustible', 'Reducir el consumo de combustible durante la carrera para minimizar el número de paradas en boxes y optimizar la estrategia global.'),
('Preservación de Neumáticos', 'Enfoque en mantener los neumáticos en buen estado durante la carrera para minimizar el desgaste y mantener un buen rendimiento.'),
('Última Parada Tardía', 'Realizar la última parada en boxes hacia el final de la carrera para tener neumáticos frescos y atacar en las últimas vueltas.'),
('David contra Goliat', 'Adoptar una estrategia arriesgada y poco convencional para sorprender a los rivales y ganar posiciones inesperadas en la carrera.'),
('Adelantamientos Agresivos', 'Realizar maniobras de adelantamiento agresivas y arriesgadas para ganar posiciones en la pista.');

-- tabla 22 participaciones en vuelta
INSERT INTO ParticipacionesEnVuelta (numeroDeVuelta, consumoDeCombustibleEnLitros, idParticipacion, idClima, idTipoDeNeumatico, idTipoDeEstrategia)
SELECT 
    generate_series(1, 5) AS numeroDeVuelta,
    (random() * (3 - 0.5) + 0.5)::FLOAT AS consumoDeCombustibleEnLitros,
    idParticipacion,
    (random() * 9 + 1)::INT AS idClima,
    (random() * 9 + 1)::INT AS idTipoDeNeumatico,
    (random() * 8 + 1)::INT AS idTipoDeEstrategia
FROM (
    SELECT generate_series(1, 150) AS idParticipacion
) AS participaciones;

-- tabla 23 tipos de accientes
INSERT INTO TiposDeAccidente (nombre, desccripcion) VALUES
('Colisión Frontal', 'Choque directo entre dos vehículos en la parte delantera.'),
('Colisión Lateral', 'Choque entre dos vehículos en los laterales.'),
('Colisión Trasera', 'Choque de un vehículo por detrás de otro.'),
('Toque de Ruedas', 'Contacto entre las ruedas de dos vehículos durante una maniobra.'),
('Salida de Pista', 'Cuando un vehículo abandona la pista debido a una maniobra o pérdida de control.'),
('Accidente Múltiple', 'Colisión que involucra a múltiples vehículos en la pista.'),
('Golpe contra Barrera', 'Impacto de un vehículo contra las barreras de protección del circuito.'),
('Avería Mecánica', 'Fallo en el funcionamiento mecánico del vehículo durante la carrera.'),
('Incendio', 'Fuego en el vehículo debido a un problema mecánico o colisión.'),
('Accidente de Vuelco', 'Vehículo volcado sobre su techo debido a una colisión o maniobra brusca.');

-- tabla 24 paradas en box
INSERT INTO ParadasEnBox (tiempo, idParticipacionEnVuelta)
SELECT 
    to_char(
        '00:00:00'::time + (interval '2 seconds' + (random() * (interval '38 seconds')))::interval,
        'HH24:MI:SS'
    )::time AS tiempo,
    idParticipacionEnVuelta
FROM (
    SELECT idParticipacionEnVuelta
    FROM generate_series(1, 750) AS idParticipacionEnVuelta
    ORDER BY random()
    LIMIT 100
) AS unique_participations;

-- tabla 25 participaciones en sector
INSERT INTO ParticipacionesEnSector (idParticipacionEnVuelta, idSector, tiempo, velocidadMaxima)
SELECT 
    idParticipacionEnVuelta,
    idSector,
    to_char(
        '00:01:30'::time + (interval '0 seconds' + (random() * (interval '1 minute 20 seconds')))::interval,
        'HH24:MI:SS'
    )::time AS tiempo,
    (random() * 50 + 250)::NUMERIC(5,2) AS velocidadMaxima
FROM (
    SELECT 
        idParticipacionEnVuelta,
        idSector
    FROM 
        generate_series(1, 750) AS idParticipacionEnVuelta,
        generate_series(1, 23) AS idSector
) AS participaciones;

-- tabla 26 accidentes
INSERT INTO Accidentes (idParticipacionEnSector, idTipoDeAccidente)
SELECT
    (random() * 17249 + 1)::INT AS idParticipacionEnSector,
    (random() * 9 + 1)::INT AS idTipoDeAccidente
FROM 
    generate_series(1, 50) AS series;
	
-- tabla 27 tipos de sanciones
INSERT INTO TiposDeSancion (nombre, descripcion, valorMulta) VALUES
('Advertencia', 'Notificación oficial de una infracción sin imponer una multa.', 0.00),
('Multas', 'Sanción económica impuesta por una infracción o incumplimiento de las normas.', 100.00),
('Pérdida de Puntos', 'Retiro de puntos del campeonato debido a una infracción grave.', 0.00),
('Suspensión Temporal', 'Prohibición temporal de participar en competiciones como resultado de una infracción grave.', 0.00),
('Desclasificación', 'Eliminación de los resultados de una carrera debido a una infracción del reglamento.', 0.00);

-- tabla 28 sanciones
INSERT INTO Sanciones (vigencia, idTipoDeSancion, idParticipacionEnSector)
SELECT
    (random() < 0.5) AS vigencia, -- Esto generará TRUE o FALSE aleatoriamente
    (random() * 4 + 1)::INT AS idTipoDeSancion,
    (random() * 17249 + 1)::INT AS idParticipacionEnSector
FROM 
    generate_series(1, 20) AS series;

-- tabla 29 tipos de arreglo
INSERT INTO TiposDeArreglo (nombre, descripcion) VALUES
('Cambio de Neumáticos', 'Sustitución de los neumáticos desgastados por nuevos para mejorar el agarre y el rendimiento.'),
('Ajuste de Alas', 'Modificación de los ángulos de las alas delanteras o traseras para mejorar la aerodinámica y el equilibrio del coche.'),
('Ajuste de Suspensión', 'Modificación de la configuración de la suspensión para adaptarse a las condiciones de la pista y mejorar la estabilidad.'),
('Reparación de Daños', 'Reparación de daños en la carrocería, alerones u otros componentes del coche causados por colisiones o impactos.'),
('Reabastecimiento de Combustible', 'Llenado del depósito de combustible para asegurar la cantidad necesaria para la siguiente etapa de la carrera.'),
('Ajuste de Presión de Neumáticos', 'Modificación de la presión de los neumáticos para adaptarse a las condiciones de la pista y optimizar el rendimiento.'),
('Cambio de Configuración', 'Modificación de la configuración general del coche, como la distribución de peso o la altura del chasis, para mejorar el manejo y la velocidad.'),
('Revisión de Motor', 'Inspección y ajuste del motor para garantizar un rendimiento óptimo y prevenir problemas mecánicos durante la carrera.');

-- tabla 30 arreglos por parada
INSERT INTO ArreglosPorParadaEnBox (idTipoDeArreglo, idParadaEnBox)
SELECT
    (random() * 7 + 1)::INT AS idTipoDeArreglo,
    (random() * 99 + 1)::INT AS idParadaEnBox
FROM generate_series(1, 150);