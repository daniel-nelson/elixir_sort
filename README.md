# Various Sorts

## ParallelSort

ParallelSort was inspired by my parallel computing class back in college when we looked at bubble sort being O(N) given N processors. This implementation turned out to be terribly slow. Of course, my Mac only has 4 processors, but even so, this turned out to be terribly slow.

## MergeSort

I wanted to see if I could come up with merge sort without having looked at the algorithm in 20 years and to see how it played out in a functional language. Very elegantly. I took the tail call optimization route first, because that seemed to play to a strength of Elixir. Indeed, it performs consistently faster than the non-tail-call-optimized version, even though it ends up needing to reverse lists a lot.

## QuickSort

Perhaps it's my implementation, or perhaps a function of the immutable context of Elixir, but QuickSort performed significantly slower than either MergeSort implementation.
