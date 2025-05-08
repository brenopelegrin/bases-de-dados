DROP TABLE IF EXISTS Avaliacao;
DROP TABLE IF EXISTS Mensagem;
DROP TABLE IF EXISTS Quarto;
DROP TABLE IF EXISTS Reserva;
DROP TABLE IF EXISTS PontoDeInteresse;
DROP TABLE IF EXISTS Propriedade;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Localizacao;
DROP TABLE IF EXISTS ContaBancaria;

CREATE TABLE ContaBancaria (
    /* Certo - atributos */
    /* Certo - restrições */
    numero_conta VARCHAR(12) PRIMARY KEY,
    agencia VARCHAR(12) NOT NULL,
    tipo_conta VARCHAR(10) NOT NULL CHECK (tipo_conta IN ('Corrente', 'Poupança'))
);

CREATE TABLE Localizacao (
    /* Certo - atributos */
    /* Certo - restrições */
    id_localizacao SERIAL PRIMARY KEY,
    cep CHAR(8) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    pais VARCHAR(30) NOT NULL,
    bairro VARCHAR(50) NOT NULL
);

CREATE TABLE Usuario (
    /* Certo - atributos */
    /* Certo - restrições */
    CPF CHAR(11) PRIMARY KEY,
    conta_bancaria VARCHAR(12) NOT NULL,
    id_localizacao INT NOT NULL,
    locador BOOLEAN NOT NULL,
    locatario BOOLEAN NOT NULL,
    nome VARCHAR(20) NOT NULL CHECK (char_length(nome) BETWEEN 2 AND 20),
    sobrenome VARCHAR(80) NOT NULL CHECK (char_length(sobrenome) BETWEEN 2 AND 80),
    data_nascimento DATE NOT NULL CHECK (data_nascimento > DATE '1900-01-01'),
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F')),
    telefone CHAR(11) UNIQUE NOT NULL CHECK (char_length(telefone) BETWEEN 10 AND 11),
    email VARCHAR(256) UNIQUE NOT NULL,
    senha VARCHAR(256) NOT NULL,
    FOREIGN KEY (conta_bancaria) REFERENCES ContaBancaria(numero_conta),
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao),
    UNIQUE (nome, sobrenome)
);

CREATE TABLE Propriedade (
    /* Certo - atributos */
    /* Certo - restrições */
    id_propriedade SERIAL PRIMARY KEY,
    id_localizacao INT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(512),
    tipo VARCHAR(30) CHECK (tipo IN ('casa inteira', 'quarto individual', 'quarto compartilhado')),
    numero_quartos INT NOT NULL CHECK (numero_quartos >= 0),
    numero_banheiros INT NOT NULL CHECK (numero_banheiros >= 0),
    preco_noite BIGINT NOT NULL CHECK (preco_noite >= 0),
    min_noites INT NOT NULL CHECK (min_noites > 0),
    max_noites INT NOT NULL CHECK (max_noites > 0),
    max_hospedes INT NOT NULL CHECK (max_hospedes>0),
    taxa_limpeza BIGINT CHECK (taxa_limpeza >= 0),
    horario_entrada TIMESTAMP,
    horario_saida TIMESTAMP CHECK(horario_saida > horario_entrada),
    datas_disponiveis TIMESTAMP ARRAY,
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao)
);

CREATE TABLE Quarto (
    /* Certo - atributos */
    /* Certo - restrições */
    id_quarto SERIAL PRIMARY KEY,
    id_propriedade INT,
    numero_camas INT CHECK (numero_camas > 0),
    tipo_cama VARCHAR(50),
    banheiro_privativo BOOLEAN,
    FOREIGN KEY (id_propriedade) REFERENCES Propriedade(id_propriedade)
);

CREATE TABLE Mensagem (
    /* Certo - atributos */
    /* Certo - restrições */
    id_mensagem SERIAL PRIMARY KEY,
    CPF_remetente CHAR(11),
    CPF_destinatario CHAR(11),
    texto VARCHAR(1023) NOT NULL,
    criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CPF_remetente) REFERENCES Usuario(CPF),
    FOREIGN KEY (CPF_destinatario) REFERENCES Usuario(CPF)
);

CREATE TABLE Avaliacao (
     /* Certo */
    id_avaliacao SERIAL PRIMARY KEY,
    id_mensagem INT,
    id_propriedade INT,
    classificacao_limpeza INT CHECK (classificacao_limpeza BETWEEN 0 AND 5),
    classificacao_estrutura INT CHECK (classificacao_estrutura BETWEEN 0 AND 5),
    nota_comunicacao INT CHECK (nota_comunicacao BETWEEN 0 AND 10),
    nota_localizacao INT CHECK (nota_localizacao BETWEEN 0 AND 10),
    nota_valor INT CHECK (nota_valor BETWEEN 0 AND 10),
    FOREIGN KEY (id_mensagem) REFERENCES Mensagem(id_mensagem),
    FOREIGN KEY (id_propriedade) REFERENCES Propriedade(id_propriedade)
);

CREATE TABLE Reserva (
    /* Certo - atributos */
    /* Certo - restrições */
    id_reserva SERIAL PRIMARY KEY,
    CPF_locatario CHAR(11),
    CPF_locador CHAR(11),
    id_propriedade INT,
    data_reserva TIMESTAMP NOT NULL,
    data_checkin TIMESTAMP,
    data_checkout TIMESTAMP CHECK (data_checkout > data_checkin),
    numero_hospedes INT NOT NULL CHECK (numero_hospedes >= 1),
    imposto BIGINT NOT NULL, CHECK (imposto > 0),
    preco_total_estadia BIGINT CHECK (preco_total_estadia > 0),
    preco_total_imposto_limpeza BIGINT CHECK (preco_total_imposto_limpeza > 0),
    status BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (CPF_locatario) REFERENCES Usuario(CPF),
    FOREIGN KEY (id_propriedade) REFERENCES Propriedade(id_propriedade)
);

CREATE TABLE PontoDeInteresse (
    /* Certo - atributos */
    /* Certo - restrições */
    id_ponto_interesse SERIAL PRIMARY KEY,
    id_localizacao INT,
    nome VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao)
);