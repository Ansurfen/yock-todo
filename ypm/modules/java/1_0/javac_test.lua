local javac = import("./javac")
javac({
    charset = "utf-8",
    object = "./build",
    mainClass = [[.\src\main\java\com\ansurfen\*.java]],
    sourcepath = {
        "./src/main/java",
        "./src/main/java/com/ansurfen/view/*.java"
    }
})
