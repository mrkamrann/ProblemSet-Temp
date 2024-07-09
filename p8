/*
Link : https://leetcode.com/problems/palindrome-rearrangement-queries/description/


Nikhil is given a 0-indexed string str having an even length len. Nikhil is also given a 0-indexed 2D integer vector, queries, 
where queries[i] = [left_start, left_end, right_start, right_end].

For each query i, Nikhil can perform the following operations:

Rearrange the characters within the substring str[left_start], where 0 <= left_start <= left_end < len / 2.
Rearrange the characters within the substring str[right_start], where len / 2 <= right_start <= right_end < len.
For each query, Nikhil's task is to determine whether it is possible to make str a palindrome by performing the operations.

Each query is answered independently of the others.

Return a 0-indexed vector answer, where answer[i] == true if it is possible to make str a palindrome by performing operations specified by the ith query, and false 
otherwise.

A substring is a contiguous sequence of characters within a string. str[x] represents the substring consisting of characters from the index x to index y in str, 
both inclusive.

Create a C++ Function CanMakePalindromeQueries that will return a vector<bool> denoting if it is possible to make the str a palindrome for each query.

Use appropriate Error Handling using the stdexcept library for invalid test cases.

Input Type:

A string denoting str
A vector of vectors of integers denoting queries

Input Constraints:

The length of str should be at least 2 and at most 10^5 inclusive.
The length of queries should be at least 1 and at most 10^5 inclusive.
Each vector queries[i] should have exactly 4 elements.
The value of left_start should be in the range [0, len / 2) inclusive.
The value of left_end should be in the range [0, len / 2) inclusive.
The value of right_start should be in the range [len / 2, len) inclusive.
The value of right_end should be in the range [len / 2, len) inclusive.
str consists of only lowercase English letters.

*/

