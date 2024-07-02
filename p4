/*
Link: https://leetcode.com/problems/minimum-cost-to-convert-string-ii/

Julie is given two 0-indexed strings, source and target, each of length n, and consisting of lowercase English letters. She is also provided with two 0-indexed arrays of strings, original and changed, 
along with an integer array cost, where each cost[i] represents the expense of converting the string original[i] into the string changed[i].

Julie starts with the string source. In a single operation, she can select a substring x from source and transform it into y with a cost z if there exists an index j such that:

cost[j] == z,
original[j] == x, and
changed[j] == y.

Julie can perform any number of such operations under these constraints:

The substrings chosen in different operations must be disjoint. This means, for substrings source[a..b] and source[c..d], the operations are valid if either b < c or d < a.

The substrings chosen in the operations must be identical. This means, for substrings source[a..b] and source[c..d], the operations are valid if a == c and b == d.

Julie wants to determine the minimum cost required to convert the string source into the string target using these operations. If it's impossible to achieve this transformation, the function should return -1.

Note: There may be cases where original[i] == original[j] and changed[i] == changed[j] for different indices i and j.

Create a C++ Function named convert_string that returns an integer representing the minimum cost to transform the string source into target. 

Ensure to use appropriate error handling using the stdexcept library for invalid test cases.

Input Type:

A string denoting source
A string denoting target
A vector<string> denoting original
A vector<string> denoting  changed
A vector<int> denoting cost

Input Constraints:

The length of source and target is at least 1 and at most 1000.
Both source and target consist only of lowercase English characters.
The lengths of cost, original, and changed are between 1 and 100 inclusive.
The lengths of each original[i] and changed[i] are between 1 and the length of source inclusive.
Each string in original and changed consists only of lowercase English characters.
Each original[i] is not equal to changed[i].
Each cost[i] is between 1 and 1,000,000 inclusive.


*/
