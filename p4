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

Create a C++ class Solution that will cotain a function named convert_string that returns an integer representing the minimum cost to transform the string source into target. 

Ensure to use appropriate error handling using the stdexcept library for invalid test cases.

Input Type:

A string denoting source
A string denoting target
A vector<string> denoting original
A vector<string> denoting  changed
A vector<int> denoting cost

Input Constraints:

The length of source and target is at least 1 and at most 1000 and both should be equal.
Both source and target consist only of lowercase English characters.
The lengths of cost, original, and changed are between 1 and 100 inclusive.
The lengths of each original[i] and changed[i] are between 1 and the length of source inclusive.
Each string in original and changed consists only of lowercase English characters.
Each original[i] is not equal to changed[i].
Each cost[i] is between 1 and 1,000,000 inclusive.


*/

#include <vector>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <queue>
#include <cstring>
#include <stdexcept>
#include <cassert>

class Solution {
public:
    struct Constants {
        static const long long infinity = 1e18;
    };

    int length;
    long long dp_table[1002];
    std::unordered_map<std::string, std::unordered_map<std::string, int>> adjacency_map;
    std::unordered_map<std::string, std::unordered_map<std::string, long long>> distance_map;
    std::unordered_set<int> sizes;

    long long CalculateCost(int index, std::string &source, std::string &target) {
        if (index >= length) return 0;
        if (dp_table[index] != -1) return dp_table[index];

        long long result = Constants::infinity;
        if (source[index] == target[index]) result = CalculateCost(index + 1, source, target);

        for (int len : sizes) {
            int end_index = index + len - 1;
            if (end_index >= length) continue;

            std::string substring_source = source.substr(index, len);
            std::string substring_target = target.substr(index, len);

            if (distance_map.find(substring_source) == distance_map.end()) continue;
            if (distance_map[substring_source].find(substring_target) == distance_map[substring_source].end()) continue;

            result = std::min(result, distance_map[substring_source][substring_target] + CalculateCost(end_index + 1, source, target));
        }
        return dp_table[index] = result;
    }

    long long MinimumCost(std::string source, std::string target, std::vector<std::string>& original, std::vector<std::string>& changed, std::vector<int>& cost) {
        int cost_size = cost.size();
        length = source.length();
        if (source.empty() || target.empty() || source.length() > 1000 || target.length() > 1000 || (int)source.size() != (int)target.size()) {
            throw std::invalid_argument("Invalid source or target length");
        }
        if (original.size() != changed.size() || original.size() != cost.size() || original.empty() || original.size() > 100) {
            throw std::invalid_argument("Invalid sizes of original, changed, or cost vectors");
        }
        
        for (const std::string& str : original) {
            if (str.length() > source.length() || str.length() < 1) {
                throw std::invalid_argument("Invalid length of strings in original vector");
            }
            for (char character : str) {
                if (character < 'a' || character > 'z') {
                    throw std::invalid_argument("Original strings must consist only of lowercase English characters");
                }
            }
        }
        
        for (const std::string& str : changed) {
            if (str.length() > source.length() || str.length() < 1) {
                throw std::invalid_argument("Invalid length of strings in changed vector");
            }
            for (char character : str) {
                if (character < 'a' || character > 'z') {
                    throw std::invalid_argument("Changed strings must consist only of lowercase English characters");
                }
            }
        }
        for(int i = 0; i < original.size(); ++i)
        {
          if(original[i] == changed[i])
          {
            throw std::invalid_argument("Changed strings must not be equal to Original strings");
          }
        }
        for (int ele : cost) {
            if (ele < 1 || ele > 1000000) {
                throw std::invalid_argument("Invalid cost value, must be between 1 and 1,000,000 inclusive");
            }
        }
        memset(dp_table,0,sizeof(dp_table));
        adjacency_map.clear();
        distance_map.clear();
        sizes.clear();
        for (int i = 0; i < cost_size; i++) {
            std::string &original_string = original[i];
            std::string &changed_string = changed[i];
            int weight = cost[i];

            sizes.insert(original_string.length());

            if (adjacency_map[original_string].find(changed_string) == adjacency_map[original_string].end()) {
                adjacency_map[original_string][changed_string] = weight;
            } else {
                adjacency_map[original_string][changed_string] = std::min(adjacency_map[original_string][changed_string], weight);
            }
        }

        for (int i = 0; i < cost_size; i++) {
            std::string &source_string = original[i];
            std::priority_queue<std::pair<long long, std::string>> priority_queue;
            std::unordered_map<std::string, long long> &dijkstra_map = distance_map[source_string];

            priority_queue.push({0, source_string});
            while (!priority_queue.empty()) {
                std::pair<long long, std::string> top_pair = priority_queue.top();
                priority_queue.pop();
                long long distance = top_pair.first;
                std::string current_string = top_pair.second;

                if (dijkstra_map.find(current_string) != dijkstra_map.end()) continue;
                dijkstra_map[current_string] = -distance;

                for (std::pair<std::string, int> neighbor_pair : adjacency_map[current_string]) {
                    std::string neighbor_string = neighbor_pair.first;
                    int neighbor_weight = neighbor_pair.second;
                    if (dijkstra_map.find(neighbor_string) != dijkstra_map.end()) continue;
                    priority_queue.push({distance - neighbor_weight, neighbor_string});
                }
            }
        }

        memset(dp_table, -1, sizeof(dp_table));
        long long result = CalculateCost(0, source, target);
        if (result >= Constants::infinity) return -1;
        return result;
    }
};

