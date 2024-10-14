# Splitter - similar to split tool

### Build
```bash
zig build
```

### Usage:
- To split files
```bash
splitter -s [input_file_name] [parts_name] [bytes]
```

- To join files
```bash
splitter -j [parts_name] [output_file_name] [parts]
```

---

Syscall Trace
```bash
$ time strace -c ./zig-out/bin/splitter -s Monkey_man.mp4 Monkey_man_ 1gib
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 62.09    6.489657     1622414         4           write
 34.25    3.580181      895045         4           read
  3.64    0.379997       18095        21           munmap
  0.01    0.001248           4       250           msync
  0.00    0.000372          74         5           openat
  0.00    0.000200           9        21           mmap
  0.00    0.000142          35         4           close
  0.00    0.000026           5         5           rt_sigaction
  0.00    0.000012           6         2           prlimit64
  0.00    0.000008           8         1           fstat
  0.00    0.000005           5         1           gettid
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00   10.451848       32662       320           total

________________________________________________________
Executed in   45.17 secs    fish           external
   usr time    0.79 secs    0.02 millis    0.79 secs
   sys time   12.47 secs    1.24 millis   12.47 secs


$ ls -l Mon*
-rw-rw-r-- 1 deku deku 3426980906 Sep 29 23:02 Monkey_man.mp4
-rw-rw-r-- 1 deku deku 1073741824 Oct 15 00:19 Monkey_man_.part_1
-rw-rw-r-- 1 deku deku 1073741824 Oct 15 00:19 Monkey_man_.part_2
-rw-rw-r-- 1 deku deku 1073741824 Oct 15 00:19 Monkey_man_.part_3
-rw-rw-r-- 1 deku deku  205755434 Oct 15 00:19 Monkey_man_.part_4
```
