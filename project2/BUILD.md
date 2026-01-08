# Project2 Build Guide

## Technology Stack
- Java 17 (OpenJDK)
- Spring Boot 3.2.1
- Gradle 8.5

## Prerequisites
- Java 17 or higher
- Gradle 8.x (or use included wrapper)

## Build Commands

### Build Project
```bash
gradle build
# or with wrapper
./gradlew build
```

### Clean Build
```bash
gradle clean build
# or with wrapper
./gradlew clean build
```

### Run Tests
```bash
gradle test
# or with wrapper
./gradlew test
```

### Run Application
```bash
java -jar build/libs/demo-0.0.1-SNAPSHOT.jar
```

## Build Output

### Success Indicators
```
Welcome to Gradle 8.5!

Starting a Gradle Daemon (subsequent builds will be faster)
> Task :compileJava
> Task :processResources
> Task :classes
> Task :resolveMainClassName
> Task :bootJar
> Task :jar
> Task :assemble
> Task :compileTestJava NO-SOURCE
> Task :processTestResources NO-SOURCE
> Task :testClasses UP-TO-DATE
> Task :test NO-SOURCE
> Task :check UP-TO-DATE
> Task :build

BUILD SUCCESSFUL in 17s
5 actionable tasks: 5 executed
```

### Exit Code
- **Success**: `0` with message `BUILD SUCCESSFUL`
- **Failure**: Non-zero with `BUILD FAILED`

### Build Artifacts
- Location: `build/libs/`
- Files:
  - `demo-0.0.1-SNAPSHOT.jar` - Executable Spring Boot JAR
  - `demo-0.0.1-SNAPSHOT-plain.jar` - Plain JAR (without dependencies)

## Application Configuration

### Application Properties
File: `src/main/resources/application.properties`

```properties
server.port=8080
server.address=0.0.0.0
server.servlet.context-path=/api/spring
```

### Endpoints
- Base URL: `http://localhost:8080/api/spring`
- Health: Application provides basic REST endpoint

## CI/CD Integration

### GitHub Actions
Workflow file: `.github/workflows/project2-build.yml`

Triggers:
- Push to `main` branch with changes in `project2/`
- Pull requests to `main` branch

### Build Steps
1. Checkout code
2. Setup Java 17 (Temurin distribution)
3. Cache Gradle dependencies
4. Build with Gradle
5. Run tests
6. Upload JAR artifacts
7. Upload test results

## Gradle Tasks

### Common Tasks
```bash
# List all tasks
gradle tasks

# Build without tests
gradle build -x test

# Run with specific profile
gradle bootRun --args='--spring.profiles.active=dev'

# Generate dependency report
gradle dependencies
```

## Troubleshooting

### Build Fails - Daemon Issues
```bash
# Stop all Gradle daemons
gradle --stop

# Clean and rebuild
gradle clean build
```

### Permission Denied (gradlew)
```bash
# Grant execute permission
chmod +x gradlew
./gradlew build
```

### Out of Memory
```bash
# Increase heap size
export GRADLE_OPTS="-Xmx2048m"
gradle build
```

### Java Version Mismatch
```bash
# Check Java version
java -version

# Should be Java 17
# If not, install Java 17 or set JAVA_HOME
export JAVA_HOME=/path/to/java17
```

## Development

### Run in Development Mode
```bash
gradle bootRun
```

### Watch for Changes (with Spring DevTools)
Add to `build.gradle`:
```gradle
dependencies {
    developmentOnly 'org.springframework.boot:spring-boot-devtools'
}
```

## Build Optimization

### Parallel Execution
Add to `gradle.properties`:
```properties
org.gradle.parallel=true
org.gradle.caching=true
```

### Skip Tests (for faster builds)
```bash
gradle build -x test
```
