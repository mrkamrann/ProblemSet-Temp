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
The length of str should be even 
The length of queries should be at least 1 and at most 10^5 inclusive.
Each vector queries[i] should have exactly 4 elements.
The value of left_start should be in the range [0, len / 2 - 1] inclusive.
The value of left_end should be in the range [0, len / 2 - 1] inclusive.
The value of right_start should be in the range [len / 2 , len - 1] inclusive.
The value of right_end should be in the range [len / 2, len - 1] inclusive.
The value of left_end should be greater than equal to left_start
The value of right_end should be greater than equal to right start
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
        
        if (str.size() < 2 || str.size() > 100000 || str.size() % 2 != 0) {
    throw std::invalid_argument("The length of str should be at least 2 and at most 10^5 inclusive and length should be even.");
}

if (queries.size() < 1 || queries.size() > 100000) {
    throw std::invalid_argument("The length of queries should be at least 1 and at most 10^5 inclusive.");
}
    
       int len = str.size();
   int len_2 = len / 2; 

for (size_t query_idx = 0; query_idx < queries.size(); ++query_idx) {
    if (queries[query_idx].size() != 4) {
        throw std::invalid_argument("Each vector queries[i] should have exactly 4 elements.");
    }
    
    int left_start = queries[query_idx][0];
    int left_end = queries[query_idx][1];
    int right_start = queries[query_idx][2];
    int right_end = queries[query_idx][3];
    
  
     
    if (left_start < 0 || left_start >= len_2) {
        throw std::invalid_argument("The value of left_start should be in the range [0, len / 2) inclusive.");
    }
    
    if (left_end < 0 || left_end >= len_2) {
        throw std::invalid_argument("The value of left_end should be in the range [0, len / 2) inclusive.");
    }
  
     if (left_end < left_start) {
        throw std::invalid_argument("The value of left_end should be greater than equal to left_start.");
    }
    
    if (right_start < str.size() / 2 || right_start >= str.size()) {
        throw std::invalid_argument("The value of right_start should be in the range [len / 2, len) inclusive.");
    }
    
    if (right_end < str.size() / 2 || right_end >= str.size()) {
        throw std::invalid_argument("The value of right_end should be in the range [len / 2, len) inclusive.");
    }
  
    if (right_end < right_start) {
        throw std::invalid_argument("The value of right_end should be greater than equal to right start.");
    }
    
}

for (char character : str) {
    if (character < 'a' || character > 'z') {
        throw std::invalid_argument("str consists of only lowercase English letters.");
    }
}

        
    
  
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

// TEST  
std::string str_1 = "abcdef";
std::vector<std::vector<int>> queries_1 = {{0, 1, 4, 5}, {1, 2, 4, 5}, {0, 0, 3, 3}};
std::vector<bool> expected_1 = {false, false, false};
std::vector<bool> result_1 = CanMakePalindromeQueries(str_1, queries_1);
assert(result_1 == expected_1);
// TEST_END
  

// TEST 
std::string str_2 = "abcdea";
std::vector<std::vector<int>> queries_2 = {{0, 1, 3, 3}, {1, 2, 3, 4}, {0, 0, 4, 4}};
std::vector<bool> expected_2 = {false, false, false};
std::vector<bool> result_2 = CanMakePalindromeQueries(str_2, queries_2);
assert(result_2 == expected_2);
// TEST_END

// TEST 
std::string str_3 = "aaaabbbb";
std::vector<std::vector<int>> queries_3 = {{0, 1, 4, 5}, {1, 2, 4, 5}, {0, 0, 4, 6}};
std::vector<bool> expected_3 = {false, false, false};
std::vector<bool> result_3 = CanMakePalindromeQueries(str_3, queries_3);
assert(result_3 == expected_3);
// TEST_END

// TEST 
std::string str_4 = "abcabc";
std::vector<std::vector<int>> queries_4 = {{1, 1, 3, 5}, {0, 2, 5, 5}};
std::vector<bool> expected_4 = {true, true};
std::vector<bool> result_4 = CanMakePalindromeQueries(str_4, queries_4);
assert(result_4 == expected_4);
// TEST_END

