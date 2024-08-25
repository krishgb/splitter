# Splitter

### Goal - To split files in desired size.

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
