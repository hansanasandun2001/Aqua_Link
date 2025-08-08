buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Define build directory configuration
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {

   
    
    // Set NDK version for all subprojects - UPDATED TO STABLE VERSION
    android {
        ndkVersion = "26.3.11579264"  // This version has proper source.properties
    }
    
    // Ensure proper project evaluation order
    afterEvaluate {
        project.evaluationDependsOn(":app")
    }
}

// Clean task configuration
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
    followSymlinks = false  // Safety measure when deleting
}
