-- CRIANDO O BANCO DE DADOS
create database mecanic_save;
use mecanic_save;

-- =========================
-- CRIAÇÃO DAS TABELAS
-- =========================

create table cliente(
	id int auto_increment primary key,
    cpf decimal(11) unique not null,
	nome varchar(300) not null,
    telefone decimal(11),
    email varchar(300),
    ativo boolean default true
);

create table veiculo(
	placa varchar(7) not null,
    id_cliente int,
    marca varchar(100) not null,
    modelo varchar(100) not null,
    ano year not null,
    cor varchar(50),
    tipo varchar(50),
    combustivel varchar(100),
    constraint pk_placa_cliente primary key (placa, id_cliente),
    constraint fk_id_cliente foreign key (id_cliente) references cliente(id)
);

create table perfil(
	id_perfil int auto_increment primary key,
    nome varchar(100) not null,
    permissoes text
);

create table funcionario(
	id_funcionario int auto_increment primary key,
    perfil_id int,
    nome varchar(300) not null,
    cpf decimal(11) unique not null,
    telefone decimal(11) not null,
    email varchar(300) not null,
    senha varchar(500) not null,
    ativo boolean default true,
    constraint fk_perfil foreign key (perfil_id) references perfil(id_perfil)
);

create table status(
	id_status int auto_increment primary key,
    status varchar(70) not null,
    descricao text
);

create table ordem_de_servico (
	id_os int auto_increment primary key,
    cliente_id int,
    placa_veiculo varchar(7),
    data_abertura date,
    data_fechamento date,
    diagnostico text,
    status_os int,
    constraint fk_cliente foreign key (cliente_id) references cliente(id),
    constraint fk_placa_vei foreign key (placa_veiculo) references veiculo(placa),
    constraint fk_status foreign key (status_os) references status(id_status)
);

create table servico(
	id_servico int auto_increment primary key,
    nome_servico varchar(200) not null,
    descricao text not null,
    valor_medio decimal(10,2) not null,
    tempo_medio time not null,
    data_de_registro date not null
);

create table peca(
	id_peca int auto_increment primary key,
    nome varchar(300),
    valor decimal(10,2),
    quantidade_estoque int default 0
);

create table servico_realizado(
	ordemS int,
    serv_id int,
    nome_servico varchar(100),
    descricao text not null,
    valor_mao_obra decimal(10,2),
    tempo_execucao time,
    date_registro date,
    constraint pk_servico_realizado primary key (ordemS, serv_id),
    constraint fk_ordemS foreign key (ordemS) references ordem_de_servico(id_os),
    constraint fk_servico_r foreign key (serv_id) references servico(id_servico)
);

create table servico_peca(
	id_do_serv int,
    id_peca_usada int,
    quantidade_usada int default 1,
    constraint pk_servico_peca primary key (id_do_serv, id_peca_usada),
    constraint fk_id_do_serv foreign key (id_do_serv) references servico(id_servico),
    constraint fk_peca_uso foreign key (id_peca_usada) references peca(id_peca)
);

create table ordem_funcionario (
	id_ordem_os int,
    id_func int,
    funcao_na_os varchar(200),
    horas_trabalhadas time,
    constraint pk_ordem_funcionario primary key (id_ordem_os, id_func),
    constraint fk_ordem_id_os foreign key (id_ordem_os) references ordem_de_servico(id_os),
    constraint fk_funcionario_fez foreign key (id_func) references funcionario(id_funcionario)
);

-- =========================
-- INSERINDO DADOS
-- =========================

-- Inserindo dados da tabela CLIENTE
insert into cliente (cpf, nome, telefone, email) values
(12345678901, 'João Silva', 11987654321, 'joao@gmail.com'),
(23456789012, 'Maria Souza', 11976543210, 'maria@gmail.com'),
(34567890123, 'Carlos Pereira', 11965432109, 'carlos@gmail.com'),
(45678901234, 'Ana Lima', 11954321098, 'ana@gmail.com'),
(56789012345, 'Pedro Rocha', 11943210987, 'pedro@gmail.com');

-- Inserindo dados da tabela PERFIL
insert into perfil (nome, permissoes) values
('Administrador', 'acesso total'),
('Mecânico', 'executar e registrar serviços'),
('Atendente', 'abrir e fechar ordens'),
('Estoque', 'gerenciar peças'),
('Gerente', 'acompanhar relatórios e desempenho');

