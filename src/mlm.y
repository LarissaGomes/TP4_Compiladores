%{
	#include <ctype.h>
	#include <stdio.h>
	#include <string.h>
	#include "tabelasimbolos.h"

	void yyerror();
	int yylex();

	char i_code[1000][30]; 
	char vars[100][10]; 
	char aux[10];
	char tipo_var[10];
	int len_i_code;
	int count;
	char* buff;
	int next_quad;

	void genCode(char *s);
	void printThreeAddressCode();
%}

%token IF
%token LOOP_STMT
%token THEN
%token UNTIL
%token END
%token WHILE
%token READ
%token WRITE
%token ELSE
%token PONTO_VIRGULA
%token DOIS_PONTOS
%token VIRGULA
%token ASSIGN
%token ABRE_PAR
%token FECHA_PAR
%token BEGIN_T
%token TYPE
%token UNSIGNED_INTEGER
%token UNSIGNED_REAL
%token BOOLEAN_CONSTANT
%token CHAR_CONSTANT
%token ID
%token RELOP
%token ADDOP
%token MULOP            
%token NOT
%token PROGRAM

%union {
    union {
        int integer;
        float real;
    } number;

    short boolean;
    char*  name;
}


%type <name> decl_list decl ident_list program compound_stmt stmt_list stmt assign_stmt read_stmt write_stmt expr_list
%type <name> WHILE BEGIN_T ELSE WRITE READ END UNTIL THEN LOOP_STMT IF 
%type <name> simple_expr term;
%type <name> expr;
%type <name> UNSIGNED_INTEGER;
%type <name> UNSIGNED_REAL;
%type <name> CHAR_CONSTANT;
%type <name> FECHA_PAR ABRE_PAR ASSIGN VIRGULA DOIS_PONTOS PONTO_VIRGULA PROGRAM NOT MULOP ADDOP RELOP TYPE
%type <name> ID;
%type <boolean> BOOLEAN_CONSTANT;

%right THEN ELSE
%define parse.error verbose

%%

program  			:PROGRAM ID PONTO_VIRGULA decl_list compound_stmt { }
					;

decl_list 			:decl_list PONTO_VIRGULA decl { }
					|decl {  }
					;

decl   				:ident_list DOIS_PONTOS TYPE { 
								$$ = $3;
								Tipo t;
								int primeira_var_declarada=0;
								char *str = $$; 
								strcpy(tipo_var,$3);

								for(int i=0; i<count; i++){
									if(Get_Entry(vars[i])==0){
										if(primeira_var_declarada==0){
											Entrada_Bloco();
											primeira_var_declarada=1;
										}
										Instala(vars[i], tipo_var, t); 
										char *s = vars[i];
										char *str = "storage, ";
										int size = strlen(str)  + strlen(s) + 1; 
										char* buff = (char *)malloc(size);
										strcat(buff, s);
										strcat(buff, ", ");
										strcat(buff, str);
										strcat(buff, ", 4, 0");
										genCode(buff);
									}
									else{
										printf("Erro, variável %s já declarada anteriormente!", vars[i]);
								
									}
								}

								count=0;
								 }
					;

ident_list 			:ident_list VIRGULA ID { Tipo t;
							$$ = $3;
							char *str = $$;
							
							for(int i=0; i<=strlen(str); i++){
								vars[count][i]=str[i];
							}
							count++;
							

							 }
					|ID { 
							Tipo t;
							$$ = $1;
							char *str = $$;
							for(int i=0; i<=strlen(str); i++){
								vars[count][i]=str[i];
							}
							count++;

						}
					;

ident_list 				:TYPE { 
								$$ = $1;
								char *str = $$;
								strcpy(tipo_var,$1);	
							  }
					;

compound_stmt 		:BEGIN_T stmt_list END {  }
					;

stmt_list 			:stmt_list PONTO_VIRGULA stmt {  }
					|stmt {  }
					;

