#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

//Con questa funzione creo una nuova proposta
static void creaProposta(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[3];

	char codice[15];
	char descrizione[150];
	
	char giorno[3];
	char mese[3];
	char anno[5];
	
	MYSQL_TIME scadenza;
	memset(&scadenza,0, sizeof(scadenza));
	
	
	printf("\n>> Inserimento nuova proposta <<\n\n");
	printf("\nNome Proposta: ");
	getInput(10, codice, false);
	printf("Descrizione: ");
	getInput(150, descrizione, false);

	
	printf("\n >> Data di scadenza <<\n\n");
	printf("* Giorno: ");
	getInput(3, giorno, false);
	printf("* Mese (numerico): ");
	getInput(3, mese, false);
	printf("* Anno: ");
	getInput(5, anno, false);
	printf("\n");
	
	scadenza.year = atoi(anno);
	scadenza.month = atoi(mese);
	scadenza.day = atoi(giorno);


	if(!setup_prepared_stmt(&prepared_stmt, "call inserisciProposta(?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'Crea Proposta'.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = codice;
	param[0].buffer_length = strlen(codice);
	
	param[1].buffer_type = MYSQL_TYPE_DATE;
	param[1].buffer = &scadenza;
	param[1].buffer_length = sizeof(scadenza);
	
	
	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = descrizione;
	param[2].buffer_length = strlen(descrizione);	
	

	

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'CreaProposta'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "Errore nella creazione di una nuova proposta.Premi 'invio' per tornare al menu.\n");
	}else{
		printf("\nNuova proposta aggiunta correttamente!\nPremi 'invio' per tornare al menu.");
	}

	mysql_stmt_close(prepared_stmt);

}

static void aggiungiFunzionario(MYSQL *conn)
{
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[5];

	// Input for the registration routine

	char nome[30];
	char cognome[30];


	// Get the required information

	printf("\n >> Aggiungi funzionario <<\n\n");
	printf("Nome: ");
	getInput(30, nome, false);
	printf("Cognome: ");
	getInput(30, cognome, false);

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call inserisciFunzionario(?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'aggiungiFunzionario'\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));


	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = nome;
	param[0].buffer_length = strlen(nome);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = cognome;
	param[1].buffer_length = strlen(cognome);	


	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per 'aggiungiFunzionario'\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'aggiunta di un nuovo funzionario\n");
	} else {
		printf("\nNuovo funzionario aggiunto.\nPremi 'invio' per tornare al menu.");
	}

	mysql_stmt_close(prepared_stmt);
}


void run_manager(MYSQL *conn)
{
	char options[3] = {'1','2', '0'};
	char op;
	
	printf("Eseguo come 'Manager'...\n");

	if(!parse_config("users/manager.json", &conf)) {
		fprintf(stderr, "Errore nel parsing per l'utente 'manager'\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf(">> Lista operazioni disponibili <<\n\n");
		printf("1) Crea una nuova proposta.\n");
		printf("2) Aggiungi funzionario. \n");
		printf("0) Esci\n");

		op = multiChoice("Seleziona operazione:", options, 3);

		switch(op) {
			case '1':
				creaProposta(conn);
				break;
			
			case '2':
				aggiungiFunzionario(conn);
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
