# Swagger

We often use Swagger to generate REST API documentations and even REST client. However, if put all the API definition in a single Swagger `.yaml` file, it gets really messy as the application grows.

To have a clean Swagger configuration, first create a multiple module maven project, as follows:
```
project
  - rest-api
    - v1
      common.yaml 
      pet.yaml
      pet-img.yaml
      store.yaml
      user.yaml
      petstore-api.yaml
    pom.xml
  - rest-client
    - v1
    pom.xml
  pom.xml
```
- The `rest-api` module will be used on the server side to implement the generated REST interfaces. 
- The `rest-client` module can be used in component tests or other services integrating with your service.


## REST API generation

In the `petstore-api.yaml` file, we specify the service resources as:

```yaml
openapi: '3.0.0'
info:
  title: Pet Store API
  description: Pet store
  version: '0.1'
  termsOfService: url

paths:
  /pet/{petId}
    $ref: 'pet.yaml#/api'
  /pet/{petId}/images
    $ref: 'pet-img.yaml#/api'
  /store/{storeId}
    $ref: 'store.yaml#/api'
  /user/{username}
    $ref: 'user.yaml#/api'
```

We then specify the API details of the sub-resouces in each swagger yaml file, for example `pet.yaml`:

```yaml
openapi: '3.0.0'

api:
  put:
    tags:
      - Pet
    summary: Create Pets
    operationId: createPet
    parameters:
      - $ref: 'common.yaml#/components/parameters/petId'
    requestBody:
      required: true
      description: OK
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/UpdatePetRequest'
    responses:
      '200':
        description: OK
        content:
          application/json:
            schema: 
              $ref: '#/components/schemas/UpdatePetResponse'
      '404':
        $ref: 'common.yaml#/components/schemas/BadRequest'
  delete:
    # .....

components:
  schemas:
    UpdatePetRequest:
      type: object
      properties:
        name:
          type: string
        category:
          $ref: '#/components/schemas/PetType'
    UpdatePetResponse:
      # ....    
    PetType:
      type: string
      enum:
        - DOG
        - CAT
```

You can put the common models to a `common.yaml` file and reference it using `$ref: 'common.yaml#/'`. 

