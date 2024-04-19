-- Comando para criar um novo banco de dados. 
CREATE DATABASE casaoliveira;
-- comando para selecionar o banco de dados criado
USE casaoliveira;

-- Comando para a criação de tabelas
CREATE TABLE usuario(
idusuario int auto_increment primary key,
nomeusuario varchar(50) not null unique,
senha varchar(255) not null,
criadoem datetime default current_timestamp(),
foto varchar(250) not null
);
CREATE TABLE funcionario(
idfuncionario int auto_increment primary key,
nomefuncionario varchar(50) not null,
cpf varchar(13) not null unique,
idcargo int not null,
expediente varchar(50) not null,
idusuario int not null,
idendereco int not null,
idcontato int not null
);

CREATE TABLE cargo(
idcargo int auto_increment primary key,
titulocargo varchar(30) not null unique,
salario decimal(7,2) not null,
departamento varchar(30) not null unique
);
CREATE TABLE contato(
idcontato int auto_increment primary key,
telefoneresidencial varchar(15),
telefonecelular varchar(15) not null unique,
email varchar(100) not null unique
);
CREATE TABLE endereco(
idendereco int auto_increment primary key,
tipologradouro enum("Rua","Avenida","Travessa","Estrada","Viela","Praça","Alameda"),
logradouro varchar(50) not null,
numero varchar(10) not null,
complemento varchar(30),
bairro varchar(30) not null,
cep varchar(10) not null,
cidade varchar(30) not null,
estado varchar(20) not null
);

CREATE TABLE fornecedor(
idfornecedor int auto_increment primary key,
razaosocial varchar(50) not null unique,
nomefantasia varchar(50) not null,
cnpj varchar(15) not null unique,
idcontato int not null,
idendereco int not null
);

CREATE TABLE produto(
idproduto int auto_increment primary key,
nomeproduto varchar(50) not null unique,
categoria enum("Frios","Limpeza","Laticinios","Cereais","Açougue","Bebidas","Pães","Hortifruti"),
descricao text not null,
idfornecedor int not null,
preco decimal(6,2) not null
);

CREATE TABLE lote(
idlote int auto_increment primary key,
datafabricacao date not null,
datavalidade date not null,
idproduto int not null
);

CREATE TABLE estoque(
idestoque int auto_increment primary key,
idlote int not null,
quantidade int not null,
dataestoque datetime default current_timestamp()
);
CREATE TABLE cliente(
idcliente int auto_increment primary key,
nomecliente varchar(50) not null,
cpf varchar(13) not null unique,
datanascimento date not null,
idcontato int not null,
idendereco int not null
);

CREATE TABLE venda(
idvenda int auto_increment primary key,
idcliente int not null,
idfuncionario int not null,
datahora datetime default current_timestamp(),
total decimal(7,2) not null
);

CREATE TABLE detalhevenda(
iddetalhevenda int auto_increment primary key,
idvenda int not null,
idproduto int not null,
quantidade int not null,
subtotal decimal(7,2)
);

CREATE TABLE pagamento(
idpagamento int auto_increment primary key,
idvenda int not null,
formapagamento enum("Dinheiro","Crédito","Débito","PIX"),
observacao text not null
);

-- comando que apagao banco de dados
-- drop database casaoliveira;

-- Alterar a tabela funcionário para adicionar
-- uma chaver estrangeira e um relacionamento
-- com a tabela de usuario
ALTER TABLE funcionario
ADD CONSTRAINT `fk.func_pk.usuario`
FOREIGN KEY funcionario(`idusuario`) 
REFERENCES usuario(`idusuario`);

-- Relacionamento da tabela de funcionário com cargo
ALTER TABLE funcionario
ADD CONSTRAINT `fk.func_pk.cargo`
FOREIGN KEY funcionario(`idcargo`)
REFERENCES cargo(`idcargo`);

ALTER TABLE funcionario
ADD CONSTRAINT `fk.func_pk.endereco`
FOREIGN KEY funcionario(`idendereco`)
REFERENCES endereco(`idendereco`);

ALTER TABLE funcionario
ADD CONSTRAINT `fk.func_pk.contato`
FOREIGN KEY funcionario(`idcontato`)
REFERENCES contato(`idcontato`);

-- Adicionar uma constraint (restrição) para a tabela fornecedor
-- para adicionar uma chave estrangeira e estabelecer relacionamentos
-- com as tabelas contato e endereco

ALTER TABLE fornecedor ADD CONSTRAINT `fk.forne_pk.contato`
FOREIGN KEY fornecedor(`idcontato`) REFERENCES contato(`idcontato`);

ALTER TABLE fornecedor ADD CONSTRAINT `fk.forne_pk.endereco`
FOREIGN KEY fornecedor(`idendereco`) REFERENCES endereco(`idendereco`);

-- Alterar a tabela produto adicionando uma constraint e relacionamento
ALTER TABLE produto ADD CONSTRAINT `fk.produto_pk.forne`
FOREIGN KEY produto (`idfornecedor`) REFERENCES fornecedor (`idfornecedor`);

-- alterar a tabela lote adicionando uma chave estrangeira
-- realizando o relacionamento com a tabela produto
ALTER TABLE lote ADD CONSTRAINT `fk.lote_pk.produto`
FOREIGN KEY lote(`idproduto`) REFERENCES produto(`idproduto`);

-- adicionar constraint a tabela de estoque
alter table estoque add constraint `fk.estoque_pk.lote`
foreign key estoque(`idloye`) references lote(`idlote`);

alter table cliente add constraint `fk.cliente_pk.contato`
foreign key cliente(`idcontato`) references contato (`idcontato`);

alter table cliente add constraint `fk.cliente_pk.endereco`
foreign key cliente(`idendereco`) references endereco(`idendereco`);

alter table venda add constraint `fk.venda_pk.cliente`
foreign key venda(`idcliente`) references cliente(`idcliente`);

alter table venda add constraint `fk.venda_pk.func`
foreign key venda(`idfuncionario`) references funcionarios(`idfuncionario`);

alter table detalhevenda add constraint `fk.detalhevenda_pk.venda`
foreign key detalhevenda(`idvenda`) references venda(`idvenda`);

alter table detalhevenda add constraint `fk.detalhevenda_pk.produto`
foreign key detalhevenda(`idproduto`)  references produto(`idproduto`)

alter table pagamento add constraint `fk.pagamento_pk.venda`
foreign key pagamento(`idvenda`) references venda(`idvenda`)
