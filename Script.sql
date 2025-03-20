drop view if exists impiegati_per_sede;
drop view if exists clienti_acquisto;
drop view if exists stipendi_per_sede;
drop view if exists auto_per_sede;
drop view if exists segno_importo;

drop table if exists Recensione;
drop table if exists Leasing;
drop table if exists Noleggio;
drop table if exists Acquisto;
drop table if exists Conto;
drop table if exists Acquisto_auto;
drop table if exists Ordine;
drop table if exists Auto;
drop table if exists Impiegato;
drop table if exists Venditore;
drop table if exists Manager;
drop table if exists Dipendente;
drop table if exists Sede;
drop table if exists Cliente;


CREATE TABLE Cliente(
    ID SERIAL PRIMARY KEY NOT NULL,
    Utente VARCHAR(20) UNIQUE NOT NULL,
    Password VARCHAR(20) NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL
);

CREATE TABLE Sede(
    Nome VARCHAR(50) PRIMARY KEY NOT NULL,
    Stato CHAR(2) NOT NULL,
    Città VARCHAR(20) NOT NULL,
    Provincia VARCHAR(15) NOT NULL,
    Via VARCHAR(20) NOT NULL,
    N_civico VARCHAR(4) NOT NULL
);

CREATE TABLE Dipendente(
    CF VARCHAR(16) PRIMARY KEY NOT NULL,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Sede VARCHAR(50) NOT NULL,
    Stipendio DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (Sede) REFERENCES Sede(Nome)
);

CREATE TABLE Manager(
    CF VARCHAR(16) PRIMARY KEY NOT NULL,
    Inizio_dirigenza DATE NOT NULL,
    Fine_dirigenza DATE CHECK(Fine_dirigenza > Inizio_dirigenza),
    FOREIGN KEY (CF) REFERENCES Dipendente(CF)
);

CREATE TABLE Venditore(
    CF VARCHAR(16) PRIMARY KEY NOT NULL,
    Auto_vendute INT,
    FOREIGN KEY (CF) REFERENCES Dipendente(CF)
);

CREATE TABLE Impiegato(
    CF VARCHAR(16) PRIMARY KEY NOT NULL,
    Mansione VARCHAR(20) NOT NULL,
    FOREIGN KEY(CF) REFERENCES Dipendente(CF)
);

CREATE TABLE Auto(
    ID SERIAL PRIMARY KEY NOT NULL,
    Marca VARCHAR(20) NOT NULL,
    Modello VARCHAR(20) NOT NULL,
    Colore VARCHAR(20) NOT NULL,
    Allestimento VARCHAR(20) NOT NULL,
    Sede VARCHAR(50) NOT NULL,
    Prezzo DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (Sede) REFERENCES Sede(Nome)
);

CREATE TABLE Ordine(
    ID SERIAL PRIMARY KEY NOT NULL,
    Auto SERIAL NOT NULL,
    Cliente SERIAL NOT NULL,
    FOREIGN KEY (Auto) REFERENCES Auto(ID),
    FOREIGN KEY (Cliente) REFERENCES Cliente(ID)
);

CREATE TABLE Acquisto_auto(
    Auto SERIAL PRIMARY KEY NOT NULL,
    Prezzo_listino DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (Auto) REFERENCES Auto(ID)
);

CREATE TABLE Conto(
    ID INT PRIMARY KEY NOT NULL,
    Ordine INT,
    Stipendio VARCHAR(16),
    Acquisto_auto INT,
    Operazione BOOLEAN NOT NULL,
    Data TIMESTAMP NOT NULL,
    Importo DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (Ordine) REFERENCES Ordine(ID),
    FOREIGN KEY (Stipendio) REFERENCES Dipendente(CF),
    FOREIGN KEY (Acquisto_auto) REFERENCES Acquisto_auto(Auto)
);

CREATE TABLE Acquisto(
    Ordine SERIAL PRIMARY KEY NOT NULL,
    Prezzo DECIMAL(8,2) NOT NULL,
    Tasso DECIMAL(3,1),
    Rata_mensile DECIMAL(5,2),
    FOREIGN KEY(Ordine) REFERENCES Ordine(ID)
);