-- Inserindo dados da tabela FUNCIONÁRIO 
insert into funcionario (perfil_id, nome, cpf, telefone, email, senha)
select id_perfil, 'Carlos Almeida', 11122233344, 11988887777, 'carlos@empresa.com', 'senha123'
from perfil where nome = 'Administrador';
insert into funcionario (perfil_id, nome, cpf, telefone, email, senha)
select id_perfil, 'Roberto Silva', 22233344455, 11977776666, 'roberto@empresa.com', 'senha456'
from perfil where nome = 'Mecânico';
insert into funcionario (perfil_id, nome, cpf, telefone, email, senha)
select id_perfil, 'Fernanda Costa', 33344455566, 11966665555, 'fernanda@empresa.com', 'senha789'
from perfil where nome = 'Atendente';
insert into funcionario (perfil_id, nome, cpf, telefone, email, senha)
select id_perfil, 'Luciana Torres', 44455566677, 11955554444, 'luciana@empresa.com', 'senha101'
from perfil where nome = 'Estoque';
insert into funcionario (perfil_id, nome, cpf, telefone, email, senha)
select id_perfil, 'Julio Mendes', 55566677788, 11944443333, 'julio@empresa.com', 'senha202'
from perfil where nome = 'Gerente';

-- Inserindo dados da tabela STATUS 
insert into status (status, descricao) values
('Aberta', 'Ordem aberta e aguardando análise.'),
('Em andamento', 'Serviço em execução.'),
('Aguardando Peças', 'Serviço parado até chegada de peças.'),
('Concluída', 'Ordem finalizada com sucesso.'),
('Cancelada', 'Ordem cancelada pelo cliente.');

-- Inserindo dados da tabela VEÍCULO
insert into veiculo (placa, id_cliente, marca, modelo, ano, cor, tipo, combustivel)
select 'ABC1234', id, 'Toyota', 'Corolla', 2018, 'Prata', 'Sedan', 'Flex' from cliente where nome = 'João Silva';

insert into veiculo (placa, id_cliente, marca, modelo, ano, cor, tipo, combustivel)
select 'XYZ5678', id, 'Honda', 'Civic', 2020, 'Preto', 'Sedan', 'Gasolina' from cliente where nome = 'Maria Souza';

insert into veiculo (placa, id_cliente, marca, modelo, ano, cor, tipo, combustivel)
select 'LMN4321', id, 'Fiat', 'Strada', 2021, 'Branco', 'Pickup', 'Diesel' from cliente where nome = 'Carlos Pereira';

insert into veiculo (placa, id_cliente, marca, modelo, ano, cor, tipo, combustivel)
select 'PQR9876', id, 'Chevrolet', 'Onix', 2019, 'Vermelho', 'Hatch', 'Etanol' from cliente where nome = 'Ana Lima';

insert into veiculo (placa, id_cliente, marca, modelo, ano, cor, tipo, combustivel)
select 'STU6543', id, 'Volkswagen', 'Polo', 2022, 'Azul', 'Hatch', 'Flex' from cliente where nome = 'Pedro Rocha';

-- Inserindo dados da tabela SERVIÇO
insert into servico (nome_servico, descricao, valor_medio, tempo_medio, data_de_registro) values
('Troca de óleo', 'Substituição de óleo e filtro do motor.', 150.00, '00:30:00', '2024-05-01'),
('Alinhamento e balanceamento', 'Ajuste da suspensão e pneus.', 200.00, '01:00:00', '2024-05-02'),
('Troca de pastilhas de freio', 'Substituição das pastilhas dianteiras.', 250.00, '01:30:00', '2024-05-03'),
('Revisão geral', 'Inspeção completa do veículo.', 500.00, '03:00:00', '2024-05-04'),
('Troca de bateria', 'Substituição da bateria automotiva.', 300.00, '00:45:00', '2024-05-05');

-- Inserindo dados da tabela PEÇA
insert into peca (nome, valor, quantidade_estoque) values
('Filtro de óleo', 30.00, 50),
('Pastilha de freio', 120.00, 40),
('Bateria 60Ah', 450.00, 15),
('Pneu Aro 15', 380.00, 20),
('Velas de ignição', 25.00, 100);

-- Inserindo dados da tabela ORDEM DE SERVIÇO 
insert into ordem_de_servico (cliente_id, placa_veiculo, data_abertura, data_fechamento, diagnostico, status_os)
select c.id, 'ABC1234', '2024-06-01', null, 'Troca de óleo e revisão leve.', s.id_status
from cliente c, status s
where c.nome = 'João Silva' and s.status = 'Aberta';

insert into ordem_de_servico (cliente_id, placa_veiculo, data_abertura, data_fechamento, diagnostico, status_os)
select c.id, 'XYZ5678', '2024-06-02', null, 'Barulho na suspensão.', s.id_status
from cliente c, status s
where c.nome = 'Maria Souza' and s.status = 'Em andamento';

