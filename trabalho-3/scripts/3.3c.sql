select L.cidade, count(L.cidade) as quantidade_por_cidade
from Propriedade as P 
join Localizacao as L
on P.id_localizacao = L.id_localizacao
group by L.cidade