CREATE TABLE Noleggio(
    Ordine SERIAL PRIMARY KEY NOT NULL,
    Data_inizio DATE NOT NULL,
    Data_fine DATE CHECK (Data_fine > Data_inizio) NOT NULL,
    Prezzo DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (Ordine) REFERENCES Ordine(ID)
);

CREATE TABLE Leasing(
    Ordine SERIAL PRIMARY KEY NOT NULL,
    Anticipo DECIMAL(6,2) NOT NULL,
    Rata DECIMAL(6,2) NOT NULL,
    Riscatto DECIMAL(6,2),
    Inizio_contratto DATE NOT NULL,
    Fine_contratto DATE CHECK(Fine_contratto > Inizio_contratto) NOT NULL,
    FOREIGN KEY (Ordine) REFERENCES Ordine(ID)
);

CREATE TABLE Recensione(
    ID SERIAL NOT NULL,
    ID_Ordine SERIAL NOT NULL,
    ID_Cliente SERIAL NOT NULL,
    Valutazione INT CHECK(Valutazione > 0 AND Valutazione <= 5) NOT NULL,
    Commento VARCHAR(100),
    PRIMARY KEY(ID, ID_Ordine, ID_Cliente),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID),
    FOREIGN KEY (ID_Ordine) REFERENCES Ordine(ID)
);


insert into Cliente(ID, Utente, Password, Nome, Cognome) VALUES
(001, 'alfredo_tassi','asdfghjkl', 'Alfredo', 'Tassi' ),
(002, 'mario_conti', 'qwertyui', 'Mario', 'Conti'),
(003, 'maria_poli', 'pjdbeksi', 'Maria', 'Poli'),
(004, 'giuseppe_vesciglio', 'ndskjhbwi', 'Giuseppe', 'Vesciglio'),
(005, 'francesca_giglioli', 'mslvnsdhj', 'Francesca', 'Giglioli'),
(006, 'marta_francesconi', 'aklscndlk', 'Marta', 'Francesconi'),
(007, 'alessia_piruli', 'kdfbvkd', 'Alessia', 'Piruli');

insert into Sede(Nome, Stato, Città, Provincia, Via, N_civico) VALUES
('Dolomiti', 'IT', 'Belluno', 'BL', 'Senaldi', '8'),
('Auto Lombardia', 'IT', 'Milano', 'MI', 'Garibaldi', '12/c'),
('Car Center', 'EN', 'Londra', 'London', 'Churchill Street', '34'),
('Smeralda', 'IT', 'Palau', 'SS', 'Berlinguer', '91/a');

insert into Dipendente(CF, Nome, Cognome, Sede, Stipendio) VALUES
('GTAVZO99I05G908P', 'Vincenzo', 'Giaretta', 'Dolomiti', 2234.53),
('BSOMCO00W10E243Q', 'Marco', 'Basso', 'Smeralda', 1995.32),
('SFIALA84R04T387N', 'Angela', 'Stefani', 'Car Center', 2543.14),
('ZLOFCO04M01Q389L', 'Francesco', 'Zilio', 'Auto Lombardia', 1784.69),
('BGOAMA78L12J488M', 'Anna', 'Biagio', 'Auto Lombardia', 3687.41),
('LZIATO94Y02T449M', 'Alberto', 'De Lorenzi', 'Dolomiti', 3842.75),
('FRCCNZ78O03M120C', 'Cinzia', 'Fraccaro', 'Smeralda', 2456.93),
('CRSENS89I11M401Z', 'Chris', 'Evans', 'Car Center', 4210.75),
('SVORNI76L10X093S', 'Silvio', 'Rini', 'Smeralda', 3526.87),
('SVAPNI96M12B387X', 'Silvia', 'Pellegrini', 'Dolomiti', 2135.47),
('DDEFIN94L02K097R', 'Davide', 'Filippin', 'Dolomiti', 2654.39),
('MROPLI90J08L012X', 'Mario', 'Bonelli', 'Auto Lombardia', 1864.25),
('TCOFCA95O03L037H', 'Francesca', 'Todescato', 'Smeralda', 2498.21),
('LRIMTA88O04K863F', 'Mattia', 'Lauri', 'Dolomiti', 1756.58),
('CPRWLM91J09M449T', 'William', 'Cooper', 'Car Center', 2345.67),
('BSIALO90M04X834A', 'Angelo', 'Bassi', 'Auto Lombardia', 1732.45),
('PLECDA89O12L394C', 'Claudia', 'Pasquale', 'Smeralda', 2631.02),
('GDIARO96O08P025F', 'Alessandro', 'Grandi', 'Car Center', 2469.72),
('CCIMCO98J05E348K', 'Marco', 'Cecchi', 'Auto Lombardia', 2436.19),
('CLISRA96Y03D364H', 'Sara', 'Castelli', 'Car Center', 2964.34);

