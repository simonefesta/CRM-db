#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void visualizzaClientiFunzionario(MYSQL *conn){
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1]; 

	char idFunzionario [15] ;
	
	int idf;
	printf("\n >> Visualizza clienti associati ad un funzionario <<\n\n");
	printf("\nInserire matricola funzionario da visionare: ");
	getInput(17, idFunzionario, false);

	idf = atoi(idFunzionario);

	
	if(!setup_prepared_stmt(&prepared_stmt, "call visualizzaClientiFunzionario(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'VisualizzaClientiFunzionario'.\n", false);
	}

	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_LONG;
	param[0].buffer = &idf;
	param[0].buffer_length = sizeof(idf);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'VisualizzaClientiFunzionario'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nella visualizzazione dei clienti.\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista dei clienti.");
	mysql_stmt_next_result(prepared_stmt);
	mysql_stmt_close(prepared_stmt);



}




static void visualizzaClienteSingolo(MYSQL *conn){
	
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];
	char nome[30];
	char cognome[30];

	printf("\n >> Dati cliente <<\n\n");
	printf("\nInserire nome: ");
	getInput(30, nome, false);
	
	printf("\nInserire cognome: ");
	getInput(30, cognome, false);
	
	
		if(!setup_prepared_stmt(&prepared_stmt, "call visualizzaClienteSingolo(?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'visualizzaClienteSingolo'\n", false);
	}
	
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = nome;
	param[0].buffer_length = strlen(nome);	
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = cognome;
	param[1].buffer_length = strlen(cognome);	

	
	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'visualizzaClienteSingolo'\n", true);
	}


	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'visualizzaClienteSingolo'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nDati Personali");
	mysql_stmt_next_result(prepared_stmt);
	mysql_stmt_close(prepared_stmt);
	
	
	//////// PROPOSTE ACCETTATE
	
	
	if(!setup_prepared_stmt(&prepared_stmt, "call proposteAccettateSingolo(?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione proposte\n", false);
	}
	
	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "errore binding proposte accettate.\n", true);
	}


	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'proposteAccettate'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nProposte Accettate\n");
	mysql_stmt_next_result(prepared_stmt);

	
	printf("\n");
	
	
	////////NOTE CLIENTE
	
		if(!setup_prepared_stmt(&prepared_stmt, "call listaNoteCliente(?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione note\n", false);
	}
	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for company list\n", true);
	}


	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'listaNoteCliente'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nNote rilasciate dal cliente\n");
	mysql_stmt_next_result(prepared_stmt);

	
	printf("\n");


	


}

static void visualizzaNota(MYSQL *conn){

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];
	char codice[15];

	printf("\n >> Visualizza note associate ad una proposta <<\n\n");
	printf("\nNome proposta: ");
	getInput(15, codice, false);

	
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = codice;
	param[0].buffer_length = strlen(codice);	

	
	
	if(!setup_prepared_stmt(&prepared_stmt, "call visualizzaNota(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'visualizza Nota'\n", false);
	}

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'Visualizza Nota'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'Visualizza Nota'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista delle note\n");
	mysql_stmt_next_result(prepared_stmt);
	mysql_stmt_close(prepared_stmt);



}

static void visualizzaAppuntamento(MYSQL *conn){

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];
	char anno[5];
	char mese[3];
	char giorno[3];

	MYSQL_TIME data;
	memset(&data,0, sizeof(data));

	printf("\n >> Visione appuntamenti << \n\n");
	printf("Inserire giorno: ");
	getInput(3, giorno, false);
	printf("Inserire mese: ");
	getInput(3, mese, false);
	printf("Inserire anno: ");
	getInput(5, anno, false);
	
	data.day=atoi(giorno);
	data.month=atoi(mese);
	data.year=atoi(anno);

	
	
	if(!setup_prepared_stmt(&prepared_stmt, "call visualizzaAppuntamento(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'visualizzaAppuntamento'\n", false);
	}
	
	
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_DATETIME;
	param[0].buffer =&data;
	param[0].buffer_length = sizeof(data);	



	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'VisualizzaAppuntamento' \n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'VisualizzaAppuntamento'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista degli appuntamenti\n");
	mysql_stmt_next_result(prepared_stmt);
	mysql_stmt_close(prepared_stmt);


}

