# Definire database per Esercitazione

create database Esercitazione;
use esercitazione;

create table Product (
	id_prodotto int auto_increment,
    nome varchar(50),
    prezzo decimal(6,2),
    primary key (id_prodotto)
);

insert into Product (nome,prezzo) values ("Bolle di sapone",4.99);
insert into Product (nome,prezzo) values ("Monopoli",19.99);
insert into Product (nome,prezzo) values ("Bambola",49.99);
insert into Product (nome,prezzo) values ("Macchina lego",59.99);
insert into Product (nome,prezzo) values ("Carte da Uno",15.50);
insert into Product (nome,prezzo) values ("Libro da colorare",5.50);
insert into Product (nome,prezzo) values ("Coriandoli",2.99);
insert into Product (nome,prezzo) values ("Soldatiti",29.99);
insert into Product (nome,prezzo) values ("Barbie",25.50);
insert into Product (nome,prezzo) values ("Casa delle bambole",150.5);
select * from Product;

create table Region (
	id_regione int auto_increment,
    regione varchar(50),
    primary key (id_regione)
);

insert into Region (regione) values 
	("Abruzzo"),
    ("Basilicata"),
    ("Calabria"),
    ("Campania"),
    ("Emilia Romagna"),
    ("Friuli Venezia Giulia"),
    ("Lazio"),
    ("Liguria"),
    ("Lombardia"),
    ("Marche"),
    ("Molise"),
    ("Piemonte"),
    ("Puglia"),
    ("Sardegna"),
    ("Sicilia"),
    ("Toscana"),
    ("Trentino Alto Adige"),
    ("Umbria"),
    ("Valle d'Aosta"),
    ("Veneto");
select * from Region;

create table Sales (
	id_vendita int auto_increment primary key,
    prodotto int,
    regione int,
    data date,
    quantita int,
    foreign key (prodotto) references Product (id_prodotto),
    foreign key (regione) references Region (id_regione)
);

insert into Sales (prodotto,regione,data,quantita) values (1,1,"2021-04-12",12);
insert into Sales (prodotto,regione,data,quantita) values (1,2,"2022-10-23",34);
insert into Sales (prodotto,regione,data,quantita) values (1,4,"2023-01-24",57);
insert into Sales (prodotto,regione,data,quantita) values (1,5,"2024-12-09",12);
insert into Sales (prodotto,regione,data,quantita) values (2,7,"2024-03-14",56);
insert into Sales (prodotto,regione,data,quantita) values (2,17,"2023-11-16",8);
insert into Sales (prodotto,regione,data,quantita) values (2,8,"2022-05-30",34);
insert into Sales (prodotto,regione,data,quantita) values (2,20,"2021-02-24",67);
insert into Sales (prodotto,regione,data,quantita) values (3,19,"2024-11-15",122);
insert into Sales (prodotto,regione,data,quantita) values (3,11,"2023-12-23",65);
insert into Sales (prodotto,regione,data,quantita) values (3,14,"2022-06-30",34);
insert into Sales (prodotto,regione,data,quantita) values (3,4,"2021-07-15",122);
insert into Sales (prodotto,regione,data,quantita) values (4,20,"2024-09-21",432);
insert into Sales (prodotto,regione,data,quantita) values (4,3,"2023-12-19",36);
insert into Sales (prodotto,regione,data,quantita) values (4,5,"2022-04-13",87);
insert into Sales (prodotto,regione,data,quantita) values (4,10,"2021-06-13",23);
insert into Sales (prodotto,regione,data,quantita) values (5,5,"2021-10-16",45);
insert into Sales (prodotto,regione,data,quantita) values (5,8,"2022-03-12",90);
insert into Sales (prodotto,regione,data,quantita) values (5,19,"2023-01-08",67);
insert into Sales (prodotto,regione,data,quantita) values (5,1,"2024-04-24",86);
insert into Sales (prodotto,regione,data,quantita) values (6,3,"2024-12-25",34);
insert into Sales (prodotto,regione,data,quantita) values (6,5,"2023-12-12",176);
insert into Sales (prodotto,regione,data,quantita) values (6,18,"2022-10-29",34);
insert into Sales (prodotto,regione,data,quantita) values (6,16,"2021-03-30",65);
select * from Sales;

# 1 Verficare che i campi definiti come PK siano univoci.
	# Avendo inserito auto_increment non dovrebbero esserci duplicati
# controllo comunque con una query (se erano indici non primay potevo usare indice unique)
select id_prodotto, count(*)
from Product
group by id_prodotto
having count(*) > 1;

select id_regione, count(*)
from Region
group by id_regione
having count(*) > 1;

select id_vendita, count(*)
from Sales
group by id_vendita
having count(*) > 1;

# 2 Esporre elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno
select p.nome as Giocattolo, year(data) as Anno, sum(prezzo * quantita) as "Fatturato Totale" from
Product p join Sales s
on p.id_prodotto = s.prodotto
group by p.nome, year(data)
order by p.nome;

# 3 Esporre il fatturato totale per stato(regione) per anno. Ordina il risultato per data e per fatturato decrescente
select distinct r.regione, year(data) as Anno, sum(prezzo * quantita) as "Fatturato Totale" from
Product p join Sales s
on p.id_prodotto = s.prodotto
join Region r
on id_regione = s.regione
group by r.regione, year(data)
order by data, sum(prezzo * quantita) desc;

# 4 Qual è la categoria di articoli maggiormente richiesta sul mercato? ( quale articolo ha la massima quantità di vendite)
# Mostro classifica maggiori vendite per prodotti
select nome as Giocattolo, max(quantita) as "Quantità venduta" from
Product p join sales s
on p.id_prodotto = s.prodotto
group by nome
order by max(quantita) desc;

# esplicito la risposta mostrando il 1* prodotto con quantità maggiore
select nome as Giocattolo, max(quantita) as "Quantità venduta" from
Product p join sales s
on p.id_prodotto = s.prodotto
group by nome
order by max(quantita) desc limit 1;

# Mostra i prodotti invenduti (se ci sono); proponi due approcci risolutivi:
# IS NULL
select p.id_prodotto, nome as Giocattolo, prezzo from 
Product p left join Sales s
on p.id_prodotto = s.prodotto
where s.prodotto is null;

# NOT IN 
select id_prodotto, nome as Giocattolo, prezzo from Product p
where p.id_prodotto not in (
	select s.prodotto from Sales s
    );

# 6 Esponi elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendità più recente)
select p.nome as Giocattolo, max(data) as "Data vendita più recente" from
Product p join Sales s
on p.id_prodotto = s.prodotto
group by p.nome
order by max(data) desc;