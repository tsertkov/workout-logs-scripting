# Workout: Logs scripting

This repo contains scripts for playing around following topics:

- Emitting log stream
- Graphing log stream
- Processing log stream

## Prerequisites

Docker, `make`, and `bash` must be available.

## Usage

Run `make` to recreate all artifacts.

> NB! It will take a lot of time to build docker images on first run.

- `make all-browser`: Open `js-all-in-one/index.html` in browser.
- `make all-perl`: Run all perl parts sequentially (See `part-*/perl/`).
- `make all-bash`: Run all bash parts sequentially (See `part-*/bash/`).
- `make all-python`: Run all bash parts sequentially (See `part-*/python/`).
- `make stream-bash`: Build all artifacts with streams using bash into `stream-artifacts/`.
- `make stream-perl`: Build all artifacts with streams using perl into `stream-artifacts/`.
- `make stream-python`: Build all artifacts with streams using python into `stream-artifacts/`.

```bash
$ time (make stream-perl)
>> Building all artifacts with streams (using perl).
>> Done. See files in stream-artifacts/ directory.
( make stream-perl; )  0.06s user 0.10s system 5% cpu 2.957 total
```

## Example artifacts

### RRDTool (Bash)
![image](https://user-images.githubusercontent.com/5339042/52972072-f3936400-33b9-11e9-97e6-8708d302dd6a.png)

### GD::Graph (Perl)
![image](https://user-images.githubusercontent.com/5339042/52972160-32c1b500-33ba-11e9-821d-d8653e55eaaa.png)

### Matplotlib (Python)
![image](https://user-images.githubusercontent.com/5339042/53340351-1ae1b800-3909-11e9-96a4-df77397cfcbd.png)

### D3 (JavaScript)
![image](https://user-images.githubusercontent.com/5339042/53764157-c9b76280-3ecc-11e9-9127-c99b1d54ddf9.png)

