#include <iostream>
#include <string>
#include "../includes/BaseConversion.h"
using namespace std;

string translateEFLAGS(const string& input);

int main()
{
	string testCase = toBinary(Value("246", 1));

	cout << translateEFLAGS(testCase);
	return 0;
}

string translateEFLAGS(const string& input)
{
	bool carry = input.size() == 12; // 0001 #### #### means True
	string proxy = input;
	if (carry)
	{
		proxy = input.substr(4);
	}
	bool signFlag = proxy[0] - '0';
	bool zeroFlag = proxy[1] - '0';
	bool auxFlag = proxy[3] - '0';
	bool parityFlag = proxy[5] - '0';
	bool carryFlag = proxy[7] - '0';

	string output = "Here are the flags of the given number " + input + "\n";
	output += "Sign Flag [SF]: ";
	output += signFlag ? "TRUE\n" : "FALSE\n";

	output += "Zero Flag [Z]: ";
	output += zeroFlag ? "TRUE\n" : "FALSE\n";

	output += "Auxiliary Flag [AF]: ";
	output += auxFlag ? "TRUE\n" : "FALSE\n";

	output += "Parity Flag [P]: ";
	output += parityFlag ? "TRUE\n" : "FALSE\n";

	output += "Carry Flag [CY]: ";
	output += carryFlag ? "TRUE\n" : "FALSE\n";

	return output;
}
