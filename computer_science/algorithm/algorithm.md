# Algorithm

## Time Complexity

Reference to [Big-O Cheat Sheet](https://www.bigocheatsheet.com/)


```text
   O(n!) O(2^n)   O(n^2)                                 O(lg(n))
     |     |        |                                      ___/
     |     |        |                                  ___/
     |     |        /                              ___/
     |     |       /                           ___/
     |     /      /                        ___/
     |    |     /                      ___/
     |   /     /                  ____/
    /   |    _/              ____/
   |   /   _/         ______/                              ____ O(n)
  /  _/ __/    ______/                    ________________/
 | _/__/______/         ________________/
/_/_/_/________________/_____________________________________ O(lg(n)), O(1)
```
`O(n!)` > `O(2^n)` > `O(n^2)` > `O(n·lg(n))` > `O(n)` > `O(lg(n))` > `O(1)`

## Sorting

|Algorithm     |Best `Ω` |Avg. `Θ` |Worst `O`|Space `O`|Note|
|--------------|---------|---------|---------|---------|----|
|Quicksort     |n·lg(n)  |n·lg(n)  |n^2      |lg(n)    |
|Mergesort     |n·lg(n)  |n·lg(n)  |n·lg(n)  |n        |
|Timsort       |n        |n·lg(n)  |n·lg(n)  |n        |
|Heapsort      |n·lg(n)  |n·lg(n)  |n·lg(n)  |1        |
|Bubble Sort   |n        |n^2      |n^2      |1        |
|Insertion Sort|n        |n^2      |n^2      |1        |Good for sorting small array|
|Selection Sort|n^2      |n^2      |n^2      |1        |
|Tree Sort     |n·lg(n)  |n·lg(n)  |n^2      |n        |
|Shell Sort    |n·lg(n)  |n·lg(n)^2|n·lg(n)^2|1        |
|Bucket Sort   |nk       |nk       |n^2      |n        |
|Radix Sort    |n+k      |n+k      |n+k      |n+k      |
|Counting Sort |nk       |nk       |nk       |k        |
|Cubesort      |n        |n·lg(n)  |n·lg(n)  |n        |

### Heap Sort

### Insertion Sort

```c
void insertion_sort(int a[], int len)
{
    int i, j, key;
    for (i=1; i<len; i++)
    {
        key = a[i];
        j = i-1;
        while (j>=0 && a[j]>key)
        {
            a[j+1] = a[j];
            j--;
        }
        a[j+1] = key;
    }
}
```

### Searching

- Binary Search (sorted)
