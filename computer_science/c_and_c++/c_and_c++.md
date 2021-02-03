# C/C++

## Compilation of a C program

> The following examples are created with gcc 9.3.0.

The compile process of a C executable file is as below:

```text
source      expended      assembly      object      executable
code    ->  code      ->  code      ->  code    ->  file
  (preprocessor)  (compiler)    (assembler)   (linker)
```

- Pre-processing (expended code)
  - Run `gcc -E ${source}` will output the preprocessed result
    - `-E`: Preprocess only; do not compile, assemble or link
- Compilation (assembly code)
  - Run `gcc -S ${source}` can output the compiled assembly code
    - `-S`: Compile only; do not assemble or link
- Assembly (object code)
  - Run `gcc -c ${source}` to generate the object code
    - `-c`: Compile and assemble, but do not link
- Linking (executable)

For example:

```cpp
#define MAX(a,b) ((a < b) ? (b) : (a))
int main() {
    return MAX(3, 8);
}
```

`g++ -E test.cpp`:

- Refer to [preprocessor output format](https://gcc.gnu.org/onlinedocs/cpp/Preprocessor-Output.html) for more details

```text
# 1 "test.cpp"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "test.cpp"

int main() {
    return ((3 < 8) ? (8) : (3));
}
```

`g++ -S test.cpp`:

```asm
    .file    "test.cpp"
    .text
    .globl    main
    .type     main, @function
main:
.LFB0:
    .cfi_startproc
    endbr64
    pushq    %rbp
    .cfi_def_cfa_offset 16
    .cfi_offset 6, -16
    movq    %rsp, %rbp
    .cfi_def_cfa_register 6
    movl    $8, %eax
    popq    %rbp
    .cfi_def_cfa 7, 8
    ret
    .cfi_endproc
.LFE0:
    .size     main, .-main
    .ident    "GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
    .section  .note.GNU-stack,"",@progbits
    .section  .note.gnu.property,"a"
    .align 8
    .long     1f - 0f
    .long     4f - 1f
    .long     5
0:
    .string   "GNU"
1:
    .align 8
    .long     0xc0000002
    .long     3f - 2f
2:
    .long     0x3
3:
    .align 8
4:

```

## Memory Segments of C Programs

```text
high    --> +-------------+
address     | system      | (environment variables)
            +-------------+
            | stack       |
            +-------------+
            |      ↓      |
            |             |
            | free memory |
            |             |
            |      ↑      |
            +-------------+
            | heap        |
            +-------------+
            | bss         | (uninitialized variables)
            +-------------+
            | data        | (initialized variables)
            +-------------+
low         | text        | (code segment)
address --> +-------------+
```

- **Text**: aka code segment, contains executable instructions
  - The text segment is usually placed below the heap or stack to prevent overflows from overwriting it
  - This segment is sharable, only a single copy needs to be in memory
- **Data**: stores the global, static constant and external variables that are already initialized
  - Initialized data segment
- **BSS**: named after an ancient assembler operator "block started by symbol"
  - Uninitialized data segment
  - The bss segment stores the uninitialized static and global variables
  - Data in this segment will be initialized to 0
  - Uninitialized variables do not have to occupy actual disk space in the objet file
- **Heap**: stores the variables that are allocated by `malloc()` or other variances
  - The heap requires pointers to access it
  - The memory is not allocated discontinuously
  - The size is limited by the physical memory
- **Stack**: stores local variables (automatic, continuous memory)
  - The stack is managed by the CPU, the programer has no ability to modify it
  - Variables are allocated continuously and freed automatically
  - The stack grows and shrinks as long as the local variables are created and destroyed

For example:

```cpp
#include <iostream>
using namespace std;

int main() {
    return 0;
}
```

```bash
# dec = text + data + bss
$ g++ test.cpp && size a.out
   text    data     bss     dec     hex filename
   1985     640       8    2633     a49 a.out

$ g++ --version
g++ (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
```

```cpp
#include <iostream>
using namespace std;

int main() {
    static int i = 0;
}
```

## Qualifiers

- Global variables
  - Being defined outside the function
  - Having external linkage that can be accessed from other files with the same variable name
- `extern`

  g.cpp:
  ```c
  int g = 10; // global variable
  ```

  main.cpp:
  ```c
  extern int g;
  int main() { return ++g; }
  ```

  Compile and execute:
  ```
  $ g++ main.cpp g.cpp -o test
  $ ./test; echo $?
  11
  ```

- `static` variable and function
  - What's the difference with and without `static`?
    - The variables or functions with `static` qualifier will become file scope
    - The file scope variables and functions can only be accessed within the same file
  - Difference between Global variable and static variable?
- `register`
  - The variables will have lifespan throughout the execution
  - The variables declared as `register` storage class **DO NOT** have a memory location. You'll get an error trying to access it with pointers:

    ```c
    int main() 
    { 
        register int i = 3;
        int* a = &i; 
        return 0; 
    } 
    ```

    ```bash
    $ gcc test.c
    test.c: In function ‘main’:
    test.c:4:5: error: address of register variable ‘i’ requested
    4 |     int* a = &i;
      |     ^~~
    ```

    - Notice that in C++ or other modern compilers, `register` qualifier seems being deprecated, the compiler will ignore it.

- `volatile`

  To tell the compiler not to optimize anything that has to do with the volatile variables. For example:

  ```c
  typedef struct {
      int busy;
      int data;
  } myData;

  void waiting_for_process_to_finish(myData *dp, int new_data)
  {
      while (dp->busy) {
          // do nothing, just waiting
      }
      dp->data = new_data;
  }
  ```

  Since there's no assignment for `dp->busy`, the compiler will try to be smart to read it just once, cache it, and then go into the infinite loop. You know what's going to happen.

  Simply define the variable as `volatile` to solve this problem:

  ```c
  void waiting_for_process_to_finish(volatile myData *dp, int new_data)
  {   //                             ^^^^^^^^
      while (dp->busy) {
          // do nothing, just waiting
      }
      dp->data = new_data;
  }
  ```

- `auto`

  C++ compiler will choose a correct type for the variables defined with `auto`:

  ```c
  #include <iostream>
  #include <vector>
  using namespace std;

  int main()
  {
    vector<int> v = { 2, 4, 6, 3, 5, 7, 9 };
    // auto -> int
    for (auto &i : v)
        cout << i << endl;

    // auto -> vector<int>::iterator
    for (auto i=v.begin(); i!=v.end(); i++)
        cout << *i << endl;

    return 0;
  }
  ```

## Operators Overloading

```cpp
#include <iostream>
using namespace std;

class Square
{
    public:
        int w, h;
        Square operator+(const Square& s);
};

Square Square::operator+(const Square& s)
{
    Square new_s;
    new_s.w = this->w + s.w;
    new_s.h = this->h + s.h;
    return new_s;
}

int main()
{
    Square s1, s2;
    s1.w = 3; s1.h = 4;
    s2.w = 5; s2.h = 6;
    s1 = s1 + s2;
    cout << s1.w << ", " << s1.h << endl; // 8, 10
    return 0;
}
```

## Data Structure

### Stack

```cpp
#include <iostream>
#include <stack>
using namespace std;

int main()
{
    stack<int> myStack;
    myStack.push(8);
    myStack.push(1);
    myStack.push(9);
    myStack.push(2);

    while (!myStack.empty()) {
        cout << myStack.top() << ", ";
        myStack.pop();
    }
    cout << endl; // 2, 9, 1, 8,
    return 0;
}
```

### Queue

```c++
#include <iostream>
#include <queue>
using namespace std;

int main()
{
    queue<int> q;
    q.push(5);
    q.push(10);
    q.push(15);
    cout << "q.size()  = " << q.size()  << endl; // 3
    cout << "q.front() = " << q.front() << endl; // 5
    cout << "q.back()  = " << q.back()  << endl; // 15
    return 0;
}
```

### Vector

```cpp
#include <iostream>
#include <vector>
using namespace std;

int main()
{
    vector<int> v;
    v.push_back(5);
    v.push_back(15);
    v.push_back(20);
    // `auto` will be translated to vector<int>::iterator by compiler
    for (auto i=v.begin(); i!=v.end(); i++)
        cout << *i << ", ";
    cout << endl;
    return 0;
}
```

### Unordered Map

```cpp
#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

class Solution
{
    public:
        vector<int> twoSum(vector<int> &nums, int target)
        {
            int complement, index;
            unordered_map<int, int> umap;
            for (int i=0; i<nums.size(); i++)
            {
                complement = target - nums[i];
                if (umap.count(complement))
                    return { umap[complement], i };
                umap[nums[i]] = i;
            }
        }
  };

int main()
{
    Solution s;
    vector<int> v = { 2, 7, 11, 15 };
    vector<int> result = s.twoSum(v, 18);
    for (auto i=result.begin(); i!=result.end(); i++)
        cout << *i << ", ";
    cout << endl;
    return 0;
}
```

### Heap

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
    vector<int> v = {0, 9, 3, 1, 8, 2};
    make_heap(v.begin(), v.end());
    print(v); // 9, 8, 3, 1, 0, 2,

    pop_heap(v.begin(), v.end());
    v.pop_back();
    print(v); // 8, 2, 3, 1, 0,

    v.push_back(11);
    push_heap(v.begin(), v.end());
    print(v); // 11, 2, 8, 1, 0, 3,

    sort_heap(v.begin(), v.end());
    print(v); // 0, 1, 2, 3, 8, 11,

    return 0;
}
```
