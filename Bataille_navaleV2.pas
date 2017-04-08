Program Bataille_NavaleV2;
uses crt;

//CONSTANTES

CONST
	nbBateau=4;
	maxCase=5;
	minL=1;
	maxL=50;
	minC=1;
	maxC=50;
	nbJoueur=50;
	minTaille=3;

//TYPES

TYPE Cell=RECORD
	ligne:INTEGER;
	colonne: INTEGER;
END;

TYPE bateau=RECORD
	nCase:Array[1..maxCase] of Cell;
END;

TYPE flotte=RECORD
	nBateau:Array[1..nbBateau] of bateau;
END;

TYPE positionBateau=(enLigne, enColonne, enDiag);

TYPE etatBateau=(Touche, Coule);

TYPE etatFlotte=(aFlot, aSombre);





PROCEDURE creationCase (l,c: INTEGER; VAR nCase: Cell);

	BEGIN
		nCase.ligne:=l;
		nCase.colonne:=c;
	END;



//BUT: Compare 2 cases. Utilisé dans la fonction ctrlCase
//ENTREES:2 Cell
//SORTIE: Un booleen indiquant si les 2 Cells sont les mêmes
FUNCTION cmpCase (nCase, tCase:Cell): Boolean;
	BEGIN
			IF (nCase.colonne=tCase.colonne) AND (nCase.ligne=tCase.ligne) THEN
				cmpCase:=TRUE
			ELSE cmpCase:=FALSE;
	END;



//BUT: Creer les bateaux des joueurs
//ENTREES: Les lignes et colonnes composant les Cell
//SORTIE: la fonction recupère une valeur de type bateau
FUNCTION crea_bateau (nCase:Cell; taille: INTEGER): bateau;

VAR
res: bateau;
I, pos: INTEGER;
posBateau: positionBateau;
	
	BEGIN
		pos:=Random(2)+1;
		posBateau:=positionBateau(pos);
		nCase.ligne:=Random(44)+1;
		nCase.colonne:=Random(44)+1;
		taille:=Random(2)+3;

		
		FOR i:=1 TO maxCase DO
			BEGIN
				IF (i<=taille) THEN
					BEGIN
						res.nCase[i].ligne:=nCase.ligne;
						res.nCase[i].colonne:=nCase.colonne;
					END
				ELSE
					BEGIN
						res.nCase[i].ligne:=0;
						res.nCase[i].colonne:=0;
					END;

				IF (posBateau=enLigne) THEN
					nCase.colonne:=nCase.colonne+1;

				IF (posBateau= enColonne) THEN
					nCase.ligne:=nCase.ligne+1;

				IF (posBateau= enDiag) THEN
					BEGIN
					nCase.colonne:=nCase.colonne+1;
					nCase.ligne:=nCase.ligne+1;
					END;
		END;
	crea_bateau:=res;
	END;



//BUT: Controle toutes les cases d'un bateau pour voir si une est  similaires à celle testée en utilisant cmpCase
//ENTREES: Les Cell composant le bateau, et la Cell testée
//SORTIE: Un boolen indiquant si le bateau comprend la case testée
FUNCTION ctrlCase (nBat:bateau; caseJoueur:Cell): Boolean;

VAR
i:INTEGER;
valTest: Boolean;
	
	BEGIN
		valTest:=FALSE;
		FOR i:=1 TO maxCase DO
			BEGIN
				IF (cmpCase(nBat.nCase[I], caseJoueur)) THEN
					valTest:=TRUE;
			END;
		ctrlCase:=valTest;
	END;



//BUT: Utilise CtrlCase pour déterminer si parmis tous les bateaux d'une flotte s'en trouve un qui comprend la case testée.
//ENTREES: Les bateaux composant la flotte
//SORTIE: Un booleen 
FUNCTION ctrlFlotte (nFlotte: flotte; caseJoueur: Cell): Boolean;

VAR
i: INTEGER;
valTest: Boolean;

	BEGIN
		valTest:=FALSE;
		FOR i:=1 TO nbBateau DO
			BEGIN
				IF (ctrlCase(nFlotte.nBateau[i], caseJoueur)) THEN
					valTest:=TRUE;
			END;
		ctrlFlotte:=valTest;
	END;




