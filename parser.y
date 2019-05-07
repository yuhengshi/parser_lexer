%{//
    #include <cstdlib>
    #include <cstdio>
    #include <iostream>
    #define YYDEBUG 1
    int yylex(void);
    void yyerror(const char *);
%}

%error-verbose

/* WRITEME: List all your tokens here */
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE
%token T_GT T_GTEQ T_EQUALS
%token T_AND T_OR T_NOT 
%token T_LBRA T_RBRA
%token T_LPAR T_RPAR
%token T_type T_ASSIGN
%token T_DOT T_SEMICOLON T_COMMA
%token T_IF T_ELSE T_WHILE T_DO
%token T_PRINT T_RETURN T_INTEGER T_BOOLEAN
%token T_NONE T_TRUE T_FALSE
%token T_NEW T_EXTENDS
%token T_INT T_IDENTIFIER


%left T_OR
%left T_AND
%left T_GT T_GTEQ T_EQUALS
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE
%precedence T_NOT 


%%

/* WRITEME: This rule is a placeholder, since Bison requires
            at least one rule to run successfully. Replace
            this with your appropriate start rules. */
Start       :   ClassList
            ;

/* WRITME: Write your Bison grammar specification here */
ClassList   :   Class ClassList
            |   Class
            ;
Class       :   ClassName ClassBody
            |   ClassName T_EXTENDS ClassName ClassBody
            ;
            
ClassBody   :   T_LBRA MemVarList MemMethList T_RBRA
            ;

Type        :   T_INTEGER
            |   T_BOOLEAN
            |   ClassName
            ;

MemVarList  :   MemVarList VariableDec T_SEMICOLON
            |   Epsilon
            ;

MemMethList :   MethodDec MemMethList
            |   Epsilon
            ;

VariableDec :   Type VarName
            |   Type VarName VarList
            ;

VarList     :   T_COMMA VarName
            |   T_COMMA VarName VarList
            ;

Identifier  :   T_IDENTIFIER
            ;

ClassName   :   Identifier
            ;

MethodName  :   Identifier
            ;

VarName     :   Identifier
            ;
            
Expression  :   Expression T_PLUS Expression
            |   Expression T_MINUS Expression
            |   Expression T_MULTIPLY Expression
            |   Expression T_DIVIDE Expression
            |   Expression T_GT Expression
            |   Expression T_GTEQ Expression
            |   Expression T_EQUALS Expression
            |   Expression T_AND Expression
            |   Expression T_OR Expression
            |   T_NOT Expression
            |   T_MINUS Expression
            |   VarName
            |   VarName T_DOT VarName
            |   MethodCall
            |   T_LPAR Expression T_RPAR
            |   Value
            |   T_NEW ClassName
            |   T_NEW ClassName T_LPAR Arguments T_RPAR
            ;

Value       :   T_INT
            |   T_TRUE
            |   T_FALSE
            ;

MethodCall  :   MethodName T_LPAR Arguments T_RPAR T_SEMICOLON
            |   VarName T_DOT MethodName T_LPAR Arguments T_RPAR T_SEMICOLON
            ;

Arguments   :   ArgTwo
            |   Epsilon
            ;

ArgTwo      :   ArgTwo T_COMMA Expression
            |   Expression
            ;

Epsilon     :   %empty
            ;


MethodDec   :   MethodName T_LPAR Parameters T_RPAR T_type T_NONE T_LBRA MethodBod T_RBRA
            |   MethodName T_LPAR Parameters T_RPAR T_type Type T_LBRA MethodBod Return T_RBRA
            ;
            
Return      :   T_RETURN Expression T_SEMICOLON
            ;

Parameters  :   ParaList
            |   Epsilon
            ;

ParaList    :   ParaList T_COMMA Type VarName
            |   Type VarName
            ;

MethodBod   :   DeclarList StateList
            ;

DeclarList  :   DeclarList VariableDec T_SEMICOLON
            |   Epsilon
            ;
            
StateList   :   Statement StateList
            |   Epsilon
            ;

Statement   :   ASSIGN
            |   MethodCall
            |   IfElse
            |   While
            |   DoWhile
            |   Print
            ;

ASSIGN  :   VarName T_ASSIGN Expression T_SEMICOLON
            |   VarName T_DOT VarName T_ASSIGN Expression T_SEMICOLON
            ;

IfElse      :   T_IF Expression Block
            |   T_IF Expression Block T_ELSE Block
            ;
            
While       :   T_WHILE Expression Block
            ;

DoWhile     :   T_DO Block T_WHILE T_LPAR Expression T_RPAR T_SEMICOLON

Block       :   T_LBRA Statement StateList T_RBRA
            ;

Print       :   T_PRINT Expression T_SEMICOLON
            ;

%%
extern int yylineno;
void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(1);
}