# SPDX-License-Identifier: Apache-2.0

import glob

import yaml

DISABLED_OS = ["rockylinux"]


def main():
    config = []
    scripts = glob.glob("images/*/*/*.sh")

    jobs = []
    for script in sorted(scripts):
        _, os, release, version_data = script.split("/")
        version = version_data.replace(".sh", "")

        if os in DISABLED_OS:
            continue

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
                ],
                "nodeset": {
                    "nodes": [
                        {
                            "name": "ubuntu-jammy",
                            "label": "jammy-4c-16g",
                        }
                    ]
                },
            }
        }

        jobs.append(job)

    config += [
        {
            "project": {
                "check": {"jobs": [job["job"]["name"] for job in jobs]},
                "gate": {"jobs": [job["job"]["name"] for job in jobs]},
            }
        }
    ] + jobs

    with open("zuul.d/build-jobs.yaml", "w", encoding="utf-8") as f:
        f.write(yaml.dump(config))


if __name__ == "__main__":
    main()
