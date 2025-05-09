SELECT 
    P.cpf_locador, u.nome,l.cidade,
    COUNT(P.cpf_locador) AS numero_de_propriedades,
	COUNT(R.cpf_locador) AS total_locacoes
FROM 
    Propriedade as P
JOIN usuario as U
on P.cpf_locador=U.cpf
JOIN localizacao as L
on L.id_localizacao=U.id_localizacao
JOIN reserva as R
on R.cpf_locador=U.cpf
GROUP BY 
    p.cpf_locador,u.nome,l.cidade
HAVING 
    COUNT(*) >= 5