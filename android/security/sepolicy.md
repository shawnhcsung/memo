# SELinux Policy

Rules:

- Make sure the file has an empty line at the 1st and the last line. Since the rules will be concatenate into one file, it will go wrong if there is no empty line at the end of the file.

To redefine the files under `/proc`, write the rules in `genfs_contexts`:

```text
genfscon proc /driver/star/mac_addr u:object_r:my_proc:s0
genfscon proc /wifi                 u:object_r:my_proc:s0
genfscon proc /bt                   u:object_r:my_proc:s0
genfscon proc /cmdline              u:object_r:my_proc:s0
```
