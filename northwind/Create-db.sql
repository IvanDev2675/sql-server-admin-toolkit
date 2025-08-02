/* 
   Script de creación de Northwind 
   Incluye:
   - Configuración óptima de filegroups
   - Parámetros de crecimiento calculados
   - Validaciones de seguridad
   - Configuraciones recomendadas para producción
*/

USE master;
GO

-- Limpieza segura si existe
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'Northwind')
BEGIN
    ALTER DATABASE Northwind SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Northwind;
END
GO

-- Creación con parámetros optimizados
CREATE DATABASE Northwind
ON PRIMARY 
(
    NAME = 'NorthwindData',
    FILENAME = 'D:\SQLData\Northwind.mdf',  -- Disco diferente para datos
    SIZE = 100MB,
    FILEGROWTH = 256MB,
    MAXSIZE = UNLIMITED
),
FILEGROUP INDEX_FG
(
    NAME = 'Northwind_Indexes',
    FILENAME = 'E:\SQLIndexes\Northwind_Indexes.ndf',  -- Disco separado para índices
    SIZE = 50MB,
    FILEGROWTH = 128MB
)
LOG ON 
(
    NAME = 'NorthwindLog',
    FILENAME = 'F:\SQLLogs\Northwind_log.ldf',  -- Disco separado para logs
    SIZE = 50MB,
    FILEGROWTH = 128MB,
    MAXSIZE = 2GB
);
GO

-- Configuraciones adicionales
ALTER DATABASE Northwind SET 
    RECOVERY SIMPLE,  -- O FULL según necesidades
    AUTO_UPDATE_STATISTICS_ASYNC ON,
    PAGE_VERIFY CHECKSUM;
GO

-- Mensaje de confirmación
PRINT 'Base de datos Northwind creada con configuración optimizada';
GO