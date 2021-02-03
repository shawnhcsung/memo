# Concurrency Managed Workqueue (CMWQ)

CMWQ is a kernel API for handling the cases where an asynchronous process execution is required. To achieve that, an independent thread `kworker`

```text
           +--------+--------+--------+--------+
Workqueue  | work-0 | work-1 |  ....  | work-n |
           +--------+--------+--------+--------+
                |
   Worker <-----+
```

## Bottom Half (BH)