insert into ordem_de_servico (cliente_id, placa_veiculo, data_abertura, data_fechamento, diagnostico, status_os)
select c.id, 'LMN4321', '2024-06-03', null, 'Substituição de pastilhas de freio.', s.id_status
from cliente c, status s
where c.nome = 'Carlos Pereira' and s.status = 'Em andamento';

insert into ordem_de_servico (cliente_id, placa_veiculo, data_abertura, data_fechamento, diagnostico, status_os)
select c.id, 'PQR9876', '2024-06-04', null, 'Revisão completa.', s.id_status
from cliente c, status s
where c.nome = 'Ana Lima' and s.status = 'Aguardando Peças';

insert into ordem_de_servico (cliente_id, placa_veiculo, data_abertura, data_fechamento, diagnostico, status_os)
select c.id, 'STU6543', '2024-06-05', '2024-06-06', 'Bateria descarregando.', s.id_status
from cliente c, status s
where c.nome = 'Pedro Rocha' and s.status = 'Concluída';

-- Inserindo dados da tabela SERVIÇO REALIZADO 
insert into servico_realizado (ordemS, serv_id, nome_servico, descricao, valor_mao_obra, tempo_execucao, date_registro)
select o.id_os, s.id_servico, s.nome_servico, 'Serviço executado com sucesso.', 100.00, '00:30:00', '2024-06-01'
from ordem_de_servico o, servico s
where o.placa_veiculo = 'ABC1234' and s.nome_servico = 'Troca de óleo';

insert into servico_realizado (ordemS, serv_id, nome_servico, descricao, valor_mao_obra, tempo_execucao, date_registro)
select o.id_os, s.id_servico, s.nome_servico, 'Direção e pneus ajustados.', 180.00, '01:00:00', '2024-06-02'
from ordem_de_servico o, servico s
where o.placa_veiculo = 'XYZ5678' and s.nome_servico = 'Alinhamento e balanceamento';

insert into servico_realizado (ordemS, serv_id, nome_servico, descricao, valor_mao_obra, tempo_execucao, date_registro)
select o.id_os, s.id_servico, s.nome_servico, 'Freios substituídos.', 220.00, '01:30:00', '2024-06-03'
from ordem_de_servico o, servico s
where o.placa_veiculo = 'LMN4321' and s.nome_servico = 'Troca de pastilhas de freio';

insert into servico_realizado (ordemS, serv_id, nome_servico, descricao, valor_mao_obra, tempo_execucao, date_registro)
select o.id_os, s.id_servico, s.nome_servico, 'Revisão completa.', 480.00, '03:00:00', '2024-06-04'
from ordem_de_servico o, servico s
where o.placa_veiculo = 'PQR9876' and s.nome_servico = 'Revisão geral';

insert into servico_realizado (ordemS, serv_id, nome_servico, descricao, valor_mao_obra, tempo_execucao, date_registro)
select o.id_os, s.id_servico, s.nome_servico, 'Bateria trocada com sucesso.', 250.00, '00:45:00', '2024-06-05'
from ordem_de_servico o, servico s
where o.placa_veiculo = 'STU6543' and s.nome_servico = 'Troca de bateria';

-- Inserindo dados da tabela SERVIÇO_PEÇA 
insert into servico_peca (id_do_serv, id_peca_usada, quantidade_usada)
select s.id_servico, p.id_peca, 1 from servico s, peca p
where s.nome_servico = 'Troca de óleo' and p.nome = 'Filtro de óleo';

insert into servico_peca (id_do_serv, id_peca_usada, quantidade_usada)
select s.id_servico, p.id_peca, 1 from servico s, peca p
where s.nome_servico = 'Troca de pastilhas de freio' and p.nome = 'Pastilha de freio';

insert into servico_peca (id_do_serv, id_peca_usada, quantidade_usada)
select s.id_servico, p.id_peca, 4 from servico s, peca p
where s.nome_servico = 'Revisão geral' and p.nome = 'Velas de ignição';

insert into servico_peca (id_do_serv, id_peca_usada, quantidade_usada)
select s.id_servico, p.id_peca, 1 from servico s, peca p
where s.nome_servico = 'Troca de bateria' and p.nome = 'Bateria 60Ah';

insert into servico_peca (id_do_serv, id_peca_usada, quantidade_usada)
select s.id_servico, p.id_peca, 4 from servico s, peca p
where s.nome_servico = 'Alinhamento e balanceamento' and p.nome = 'Pneu Aro 15';

