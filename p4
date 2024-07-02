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

        if (source.empty() || target.empty() || source.length() > 1000 || target.length() > 1000 || source.size() != target.size()) {
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
  return 0;
}
