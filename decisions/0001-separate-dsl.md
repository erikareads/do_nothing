# Separate the DSL from the core library

## Context and Problem Statement

This decision concerns adding a Builder API which uses functions to build and validate the data structure.
And what to do with the DSL in light of that Builder API.

The DoNothing scripting framework is meant to be a gradual automation tool for DevOps scripting.
As such, DevOps considerations like dependency management are relevant to the library.

The core premise of DoNothing is that you specify a validate data structure,
And then walk that structure during execution.

The DSL is a simple way of specifying that validated data structure,
But it is not essential to its construction.

Inspiration for the Builder API comes from considering ports of DoNothing to other popular DevOps programming languages, that do not have access to Spark for DSL creation.

## Considered Options

* Leave the library as is
* Separate the DSL into another library DoNothingDsl
* Add the builder API while keeping the DSL in DoNothing

## Decision Outcome

Separte the DSL into another library DoNothingDsl

This option significantly reduces the lines of code required to run a DoNothing script, by removing Spark as a guaranteed dependency. The second library will depend on DoNothing, will allow for a single line `Mix.install` that allows access to the DSL as before. 

It also allows for a similar user experience of the base library across ported languages.
