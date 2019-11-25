	/*Implementação do Analisador Léxico usando a ferramenta Lex e linguagem C*/
%{
	#include <string.h>
	#include "mlm.tab.h"
%}

letra 				[a-zA-Z] 
digito 				[0-9]
identifier			{letra}({letra}|{digito})*
unsigned_integer 	{digito}{digito}*
sinal 				(\+|\−)
scale_factor 		E{sinal}?{unsigned_integer}
integer_constant 	{unsigned_integer}
real_constant 		{unsigned_real}
unsigned_real 		{unsigned_integer}(\.{digito}+)?{scale_factor}?
char_constant       '.'
tipo                integer|char|boolean|float
relop               <|<=|=|>|>=|!=
addop               \+|-
mulop               \*|\/
ws                  [ \t\n]     

%%
{ws}            	{}

OR 					{ 
   yylval.name = strdup(yytext);
   return ADDOP;
   }
NOT					{ 
   yylval.name = strdup(yytext);
   return NOT;
}
AND 				{ 
   yylval.name = strdup(yytext);
   return MULOP;
}
DIV 				{ 
   yylval.name = strdup(yytext);
   return MULOP;
}
MOD					{ 
   yylval.name = strdup(yytext);
   return MULOP;
}
false				{ 
   yylval.name = strdup(yytext);
   return BOOLEAN_CONSTANT;
}
true				{ 
   yylval.name = strdup(yytext);
   return BOOLEAN_CONSTANT;
}
if 					{ 
   yylval.name = strdup(yytext);
   return IF;
}
write          		{ 
   yylval.name = strdup(yytext);
   return WRITE;
}
read          		{ 
   yylval.name = strdup(yytext);
   return READ;
}
until          		{ 
   yylval.name = strdup(yytext);
   return UNTIL;
}
while          		{ 
   yylval.name = strdup(yytext);
   return WHILE;
}
do          		{ 
   yylval.name = strdup(yytext);
   return LOOP_STMT;
}
then          		{ 
   yylval.name = strdup(yytext);
   return THEN;
}
else          		{ 
   yylval.name = strdup(yytext);
   return ELSE;
}
program          	{ 
   yylval.name = strdup(yytext);
   return PROGRAM;
}
":="          		{ 
   yylval.name = strdup(yytext);
   return ASSIGN;
}
","          		{ 
   yylval.name = strdup(yytext);
   return VIRGULA;
}
";"					{ 
   yylval.name = strdup(yytext);
   return PONTO_VIRGULA;
}
":"					{ 
   yylval.name = strdup(yytext);
   return DOIS_PONTOS;
}
"("					{ 
   yylval.name = strdup(yytext);
   return ABRE_PAR;
}
")" 				{ 
   yylval.name = strdup(yytext);
   return FECHA_PAR;
}
begin				{ 
   yylval.name = strdup(yytext);
   return BEGIN_T;
}
end   				{ 
   yylval.name = strdup(yytext);
   return END;
}
{tipo} 		    	{ 
   yylval.name = strdup(yytext);
   return TYPE;
}
{unsigned_integer}  { 
   yylval.name = strdup(yytext);
   return UNSIGNED_INTEGER;
   }
{unsigned_real} 	{ 
   yylval.name = strdup(yytext);
   return UNSIGNED_REAL;
   }
{char_constant}		{ 
   yylval.name = strdup(yytext);
   return CHAR_CONSTANT;
   }
{identifier}		{ 
   yylval.name = strdup(yytext);
   return ID;
   }
{relop}				{ 
   yylval.name = strdup(yytext);
   return RELOP;
   }
{addop}				{ 
   yylval.name = strdup(yytext);
   return ADDOP;
}
{mulop}				{ 
   yylval.name = strdup(yytext);
   return MULOP;
   }

%%
int yywrap(){
	return 1;
}
