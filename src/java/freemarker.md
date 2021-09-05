# Create a Maven Plugin with FreeMarker

Sometimes it is quite convinent to generate Java source code from a specification, such as from a `.yaml` file. 

You can create a maven plugin to read the `.yaml` specification and generate the Java source code into the `target/generated-sources/` directory using [FreeMarker](https://freemarker.apache.org/), a Java Template Engine.


To create a maven plugin with freemarker, you need the following dependencies. And you will typically name your plugin `<yourplugin>-maven-plugin`.

```xml
  <dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-plugin-api</artifactId>
      <version>3.6.3</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven.plugin-tools</groupId>
      <artifactId>maven-plugin-annotations</artifactId>
      <version>3.6.0</version>
      <scope>provided</scope>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-project</artifactId>
      <version>2.2.1</version>
    </dependency>
    <dependency>
      <groupId>org.freemarker</groupId>
      <artifactId>freemarker</artifactId>
      <version>2.3.30</version>
    </dependency>
  </dependencies>
```

As an example, we are going to create a maven plugin named `client-notification-maven-plugin` which reads a `YAML` specification and generates Java source code.

## Mojo

To create the plugin, we need to first create a Java mojo class representing the plugin's goals `generate`.

```java
@Mojo(name = "generate", defaultPhase = LifecyclePhase.GENERATE_SOURCES)
public class ClientNotificationMojo extends AbstractMojo {
}
```

To use the plugin in other Java projects, we need to specify the corresponding goal `generate` , as follows

```xml
<build>
  <plugins>
    <plugin>
      <groupId>com.lakritsoft</groupId>
      <artifactId>client-notification-maven-plugin</artifactId>
      <executions>
        <execution>
          <goals>
            <goal>generate</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

### Package of generated source code

When generating the Java source code, it is often desired to specify the Java package. 

Assume the project has the groupId and artifactId below:

```xml
<groupId>com.lakritsoft.myservice</groupId>
<artifactId>app</artifactId>
```

And we want the generated the souce code to be located at `com.lakritsoft.myservice.clientnotification` package.

```xml
app/
  target/
    generated-sources/
      client-notification/
	java/
          com.lakritsoft.myservice.clientnotification // package name
  pom.xml
pom.xml
```

To find out the project groupId and specify the source package:

```java
@Mojo(name = "generate", defaultPhase = LifecyclePhase.GENERATE_SOURCES)
public class ClientNotificationMojo extends AbstractMojo {

  @Parameter(defaultValue = "target/generated-sources/client-notification/java")
  private File outputDirectory;

  @Parameter(
      defaultValue = "${project}",
      required = true,
      readonly = true)
  private MavenProject project
  
  @Override
  public void execute() throws MojoExecutionException, MojoFailureException {
    String srcPackage = project.getGroupId() + "." + "clientnotification";
    File srcDir = new File(outputDirectory, srcPackage.replace(".", "/"));

    srcDir.mkdirs();

    project.addCompileSourceRoot(outputDirectory.getAbsolutePath());  
  }
}
```
## Read the YAML specification from the Java Mojo Class

If the `YAML` specifications is published to Maven artifact repository, such as Nexus, as `zip` format, we can use `maven-dependecy-plugin` to unpack the zip file.

```xml
 <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-plugin-plugin</artifactId>
        <version>3.6.0</version>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-dependency-plugin</artifactId>
        <executions>
          <execution>
            <id>unpack-yaml-specification</id>
            <goals>
              <goal>unpack</goal>
            </goals>
            <phase>compile</phase>
            <configuration>
              <artifactItems>
                <artifactItem>
                  <groupId>com.example</groupId>
                  <artifactId>yaml-specification</artifactId>
                  <version>${version}</version>
                  <type>zip</type>
                  <outputDirectory>${project.build.directory}/classes/specs</outputDirectory>
                  <includes>specification.yaml</includes>
                </artifactItem>
              </artifactItems>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
```

With `maven-dependency-plugin`, We unpack the YAML files into the project `classpath` - `app/target/classes/specs`.

And to read the YAML file, we can ues Java `ClassLoader`:

```java
@Mojo(name = "generate", defaultPhase = LifecyclePhase.GENERATE_SOURCES)
public class ClientNotificationMojo extends AbstractMojo {

  @Override
  public void execute() throws MojoExecutionException, MojoFailureException {

     InputStream is =
        this.getClass().getClassLoader().getResourceAsStream("specs/specification.yaml");

  }
}
```

## FreeMarker

We have now covered how to create the src package for the generated clasess, and how to read YAML files.
Next step is to generate the Java source files using FreeMaker template engine.

We create the template files and put them inside the `resources` directory: 

```txt
client-notification-maven-plugin
  src/
    main/
      java/
      resources/ 
        tempaltes/
          ExampleJava.ftlh
```

The content of the `ExampleJava.ftlh` is as follows:

```java
package ${package};

public class ExampleJava {

}
```

Then in our Java Mojo class, we can process the template and generate the `ExampleJava.java` source file:

```java

  project.addCompileSourceRoot(outputDirectory.getAbsolutePath());
  Configuration cfg = new Configuration(Configuration.VERSION_2_3_29);
  cfg.setNumberFormat("computer");

  try {
      cfg.setClassForTemplateLoading(this.getClass(), "/templates/");

      Template temp = cfg.getTemplate("ExampleJava.ftlh");
      temp.process(Map.of("package", srcPackage), new FileWriter(new File(srcDir, "ExampleJava.java")));

    } catch (IOException | TemplateException e) {
      getLog().error(e);
      throw new RuntimeException(e);
    }
```

With FreeMarker, you can perform `if` condition and loop through a Java collection to generate dynamic content.

One example is that the user of our plugin want to specify a list of notification types and the generated Java source code should be different based on the configuration: 

```xml
<build>
  <plugins>
    <plugin>
      <groupId>com.lakritsoft</groupId>
      <artifactId>client-notification-maven-plugin</artifactId>
      <executions>
        <execution>
          <goals>
            <goal>generate</goal>
          </goals>
	  <configuration>
             <notificationTypes>
                <notificationType>EMAIL</notificationType>
                <notificationType>SMS</notificationType>
                <notificationType>WEB_SOCKET</notificationType>
              </notificationTypes>
          </configuration>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

We can read the user-specified `notificationTypes` configuration inside the Mojo class:

```java
@Mojo(name = "generate", defaultPhase = LifecyclePhase.GENERATE_SOURCES)
public class ClientNotificationMojo extends AbstractMojo {

  @Parameter(
      property = "notificationTypes",
      required = false,
      readonly = true)
  private String[] notificationTypes 
}
```

We can then pass the `notificationTypes` further to the FreeMarker template:

```java
Map<String, Object> options = Map.of("package", srcPackage, "notificationTypes", notificationTypes);

temp.process(options, new FileWriter(new File(srcDir, "ExampleJava.java")));
```

Inside the `.ftlh` file, we can loop the notification `java.util.List` as


```java
package ${package};

public class ExampleJava {
  <#list notificationTypes as no>
     <#assign idx = no?index>
     .....
     .....
  </#list>
}
```

You can read more about FreeMarker directives at [Apache FreeMarker Manual](https://freemarker.apache.org/docs/index.html).