#include <vector>
#include <string>
#include <stdexcept>
#include <map>
#include <cassert>


    void Subtract(std::vector<int>& vec_1, std::vector<int>& vec_2) {
        for (int idx = 0; idx < 26; ++idx) {
            vec_1[idx] -= vec_2[idx];
        }
    }

    std::vector<bool> CanMakePalindromeQueries(std::string str, std::vector<std::vector<int>>& queries) {
        
        if (str.size() < 2 || str.size() > 100000) {
    throw std::invalid_argument("The length of str should be at least 2 and at most 10^5 inclusive.");
}

if (queries.size() < 1 || queries.size() > 100000) {
    throw std::invalid_argument("The length of queries should be at least 1 and at most 10^5 inclusive.");
}

for (size_t query_idx = 0; query_idx < queries.size(); ++query_idx) {
    if (queries[query_idx].size() != 4) {
        throw std::invalid_argument("Each vector queries[i] should have exactly 4 elements.");
    }
    
    int left_start = queries[query_idx][0];
    int left_end = queries[query_idx][1];
    int right_start = queries[query_idx][2];
    int right_end = queries[query_idx][3];
    
    if (left_start < 0 || left_start >= str.size() / 2) {
        throw std::invalid_argument("The value of left_start should be in the range [0, len / 2) inclusive.");
    }
    
    if (left_end < 0 || left_end >= str.size() / 2) {
        throw std::invalid_argument("The value of left_end should be in the range [0, len / 2) inclusive.");
    }
    
    if (right_start < str.size() / 2 || right_start >= str.size()) {
        throw std::invalid_argument("The value of right_start should be in the range [len / 2, len) inclusive.");
    }
    
    if (right_end < str.size() / 2 || right_end >= str.size()) {
        throw std::invalid_argument("The value of right_end should be in the range [len / 2, len) inclusive.");
    }
}

for (char character : str) {
    if (character < 'a' || character > 'z') {
        throw std::invalid_argument("str consists of only lowercase English letters.");
    }
}

        
        int len = str.size();
  
        bool is_possible = true;
        std::map<int, int> char_count;
        for (int idx = 0; idx < len / 2; ++idx) {
            char_count[str[idx] - 'a']++;
        }
        for (int idx = len / 2; idx < len; ++idx) {
            if (char_count.find(str[idx] - 'a') == char_count.end() || char_count[str[idx] - 'a'] == 0) {
                is_possible = false;
            } else {
                char_count[str[idx] - 'a']--;
            }
        }
        if (!is_possible) {
            std::vector<bool> out(queries.size(), false);
            return out;
        }

        std::vector<std::vector<int>> left_freq(len / 2, std::vector<int>(26, 0));
        left_freq[0][str[0] - 'a']++;
        for (int idx = 1; idx < len / 2; ++idx) {
            left_freq[idx] = left_freq[idx - 1];
            left_freq[idx][str[idx] - 'a']++;
        }

        std::vector<std::vector<int>> right_freq(len / 2, std::vector<int>(26, 0));
        right_freq[0][str[len - 1] - 'a']++;
        for (int idx = len - 2; idx >= len / 2; --idx) {
            right_freq[len - 1 - idx] = right_freq[len - 1 - idx - 1];
            right_freq[len - 1 - idx][str[idx] - 'a']++;
        }

        std::vector<int> not_equal(len / 2, 0);
        for (int idx = 0; idx < len / 2; ++idx) {
            not_equal[idx] = (idx > 0 ? not_equal[idx - 1] : 0) + (str[idx] != str[len - 1 - idx]);
        }

        std::vector<bool> out(queries.size(), true);
        for (size_t query_idx = 0; query_idx < queries.size(); ++query_idx) {
            int left_start = queries[query_idx][0];
            int left_end = queries[query_idx][1];
            int right_start = len - 1 - queries[query_idx][3];
            int right_end = len - 1 - queries[query_idx][2];

            if (std::min(left_start, right_start) > 0 && not_equal[std::min(left_start, right_start) - 1] > 0) {
                out[query_idx] = false;
            }
            if (std::max(left_end, right_end) < len / 2 - 1 && not_equal[len / 2 - 1] - not_equal[std::max(left_end, right_end) + 1] > 0) {
                out[query_idx] = false;
            }

            std::vector<int> left_vec = left_freq[left_end];
            if (left_start > 0) {
                Subtract(left_vec, left_freq[left_start - 1]);
            }
            std::vector<int> right_vec = right_freq[right_end];
            if (right_start > 0) {
                Subtract(right_vec, right_freq[right_start - 1]);
            }

            if (left_start < right_start) {
                std::vector<int> remove = right_freq[std::min(right_start - 1, left_end)];
                if (left_start > 0) {
                    Subtract(remove, right_freq[left_start - 1]);
                }
                Subtract(left_vec, remove);
            } else if (right_start < left_start) {
                std::vector<int> remove = left_freq[std::min(left_start - 1, right_end)];
                if (right_start > 0) {
                    Subtract(remove, left_freq[right_start - 1]);
                }
                Subtract(right_vec, remove);
            }
            if (left_end < right_end) {
                std::vector<int> remove = left_freq[right_end];
                if (std::max(right_start, left_end + 1) > 0) {
                    Subtract(remove, left_freq[std::max(right_start, left_end + 1) - 1]);
                }
                Subtract(right_vec, remove);
            } else if (right_end < left_end) {
                std::vector<int> remove = right_freq[left_end];
                if (std::max(left_start, right_end + 1) > 0) {
                    Subtract(remove, right_freq[std::max(left_start, right_end + 1) - 1]);
                }
                Subtract(left_vec, remove);
            }

            bool is_possible = true;
            for (int idx = 0; idx < 26; ++idx) {
                if (left_vec[idx] < 0 || right_vec[idx] < 0) {
                    is_possible = false;
                }
            }
            if (!is_possible) {
                out[query_idx] = false;
            }

            if (left_end < right_start) {
                int not_equal_count = not_equal[right_start - 1] - not_equal[left_end];
                if (not_equal_count) {
                    out[query_idx] = false;
                }
            } else if (right_end < left_start) {
                int not_equal_count = not_equal[left_start - 1] - not_equal[right_end];
                if (not_equal_count) {
                    out[query_idx] = false;
                }
            }

            for (int idx = 0; idx < 26; ++idx) {
                if (left_vec[idx] != right_vec[idx]) {
                    out[query_idx] = false;
                }
            }
        }
        return out;
    }


#include <cassert>

int main(){

return 0;

}
