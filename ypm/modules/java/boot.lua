---@diagnostic disable: undefined-global
return {
    version = "1.0",
    name = "java",
    load = yock_todo_loader,
    ark = {
        pull = import("./ark/pull"),
        load = import("./ark/load"),
        sail = import("./ark/sail")
    }
}
