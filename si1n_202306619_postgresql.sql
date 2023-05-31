





-- Apagar banco de dados uvv caso exista

DROP DATABASE IF EXISTS uvv;

--........................................................................


-- Apagar usuário filipe caso exista

DROP USER IF EXISTS filipe;

--........................................................................


-- crie o usuário filipe com permissão para criar outros bancos de dados, roles e senha criptografada  'filipe'

CREATE USER  filipe WITH 
CREATEDB 
CREATEROLE 
ENCRYPTED PASSWORD 'filipe';

--........................................................................

--crie o banco de dados uvv com proprietário 'filipe' e com as seguintes configurações, template = 'template0' 
--encoding = 'UTF8' lc_collate = 'pt_BR.UTF-8' lc_ctype = 'pt_BR.UTF-8' allow_connections = 'true'

CREATE DATABASE uvv WITH 
owner = 'filipe' 
template = 'template0' 
encoding = 'UTF8' 
lc_collate = 'pt_BR.UTF-8' 
lc_ctype = 'pt_BR.UTF-8' 
allow_connections = 'true';

--........................................................................

-- Conectando ao banco de dados uvv
\c uvv;

--........................................................................

--concede privilégio ao user filipe
SET ROLE filipe;

--........................................................................

-- o usuário filipe tem permissão para criar o esquema se não existir a tabela 'lojas'
CREATE SCHEMA IF NOT EXISTS lojas AUTHORIZATION filipe;

--........................................................................

ALTER USER filipe;

--definir a ordem dos esquemas para o esquema lojas aparecer na frente dos demais ( esquema padrão) 

--........................................................................

SET SEARCH_PATH TO lojas, "&user", public;


-- crie a tabela produtos
CREATE TABLE produtos (
                produto_id                NUMERIC(38)      NOT NULL, 'chave primária da tabela produtos, se relaciona com as tabelas estoque e pedidos_itens'
                nome                      VARCHAR(255)     NOT NULL, 'tabela com o nome dos produtos'
                preco_unitario            NUMERIC(10,2)    NOT NULL, 'preço das mercadorias'
                detalhes                  BYTEA            NOT NULL, 'informações adicionais sobre os produtos'
                imagem                    BYTEA            NOT NULL, 'Imagem dos produtos'
                imagem_mime_type          VARCHAR(512)     NOT NULL, 'imagem dos produtos por categoria'
                imagem_arquivo            VARCHAR(512)     NOT NULL, 'arquivo de imagem'
                imagem_charset            VARCHAR(512)     NOT NULL, 'carcateres dos produtos'
                imagem_ultima_atualizacao DATE             NOT NULL, 'atualização'
                CONSTRAINT pk_produtos PRIMARY KEY (produto_id)
);
COMMENT ON TABLE produtos IS 'tabela de valor unitario das mercadorias e alguns detalhes extras';
--.............................................................................................................

-- Criação das tabelas
--........................................................................

-- Crie a tabela loja com as seguintes caracteristicas
CREATE TABLE lojas (
                loja_id         NUMERIC(38)  NOT NULL,    'loja_id com o máximo de caracteres =38'
                nome            VARCHAR(255) NOT NULL,    ' nome da loja com o máximo de caracteres =255'
                endereco_web    VARCHAR(100) NOT NULL,    ' endereço web da loja com máximo de caracteres = 100 '
                endereco_fisico VARCHAR(512) NOT NULL,    ' endereço físico da loja com máximo de caracteres = 512 '
                latitude        NUMERIC      NOT NULL,    ' localização da loja ( latitude)'
                longitude       NUMERIC      NOT NULL,    'localização da loja ( longitude)'
                logo            BYTEA        NOT NULL,    'logo da loja'
                logo_mime_type  VARCHAR(512) NOT NULL,    'logo da loja'
                logo_arquivo    VARCHAR(512) NOT NULL,    'logo da loja'
                logo_charset    VARCHAR(512) NOT NULL,    'logo da loja'
                logo_ultima_atualizacao DATE NOT NULL,    'logo da loja'
                CONSTRAINT pk_lojas PRIMARY KEY (loja_id) 'constraint pk _lojas com pk loja_id'
);
                COMMENT ON TABLE lojas IS                 'tabela de geolocalização física , virtual e logos';

--..........................................................................................................

-- Crie a tabela estoques
               
