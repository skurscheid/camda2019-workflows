import requests
import json
from pprint import pprint

cases_endpt = "https://api.gdc.cancer.gov/cases"
annotations_endpt = 'https://api.gdc.cancer.gov/annotations'
files_endpt = 'https://api.gdc.cancer.gov/files'

fields = [
    "file_name",
    "cases.submitter_id",
    "cases.samples.sample_type",
    "cases.disease_type",
    "cases.project.project_id"
    ]

fields = ",".join(fields)

# look up in files DB
filt = {"op":"in",
        "content":{
        "field":"file_id",
        "value":["018cdacc-dad1-406f-ae45-1c15be6c6a57"],
   }
}

params = {'filters':json.dumps(filt), 'format':'json', 'expand':'cases.samples'} # expand parameter is supplied in search & retrieve request

# requests URL-encodes automatically
response = requests.get(files_endpt, params = params)
#response = requests.post(files_endpt, headers = {"Content-Type": "application/json"}, json = params)
pprint(response.json())

# look up in annotation DB
annotation_filter = {"op":"in",
                     "content":{
                     "field":"submitter_id",                         
                     "value":["8e5c811c-132a-4f27-b7ef-1a4a644f9079"]
                     }
                    }
params = {'filters':json.dumps(annotation_filter)}
response = requests.get(annotations_endpt, params = params)
pprint(json.dumps(response.json(), indent=2))

# look up in cases db
fields = [
    "submitter_id",
    "case_id",
    "primary_site",
    "disease_type",
    "diagnoses.vital_status"
    ]

fields = ",".join(fields)

filters = {
    "op": "in",
    "content":{
        "field": "submitter_id",
        "value": ["8e5c811c-132a-4f27-b7ef-1a4a644f9079"]
        }
    }

params = {
    "filters": json.dumps(filters),
    "fields": fields,
    "format": "json",
    "size": "2"
    }

response = requests.get(cases_endpt, params = params)
pprint(json.dumps(response.json(), indent=2))
