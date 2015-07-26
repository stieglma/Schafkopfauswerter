# Schafkopfauswerter
The Schafkopfauswerter is an application to make longterm statistics for playing the game Schafkopf. It is based on
Java 7 and AspectJ. Features of this programs are e.g. a table of all played games, changeable prices, graphical
evaluations per player and overall, a PDF report generation and also importing and exporting old Schafkopf sessions.

This application uses the [pdfBox](https://pdfbox.apache.org/) library for generating the PDF reports and [GRAL](http://trac.erichseifert.de/gral/)
for creating the plots.

* * *
### The Easy Way
If you just want to use the Schafkopfauswerter you can simply download the file `Schafkopfauswerter.jar` from the base
directory. It is a precompiled versions with all features turned on. For those who want to make some changes please read
the next paragraph.

#### Installation
After checking out the project you're almost done, just call `gradle build` to download all needed dependencies
from diverse Maven repositories. If you do not have gradle installed use `./gradlew`. It will install
the necessary gradle version and delegate all further commands to it. 

For an easy integration into IntelliJ IDEA or Eclipse use `gradle idea` or `gradle eclipse`.

##### Useful Commands
* With `gradle run` the application can be started.
* With `gradle fatJar` are jar file containing all dependencies is created, it can be found in `build/libs`
and has the suffix `-all` in its name
