# GNU make

## Example

Makefile:

```mk
MODEL="PRJ_00F_Factory"

RESULT=$(strip \
	$(findstring 00F, $(MODEL)) \
	$(findstring 00T, $(MODEL)) \
)

$(info RESULT = "$(RESULT)")

ifneq (,$(RESULT))
	DEFINES += FACTORY
else
	$(warning general image)
endif

all:
	gcc -D$(DEFINES) test.c -o test
```

test.c:

```c
#include <stdio.h>

int main()
{
    printf("check point\n");
#ifdef FACTORY
    printf("factory image\n");
#endif
    return 0;
}
```

Output:

```
$ make
RESULT = "00F"
gcc -DFACTORY test.c -o test
$ ./test
check point
factory image
```

## Commands
