//Author: Jonathan Dang
//Simulation of Base 10, Base 16, and Base 8 Translations
//Professor: Sassan Barkeshli
//Date: 8/25/2021
#include <iostream>
#include <string>
#include <vector>
using namespace std;

const char base16[16] = { '0','1','2','3','4','5','6','7'
							,'8','9','A','B','C','D','E','F' };
struct Value
{
	Value() : _data("0"), _type(-1) {}
	Value(string data, int type) : _data(data), _type(type) {}

	friend ostream& operator<<(ostream& outs, const Value& rhs)
	{
		outs << "[";
		switch (rhs._type)
		{
			case(0):
			{
			outs << "Binary";
			break;
			}
			case(1):
			{
			outs << "Decimal";
			break;
			}
			case(2):
			{
			outs << "Octal";
			break;
			}
			case(3):
			{
			outs << "Hex";
			break;
			}
		}
		outs << "] " << rhs._data;
		return outs;
	}

	string _data;
	int _type;
	//Binary: 0
	//Decimal: 1
	//Octal: 2
	//Hex: 3
};

string toDecimal(Value input);
string toHex(Value input);
string toBinary(Value input);
string toOctal(Value input);

int main()
{
	cout << "====================BEGIN=====================\n";
	while (true)
	{
		cout << "Please insert a value in either Binary, Base10, Octal, or Hex {MUST BE A SIGNED VALUE}: ";
		string input;
		cin >> input;
		cout << "[D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX\n";
		cout << "Please indicate which of the 4 bases you are using by entering in the marked character: ";
		char type;
		cin >> type;

		Value in(input, -1);
		Value output[3];

		switch (type)
		{
		case('d'):
		case('D'):
		{
			in._type = 1;
			output[0] = Value(toBinary(in), 0);
			output[1] = Value(toOctal(in), 2);
			output[2] = Value(toHex(in), 3);
			break;
		}//Decimal
		case('i'):
		case('I'):
		{
			in._type = 0;
			output[0] = Value(toDecimal(in), 1);
			output[1] = Value(toOctal(in), 2);
			output[2] = Value(toHex(in), 3);
			break;
		}//Binary
		case('o'):
		case('O'):
		{
			in._type = 2;
			output[0] = Value(toBinary(in), 0);
			output[1] = Value(toDecimal(in), 1);
			output[2] = Value(toHex(in), 3);
			break;
		}//Octal
		case('h'):
		case('H'):
		{
			in._type = 3;
			output[0] = Value(toBinary(in), 0);
			output[2] = Value(toOctal(in), 2);
			output[1] = Value(toDecimal(in), 1);
			break;
		}//Hex
		}//switch

		cout << "Here are the translated Numbers from your entry of " << input << endl;
		for (int i = 0; i < 3; i++)
		{
			cout << output[i] << endl;
		}

		cout << "To e[X]it the program, Enter 'X', enter anything else to continue: ";
		char c;
		cin >> c;
		if (c == 'X' || c == 'x')
			break;

	}//While
	cout << "=====================END======================\n";
	return 0;
}


	//Binary: 0
	//Decimal: 1
	//Octal: 2
	//Hex: 3
string toDecimal(Value input)
{
	string output;

	switch (input._type)
	{
	case(0):
	{
		int binary = stoi(input._data);
		int decimal = 0, temp = 0, rem;
		while (binary != 0)
		{
			rem = binary % 10;
			binary = binary / 10;
			decimal = decimal + rem * pow(2, temp);
			temp++;
		}

		return to_string(decimal);
	}
	case(1):
		return input._data;
	case(2):
	{
		int octal = stoi(input._data);
		int decimal = 0, temp = 0;
		while (octal != 0)
		{
			decimal += octal * pow(8, temp);
			temp++;
			octal /= 10;
		}
		return to_string(decimal);
	}
		
	case(3):
	{
		int size = input._data.size();
		int base = 1, decimal = 0;
		for (int i = size - 1; i >= 0; i--)
		{
			if (input._data[i] >= '0' && input._data[i] <= '9')
			{
				decimal += (input._data[i] - '0') * base;
				base *= 16;
			}
			else if (input._data[i] >= 'A' && input._data[i] <= 'F')
			{
				decimal += (input._data[i] - 'A') * base;
				base *= 16;
			}
		}
		return to_string(decimal);
	}
	}
	return "DECIMAL";
}

string toHex(Value input)
{
	int decimalProxy = stoi(toDecimal(input));

	vector<int> hold;
	for (int i = 0; decimalProxy > 0; i++)
	{
		hold.push_back(decimalProxy % 16);
		decimalProxy /= 16;
	}

	string output;
	for (int i = hold.size() - 1; i >= 0; i--)
	{
		output += base16[hold.at(i)];
	}

	return output;
}

string toBinary(Value input)
{
	int decimalProxy = stoi(toDecimal(input));

	vector<int> hold;
	for (int i = 0; decimalProxy > 0; i++)
	{
		hold.push_back(decimalProxy % 2);
		decimalProxy /= 2;
	}

	string output;
	for (int i = hold.size() - 1; i >= 0; i--)
	{
		output += to_string(hold.at(i));
	}

	return output;
}

string toOctal(Value input)
{	
	int decimalProxy = stoi(toDecimal(input));

	vector<int> hold;
	for (int i = 0; decimalProxy > 0; i++)
	{
		hold.push_back(decimalProxy % 8);
		decimalProxy /= 8;
	}

	string output;
	for (int i = hold.size() - 1; i >= 0; i--)
	{
		output += to_string(hold.at(i));
	}

	return output;
}