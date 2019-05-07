%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    
    void yyerror(const char *);
    
%}

            
%x comment


%%
  /* WRITEME: Write your Flex token rules here */
  
"+"                     { return T_PLUS; }
"-"                     { return T_MINUS; }
"\*"                    { return T_MULTIPLY; }
"/"                     { return T_DIVIDE; }
">"                     { return T_GT; }
">="                    { return T_GTEQ; }
"\("                    { return T_LPAR; }
"\)"                    { return T_RPAR; }
"{"                     { return T_LBRA; }
"}"                     { return T_RBRA; }
"->"                    { return T_type; }
";"                     { return T_SEMICOLON; }
"="                     { return T_ASSIGN; }
"\."                    { return T_DOT; }
","                     { return T_COMMA; }
"\n"                    {}
"/*"                    BEGIN(comment);

<comment>[^*\n]*        
<comment>"*"+[^*/\n]*   

<comment>\n         //
<comment><<EOF>>        { 
                            yyerror("Comment left unclosed"); 
                        }
<comment>"*"+"/"        BEGIN(INITIAL);

"if"                    { return T_IF; }
"else"                  { return T_ELSE; }
"while"                 { return T_WHILE; }
"do"                    { return T_DO; }
"print"                 { return T_PRINT; }
"return"                { return T_RETURN; }
"integer"               { return T_INTEGER; }
"boolean"               { return T_BOOLEAN; }
"none"                  { return T_NONE; }
"true"                  { return T_TRUE; }
"false"                 { return T_FALSE; }
"new"                   { return T_NEW; }
"extends"               { return T_EXTENDS; }
"equals"                { return T_EQUALS; }
"and"                   { return T_AND; }
"or"                    { return T_OR; }
"not"                   { return T_NOT; }

0|[1-9][0-9]*           { return T_INT; }
[a-zA-Z][a-zA-Z0-9]*    { return  T_IDENTIFIER; }

[ \t\f\v\r]+            {}

.                       { yyerror("invalid character"); }


%%

int yywrap(void) {
  return 1;
}