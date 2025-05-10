SELECT U_loc.nome, U_loc.sobrenome, U_loc.cpf
FROM Usuario AS U_loc
WHERE U_loc.locatario = true 
  AND U_loc.data_nascimento < (
    SELECT MAX(U_alf.data_nascimento)
    FROM Usuario AS U_alf
    WHERE U_alf.locador = true	
  );