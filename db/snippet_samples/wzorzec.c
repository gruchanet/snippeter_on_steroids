/*  Program obsluguje pliki o wielkosci <= 1MB
 *	Jako I argument podajemy nazwe pliku, na ktorym chcemy wykonac operacje wyszukania wzorca.
 *	Jako II argument podajemy wzorzec, ktorego chcemy poszukac w tekscie. Domyslnie wzorzec jest ustawiony na sztywno
 *		dla pliku "tekst.txt"
 *
 *	info. dodatkowe:
 *	(instrukcja == NULL) == !instrukcja
 */

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include <time.h>

#define ASCII 256 // quantity of ascii characters
#define PRIME 1009 // eg. 101, 1009, etc.
#define E_SIZE 65536
#define L_SIZE 1024
#define F_SIZE 1048576 // file size, up to 1MB
#define SPECIAL_SIZE 1048576

typedef char* string;
typedef enum {FALSE, TRUE} boolean;

FILE *file;
string text;
int textLength;
int fileEncounter[SPECIAL_SIZE] = {0};
int encounters = 0;

boolean emptyFile() {
	fseek(file, 0, SEEK_END);
		if (ftell(file) == 0)
			return TRUE;
	fseek(file, 0, SEEK_SET);
	return FALSE;
}

string getFile() {
	int i = 0;
	string str = malloc(F_SIZE*sizeof(string));
	string buffer = malloc(L_SIZE*sizeof(string));

	while (feof(file) == 0) {
		fscanf(file, "%s\n", buffer);
		strcpy(str+i, buffer);
		i += strlen(buffer);
	}

	return str;
}

void naiveAlgorithm(string pattern, int patternLength) {
	int i;
	string temp = malloc(patternLength*sizeof(string));
	temp[patternLength] = '\0';

	for (i=0; i<=textLength-patternLength; i++) {
		if (strcmp(strncpy(temp, text+i, patternLength), pattern) == 0)
			fileEncounter[encounters++] = i;
	}
}

void KMPAlgorithm(string pattern, int patternLength) {
	int KMPNext[patternLength+1], i, b;

	KMPNext[0] = b = -1;
	for (i=1; i<=patternLength; i++) {
		while ((b > -1) && (pattern[b] != pattern[i - 1]))
			b = KMPNext[b];
		++b;
		if ((i == patternLength) || (pattern[i] != pattern[b]))
			KMPNext[i] = b;
		else
			KMPNext[i] = KMPNext[b];
	}

	b = 0;
	for (i=0; i<textLength; i++) {
		while ((b > -1) && (pattern[b] != text[i]))
			b = KMPNext[b];
		if (++b == patternLength) {
			fileEncounter[encounters++] = i-b+1;
			b = KMPNext[b];
		}
	}
}

void RKAlgorithm(string pattern, int patternLength) {
	int hash = 1, hashPattern = 0, hashText = 0, i;
	string temp = malloc(patternLength*sizeof(string));

	for (i=0; i<patternLength-1; i++) {
		hash = (hash*ASCII)%PRIME;
		hashPattern = (hashPattern*ASCII + pattern[i])%PRIME;
		hashText = (hashText*ASCII + text[i])%PRIME;
	}
	hashPattern = (hashPattern*ASCII + pattern[patternLength-1])%PRIME;
	hashText = (hashText*ASCII + text[patternLength-1])%PRIME;

	for (i=0; i<textLength-patternLength; i++) {
		if ((hashPattern == hashText) && (strcmp(strncpy(temp, text+i, patternLength), pattern) == 0))
			fileEncounter[encounters++] = i;
		hashText = (ASCII*(hashText - text[i]*hash) + text[i+patternLength])%PRIME;
		if (hashText < 0)
			hashText += PRIME;
	}
}

void FSMAlgorithm(string pattern, int patternLength) { // alphabet: acgt
	int FAMNext[L_SIZE][ASCII] = {{0}}, i, j;
	int getNextState(int state, int charNO) {
		if (state < patternLength && charNO == pattern[state])
			return state+1;

		int ps, i; // ps = (prefix == sufix)

		for (ps=state; ps>0; ps--)
			if (pattern[ps-1] == charNO) {
				for (i=0; i<ps-1; i++)
					if (pattern[i] != pattern[state-ps+i+1])
						break;
				if (i == ps-1)
					return ps;
			}

		return 0;
	}

	for (i=0; i<=patternLength; ++i)
		for (j=0; j<ASCII; ++j)
			FAMNext[i][j] = getNextState(i, j);

	j = 0;
	for (i=0; i<textLength; i++) {
		j = FAMNext[j][(int)text[i]];
		if (j == patternLength)
			fileEncounter[encounters++] = i-patternLength+1;
    }
}

void KMPAlgorithm_modified(string pattern, int patternLength) {
	int KMPNext[patternLength+1], i, b;

	KMPNext[0] = b = -1;
	for (i=1; i<=patternLength; i++) {
		while ((b > -1) && (pattern[b] != pattern[i - 1]))
			b = KMPNext[b];
		++b;
		if ((i == patternLength) || (pattern[i] != pattern[b]))
			KMPNext[i] = b;
		else
			KMPNext[i] = KMPNext[b];
	}

	b = 0;
	for (i=0; i<textLength; i++) {
		while ((b > -1) && (pattern[b] != text[i] && text[i] != '?'))
			b = KMPNext[b];
		if (++b == patternLength) {
			fileEncounter[encounters++] = i-b+1;
			b = KMPNext[b];
		}
	}
}