insert into Manager(CF, Inizio_dirigenza, Fine_dirigenza) VALUES
('CRSENS89I11M401Z', '01-01-2012', '30-09-2018'),
('SVORNI76L10X093S', '12-04-2008', NULL),
('BGOAMA78L12J488M', '21-12-2011', '31-05-2020'),
('LZIATO94Y02T449M', '18-09-2005', NULL);

insert into Venditore(CF, Auto_vendute) VALUES
('GTAVZO99I05G908P', 19),
('SFIALA84R04T387N', 38),
('DDEFIN94L02K097R', 26),
('MROPLI90J08L012X', 22),
('TCOFCA95O03L037H', 16),
('PLECDA89O12L394C', 36),
('CCIMCO98J05E348K', 29),
('CLISRA96Y03D364H', 31);

insert into Impiegato(CF, Mansione) VALUES
('BSOMCO00W10E243Q', 'Amministrazione'),
('ZLOFCO04M01Q389L', 'Risorse Umane'),
('FRCCNZ78O03M120C', 'Contabilità'),
('SVAPNI96M12B387X', 'Accoglienza clienti'),
('LRIMTA88O04K863F', 'Contabilità'),
('CPRWLM91J09M449T', 'Customer service'),
('BSIALO90M04X834A', 'Manutenzione'),
('GDIARO96O08P025F', 'Receptionist');

insert into Auto(ID, Marca, Modello, Colore, Allestimento, Sede, Prezzo) VALUES
(01, 'Fiat', 'Tipo','Bianco', 'Sportivo', 'Dolomiti', 22147.00),
(02, 'Opel', 'Corsa', 'Nero', 'Utilitaria', 'Auto Lombardia', 19789.98),
(03, 'Volkswagen', 'Golf', 'Grigio', 'Sportivo', 'Car Center', 25647.00),
(04, 'Mercedes', 'A150', 'Rosso', 'Berlina', 'Smeralda', 28899.00),
(05, 'Audi', 'A4', 'Nero', 'Berlina', 'Car Center', 27601.00),
(06, 'Alfa Romeo', 'Stelvio', 'Rosso bordeaux', 'Suv', 'Dolomiti', 42150.00),
(07, 'Volvo', 'V90', 'Blu marino', 'Station Wagon', 'Smeralda', 32786.00),
(08, 'Nissan', 'Juke', 'Bianco', 'Suv', 'Auto Lombardia', 35420.99),
(09, 'Peugeot', '208', 'Grigio metallizzato','Utilitaria', 'Smeralda', 18345.00),
(10, 'Fiat', '500 Abarth', 'Rosso Ferrari', 'Sportivo', 'Car Center', 23000.00),
(11, 'Renault', 'Clio', 'Giallo', 'Utilitaria', 'Dolomiti', 17902.00),
(12, 'Toyota', 'Corolla', 'Bianco', 'Berlina', 'Auto Lombardia', 17601.00);

insert into Ordine(ID, Auto, Cliente) VALUES
(0001, 03, 001),
(0002, 12, 005),
(0003, 04, 003),
(0004, 06, 006),
(0005, 10, 002),
(0006, 08, 004),
(0007, 09, 007);

