# Software Standards

## (1) Introduction

Traditionally within the research community people would create and develop their own analysis software packages. These could be in the form of scripts or compiled code (such as Fortran or C++). This software is often unique to the research group and effectively leads to duplicated effort as other research groups develop software for the same purpose. The developers of the software frequently change (due to the nature of post docs) and without standards this can lead to the code being difficult to read because the style will change depending on who wrote it. This in the worst cases can lead to people believing that the code is incorrect, when it is correct, hence leading to wasted effort. The other potential pitfalls with this isolated approach of software development is that bugs are less likely to be found, due to less users and that the software may become too cumbersome to develop leading to the project having to start from scratch.

The Oxford Dictionaries (https://en.oxforddictionaries.com/) definition of a guideline is “a general rule, principle, or piece of advice”, for example “the organisation has issued guidelines for people working with prisoners”. We will use this definition throughout the remainder of this paper.

The standards and guidelines presented in this paper will suggest the best practises for the current tools that are commonly available. It is possible for standards and guidelines to become out of data. For example the European report [ref] is three years old, yet the advice for about how to host code has been superseded but the fundamental ideas are still correct. Hence, when it is appropriate the idea of the guideline/standard will be abstracted so that a new tool can be chosen in the future.
In this paper we outline some guidelines and standards for open source software development. Following these should reduce the risk of wasted effort, the code base becoming unmaintainable and removing duplicated effort.

## (2) Business as Usual

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

The traditional alternative to agile is waterfall, in this methodology each task
is planned in advance and carried out in a predetermined order. One key
disadvantage to this is the lack of flexibility when issues in implementation
cause a cascading change to how the project is to be implemented.

Projects that are better suited to the waterfall methodology are those where
delivering an intermediate product is not viable. For example, a library to
perform Fourier transformations is not useful unless fully implemented whereas a
graphical data processing toolkit may be.

### Coding standards

Code should be of a high standard, the reason for this is two fold; good quality
code that conforms to accepted standards is less likely to contain defects and
well formatted, readable code makes it easier to maintain that code in the
future.

Specific rules depend greatly on the language in question, as such it is better
to select a set of standards based on the language your software is written in.
A community curated list of standards organised by language is available here:
https://github.com/Kristories/awesome-guidelines

An important, language agnostic rule to follow is to be clear about what your
code is doing. This may be by means of comments, verbose variable names, etc.
Ideally a developer should not have to dig through documentation stored
elsewhere or find the correct person to talk to to understand a piece of code.

A general rule for code is to attempt to read the code as plain text, possibly
also out loud, and if the function of the code is clear then it is sufficiently
expressive or well commented. If not refactoring should be done to make the
intended function of the code obvious.

As an example of this, compare
```
float calc_v(std::vector<float> y)
{
  float v = 0.0;
  for (int i = 0; i < y.size(); i++)
  {
    v += (f(y[i]) - y[i]) * s(y[i]) + y[i];
  }
  return v;
}
```

against,
```
float linear_approx_pair_potentials(std::vector<float> const& pair_potential)
{
  float lapp(0.0f);
  for (auto const& y : pair_potential)
  {
    lapp += ((ema_potential(y) - y) * smooth_switch(y)) + y;
  }
  return lapp;
}
```

TODO: LAPP function needs a citation, details are https://spiral.imperial.ac.uk/handle/10044/1/29867

For ease of collaboration filenames, identifier names, comments and
documentation should be published in English. Translation frameworks may be used
to provide your software and documentation in other languages at compile/build
time.

### Issues and work planning

A means of tracking work to be done on a software project is essential. This is
often implemented in two parts; low level tracking of implementation tasks and
high level tracking of project goals.

For low level task tracking simple tools such as GitHub Issues are likely
sufficient, even for large projects. The essential functionality is providing a
description of work to be undertaken and allowing it to be assigned to a
developer. Additional features may include Kanban boards, task dependency and
task hierarchy.

High level tracking, typically at project management level, should track the
projects medium to long term goals and keep track of their progress. This can be
used to plan the use of developer time over the coming months and should be the
point at which users of the software define what they would like to see.

Ideally both levels of work tracking should be available to view freely so that
users can remain informed about the development of the software.

### Source control management

Source control management (SCM) is an essential part of a software project. This
provides a full history of the state of your code base as the project evolves,
allows multiple developers to work on the project simultaneously and provides
means on reviewing changes to your software.

As with writing code, following a set of guidelines when working with your SCM
will allow you to get the most out of it. As such guidelines apply to a much
wider audience there is already ample documentation describing them, some of
which are listed at https://github.com/dictcp/awesome-git#workflow, therefore
this section will only give an overview and highlight a few commonly overlooked
points.

You must adopt a workflow and enforce it. A workflow defines how developers
interact with the SCM and the process of their changes to the code base being
accepted.

A popular option, that is also one of the simplest, is the feature branch
workflow (see
https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow).
In this workflow when a developer starts working on a new feature they do so on
a new branch and that branch is then merged when the changes are to be accepted.

Developers should also ensure that they produce a clear commit history. Given
that this is likely the longest standing documentation describing the history of
your software it is important that commits are sensible, atomic and logically
ordered and that commit messages are clear and describe the reasoning behind the
changes made in the commit itself. A good guide for this can be found here:
https://chris.beams.io/posts/git-commit/.

### Continuous integration

Continuous Integration (CI) should be used, regardless of the projects size, to
ensure that your software performs as you expect it to.

CI is essentially a service that detects when new changes have been made to the
code base (via the SCM) and runs a set of actions to determine of the code is of
good quality. It can also be used to perform the same checks on proposed changes
before they become part of the main code base.

Typically the actions performed include compiling/installing the software and
running any automated test suites, however any number of additional tasks can be
performed including; generating documentation, performing static analysis,
deploying installer packages, checking for software vulnerabilities, etc.

Given the availability of free to use CI services (see Standard Tools section)
there is no good reason to not have CI setup.

### Code review

Code review is the process of determining if a proposed change should be made to
the code base, typically after a developer has finished working on a feature or
bug fix.

The depth of the review process depends a great deal on the size and purpose of
the project. At minimum the developer proposing the changes should provide a
description of that their change accomplishes and instructions on how the tester
can demonstrate this, this step proves the changes worth.

The tester then must ensure that the code is of good quality and coding styles,
guidelines, etc. have been followed, commit history is sane and relevant
documentation (including release notes) updated. CI tools can be used to perform
some of these checks automatically.

Larger or more critical projects may opt to have a second review stage, in which
another tester (that has yet to be involved in the development or testing of this
proposed change) will perform the same duties as the first tester. While this is
duplicating work having multiple eyes on a change before it is accepted does
significantly increase the chance of potential issues being found before they
are released to users.

## (3) Architecture

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

A benefit gained from making code modular is the ability to test each module in
isolation using automated testing, for instance unit testing.

The code base of your software should be managed using an appropriate build
system, of course this depends on the language (or combination of languages)
used.

A good choice for C and C++ projects is CMake. This can handle setting up
library paths and build tools automatically, allowing developers on any platform
to develop your software with relative ease.

For Python based projects Python's setuptools is typically sufficient, for
specific cases (for example, when the software depends on tricky to package
dependencies) Conda may be used as an alternative.

C++ projects can also benefit from use of a dependency manager such as Conan.
Most build systems for other languages combine a dependency manager into the
build system, however this is not the case for CMake.

## (4) Data Formats and Interoperability

It is important to consider users wishing to move their data between software
packages (or write their own data treatment routines) and not make design
choices that inhibit this.

A key part of this is choosing an open, well documented format for storing data
in. In the neutron science community this is the NeXus format which defines a
schema on top of the HDF5 file format. NeXus aims to standardise the way similar
data is represented by different facilities and software. Whilst the format has
existed for roughly two decades it's widespread use as the standard data format
has been a relatively recent effort between facilities and software projects.

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

## (5) Project Management

Large pieces of software will require some form of management, to ensure that the team are working effectively. This is sometimes referred to as a governance model. The scale of the governance model will depend on the size of the piece of software and could range from an advisory committee to a project management board. A governance model will provide a constructive mechanism for deciding the direction of the software and for ensuring it progresses.

All pieces of distributed software require a license. An open source license such as the GNU General Public License (GPL) is advisable from both a user and development perspective. The users will be able to download and use the software free of charge, removing a potential barrier in the uptake of your software. The advantage of the GPL for software development is that it allows anyone to contribute to your software (you may impose some of your own checks on the code before it goes into the master branch), this radically improves the available pool of developers.


For research/academic software it is also beneficial to generate a Digital
Object Identifier (DOI) for each release. This allows your software to be easily
cited in publications and makes it clear which version of your software was used
to generate results in a given publication. Another method is to use a publication that provides the idea of the software.

The software should follow the basic notion of a release cycle. A release is a version of the software that has been tested and the development team is confident that it is ready to be used as part of the neutron experiments. A release will occur a few times a year, this reassures users that the project is still supported. It is advisable to follow semantic versioning (major.minor.patch, e.g. 3.1.0) for the naming of the releases. Prior to a release there will be a code freeze, where no new code will be submitted to the master branch. Once all of the code has been merged into a release (will be based off of master at the start of the code freeze) branch then manual testing can begin. It is advisable for the developers to do the first round to catch obvious bugs, which are fixed and added to the master branch. The next stage is beta testing where a select group of the users are chosen and they test the master branch and report any bugs. Once these bugs are fixed it is then possible to release the software with some confidence that it is ready for use during experiments. It is advisable to then spend some time working maintenance tasks, these are improvements to the maintainability of the code.

## (6) Packaging and Distribution


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

### Maintenance period

After a release is the opportune time to perform invasive maintenance tasks that
would otherwise be too much of a risk to carry out closer to a release. Such
tasks may include; updating dependency versions, addressing code quality issues,
refactoring, code restructuring, deploying new functionality that interacts with
large portions of the code, etc.

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

## (7) Support and Documentation

If a piece of software is intended to have a large user base then documentation becomes essential. Good documentation will prevent the developers having to spend time explaining how to use the software to users. The hallmarks of good documentation are it is concise, written in a way that is accessible to the target audience (users) and easily available.
The simplest and most common form is online documentation, for example Read the docs or a wiki page. This should have a clear structure and be easy to navigate. An easy way to achieve this is to have a contents page and to make the pages searchable so users can easily find the relevant information. An easy way to achieve this is to have tags that summarise the main themes of each page. The online documentation should be version controlled so it is possible to revert changes and to follow its evolution.

An increasingly popular method of documentation is the video tutorial. These are extremely useful to users as it allows them to easily see how to use the software, however they have a large time cost to create them. All documentation should be kept up to date, but video tutorials may require significant work if the software undergoes a large change.

Face to Face communication is often the most efficient and effective way to understand a user’s question/comment. This allows for a conversation to occur with more probing questions to improve the developer’s understanding and to overcome any unfamiliar terminology. As a result it is important to have some local support, where developers are preferably in close proximity to their users. Face to Face contact also has the benefit of increasing the user experience and users are more likely to report problems/bugs to the development team if they can easily speak to them.

The documentation discussed so far has focused on the users. It is also valuable to have developer documentation. This documentation could contain information on the standards used in the code, how to set up a development version and appropriate tutorials/information.
A key activity for any piece of software is the user support. Unlike documentation this is more interactive between developers and users. As a minimum email support should be provided to the users in a location that is easy for them to find. The emails should be checked regularly and initial responses should be within a day or two. The initial response may be to ask for more details, to arrange to meet with them face to face or to say that it is being worked on. Providing effective user support will give users more confidence in the software.

## (8) Standard Tools

This section lists a series of tasks and the standard tools that are commonly
used to perform them. It is designed to aid as a guide when starting out a new
software project.

It is not designed to be a definitive list of what can and cannot be used, but
rather a recommendation based on experience of software projects and analysis of
the options at the time of writing.

### Source control management

- Git

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

## (9) SINE2020

TODO

## (10) Conclusion

TODO

## (11) Acknowledgements

TODO
