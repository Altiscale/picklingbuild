# picklingbuild
Build script to produce RPM for Scala pickling jars/libs.
We use source branch `0.11.x` to refer to all `0.11.x` version. This does NOT distinguish
the Scala version such as `2.10` or `2.11`.

# Known Issues and Workarounds
- Java8 build env not available on Jenkin. We utilize docker and openjdk8 to provide such env.
- sbt not available on jenkin. We utilize docker to provide `sbt`
- `0.11.x` is not production available. No release tag for different Scala version.
We utilize existing maven repo to download the pre-built JARs.
Not ideal, but this provides the JAR. Eventually we will need to build these from source.
We use the `BUILD_BRANCH` env variable to distinguish the download URL and produce RPM respectively
for scala 2.10 and 2.11. Therefore, you will see 2 `BUILD_BRANCH` for each scala version with the same
code.
- `0.11.0-M1` is preferred and tested by Spark Controller team, although, `0.11.0-M2` is available
when we contacted this JAR, we will still use the M1 version.