-- Inserindo dados da tabela ORDEM_FUNCIONARIO
insert into ordem_funcionario (id_ordem_os, id_func, funcao_na_os, horas_trabalhadas)
select o.id_os, f.id_funcionario, 'Mecânico responsável', '00:45:00'
from ordem_de_servico o, funcionario f
where o.placa_veiculo = 'ABC1234' and f.nome = 'Roberto Silva';

insert into ordem_funcionario (id_ordem_os, id_func, funcao_na_os, horas_trabalhadas)
select o.id_os, f.id_funcionario, 'Mecânico auxiliar', '01:15:00'
from ordem_de_servico o, funcionario f
where o.placa_veiculo = 'XYZ5678' and f.nome = 'Roberto Silva';

insert into ordem_funcionario (id_ordem_os, id_func, funcao_na_os, horas_trabalhadas)
select o.id_os, f.id_funcionario, 'Gerente de oficina', '02:00:00'
from ordem_de_servico o, funcionario f
where o.placa_veiculo = 'PQR9876' and f.nome = 'Carlos Almeida';

insert into ordem_funcionario (id_ordem_os, id_func, funcao_na_os, horas_trabalhadas)
select o.id_os, f.id_funcionario, 'Controle de estoque', '00:30:00'
from ordem_de_servico o, funcionario f
where o.placa_veiculo = 'STU6543' and f.nome = 'Luciana Torres';

insert into ordem_funcionario (id_ordem_os, id_func, funcao_na_os, horas_trabalhadas)
select o.id_os, f.id_funcionario, 'Atendente da OS', '00:20:00'
from ordem_de_servico o, funcionario f
where o.placa_veiculo = 'LMN4321' and f.nome = 'Fernanda Costa';


-- ------------------------------------
-- ---------------VIEWS----------------
-- ------------------------------------

-- DETALHES DE ORDEM DE SERVIÇO 
CREATE VIEW view_ordem_servico AS
SELECT  
    os.id_os AS 'ID OS',
    st.status AS 'Status',
    os.data_abertura AS 'Data Abertura',
    os.data_fechamento AS 'Data Fechamento',
    os.diagnostico AS 'Diagnóstico',
    c.nome AS 'Cliente',
    c.telefone AS 'Telefone Cliente',
    c.email AS 'Email Cliente',
    v.placa AS 'Placa',
    v.marca AS 'Marca',
    v.modelo AS 'Modelo',
    f.nome AS 'Funcionário Responsável'
FROM
    ordem_de_servico os
JOIN
    cliente c ON os.cliente_id = c.id
JOIN
    veiculo v ON os.placa_veiculo = v.placa
JOIN
    status st ON os.status_os = st.id_status
LEFT JOIN
    ordem_funcionario ofu ON os.id_os = ofu.id_ordem_os
LEFT JOIN
    funcionario f ON ofu.id_func = f.id_funcionario;

-- EXEMPLO:
SELECT * FROM view_ordem_servico
WHERE Status = 'Concluída';

-- DEMONSTRATIVO FINANCEIRO

CREATE VIEW view_financeiro AS
SELECT  
    sr.ordemS AS 'ID OS',
    SUM(sr.valor_mao_obra) AS 'Valor Total Mão de Obra',
    GROUP_CONCAT(sr.nome_servico SEPARATOR ', ') AS 'Serviços Prestados'
FROM
    servico_realizado sr
GROUP BY
    sr.ordemS;

-- EXEMPLO:
SELECT * FROM view_financeiro;

-- HISTÓRICO DE VEÍCULO
CREATE VIEW view_ficha_veiculo AS
SELECT  
    v.placa AS 'Placa',
    v.marca AS 'Marca',
    v.modelo AS 'Modelo',
    os.data_abertura AS 'Data do Serviço',
    os.diagnostico AS 'Diagnóstico',
    sr.nome_servico AS 'Serviço Realizado',
    sr.valor_mao_obra AS 'Valor do Serviço',
    f.nome AS 'Realizado Por'
FROM
    veiculo v
JOIN
    ordem_de_servico os ON v.placa = os.placa_veiculo
JOIN
    servico_realizado sr ON os.id_os = sr.ordemS
LEFT JOIN
    ordem_funcionario ofu ON os.id_os = ofu.id_ordem_os
LEFT JOIN
    funcionario f ON ofu.id_func = f.id_funcionario
ORDER BY
    v.placa, os.data_abertura DESC;

-- EXEMPLO:
SELECT * FROM view_ficha_veiculo WHERE Placa = 'ABC1234';

