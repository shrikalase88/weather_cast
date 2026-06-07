allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// SDK Version Force with "Already Evaluated" protection
subprojects {
    val applySdkOverride = {
        if (project.hasProperty("android")) {
            val android = project.extensions.findByName("android")
            if (android is com.android.build.gradle.BaseExtension) {
                android.compileSdkVersion(36)
                android.defaultConfig.targetSdk = 36
                if (android.defaultConfig.minSdk == null || android.defaultConfig.minSdk!! < 21) {
                    android.defaultConfig.minSdk = 21
                }
            }
        }
    }

    if (project.state.executed) {
        applySdkOverride()
    } else {
        project.afterEvaluate {
            applySdkOverride()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
