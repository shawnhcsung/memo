# `sed`

## Use Cases

### Substituting text

- `s`: To substitute string
- `g`: Apply the replacement to all matches to the regexp

Replace the first match only

```bash
$ echo "to live and to live totally" | sed 's/live/think'
to think and to live totally
#  ^^^^^
```

Add `g` to the regexp to replace all the matches

```bash
$ echo "to live and to live totally" | sed 's/live/think/g'
to think and to think totally
#  ^^^^^        ^^^^^
```

Add `\` to the font of special characters

```bash
$ echo "to live and to live totally" | sed 's/live/\\live\//g'
to \live/ and to \live/ totally
```

### Removing trailing whitespace

Refer to [Regular Expressions](#Regular\ Expressions) for more details.

```bash
$ echo "trailing whitespace   <" | sed 's/[[:space:]]*<$/</'
trailing whitespace<
```

- I add `<` at the end of string for better demonstration. Can replace the regexp with `s/[[:space:]]*$//` for regular use cases.

### Removing leading whitespace

```bash
$ echo "   remove leading whitespace" | sed 's/^[[:space:]]*//'
remove leading whitespace
```

### Deleting lines that contain a specific string

```bash
$ echo -e "first\nthe second line\nthird" | sed '/second/d'
first
third
```

### Replacing the value of the variable

```bash
$ echo "SOMETHING=any" | sed 's/\(SOMETHING=\).*/\1new/'
SOMETHING=new
```

- The string `SOMETHING` within `\(` and `\)` will be treated as the first parameter `\1`
- Use double quote if you wanna use variable here:

  ```bash
  sed "s/\(SOMETHING\).*/\1$VAR/"
  ```

## Regular Expressions

Reference: [Wikibooks: Regular Expressions](https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions)

### POSIX Basics

| Meta  | Description                                         |
|-------|-----------------------------------------------------|
| `.`   | Any single character                                |
| `*`   | Match the preceding element zero or more times      |
| `^`   | The starting position within the string             |
| `$`   | The ending positions of the string (before newline) |
| `[ ]` | Characters contained within the brackets            |
| `( )` | The string within can be recalled later             |

### POSIX Classes

| Class        | Characters             |
|--------------|------------------------|
| `[:digit:]`  | `[0-9]`                |
| `[:lower:]`  | `[a-z]`                |
| `[:upper:]`  | `[A-Z]`                |
| `[:xdigit:]` | `[0-9A-Fa-f]`          |
| `[:alpha:]`  | `[[:upper:][:lower:]]` |
| `[:alnum:]`  | `[[:alpha:][:digit:]]` |
| `[:punct:]`  | `[.,!?:...]`           |
| `[:blank:]`  | `[ \t]`                |
| `[:space:]`  | `[ \t\n\r\f\v]`        |
| `[:graph:]`  | `[^[:space:]]`         |
| `[:print:]`  | `[^\t\n\r\f\v]`        |
| `[:cntrl:]`  |                        |