-- CONSULTA DE VEICULO-PROPRIETÁRIO
CREATE VIEW view_consulta_veic_proprietario AS
SELECT  
    v.placa AS 'Placa',
    v.marca AS 'Marca',
    v.modelo AS 'Modelo',
    v.ano AS 'Ano',
    v.cor AS 'Cor',
    c.nome AS 'Nome Proprietário',
    c.telefone AS 'Telefone Proprietário',
    c.email AS 'Email Proprietário',
    c.cpf AS 'CPF Proprietário'
FROM
    veiculo v
JOIN
    cliente c ON v.id_cliente = c.id
ORDER BY
    c.nome, v.placa;

-- EXEMPLO:
SELECT * FROM view_consulta_veic_proprietario WHERE Placa = 'ABC1234';

-- FATURAMENTO MENSAL
CREATE VIEW view_faturamento_mensal AS
SELECT  
    DATE_FORMAT(sr.date_registro, '%Y-%m') AS 'Mês/Ano',
    SUM(sr.valor_mao_obra) AS 'Faturamento Total',
    COUNT(sr.serv_id) AS 'Qtd Serviços Realizados',
    COUNT(DISTINCT sr.ordemS) AS 'OS Faturadas'
FROM
    servico_realizado sr
GROUP BY
    DATE_FORMAT(sr.date_registro, '%Y-%m')
ORDER BY
 `Mês/Ano` DESC;
 
-- EXEMPLO:
SELECT * FROM view_faturamento_mensal
WHERE 'Mês/Ano' = '2025-09';

-- DESEMPENHO DE FUNCIONÁRIOS

-- (6) DESEMPENHO DOS FUNCIONÁRIOS

CREATE VIEW view_desempenho_funcionarios AS
SELECT 
    f.id_funcionario AS 'ID Funcionário',
    f.nome AS 'Nome do Funcionário',
    p.nome AS 'Perfil',
    COUNT(DISTINCT ofn.id_ordem_os) AS 'Ordens de Serviço Participadas',
    SEC_TO_TIME(SUM(TIME_TO_SEC(ofn.horas_trabalhadas))) AS 'Total de Horas Trabalhadas',
    IFNULL(SUM(sr.valor_mao_obra), 0) AS 'Valor Total Gerado (Mão de Obra)'
FROM 
    funcionario f
LEFT JOIN 
    perfil p ON f.perfil_id = p.id_perfil
LEFT JOIN 
    ordem_funcionario ofn ON f.id_funcionario = ofn.id_func
LEFT JOIN 
    ordem_de_servico os ON ofn.id_ordem_os = os.id_os
LEFT JOIN 
    servico_realizado sr ON sr.ordemS = os.id_os
GROUP BY 
    f.id_funcionario, f.nome, p.nome
ORDER BY `Valor Total Gerado (Mão de Obra)` DESC;

    
-- EXEMPLO 
SELECT * FROM view_desempenho_funcionarios;

-- Indices

-- Relatórios e status de OS
CREATE INDEX idx_ordem_status_data 
ON ordem_de_servico (status_os, data_abertura);

-- Faturamento e relatórios mensais
CREATE INDEX idx_servico_realizado_data_ordem 
ON servico_realizado (date_registro, ordemS);

-- Consulta de veículos por proprietário
CREATE INDEX idx_veiculo_cliente 
ON veiculo (id_cliente);

-- Regra de Negócio: Finalização de Ordem de Serviço com Baixa de Estoque

DELIMITER //

CREATE PROCEDURE sp_finalizar_ordem_servico (IN par_id_os INT, OUT retorno varchar(60))

