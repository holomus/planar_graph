### Operational Rules

#### 1. Branching Strategy

- **Master Branch:**
  - Keeps only release history.
  - Should not be pushed directly into.
  - Each time something is pushed into master new tag should be created
  - Person that merges into master creates new tag

- **Patch Branch:**
  - Used for merging hotfixes or small patches into master.
  - Changes are accumulated here before merging into master.
  - Each merge into master is accompanied by creating a new tag, and the patch version is incremented.
  - Regularly rebased to master to stay synchronized.

- **Debug Branch:**
  - Used for adding new features.
  - At the end of a sprint, a new release is generated from this branch.

#### 2. Oracle Schemas

- **Debug Schema:**
  - Main schema for developers to add their changes.
  - New forms are added here first.
  - Releases are generated from this schema.
  - Translations are applied to this schema.

- **Patch Schema:**
  - Used for adding hotfixes and small patches that need to be fixed on production.
  - Should be consistent with the patch git branch.

- **Release Schema:**
  - QA tests new releases and adds their information.
  - Data migrations are tested here.
  - Structural changes (other migration checks) are not tested here.
