# Time and Delay

```c
struct timespec64 start;
struct timespec64 end;
struct timespec64 temp;
uint32_t duration; // us

ktime_get_ts64(&start);
ktime_get_ts64(&end);

temp = timespec64_sub(end, start);
duration = temp.tv_sec * USEC_PER_SEC;
duration += temp.tv_nsec / NSEC_PER_USEC;
```