BEGIN
    -- variaveis
    DECLARE v_erro BOOLEAN DEFAULT FALSE;
    DECLARE v_msg_erro VARCHAR(255);
    DECLARE v_status_concluida INT;
    DECLARE v_status_atual INT;

    -- 1. Obter o ID do status e o status atual da OS
    SELECT id_status INTO v_status_concluida FROM status WHERE status = 'Concluída';
    SELECT status_os INTO v_status_atual FROM ordem_de_servico WHERE id_os = par_id_os;

    -- VALIDAÇÃO 1: A OS existe?
    IF v_status_atual IS NULL THEN
        SET retorno = 'Erro: Ordem de Serviço não encontrada.';
    END IF;

    -- VALIDAÇÃO 2: A OS já está concluída?
    IF v_status_atual = v_status_concluida THEN
        SET retorno = 'Erro: Esta OS já foi finalizada anteriormente.';
    END IF;

    -- VALIDAÇÃO 3: Verificar se há estoque suficiente para todos os itens
    -- Se alguma peça necessária tiver estoque menor do que precisa, bloqueamos a finalização
    IF EXISTS 
		(SELECT 1
        FROM servico_realizado sr
        JOIN servico_peca sp ON sr.serv_id = sp.id_do_serv
        JOIN peca p ON sp.id_peca_usada = p.id_peca -- Pega o estoque atual
        WHERE sr.ordemS = par_id_os
        AND sr.ativo = TRUE -- Apenas serviços não cancelados
        AND sp.ativo = TRUE -- Apenas peças ativas
        AND (p.quantidade_estoque - sp.quantidade_usada) < 0
    ) THEN
        SET retorno = 'Erro: Estoque insuficiente para um ou mais itens desta OS.';
    END IF;

    -- INÍCIO DA TRANSAÇÃO
    START TRANSACTION;

    -- Baixar o estoque
    -- Atualiza a tabela de peças subtraindo a quantidade usada na receita dos serviços dessa OS
    UPDATE peca p
    JOIN servico_peca sp ON p.id_peca = sp.id_peca_usada
    JOIN servico_realizado sr ON sp.id_do_serv = sr.serv_id
    SET p.quantidade_estoque = p.quantidade_estoque - sp.quantidade_usada
    WHERE sr.ordemS = par_id_os
      AND sr.ativo = TRUE
      AND sp.ativo = TRUE;

    -- Atualizar o Status da OS para "Concluída" e definir data de fechamento
    UPDATE ordem_de_servico
    SET status_os = v_status_concluida,
        data_fechamento = CURDATE()
    WHERE id_os = par_id_os;

    -- VERIFICAÇÃO FINAL E COMMIT
    IF v_erro THEN
        ROLLBACK;
        SET retorno = 'Erro ao processar transação. Operação desfeita.';
    ELSE
        COMMIT;
        SELECT 'Sucesso: OS finalizada e estoque atualizado.' AS Mensagem;
    END IF;

END //

DELIMITER ;


/* "Para cada tabela criar 3 procedures
1 = inserir registros, 2 = atualizar registros, 3 = exclusão lógica"
*/

-- ajuste para fazer a exclusão lógica:
ALTER TABLE veiculo ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
ALTER TABLE servico ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
ALTER TABLE peca ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
ALTER TABLE servico_realizado ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
ALTER TABLE servico_peca ADD COLUMN ativo BOOLEAN DEFAULT TRUE;

-- tabela 1 CLIENTE:

DELIMITER //

-- 1. Inserir Cliente
CREATE PROCEDURE sp_inserir_cliente
	(IN par_cpf DECIMAL(11), 
    IN par_nome VARCHAR(300), 
    IN par_telefone DECIMAL(11),
    IN par_email VARCHAR(300)
)

BEGIN
    INSERT INTO cliente (cpf, nome, telefone, email, ativo)
    VALUES (par_cpf, par_nome, par_telefone, par_email, TRUE);
END //

-- 2. Atualizar Cliente
CREATE PROCEDURE sp_atualizar_cliente
	(IN par_id INT,
    IN par_nome VARCHAR(300),
    IN par_telefone DECIMAL(11),
    IN par_email VARCHAR(300)
)

BEGIN
    UPDATE cliente 
    SET nome = par_nome, telefone = par_telefone, email = par_email
    WHERE id = par_id;
END //

-- 3. Exclusão Lógica Cliente
CREATE PROCEDURE sp_excluir_cliente (IN par_id INT)

BEGIN
    UPDATE cliente SET ativo = FALSE WHERE id = p_id;
END //

DELIMITER ;


-- Tabela 2 VEICULO:

DELIMITER //

-- 1. Inserir Veículo
CREATE PROCEDURE sp_inserir_veiculo	
	(IN par_placa VARCHAR(7),
    IN par_cpf_cliente DECIMAL(11),
    IN par_marca VARCHAR(100),
    IN par_modelo VARCHAR(100),
    IN par_ano YEAR,
    IN par_cor VARCHAR(50),
    IN par_tipo VARCHAR(50),
    IN par_combustivel VARCHAR(100),
    OUT retorno varchar(60)
)

BEGIN
    DECLARE v_id_cliente INT;
    
    SELECT id INTO v_id_cliente FROM cliente WHERE cpf = par_cpf_cliente;

    IF v_id_cliente IS NOT NULL THEN
        INSERT INTO veiculo (placa, id_cliente, marca, modelo, ano, cor, tipo, combustivel, ativo)
        VALUES (par_placa, v_id_cliente, par_marca, par_modelo, par_ano, par_cor, par_tipo, par_combustivel, TRUE);
    ELSE
        SET retorno = 'Cliente não encontrado';
    END IF;
