#include <iostream>
using namespace std;

char* makeArrayChar();
int* makeArrayInt();

int main()
{
	cout << "=======================START======================\n";
	char* cArr = makeArrayChar();
	int* iArr = makeArrayInt();
	char secondArr[10] = { '0','1','2','3','4','5','6','7','8','9' };
	int secondIntArr[10] = { 0,1,2,3,4,5,6,7,8,9 };

	for (int i = 0; i < 10; i++)
	{
		cout << secondArr[i];
		//cArr++;
	}

	for (int i = 0; i < 10; i++)
	{
		cout << secondIntArr[i];
		//iArr++;
	}

	cout << "======================= END ======================\n";
	return 0;
}

char* makeArrayChar()
{
	char* arr = new char[10];
	char* temp = arr;

	for (int i = 0; i < 10; i++)
	{
		*temp = '0' + i;
		temp++;
	}
	return arr;
}

int* makeArrayInt()
{
	int* arr = new int[10];
	int* temp = arr;

	for (int i = 0; i < 10; i++)
	{
		*temp = i;
		temp++;
	}
	return arr;
}
