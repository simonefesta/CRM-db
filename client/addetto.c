#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "defines.h"

static void inserisciCliente(MYSQL *conn){

	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[12];

	char nome[30]; 
	char cognome[30]; 
	char codiceFiscale[17];
	char partitaIva[11];
	

	char giorno[3];
	char mese[3];
	char anno[5];

	char telefono[11]; 
	char mail[50]; 
        char fax[11];
        char citta[30];
	char indirizzo[50];

	MYSQL_TIME nascita;
	memset(&nascita,0, sizeof(nascita));

	printf("\n>> Inserimento nuovo utente << \n");
	printf("\n* indica un campo obbligatorio.\nPer gli campi è possibile premere 'invio' e proseguire. \n");
	// Get the required information
	
	printf("\n >>Dati personali<<\n\n");
	printf("\n* Nome: ");
	getInput(30, nome, false);
	printf("* Cognome: ");
	getInput(30, cognome, false);
	printf("* Codice Fiscale: ");
	getInput(17, codiceFiscale, false);
	printf(" partita Iva: ");
	getInput(11, partitaIva, false);
	
	printf("\n >>Data di Nascita<<\n\n");
	printf("* Giorno: ");
	getInput(3, giorno, false);
	printf("* Mese (numerico): ");
	getInput(3, mese, false);
	printf("* Anno: ");
	getInput(5, anno, false);
	printf("\n");
	
	printf("\n >>Contatti<<\n\n");
	printf("* Mail: ");
	getInput(50, mail, false);
	printf("* Telefono: ");
	getInput(11, telefono, false);
	printf(" Fax: ");
	getInput(11, fax, false);
	
	printf("\n >>Residenza<<\n\n");
	printf("* Citta: ");
	getInput(30, citta, false);
	printf("* Indirizzo:");
	getInput(50, indirizzo, false);
	
	nascita.year = atoi(anno);
	nascita.month = atoi(mese);
	nascita.day = atoi(giorno);
	

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call inserisciCliente(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore nella preparazione della stored procedure 'inserisci Cliente'.\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));


	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[0].buffer = nome;
	param[0].buffer_length = strlen(nome);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[1].buffer = cognome;
	param[1].buffer_length = strlen(cognome);
	
	param[2].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[2].buffer = codiceFiscale;
	param[2].buffer_length = strlen(codiceFiscale);
	
	param[3].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[3].buffer = partitaIva;
	param[3].buffer_length = strlen(partitaIva);

	param[4].buffer_type = MYSQL_TYPE_DATE;
	param[4].buffer = &nascita;
	param[4].buffer_length = sizeof(nascita);
	
	//new insert
	param[5].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[5].buffer = telefono;
	param[5].buffer_length = strlen(telefono);
	
	param[6].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[6].buffer = mail;
	param[6].buffer_length = strlen(mail);
	
	//new insert
	
	param[7].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[7].buffer = fax;
	param[7].buffer_length = strlen(fax);
	

	param[8].buffer_type = MYSQL_TYPE_VAR_STRING; 		
	param[8].buffer = citta;
	param[8].buffer_length = strlen(citta);

	param[9].buffer_type = MYSQL_TYPE_VAR_STRING;
	param[9].buffer = indirizzo;
	param[9].buffer_length = strlen(indirizzo);	

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Errore di binding param per l'utente addetto.\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error (prepared_stmt, "Errore nell'inserimento del nuovo cliente.");
	} else{
		printf("\nNuovo cliente inserito con successo.\nPremi 'invio' per tornare al menu.");
	}

	mysql_stmt_close(prepared_stmt);

}



void run_addetto(MYSQL *conn)
{
	char options[2] = {'1','0'};
	char op;
	
	printf("Eseguo come addetto...\n");

	if(!parse_config("users/addetto.json", &conf)) {
		fprintf(stderr, "Errore nel parsing per l'utente 'addetto'\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf(">> Lista operazioni disponibili <<\n\n");
		printf("1) Registra un nuovo cliente\n");
		printf("0) Esci\n");

		op = multiChoice("Seleziona operazione:", options, 2);

		switch(op) {
			case '1':
				inserisciCliente(conn);
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
