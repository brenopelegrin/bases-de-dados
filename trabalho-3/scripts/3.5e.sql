select nome,data_nascimento from 
usuario where data_nascimento >= ALL (
	select data_nascimento
	from usuario
	where usuario.locador=True
) and locatario=True