END //

-- 2. Atualizar Veículo
CREATE PROCEDURE sp_atualizar_veiculo
	(IN par_placa VARCHAR(7),
    IN par_cor VARCHAR(50),
    IN par_tipo VARCHAR(50)
)

BEGIN
    UPDATE veiculo 
    SET cor = par_cor, tipo = par_tipo
    WHERE placa = par_placa;
END //

-- 3. Exclusão Lógica Veículo
CREATE PROCEDURE sp_excluir_veiculo (IN par_placa VARCHAR(7))
BEGIN
    UPDATE veiculo SET ativo = FALSE WHERE placa = par_placa;
END //

DELIMITER ;

-- Tabela 3 FUNCIONARIO:

DELIMITER //

-- 1. Inserir Funcionário
CREATE PROCEDURE sp_inserir_funcionario
	(IN par_nome_perfil VARCHAR(100),
    IN par_nome VARCHAR(300),
    IN par_cpf DECIMAL(11),
    IN par_telefone DECIMAL(11),
    IN par_email VARCHAR(300),
    IN par_senha VARCHAR(500)
)

BEGIN
    INSERT INTO funcionario (perfil_id, nome, cpf, telefone, email, senha, ativo)
    SELECT id_perfil, par_nome, par_cpf, par_telefone, par_email, par_senha, TRUE
    FROM perfil WHERE nome = par_nome_perfil;
END //

-- 2. Atualizar Funcionário
CREATE PROCEDURE sp_atualizar_funcionario
	(IN par_id INT,
    IN par_nome VARCHAR(300),
    IN par_telefone DECIMAL(11),
    IN par_email VARCHAR(300)
)

BEGIN
    UPDATE funcionario 
    SET nome = par_nome, telefone = par_telefone, email = par_email
    WHERE id_funcionario = par_id;
END //

-- 3. Exclusão Lógica Funcionário
CREATE PROCEDURE sp_excluir_funcionario (IN par_id INT)

BEGIN
    UPDATE funcionario SET ativo = FALSE WHERE id_funcionario = par_id;
END //

DELIMITER ;

-- tabela 4 ORDEM DE SERVIÇO:

DELIMITER //

-- 1. Inserir OS
CREATE PROCEDURE sp_inserir_os
	(IN par_placa VARCHAR(7),
    IN par_diagnostico TEXT
)

BEGIN
    DECLARE v_id_cliente INT;
    DECLARE v_id_status_aberta INT;

    -- pega o ID do cliente dono do veículo
    SELECT id_cliente INTO v_id_cliente FROM veiculo WHERE placa = par_placa LIMIT 1;
    
    -- Pega o ID do status "Aberta"
    SELECT id_status INTO v_id_status_aberta FROM status WHERE status = 'Aberta';

    INSERT INTO ordem_de_servico (cliente_id, placa_veiculo, data_abertura, diagnostico, status_os)
    VALUES (v_id_cliente, par_placa, CURDATE(), par_diagnostico, v_id_status_aberta);
END //

-- 2. Atualizar OS
CREATE PROCEDURE sp_atualizar_status_os
	(IN par_id_os INT,
    IN par_novo_status VARCHAR(70)
)

BEGIN
    UPDATE ordem_de_servico 
    SET status_os = (SELECT id_status FROM status WHERE status = par_novo_status)
    WHERE id_os = par_id_os;
END //

-- 3. Exclusão Lógica OS (Muda status para Cancelada)
CREATE PROCEDURE sp_cancelar_os (IN par_id_os INT)

BEGIN
    UPDATE ordem_de_servico 
    SET status_os = (SELECT id_status FROM status WHERE status = 'Cancelada'),
        data_fechamento = CURDATE()
    WHERE id_os = par_id_os;
END //

DELIMITER ;

-- Tabela 5 PEÇA:

DELIMITER //

-- 1. Inserir Peça
CREATE PROCEDURE sp_inserir_peca
	(IN par_nome VARCHAR(300),
    IN par_valor DECIMAL(10,2),
    IN par_qtd INT
)

BEGIN
    INSERT INTO peca (nome, valor, quantidade_estoque, ativo)
    VALUES (par_nome, par_valor, par_qtd, TRUE);
END //

-- 2. Atualizar Peça (Estoque e Valor)
CREATE PROCEDURE sp_atualizar_peca(
    IN par_id INT,
    IN par_valor DECIMAL(10,2),
    IN par_nova_qtd INT
)

BEGIN
    UPDATE peca 
    SET valor = par_valor, quantidade_estoque = par_nova_qtd
    WHERE id_peca = par_id;
