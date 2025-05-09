select nome,data_nascimento from 
usuario where data_nascimento > (
	select data_nascimento
	from usuario
	where usuario.nome='Leandro' and usuario.locador=True
) and locatario=True