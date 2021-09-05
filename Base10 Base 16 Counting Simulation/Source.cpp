//Author: Jonathan Dang
//Simulation of Base 10, Base 16, and Base 8 Translations
//Professor: Sassan Barkeshli
//Date: 9/5/2021
#include <iostream>
#include <string>
#include <vector>
using namespace std;

const string octal[8] = { "000", "001", "010", "011","100","101","110","111" };

const string Hex[16] = { "0000", "0001", "0010","0011","0100","0101","0110","0111"
							,"1000","1001","1010","1011","1100","1101","1110","1111" };

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

string* toDecimal(Value input);
string* toHex(Value input);
string toBinary(Value input);
string* toOctal(Value input);
string twosCompliment(string input);

int main()
{
	cout << "====================BEGIN=====================\n";
	while (true)
	{
		cout << "Please insert a value in either Binary, Decimal, Octal, or Hex: ";
		string input;
		cin >> input;
		cout << "[D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX\n";
		cout << "Please indicate which of the 4 bases you are using by entering in the marked character: ";
		char type;
		cin >> type;

		Value in(input, -1);
		Value output[7];
		//0 : Binary
		//1 : signed Decimal
		//2 : unsigned Decimal
		//3 : signed Octal
		//4 : unsigned Octal
		//5 : signed Hex
		//6 : unsigned Hex

		switch (type)
		{
		case('d'):
		case('D'):
		{
			//Needs: Binary, Octal, Hex
			in._type = 1;
			string* temp = toOctal(in);
			output[0] = Value(toBinary(in),0);
			output[3] = Value(*temp,2);
			output[4] = Value(*(temp + 1),2);
			delete[] temp;
			temp = toHex(in);
			output[5] = Value(*temp,3);
			output[6] = Value(*(temp + 1),3);
			delete[] temp;
			break;
		}//Decimal
		case('i'):
		case('I'):
		{
			//Needs: Decimal, Octal, Hex
			in._type = 0;
			string* temp = toDecimal(in);
			output[1] = Value(*temp,1);
			output[2] = Value(*(temp + 1),1);
			delete[] temp;
			temp = toOctal(in);
			output[3] = Value(*temp,2);
			output[4] = Value(*(temp + 1),2);
			delete[] temp;
			temp = toHex(in);
			output[5] = Value(*temp,3);
			output[6] = Value(*(temp + 1),3);
			delete[] temp;
			break;
		}//Binary
		case('o'):
		case('O'):
		{
			//Needs: Decimal, Binary, Hex
			in._type = 2;

			output[0] = Value(toBinary(in),0);
			string* temp = toDecimal(in);
			output[1] = Value(*temp,1);
			output[2] = Value(*(temp + 1),1);
			delete[] temp;
			temp = toHex(in);
			output[5] = Value(*temp,3);
			output[6] = Value(*(temp + 1),3);
			delete[] temp;

			break;
		}//Octal
		case('h'):
		case('H'):
		{
			//Needs: Binary, Decimal, Octal
			in._type = 3;

			output[0] = Value(toBinary(in),0);
			string* temp = toDecimal(in);
			output[1] = Value(*temp,1);
			output[2] = Value(*(temp + 1),1);
			delete[] temp;
			temp = toOctal(in);
			output[3] = Value(*temp,2);
			output[4] = Value(*(temp + 1),2);
			delete[] temp;

			break;
		}//Hex
		}//switch

		cout << "Here are the translated Numbers from your entry of " << input << endl;
		for (int i = 0; i < 7; i++)
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

//Iteration 2
string* toDecimal(Value input)
{
	string* arr = new string[2];

	string binaryProxy = toBinary(input);
	string negativeProxy = twosCompliment(binaryProxy);

	int signedNumber = 0, unsignedNumber = 0;
	int t = binaryProxy.length() - 1;
	for (int i = 0; i < binaryProxy.length(); i++)
	{
		if (binaryProxy[i] == '1')
		{
			signedNumber += pow(2, t);
		}
		if (negativeProxy[i] == '1')
		{
			unsignedNumber += pow(2, t);
		}

		t--;
	}

	string* temp = arr;
	*temp = to_string(signedNumber);
	temp++;
	*temp = to_string(-unsignedNumber);
	return arr;
}

string* toHex(Value input)
{
	string* arr = toDecimal(input);
	string* temp = arr;

	int signedNumber = stoi(*temp);
	int unsignedNumber = 0;
	if (temp + 1 != nullptr)
	{
		unsignedNumber = stoi(*(temp + 1));
		unsignedNumber *= -1;
	}
		


	string outputS, outputU;
	int i = 0;
	while (signedNumber != 0) 
	{
		int temp = 0;
		temp = signedNumber % 16;

		if (temp < 10) {
			outputS += temp + 48;
			i++;
		}
		else {
			outputS += temp + 55;
			i++;
		}

		signedNumber /= 16;
	}

	while (unsignedNumber != 0)
	{
		int temp = 0;
		temp = unsignedNumber % 16;

		if (temp < 10) {
			outputU += temp + 48;
			i++;
		}
		else {
			outputU += temp + 55;
			i++;
		}

		unsignedNumber /= 16;
	}

	string* output = new string[2];
	temp = output;
	*temp = outputS;
	*(temp + 1) = '-' + outputU;
	return output;
}

string toBinary(Value input)
{
	//Identity section | faster processing
	if (input._type == 0)
		return input._data;
	
	bool negative = false;
	string inputData = input._data;
	if (input._data[0] == '-')
	{
		negative = true;
		inputData = inputData.substr(1);
	}

	switch (input._type)
	{
	case(1):
	{
		int rawData = stoi(inputData);
		vector<int> hold;
		for (int i = 0; rawData > 0; i++)
		{
			hold.push_back(rawData % 2);
			rawData /= 2;
		}

		string output;
		for (int i = hold.size() - 1; i >= 0; i--)
		{
			output += to_string(hold.at(i));
		}

		if (negative)
		{
			output = twosCompliment(output);
		}

		return output;
	}//Case 1 Decimal
	case(2):
	{
		string output;
		if (negative)
			output += '-';
		for (int i = 0; i < inputData.length(); i++)
		{
			output += octal[inputData[i] - '0'];
		}

		if (negative)
		{
			for (int i = 0; i < output.length(); i++)
			{
				if (output[i] == '1')
					output[i] = '0';
				else
					output[i] = '1';
			}

			for (int i = output.length() - 1; i >= 0; i--) //Adding 1
			{
				if (output[i] == '1')
				{
					output[i] = '0';
				}// Continue the Algorithmn
				else
				{
					output[i] = '1';
					break;
				}
			}

		}

		return output;
		//
	}//Case 2 Octal
	case(3):
	{
		//Things to check:
		//If char, then follow A-F
		//4 bits
		string output;
		if (negative)
			output += '-';
		for (int i = 0; i < inputData.length(); i++)
		{
			if (inputData[i] >= 'A' && inputData[i] <= 'F')
			{
				switch (inputData[i])
				{
				case('A'):
					output += Hex[10];
					break;
				case('B'):
					output += Hex[11];
					break;
				case('C'):
					output += Hex[12];
					break;
				case('D'):
					output += Hex[13];
					break;
				case('E'):
					output += Hex[14];
					break;
				case('F'):
					output += Hex[15];
					break;
				default:
					break;
				}
			}
			else
			{
				output += Hex[inputData[i] - '0'];
			}
		}

		if (negative)
		{
			for (int i = 0; i < output.length(); i++)
			{
				if (output[i] == '1')
					output[i] = '0';
				else
					output[i] = '1';
			}

			for (int i = output.length() - 1; i >= 0; i--) //Adding 1
			{
				if (output[i] == '1')
				{
					output[i] = '0';
				}// Continue the Algorithmn
				else
				{
					output[i] = '1';
					break;
				}
			}

		}

		return output;
	}//Case 3 Hex
	default:
		return "";
	}
}

string* toOctal(Value input)
{
	string* arr = toDecimal(input);
	string* temp = arr;

	int signedNumber = stoi(*temp);
	int unsignedNumber = 0;
	if (*(temp + 1) != "")
		unsignedNumber = stoi(*(temp + 1));

	int octalSigned = 0, octalUnsigned = 0, countS = 1, countU = 1;

	while (signedNumber != 0)
	{
		int rem = signedNumber % 8;
		octalSigned += rem * countS;
		countS *= 10;
		signedNumber /= 8;
	}

	while (unsignedNumber != 0)
	{
		int rem = unsignedNumber % 8;
		octalUnsigned += rem * countU;
		countU *= 10;
		unsignedNumber /= 8;
	}

	string* output = new string[2];
	temp = output;
	*temp = to_string(octalSigned);
	*(temp + 1) = to_string(octalUnsigned);

	return output;
}

string twosCompliment(string input)
{
	string output = input;
	for (int i = 0; i < output.length(); i++) // 2's Compliment
	{
		if (output[i] == '1')
			output[i] = '0';
		else
			output[i] = '1';
	}

	for (int i = output.length() - 1; i >= 0; i--) //Adding 1
	{
		if (output[i] == '1')
		{
			output[i] = '0';
		}// Continue the Algorithmn
		else
		{
			output[i] = '1';
			break;
		}
	}
	return output;
}

//Iteration 1
/*string toDecimal(Value input)
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
}*/

/*
TESTING:
====================BEGIN=====================
Please insert a value in either Binary, Decimal, Octal, or Hex: -123
[D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX
Please indicate which of the 4 bases you are using by entering in the marked character: D
Here are the translated Numbers from your entry of -123
[Binary] 0000101
[] 0
[] 0
[Octal] 5
[Octal] -173
[Hex] 5
[Hex] -B7
To e[X]it the program, Enter 'X', enter anything else to continue: 1234567890
Please insert a value in either Binary, Decimal, Octal, or Hex: [D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX
Please indicate which of the 4 bases you are using by entering in the marked character: D
Here are the translated Numbers from your entry of 234567890
[Binary] 1101111110110011100011010010
[] 0
[] 0
[Octal] 1576634322
[Octal] -201143456
[Hex] 2D83BFD
[Hex] -E27C402
To e[X]it the program, Enter 'X', enter anything else to continue: a
Please insert a value in either Binary, Decimal, Octal, or Hex: 173
[D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX
Please indicate which of the 4 bases you are using by entering in the marked character: O
Here are the translated Numbers from your entry of 173
[Binary] 001111011
[Decimal] 123
[Decimal] -389
[] 0
[] 0
[Hex] B7
[Hex] -581
To e[X]it the program, Enter 'X', enter anything else to continue: s
Please insert a value in either Binary, Decimal, Octal, or Hex: 1A
[D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX
Please indicate which of the 4 bases you are using by entering in the marked character: H
Here are the translated Numbers from your entry of 1A
[Binary] 00011010
[Decimal] 26
[Decimal] -230
[Octal] 32
[Octal] -346
[] 0
[] 0
To e[X]it the program, Enter 'X', enter anything else to continue: k
Please insert a value in either Binary, Decimal, Octal, or Hex: -1A
[D]ECIMAL | B[I]NARY | [O]CTAL | [H]EX
Please indicate which of the 4 bases you are using by entering in the marked character: H
Here are the translated Numbers from your entry of -1A
[Binary] 111100110
[Decimal] 486
[Decimal] -26
[Octal] 746
[Octal] -32
[] 0
[] 0
To e[X]it the program, Enter 'X', enter anything else to continue: X
=====================END======================

C:\Users\pocke\source\repos\Base10 Base 16 Counting Simulation\Debug\Base10 Base 16 Counting Simulation.exe (process 17676) exited with code 0.
To automatically close the console when debugging stops, enable Tools->Options->Debugging->Automatically close the console when debugging stops.
Press any key to close this window . . .

*/
