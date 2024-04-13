def fibonacci_below(n):
    a, b = 0, 1
    while a < n:
        print(a, end=" ")
        a, b = b, a + b


fibonacci_below(5)


"""
0 1 1 2 3 
"""

# %%
# The marker above separates the code below into a different cell

fibonacci_below(10)


"""
0 1 1 2 3 5 8 
"""