END //

-- 3. Exclusão Lógica Peça
CREATE PROCEDURE sp_excluir_peca (IN par_id INT)

BEGIN
    UPDATE peca SET ativo = FALSE WHERE id_peca = par_id;
END //

DELIMITER ;

-- Tabela 6 SERVIÇO:

DELIMITER //

-- 1. Inserir Serviço
CREATE PROCEDURE sp_inserir_servico
	(IN par_nome VARCHAR(200),
    IN par_descricao TEXT,
    IN par_valor DECIMAL(10,2),
    IN par_tempo TIME
)
BEGIN
    INSERT INTO servico (nome_servico, descricao, valor_medio, tempo_medio, data_de_registro, ativo)
    VALUES (par_nome, par_descricao, par_valor, par_tempo, CURDATE(), TRUE);
END //

-- 2. Atualizar Serviço
CREATE PROCEDURE sp_atualizar_servico
	(IN par_id INT,
    IN par_valor DECIMAL(10,2),
    IN par_tempo TIME
)

BEGIN
    UPDATE servico 
    SET valor_medio = par_valor, tempo_medio = par_tempo
    WHERE id_servico = par_id;
END //

-- 3. Exclusão Lógica Serviço
CREATE PROCEDURE sp_excluir_servico (IN par_id INT)

BEGIN
    UPDATE servico SET ativo = FALSE WHERE id_servico = par_id;
END //

DELIMITER ;

-- Tabela 7 SERVIÇO REALIZADO:

DELIMITER //

-- 1. Inserir
CREATE PROCEDURE sp_inserir_servico_realizado
	(IN par_id_os INT,
    IN par_id_servico INT,
    IN par_id_funcionario INT
)

BEGIN
    INSERT INTO servico_realizado (ordemS, serv_id, nome_servico, descricao, valor_mao_obra, tempo_execucao, date_registro, ativo)
    SELECT par_id_os, id_servico, nome_servico, descricao, valor_medio, tempo_medio, CURDATE(), TRUE
    FROM servico WHERE id_servico = par_id_servico;
    
    IF p_id_funcionario IS NOT NULL THEN
        INSERT INTO ordem_funcionario (id_ordem_os, id_func, funcao_na_os, horas_trabalhadas)
        VALUES (par_id_os, par_id_funcionario, 'Técnico Responsável', (SELECT tempo_medio FROM servico WHERE id_servico = par_id_servico));
    END IF;
END //

-- 2. Atualizar
CREATE PROCEDURE sp_atualizar_servico_realizado
	(IN par_id_os INT,
    IN par_id_servico INT,
    IN par_novo_valor DECIMAL(10,2),
    IN par_novo_tempo TIME
)

BEGIN
    UPDATE servico_realizado 
    SET valor_mao_obra = par_novo_valor, 
        tempo_execucao = par_novo_tempo
    WHERE ordemS = par_id_os AND serv_id = par_id_servico;
END //

-- 3. Exclusão Lógica
CREATE PROCEDURE sp_remover_servico_realizado
	(IN par_id_os INT,
    IN par_id_servico INT
)

BEGIN
    UPDATE servico_realizado 
    SET ativo = FALSE 
    WHERE ordemS = par_id_os AND serv_id = par_id_servico;
END //

DELIMITER ;
 
 
-- Tabela 8 SERVIÇO PEÇA:

DELIMITER //

-- 1. Inserir
CREATE PROCEDURE sp_inserir_peca_no_servico
	(IN par_id_servico INT,
    IN par_id_peca INT,
    IN par_quantidade INT
)

BEGIN
    INSERT INTO servico_peca (id_do_serv, id_peca_usada, quantidade_usada, ativo)
    VALUES (par_id_servico, par_id_peca, par_quantidade, TRUE);
END //

-- 2. Atualizar
CREATE PROCEDURE sp_atualizar_qtd_peca_servico
	(IN par_id_servico INT,
    IN par_id_peca INT,
    IN par_nova_quantidade INT
)

BEGIN
    UPDATE servico_peca 
    SET quantidade_usada = par_nova_quantidade
    WHERE id_do_serv = par_id_servico AND id_peca_usada = par_id_peca;
END //

-- 3. Exclusão Lógica
CREATE PROCEDURE sp_remover_peca_do_servico
	(IN par_id_servico INT,
    IN par_id_peca INT
)

BEGIN
    UPDATE servico_peca 
    SET ativo = FALSE 
    WHERE id_do_serv = par_id_servico AND id_peca_usada = par_id_peca;
END //

DELIMITER ;
