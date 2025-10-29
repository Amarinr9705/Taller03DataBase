USE DivisionPolitica

GO
--Cargar los datos en una tabla temporal desde un archivo plano
CREATE TABLE #Japon(
Prefectura varchar(50) NOT NULL,
Capital varchar(50) NOT NULL,
Area float NULL,
Poblacion int NULL
)
BULK INSERT #Japon
FROM 'C:\ITM\Diseño de DB\Taller03DataBase\Japon.csv'
WITH (
DATAFILETYPE='char',
FIELDTERMINATOR = ','
)
--Agregar los registros de REGION
DECLARE @IdPais int
SET @IdPais=(SELECT TOP 1 Id FROM Pais WHERE Nombre='Japón')
IF @IdPais is null
BEGIN
--Si el PAIS no existe...
--Obtener el codigo de TIPO REGION
DECLARE @IdTR int
SET @IdTR=(SELECT TOP 1 Id FROM TipoRegion WHERE
TipoRegion='Prefectura')
IF @IdTR is null
BEGIN
INSERT INTO TipoRegion
(TipoRegion)
VALUES('Prefectura')
SET @IdTR=@@IDENTITY
END
--Obtener el codigo de CONTINENTE
DECLARE @IdC int
SET @IdC=(SELECT TOP 1 Id FROM Continente WHERE Nombre='Asia')
IF @IdC is null
BEGIN
INSERT INTO Continente
(Nombre)
VALUES('Asia')
SET @IdC=@@IDENTITY
END
--Agregar el PAIS
INSERT INTO Pais
(Nombre, IdContinente, IdTipoRegion)
VALUES('Japón', @IdC, @IdTR)
SET @IdPais=@@IDENTITY
END

INSERT INTO Region
(Nombre, IdPais, Area, Poblacion)
SELECT J.Prefectura, @IdPais, J.Area, J.Poblacion
FROM #Japon J
--Agregar los registros de CIUDAD
INSERT INTO Ciudad
(Nombre, IdRegion, CapitalRegion)
SELECT J.Capital, R.Id, 1
FROM #Japon J
JOIN Region R ON J.Prefectura=R.Nombre AND
R.IdPais=@IdPais
--Verificando las actualizaciones
SELECT *
FROM Pais P
JOIN Region R ON P.Id=R.IdPais
JOIN Ciudad C ON R.Id=C.IdRegion
WHERE P.Nombre='Japón'



--       Taller 03

-- 1. 
CREATE TABLE Moneda (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Moneda NVARCHAR(100) NOT NULL,
    Sigla NVARCHAR(10),
    Imagen VARBINARY(MAX)
);


INSERT INTO Moneda (Moneda)
SELECT DISTINCT Moneda
FROM Pais
WHERE Moneda IS NOT NULL;


ALTER TABLE Pais
ADD IdMoneda INT;


UPDATE P
SET P.IdMoneda = M.Id
FROM Pais P
INNER JOIN Moneda M ON P.Moneda = M.Moneda;


ALTER TABLE Pais
DROP COLUMN Moneda;


ALTER TABLE Pais
ADD CONSTRAINT FK_Pais_Moneda
FOREIGN KEY (IdMoneda) REFERENCES Moneda(Id);

-- 2. 

ALTER TABLE Pais
ADD Bandera NVARCHAR(255),
    Mapa NVARCHAR(255);

-- Revisar

SELECT * 
FROM sys.tables 

SELECT * 
FROM Moneda

SELECT * 
FROM Pais

SELECT 
    P.Nombre AS Pais,
    M.Moneda AS Moneda
FROM Pais P
JOIN Moneda M ON P.IdMoneda = M.Id;