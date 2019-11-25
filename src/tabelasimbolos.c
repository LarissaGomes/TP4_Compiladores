#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "tabelasimbolos.h"

#define NMAX 1000 		// Numero máximo de itens possiveis

/*void main(void){
	L=1;				// Considera-se que a primeira posicao da tabela e' a de indice 0 
						// L e' o final da arvore binaria
	Raiz=0;		
	nivel=1;			// 0 o primeiro nivel, o 1
	escopo[nivel]=1;	// escopo[1] contem o indice do primeiro elemento
	Entrada_Bloco();
	Get_Entry("oi");
	Instala("teste", "string");
	imprimir();
	Saida_Bloco();
}*/

// Implementações

/*
	Função que define os erros provaveis de acontecer
*/
void Erro(int num){
	char opcao;
	switch(num){
		case 1:
			printf("Tabela de Simbolos cheia!\n");
			break;
		case 2:
			printf("Este item nao foi encontrado!\n");
			break;
		case 3:
			printf("Este item ja foi inserido!\n");
			break;
	}
}

/*
	Função de entrada num bloco
*/
void Entrada_Bloco(){
	nivel++;
	if(nivel>NMAX){
		Erro(1);
	}
	else{
		escopo[nivel]=L;
	}
}

/*
	Função de saida num bloco
*/
void Saida_Bloco(){
	L=escopo[nivel];
	nivel--;
}

/*
	Função que pesquisa item na tabela:
		Pesquisa o simbolo "x" e retorna o indice da Tabela de simbolos
		onde ele se encontra
*/
int Get_Entry(char x[10]){
	int K, achou, aux, Esquerda, Direita;
	Esquerda=1;
	Direita=L;
	achou=0;
	while((Esquerda<=Direita)&&(achou==0)){
		K=((Esquerda+Direita)/2);
		aux=strcasecmp(x,TabelaS[K].nome);
		if(aux==0){
			achou=1;
		}
		else{
			if(aux<0){
				Direita=K-1;
			}
			else{
				Esquerda=K+1;
			}
		}
	}
	if(achou==1){
		//printf("O item esta no nivel %d", TabelaS[K].nivel);
		//printf("					Indice %u\n", K);
		return 1;
	}
	else{
		//Erro(2); 
		return 0;
	}
}

/*
	Função que instala o item na tabela:
		Instala o simbolo "X" com o atributo de Simbolos
*/
void Instala(char X[10], char atribut[10], Tipo tipo){
	int i, j, inseriu, deuerro, k, aux;
	k=escopo[nivel];
	inseriu=0;
	deuerro=0;
	i=L;
	while((inseriu==0)&&(deuerro==0)){
		if(L==escopo[nivel]){
			inseriu=1;
			TabelaS[i].nivel=nivel;
			aux=strlen(atribut);
			for(j=0; j<=aux-1; j++){
				TabelaS[i].atributo[j]=atribut[j];
			}
			aux=strlen(X);
			for(j=0; j<=aux-1; j++){
				TabelaS[i].nome[j]=X[j];
			}
		}
		else{
			while(k<L){
				aux=strcmp(TabelaS[k].nome, X);
				if(aux==0){
					Erro(3);
					L--;
					deuerro=1;
				}
				k++;
			}
			if(deuerro==0){
				while((X<TabelaS[i-1].nome)&&(i>=escopo[nivel]+1)){
					TabelaS[i].nivel = TabelaS[i-1].nivel;
					aux=strlen(atribut);
					for(j=0; j<=aux-1; j++){
						TabelaS[i].atributo[j]=TabelaS[i-1].atributo[j];
						aux=strlen(X);
						for(j=0; j<=aux-1; j++){
							TabelaS[i].nome[j]=TabelaS[i-1].nome[j];
						}
						i--;
					}
				}

				if(L==NMAX+1){
					L--;
					Erro(1);
				}
				else{
					inseriu=1;
					TabelaS[i].nivel=nivel;
					aux=strlen(atribut);
					for(j=0; j<=aux-1; j++){
						TabelaS[i].atributo[j]=atribut[j];
					}
					aux=strlen(X);
					for(j=0; j<=aux-1; j++){
						TabelaS[i].nome[j]=X[j];
					}
				}
			}
		}
		L++;

	}
}

/*
	Função que imprime a Tabela de Simbolos
*/
void imprimir(){
	int i;
	for(i=0; i<=L-1; i++){
		printf("\nNome: %s\n", TabelaS[i].nome);
		printf("\nAtributo: %s\n", TabelaS[i].atributo);
		printf("\nNivel: %i\n", TabelaS[i].nivel);
	}
}