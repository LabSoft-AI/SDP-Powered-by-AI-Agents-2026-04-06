"""Sphinx configuration for SDP Powered by AI Agents course docs."""

# pylint: disable=invalid-name,redefined-builtin

project = "SDP Powered by AI Agents"
copyright = '2026, <a href="mailto:momo@labsoft.ai">Momcilo Krunic</a> (<a href="https://labsoft.ai">LabSoft AI</a>). Licensed under <a href="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</a>'  # noqa: A001
author = "Momcilo Krunic (LabSoft AI)"

extensions = [
    "sphinx_wagtail_theme",
    "myst_parser",
    "sphinx_copybutton",
    "sphinx_new_tab_link",
]

new_tab_link_show_external_link_icon = True

myst_enable_extensions = ["colon_fence", "deflist", "tasklist"]
source_suffix = {".rst": "restructuredtext", ".md": "markdown"}
exclude_patterns = ["_build"]

html_theme = "sphinx_wagtail_theme"
html_theme_options = {
    "project_name": "SDP · AI Agents",
    "logo": "LabSoft_Logo.png",
    "logo_alt": "LabSoft AI",
    "logo_height": 80,
    "logo_width": 73,
    "github_url": "https://github.com/LabSoft-AI/SDP-Powered-by-AI-Agents-2026-04-06/",
    "footer_links": "",
}

html_static_path = ["_static"]
templates_path = ["_templates"]
html_extra_path = ["_extra"]
html_css_files = ["custom.css"]
html_js_files = ["force-dark.js"]
html_show_sourcelink = False
html_show_sphinx = False
html_last_updated_fmt = "%b %d, %Y"

suppress_warnings = ["myst.xref_missing", "image.not_readable"]
