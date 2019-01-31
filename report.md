# Software Standards

## Introduction

TODO

## Project Management

TODO

## Packaging and Distribution

### Cross platform

Unless your software specifically targets high performance computing systems
such as clusters or distributed compute platforms then no assumption can
realistically be made about how, and specifically on what platform, a user will
expect to run your software.

For this reason it is highly desirable (or even essential) that your software is
designed to be run on or at least easily portable to multiple operating systems
and architectures.

Thanks to modern development tools, libraries and build systems this is not a
complex task. Cross platform development tends to not add significant complexity
or time cost to delivering a piece of software.

It is possible to only officially support a single or narrow selection of
systems, however the use of cross platform libraries and build systems should
still be encouraged to allow easy deployment on additional platforms at a later
stage if required and to allow collaborators and power users to build and modify
your software on whatever computer they may use.

If officially supporting multiple platforms then it is beneficial to encourage a
spread of different platforms and operating systems across your development team
(a good example of this is the Mantid project), this ensures that there are
always multiple people capable of addressing platform specific issues when they
arise.

### Packaging

In order to reduce friction for users when they want to setup your software an
intuitive packaging method is essential. Exactly what this involves varies
depending on the nature of your project, as such this section will not go into
great detail about specific options but rather the requirements of an installer
and method of choosing an appropriate installation method for your software.

The goal of an installer to to give your users with a working copy of your
software. They should not have to care about any implementation specifics or
having to install additional dependencies to simply make your software run. This
is the first requirement.

Once installed your software should not conflict with any other software a user
may have installed on their machine. A common example of this is when
applications, at some level, depend on the same libraries. In which case the
latest installed software package may remove or overwrite the third party
library installed by the first software package.

As the technology becomes more popular it is worth looking into cross platform
container based means of distribution (for example, Docker and friends). This
allows you to ship a software package in an already configured and working state
being safe in the knowledge it will function in the same way on the user's
computer. Different containerization systems have their own caveats and there is
no "one size fits all" solution.

### Releases

A good release process depends greatly on the nature of the software project.
For instance, a small tool used by a handful of users on a unique beamline could
probably be released very quickly with minimal effort or fuss given that the
users are likely closely involved with the development of said tool. Whereas a
large framework used by multiple different scientific techniques at different
facilities (such as the Mantid project) requires a much more involved release
process to ensure the software is suitable for use by all intended audiences.

This section will assume you have a substantial number of users which you do not
directly interact with during your development process, and as such cannot
simply release and hope for the best because the users you do interact with have
not reported any issues.

In order for any potential issues in your software to be found and rectified you
may wish to release beta or release candidate versions of your software before
the official release. This release is intended for "power users" who do not mind
testing your software for the benefit of the wider audience of your software
(a typical example is a beamline scientist who wants to ensure your software
works before providing it to their visiting users).

The length of the beta period is determined by your release cycle and the number
of users you estimate use your software. There is no generic rule for this other
than ensuring that all (or as close to as possible) use cases of your software
have been tested by users who specialise in that area.

There can be any number of release candidates before the final release version
is selected. As the name suggests a release candidate should be generated in
exactly the same manner as a release (the only difference being the version
number).

To ensure users approach the new version with realistic expectations it is
essential to provide sufficiently detailed release notes at the start of your
beta testing period. These should summarise the changes made to your software
since the last release, possibly highlighting some specific new features (this
is where you "sell" your new version and give a reason for users to upgrade).

It is essential that all breaking changes, i.e. those that require the user to
perform different steps to achieve the same outcome, are listed. This will
prevent issues when users attempt to use incompatible existing workflows with
your new version.

If your software in in any way involved in security or safety (in terms of
either data, equipment or life) fixes for identified issues compromising safety
or security must be listed in your release notes.

It is recommended to tag and sign the release in your SCM system, in the case of
Git this involves creating a tag from the code that was used to generate your
release package and signing it with either a project or maintainers PGP key.
This is not an essential step, but is good practice to allow verification of
historic releases.

For research/academic software it is also beneficial to generate a Digital
Object Identifier (DOI) for each release. This allows your software to be easily
cited in publications and makes it clear which version of your software was used
to generate results in a given publication.

### Maintenance period

After a release is the opportune time to perform invasive maintenance tasks that
would otherwise be too much of a risk to carry out closer to a release. Such
tasks may include; updating dependency versions, addressing code quality issues,
refactoring, code restructuring, deploying new functionality that interacts with
large portions of the code, etc.

## Support and Documentation

TODO

## Data Formats and Interoperability

It is important to consider users wishing to move their data between software
packages (or write their own data treatment routines) and not make design
choices that inhibit this.

A key part of this is choosing an open, well documented format for storing data
in. In the neutron science community this is the NeXus format which defines a
schema on top of the HDF5 file format. NeXus aims to standardise the way similar
data is represented by different facilities and software.

One point of note is that when committing to NeXus as your data format, you must
ensure you truly implement the standard or publish the schema if the need to
diverge from the standard is genuinely required. In this case you may evaluate
if your changes should form part of the standard and propose such changes.

Proprietary file formats should be avoided at all costs. While there is
sometimes an argument for software specific intermediate formats, they should
remain intermediate and NeXus should be the preferred interchange format.

Applications may need to store configuration or process setup information that
is specific to a "job" (i.e. not general application configuration information,
this should be handled by your application framework, e.g. `QSettings` for Qt).

This job specific configuration should ideally be in a human readable plain text
format assuming it's data volume does not negate readability or performance.
Popular formats for this purpose include INI, YAML and JSON, all of which have
several library options for common languages and store data as plain text. Under
no circumstances should proprietary formats be used for job configuration
(either plain text or binary).