int main(){
 
Solution solution;
  // TEST
std::string source_1 = "abc";
std::string target_1 = "def";
std::vector<std::string> original_1 = {"a", "b", "c"};
std::vector<std::string> changed_1 = {"d", "e", "f"};
std::vector<int> cost_1 = {1, 1, 1};
long long expected_1 = 3;
long long result_1 = solution.MinimumCost(source_1, target_1, original_1, changed_1, cost_1);
assert(result_1 == expected_1);
// TEST_END

// TEST
std::string source_2 = "xyz";
std::string target_2 = "xyz";
std::vector<std::string> original_2 = {"x", "y", "z"};
std::vector<std::string> changed_2 = {"y", "z", "x"};
std::vector<int> cost_2 = {2, 2, 2};
long long expected_2 = 0;
long long result_2 = solution.MinimumCost(source_2, target_2, original_2, changed_2, cost_2);
assert(result_2 == expected_2);
// TEST_END

// TEST
std::string source_3 = "aaaa";
std::string target_3 = "bbbb";
std::vector<std::string> original_3 = {"a"};
std::vector<std::string> changed_3 = {"b"};
std::vector<int> cost_3 = {4};
long long expected_3 = 16;
long long result_3 = solution.MinimumCost(source_3, target_3, original_3, changed_3, cost_3);
assert(result_3 == expected_3);
// TEST_END

// TEST
std::string source_4 = "abcd";
std::string target_4 = "wxyz";
std::vector<std::string> original_4 = {"ab", "cd"};
std::vector<std::string> changed_4 = {"wx", "yz"};
std::vector<int> cost_4 = {5, 5};
long long expected_4 = 10;
long long result_4 = solution.MinimumCost(source_4, target_4, original_4, changed_4, cost_4);
assert(result_4 == expected_4);
// TEST_END

// TEST
std::string source_5 = "mn";
std::string target_5 = "op";
std::vector<std::string> original_5 = {"m", "n"};
std::vector<std::string> changed_5 = {"o", "p"};
std::vector<int> cost_5 = {3, 3};
long long expected_5 = 6;
long long result_5 = solution.MinimumCost(source_5, target_5, original_5, changed_5, cost_5);
assert(result_5 == expected_5);
// TEST_END

// TEST
std::string source_6 = "aaa";
std::string target_6 = "bbb";
std::vector<std::string> original_6 = {"aa", "a"};
std::vector<std::string> changed_6 = {"bb", "b"};
std::vector<int> cost_6 = {2, 1};
long long expected_6 = 3;
long long result_6 = solution.MinimumCost(source_6, target_6, original_6, changed_6, cost_6);
assert(result_6 == expected_6);
// TEST_END

// TEST
std::string source_7 = "xyz";
std::string target_7 = "uvw";
std::vector<std::string> original_7 = {"x", "y", "z"};
std::vector<std::string> changed_7 = {"u", "v", "w"};
std::vector<int> cost_7 = {1, 1, 1};
long long expected_7 = 3;
long long result_7 = solution.MinimumCost(source_7, target_7, original_7, changed_7, cost_7);
assert(result_7 == expected_7);
// TEST_END

// TEST
std::string source_8 = "abcdabcd";
std::string target_8 = "efghefga";
std::vector<std::string> original_8 = {"a", "b", "c", "d"};
std::vector<std::string> changed_8 = {"e", "f", "g", "h"};
std::vector<int> cost_8 = {4, 4, 4, 4};
long long expected_8 = -1;
long long result_8 = solution.MinimumCost(source_8, target_8, original_8, changed_8, cost_8);
assert(result_8 == expected_8);
// TEST_END

// TEST
std::string source_9 = "xyzxyz";
std::string target_9 = "uvwxyz";
std::vector<std::string> original_9 = {"x", "z", "y"};
std::vector<std::string> changed_9 = {"u", "w", "v"};
std::vector<int> cost_9 = {5, 3, 1};
long long expected_9 = 9;
long long result_9 = solution.MinimumCost(source_9, target_9, original_9, changed_9, cost_9);
assert(result_9 == expected_9);
// TEST_END

// TEST
std::string source_10 = "abc";
std::string target_10 = "def";
std::vector<std::string> original_10 = {"a", "b", "c"};
std::vector<std::string> changed_10 = {"d", "e", "f"};
std::vector<int> cost_10 = {-1, 1, 1};
try {
    solution.MinimumCost(source_10, target_10, original_10, changed_10, cost_10);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_11 = "abc";
std::string target_11 = "def";
std::vector<std::string> original_11 = {"a", "b", "c"};
std::vector<std::string> changed_11 = {"d", "e", "f"};
std::vector<int> cost_11 = {1, -1, 1};
try {
    solution.MinimumCost(source_11, target_11, original_11, changed_11, cost_11);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_12 = "abc";
std::string target_12 = "def";
std::vector<std::string> original_12 = {"a", "b", "c"};
std::vector<std::string> changed_12 = {"d", "e", "f"};
std::vector<int> cost_12 = {1, 1, -1};
try {
    solution.MinimumCost(source_12, target_12, original_12, changed_12, cost_12);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_13 = "";
std::string target_13 = "def";
std::vector<std::string> original_13 = {"a", "b", "c"};
std::vector<std::string> changed_13 = {"d", "e", "f"};
std::vector<int> cost_13 = {1, 1, 1};
try {
    solution.MinimumCost(source_13, target_13, original_13, changed_13, cost_13);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_14 = "abc";
std::string target_14 = "";
std::vector<std::string> original_14 = {"a", "b", "c"};
std::vector<std::string> changed_14 = {"d", "e", "f"};
std::vector<int> cost_14 = {1, 1, 1};
try {
    solution.MinimumCost(source_14, target_14, original_14, changed_14, cost_14);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_15 = "abc";
std::string target_15 = "def";
std::vector<std::string> original_15 = {"a", "b", "c"};
std::vector<std::string> changed_15 = {"d", "e", ""};
std::vector<int> cost_15 = {1, 1, 1};
try {
    solution.MinimumCost(source_15, target_15, original_15, changed_15, cost_15);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_16 = "abc";
std::string target_16 = "def";
std::vector<std::string> original_16 = {"a", "b", "c"};
std::vector<std::string> changed_16 = {"d", "", "f"};
std::vector<int> cost_16 = {1, 1, 1};
try {
    solution.MinimumCost(source_16, target_16, original_16, changed_16, cost_16);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END
  

// TEST
std::string source_17 = "abc";
std::string target_17 = "def";
std::vector<std::string> original_17 = {"a", "b", "c"};
std::vector<std::string> changed_17 = {"d", "", "f"};
std::vector<int> cost_17 = {1, 1, 1};
try {
    solution.MinimumCost(source_17, target_17, original_17, changed_17, cost_17);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_18 = "abc";
std::string target_18 = "def";
std::vector<std::string> original_18 = {"", "b", "c"};
std::vector<std::string> changed_18 = {"d", "e", "f"};
std::vector<int> cost_18 = {1, 1, 1};
try {
    solution.MinimumCost(source_18, target_18, original_18, changed_18, cost_18);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_19 = "abc";
std::string target_19 = "def";
std::vector<std::string> original_19 = {"a", "b", "c"};
std::vector<std::string> changed_19 = {"d", "e", "f"};
std::vector<int> cost_19 = {1, 1000001, 1};
try {
    solution.MinimumCost(source_19, target_19, original_19, changed_19, cost_19);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_20 = "abc";
std::string target_20 = "def";
std::vector<std::string> original_20 = {"a", "b", "c"};
std::vector<std::string> changed_20 = {"d", "e", "f"};
std::vector<int> cost_20 = {0, 1, 1};
try {
    solution.MinimumCost(source_20, target_20, original_20, changed_20, cost_20);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_21 = "abc";
std::string target_21 = "def";
std::vector<std::string> original_21 = {"a", "b", "c"};
std::vector<std::string> changed_21 = {"d", "e", "f"};
std::vector<int> cost_21 = {1, 0, 1};
try {
    solution.MinimumCost(source_21, target_21, original_21, changed_21, cost_21);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
std::string source_22 = "abc";
std::string target_22 = "def";
std::vector<std::string> original_22 = {"a", "b", "c"};
std::vector<std::string> changed_22 = {"d", "e", "f"};
std::vector<int> cost_22 = {1, 1, 0};
try {
    solution.MinimumCost(source_22, target_22, original_22, changed_22, cost_22);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

  return 0;
}
