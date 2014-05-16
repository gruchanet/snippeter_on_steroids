#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

#define T 3 // stopien B-drzewa (min. ilosc kluczy to t-1, max. 2t-1, ilosc wskaznikow 2t)

typedef enum {FALSE, TRUE} boolean;
typedef enum {ROOT, NODE} nodeType;
typedef struct {
	short n;        // ilosc kluczy (-1 -> wezel usuniety)
	int k[2*T-1];   // klucze
	int c[2*T];     // wskazniki do synow (pozycje w pliku: 0,1,2 ...) (c[0] = -1 == aktualny wezel to lisc)
} Node;
int nodeSize = sizeof(Node); // rozmiar wezla w bajtach
FILE *treeFile;  // plik drzewa (zawierajacy wezly)
// FILE *stackFile; // plik stosu (zawierajacy wolne pozycje)
int rootPos = -1; // pozycja korzenia
int nextPos = 0; // nastepna wolna pozycja // ew. zapisywanie info. do pliku o nastepnej wolnej pozycji

int getNode(unsigned long int i, Node *node) {
	fseek(treeFile, i*nodeSize+(sizeof(int)), SEEK_SET);
	return (ftell(treeFile)-sizeof(int))/nodeSize; // zwraca pozycje wezla
}

int saveNode(unsigned long int i, Node *node) {
	fseek(treeFile, i*nodeSize+(sizeof(int)), SEEK_SET);
	fwrite(node, nodeSize, 1, treeFile);
	
	return getNode(i, node);
}

int readNode(unsigned long int i, Node *node) {
	fseek(treeFile, i*nodeSize+(sizeof(int)), SEEK_SET);
	fread(node, nodeSize, 1, treeFile);
	
	return getNode(i, node);
}

void saveRoot() {
	fseek(treeFile, 0, SEEK_SET);
	fwrite(&rootPos, (sizeof(int)), 1, treeFile);
}

void readRoot() {
	fseek(treeFile, 0, SEEK_SET);
	fread(&rootPos, (sizeof(int)), 1, treeFile);
}

/* restrukturyzacja (rozbijanie wezla) */
void nodeSplit(Node mainNode, Node childNode, int i, nodeType nType, int mainPos, int childPos) {
	Node anotherNode;
	int j;
	
	if (childNode.c[0] == -1)
		anotherNode.c[0] = childNode.c[0];
	anotherNode.n = T-1;
	
	for (j=0; j<T-1; j++)
		anotherNode.k[j] = childNode.k[j+T];
	
	if (childNode.c[0] != -1)
		for (j=0; j<T; j++)
			anotherNode.c[j] = childNode.c[j+T];
			
	childNode.n = T-1;
	
	for (j=mainNode.n; j>i; j--)
		mainNode.k[j] = mainNode.k[j-1];
		
	mainNode.k[i] = childNode.k[T-1];
	
	for (j=mainNode.n+1; j>i+1; j--)
		mainNode.c[j] = mainNode.c[j-1];
	
	mainNode.n++;

	saveNode(childPos, &childNode);
	saveNode(nextPos, &anotherNode);
	mainNode.c[i+1] = nextPos++;
	
	if (nType == ROOT)
		saveNode(nextPos, &mainNode); // nowy korzen
	else if (nType == NODE)
		saveNode(mainPos, &mainNode);
}

void insertValue(Node node, int nodePos, int value) {
	int i = 0;
	
	if (node.c[0] == -1) { // lisc
		i = node.n;
		while (i >= 1 && value < node.k[i-1]) {
			node.k[i] = node.k[i-1];
			i--;
		}
		node.k[i] = value;
		node.n++;
		saveNode(nodePos, &node);
	}
	else { // wezel wewn.
		Node temp;
		int tempPos;
		for (i=0; i<node.n; i++) // szukanie miejsca na wezel miedzy kluczami (przejscie do syna)
			if (value < node.k[i])
				tempPos = readNode(node.c[i], &temp);
		if (value >= node.k[i-1])
			tempPos = readNode(node.c[i], &temp);
		if (temp.n == 2*T-1) { // czy wezel-syn jest pelny?
			nodeSplit(node, temp, i, NODE, nodePos, tempPos);
			readNode(nodePos, &node);
			insertValue(node, nodePos, value);
			return;
		}
		insertValue(temp, tempPos, value);
	}
}

void insert(int value) {
	Node root;

	if (rootPos == -1) { // drzewo puste -> tworzenie korzenia
		root.n = 1; root.k[0] = value; root.c[0] = -1;
		rootPos = saveNode(0, &root);
		nextPos = rootPos + 1;
		saveRoot();
	}
	else { // drzewo niepuste
		readNode(rootPos, &root);
		if (root.n == 2*T-1) { // czy korzen jest pelny?
			Node newRoot;
			newRoot.n = 0;
			newRoot.c[0] = rootPos;
			nodeSplit(newRoot, root, 0, ROOT, 0, rootPos);
			rootPos = nextPos++;
			saveRoot();
			readNode(rootPos, &root);
		}
		insertValue(root, rootPos, value);
	}
}

void drukujB(int r, int p) {
	// drukuje B-drzewo o korzeniu r (pozycja w pliku)
	// wydruk przesuniety o p w prawo
	Node w;
	int i, j;
	readNode(r,&w);
	if (w.c[0] == -1) {
		for (i=0;i<p;i++)
			printf(" ");
		for (i=0;i<w.n;i++)
			printf("%d ",w.k[i]);
		printf("\n");
	} 
	else {
		drukujB(w.c[w.n],p+4);
		for (i=w.n-1;i>=0;i--){
			for (j=0;j<p;j++)
				printf(" ");
			printf("%d\n",w.k[i]);
			drukujB(w.c[i],p+4);
		}
	}
}

/* testowe wypisywanie danych z pliku */
void printFile() {
	int i, j;
	Node temp;
	
	readRoot();
	printf("rootPos: %i\n\n", rootPos);
	for (i=0; i<nextPos; i++) {
		readNode(i, &temp);
		printf("__Node #%i of pos__\n", i);
		printf("node.n: %i\n", temp.n);
		for (j=0; j<2*T-1; j++)
			printf("node.k[%i]: %i\n", j, temp.k[j]);
		for (j=0; j<2*T; j++)
			printf("node.c[%i]: %i\n", j, temp.c[j]);
		puts("");
	}
}

int main() {
	int menu, value;
	treeFile = fopen("b-tree.bt", "w+");
	
	while (TRUE) {
		system("cls");
		printf("\t\t__MENU__\n");
		printf("\t1 - Dopisz nowa wartosc do drzewa\n");
		printf("\t3 - Wyswietl drzewo\n");
		printf("\t[TEST] 4 - Wyswietl dane z pliku\n");
		printf("\t0 - Zakonczenie programu\n\n");
		printf("Co wybierasz? ");
		scanf("%i", &menu);
		
		switch (menu) {
			case 1:
				printf("Podaj wartosc, ktora chcesz wprowadzic do drzewa: ");
				scanf("%i", &value);
				insert(value);
				getch();
				break;
			case 3:
				drukujB(rootPos, 0);
				getch();
				break;
			case 4:
				printFile();
				getch();
				break;
			case 0:
				exit(0);
				break;
			default:
				printf("Blad: Niepoprawny wybor z menu. Sprobuj ponownie!");
				getch();
				break;
		}
	}
	
	fclose(treeFile);
	return 0;
}