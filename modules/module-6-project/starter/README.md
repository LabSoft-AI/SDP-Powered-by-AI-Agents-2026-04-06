# Sphinx Documentation Starter

Starter files for building a Sphinx documentation site for your kata project.

## Files

| File | Purpose |
|------|---------|
| `conf.py` | Sphinx configuration — update project name, author, GitHub URL |
| `index.rst` | Main index — add your architecture chapters and user story files |
| `requirements.txt` | Python dependencies for Sphinx |
| `Makefile` | Build commands (`make html`, `make clean`) |

## Setup

### 1. Copy to your docs folder

```bash
cp -r modules/module-6-project/starter/* docs/
```

### 2. Edit `conf.py`

Replace the TODO placeholders:

```python
project = "Mars Rover"              # Your kata name
copyright = "2026, Your Name"       # Your name
author = "Your Name"                # Your name

html_theme_options = {
    "project_name": "Mars Rover",   # Your kata name
    "github_url": "https://github.com/YOUR_USERNAME/YOUR_REPO",
}
```

### 3. Edit `index.rst`

Update the toctree entries to match your actual file paths:

```rst
.. toctree::
   :caption: Architecture:

   architecture/01-introduction-and-goals
   architecture/02-constraints
   ...

.. toctree::
   :caption: User Stories:

   user-stories/README
   user-stories/rover-control
   user-stories/grid-map
```

### 4. Install dependencies and build

```bash
pip install -r docs/requirements.txt
cd docs && make html
```

### 5. Preview locally

```bash
open docs/_build/html/index.html
# or
python -m http.server -d docs/_build/html 8000
```

## GitHub Pages Deployment

Add `.github/workflows/docs-deploy.yml` to auto-deploy on changes.
Your Sphinx agent can help you create this workflow.
