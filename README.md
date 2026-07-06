# app-container

A monorepo of purpose-built OCI/container images used across our CI/CD build
pipelines and lab deployments. Each top-level directory is one independent image
project that shares a common build convention.

## Repository layout

```
app-container/
├── base_images.sh          # Central pin of every base image (single source of truth)
├── include.mk              # Shared make targets used by every project
├── Makefile                # Repo-wide lint aggregator (shellcheck + hadolint)
├── <project>/              # One directory per image, e.g. activemq, net-snmp, frrouting
│   ├── Dockerfile.tpl      # Template; `${VAR}` values are filled from version-lock.sh
│   ├── Makefile            # One line: `include ../include.mk`
│   ├── version-lock.sh     # Pinned versions/vars for this image (sourced at build)
│   ├── release.tag         # Published image name + tag, e.g. `activemq:6.1.3.20240919`
│   └── build/              # Local OCI build artifacts (git-ignored)
└── .github/
    ├── workflows/build.yml # CI: lint, discover changed projects, build/publish
    └── renovate.json       # Automated base-image + GitHub Actions updates
```

The `Dockerfile` in each project is **generated** from `Dockerfile.tpl` by
`envsubst` and is git-ignored — never edit or commit it.

## Build a single image locally

From inside a project directory:

```bash
cd net-snmp
make oci                    # generate Dockerfile, lint, build a local OCI image
make oci SINGLE_ARCH=linux/arm64
make clean                  # remove generated Dockerfile, artifacts, builder
make help                   # full target list
```

`make oci` writes the image archive to `build/<project>_<arch>.oci`.

Required tooling: `docker` (with buildx), `envsubst` (gettext), `shellcheck`,
`hadolint`.

## Publishing

Publishing is normally done by CI, but can be run manually:

```bash
make publish \
  CONTAINER_REGISTRY=quay.io \
  CONTAINER_REGISTRY_REPO=labmonkeys \
  CONTAINER_REGISTRY_LOGIN=... \
  CONTAINER_REGISTRY_PASS=...
```

Published tags are treated as **immutable**. `make publish` refuses to overwrite
an existing tag; `make publish-force` overrides that (use with care — it can
break downstream CI/CD).

## Adding a new image

1. Create a directory named after the image and add:
   - `Makefile` containing only `include ../include.mk`
   - `Dockerfile.tpl` starting with `FROM "${BASE_IMAGE}"` and using
     `${VAR}` placeholders for anything version-specific
   - `version-lock.sh` that `source ../base_images.sh`, exports the VCS/date
     labels, sets `BASE_IMAGE`, and pins the image-specific versions
     (copy an existing project such as `net-snmp/` as a starting point)
   - `release.tag` with the `name:tag` to publish
   - `build/.gitkeep`
2. That's it — CI discovers the new directory automatically (any directory with
   a `Dockerfile.tpl`); no workflow edit is needed.

Prefer pinning base images in `base_images.sh` rather than hard-coding a tag in
a `Dockerfile.tpl`, so Renovate can keep them current.

## Continuous integration

`.github/workflows/build.yml` runs on every push to `main` and on pull requests:

- **lint** — `make shellcheck` and `make hadolint` across the whole repo.
- **discover** — computes which project directories changed. A change to a
  shared file (`base_images.sh`, `include.mk`, root `Makefile`, or the workflow)
  rebuilds every project.
- **build** — a matrix over the changed projects. Pull requests run `make oci`
  (build only); pushes to `main` run `make publish` with a `.b<run-number>`
  suffix.

Registry credentials are provided as repository secrets: `CONTAINER_REGISTRY`,
`CONTAINER_REGISTRY_REPO`, `CONTAINER_REGISTRY_LOGIN`, `CONTAINER_REGISTRY_PASS`.

## Dependency updates

`.github/renovate.json` keeps dependencies current:

- Base images pinned in `base_images.sh` (via a custom regex manager).
- GitHub Actions, pinned to immutable SHAs with the semver retained in a comment.

## License

MIT — see [LICENSE](LICENSE).
