allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
subprojects {
    plugins.withId("com.android.library") {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val namespaceMethod = android.javaClass.getMethod("getNamespace")
                val currentNamespace = namespaceMethod.invoke(android)
                if (currentNamespace == null) {
                    val setNamespaceMethod = android.javaClass.getMethod("setNamespace", String::class.java)
                    val fallback = "com.fallback." + project.name.replace("-", "_").replace(":", "_")
                    setNamespaceMethod.invoke(android, fallback)
                }
            } catch (e: Exception) {
                // Ignore and fallback silently
            }
        }

        // Clean package attribute from legacy AndroidManifest.xml files
        val manifestFile = project.projectDir.resolve("src/main/AndroidManifest.xml")
        if (manifestFile.exists()) {
            try {
                var content = manifestFile.readText()
                if (content.contains("package=")) {
                    content = content.replace(Regex("""package="[^"]*""""), "")
                    manifestFile.writeText(content)
                }
            } catch (e: Exception) {
                // Ignore and fallback silently
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