CREATE TABLE Estoques (
                estoque_id NUMERIC(38) NOT NULL, 'Produtos em estoque'
                produto_id NUMERIC(38) NOT NULL, ' código do produto'
                loja_id    NUMERIC(38) NOT NULL, ' Código da loja'
                quantidade NUMERIC(38) NOT NULL, ' Mercadorias'
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id) ' constraint pk _ estoques com pk estoques _id'
);
COMMENT ON TABLE Estoques IS 'Tabela de quantidade de produtos em estoque';
--...........................................................................................................

--- crie a tabela clientes

CREATE TABLE clientes (
                cliente_id NUMERIC(38)  NOT NULL,                'código do cliente'
                email      VARCHAR(255) NOT NULL,                ' email do cliente'
                nome       VARCHAR(255) NOT NULL,                'nome do cliente'
                telefone1  VARCHAR(20)  NOT NULL,                ' telefone 1'
                telefone2  VARCHAR(20)  NOT NULL,                ' telefone 2'
                telefone3  VARCHAR(20)  NOT NULL,                ' telefone 3'
                CONSTRAINT pk_clientes  PRIMARY KEY (cliente_id) ' constraint pk _ clientes com pk cliente _id'
);
COMMENT ON TABLE clientes IS 'Cadastro de informações para entrar em contato com os clientes';
--.......................................................................................................................

-- crie a tabela pedidos

CREATE TABLE pedidos (
                pedido_id  NUMERIC(38)         NOT NULL,      'id do produto'
                loja_id    NUMERIC(38)         NOT NULL,      'id da loja'
                cliente_id NUMERIC(38)         NOT NULL,      ' id do cliente'
                data_hora  TIMESTAMP           NOT NULL,      ' Data e hora que o pedido foi feito'
                status     VARCHAR(15)         NOT NULL,      ' Status do pedido'
                CONSTRAINT pk_pedidos PRIMARY KEY (pedido_id) 'constraint pk _pedidos com pk pedido _id'
);
COMMENT ON TABLE pedidos IS 'Tabela de status dos pedidos';

--..........................................................................................................
-- crie a tabela envios

CREATE TABLE envios (
                envio_id         NUMERIC(38)  NOT NULL,  'código de envio'
                loja_id          NUMERIC(38)  NOT NULL,  'loja_id com o máximo de caracteres =38'
                cliente_id       NUMERIC(38)  NOT NULL,  'código do cliente'
                endereco_entrega VARCHAR(512) NOT NULL,  'local de entrega'
                status           VARCHAR(15)  NOT NULL,  ' Status do pedido'
                CONSTRAINT pk_envios PRIMARY KEY (envio_id) 'constraint pk _envios com pk envio _id'
);
COMMENT ON TABLE envios IS 'tabela de informações para entrega dos produtos';

--................................................................................

-- Crie a tabela pedidos_itens

CREATE TABLE pedidos_itens (
                produto_id NUMERIC(38) NOT NULL, 'id do produto'
                pedido_id NUMERIC(38) NOT NULL, 'id do pedido'
                envio_id NUMERIC(38) NOT NULL, 'id de envio'
                numero_da_linha NUMERIC(38) NOT NULL, 'numero da linha do pedido'
                preco_unitario NUMERIC(10,2) NOT NULL, 'preço unitario'
                quantidade NUMERIC(38) NOT NULL,'quantidade disponível'
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (produto_id, pedido_id) 'constraint pk _pedidos_itens com produto_id e pk pedido _id'
);
COMMENT ON TABLE pedidos_itens IS 'tabela com informações de envio,preço e quantidade';
--....................................................................................................

-- Alterar tabela estoques e adicionar produtos_estoques como chave estrangeira 

ALTER TABLE Estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--.............

--Alterar tabela pedidos_itens e adicionar produtos_pedidos_itens como chave estrangeira 

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--..........................................................

-- Alterar tabela envios e adicionar lojas_envios como chave estrangeira 

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--..................................................................

--Alterar tabela estoques e adicionar lojas_estoques como chave estrangeira 

ALTER TABLE Estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--...................................................................

--Alterar tabela pedidos e adicionar lojas_pedidos como chave estrangeira 

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--.....................................................

--Alterar tabela envios e adicionar clientes_envios como chave estrangeira 

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--.............................................................

-- Alterar tabela pedidos e adicionar clientes_pedidos como chave estrangeira 

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--........................................................................

--Alterar tabela pedidos_itens e adicionar pedidos_pedidos_itens como chave estrangeira 

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
--...............................................................................

--Alterar tabela pedidos_itens e adicionar envios_pedidos_itens como chave estrangeira 

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;