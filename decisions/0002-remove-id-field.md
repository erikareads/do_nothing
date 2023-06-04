# Remove Step Id Field

## Context and Problem Statement

The step id field is only used in one place during execution,
and it only plays a minor role.

Specifically, it is interpolated during an automated step to say that that step is executed automatically.
However, if we instead say "This step is executing automatically" without the id,
We can remove the id field and save a bunch of line noise in the instantiation of a DoNothing script.

## Considered Options

* Leave id field as is
* Remove the id field and change the automated notes

## Decision Outcome

Remove the id field and change the automated notes

The id field is currently being used for too little effect,
and reducing the line noise in a self-documenting script is valuable.