static void gestioneNota(MYSQL *conn){
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];

	char propostareale[20];
	char tipo[12];
	char descrizione[150];
	
	printf("\n >> Gestione delle note << \n\n");
	
	
	if(!setup_prepared_stmt(&prepared_stmt, "call listaComunicazioni()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione lista comunicazioni\n", false);
	}
	

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'listaComunicazioni'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista codici\n");
	mysql_stmt_next_result(prepared_stmt);

	
	printf("\n");
	
	
	
	
	
	printf("\nProposta Reale associata: ");
	getInput(20, propostareale, false);
	printf("Definisci il tipo ('Servizio','Costo','Assistenza','Altro'): ");
	getInput(12, tipo, false);
	printf("Inserisci la nota: ");
	getInput(150, descrizione, false);



	if(!setup_prepared_stmt(&prepared_stmt, "call gestioneNota(?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'gestioneNota'\n", false);
	}
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = propostareale;
	param[0].buffer_length = strlen(propostareale);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = tipo;
	param[1].buffer_length = strlen(tipo);
	
	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = descrizione;
	param[2].buffer_length = strlen(descrizione);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'gestioneNota'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nella gestione della nota\n");
	}else{
		printf("\nNota inserita correttamente.\n");
	}


	mysql_stmt_close(prepared_stmt);
}


static void inserisciAppuntamento(MYSQL *conn){
	printf("\033[2J\033[H");
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

	char anno[5];
	char mese[3];
	char giorno[3];
	char ora[3];
	char minuti[3];

	char sala[20];
	char sede[20];
	char propostareale[20];
	char nota[150];
	
	printf("\n >> Creazione appuntamento << \n");

	
	//LISTA PROPOSTE POSITIVE
	if(!setup_prepared_stmt(&prepared_stmt, "call visualizzaClientePropostePendenti()", conn)) {
	finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'visualizzaClientiPropostePendenti'\n", false);
	}
	

	
	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'visualizzaClientiPropostePendenti'\n", true);
	}


	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'visualizzaClientiPropostePendenti'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista dei clienti con esito 'Positivo'.");
	mysql_stmt_next_result(prepared_stmt);

	
	


	
	MYSQL_TIME data,orario;
	memset(&data,0, sizeof(data));
	memset(&orario,0, sizeof(orario));
	

	

	
	
	if(!setup_prepared_stmt(&prepared_stmt, "call calendario()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione calendario\n", false);
	}
	

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'VisualizzaAppuntamento'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nCalendario");
	mysql_stmt_next_result(prepared_stmt);

	
	printf("\n");
	
	//LISTA SEDI
	
	if(!setup_prepared_stmt(&prepared_stmt, "call listaSedi()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione sedi\n", false);
	}
	

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'VisualizzaAppuntamento'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista delle sedi.");
	mysql_stmt_next_result(prepared_stmt);

	
	printf("\n >> Inserimento appuntamento << \n\n");
	

	printf("Sala: ");
	getInput(20, sala, false);
	printf("Sede: ");
	getInput(20, sede, false);
	printf("Proposta Reale associata: ");
	getInput(10, propostareale, false);
	
	printf("\n Selezione data\n");
	
	printf("Giorno: ");
	getInput(3, giorno, false);
	printf("Mese: ");
	getInput(3, mese, false);
	printf("Anno: ");
	getInput(5, anno, false);
	printf("Ora: ");
	getInput(3, ora, false);
	printf("Minuti: ");
	getInput(3, minuti, false);
	
	printf("Nota descrittiva: ");
	getInput(150, nota, false);



	data.day=atoi(giorno);
	data.month=atoi(mese);
	data.year=atoi(anno);
	data.hour = atoi(ora);
	data.minute = atoi(minuti);
	
	
	


	if(!setup_prepared_stmt(&prepared_stmt, "call inserisciAppuntamento(?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'inserisciAppuntamento'\n", false);
	}

	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_DATETIME;
	param[0].buffer = &data;
	param[0].buffer_length = sizeof(data);
	
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = sala;
	param[1].buffer_length = strlen(sala);

	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer =sede;
	param[2].buffer_length = strlen(sede);
	
	param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[3].buffer = propostareale;
	param[3].buffer_length = strlen(propostareale);
	
	param[4].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[4].buffer = nota;
	param[4].buffer_length = strlen(nota);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'inserisciAppuntamento'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'inserisciAppuntamento'\n");
	}else{
		printf("Appuntamento registrato.\n");
	}


	mysql_stmt_close(prepared_stmt);

}



