# Drifter (Vagrant Box)

This project builds a Vagrant box to be used as my primary development
environment.

I wrote a response to a complaint about Vagrant on the Internet.  That might
give you a background of why I started using Vagrant.  The key different to the
usual Vagrant is that I don't use the shared directory provided by Vagrant.

* [A response to "Why Developers Should NOT Use MacBook Pro"](https://medium.com/@alvin.yp.yim/with-your-first-point-about-vagrant-virtualbox-setting-up-a-samba-in-virtualbox-and-edit-code-9680b2d38c69)

## About Vagrant

### In the physical world

> Vagrant (noun): a person without a settled home or regular work who wanders
> from place to place and lives by begging.

### In the tech world

Vagrant is a tool for automating virtual machine creations and interactions.

1. It supports a few engines (providers) out-of-the-box, e.g. VirtualBox
   (default), VMWare and Docker.
1. One may also define custom provider to manage other virtual machines such as
   EC2.
1. It is very similar to Docker.  While Docker uses `cgroup`, Vagrant is one
   level higher.  It manages virtual machines.
1. "Box" in Vagrant primarily means a pre-built Vagrant box, e.g. an official
   box released by Ubuntu or a private pre-built box.  "Box" can also mean a
   virtual machine that is running that is managed by Vagrant.
1. Public boxes are published in Vagrant Cloud.
1. With paid subscriptions, Private boxes can be hosted in Vagrant Cloud as
   well.  Private boxes can also be shared as files.


Common usage of Vagrant are as follows.

1. Experimental environment.

   > I want to try Ubuntu without having to clicking around VirtualBox or
   > VMware.

1. General development environment (out-of-the-box).

   > I want to use WSL 2.0 but I can't live with the memory issue of it.

1. General development environment (pre-built box).

   > I want to have a box that contains most of the things I need.  E.g.
   > `dotnet`, Docker and MSSQL, `nvm`, AWS CLI, Git, Python and the list goes
   > on...

1. Reference application stack for development.

   > How do I setup XAI and XAPI with a local MSSQL?  Each of them can be in a
   > Vagrant box.  One may pre-build boxes that contain the components; or
   > contain scripts that will clone the Git repos and run the setup script of
   > each component.

1. Production. (Not as common but it's an option)

## About this box

1. Used to be called `hobo` now `drifter`.
1. It's built automatically in Semaphore upon pushing a Git tag.
1. It's based on the official Ubuntu.
1. Historically this box were built using just Vagrant itself but now use the
   dedicated tool, Packer.
1. It exposes the `HOME` directory via Windows file sharing (Samba).
1. The virtual root drive is resized to 100 GiB.  Actually allocated size is
   much less and it grows only when needed.
1. The primary mechanism for installing tools and configrations in this box is
   Bash scripts.  See `src/prepare`.
1. A lot of choices of tools were made based on how other CI/CD environments
   provide dependencies.  [AWS
   CodeBuild](https://github.com/aws/aws-codebuild-docker-images/blob/master/ubuntu/standard/3.0/runtimes.yml),
   [Semaphore CI](https://docs.semaphoreci.com/).
1. All of programming related tools supports multi-version.  I.e. NVM as
   opposed to a particular version of Node.js and multiple version listed under
   `dotnet --list-sdks`.
1. Most of the installation scripts were written based on the official
   documentation, usually found on the GitHub page of the tools.
1. When new tools are required, they can be added in to this project.

### Upside

1. A way of documenting how I setup my tools.
1. Any upgrade/update can be tested before I fully switch to them.
1. Yet another solution to the "It-works-on-machine" problem.
1. Works on Windows, Mac and Linux.
1. No longer need to run `apt-get upgrade`.

### Downside

1. One will need to understand the concept of pets vs cattle before they can
   appreciate the values Vagrant brings.
1. It supports Windows boxes but becasue a lot of tasks cannot be automated in
   Windows.  It doesn't bring as many advantages as in Linux boxes.
1. Requires virtualisation (VTx).  Not supported in the usual EC2; only works
   in bare metal EC2.  Does not work on older machines (usually built before
   2011).
1. You need to be comfortable with commands/terminal/CLIs.
1. You need to be comfortable with Linux.

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│    Host OS (Windows, Linux or Mac)                                   │
│                                                                      │
│                               Copied into the box upon first use     │
│    ssh key at the host ────────────┐                                 │
│                                    │                                 │
│                                    │                                 │
│                                    ▼                                 │
│                             ┌──────────────────────────────────────┐ │
│  ┌─────────────┐            │                                      │ │
│  │ Vagrant CLI │            │   Vagrant box (Linux)                │ │
│  │ Vagrantfile ├───────────►│                                      │ │
│  └─────────────┘            │                                      │ │
│                             │   Native Docker                      │ │
│  ┌────────────────────┐     │                                      │ │
│  │ Z: maps to Vagrant │     │                                      │ │
│  │  box's HOME        ├────►│   Expose HOME through Samba          │ │
│  └────────────────────┘     │                                      │ │
│                             │                                      │ │
│  ┌────────────────────────┐ │                                      │ │
│  │ Vagrant SSH/Native SSH │►│                                      │ │
│  └────────────────────────┘ │                                      │ │
│                             │                                      │ │
│  ┌────────────────┐         │                                      │ │
│  │ VS Code Remote ├────────►│                                      │ │
│  └────────────────┘         │                                      │ │
│                             │                                      │ │
│                             │                                      │ │
│                             └──────────────────────────────────────┘ │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```
