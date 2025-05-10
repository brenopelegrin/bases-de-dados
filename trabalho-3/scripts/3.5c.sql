SELECT EXTRACT(MONTH FROM R.data_reserva) as mes_reserva, R.status as confirmacao, AVG(R.preco_total_estadia/(EXTRACT(DAY FROM R.data_checkout - R.data_checkin) ))/100 as media_diaria
FROM Reserva as R
JOIN Propriedade as P
ON P.id_propriedade = R.id_propriedade
JOIN Localizacao as L
ON P.id_localizacao = L.id_localizacao
Group by EXTRACT(MONTH FROM R.data_reserva), R.status
Order by mes_reserva