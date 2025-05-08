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
    nome VARCHAR(20) NOT NULL CHECK (char_length(nome) BETWEEN 2 AND 20),
    sobrenome VARCHAR(80) NOT NULL CHECK (char_length(sobrenome) BETWEEN 2 AND 80),
    tipo CHAR NOT NULL CHECK (tipo IN ('Locador', 'Locatario')),
    data_nascimento DATE NOT NULL CHECK (data_nascimento > DATE '1900-01-01'),
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('M', 'F')),
    telefone CHAR(11) UNIQUE NOT NULL CHECK (char_length(telefone) BETWEEN 10 AND 11),
    email VARCHAR(256) UNIQUE NOT NULL,
    senha VARCHAR(256) NOT NULL,
    FOREIGN KEY (conta_bancaria) REFERENCES ContaBancaria(numero_conta),
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao),
    FOREIGN KEY (id_locador) REFERENCES Localizacao(id_locador),
    UNIQUE (nome, sobrenome)
);


CREATE TABLE Propriedade (
    /* Certo - atributos */
    /* Certo - restrições */
    id_propriedade SERIAL PRIMARY KEY,
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
    datas_disponiveis TIMESTAMP ARRAY
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
    FOREIGN KEY (CPF_locador) REFERENCES Usuario(CPF),
    FOREIGN KEY (id_propriedade) REFERENCES Propriedade(id_propriedade)
);

