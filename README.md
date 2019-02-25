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

### RRDTool
![image](https://user-images.githubusercontent.com/5339042/52972072-f3936400-33b9-11e9-97e6-8708d302dd6a.png)

### GD::Graph
![image](https://user-images.githubusercontent.com/5339042/52972160-32c1b500-33ba-11e9-821d-d8653e55eaaa.png)

