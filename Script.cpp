#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"

using namespace std;

#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"                   //Change this
#define PG_DB "Progetto_concessionaria"      //Change this
#define PG_PASS "postgres"                   //Change this
#define PG_PORT 5432                         //Change this


void CheckResult(PGresult* res, const PGconn* conn){
    if(PQresultStatus(res) != PGRES_TUPLES_OK){
        cout << "Non e' stato restituito un risultato" << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}


PGconn* connect(const char* host, const char* user, const char* db, const char* pass, int port) {
    char conninfo[256];
    snprintf(conninfo, 256, "user = %s, password = %s, dbname = %s, hostaddr =%s, port = %d", user, pass, db, host, port);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione" << endl << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }
    else{
        cout << "Connessione riuscita" << endl;
    }

    return conn;
}


int main(){
    PGconn* conn = connect(PG_HOST, PG_USER, PG_DB, PG_PASS, PG_PORT);


    cout <<"Query 1:"<< endl;
    cout <<"Estrarre gli id delle operazioni in entrata nel conto, l'id dell'ordine di riferimento, la marca e il modello dell'auto acquistata dove l'importo e' superiore a 25000.00 euro, ordinati per ordine" << endl;
    PGresult* res;
    res = PQexec(conn, "SELECT c.ID, o.ID, a.Marca, a.Modello FROM conto c, ordine o JOIN auto a on o.auto = a.ID WHERE c.ordine = o.ID AND c.operazione = TRUE AND c.importo > 25000.00 ORDER BY o.ID");
   
    CheckResult(res, conn);
   
    int tuple = PQntuples(res);
    int campi = PQnfields(res);
   
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        cout << PQfname(res, i) << "\t\t";
    }
    cout << endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
    PQclear(res);

    cout <<"Query 2:"<< endl;
    cout <<"Per ogni sede selezionare il totale dei dipendenti che non sono manager, lo stipendio maggiore percepito con il rispettivo nome e cognome del dipendente"<< endl;
    
    res = PQexec(conn, "drop view if exists Impiegati_per_sede; CREATE VIEW Impiegati_per_sede(sede, dipendenti, salario) AS SELECT s.nome, COUNT(d.CF), MAX(d.stipendio) FROM sede s, dipendente d WHERE s.nome = d.sede AND d.CF NOT IN (SELECT CF FROM Manager) GROUP BY s.nome; SELECT i.sede, i.dipendenti, i.salario, d.nome, d.cognome FROM Impiegati_per_sede i JOIN Dipendente d ON i.sede = d.sede WHERE i.salario = d.salario GROUP BY i.sede, i.dipendenti, i.salario, d.nome, d.cognome");
    
    CheckResult(res, conn);
    
    tuple = PQntuples(res);
    campi = PQnfields(res);
    
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        cout << PQfname(res, i) << "\t\t";
    }
    cout << endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
    PQclear(res);

    cout <<"Query 3:"<< endl;
    cout <<"Estrarre nome e cognome dei clienti (ordinati per cognome) che hanno effettuato un ordine d'acquisto su cui hanno scritto una recensione. Estrarre inoltre il prezzo dell'ordine, l'id e la valutazione della recensione"<< endl;
    
    res = PQexec(conn, "drop view if exists Clienti_acquisto; CREATE VIEW Clienti_acquisto (cognome, nome, ordine) AS SELECT c.cognome, c.nome, o.id FROM Cliente c, Ordine o WHERE o.cliente = c.id EXCEPT  SELECT c.cognome, c.nome, o.id FROM Cliente c, Ordine o, Noleggio n, Leasing l WHERE c.id = o.cliente AND o.id = n.ordine OR o.id = l.ordine ORDER BY cognome; SELECT ca.cognome, ca.nome, a.prezzo, r.id AS ID_recensione, r.valutazione FROM Clienti_acquisto ca, Recensione r, Acquisto a WHERE ca.ordine = r.ID_ordine AND a.ordine = ca.ordine");
    
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
    
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        cout << PQfname(res, i) << "\t\t";
    }
    cout << endl;
    
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
    PQclear(res);

    cout <<"Query 4:"<< endl;
    cout <<"Selezionare la sede, il totale delle auto disponibili e il prezzo medio delle auto che hanno una media dei prezzi > 26000.00 euro"<< endl;
    
    res = PQexec(conn, "drop view if exists Auto_per_sede; CREATE VIEW Auto_per_sede(sede, tot_auto) AS SELECT a.sede, COUNT(*) FROM Auto a GROUP BY a.sede; SELECT aps.sede, aps,tot_auto, ROUND(AVG(a.Prezzo), 2) AS Prezzo_medio FROM Auto_per_sede aps, auto a WHERE a.sede = aps.sede GROUP BY aps.sede, aps.tot_auto HAVING AVG(a.prezzo) > 25000");
   
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
    
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        cout << PQfname(res, i) << "\t\t";
    }
    cout << endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
    PQclear(res);

    cout <<"Query 5:"<< endl;
    cout <<"Selezionare per ogni sede la somma di tutti gli stipendi dei dipendenti e il nome e cognome del manager che la dirige"<< endl;
    
    res = PQexec(conn, "drop view if exists Stipendi_per_sede; CREATE VIEW Stipendi_per_sede(sede, somma_stipendi) AS SELECT s.nome, SUM(d.stipendio) FROM sede s, dipendente d WHERE s.nome = d.sede GROUP BY s.nome; SELECT ss.sede, (d.cognome, d.nome) AS Manager, ss.somma_stipendi FROM Stipendi_per_sede ss, dipendente d, manager m WHERE d.CF = m.CF AND d.sede = ss.sede");
   
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
   
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        cout << PQfname(res, i) << "\t\t";
    }
    cout << endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
    PQclear(res);

    cout <<"Query 6:"<< endl;
    cout <<"Estrarre dal conto l'ultimo movimento che e' stato effettuato in ordine di tempo. Visualizzare il numero del movimento (ID del conto), l'eventuale ordine, il codice fiscale del dipendente in caso di stipendio o l'acquisto dell'auto, e il prezzo. Riguardo al prezzo, se l'operazione e' di uscita, visualizzare il segno meno per indicarlo"<< endl;
    
    res = PQexec(conn, "drop view if exists Segno_importo; CREATE VIEW Segno_importo(movimento, importo) AS SELECT c.ID, (0 - c.Importo) AS Importo FROM Conto c WHERE c.Operazione = FALSE UNION SELECT c.ID, c.Importo FROM Conto c WHERE c.Operazione = TRUE; SELECT c.ID AS Movimento, c.Ordine, c.Stipendio AS Stipendio_dipendente, c.Acquisto_auto, s.Importo FROM Conto c, Segno_importo s WHERE c.ID = Movimento AND c.Data = (SELECT MAX(c.Data) FROM Conto c)");
   
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
   
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        cout << PQfname(res, i) << "\t\t";
    }
    cout << endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            cout << PQgetvalue(res, i, j) << "\t\t";
        }
        cout << endl;
    }
    PQclear(res);

    PQfinish(conn);
    return 0;
}