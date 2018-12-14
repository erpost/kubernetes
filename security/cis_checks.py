import os
import yaml

from pprint import pprint


kube_api_config = os.path.expanduser('/etc/kubernetes/manifests/kube-apiserver.yaml')

if os.path.isfile(kube_api_config):
    print('File Exists!')

else:
    print('Does Not Exist!')

with open('/etc/kubernetes/manifests/kube-apiserver.yaml', 'r') as apiserver_yaml:
    apiserver = yaml.load(apiserver_yaml)
    apiVersion = apiserver['apiVersion']
    kind = apiserver['kind']
    spec = apiserver['spec']
    command = apiserver['spec']['containers'][0]['command']
    # print(apiVersion)
    # print(kind)
    pprint(command)
