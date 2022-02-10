# Docker Image for Antora

This repository hosts the Docker image for Antora. 

## How to Use this Image

The name of the image is `quay.io/labmonkeys/antora`.
This image is published to [Quay.io](https://quay.io/repository/labmonkeys/antora).
The purpose of the image is to execute the `antora` command inside a container (as configured by the image).
Currently, this image only provides a linux/amd64 container.

### Run the Image Directly

This image is primarily designed to be used as a command in a box.
You can use this image as a replacement for the `antora` command to execute a playbook.
(The arguments that follow the name of the image are assumed to either be arguments to the `antora` command or a local command).
The benefit of using this image is that you don't have to install Antora itself.

To demonstrate how to use this image, we'll be using the https://gitlab.com/antora/demo/demo-site[Antora demo site].

Start by cloning the playbook repository for the demo site, then switch to the newly created folder:

```
$ git clone https://gitlab.com/antora/demo/demo-site.git
cd demo-site
```

Next, execute the `docker run` command to start a container process from this image, which implicitly runs the `antora` command inside the container:

```
$ docker run -v $PWD:/antora --rm -t quay.io/labmonkeys/antora --stacktrace antora-playbook.yml
```

The `-t` flag allocates a pseudo-TTY, which is required if you want to see the progress bars for git operations.

If you're running a Linux distribution that has SELinux enabled, like Fedora, you'll need to add the `:Z` (or `:z`) modifier to the volume mount.
You'll also want to add the `-u $(id -u)` option to instruct Docker to run the entrypoint command as the current user.
Otherwise, files will be written as root and thus hard to delete.
Here's the command you'll use:

```
$ docker run -u $(id -u) -v $PWD:/antora:Z --rm -t quay.io/labmonkeys/antora --stacktrace antora-playbook.yml
```

Although tempting, the `--privileged` flag is not needed.
To learn more about using volume mounts with SELinux, see the blog post [Using Volumes with Docker can Cause Problems with SELinux](http://www.projectatomic.io/blog/2015/06/using-volumes-with-docker-can-cause-problems-with-selinux/).

If your uid is not 1000, you may encounter the following error:

```
error: EACCES: permission denied, mkdir '/.cache'
```

This happens because the default cache dir resolves relative to the user's home directory and the home directory of the Docker user is `/` (hence the path [.path]_/.cache_).
You can fix this problem by setting the cache dir relative to the playbook when running Antora:

```
$ docker run -u $(id -u) -v $PWD:/antora:Z --rm -t \
quay.io/labmonkeys/antora --cache-dir=./.cache --stacktrace antora-playbook.yml
```

If you want to shell into the container, use the following command:

```
$ docker run -v $PWD:/antora:Z --rm -it antora/antora sh
```

This command allows you to run the `antora` command from a prompt inside the running container, but will still generate files to the local filesystem.
The reason this works is because, if the first argument following the image name is a local command, the container will execute the specified command instead of `antora`.

### Align with local paths

If you use the volume mapping `$PWD:/antora:Z`, you may notice that local paths reported by Antora don’t map back to your system.
That's because, as far as Antora is concerned, [.path]_/antora_ is the current working directory.
To remedy this problem, you need to map your current working directory into the container, then switch to it before running Antora.
To do so, use this volume mount instead:

```
-v $PWD:$PWD:Z -w $PWD
```

Notice the addition of the `-w` option.
This option tells Antora to switch from [.path]_/antora_ to the directory you have mapped.
Now, when Antora reports local paths, they will match paths on your system.

=== Use the git client

Although this image does not include `git`, it does provide access to the CLI for the git client used by Antora (isomorphic-git).
The name of this CLI is `isogit`.
You can use it to clone a repository as follows:

```
$ mkdir /tmp/docs-site
cd /tmp/docs-site
isogit clone --url=https://gitlab.com/antora/docs.antora.org.git
```

You can trim that clone down to a single commit by adding additional flags:

```
isogit clone --url=https://gitlab.com/antora/docs.antora.org.git --singleBranch --noTags --depth=1
```

Note that the `isogit clone` command does not create a directory for the repository clone like the `git clone` command.
Therefore, you have to create the repository first, switch to it, then run the `clone` command.

## How to Build this Image

To build this image locally, use the following command:

```
$ make
```

The build make take a while to complete.
Once it's finished, you can use the image name `ra` (i.e., `antora:linux-amd64`) to run the container.

## Copyright and License

Copyright (C) 2018-present OpenDevise Inc. and the Antora Project.

Use of this software is granted under the terms of the [Mozilla Public License Version 2.0](https://www.mozilla.org/en-US/MPL/2.0/) (MPL-2.0).
See [LICENSE](https://www.mozilla.org/en-US/MPL/2.0/) to find the full license text.