void printEncounters(string pattern, int patternLength) {
	int i;

	if (encounters > 0) {
		printf("\nWzorzec \"%s\" znaleziono w sumie %i raz(y), w miejscach: \n", pattern, encounters);
		for (i=0; i<encounters; i++)
			printf("\t* %i\n", fileEncounter[i]);
	}
	else
		printf("\nWzorzec \"%s\" nie zostal znaleziony w zadnym miejscu.\n", pattern);
	encounters = 0;
}

int main(int argc, char *argv[]) {
	if ((file = fopen(argv[1], "r+")) == NULL) {
		fprintf(stderr, "Blad: Nie mozna otworzyc pliku o nazwie \"%s\"!\n", argv[1]);
		exit(1);
	}
	text = getFile();
	textLength = strlen(text);
	if (emptyFile() == TRUE) {
		fprintf(stderr, "Blad: Plik \"%s\" jest pusty!\n", argv[1]);
		exit(1);
	}
	string pattern = argv[2];
	if (pattern == NULL)
		pattern = "cggtagcggcgggggggagggcggtgggggcgagccggac"; // default pattern
	int mainMenu, subMenu;
	int patternLength = strlen(pattern);
	if (patternLength > textLength) {
		fprintf(stderr, "Blad: Dlugosc wzorca jest wieksza od dlugosci tekstu w pliku!\n");
		exit(1);
	}

	clock_t start, stop;
	double naiveDuration, KMPDuration, RKDuration, FSMDuration;

	while (TRUE) {
		system("cls");
		// printf("text: %s\ntextLength: %i\npattern: %s\npatternLength: %i\n", text, textLength, pattern, patternLength);
		printf("\t\t__MENU__\n");
		printf("\t1 - Wykonaj wyszukiwanie wzorca dla wszystkich algorytmow\n\t    i przedstaw ich czasy wykonania.\n");
		printf("\t2 - Wykonaj wyszukiwanie wzorca dla okreslonego algorytmu.\n");
		printf("\t0 - Zakonczenie programu\n\n");
		printf("Co wybierasz? ");
		scanf("%i", &mainMenu);

		switch (mainMenu) {
			case 1:
				start = clock();
				naiveAlgorithm(pattern, patternLength);
				stop = clock();
				naiveDuration = (double)(stop-start)/CLOCKS_PER_SEC;
				start = clock();
				KMPAlgorithm(pattern, patternLength);
				stop = clock();
				KMPDuration = (double)(stop-start)/CLOCKS_PER_SEC;
				if (strcmp(argv[1], "tekst.txt") == 0) {
					start = clock();
					RKAlgorithm(pattern, patternLength);
					stop = clock();
					RKDuration = (double)(stop-start)/CLOCKS_PER_SEC;
				}
					start = clock();
					FSMAlgorithm(pattern, patternLength);
					stop = clock();
					FSMDuration = (double)(stop-start)/CLOCKS_PER_SEC;
				printf("Czasy wykonania algorytmow: \n");
				printf("\t- naiwny algorytm: %2.5f\n", naiveDuration);
				printf("\t- algorytm KMP: %2.5f\n", KMPDuration);
				if (strcmp(argv[1], "tekst.txt") == 0)
					printf("\t- algorytm RK: %2.5f\n", RKDuration);
				printf("\t- algorytm FSM: %2.5f\n", FSMDuration);
				encounters = 0;
				getch();
				break;
			case 2:
				system("cls");
				printf("Algorytmy:\n");
				printf("\t1 - naiwny algorytm (oczywisty)\n");
				printf("\t2 - algorytm Knutha-Morrisa-Pratta\n");
				if (strcmp(argv[1], "tekst.txt") == 0)
					printf("\t3 - algorytm Rabina-Karpa\n");
				printf("\t4 - algorytm wykorzystujacy automat skonczony\n");
				printf("\t5 - zmodyfikowany algorytm Knutha-Morrisa-Pratta ('?')\n");
				printf("\t0 - poprzednie menu\nTwoj wybor: ");
				scanf("%i", &subMenu);

				switch (subMenu) {
					case 1:
						naiveAlgorithm(pattern, patternLength);
						break;
					case 2:
						KMPAlgorithm(pattern, patternLength);
						break;
					case 3:
						if (strcmp(argv[1], "tekst.txt") == 0)
							RKAlgorithm(pattern, patternLength);
						else {
							fprintf(stderr, "Blad: Algorytm Rabina-Karpa jest dostepny tylko dla pliku \"tekst.txt\"!");
							getch();
						}
						break;
					case 4:
						FSMAlgorithm(pattern, patternLength);
						break;
					case 5:
						KMPAlgorithm_modified(pattern, patternLength);
						break;
					case 0:
						break;
					default:
						fprintf(stderr, "Blad: Niepoprawny wybor algorytmu.");
						getch();
						break;
				}
				if (subMenu >= 1 && subMenu <= 5) {
					printEncounters(pattern, patternLength);
					getch();
				}
				break;
			case 0:
				fclose(file);
				exit(0);
				break;
			default:
				fprintf(stderr, "Blad: Niepoprawny wybor z menu. Sprobuj ponownie!");
				getch();
				break;
		}
	}

	return 0;
}