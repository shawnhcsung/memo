# Graph

## Type of Graph

- Undirected Graph

  ![undirected graph](.pic/01_undirected_graph.svg)

- Directed Graph (Digraph)

  ![directed graph](.pic/01_directed_graph.svg)

- Weighted Graph

  ![weighted graph](.pic/01_weighted_graph.svg)

- Complete Graph

  ![complete graph](.pic/01_complete_graph.svg)

- Directed Acyclic Graph (DAG)

  ![directed acyclic graph](.pic/01_directed_acyclic_graph.svg)

- Tree (undirected graph with no cycles)
- Bipartite Graph

## Representing Graphs

![undirected graph](.pic/01_representing_graph.svg)

Notice that the following examples are not optimized. Since the sample tree is undirected and unweighted, there should be several choices for optimization.

### Adjacency Matrix

```c
bool matrix[11][11] = {
//  0  1  2  3  4  5  6  7  8  9  10
  { 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, // 0
  { 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0 }, // 1
  { 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, // 2
  { 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0 }, // 3
  { 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 0 }, // 4
  { 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0 }, // 5
  { 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0 }, // 6
  { 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 }, // 7
  { 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0 }, // 8
  { 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 }, // 9
  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }, // 10
};
```

- Pros
  - Simple
  - Space efficient for dense graphs
  - Edge weight lookup is O(1)
- Cons
  - Require O(V^2) space
  - Take O(V^2) to traverse all edges

### Adjacency List

```cpp
[0]: 1
[1]: 0 -> 2 -> 3 -> 4
[2]: 1
[3]: 1 -> 4
[4]: 1 -> 3 -> 5 -> 6
[5]: 4 -> 6
[6]: 4 -> 5 -> 7 -> 8
[7]: 6
[8]: 6 -> 9
[9]: 8
[10]: // node 10 is not connected to any node
```

### Edge List

Edge list cannot represent a single node.

```
[[0,1], [1,2], [1,3], [1,4], [2,1], [3,1], [3,4], [4,1], [4,3], [4,5], [4,6], [5,4], [5,6], [6,4], [6,5], [6,7], [6,8], [7,6], [8,6], [8,9], [9,8]]
```

## Traversing Graphs

Let's continue using the undirected graph in [Representing Graphs](#Representing-Graphs) section for demonstration. Let's create a graph as below:

```cpp
#include <iostream>
#include <list>
#include <algorithm> // find()
using namespace std;

class Node
{
public:
    list<Node *> neighbors; // edge list
    Node(int node);
    int id;
    void connect(Node *);
    void print();
};

Node::Node(int node)
{
    this->id = node;
}

void Node::print()
{
    for (auto &node : this->neighbors) {
        cout << node->id;
        if (node != *(--this->neighbors.end()))
            cout << ", ";
    }
    cout << endl;
}

void Node::connect(Node *target)
{
    auto node = find(this->neighbors.begin(),
                     this->neighbors.end(),
                     target);
    // skip duplicate edges
    if (node == this->neighbors.end())
        this->neighbors.push_back(target);
}

class Graph
{
public:
    list<Node> nodes;
    void add(int node);
    void link(int node1, int node2);
    void print();
    Node *exist(int node);
};

Node *Graph::exist(int new_node)
{
    for (auto &node : this->nodes) {
        if (node.id == new_node)
            return &node;
    }
    return NULL;
}

void Graph::add(int new_node)
{
    Node *node = this->exist(new_node);
    if (node != NULL) {
        cout << "Error: duplicate node: skip!" << endl;
        return;
    }
    this->nodes.push_back(Node(new_node));
}

void Graph::link(int node1, int node2)
{
    Node *one = this->exist(node1);
    Node *two = this->exist(node2);
    if (one != NULL) {
        if (two != NULL) {
            one->connect(two);
            two->connect(one);
        } else {
            cout << "Error: node `" << node2 << "` doesn't exist" << endl;
        }
    } else {
        cout << "Error: node `" << node1 << "` doesn't exist" << endl;
    }
}

void Graph::print()
{
    cout << endl;
    for (auto &node : this->nodes) {
        cout << " " << node.id << " : ";
        node.print();
    }
    cout << endl;
}

int main()
{
    Graph g;

    g.add(0); g.add(1); g.add(2); g.add(3);
    g.add(4); g.add(5); g.add(6); g.add(7);
    g.add(8); g.add(9); g.add(10);

    g.link(0, 1); g.link(1, 2); g.link(1, 3); g.link(1, 4);
    g.link(3, 4); g.link(4, 5); g.link(4, 6); g.link(5, 6);
    g.link(6, 7); g.link(6, 8); g.link(8, 9);

    g.print();

    /* output:
        0 : 1
        1 : 0, 2, 3, 4
        2 : 1
        3 : 1, 4
        4 : 1, 3, 5, 6
        5 : 4, 6
        6 : 4, 5, 7, 8
        7 : 6
        8 : 6, 9
        9 : 8
        10 :
    */

    return 0;
}
```

### Depth First Search (DFS)

- Time complexity: O(V+E)

  ```cpp
  static void __dfs(Graph *g, Node *node)
  {
      if (!node->visited) {
          node->visited = true;
          g->print();
          for (auto &neighbor : node->neighbors)
              __dfs(g, neighbor);
      }
  }

  void dfs(Graph *g)
  {
      for (auto &node : g->nodes)
          __dfs(g, &node);
  }
  ```

### Breadth First Search (BFS)

- Time complexity: O(V+E)

  ```cpp
  static void __bfs(list<Node *> *Q, Graph *g, Node *node)
  {
      if (!node->visited)
      {
          node->visited = true;
          g->print();
          for (auto &neighbor : node->neighbors) {
              if (!neighbor->visited)
                  Q->push_back(neighbor);
          }
      }
  }

  void bfs(Graph *g)
  {
      list<Node *> Q;
      for (auto &node : g->nodes) {
          __bfs(&Q, g, &node);
          while (!Q.empty()) {
              __bfs(&Q, g, Q.front());
              Q.pop_front();
          }
      }
  }
  ```

  Move the node `5` to the front to see how BFS works. Otherwise it will go sequentially.

  ```cpp
  int main()
  {
      Graph g;

      g.add(5); // <--- move to front

      g.add(0); g.add(1); g.add(2); g.add(3); g.add(4);
      g.add(6); g.add(7); g.add(8); g.add(9); g.add(10);

      g.link(0, 1); g.link(1, 2); g.link(1, 3); g.link(1, 4);
      g.link(3, 4); g.link(4, 5); g.link(4, 6); g.link(5, 6);
      g.link(6, 7); g.link(6, 8); g.link(8, 9);

      bfs(&g);

      return 0;
  }
  ```

## Common Problems

### Connectivity

- Union find data structure, DFS, BFS

### Shortest Path Problem

- BFS, Dijkstra's, Bellman-Ford, Floyd-Warshall, A*

### Negtive cycles

- Bellman-Ford, Floyd-Warshall

### Strongly Connected Components

- Tarjan's and Kosaraju's algorithm

### Traveling Salesman Problem

- Held-Karp, 

### Bridges

### Minimum Spanning Tree (MST)

### Network Flow: Max Flow
