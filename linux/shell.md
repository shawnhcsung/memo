# Shell

## What is Shell?

Shell is a standard operating system interface defined by IEEE ([1003.1&trade;-2017](https://pubs.opengroup.org/onlinepubs/9699919799/)). There are many implementations such as `bash`, `zsh`, `dash` ...etc. The command `sh` is usually linked to the actual shell program you're using in the system. For example:

```bash
> ls -lah $(which sh)
lrwxrwxrwx 1 root root 4 May 22 20:29 /usr/bin/sh -> bash
```

## Statement

### `if-else-elif`

```bash
if [ $1 -lt 10 ]; then
  echo "$1 < 10"
elif [ $1 -gt 30 ] && [ $1 -lt 40 ]; then # multiple conditions
  echo "30 < $1 < 40"
else
  echo "something else"
fi
```

### `case`

```bash
case "$1" in
car) echo "this is a car" ;;
dog) echo "this is a dog" ;;
  *) echo "unknown" ;;
esac
```

## Loop

### `for`

```bash
for (( i=0; i<10; i++ )); do
  echo $i
done
```

### `while`

```bash
i=0
while [ $i -lt 10 ]; do
  echo $i
  i = $((i+1))
done
```

## Array

```bash
BAG=()
BAG+=("pen")
BAG+=("apple")

echo "there are ${#BAG[@]} items in your bag:"
for i in ${BAG[@]}; do
  echo $i
done
```

The next example operates like an array but actually it's just a string. This trick can be done because of **Internal Field Separator** ([IFS](https://bash.cyberciti.biz/guide/$IFS)).

```bash
BAG="pen apple"
for i in $BAG; do
  echo $i
done
```

- The default value of IFS is `<space><tab><newline>`, so the for-loop will cut the string using `<space>` character. Since IFS is a variable in shell, we can change it as the following example:

  ```bash
  IFS="$IFS,"
  BAG="pen, apple"
  for i in $BAG; do
    echo $i
  done
  ```

## Function

```bash
my_func() {
  # try to remove `local` here and see the difference
  local msg = "hello"
  echo "$msg, $1"
}

msg="say something"
my_func "$msg"

echo $msg
```

- By adding `local` prefix to the variable, we can avoid affecting the world outside of the function
- `$1` represents the 1st parameter passed into the function, `$2` is the 2nd one and so on.

## Random

```bash
RANDOM=$$ # seed (optional)
while true; do
  num=$((RANDOM % 100 + 1))
  echo $num
  [ $num -gt 50 ] && break
done
```

- `$RANDOM` variable is maintained by shell

## Return Value

The execution result of the previous command will be saved at `$?` variable.

```bash
> find /bin/something
find: ‘/bin/something’: No such file or directory
> echo $?
1
> find /bin/test
/bin/test
> echo $?
0
```

Notice that in shell script, `0` means true and `1` means false. This is because one command will return `0` if it's executed successfully. For example:

```bash
if true; then
  echo "this is true"
fi
```

- The `true` is a command instead of a variable

  ```bash
  > which true
  /usr/bin/true
  > true; echo $?
  0
  > false; echo $?
  1
  ```

So whenever you write a function, don't forget to return `0` for true and `1` for false:

```bash
hit() {
  [ "$1" == "target" ] && return 0 # true
  return 1 # false
}

if hit "$1"; then
  echo "hit!"
else
  echo "miss"
fi
```
