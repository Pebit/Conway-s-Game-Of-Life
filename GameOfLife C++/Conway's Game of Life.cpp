#include <iostream>
#include <fstream>
#include <cstring>
using namespace std;
int main()
{
	int m, n, p, k;
	bool mat[50][50];
	bool aux[50][50];
	int x, y;
	int celulevii;
	int operationDecider;
	
	int putere2;
	char mesaj[100];
	int vector[100];
	int caracterint;
	int lenmesajcriptat;
	int vindex;
	char hexa[] = "0123456789ABCDEF";

	ifstream fin("date.in");
	// citim nr linii si coloane
	fin >> m;
	fin >> n;
	// schimbam valorea lui m si n conform matricei expandate pentru usurarea calculelor in assembly 
	m = m + 1;
	n = n + 1;
	// initializam matricea cu 0
	for (int i = 0; i <= m; i++)
		for (int j = 0; j <= n; j++)
		{
			mat[i][j] = 0;
			aux[i][j] = 0;
		}
	// citim nr celulelor vi pe care le vom pregati
	fin >> p;
	for (int i = 0; i < p; i++)
	{
		//citim coordonatele celulelor vii
		fin >> x >> y;
		//le notam in matrice
		x = x + 1;
		y = y + 1;
		mat[x][y] = 1;
		aux[x][y] = 1;
	}
	// citim numarul de "tick-uri" parcurse in joc
	fin >> k;
	// parcurgerea matricei neexpandate:
	for (int E = 0; E < k; E++)
	{
		for (int i = 1; i < m; i++)
		{
			for (int j = 1; j < n; j++)
			{
				//calculam numarul de celule vii din jurul celulei curent (calculele se vor face unul cate unul in assembly)
				celulevii = mat[i - 1][j - 1] + mat[i - 1][j] + mat[i - 1][j + 1] + mat[i][j - 1] + mat[i][j + 1] + mat[i + 1][j - 1] + mat[i + 1][j] + mat[i + 1][j + 1];
				// copiem valoarea celulei in matricea auxiliara
				/*aux[i][j] = mat[i][j];*/

				// daca celula vie are mai putin de 2 sau mai mult de trei vecini vi moare
				if (mat[i][j] == 1)
				{
					if (celulevii < 2)
						aux[i][j] = 0;
					if (celulevii > 3)
						aux[i][j] = 0;
				}
				// daca celula moarta are 3 vecini atunci invie
				if (mat[i][j] == 0)
					if (celulevii == 3)
						aux[i][j] = 1;
			}
		}
		for (int i = 1; i < m; i++)
		{
			for (int j = 1; j < n; j++)
			{
				mat[i][j] = aux[i][j];
			}
		}
	}
	for (int i = 1; i < m; i++)
	{
		for (int j = 1; j < n; j++)
		{
			cout << aux[i][j];
		}
		cout << "\n";
	}
	fin >> operationDecider;
	// citim mesajul
	fin >> mesaj;
	// pentru criptare
	if (operationDecider == 0)
	{
		x = 0;
		y = 0;
		// transformam fiecare caracter din string in binar si il adaugam in vector
		while (mesaj[x] != '\0')
		{
			caracterint = (int)mesaj[x];
			// incarcam fiecare 8 biti cu codul ascii in binar al caracterului corespunzator prin algoritmul cu impartirea la 2
			for (int i = 7; i >= 0; i--)
			{
				vector[y + i] = caracterint % 2;
				caracterint = caracterint / 2;
			}
			y = y + 8;
			x = x + 1;
		}
		
		
		lenmesajcriptat = y;
		cout << endl;
		// xor-am fiecare element din vectorul cu mesaj cu elementele din matricea extinsa game of life
		x = 0;
		y = 0;
		for (int j = 0; j < lenmesajcriptat; j++)
		{
			// parcurgem in paralel vectorul si matricea
			// atunci cand indexul coloanelor matricei trece de nr coloanelor se intoarce la prima coloana iar linia se incrementeaza
			if (y > n)
			{
				y = 0;
				x = x + 1;
			}
			// atunci cand indexul liniilor depaseste nr liniilor matricei se intoarce la prima linie
			if (x > m)
			{
				x = 0;
			}
			// se xoreaza si rezultatul se pastreaza in vectorul vector
			vector[j] = vector[j] xor mat[x][y];
			if (j % 4 == 0 and j != 0)
				cout << " ";
			cout << vector[j];
			y = y + 1;
		}
		cout << "\n";
		cout << "0x";
		// parcurgem vectorul cu cifrul obtinut si il transformam in hexa
		y = 0;
		x = 0;
		while(x < lenmesajcriptat)
		{
			caracterint = 0;
			if (vector[x] == 1)
				caracterint = caracterint + 8;
			x = x + 1;
			if (vector[x] == 1)
				caracterint = caracterint + 4;
			x = x + 1;
			if (vector[x] == 1)
				caracterint = caracterint + 2;
			x = x + 1;
			if (vector[x] == 1)
				caracterint = caracterint + 1;
			cout << hexa[caracterint];
			x = x + 1;
		}
	}
	
	// pentru decriptare
	if (operationDecider == 1)
	{
		// x este 2 deoarece ignoram caracterele "0x"
		x = 2;
		y = 0;
		while (mesaj[x] != '\0')
		{
			// transformam hexa in decimal
			if ((int)mesaj[x] <= 57)
				caracterint = (int)mesaj[x] - 48;
			if ((int)mesaj[x] >= 65)
				caracterint = (int)mesaj[x] - 55;
			cout << caracterint << " ";
			// transformam decimal in binar si punem codul binar in vector
			vindex = y + 3;
			while (vindex >= y)
			{
				vector[vindex] = caracterint % 2;
				caracterint = caracterint / 2;
				vindex = vindex - 1;
			}
			y = y + 4;
			x = x + 1;
		}
		cout << endl;
		for (int i = 0; i < y; i++)
			cout << vector[i];
		cout << endl;
		// xoram vectorul cu cheia (matricea game of life la al k-lea loop) pentru a descifra mesajul
		lenmesajcriptat = y;
		x = 0;
		y = 0;
		for (int j = 0; j < lenmesajcriptat; j++)
		{
			// parcurgem in paralel vectorul si matricea
			// atunci cand indexul coloanelor matricei trece de nr coloanelor se intoarce la prima coloana iar linia se incrementeaza
			if (y > n)
			{
				y = 0;
				x = x + 1;
			}
			// atunci cand indexul liniilor depaseste nr liniilor matricei se intoarce la prima linie
			if (x > m)
			{
				x = 0;
			}
			// se xoreaza si rezultatul se pastreaza in vectorul vector
			vector[j] = vector[j] xor mat[x][y];
			cout << vector[j];
			y = y + 1;
		}
		cout << endl;
		//luam 8 cate 8 valori din vector si le transformam din binar in decimal si le afisam drept char
		vindex = 0;
		x = 0;
		y = 0;
		while (vindex != lenmesajcriptat)
		{
			caracterint = 0;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 64;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 32;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 16;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 8;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 4;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 2;
			vindex = vindex + 1;
			if (vector[vindex] == 1)
				caracterint = caracterint + 1;
			cout << (char)caracterint;
			vindex = vindex + 1;
		}
	}
}

// pentru inputul = 0 trebuie sa criptam mesajul
// cheia de criptare depinde de matrice dupa al k-lea loop
//