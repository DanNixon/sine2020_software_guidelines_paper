# Software Standards

## (1) Introduction

Traditionally within the research community people would create and develop their own analysis software packages.
These could be in the form of scripts or compiled code (such as Fortran or C++).
This software is often unique to the research group and effectively leads to duplicated effort as other research groups develop software for the same purpose.
The developers of the software frequently change (due to the nature of post docs) and without standards this can lead to the code being difficult to read because the style will change depending on who wrote it.
This in the worst cases can lead to people believing that the code is incorrect, when it is correct, hence leading to wasted effort.
The other potential pitfalls with this isolated approach of software development is that bugs are less likely to be found, due to less users.
Also the software may become too cumbersome to develop leading to the project having to start from scratch.

The Oxford Dictionaries (https://en.oxforddictionaries.com/) definition of a guideline is “a general rule, principle, or piece of advice”, for example “the organisation has issued guidelines for people working with prisoners”.
We will use this definition throughout the remainder of this paper.

The standards and guidelines presented in this paper will suggest the best practises for the current tools that are commonly available today.
The European report [ref] is three years old, yet the advice for about how to host code has been superseded but the fundamental ideas are still correct.
Hence, when it is appropriate the idea of the guideline/standard will be abstracted so that a new tool can be chosen in the future.

In this paper we outline some guidelines and standards for open source software development.
Following these should reduce the risk of wasted effort, the code base becoming unmaintainable and removing duplicated effort.

## (2) Business as Usual

This section aims to outline choices that impact the day to day work of developers working on your project.
Most are choices that will be made at the start of the project and ideally last the duration of the project, however there are cases where changes will be made to accommodate new tools and standards, etc.

### Development methodology

Essentially development methodology is a set of rules that govern how requirements are gathered, converted into developer tasks and the final product is delivered to the user.

Due to the nature of scientific software "agile", or some variant of, is typically the chosen methodology.

The general principle of agile is short development "sprints" in which small, incremental additions are made to the overall software, where the features implemented are determined by revisiting requirements in between each sprint.

This allows requirements to change quickly, reducing the delay in obtaining feedback from users and developers to be more responsive to the users' needs.

The area this falls down is in long term planning, as agile methodologies do not focus on long term goals (or at least do not attempt to assign deadlines to them).

The traditional alternative to agile is "waterfall", in this methodology each task is planned in advance and carried out in a predetermined order.
One key disadvantage to this is the lack of flexibility when issues in implementation cause a cascading change to how the project is to be implemented.

Projects that are better suited to the waterfall methodology are those where delivering an intermediate product is not viable.
For example, a library to perform Fourier transformations is not useful unless fully implemented whereas a graphical data processing toolkit may be.

### Coding standards

Code should be of a high standard, the reason for this is two fold; good quality code that conforms to accepted standards is less likely to contain bugs and well formatted, readable code makes it easier to maintain in the future.

Specific rules depend greatly on the language in question, as such it is better to select a set of standards based on the language your software is written in.
A community curated list of standards organised by language is available here: https://github.com/Kristories/awesome-guidelines

An important, language agnostic rule to follow is to write human readable code.
This may be by means of comments, verbose variable names, etc.
Ideally a developer should not have to dig through documentation stored elsewhere or find the correct person to talk to to understand a piece of code.

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

For ease of collaboration filenames, identifier names, comments and documentation should be published in English.
Translation frameworks may be used to provide your software and documentation in other languages at compile/build time.

To assist in maintaining code quality one or more "linters" (also referred to as "static analysis" tools) should be employed.
These are tools that inspect your code in one way or another to detect potential issues, such as unused variables, indentation, thread misuse, etc.
There are a plethora of linters available for almost every language.
Clang and Pylint are two of the most common for C++ and Python respectively.

A lot of tools are available as standalone packages that you simply install, run and produces a report.
Some tools are also available as a cloud service (e.g. Coverity, TODO Python tool) that is triggered by new code being pushed to your remote repository.

For a wider selection of the available tools it is worth looking over the selection on Awesome Static Analysis (https://github.com/mre/awesome-static-analysis), a community curated list of static analysis tools.

Another general rule to bear in mind when writing new code is to avoid the pitfalls of pre-emptive optimisation, by attempting to reduce execution cost without determining if it is a problem to begin with.
A similar pitfall is pre-emptive generalisation, which is attempting to make the code less problem specific in the hope it can be reused without determining if this affects code quality or if there is even a case where it could be reused.
Of course neither pre-emptive optimisation or generalisation have a concrete definition so it is up to the developer and code reviewers to make informed decisions based on the nature of the work and the code base.

### Issues and work planning

A means of tracking work to be done on a software project is essential.
This is often implemented in two parts; low level tracking of implementation tasks and high level tracking of project goals.

For low level task tracking simple tools such as GitHub Issues are likely sufficient, even for large projects.
The essential functionality is providing a description of work to be undertaken and allowing it to be assigned to a developer.
Additional features may include Kanban boards (TODO provide reference), task dependency and task hierarchy.

Most cloud hosted Git services provide their own issue tracking tool, which typically suit the needs of most software projects.

If more complex task workflows are needed or if your code base is distributed across multiple locations then it may be beneficial to look into issue tracking separate from your code.

High level tracking, typically at project management level, should track the projects medium to long term goals and their progress.
These goals should be defined by users of the software.

Ideally both levels of tracking should be available to view freely so that users can remain informed about the development of the software.

### Source control management

Source control management (SCM) is an essential part of a software project.
This provides a full history of the state of your code base as the project evolves, allows multiple developers to work on the project simultaneously and provides means on reviewing changes to your software.

As with writing code, following a set of guidelines when working with your SCM will allow you to get the most out of it.
As such guidelines apply to a much wider audience there is already ample documentation describing them, some of which are listed at https://github.com/dictcp/awesome-git#workflow, therefore this section will only give an overview and highlight a few commonly overlooked points.

You must adopt a workflow and enforce it.
A workflow defines how developers interact with the SCM and the process of their changes to the code base being accepted.

When working with developers who may be using SCM for the first time it is common to see unused code (be it commented out code, functions that are never called, files that are not included, etc.) left in the code base.
For the sake of keeping the code base clean it is important to remove such dead code, it's presence in the code base only leads to increased difficulty in reading and understanding the code that is actually used and given that history is recorded in the SCM, deleting it comes with no danger.

A popular option, that is also one of the simplest, is the feature branch workflow (see https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow).
In this workflow when a developer starts working on a new feature they do so on a new branch and that branch is then merged when the changes are to be accepted.

Developers should also ensure that they produce a clear commit history.
Given that this is likely the longest standing documentation describing the history of your software it is important that commits are sensible, atomic and logically ordered and that commit messages are clear and describe the reasoning behind the changes made in the commit itself.
A good guide for this can be found here: https://chris.beams.io/posts/git-commit/.

Git is the most common and one of the most powerful SCM tool used in open source software today with a wide variety of training resources available.
It is suitable for a project of any size and will probably last the life of your project.

There are a wide range of cloud Git repository providers, all of which provide mostly similar features.
If your team is distributed then it is recommended to use such a service (opposed to local hosting on site) to avoid network related bottlenecks.

### Continuous integration

Continuous Integration (CI) should be used, regardless of the projects size, to ensure that your software performs as you expect it to.

CI is essentially a service that detects when new changes have been made to the code base (via the SCM) and runs a set of actions to determine if the code is of good quality.
It can also be used to perform the same checks on proposed changes before they become part of the main code base.

Typically the actions performed include compiling/installing the software and running automated test suites, however any number of additional tasks can be performed including; generating documentation, performing code linting (static analysis), deploying installer packages, checking for software vulnerabilities, etc.

For small scale projects that reside in a single repository continuous integration as a hosted service is most likely sufficient.
For example Travis CI offer time limited windows for you to run your builds and tests on Linux, Mac OS and Windows operating systems.

Jenkins is a self hosted CI solution that runs on your own infrastructure.
The key advantage this has is removing restrictions around build time, data availability and specific build environment setup.

### Code review

Code review is the process of determining if a proposed change should be made to the code base, typically after a developer has finished working on a feature or bug fix.

The depth of the review process depends a great deal on the size and purpose of the project.
The developer proposing the changes should provide a description of their change and instructions on how the tester can demonstrate this.

The tester then must ensure that the code is of good quality and coding styles, guidelines, etc. have been followed, commit history is sane and relevant documentation (including release notes) has been updated.
CI tools can be used to perform some of these checks automatically.

Larger or more critical projects may opt to have a second review stage, in which another tester (that has yet to be involved in the development or testing of this proposed change) will perform the same duties as the first tester.
Having multiple reviewers for the same piece of work may seem inefficient but significantly increases the chance of potential issues being found before they are released to users.

Tools for code review are often in built in hosted SCM services, an example of this is GitHub "Pull Requests", which allow code to be viewed and commented on.

## (3) Architecture

A well designed software package would separate its functionality into a set of individual "modules" based on common feature areas, where a module may refer to a package, library or software plugin.

Care should be taken when designating these modules, these should contain only functionality relevant to the goal of the module, where the goal itself is a very specific task (e.g. optimization).

Code within a module should be closely related to each other, this reduces importing unnecessary functionality and keeps modules specific to a given purpose.
A benefit gained from making code modular is the ability to test each module in isolation using automated testing (i.e. unit testing).

The code base of your software should be managed using an appropriate build system, this depends on the language (or combination of languages) used.
A good choice for C and C++ projects is CMake.
This can handle setting up library paths and build tools automatically, allowing developers on any platform to develop your software with relative ease.
C++ projects can also benefit from use of a dependency manager such as Conan.
Most build systems for other languages combine a dependency manager into the build system, however this is not the case for CMake.
For Python based projects Python's setuptools is typically sufficient, for specific cases (for example, when the software depends on tricky to package dependencies) Conda may be used as an alternative.

If you are making your software extensible by means of a scripting interface this should ideally be done in Python.
Python is becoming the standard language for data science and as such has a wide range of libraries, documentation and resources available for it.

If the application requires a graphical user interface (GUI) then a good choice of library is Qt.
Qt is an application framework commonly used by many open source and commercial software packages.
It allows easy development of cross platform GUIs in a variety of languages.
Another increasingly popular option is to provide your software as a web service that is accessed via a web page.

## (4) Data Formats and Interoperability

It is important for your software to use a standardised data format, which features open source definitions and documentation.
In the neutron science community this is the NeXus format, which defines a structure on top of the HDF5 file format.
NeXus aims to standardise the way similar data is represented by different facilities and software.
Whilst the format has existed for roughly two decades it's widespread use as the standard data format has been a relatively recent effort between facilities and software projects.
One point of note is that when committing to NeXus as your data format, you must ensure you truly implement the standard or publish the definition, if the need to diverge from the standard is genuinely required.
In this case you may evaluate if your changes should form part of the standard and propose such changes.

Proprietary file formats should be avoided at all costs.
While there is sometimes an argument for software specific intermediate formats, they should remain intermediate and NeXus should be the preferred interchange format.

Applications may store information relevant to it as a whole (e.g. window layout for a graphical tool), which should typically be stored using the facilities provided by the application framework (e.g. `QSettings` for Qt).

Additional configuration or process setup information should be stored in an easily accessible location.
This configuration should ideally be in a human readable plain text format, assuming it's data volume does not negate readability or performance.
Popular formats for this purpose include INI, YAML and JSON, all of which have several library options for common languages and store data as plain text.
Under no circumstances should custom formats be used for job configuration.

The ability to reproduce results of data treatment is an important ability for users of your software, to allow this you should provision a mechanism that allows the actions of your software to be "replayed" on the raw data.
Typically this means recording a history of each atomic action your software performs as well as any relevant version numbers (i.e. such as the version of your software, versions of plugins/dependencies).
Good examples of such history reporting are algorithm histories in Mantid (TODO citation) and Process Lists in Savu (TODO citation).

One may also choose to use a common format for job configurations and history, for example Process Lists in Savu, which are stored as entries in a NeXus file.
The advantage this gives is that the result dataset can be used as input for a future job.

## (5) Project Management

Large pieces of software will require some form of management, to ensure that the team are working effectively.
This is referred to as a governance model.
The scale of the governance model will depend on the size of the project and could range from an advisory committee to a project management board.
A governance model will provide a constructive mechanism for deciding the direction of the project and for ensuring it progresses.

The software should follow the basic notion of a release cycle.
A release is a version of the software that has been tested and the development team is confident that it is ready to be used.
A release will occur a few times a year, this reassures users that the project is still supported.
It is advisable to follow semantic versioning (major.minor.patch, e.g. 3.1.0) for the naming of the releases, for more details see TODO link.
Prior to a release there will be a "code freeze", where no new code will be submitted to the main branch.
In preparation for a release developers should test the software works as expected with no obvious bugs.
The next stage is "beta testing" where a select group of users are chosen and they test the software and report any bugs.
Once all of the identified bugs are fixed it is then possible to release the software with some confidence that it is ready for use.
It is advisable to then spend some time working on maintenance tasks, these are improvements to the maintainability of the code rather than any new user facing functionality.

All pieces of released software require a license.
An open source license is advisable from both a user and development perspective, for details of the available licenses see TODO link.
The users will be able to download and use the software free of charge, removing a potential barrier in the uptake of your software.
The advantage of an open source license is that it allows anyone to contribute to your software (this should not bypass any review process), this radically improves the available pool of developers.

For research/academic software it is also beneficial to generate a Digital Object Identifier (DOI) for each release.
This allows your software to be easily cited in publications and makes it clear which version of your software was used to generate results in a given publication.
Another method is to use a publication that provides the idea of the software.

When selecting developers for a given task you should consider the skills/knowledge of the developer, the time required to complete the task and the deadline for the task.
If the deadline and time required are similar then it is better to choose a developer with the existing skills.
If there is sufficient time between the deadline and the estimated time to complete the task then it is better to use it as an opportunity to train a developer.

## (6) Packaging and Distribution

### Releases

A good release process depends greatly on the nature of the software project.
For instance, a small tool used by a handful of users on a unique beamline could probably be released very quickly with minimal effort or fuss given that the users are likely closely involved with the development of said tool.
Whereas a large framework used by multiple different scientific techniques at different facilities (such as the Mantid project) requires a much more involved release process to ensure the software is suitable for use by all intended audiences.

This section will assume you have a substantial number of users which you do not directly interact with during your development process, and as such cannot simply release and hope for the best because the users you do interact with have not reported any issues.

In order for any potential issues in your software to be found and rectified you may wish to release beta or release candidate versions of your software before the official release.
This release is intended for "power users" who do not mind testing your software for the benefit of the wider audience of your software (a typical example is a beamline scientist who wants to ensure your software works before providing it to their visiting users).

The length of the beta period is determined by your release cycle and the number of users you estimate use your software.
There is no generic rule for this other than ensuring that all (or as close to as possible) use cases of your software have been tested by users who specialise in that area.

There can be any number of release candidates before the final release version is selected.
As the name suggests a release candidate should be generated in exactly the same manner as a release (the only difference being the version number).

To ensure users approach the new version with realistic expectations it is essential to provide sufficiently detailed release notes at the start of your beta testing period.
These should summarise the changes made to your software since the last release, possibly highlighting some specific new features (this is where you "sell" your new version and give a reason for users to upgrade).

It is essential that all breaking changes, i.e. those that require the user to perform different steps to achieve the same outcome, are listed.
This will prevent issues when users attempt to use incompatible existing workflows with your new version.

If your software in in any way involved in security or safety (in terms of either data, equipment or life) fixes for identified issues compromising safety or security must be listed in your release notes.

It is recommended to tag and sign the release in your SCM system, in the case of Git this involves creating a tag from the code that was used to generate your release package and signing it with either a project or maintainers PGP key.
This is not an essential step, but is good practice to allow verification of historic releases.

### Maintenance period

After a release is the opportune time to perform invasive maintenance tasks that would otherwise be too much of a risk to carry out closer to a release.
Such tasks may include;
updating dependency versions, addressing code quality issues, refactoring, code restructuring, deploying new functionality that interacts with large portions of the code, etc.

### Packaging

In order to reduce friction for users when they want to setup your software an intuitive packaging method is essential.
Exactly what this involves varies depending on the nature of your project, as such this section will not go into great detail about specific options but rather the requirements of an installer and method of choosing an appropriate installation method for your software.

The goal of an installer to to give your users with a working copy of your software.
They should not have to care about any implementation specifics or having to install additional dependencies to simply make your software run.
This is the first requirement.

Once installed your software should not conflict with any other software a user may have installed on their machine.
A common example of this is when applications, at some level, depend on the same libraries.
In which case the latest installed software package may remove or overwrite the third party library installed by the first software package.

As the technology becomes more popular it is worth looking into cross platform container based means of distribution (for example, Docker and friends).
This allows you to ship a software package in an already configured and working state being safe in the knowledge it will function in the same way on the user's computer.
Different containerization systems have their own caveats and there is no "one size fits all" solution.

### Cross platform

Unless your software specifically targets high performance computing systems such as clusters or distributed compute platforms then no assumption can realistically be made about how, and specifically on what platform, a user will expect to run your software.

For this reason it is highly desirable (or even essential) that your software is designed to be run on or at least easily portable to multiple operating systems and architectures.

Thanks to modern development tools, libraries and build systems this is not a complex task.
Cross platform development tends to not add significant complexity or time cost to delivering a piece of software.

It is possible to only officially support a single or narrow selection of systems, however the use of cross platform libraries and build systems should still be encouraged to allow easy deployment on additional platforms at a later stage if required and to allow collaborators and power users to build and modify your software on whatever computer they may use.

If officially supporting multiple platforms then it is beneficial to encourage a spread of different platforms and operating systems across your development team (a good example of this is the Mantid project), this ensures that there are always multiple people capable of addressing platform specific issues when they arise.

## (7) Support and Documentation

If a piece of software is intended to have a large user base then documentation becomes essential.
Good documentation will prevent the developers having to spend time explaining how to use the software to users.
The hallmarks of good documentation are it is concise, written in a way that is accessible to the target audience (users) and easily available.

The simplest and most common form is online documentation, for example Read the Docs or a wiki page.
This should have a clear structure and be easy to navigate.
An easy way to achieve this is to have a contents page and to make the pages searchable so users can easily find the relevant information.
An easy way to achieve this is to have tags that summarise the main themes of each page.
The online documentation should be version controlled so it is possible to revert changes and to follow its evolution.

Projects may benefit from having a landing page introducing the project and directing users to commonly used or important resources.
Hugo and GitHub Pages are a common choice for this.

Hugo is a powerful and fast static website generator.
It can be used for very basic less than 10 page sites up to large blogs/news sites, supports themeing and customisation and works with content defined in Markdown.

GitHub Pages is a free hosting service provided by GitHub, this allows you to commit your website content to a specific branch and have it served by GitHub.
The large benefit here is avoiding the cost and time of maintaining the infrastructure required to host your projects website.

An increasingly popular method of documentation is the video tutorial.
These are extremely useful to users as it allows them to easily see how to use the software, however they have a large time cost to create them.
All documentation should be kept up to date, but video tutorials may require significant work if the software undergoes a large change.

Face to Face communication is often the most efficient and effective way to understand a user's question/comment.
This allows for a conversation to occur with more probing questions to improve the developer's understanding and to overcome any unfamiliar terminology.
As a result it is important to have some local support, where developers are preferably in close proximity to their users.
Face to Face contact also has the benefit of increasing the user experience and users are more likely to report problems/bugs to the development team if they can easily speak to them.

The documentation discussed so far has focused on the users.
It is also valuable to have developer documentation.
This documentation could contain information on the standards used in the code, how to set up a development version and appropriate tutorials/information.

A key activity for any piece of software is the user support.
Unlike documentation this is more interactive between developers and users.
As a minimum email support should be provided to the users in a location that is easy for them to find.
The emails should be checked regularly and initial responses should be within a day or two.
The initial response may be to ask for more details, to arrange to meet with them face to face or to say that it is being worked on.
Providing effective user support will give users more confidence in the software.

## (8) SINE2020

TODO

## (9) Conclusion

The implementation of software standards to a computational project has numerous benefits.
It fundamentally allows for the software to be developed and maintained easily by a distributed team, while providing support to users.
There is an initial cost in deciding what those standards should be and the specific recommendations from this paper may not be the best choice in ten years’ time, but choosing a standard will still benefit the project.
To make sure the smooth running of the project a governance model should also be implemented.
Once the development work starts it is important to follow the standards and process that have been set out and these may need updating for long life projects.
To ensure users have a positive experience it is important to provide support and to have a release cycle.

Ultimately the main benefit of software that follows standards is that it allows development to continue even if the developers change.
This is because the standards ensue a uniform code quality.
With the superior code quality will come a more stable and maintainable piece of software.
This can allow the user base to grow and flourish.

## (10) Acknowledgements

TODO
