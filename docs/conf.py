project = "onap"
release = "london"
version = "london"

author = "Open Network Automation Platform"
# yamllint disable-line rule:line-length
copyright = "ONAP. Licensed under Creative Commons Attribution 4.0 International License"

pygments_style = "sphinx"
html_theme = "sphinx_rtd_theme"
html_theme_options = {
  "style_nav_header_background": "white",
  "sticky_navigation": "False" }
html_logo = "_static/logo_onap_2017.png"
html_favicon = "_static/favicon.ico"
html_static_path = ["_static"]
html_show_sphinx = False

extensions = [
    'sphinx.ext.intersphinx',
    'sphinx.ext.graphviz',
    'sphinxcontrib.blockdiag',
    'sphinxcontrib.seqdiag',
    'sphinxcontrib.swaggerdoc',
    'sphinxcontrib.plantuml',
    'sphinx_toolbox.collapse'
]

exclude_patterns = ['archived/*.rst', '.tox']
#
# Map to 'latest' if this file is used in 'latest' (master) 'doc' branch.
# Change to {releasename} after you have created the new 'doc' branch.
#

branch = 'london'

intersphinx_mapping = {}
doc_url = 'https://docs.onap.org/projects'
master_doc = 'index'

spelling_word_list_filename='spelling_wordlist.txt'
spelling_lang = "en_GB"

#
# Example:
# intersphinx_mapping['onap-aai-aai-common'] = ('{}/onap-aai-aai-common/en/%s'.format(doc_url) % branch, None)
#

html_last_updated_fmt = '%d-%b-%y %H:%M'


def setup(app):
    app.add_css_file("css/ribbon.css")


linkcheck_ignore = [
  "https://istio-release.storage.googleapis.com/charts",
  "https://charts.bitnami.com/bitnami",
  "https://codecentric.github.io/helm-charts",
  r'http://localhost:\d+/'
]
