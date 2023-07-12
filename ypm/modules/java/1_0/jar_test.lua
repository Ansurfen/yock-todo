local jar = import("./jar")
jar({
    object = "app.jar",
    verbose = true,
    manifest = "MANIFEST.MF",
    dir = "."
})
jar({
    object = "app.jar app2.jar",
    verbose = true,
    dir = "."
})
