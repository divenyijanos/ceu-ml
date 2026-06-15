This is the repository of the ["Data Science 3: Machine Learning Concepts and Tools"](https://ceu.studyguide.timeedit.net/modules/ECBS5233?type=CORE) course in the 2026/2027 Winter term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU.

## Setup

This course uses [uv](https://docs.astral.sh/uv/) for Python environment management.

### Install uv

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Set up the environment

```bash
# Install core dependencies (run once)
uv sync

# Start Jupyter
uv run jupyter notebook
```

### Heavy dependencies (class-specific)

Some classes use `tabpfn` and `sentence-transformers` (large download, requires PyTorch). Install when needed:

```bash
uv sync --extra heavy
```
