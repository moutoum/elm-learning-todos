#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;

use rocket::State;
use rocket_contrib::json::{Json, JsonValue};
use std::sync::Mutex;

#[derive(Serialize, Deserialize, Clone)]
struct Todo {
    #[serde(skip_deserializing)]
    id: u64,
    value: String,
}

#[derive(Default)]
struct Todos {
    todos: Vec<Todo>,
    index: u64,
}

#[get("/todos")]
fn list(state: State<Mutex<Todos>>) -> Json<Vec<Todo>> {
    let todos = state.lock().unwrap();
    Json(todos.todos.clone())
}

#[post("/todo", format = "json", data = "<todo>")]
fn post(mut todo: Json<Todo>, state: State<Mutex<Todos>>) -> JsonValue {
    let mut todos = state.lock().unwrap();
    todo.0.id = todos.index;
    todos.index += 1;
    todos.todos.push(todo.0);
    json!({ "status": "ok" })
}

#[delete("/todo/<id>")]
fn delete(id: u64, state: State<Mutex<Todos>>) -> JsonValue {
    let mut todos = state.lock().unwrap();
    todos.todos.retain(|todo| todo.id != id);
    json!({ "status": "ok" })
}

#[catch(404)]
fn not_found() -> JsonValue {
    json!({
    "status": "error",
    "text": "resource not found",
    })
}

fn main() {
    rocket::ignite()
        .mount("/api", routes![list, post, delete])
        .register(catchers![not_found])
        .manage(Mutex::new(Todos::default()))
        .launch();
}
