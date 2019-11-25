#ifndef TABELASIMBOLOS_H
#define TABELASIMBOLOS_H


typedef enum Tipo {
    _int, _real, _bool, _char
} Tipo;

int escopo [10];
int nivel; 				// Inteiro que contem o numero do item atual
int L; 					// Inteiro que contem o indice do ultimo elemento da Tabela de Simbolos

int Raiz;				// Inteiro que contem o indice do primeiro elemento da Tabela de Simbolos

struct {
	char nome[10];		// Contem o nome do simbolo
	int nivel;			// Contem o nivel do simbolo relacionado
	char atributo[10];	// Contem o atributo do relacionado
	Tipo tipo;
} TabelaS [100];			// Vetor de struct que contem a tabela de simbolos



void Entrada_Bloco(void);
void Erro (int numero);
void Saida_Bloco(void);
int Get_Entry(char name[10]);
void Instala(char name[10], char atributo[10], Tipo tipo);
void imprimir(void);

#endif