//PROGRAMME PRINCIPAL
VAR
i,j, bat, cellule: INTEGER;
taille: INTEGER;
joueur: ARRAY[1..nbJoueur] of flotte;
caseJoueur: Cell;
caseTest: Cell;
nCase: Cell;
vieJ, vieO:Boolean;



	BEGIN
		randomize;
		clrscr;
		writeln('Bienvenue sur le jeu de la Bataille Navale. Continuez pour lire les regles de jeu.');
		readln;
		writeln('Chaque joueur possede 4 bateaux allant de 3 à 5 cellules. A tour de role, le joueur et l''ordinateur ciblent une cellule du jeu.');
		writeln('Pour couler un bateau, il faut toucher toutes les cellules composant le bateau. Pour gagner, il faut couler tous les bateaux de son adversaire. Continuez pour passer à la creation des bateaux.');
		readln;


		//Cree les bateaux grace à la fonction crea_bateau
		FOR i:=1 TO nbJoueur DO
		BEGIN
			FOR j:=1 TO nbBateau DO
			BEGIN
				joueur[i].nBateau[j]:=crea_bateau(nCase, taille);
			END;
		END;



		writeln('La partie peut maintenant commencer. Vous allez jouer en premier, puis ce sera au tour de l''ordinateur, puis a nouveau a vous. Ce cycle continue jusqu''à la fin de la partie.');
		readln;
		


		
		


		REPEAT
			BEGIN
			clrscr;
			//AFFICHAGE DES BATEAUX
			FOR bat:=1 TO nbBateau DO
			BEGIN
				writeln('Bateau ',bat);
                FOR cellule:=1 TO maxCase DO
                BEGIN
					write('ligne ',cellule,': ',joueur[1].nBateau[bat].nCase[cellule].ligne,'  ');
					writeln('colonne ',cellule,':',joueur[1].nBateau[bat].nCase[cellule].colonne);
				END;
			END;


			writeln('Debut de votre Tour');
			writeln('Entrez la ligne visee');
			readln (caseJoueur.ligne);
			writeln('Entrez la colonne visée');
			readln (caseJoueur.colonne);
			//TESTE SI LE TIR DU JOUEUR TOUCHE
			IF ctrlFlotte(joueur[2], caseJoueur) THEN
			BEGIN
				FOR i:=1 to nbBateau DO
				BEGIN
					FOR j:=1 TO maxCase DO
					BEGIN
						IF (joueur[2].nBateau[i].nCase[j].ligne=caseJoueur.ligne) AND (joueur[2].nBateau[i].nCase[j].colonne=caseJoueur.colonne) THEN
						BEGIN
							writeln ('Touche');
							joueur[2].nBateau[i].nCase[j].ligne:=0;
							joueur[2].nBateau[i].nCase[j].colonne:=0;
						END;
					END;	
				END;
			END;





			writeln(' Tour de l''ordinateur');
			caseJoueur.ligne:=random(49)+1;
			caseJoueur.colonne:=random(49)+1;
			//TESTE SI LE TIR DE L'IA TOUCHE
			IF ctrlFlotte(joueur[1], caseJoueur) THEN
			BEGIN
				FOR i:=1 to nbBateau DO
				BEGIN
					FOR j:=1 TO maxCase DO
					BEGIN
						IF (joueur[1].nBateau[i].nCase[j].ligne=caseJoueur.ligne) AND (joueur[1].nBateau[i].nCase[j].colonne=caseJoueur.colonne) THEN
						BEGIN
							writeln ('Touche');
							joueur[1].nBateau[i].nCase[j].ligne:=0;
							joueur[1].nBateau[i].nCase[j].colonne:=0;
						END;
					END;			
				END;
			END;

			//CONTROLE SI LE JOUEUR A PERDU
			FOR i:=1 TO nbBateau DO
			BEGIN
				FOR j:=1 TO maxCase DO
				BEGIN
					IF ((joueur[1].nBateau[i].nCase[j].ligne=0) AND (joueur[1].nBateau[i].nCase[j].colonne=0)) THEN
					vieJ:=vieJ OR FALSE
					ELSE vieJ:=vieJ OR TRUE;
				END;
			END;



			//CONTROLE SI L'ORDINATEUR A PERDU
			FOR i:=1 TO nbBateau DO
			BEGIN
				FOR j:=1 TO maxCase DO
				BEGIN
					IF ((joueur[2].nBateau[i].nCase[j].ligne=0) AND (joueur[2].nBateau[i].nCase[j].colonne=0)) THEN
					vieO:=vieO OR FALSE
					ELSE vieO:=vieO OR TRUE;
				END;
			END;


			END;

		UNTIL (vieJ=FALSE) OR (vieO=FALSE);

		IF vieO=FALSE THEN
			writeln('Felicitations. Vous avez vaincu. Le programme va maintenant se fermer.');

		IF vieJ=FALSE THEN
			writeln('Quel Dommage. Vous ferez mieux la prochaine fois. Le programme va maintenant se fermer.');
		readln;
	END.









