# Archive

## Tools

- `zip`
- `tar`
- `gzip`

## The `zip` archive

The `.zip` format is commonly supported by various kinds of OS, so I usually use this format to archive the files when sending it to a non-linux user.

### Archive multiple files or directory

Create sample files and folder:

```bash
$ mkdir my-folder
$ touch my-file1
$ touch my-file2
$ ll
total 0
drwxr-xr-x 1 shawn shawn 62 Aug 18 09:40 .
drwxr-xr-x 1 shawn shawn 24 Aug 18 09:39 ..
-rw-r--r-- 1 shawn shawn  0 Aug 18 09:40 my-file1
-rw-r--r-- 1 shawn shawn  0 Aug 18 09:40 my-file2
drwxr-xr-x 1 shawn shawn  0 Aug 18 09:40 my-folder
```

Create an archive using `zip`:

- `-r`: recurse into directories
- `-e`: encrpyt the archive

```bash
$ zip test.zip -r -e *
Enter password: 
Verify password:
adding: my-file1 (stored 0%)
adding: my-file2 (stored 0%)
adding: my-folder/ (stored 0%)
```

Now we can see an archive has been created:

```bash
$ ll
total 4.0K
drwxr-xr-x 1 shawn shawn  78 Aug 18 09:42 .
drwxr-xr-x 1 shawn shawn  24 Aug 18 09:39 ..
-rw-r--r-- 1 shawn shawn   0 Aug 18 09:40 my-file1
-rw-r--r-- 1 shawn shawn   0 Aug 18 09:40 my-file2
drwxr-xr-x 1 shawn shawn   0 Aug 18 09:40 my-folder
-rw-r--r-- 1 shawn shawn 470 Aug 18 09:42 test.zip

> file test.zip 
test.zip: Zip archive data, at least v1.0 to extract
```

List the files and direcotries in the archive but not extracting it:

```bash
$ unzip -l test.zip 
Archive:  test.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  2020-08-18 09:40   my-file1
        0  2020-08-18 09:40   my-file2
        0  2020-08-18 09:40   my-folder/
---------                     -------
        0                     3 files
```

Extract the archive:

- `-d`: extract files into exdir (will create the folder automatically)

```bash
$ unzip test.zip -d target-folder
```
