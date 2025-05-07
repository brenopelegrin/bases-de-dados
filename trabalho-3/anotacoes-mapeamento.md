## CONJUNTOS DE ENTIDADES (CE)
###Usuário
Chave Primária: CPF
Chaves Estrangeiras: conta_bancaria, id_localizacao
Atributos: nome, sobrenome, data_nascimento, endereço, sexo, telefone, email, senha
Mapeamento: Representado por uma tabela. Chaves estrangeiras apontam para ContaBancaria e Localizacao. Restrição de unicidade em (nome, sobrenome, email).
Observação: A entidade central do sistema, conecta-se à maioria dos relacionamentos.

###Mensagem
Chave Primária: id_mensagem
Chaves Estrangeiras: CPF_remetente, CPF_destinatario
Atributos: texto, timestamp
Mapeamento: Representada por tabela própria. As chaves estrangeiras referenciam dois usuários. Facilita a navegação entre comunicações de usuários.

###Reserva
Chave Primária: id_reserva
Chaves Estrangeiras: CPF_locatario, id_propriedade
Atributos: data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status
Mapeamento: Cada reserva está ligada a um usuário (locatário) e a uma propriedade.

###Conta Bancária
Chave Primária: numero_conta
Atributos: agencia, tipo_conta
Mapeamento: Entidade autônoma. Ligada ao usuário por chave estrangeira.

###Propriedade
Chave Primária: id_propriedade
Chaves Estrangeiras: CPF_locador, CPF_locatario, id_localizacao
Atributos: nome, endereço, tipo, número de quartos, número de banheiros, preço por noite, min/max noites, max_hóspedes, taxa_limpeza, horário entrada/saída, datas_disponíveis
Mapeamento: Representa o bem alugado. Pode ser uma casa (com vários quartos) ou um quarto (individual/compartilhado). Ligada à localização e aos usuários.

###Quarto
Chave Primária: id_quarto
Chave Estrangeira: id_propriedade
Atributos: número_camas, tipo_cama, banheiro_privativo
Mapeamento: Tabela dependente de Propriedade. Aponta que um quarto sempre pertence a uma propriedade.

###Avaliação
Chave Primária: id_avaliacao
Chaves Estrangeiras: id_mensagem, id_propriedade
Atributos: classificações e mensagem
Mapeamento: A avaliação é associada a uma mensagem enviada e a uma propriedade avaliada. Conecta funcionalmente três entidades (via relacionamentos).

###Localização
Chave Primária: id_localizacao
Atributos: cep, cidade, estado, país, bairro
Mapeamento: Usada tanto por Usuario quanto por Propriedade e PontoDeInteresse.

###Ponto de Interesse
Chave Primária: id_ponto_interesse
Chave Estrangeira: id_localizacao
Atributo: nome
Mapeamento: Entidade autônoma relacionada com uma localização específica.

##CONJUNTOS DE RELACIONAMENTOS (CR)

###Alugar
Entre: Usuario (como Locatário) e Propriedade
Mapeamento: Representado pela entidade Reserva, com CPF_locatario e id_propriedade como chaves estrangeiras.
Observação: Implementado como entidade associativa com atributos adicionais (datas, preços).

###Enviar / Receber Mensagem
Entre: Usuario (Remetente/Destinatário) e Mensagem
Mapeamento: Via atributos CPF_remetente e CPF_destinatario na tabela Mensagem.
Observação: Relacionamento muitos-para-muitos modelado com entidade associativa.

###Realizar Avaliação
Entre: Usuario, Mensagem, Propriedade
Mapeamento: Encadeado: o usuário envia uma mensagem que gera uma avaliação sobre uma propriedade. Está implementado indiretamente via Mensagem e Avaliação.
Observação: Um exemplo de relacionamento composto intermediado.

###Tem / Está em Localização
Entre: Usuario, Propriedade, PontoDeInteresse → Localização
Mapeamento: Todas essas entidades têm chaves estrangeiras id_localizacao.
Observação: Um ponto central de agregação geográfica.

###Possui Quarto
Entre: Propriedade e Quarto
Mapeamento: Um para muitos, com id_propriedade como chave estrangeira em Quarto.

###Possui Conta Bancária
Entre: Usuario e ContaBancaria
Mapeamento: Direto, com conta_bancaria como chave estrangeira em Usuario.

###Tem Ponto de Interesse
Entre: Localizacao e PontoDeInteresse
Mapeamento: Um para muitos, com id_localizacao como chave estrangeira em PontoDeInteresse.