insert into Acquisto_auto(Auto, Prezzo_listino) VALUES
(02, 19789.98),
(01, 22147.00),
(07, 32786.00);
                                                                                          
insert into Conto(ID, Ordine, Stipendio, Acquisto_auto, Operazione, Data, Importo) VALUES 
(01, 0003, NULL, NULL, TRUE, '2020-12-20 13:01:45', 25134.09),
(02, NULL, NULL, 02, FALSE, '2020-12-20 14:05:32', 19789.98),
(03, NULL, 'BSOMCO00W10E243Q', NULL, FALSE, '2020-12-20 14:15:17', 1995.32),
(04, NULL, 'ZLOFCO04M01Q389L', NULL, FALSE, '2020-12-20 15:37:48', 1784.69),
(05, 0001, NULL, NULL, TRUE, '2020-12-20 16:43:56', 25647.00),
(06, 0006, NULL, NULL, TRUE, '2020-12-20 17:02:19', 35420.99),
(07, NULL, 'FRCCNZ78O03M120C', NULL, FALSE, '2020-12-20 17:15:31', 2456.93),
(08, NULL, NULL, 01, FALSE, '2021-01-10 10:43:39', 22147.00),
(09, NULL, NULL, 07, FALSE, '2021-01-10 13:55:29', 32786.00),
(10, NULL, 'SVORNI76L10X093S', NULL, FALSE, '2021-01-10 16:30:03', 3526.87),
(11, 0002, NULL, NULL, TRUE, '2021-01-10 16:31:45', 767.00),
(12, NULL, 'GDIARO96O08P025F', NULL, FALSE, '2021-01-10 16:33:12', 2469.72);

insert into Acquisto(Ordine, Prezzo, Tasso, Rata_mensile) VALUES 
(0006, 35420.99, 10.1, 645.00),
(0007, 18345.00, NULL, NULL);

insert into Noleggio (Ordine, Data_inizio, Data_fine, Prezzo) VALUES
(0002, '12-02-2021' , '12-03-2021', 767.00),
(0005, '14-04-2021', '21-04-2021', 345.00);

insert into Leasing (Ordine, Anticipo, Rata, Riscatto, Inizio_contratto, Fine_contratto) VALUES
(0003, 4500.00, 1023.00, NULL, '18-02-2021', '18-02-2022'),
(0004, 7000.00, 1200.00, NULL, '01-03-2021', '01-03-2022');

insert into Recensione(ID, ID_Ordine, ID_Cliente, Valutazione, Commento) VALUES
(01, 0001, 001, 4, NULL),
(02, 0003, 003, 3, NULL),
(03, 0005, 002, 5, 'Prodotto eccellente e servizio impeccabile!'),
(04, 0007, 007, 3, 'Prodotto straordinario, ma un po meno il servizio...');




/*QUERY PER LE INTERROGAZIONI*/


/*QUERY 1:*/

/*Selezionare gli ID delle operazioni in entrata del conto, l'ID dell'ordine di riferimento, 
la marca e il modello dell'auto acquistata dove l'importo è superiore a 25000 euro,
ordinati per ordine*/

SELECT c.ID AS ID_conto, o.ID AS ID_ordine, a.Marca, a.Modello
FROM conto c, ordine o JOIN auto a on o.auto=a.ID
WHERE c.ordine=o.ID and c.operazione=TRUE
		and c.importo>25000
ORDER BY o.ID



/*QUERY 2:*/

/*Per ogni sede, selezionare il totale dei dipendenti che non sono manager, e, tra questi, lo stipendio maggiore percepito con il rispettivo nome e cognome del
dipendente*/

drop view impiegati_per_sede;

CREATE VIEW impiegati_per_sede (sede, dipendenti, salario) as
SELECT s.nome, COUNT(d.CF), MAX(d.stipendio)
FROM sede s, dipendente d
WHERE s.nome=d.sede and d.CF NOT IN (SELECT CF
								 	FROM manager)
