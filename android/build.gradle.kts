allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = File(rootDir, "../build")

subprojects {
    project.buildDir = File(rootProject.buildDir, project.name)
}

subprojects {
    afterEvaluate {
        // Force compileSdk 36 for all subprojects including isar_flutter_libs
        if (project.hasProperty("android")) {
            extensions.configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(36)
            }
        }
        
        // Fix for isar_flutter_libs missing namespace in AGP 8.0+
        if (project.name == "isar_flutter_libs") {
            try {
                val android = extensions.findByName("android")
                if (android != null) {
                    val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                    setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                }
            } catch (e: Exception) {
                println("Failed to set namespace for isar_flutter_libs: ${e.message}")
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
subprojects {
    if (project.name != "app") {
        project.evaluationDependsOn(":app")
    }
}
