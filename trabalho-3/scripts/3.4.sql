select 
  R.id_reserva, 
  R.CPF_locatario, 
  R.id_propriedade, 
  EXTRACT(DAY from (R.data_checkout - R.data_checkin)) as dias_locados, 
  CONCAT(U_locatario.nome, ' ', U_locatario.sobrenome) as nome_hospede, 
  CONCAT(U_locador.nome, ' ', U_locador.sobrenome) as nome_proprietario,
  (R.preco_total_estadia + R.preco_total_imposto_limpeza + imposto)/(100*EXTRACT(DAY from (R.data_checkout - R.data_checkin))) as valor_diaria
from Reserva as R
join Propriedade as P
on P.id_propriedade = R.id_propriedade
join Usuario as U_locatario
on U_locatario.CPF = R.CPF_locatario
join Usuario as U_locador
on U_locador.CPF = R.CPF_locador
where R.status is True and R.data_checkin > '2025-04-24'