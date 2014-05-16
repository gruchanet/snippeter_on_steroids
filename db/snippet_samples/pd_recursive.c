#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INF -1
#define SIZE 32
#define LENGTH 256

/* definiowane typy zmiennych */
typedef char* string;
typedef enum {FALSE, TRUE} boolean;

/* zmienne globalne */
string R[SIZE]; // tablica z LCS
int counter = 0; // licznik LCS

/* znajdowanie najwiekszej wartosci */
int max(int a, int b) {
    return (a > b)? a : b; // TRUE : FALSE
}

/* wyswietlanie tabeli LCS */
void CheckLCS(string string1, string string2, int C[strlen(string1)][strlen(string2)]) {
	int i, j;

	printf("  ");
	for (j=0; j<strlen(string2); j++)
		printf(" %2c", string2[j]);
	printf("\n");

	for (i=0; i<strlen(string1); i++) {
		for (j=0; j<strlen(string2); j++) {
			if (j == 0)
				printf("%2c", string1[i]);
			if (C[i][j] == INF)
				printf(" %2c", 510); // 0x0000221E
			else
				printf(" %2c", C[i][j]);
		}
		printf("\n");
	}
}

// wypisz najdluzszy podciag //
void PrintLCS(string string1, string string2, int C[strlen(string1)][strlen(string2)], int i, int j) {
	if (i == 0 || j == 0) return;
	if (string1[i] == string2[j]) {
		PrintLCS(string1, string2, C, i-1, j-1);
		printf("%c", string1[i]);
	}
	else if (C[i-1][j] >= C[i][j-1]) // '|'
		PrintLCS(string1, string2, C, i-1, j);
	else if (C[i-1][j] < C[i][j-1]) // '-'
		PrintLCS(string1, string2, C, i, j-1);
}

/* wypelnianie tabeli LCS */
int LCSLookup(string string1, string string2, int C[strlen(string1)][strlen(string2)], int i, int j) {
	if (C[i][j] != INF) return C[i][j]; // jesli wartosc w tablicy != oo (nieskonczonosc)
	if (string1[i] == string2[j]) // jesli znaki sa takie same
		C[i][j] = LCSLookup(string1, string2, C, i-1, j-1) + 1;
	else { // w przeciwnym wypadku wybierz wartosc maksymalna
		C[i][j] = max(LCSLookup(string1, string2, C, i-1, j), LCSLookup(string1, string2, C, i, j-1));
	}

	return C[i][j];
}

/* glowna funkcja LCS (rekursywna) */
void LCSRec(string string1, string string2) {
	int length1 = strlen(string1), length2 = strlen(string2);
	int C[length1][length2]; // tablica wypelniona liczbami
	int i, j;

	// NWP ciagu dowolnej dlugosci oraz ciagu pustego == 0 //
	for (i=0; i<length1; i++)
		C[i][0] = '0';
	for (j=1; j<length2; j++) // j=1, poniewaz dla tab[0][0] juz ustalilismy wartosc = 0
		C[0][j] = '0';

	for (i=1; i<length1; i++)
		for (j=1; j<length2; j++)
			C[i][j] = INF;

	LCSLookup(string1, string2, C, length1-1, length2-1);

	system("cls");
	CheckLCS(string1, string2, C);
	printf("\nNajdluzszy wspolny podciag:\n");
	PrintLCS(string1, string2, C, length1-1, length2-1);
	puts("\n");
	return;
}


int main() {
	string string1 = malloc(LENGTH * sizeof(string));
	string string2 = malloc(LENGTH * sizeof(string));

	printf("Podaj kolejno 2 ciagi (slowa), dla ktorych chcesz wyznaczyc ich najdluzsze\nwspolne podciagi. Ciagi oddziel za pomoca klawisza spacja/enter:\n");
	strcpy(string1, ".");
	strcpy(string2, ".");
	scanf("%s %s", string1+1, string2+1);

	LCSRec(string1, string2);

	return 0;
}