GROUP BY s.nome;

SELECT i.sede, i.dipendenti, i.salario, d.nome, d.cognome
FROM impiegati_per_sede i JOIN dipendente d ON i.sede=d.sede
WHERE i.salario=d.stipendio
GROUP BY i.sede, i.dipendenti, i.salario, d.nome, d.cognome



/*QUERY 3:*/

/*Estrarre nome e cognome dei clienti (ordinati per cognome) che hanno effettuato un ordine d'acquisto su cui hanno scritto
una recensione. Estrarre l'id e la valutazione della recensione.
*/
drop view if exists clienti_acquisto;

CREATE VIEW clienti_acquisto(cognome, nome, ordine) AS
SELECT c.cognome, c.nome, o.id
FROM cliente c, ordine o 
WHERE c.id=o.cliente

EXCEPT 
SELECT c.cognome, c.nome, o.id
FROM cliente c, ordine o, noleggio, leasing
WHERE c.id=o.cliente AND o.id=noleggio.ordine OR o.id=leasing.ordine
	   
ORDER BY cognome;

SELECT ca.cognome, ca.nome, a.prezzo, r.id as id_recensione, r.valutazione
FROM clienti_acquisto ca, acquisto a, recensione r
WHERE ca.ordine=r.ID_ordine AND a.ordine=ca.ordine



/*QUERY 4:*/

/*Estrarre le sedi con il prezzo medio delle auto superiore a 26000 euro. Mostrare il numero di auto disponibili 
per ogni sede e il prezzo medio. */
drop view if exists auto_per_sede;

CREATE VIEW auto_per_sede (sede, tot_auto) AS
SELECT a.sede, count(*)
FROM auto a
GROUP BY a.sede;

SELECT aps.sede, aps.tot_auto, ROUND(AVG(a.prezzo), 2) AS prezzo_medio
FROM auto_per_sede aps, auto a
WHERE a.sede=aps.sede
GROUP BY aps.sede, aps.tot_auto
HAVING AVG(a.prezzo)>26000




/*QUERY 5*/

/*Selezionare per ogni sede la somma di tutti gli stipendi dei dipendenti e il nome e cognome manager che la
dirige*/
drop view if exists stipendi_per_sede;

CREATE VIEW stipendi_per_sede(sede, somma_stipendi) AS
SELECT s.nome, sum(d.stipendio)
FROM sede s, dipendente d
WHERE s.nome=d.sede
GROUP BY s.nome;


SELECT ss.sede,(d.cognome, d.nome) AS manager, ss.somma_stipendi
FROM stipendi_per_sede ss, dipendente d, manager m
WHERE d.CF=m.cf AND d.sede=ss.sede




/*QUERY 6:*/

/*Estrarre dal conto l'ultimo movimento che è stato effettuato in ordine di tempo.
Visualizzare il numero del movimento (ID del conto), l'eventuale ordine o stipendio o l'acquisto dell'auto e il prezzo.
Riguardo al prezzo, se l'operazione è di uscita, visualizzare il segno meno per indicare il prezzo.
*/
drop view if exists segno_importo;

CREATE VIEW segno_importo (movimento, importo) AS
SELECT c.id, (0-c.importo) AS importo
FROM conto c
WHERE c.operazione=FALSE 

UNION

SELECT c.id, c.importo
FROM conto c
where c.operazione=TRUE;


SELECT c.ID as Movimento, c.ordine, c.stipendio AS stipendio_dipendente, c.acquisto_auto, s.importo
FROM Conto c, segno_importo s
WHERE c.id=s.movimento AND c.data=(SELECT MAX(c.data)
								  FROM conto c)




/*INDICI:*/


/*Indice per la ricerca di movimenti nel conto*/

drop index if exists ricerca_movimento;

create index ricerca_movimento on Conto(Ordine, Stipendio, Acquisto_auto, Importo);


/*Indice per la ricerca di dipendenti*/
drop index if exists ricerca_dipendente;

create index ricerca_dipendente on Dipendente(Nome, Cognome, Sede);

