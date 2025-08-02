-- 1. Crear un Login para acceder al servidor SQL
-- Esto es como crear una credencial para entrar al sistema
USE master;
GO
CREATE LOGIN SystemUser WITH PASSWORD = 'Sosa2675';
GO

-- 2. Crear un usuario en la base de datos Northwind para ese login
-- Esto permite al login acceder a esta base específica
USE Northwind;
GO
CREATE USER SystemUser FOR LOGIN SystemUser;
GO

-- 3. Crear un esquema (como una carpeta) para organizar tablas
-- El esquema pertenecerá a nuestro usuario
CREATE SCHEMA Informatica AUTHORIZATION SystemUser;
GO

-- 4. Asignar el esquema por defecto al usuario
-- Todas las tablas nuevas se crearán aquí si no se especifica otro lugar
ALTER USER SystemUser WITH DEFAULT_SCHEMA = Informatica;
GO

-- 5. Dar permisos básicos al usuario
-- Permiso para leer datos (SELECT)
GRANT SELECT TO SystemUser;
-- Permiso para crear tablas (pero solo en su esquema)
GRANT CREATE TABLE TO SystemUser;
GO

-- 6. Agregar al usuario a roles de base de datos
-- Rol para leer cualquier tabla (db_datareader)
EXEC sp_addrolemember 'db_datareader', 'SystemUser';
-- Rol para modificar datos (db_datawriter)
EXEC sp_addrolemember 'db_datawriter', 'SystemUser';
GO

-- 7. Ejemplo: Crear una tabla como si fuéramos el usuario
-- Esto simula ser SystemUser temporalmente
EXECUTE AS USER = 'SystemUser';
CREATE TABLE Informatica.Test (
    Codigo INT NOT NULL PRIMARY KEY,
    Nombre VARCHAR(150)
);
REVERT;  -- Volvemos a ser nuestro usuario normal
GO

-- 8. Eliminar usuario si es necesario (script de limpieza)
USE Northwind;
GO
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'SystemUser')
BEGIN
    DROP USER SystemUser;
    PRINT 'Usuario SystemUser eliminado.';
END
ELSE
BEGIN
    PRINT 'El usuario no existe en esta base de datos.';
END
GO

-- 9. Eliminar login si es necesario (desde master)
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'SystemUser')
BEGIN
    DROP LOGIN SystemUser;
    PRINT 'Login SystemUser eliminado.';
END
ELSE
BEGIN
    PRINT 'El login no existe en el servidor.';
END
GO