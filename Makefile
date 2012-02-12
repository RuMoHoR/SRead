NAME	= sreader

all:	$(NAME)

OBJ	= \
	main.o \
	sreadnode.o \
	sread.lex.o \
	sread.tab.o

CFLAGS	= \
	-Wall -Werror -Wextra \
	-Wmissing-declarations -Wredundant-decls \
	-Wno-unused-parameter \
	-Wcast-qual -Wcast-align \
	-Wshadow \
	-Wstrict-prototypes -Wmissing-prototypes \
	-Wbad-function-cast -Wnested-externs \
	-Wredundant-decls \
	-Wno-unused-parameter \
	-O2 -s

#	-Wunreachable-code \

SREAD	= sread.lex.c sread.lex.h sread.tab.c sread.tab.h


.SUFFIXES:  .c, .l, .y

LIBS	=

.c.o:
	gcc $(CFLAGS) -c $< -o $@

sread.lex.c sread.lex.h: sread.l sread.tab.h sreadnode.h
	lex \
		--8bit \
		--bison-locations \
		--yylineno \
		--prefix=sread_ \
		--outfile=sread.lex.c \
		--header-file=sread.lex.h \
		$<

sread.tab.c sread.tab.h: sread.y sreadnode.h
	yacc -Wall -Werror --locations --name-prefix=sread_ \
		--output=sread.tab.c --defines=sread.tab.h $<

#--reentrant \


# -r all

sread.lex.o: sread.lex.c sreadnode.h
sread.tab.o: sread.tab.c sread.tab.h sreadnode.h
sreadnode.o: sreadnode.c sreadnode.h
main.o:	main.c sread.lex.h sread.tab.h

$(NAME): $(OBJ)
	gcc -o $(NAME) $(OBJ) $(LIBS)

clean:
	rm -f $(NAME) $(OBJ) $(SREAD)

tst:	$(NAME)
	./$(NAME) test/tst.srec

#	./$(NAME) test/test.srec