stmt 				:assign_stmt {  }
					|if_stmt {  }
					|loop_stmt {  }
					|read_stmt {  }
					|write_stmt {  }
					|compound_stmt {  }
					;

assign_stmt			:ID ASSIGN expr { 
										if(Get_Entry($1)==0){
											printf("Erro, variável %s não foi declarada!", $1);
										}
										else{
											char *s = $1;
											strcat(aux, s);
										 }
									}
					;

if_stmt				:IF cond THEN stmt {  }
					|IF cond THEN stmt ELSE stmt {  }
					;

cond 				:expr {  }
					;

loop_stmt			:stmt_prefix LOOP_STMT stmt_list stmt_suffix {  }
					;

stmt_prefix			:WHILE cond {  }
					|  { }
					;

stmt_suffix			:UNTIL cond {  }
					|END {  }
					;

read_stmt			:READ ABRE_PAR ident_list FECHA_PAR { 
															$$ = $1;
															char *str = $3;
															char *s = $1;
															int size = strlen(str)  + strlen(s) + 1; 
															char* buff = (char *)malloc(size);
															strcat(buff, s);
															strcat(buff, ", ");
															strcat(buff, str);
															strcat(buff, ", 0, 0");
															genCode(buff);		
														}
					;

write_stmt			:WRITE ABRE_PAR expr_list FECHA_PAR { 
															$$ = $1;
															char *str = $3;
															char *s = $1;
															int size = strlen(str)  + strlen(s) + 1; 
															char* buff = (char *)malloc(size);
															strcat(buff, s);
															strcat(buff, ", ");
															strcat(buff, str);
															strcat(buff, ", 0, 0");
															genCode(buff);	
														}
					;

expr_list 			:expr {  }
					|expr_list VIRGULA expr {  }
					;

expr 				:simple_expr { }
					|simple_expr RELOP simple_expr { }
					;

simple_expr			:term {  }
					|simple_expr   ADDOP   term { 			

															//printf("TESTE %s", aux);
															char *s = $1;
															char *s2 = $3;
															int size = strlen(s2)  + strlen(s) + 1; 
															char* buff = (char *)malloc(size);
															strcat(buff, "+, ");
															strcat(buff, s);
															strcat(buff, ", ");
															strcat(buff, s2);
															strcat(buff, ", ");
															strcat(buff, s);
															genCode(buff);
											
												}
					;

factor 				:ID  { 
										if(Get_Entry($1)==0){
											printf("Erro, variável %s não foi declarada!", $1);
										}
										else{

										 }
									}
					|constant {  }
					|ABRE_PAR expr FECHA_PAR {  }
					|NOT factor {  }
					;

factor_a			:"-" factor {  }
					|factor {  }
					;

term				:factor_a {  }
					|term   MULOP   factor_a {  }
					;

constant 			:UNSIGNED_INTEGER {  }
					|UNSIGNED_REAL {  }
					|CHAR_CONSTANT {  }
					|BOOLEAN_CONSTANT {  }
					;


%%
void yyerror(char *c){ 
    printf("Meu erro foi: %s\n",c); 
} 
 
int main(int argc, char **argv) { 
	count=0;
	len_i_code=0;
	next_quad=0;
	strcpy(tipo_var,"VAZIO");
	Tipo t; 
	//L=1;				// Considera-se que a primeira posicao da tabela e' a de indice 0 
						// L e' o final da arvore binaria
	//Raiz=0;		
	//nivel=1;			// 0 o primeiro nivel, o 1
	//escopo[nivel]=1;	// escopo[1] contem o indice do primeiro elemento
	

    yyparse();  
    imprimir();
    printThreeAddressCode();
    return 0;  
}

void genCode(char *s) {
	for(int i=0; i<strlen(s); i++){
		i_code[len_i_code][i]=s[i];
	}
	len_i_code++;
	next_quad++;
}

void printThreeAddressCode() {
	int i = 0;
	for(int i=0; i < len_i_code; i++) {
		printf("<%s> \n", i_code[i]);
	}
}
