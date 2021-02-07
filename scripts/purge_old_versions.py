#!/usr/bin/python3
import sys
from subprocess import check_output
from apt_pkg import version_compare, init_system
from functools import cmp_to_key

init_system()

repo = sys.argv[1]
package_name = sys.argv[2]
retain_how_many = int(sys.argv[3])

output = check_output(["aptly", "repo", "remove", "-dry-run=true", repo, package_name], encoding="utf-8")
output = [line for line in output.split("\n") if line.startswith("[-]")]
output = [line.replace("[-] ","") for line in output]
output = [line.replace(" removed","") for line in output]

def sort_cmp(name1, name2):
    version_and_build_1 = name1.split("_")[1]
    version_and_build_2 = name2.split("_")[1]
    return version_compare(version_and_build_1, version_and_build_2)

output.sort(key=cmp_to_key(sort_cmp))
should_delete = output[:-(retain_how_many+1)]

if should_delete:
    print(check_output(["aptly", "repo", "remove", repo] + should_delete, encoding="utf-8"))
else:
    print("nothing to delete")
