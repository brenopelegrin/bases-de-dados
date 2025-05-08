select P.tipo, count(P.tipo) as quantidade_por_tipo
from Propriedade as P
group by P.tipo