The ability to reproduce results of data treatment is an important ability for
users of your software, to allow this you should provision a mechanism that
allows the actions of your software to be "replayed" on the untreated raw data.
Typically this means recording a history of each atomic action your software
performs as well as any relevant version numbers (i.e. the version of your
software, versions of plugins/dependencies, etc.).

Good examples of such history reporting are algorithm Histories in Mantid and
Process Lists in Savu.

One may also choose to use a common format for job configurations and history,
for example Process Lists in Savu which are stored as entries in a NeXus file.
The advantage this gives is that the result dataset can be used as input
defining a job.

## Architecture

A well designed software package would separate its functionality into a set of
individual modules based on common feature areas, where a "module" may refer to
a package, library or software plugin.

Care should be taken when designating these modules; modules should contain only
functionality relevant to the goal of the module, where the goal itself is a
very specific task (e.g. optimization).

Another aspect of this is not introducing unnecessary dependence into modules.
Avoiding this allows individual modules to be reused with less restrictions than
those that depend on multiple additional components, especially when the
dependencies contain functionality that do not directly influence the
functionality of the module in question.

TODO

## Business as Usual

This section aims to outline choices that impact the day to day work of
developers working on your project. Most are choices that will be made at the
start of the project and ideally last the duration of the project, however there
are cases where changes will be made to accommodate new tools and standards,
etc.

### Development methodology

Development methodology defines how the software is developed and delivered to
the user. Essentially it is a set of rules that govern how requirements are
gathered, converted into developer tasks and the final product is delivered to
the user.

Due to the nature of scientific software agile, or some variant of, is typically
the chosen methodology.

The general principle of agile is short development sprints in which small,
incremental additions are made to the overall software, where the features
implemented are determined by revisiting requirements in between each sprint.

This allows requirements to change quickly, reducing the delay in obtaining
feedback from users and developers to me more responsive to the users needs.

The area this falls down is in long term planning, as agile methodologies do not
focus on long term goals (or at least do not attempt to assign deadlines to
them).

### Coding standards

Code should be of a high standard, 

TODO

### Source control management

Source control management (SCM) is an essential part of a software project. This
provides a full history of the state of your code base as the project evolves,
allows multiple developers to work on the project simultaneously and provides
means on reviewing changes to your software. 

TODO

### Issues and work planning

TODO

### Continuous integration

TODO

### Code review

TODO

## Standard Tools

This section lists a series of tasks and the standard tools that are commonly
used to perform them. It is designed to aid as a guide when starting out a new
software project.

It is not designed to be a definitive list of what can and cannot be used, but
rather a recommendation based on experience of software projects and analysis of
the options at the time of writing.

### Source control management

Git

Git is the most common and one of the most powerful source control management
tool used in open source software today with a wide variety of training
resources available. It is suitable for a project of any size and will last the
life of your project.

### Code hosting

- GitHub
- GitLab
- Bitbucket

There are a wide range of cloud Git repository providers, all of which provide
mostly similar features. If your team is distributed then it is recommended to
use such a service (opposed to local hosting on site) to avoid network related
bottlenecks.

### Issue tracking

- Git hosting providers in built tool

Most cloud hosted Git services provide their own issue tracking tool which
typically suit the needs of most software projects.

If more complex task workflows are needed or if your project is split across
multiple repositories where work on a single feature may span multiple
repositories then it may be beneficial to look into issue tracking separate from
your code repositories.

### Code review

- Git hosting providers in built tool

Similarly, most cloud hosted Git services also provide some means of code review
which is often sufficient for most projects.

### Project website

- Hugo & GitHub Pages

Hugo is a powerful and fast static website generator. It can be used for very
basic less than 10 page sites up to large blogs/news sites, supports themeing
and customisation and works with content defined in Markdown.

GitHub Pages is a free hosting service provided by GitHub, this allows you to
commit your website content to a specific branch and have it served by GitHub.
The large benefit here is avoiding the cost and time of maintaining the
infrastructure required to host your projects website.

### Continuous integration

- Travis
- Appveyor
- Jenkins

For small scale projects that reside in a single repository continuous
integration as a hosted service is most likely sufficient. One of the most
common of such services is Travis CI who offer Linux, Mac OS and Windows build
environments for a time limited window for you to run your builds and tests.

Appveyor is an alternative service that focuses on Windows build environments.
Windows support in Travis is relatively new at the time of writing so the common
approach of using Travis and Appveyor to cover all operating systems is still
common.

Jenkins is a self hosted CI solution that runs on your own infrastructure. The
key advantage this has is removing restrictions around build time, data
availability and specific build environment setup.

### Code analysis

- Clang (C++)
- Pylint (Python)

There are a plethora of static analysis tools available for pretty much every
language. The two listed are two of the most common for C++ and Python.

A lot of tools are available as standalone packages that you simply install, run
and get back a report in whatever format that tool supports. Some tools are also
available as a cloud service that is triggered by new code being pushed to your
remote repository.

For a wider selection of the available tools it is worth looking over the
selection on Awesome Static Analysis
(https://github.com/mre/awesome-static-analysis), a community curated list of
static analysis tools.

### GUI framework/library

- Qt/PyQt

Qt is a commonly used application framework used by many open source and
commercial software packages. It allows easy development of cross platform GUIs
in a variety of languages.

### Scripting/plugin interface

- Python

If you are making your software extensible by means of a scripting interface
this should ideally be done in Python.

Python is becoming the standard language for data science and as such has a wide
range of libraries, documentation and resources available for it. This benefits
both the developer of the software as the burden of implementing new features
and documenting a lesser known scripting mechanism are lifted to a degree and
your users as they have the ability to augment your software to suit any
specific needs they data has.

## SINE2020

TODO

## Conclusion

TODO

## Acknowledgements

TODO