```yaml
openapi: '3.0.0'
components:
  parameters:
    petId:
      in: path
      name: petId
      required: true
      schema:
        type: string
  responses:
    BadRequest:
      description: Invalid Parameters
      content:
         application/json
           schema:
            $ref: '#/components/schemas/Error'
  schemas:
    Error:
      type: object
      properties:
        code: 
          type: string
        message:
          type: string  
      required:
         - code
         - message 
```
We now have a way to seperate sub-resourcs definitions into different yaml files. Next is to add the [Swagger Codegen maven plugin](https://github.com/swagger-api/swagger-codegen) to generate the Java models and interfaces.

In the project root `pom.xml`, add the following dependencies. We exclude some dependencies from `io.swagger.codegen.v3` since they are not needed and also cause some Sonarcube vulneribilites.
```xml
<dependencyManagement>
	<dependencies>
	  <dependency>
	    <groupId>io.swagger.codegen.v3</groupId>
	    <artifactId>swagger-codegen-maven-plugin</artifactId>
	    <version>3.0.27</version>
	    <exclusions>
	      <exclusion>
		<groupId>org.apache.maven</groupId>
		<artifactId>maven-core</artifactId>
	      </exclusion>
	      <exclusion>
		<groupId>io.swagger.codegen.v3</groupId>
		<artifactId>swagger-codegen-generators</artifactId>
	      </exclusion>
	      <exclusion>
		<groupId>io.swagger</groupId>
		<artifactId>*</artifactId>
	      </exclusion>
	      <exclusion>
		<groupId>commons-io</groupId>
		<artifactId>commons-io</artifactId>
	      </exclusion>
	    </exclusions>
	  </dependency>
	  <dependency>
	    <groupId>org.springframework.boot</groupId>
	    <artifactId>spring-boot-starter-web</artifactId>
	    <version>2.5.2</version>
	    <scope>provided</scope>
	  </dependency>
	</dependencies>
</dependencyManagement>
```

Then in the `rest-api/pom.xml`, we have the following:

```xml
<dependencies>
	<dependency>
	    <groupId>io.swagger.codegen.v3</groupId>
	    <artifactId>swagger-codegen-maven-plugin</artifactId>
	</dependency>
	<dependency>
	    <groupId>org.springframework.boot</groupId>
	    <artifactId>spring-boot-starter-web</artifactId>
	</dependency>
</dependencies>

<build>
	<plugins>
	    <plugin>
		<groupId>io.swagger.codegen.v3</groupId>
		<artifactId>swagger-codegen-maven-plugin</artifactId>
		<version>3.0.27</version>
		<executions>
		    <execution>
			<id>generate-petstore-api</id>
			<goals>
			    <goal>generate</goal>
			</goals>
			<configuration>
			    <inputSpec>${project.basedir}/v1/petstore-api.yaml</inputSpec>
			    <language>spring</language>
			    <generateApiTests>false</generateApiTests>
			    <generateModelTests>false</generateModelTests>
			    <configOptions>
				<apiPackage>se.petstore.generated.api.rest</apiPackage>
				<modelPackage>se.petstore.generated.api.rest.model</modelPackage>
				<dateLibrary>java8</dateLibrary>
				<async>true</async>
				<java8>true</java8>
				<library>spring-boot</library>
				<useTags>true</useTags>
				<interfaceOnly>true</interfaceOnly>
			    </configOptions>
			</configuration>
		    </execution>
		</executions>
	    </plugin>
	</plugins>
</build>
```

## REST Client generation

To generate REST client, add the following to `rest-client/pom.xml` file.

```xml
<dependencies>
	<dependency>
	    <groupId>se.petstore</groupId>
	    <artifactId>se.petstore.rest-api</artifactId>
	    <version>${project.version}</version>
	</dependency>
</dependencies>
<build>
	<plugins>
	    <plugin>
		<groupId>io.swagger.codegen.v3</groupId>
		<artifactId>swagger-codegen-maven-plugin</artifactId>
		<version>3.0.27</version>
		<executions>
		    <execution>
			<id>generate-petstore-client</id>
			<goals>
			    <goal>generate</goal>
			</goals>
			<configuration>
			    <inputSpec>${project.parent.basedir}/rest-api/v1/petstore-api.yaml</inputSpec>
			    <language>java</language>
			    <generateApis>true</generateApis>
			    <generateModels>false</generateModels>
			    <generateApiTests>false</generateApiTests>
			    <generateModelTests>false</generateModelTests>
			    <configOptions>
				<invokerPackage>se.petstore.generated.api.rest.client</invokerPackage>
				<apiPackage>se.petstore.generated.api.rest.client</apiPackage>
				<modelPackage>se.petstore.generated.api.rest.model</modelPackage>
				<dateLibrary>java11</dateLibrary>
				<library>resttemplate</library>
				<useTags>true</useTags>
			    </configOptions>
			</configuration>
		    </execution>
		</executions>
	    </plugin>
	</plugins>
</build>
```

# Swagger UI

In the server application, add the [SpringFox](https://github.com/springfox/springfox) dependency:

```xml
<dependency>
	<groupId>io.springfox</groupId>
	<artifactId>springfox-boot-starter</artifactId>
	<version>3.0.0</version>
</dependency>
```

Then define the `Docket` Bean. The following configuration requires a `Bearer` token when makeing the API calls.

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RestController;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiKey;
import springfox.documentation.service.AuthorizationScope;
import springfox.documentation.service.SecurityReference;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spi.service.contexts.SecurityContext;
import springfox.documentation.spring.web.plugins.Docket;

import java.util.Collections;

@Configuration
class AppConfig {

  @Bean
  public Docket api() {
    AuthorizationScope[] authScopes = new AuthorizationScope[]{
      new AuthorizationScope("global", "accessEverything")
    };
    SecurityReference securityReference = new SecurityReference("Bearer", authScopes);
    SecurityContext securityContext = SecurityContext.builder()
        .securityReferences(Collections.singletonList(securityReference))
        .build();

    return new Docket(DocumentationType.SWAGGER_2)
        .select()
        .apis(RequestHandlerSelectors.withClassAnnotation(RestController.class))
        .paths(PathSelectors.any())
        .build()
        .securitySchemes(Collections.singletonList(new ApiKey("Bearer", "Authorization", "header")))
        .securityContexts(Collections.singletonList(securityContext));
  }
}
```

