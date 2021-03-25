# Task Management

Tasks are implemented as C functions that:

1. Must return `void`
2. Accept only one `void*` parameter

```c
void myTask(void *pvParameters)
{
    int var = (int) pvParameters;
    for (;;)
    {
        // do something
    }
    // must be deleted before ending
    vTaskDelete(NULL);
}
```