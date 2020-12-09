from docs_conf.conf import *

branch = 'latest'
master_doc = 'index'

linkcheck_ignore = [
    'http://localhost',
]

intersphinx_mapping = {}

needs_services = {
    'github-issues': {
        'url': 'https://api.github.com/',
        'need_type': 'spec',
        'max_amount': 2,
        'max_content_lines': 20,
        'id_prefix': 'GH_ISSUE_'
    },
    'github-prs': {
        'url': 'https://api.github.com/',
        'need_type': 'spec',
        'max_amount': 2,
        'max_content_lines': 20,
        'id_prefix': 'GH_PR_'
    },
    'github-commits': {
        'url': 'https://api.github.com/',
        'need_type': 'spec',
        'max_amount': 2,
        'max_content_lines': 20,
        'id_prefix': 'GH_COMMIT_'
    }
}

html_last_updated_fmt = '%d-%b-%y %H:%M'

def setup(app):
    app.add_css_file("css/ribbon_onap.css")
