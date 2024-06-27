# SPDX-License-Identifier: Apache-2.0

import glob

import yaml


def main():
    config = []
    scripts = glob.glob("images/*/*/*.sh")

    for script in sorted(scripts):
        _, os, release, version_data = script.split("/")
        version = version_data.replace(".sh", "")

        job = {
            "job": {
                "name": f"capo-image-elements-build-{os}-{release}-kubernetes-{version}",
                "pre-run": "playbooks/build/pre.yaml",
                "run": "playbooks/build/run.yaml",
                "vars": {
                    "os": os,
                    "release": release,
                    "script": version_data,
                },
                "files": [
                    f"images/{os}/{release}/{version}.sh",
                ]
            }
        }

        config.append(job)

    config += [
        {
            "project": {
                "check": {
                    "jobs": [job["job"]["name"] for job in config]
                },
                "gate": {
                    "jobs": [job["job"]["name"] for job in config]
                }
            }
        }
    ]
    

    with open("zuul.d/build-jobs.yaml", "w", encoding="utf-8") as f:
        f.write(yaml.dump(config))


if __name__ == "__main__":
    main()
