## RV32I

### Instruction Types

| Type | Description               |
|------|---------------------------|
| R    | Register to register      |
| I    | Short immediate and loads |
| S    | Stores                    |
| B    | Branches (conditional)    |
| U    | Long immediate (Upper?)   |
| J    | Jumps (unconditional)     |

```
    31           25 24     20 19     15 14   12 11           7 6      0
   +---------------+---------+---------+-------+--------------+--------+
R: |      func7    |   rs2   |   rs1   | func3 |      rd      | opcode |
I: | [11:0]                  |   rs1   | func3 |      rd      | opcode |
S: | [11:5]        |   rs2   |   rs1   | func3 | [4:0]        | opcode |
B: | [12] | [10:5] |   rs2   |   rs1   | func3 | [4:1] | [11] | opcode |
U: | [31:12]                                   |      rd      | opcode |
J: | [20] |  [10:1]   | [11] |     [19:12]     |      rd      | opcode |
   +---------------+---------+---------+-------+--------------+--------+
```
