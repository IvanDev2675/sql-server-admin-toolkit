---Envio de correo electronico despues de configurar database mail

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'AdministradorSQL',  
    @recipients = 'Jaimerivan@gmail.com',  
    @body = 'Esta es una prueba de envio de correo con sp_send_dbmail',  
    @subject = 'Uso de sp_send_dbmail'