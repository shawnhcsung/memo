# Data Structure

|Data Structure    |Access|Search|Insertion|Deletion|Space  |
|------------------|------|------|---------|--------|-------|
|Array             |1     |n     |n        |n       |n      |
|Stack             |n     |n     |1        |1       |n      |
|Queue             |n     |n     |1        |1       |n      |
|Singly-Linked List|n     |n     |1        |1       |n      |
|Doubly-Linked List|n     |n     |1        |1       |n      |
|Skip List         |n     |n     |n        |n       |n·lg(n)|
|Hash Table        |-     |n     |n        |n       |n      |
|Binary Search Tree|n     |n     |n        |n       |n      |
|Cartesian Tree    |-     |n     |n        |n       |n      |
|B-Tree            |lg(n) |lg(n) |lg(n)    |lg(n)   |n      |
|Red-Black Tree    |lg(n) |lg(n) |lg(n)    |lg(n)   |n      |
|Splay Tree        |-     |lg(n) |lg(n)    |lg(n)   |n      |
|AVL Tree          |lg(n) |lg(n) |lg(n)    |lg(n)   |n      |
|KD Tree           |n     |n     |n        |n       |n      |

## Array

```cpp
int main()
{
    int a1[] = { 0, 5, 10, 15 };
    int a2[4];
    int *ap = new int[4];

    for (int i=0; i<sizeof(a1)/sizeof(int); i++)
    {
        a2[i] = a1[i];
        ap[i] = a1[i];
    }
    cout << "a1[2] = " << a1[2] << endl;      // 10
    cout << "a2[2] = " << a2[2] << endl;      // 10
    cout << "ap[2] = " << ap[2] << endl;      // 10
    cout << "*ap+2    = " << *ap+2   << endl; // 2
    cout << "*(ap+2)  = " << *(ap+2) << endl; // 10
    cout << "(*ap)+2  = " << (*ap)+2 << endl; // 2

    if (ap) free(ap);
    return 0;
}
```

## Queue

### Priority Queue

## Linked List

```cpp
#include <iostream>
using namespace std;

class Node
{
public:
    int data;
    class Node *next;
    Node(int data);
};

Node::Node(int data)
{
    this->data = data;
    this->next = NULL;
}

int main()
{
    Node *np;
    Node *root;

    np = new Node(5);
    root = np;

    np->next = new Node(10);
    np = np->next;

    np->next = new Node(15);

    while (root!=NULL)
    {
        cout << root->data << ", ";
        np = root->next;
        delete(root); // delete() is a C++ operator
                      // only use free() for malloc(), calloc() or realloc()
        root = np;
    } cout << endl;
    return 0;
}
```

## Map

|              |Map               |Unordered Map|
|--------------|------------------|-------------|
|Ordering      |increasing order  |no ordering  |
|Implementation|self balancing BST|hash table   |

## Trees

Let's insert [ 0, 9, 3, 1, 8, 2, 5 ] sequentially to the different kinds of trees below:

### Binary Tree

Without any rule, just insert the nodes in some sort of orders (ex. root -> left -> right).

  ```text
        0
      /   \
     9     3
    / \   / \
   1   8 2   5
  ```

### Binary Search Tree (BST)

Rule: `left < root < right`

```text
  0
   \
    9
   /
  3
/   \
1   8
\   /
 2 5
```

As you can see, the time complexity finding a node can be `O(n)` when the tree is extreamly imbalanced (ex. insert [ 0, 1, 2, ... 9 ] to a BST).

Implementation:

```cpp
#include <iostream>
using namespace std;

const int a[] = { 0, 9, 3, 1, 8, 2, 5 };

class BST
{
    int key;
    BST *left, *right;
public:
    BST();
    BST(int key);
    BST* insert(BST *root, int key);
    void print(BST *root);
    void print_inorder(BST *root);
    void print_preorder(BST *root);
    void print_postorder(BST *root);
};

BST::BST()
    :key(0)
    ,left(NULL)
    ,right(NULL)
{}

BST::BST(int key)
{
    this->key = key;
    this->left = this->right = NULL;
}

BST* BST::insert(BST *root, int key)
{
    if (root == NULL) return new BST(key);
    else if (key < root->key) root->left = insert(root->left, key);
    else root->right = insert(root->right, key);
    return root;
}

void BST::print_inorder(BST *root)
{
    if (root == NULL) return;
    print_inorder(root->left);
    cout << root->key << ", ";
    print_inorder(root->right);
}

void BST::print_preorder(BST *root)
{
    if (root == NULL) return;
    cout << root->key << ", ";
    print_preorder(root->left);
    print_preorder(root->right);
}

void BST::print_postorder(BST *root)
{
    if (root == NULL) return;
    print_postorder(root->left);
    print_postorder(root->right);
    cout << root->key << ", ";
}

void BST::print(BST *root)
{
    print_inorder(root);
    cout << endl;
}

int main()
{
    BST bst, *root = NULL;
    for (int i=0; i<sizeof(a)/sizeof(int); i++) {
        cout << "insert(" << a[i] << ")" << endl;
        if (i == 0) root = bst.insert(root, a[i]);
        else bst.insert(root, a[i]);
        bst.print(root);
    }

    return 0;
}

/*
insert(0)
0, 
insert(9)
0, 9, 
insert(3)
0, 3, 9, 
insert(1)
0, 1, 3, 9, 
insert(8)
0, 1, 3, 8, 9, 
insert(2)
0, 1, 2, 3, 8, 9, 
insert(5)
0, 1, 2, 3, 5, 8, 9,
*/
```

### Self-balancing BST

#### AVL Tree (Adelson-Velsky and Landis)(1962)

#### Heap

- For any given node C, if P is a parent node of C:
  - In maximum heap: P.value() >= C.value()
  - In minimum heap: P.value() <= C.value()

#### Red-Black Tree