CREATE TABLE PontoDeInteresse (
    /* Certo - atributos */
    /* Certo - restrições */
    id_ponto_interesse SERIAL PRIMARY KEY,
    id_localizacao INT,
    nome VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_localizacao) REFERENCES Localizacao(id_localizacao)
);INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('95603552212', '22890432', 'Corrente');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('69512167843', '73461761', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('23896726832', '90641239', 'Corrente');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('21261287221', '59412293', 'Corrente');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('82503943163', '13360858', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('51079609703', '64876863', 'Corrente');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('43564567341', '80242675', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('32942582989', '36631252', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('72575774783', '76238786', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('55471282932', '89109045', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('17202070897', '80159709', 'Corrente');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('95634651158', '85656551', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('47018668943', '75791416', 'Corrente');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('58607966533', '56848737', 'Poupança');
INSERT INTO ContaBancaria (numero_conta, agencia, tipo_conta) VALUES ('19991053174', '42807747', 'Corrente');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('40376214', 'Nascimento das Flores', 'MT', 'Brasil', 'Bairro Das Indústrias Ii');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('49620098', 'Rezende da Prata', 'SE', 'Brasil', 'Cdi Jatoba');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('85768266', 'Vasconcelos de Minas', 'SP', 'Brasil', 'Lajedo');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('19392558', 'Machado de Sá', 'PE', 'Brasil', 'Xangri-Lá');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('69941994', 'Rocha das Flores', 'RS', 'Brasil', 'Satelite');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('90858023', 'Duarte', 'TO', 'Brasil', 'Bairro Das Indústrias Ii');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('56163381', 'Cirino', 'SE', 'Brasil', 'Novo São Lucas');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('09990480', 'Dias do Galho', 'SE', 'Brasil', 'Vitoria');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('38061264', 'da Rocha Alegre', 'CE', 'Brasil', 'Vitoria');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('78428967', 'Cavalcanti', 'PE', 'Brasil', 'Nova Pampulha');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('90284152', 'Fogaça', 'ES', 'Brasil', 'Conjunto Capitão Eduardo');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('26105333', 'Rodrigues Alegre', 'TO', 'Brasil', 'Olaria');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('38993210', 'Rocha das Flores', 'PB', 'Brasil', 'São Gonçalo');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('25903010', 'da Rosa do Oeste', 'AP', 'Brasil', 'Novo Ouro Preto');
INSERT INTO Localizacao (cep, cidade, estado, pais, bairro) VALUES ('75772249', 'da Luz', 'AP', 'Brasil', 'Taquaril');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('05764982111', '19991053174', 1, 'Francisco', 'Nogueira', '1971-07-08', 'F', '9233899593', 'caua67@example.net', '+PYkNz9VG62Z');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('71946802549', '47018668943', 2, 'Luan', 'da Paz', '1961-07-28', 'M', '9149978278', 'yviana@example.com', 'i@Z&O)6fZ34L');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('18597302488', '58607966533', 3, 'Otto', 'Moura', '2002-05-07', 'M', '9984514056', 'isiscamara@example.org', 'A@Z4RPjiJb5n');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('92045867374', '72575774783', 4, 'Gustavo Henrique', 'Alves', '1985-03-28', 'F', '9773266581', 'kda-rocha@example.net', 'K8Gpb0ui4Y!Q');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('02157489649', '21261287221', 5, 'Ana Luiza', 'Melo', '1944-08-02', 'F', '9726579799', 'luigimartins@example.org', 'BlACaCnp*@9$');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('30674958292', '95603552212', 6, 'Bento', 'da Cunha', '1966-02-14', 'M', '9274940741', 'ian06@example.net', '#6kZaaqtjUCm');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('07459386200', '43564567341', 7, 'Valentina', 'Ribeiro', '1967-11-29', 'M', '9762040435', 'vitormoreira@example.net', '^2$$tTtiQBEX');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('54210839779', '69512167843', 8, 'Maria Alice', 'Rodrigues', '1998-05-28', 'M', '9984873541', 'garciagabriel@example.com', '!4O8%9inHq81');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('18235097460', '58607966533', 9, 'Erick', 'Lopes', '1947-08-25', 'F', '9497490549', 'dcavalcante@example.com', '!P0(sApwst2S');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('43905621770', '69512167843', 10, 'Benjamim', 'da Rocha', '1986-09-25', 'M', '9981163197', 'alvesluiz-gustavo@example.net', 'D)9E4hWyH*oU');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('72861305959', '43564567341', 11, 'Luara', 'Rocha', '1974-07-02', 'M', '9842767031', 'moreirastella@example.net', '*6R2Pmux2M8$');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('28957614346', '95603552212', 12, 'Clara', 'Caldeira', '1973-04-05', 'M', '9243650645', 'gvargas@example.net', '#oPNmUy9u7ZT');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('58904761220', '17202070897', 13, 'Nathan', 'Camargo', '1972-06-09', 'M', '9832113743', 'da-pazgael@example.net', '*!Z2Bwo#ZI9x');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('08547231960', '58607966533', 14, 'Manuela', 'Marques', '1968-10-22', 'M', '9842399588', 'xbrito@example.org', '!5RwF(Xp^^Au');
INSERT INTO Usuario (CPF, conta_bancaria, id_localizacao, nome, sobrenome, data_nascimento, sexo, telefone, email, senha) VALUES ('95247860365', '51079609703', 15, 'Emanuella', 'Barbosa', '1986-08-02', 'F', '9128011678', 'bferreira@example.org', '(rK6WQc#nm7_');
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Andrade Caldeira Ltda.', 'Alameda de da Paz', 'quarto individual', 2, 2, 52000, 5, 26, 4, 18200, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('da Paz Moura S/A', 'Distrito João Guilherme Nascimento, 84', 'quarto compartilhado', 4, 1, 83100, 5, 5, 8, 13500, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Marques', 'Passarela de da Cruz, 68', 'quarto compartilhado', 4, 2, 27700, 4, 16, 4, 2400, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Freitas Albuquerque - ME', 'Trecho de Moura, 13', 'quarto individual', 3, 3, 37500, 3, 30, 2, 2300, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Azevedo Viana Ltda.', 'Aeroporto de Siqueira, 47', 'casa inteira', 4, 3, 75000, 3, 6, 1, 11100, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Lopes', 'Colônia de Mendes, 14', 'quarto compartilhado', 4, 1, 58500, 4, 10, 2, 8000, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Melo Gonçalves Ltda.', 'Campo de Nunes, 52', 'casa inteira', 5, 2, 62300, 4, 12, 5, 18900, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Siqueira Ltda.', 'Condomínio Nogueira', 'casa inteira', 1, 1, 49400, 4, 5, 3, 4900, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Farias Rocha - EI', 'Lagoa Macedo, 91', 'quarto compartilhado', 5, 3, 46400, 4, 17, 4, 16000, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Barbosa', 'Condomínio Viana, 3', 'quarto compartilhado', 3, 1, 53400, 2, 30, 3, 15700, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Souza', 'Campo Duarte, 82', 'quarto compartilhado', 3, 2, 49900, 1, 28, 1, 1100, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Teixeira', 'Jardim Teixeira, 82', 'quarto compartilhado', 1, 2, 13400, 5, 7, 9, 3600, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Nogueira', 'Residencial Maria Clara Freitas, 94', 'quarto compartilhado', 4, 2, 59400, 5, 24, 9, 16600, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Rodrigues Ltda.', 'Aeroporto de Garcia, 25', 'quarto individual', 5, 3, 8900, 1, 17, 5, 16500, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Propriedade (nome, endereco, tipo, numero_quartos, numero_banheiros, preco_noite, min_noites, max_noites, max_hospedes, taxa_limpeza, horario_entrada, horario_saida, datas_disponiveis) VALUES ('Macedo - ME', 'Jardim Rodrigo Cavalcante, 84', 'casa inteira', 4, 3, 52400, 2, 25, 1, 11100, '2025-01-01 11:00:00', '2025-01-01 14:00:00', ARRAY[timestamp '2025-01-01 00:00:00', timestamp '2025-01-02 00:00:00', timestamp '2025-01-03 00:00:00', timestamp '2025-01-04 00:00:00', timestamp '2025-01-05 00:00:00', timestamp '2025-01-06 00:00:00', timestamp '2025-01-07 00:00:00', timestamp '2025-01-08 00:00:00', timestamp '2025-01-09 00:00:00', timestamp '2025-01-10 00:00:00', timestamp '2025-01-11 00:00:00', timestamp '2025-01-12 00:00:00', timestamp '2025-01-13 00:00:00', timestamp '2025-01-14 00:00:00', timestamp '2025-01-15 00:00:00']);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (1, 1, 'Solteiro', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (2, 4, 'Queen', True);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (3, 1, 'Queen', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (4, 3, 'Casal', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (5, 3, 'Queen', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (6, 3, 'Casal', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (7, 3, 'Solteiro', True);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (8, 1, 'Casal', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (9, 4, 'Casal', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (10, 4, 'Solteiro', True);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (11, 4, 'King', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (12, 2, 'Casal', True);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (13, 1, 'King', True);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (14, 1, 'Queen', False);
INSERT INTO Quarto (id_propriedade, numero_camas, tipo_cama, banheiro_privativo) VALUES (15, 3, 'Queen', False);
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Illo architecto necessitatibus alias minima dolorem. Nemo voluptas autem ad numquam sint illo. Minus inventore cumque perspiciatis porro omnis.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Occaecati tenetur sint explicabo illo odio soluta. Iure inventore nobis vel hic esse. Sed adipisci amet libero aliquam.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Nam quisquam officiis fuga atque. Harum voluptatibus dolores ex earum. Praesentium quos voluptatem deserunt.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Adipisci eligendi asperiores odio excepturi. Fugiat doloribus reprehenderit saepe nisi. Tempore dicta ab in quis.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Laboriosam vitae commodi beatae quasi.
Inventore consectetur maiores dignissimos vel. Consequatur ullam nam ab dolore. Quia veritatis doloremque ducimus omnis repellat praesentium.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Quis eaque ipsum sequi minima aliquid. Earum ea labore laborum necessitatibus iure. Possimus numquam adipisci eveniet dolorum harum repellat delectus.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Doloribus recusandae possimus deleniti at vel harum necessitatibus. Possimus sit voluptate eius fugiat ratione. Doloribus vero ullam officia exercitationem.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Unde consectetur laboriosam corporis pariatur. Molestias saepe officia reiciendis vel. Suscipit adipisci commodi corrupti excepturi aut laborum.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Esse quam enim perferendis illum facere. Veritatis nobis adipisci aperiam. Ullam sint quibusdam facere molestiae.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Cumque explicabo aut quas quisquam eum dolorum.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Aut qui quos qui quaerat. Fuga maxime similique magnam.
Laudantium aliquid vel numquam porro. Perferendis provident animi voluptate maiores hic a. Perspiciatis fuga vel corporis quia nostrum.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Necessitatibus ex beatae cum ipsa reiciendis. Dolores blanditiis aperiam voluptate eius. Officia illo impedit placeat distinctio dolorem sint.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Eligendi error qui totam alias minima. Ad magnam soluta.
Qui tenetur aut tempora. Eius sapiente officia beatae veritatis tempore. Corrupti debitis delectus vitae quisquam tempora consectetur.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Harum labore fugit at quas. Animi ratione voluptate.');
INSERT INTO Mensagem (CPF_remetente, CPF_destinatario, texto) VALUES ('05764982111', '71946802549', 'Enim facilis eos explicabo nihil. Molestias id enim consequatur itaque officiis.
Voluptas iure doloremque.');
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (1, 1, 0, 2, 4, 5, 1);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (2, 2, 3, 2, 6, 8, 10);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (3, 3, 4, 1, 9, 1, 0);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (4, 4, 0, 2, 9, 3, 10);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (5, 5, 2, 5, 1, 0, 6);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (6, 6, 2, 0, 6, 8, 1);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (7, 7, 5, 2, 7, 0, 9);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (8, 8, 5, 2, 5, 9, 10);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (9, 9, 3, 4, 5, 1, 10);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (10, 10, 2, 3, 6, 1, 5);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (11, 11, 2, 1, 4, 6, 0);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (12, 12, 2, 5, 2, 8, 0);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (13, 13, 5, 5, 4, 5, 5);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (14, 14, 0, 0, 10, 7, 7);
INSERT INTO Avaliacao (id_mensagem, id_propriedade, classificacao_limpeza, classificacao_estrutura, nota_comunicacao, nota_localizacao, nota_valor) VALUES (15, 15, 4, 3, 2, 10, 3);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('05764982111', 1, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 3, 47100, 211800, 56900, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('71946802549', 2, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 1, 37700, 16300, 50900, False);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('18597302488', 3, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 3, 2900, 147400, 12600, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('92045867374', 4, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 2, 43300, 244200, 46700, False);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('02157489649', 5, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 5, 9200, 334400, 40800, False);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('30674958292', 6, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 2, 12800, 369200, 74700, False);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('07459386200', 7, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 2, 39000, 236000, 8400, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('54210839779', 8, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 5, 31800, 270700, 72500, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('18235097460', 9, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 1, 13800, 393100, 62200, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('43905621770', 10, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 4, 18700, 381300, 47300, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('72861305959', 11, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 1, 20500, 114300, 80000, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('28957614346', 12, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 3, 9700, 128700, 53000, False);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('58904761220', 13, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 4, 39100, 65300, 29400, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('08547231960', 14, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 3, 45700, 159100, 7700, True);
INSERT INTO Reserva (CPF_locatario, id_propriedade, data_reserva, data_checkin, data_checkout, numero_hospedes, imposto, preco_total_estadia, preco_total_imposto_limpeza, status) VALUES ('95247860365', 15, '2025-01-02 00:00:00', '2025-01-04 00:00:00', '2025-01-08 00:00:00', 2, 17100, 412800, 28400, True);
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (1, 'Vieira');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (2, 'Siqueira Moreira Ltda.');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (3, 'das Neves');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (4, 'Fonseca Ltda.');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (5, 'da Luz Gomes S/A');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (6, 'Costela');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (7, 'da Cruz');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (8, 'Ferreira');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (9, 'Lopes');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (10, 'Alves');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (11, 'da Rocha');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (12, 'Vargas');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (13, 'Azevedo');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (14, 'da Rocha - EI');
INSERT INTO PontoDeInteresse (id_localizacao, nome) VALUES (15, 'Sá Costela S/A');
