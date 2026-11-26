--modalidades: id PK, nome string
--jogos: id PK, id_jogador, modalidade_id FK, titulo string, data data, status string
--jogadores: id PK, nome, email, senha hash, ativo bool
--historico_partidas: id, id_partida, observacao varchar (contem status da partida)

CREATE TABLE modalidades (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE jogadores (
  id SERIAL PRIMARY KEY,
  nickname VARCHAR(30) NOT NULL UNIQUE,
  email VARCHAR(100) unique NOT NULL,
  cpf bytea not null,
  senha VARCHAR(64) NOT NULL,              
  ativo bool default true,
  data_cadastro timestamp default current_timestamp
);

CREATE TABLE partidas (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  id_modalidade INT NOT NULL REFERENCES modalidades(id),
  id_jogador INT REFERENCES jogadores(id),
  data_partida TIMESTAMP NOT NULL,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(15) NOT NULL DEFAULT 'agendada' CHECK (status IN ('agendada','em_andamento','finalizada','cancelada'))
);

CREATE TABLE historico_partidas (
  id SERIAL PRIMARY KEY,
  id_partida INT references partidas(id) on delete cascade,
  descricao VARCHAR(30) NOT NULL,
  data_log TIMESTAMP DEFAULT current_timestamp
);


insert into modalidades (nome) values 
('valorant'), 
('fortnite'), 
('minecraft');

insert into jogadores (nickname, email, cpf, senha, ativo) values 
('joao1', 'joao1@email.com', pgp_sym_encrypt('111111111-00', 'chavelgpd'), encode(digest('joao1senha', 'sha256'), 'hex'), true),  
('joao2', 'joao2@email.com', pgp_sym_encrypt('222222222-00', 'chavelgpd'), encode(digest('joao2senha', 'sha256'), 'hex'), true), 
('joao3', 'joao3@email.com', pgp_sym_encrypt('333333333-00', 'chavelgpd'), encode(digest('joao3senha', 'sha256'), 'hex'), true);

insert into partidas (titulo, id_modalidade, id_jogador, data_partida, data_criacao) values 
('partida1', 3, 1, current_date + interval '3 days', default), 
('partida2', 2, 2, current_date + interval '2 days', default), 
('partida3', 1, 3, current_date + interval '1 days', default);

create or replace view vw_cronograma_partidas as
select
	p.id as partida_id,
	j.nickname as jogador_nome,
	m.nome as modalidade,
	p.titulo as partida,
	p.data_partida,
	p.status
from partidas p
join jogadores j on p.id_jogador = j.id
join modalidades m on p.id_modalidade = m.id;





