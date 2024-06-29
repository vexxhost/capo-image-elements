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

        build_job = {
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
                    "^elements/",
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

        jobs.append(build_job)

        upload_job = {
            "job": {
                "name": f"capo-image-elements-promote-{os}-{release}-kubernetes-{version}",
                "parent": f"capo-image-elements-build-{os}-{release}-kubernetes-{version}",
                "post-run": "playbooks/build/post.yaml",
            },
        }

        jobs.append(upload_job)

    config += [
        {
            "project": {
                "check": {"jobs": [job["job"]["name"] for job in jobs if "build" in job["job"]["name"]]},
                "gate": {"jobs": [job["job"]["name"] for job in jobs if "build" in job["job"]["name"]]},
                "promote": {"jobs": [job["job"]["name"] for job in jobs if "promote" in job["job"]["name"]]},
            }
        }
    ] + jobs

    with open("zuul.d/build-jobs.yaml", "w", encoding="utf-8") as f:
        f.write(yaml.dump(config))


if __name__ == "__main__":
    main()
