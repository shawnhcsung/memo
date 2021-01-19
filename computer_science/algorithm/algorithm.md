# Algorithm

## Time Complexity

Reference to [Big-O Cheat Sheet](https://www.bigocheatsheet.com/)

```text
   O(n!) O(2^n)   O(n^2)                                  O(lg(n))
     |     |        |                                      __/
     |     |        |                                  ___/
     |     |        /                              ___/
     |     |       /                           ___/
     |     /      /                        ___/
     |    |     /                      ___/
     |   /     /                  ____/
    /   |    _/              ____/
   |   /   _/         ______/                              __ O(n)
  /  _/ __/    ______/                    ________________/
 | _/__/______/         ________________/
/_/_/_/________________/_____________________________________ O(lg(n)), O(1)
```

O(n!) > O(2^n) > O(n^2) > O(n·lg(n)) > O(n) > O(lg(n)) > O(1)

## Sorting

|Algorithm     |Best `Ω` |Avg. `Θ` |Worst `O`|Space `O`|Note|
|--------------|---------|---------|---------|---------|----|
|Quicksort     |n·lg(n)  |n·lg(n)  |n^2      |lg(n)    |
|Mergesort     |n·lg(n)  |n·lg(n)  |n·lg(n)  |n        |
|Heapsort      |n·lg(n)  |n·lg(n)  |n·lg(n)  |1        |
|Timsort       |n        |n·lg(n)  |n·lg(n)  |n        |
|Bubble Sort   |n        |n^2      |n^2      |1        |
|Insertion Sort|n        |n^2      |n^2      |1        |Good for sorting small array|
|Selection Sort|n^2      |n^2      |n^2      |1        |
|Tree Sort     |n·lg(n)  |n·lg(n)  |n^2      |n        |
|Shell Sort    |n·lg(n)  |n·lg(n)^2|n·lg(n)^2|1        |
|Bucket Sort   |nk       |nk       |n^2      |n        |
|Radix Sort    |n+k      |n+k      |n+k      |n+k      |
|Counting Sort |nk       |nk       |nk       |k        |
|Cubesort      |n        |n·lg(n)  |n·lg(n)  |n        |

### Quick Sort

```cpp
#include <iostream>
#include <vector>
using namespace std;

// 1. Select an element of array as pivot
//    Can pick the first, the last, or a random element as pivot.
//    Here we choose the last element as pivot in the following example
// 2. Sort the elements in array that are less than the pivot to left and others to right
// 3. Sort the sub array on the left side and the right side recursively with this rule

void output(vector<int> *arr)
{
    for (auto i=arr->begin(); i!=arr->end(); i++) {
        cout << *i << ", ";
    } cout << endl;
}

class Quicksort
{
public:
    void sort(vector<int> *arr);
private:
    void __sort(vector<int> *arr, int lo, int hi);
    int partition(vector<int> *arr, int lo, int hi);
};

void Quicksort::sort(vector<int> *arr)
{
    if (arr == NULL) return;
    this->__sort(arr, 0, arr->size()-1);
}

void Quicksort::__sort(vector<int> *arr, int lo, int hi)
{
    int pivot;

    if (arr == NULL) return;
    if (lo < hi) {
        pivot = this->partition(arr, lo, hi);
        output(arr);
        __sort(arr, lo, pivot-1);
        __sort(arr, pivot+1, hi);
    }
}

// this function will divide the array into 3 parts:
// [ < pivot ], pivot, [ > pivot ]
int Quicksort::partition(vector<int> *arr, int lo, int hi)
{
    int pivot, start, i;

    if (arr == NULL) return -1;

    pivot = arr->at(hi);
    start = lo;

    for (i=lo; i<=hi-1; i++) // hi-1: since arr[hi] is the pivot
    {
        if (arr->at(i) < pivot) {
            iter_swap(arr->begin()+i, arr->begin()+start);
            start++;
        }
    }

    // insert the pivot element between left(< pivot) and right(> pivot)
    iter_swap(arr->begin()+i, arr->begin()+start);
    return start;
}

int main()
{
    vector<int> arr = { 0, 9, 3, 1, 8, 2, 5 };
    Quicksort quick;
    quick.sort(&arr);
    output(&arr);
    return 0;
}
```

### Heap Sort

```cpp
#include <iostream>
#include <vector>
#include <algorithm> // heap
using namespace std;

void print(vector<int> &v)
{
    for (auto i=v.begin(); i!=v.end(); i++)
        cout << *i << ", ";
    cout << endl;
}

int main()
{
    vector<int> v = { 0, 9, 3, 1, 8, 2, 5 };
    make_heap(v.begin(), v.end());
    print(v); // 9, 8, 5, 1, 0, 2, 3,

    pop_heap(v.begin(), v.end());
    v.pop_back();
    print(v); // 8, 3, 5, 1, 0, 2,

    v.push_back(11);
    push_heap(v.begin(), v.end());
    print(v); // 11, 3, 8, 1, 0, 2, 5,

    sort_heap(v.begin(), v.end());
    print(v); // 0, 1, 2, 3, 5, 8, 11,

    return 0;
}
```

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
