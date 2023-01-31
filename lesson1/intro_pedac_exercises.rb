# PROBLEM:

# Given a string, write a method `palindrome_substrings` which returns
# all the substrings from a given string which are palindromes. Consider
# palindrome words case sensitive.

# Test cases:

# palindrome_substrings("supercalifragilisticexpialidocious") == ["ili"]
# palindrome_substrings("abcddcbA") == ["bcddcb", "cddc", "dd"]
# palindrome_substrings("palindrome") == []
# palindrome_substrings("") == []

# input: string
# output: array of string's
# rules:
#      Explicit requirements:
#        - Palindromes are case sensitive('aba' is a palindrome, 'Aba' is not)
#        - any substring can be a palindrome
#
#      Implicit requirements:
#        - substrings can contain other substrings that are palindromes
#            ('abcba' is a palindrome, 'bcb' is as well and both count)
#        - If the string given is empty, the array returned should be empty
