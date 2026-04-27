"""Sphinx configuration for SDP Powered by AI Agents course docs."""

project = "SDP Powered by AI Agents"
author = "LabSoft AI"
copyright = "2026, LabSoft AI"  # noqa: A001

extensions = [
    "myst_parser",
    "sphinx_copybutton",
]

myst_enable_extensions = ["colon_fence", "deflist"]
source_suffix = {".rst": "restructuredtext", ".md": "markdown"}
exclude_patterns = ["_build"]

html_theme = "basic"
html_static_path = ["_static"]
html_css_files = ["custom.css"]
html_title = "SDP · AI Agents"
html_show_sourcelink = False
html_show_sphinx = False
html_sidebars = {"**": ["globaltoc.html"]}

suppress_warnings = ["myst.xref_missing", "image.not_readable"]