// TEST 
std::string str_5 = "acbcab";
std::vector<std::vector<int>> queries_5 = {{1, 2, 4, 5}};
std::vector<bool> expected_5 = {true};
std::vector<bool> result_5 = CanMakePalindromeQueries(str_5, queries_5);
assert(result_5 == expected_5);
// TEST_END

// TEST 
std::string str_6 = "xyzyxa";
std::vector<std::vector<int>> queries_6 = {{0, 1, 3, 5}, {1, 2, 4, 5}, {0, 0, 4, 4}};
std::vector<bool> expected_6 = {false, false, false};
std::vector<bool> result_6 = CanMakePalindromeQueries(str_6, queries_6);
assert(result_6 == expected_6);
// TEST_END

// TEST 
std::string str_7 = "abcddcba";
std::vector<std::vector<int>> queries_7 = {{0, 1, 4, 4}, {2, 3, 4, 6}, {1, 2, 5, 5}};
std::vector<bool> expected_7 = {true, true, true};
std::vector<bool> result_7 = CanMakePalindromeQueries(str_7, queries_7);
assert(result_7 == expected_7);
// TEST_END

// TEST 
std::string str_8 = "aaaabbbbccccdddd";
std::vector<std::vector<int>> queries_8 = {{0, 2, 8, 9}, {1, 3, 10, 13}, {0, 1, 11, 14}};
std::vector<bool> expected_8 = {false, false, false};
std::vector<bool> result_8 = CanMakePalindromeQueries(str_8, queries_8);
assert(result_8 == expected_8);
// TEST_END
  

// TEST 
std::string str_9 = "abcdedcbaa";
std::vector<std::vector<int>> queries_9 = {{0, 2, 5, 5}, {1, 3, 6, 8}, {0, 1, 6, 7}};
std::vector<bool> expected_9 = {false,false, false};
std::vector<bool> result_9 = CanMakePalindromeQueries(str_9, queries_9);
assert(result_9 == expected_9);
// TEST_END


// TEST
  
std::string str_10 = "a";
std::vector<std::vector<int>> queries_10 = {{0, 1, 1, 2}};
try {
    CanMakePalindromeQueries(str_10, queries_10);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_11 = "abc";
std::vector<std::vector<int>> queries_11;
try {
    CanMakePalindromeQueries(str_11, queries_11);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_12 = "abc";
std::vector<std::vector<int>> queries_12 = {{0, 1, 2}};
try {
    CanMakePalindromeQueries(str_12, queries_12);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_13 = "abcdefg";
std::vector<std::vector<int>> queries_13 = {{4, 5, 6, 7}};
try {
    CanMakePalindromeQueries(str_13, queries_13);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
  
std::string str_14 = "abcdefg";
std::vector<std::vector<int>> queries_14 = {{0, 1, 6, 7}};
try {
    CanMakePalindromeQueries(str_14, queries_14);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_15 = "abcdefg";
std::vector<std::vector<int>> queries_15 = {{0, 1, 2, 3}};
try {
    CanMakePalindromeQueries(str_15, queries_15);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_16 = "abcdefg";
std::vector<std::vector<int>> queries_16 = {{0, 1, 2, 5}};
try {
    CanMakePalindromeQueries(str_16, queries_16);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_17 = "abC";
std::vector<std::vector<int>> queries_17 = {{0, 1, 2, 3}};
try {
    CanMakePalindromeQueries(str_17, queries_17);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST
  
std::string str_18 = "abc";
std::vector<std::vector<int>> queries_18 = {{0, 1, 2, 3}};
try {
    CanMakePalindromeQueries(str_18, queries_18);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

// TEST 
  
std::string str_19 = "abcde";
std::vector<std::vector<int>> queries_19;
try {
    CanMakePalindromeQueries(str_19, queries_19);
    assert(false);
} catch (const std::invalid_argument& e) {
    assert(true);
}
// TEST_END

return 0;

}