static void comunicaPropostaReale(MYSQL *conn){
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

	char esito[20];
	char codiceproposta[15];
	char cliente[5];
	char funzionario[5];
	int  idcomunicazione = 0;

	printf("\n >> Comunicazione proposta ad un cliente << \n\n");
	
	
	if(!setup_prepared_stmt(&prepared_stmt, "call listaClienti()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione listaClienti\n", false);
	}
	

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'listaClienti'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista Clienti\n");
	mysql_stmt_next_result(prepared_stmt); 

	printf("\n\nCodice Cliente: ");
	getInput(5, cliente, false);
	printf("Codice Funzionario: ");
	getInput(5, funzionario, false);
	printf("Codice della proposta: ");
	getInput(15, codiceproposta, false);
	printf("Esito ('Positivo','Negativo','Accettato','Altro'): ");
	getInput(20, esito, false);
	
	
	
	
	

	if(!setup_prepared_stmt(&prepared_stmt, "call comunicaProposta(?, ?, ?, ?,?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'comunicaProposta'\n", false);
	}

	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = esito;
	param[0].buffer_length = strlen(esito);
	
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = codiceproposta;
	param[1].buffer_length = strlen(codiceproposta);

	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = cliente;
	param[2].buffer_length = strlen(cliente);
	
	param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[3].buffer = funzionario;
	param[3].buffer_length = strlen(funzionario);
	
	//OUT
	param[4].buffer_type = MYSQL_TYPE_LONG;
	param[4].buffer = &idcomunicazione;
	param[4].buffer_length = sizeof(idcomunicazione);


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'comunicaProposta'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'comunicaProposta'\n");
	}else{
		printf("Proposta comunicata.\n");
	}
	
	memset(param, 0, sizeof(param));
 	param[0].buffer_type = MYSQL_TYPE_LONG; // OUT
 	param[0].buffer = &idcomunicazione;
	param[0].buffer_length = sizeof(idcomunicazione);

 	if(mysql_stmt_bind_result(prepared_stmt, param)) {
 	    print_stmt_error(prepared_stmt, "Errore nel risultato in uscita.");
	   }

 	// Retrieve output parameter
 	if(mysql_stmt_fetch(prepared_stmt)) {
 	      print_stmt_error(prepared_stmt, "Impossibile generare id comunicazione.");
  
 	  } else {
 		  printf("\nId univoco della comunicazione: %d",idcomunicazione);
  		 }


	mysql_stmt_close(prepared_stmt);


}

static void esitoAppuntamento(MYSQL *conn){
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[2];

	char esito[20];
	char appuntamento[20];

	printf("\n >> Esito Appuntamento << \n\n");
	
	//LISTA CODICI
	
	if(!setup_prepared_stmt(&prepared_stmt, "call listaCodiciAppuntamenti()", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore inizializzazione lista codici\n", false);
	}
	

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'listaCodiciAppuntamenti'\n");
	}

	// Dump the result set
	dump_result_set(conn, prepared_stmt, "\nLista codici\n");
	mysql_stmt_next_result(prepared_stmt);

	
	printf("\n");
	
	

	printf("Codice dell'appuntamento: ");
	getInput(20, appuntamento, false);
	printf("Esito ('Accettato' o 'Negativo'): ");
	getInput(20, esito, false);
	
	if(!setup_prepared_stmt(&prepared_stmt, "call esitoAppuntamento(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'esitoAppuntamento'\n", false);
	}

	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = appuntamento;
	param[0].buffer_length = strlen(appuntamento);
	
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = esito;
	param[1].buffer_length = strlen(esito);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'esitoAppuntamento'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nell'esecuzione di 'esitoAppuntamento'\n");
	}else{
		printf("Esito appuntamento registrato.\n");
	}


	mysql_stmt_close(prepared_stmt);


}






void run_funzionario(MYSQL *conn)
{
	char options[9] = {'1','2', '3', '4', '5', '6','7','8','0'};
	char op;
	
	printf("Eseguo come funzionario...\n");

	if(!parse_config("users/funzionario.json", &conf)) {
		fprintf(stderr, "Errore nel parsing per l'utente 'funzionario'\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf(">> Lista operazioni disponibili <<\n\n");
		
		printf("1) Lista clienti gestiti da un funzionario.\n");
		printf("2) Visualizza singolo cliente, note e proposte accettate.\n");
		printf("3) Visualizza le note di una proposta.\n");
		printf("4) Visualizza appuntamenti fissati.\n");
		printf("5) Gestisci le note dei clienti.\n");
		printf("6) Inserisci un appuntamento.\n");
		printf("7) Comunica una proposta ad un cliente.\n");
		printf("8) Aggiorna l'esito di un appuntamento.\n");
		
		
		printf("0) esci\n\n");
	
		op = multiChoice("Seleziona operazione:", options,9 );
	

		switch(op) {
			case '1':
				visualizzaClientiFunzionario(conn);
				break;
			
			case '2':
				visualizzaClienteSingolo(conn);
				break;	

			case '3':
				visualizzaNota(conn);
				break;

			case '4':
				visualizzaAppuntamento(conn);
				break;

			case '5':
				gestioneNota(conn);
				break;
				
			case '6':
				inserisciAppuntamento(conn);
				break;
				
			case '7':
				comunicaPropostaReale(conn);
				break;
			
			case '8':
				esitoAppuntamento(conn);
				break;
				
	
			case '0':
				return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}
