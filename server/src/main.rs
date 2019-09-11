#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use]
extern crate rocket;
#[macro_use]
extern crate rocket_contrib;
#[macro_use]
extern crate serde_derive;

mod todos;

use rocket::response::status::{Created, NotFound};
use rocket::State;
use rocket_contrib::json::{Json, JsonValue};
use std::sync::Mutex;
use todos::{Todo, Todos};

fn status_error<S: AsRef<str>>(text: S) -> JsonValue {
    json!({ "status": "error", "text": text.as_ref() })
}

#[get("/todos")]
fn list(state: State<Mutex<Todos>>) -> Json<Vec<Todo>> {
    let todos = state.lock().unwrap();
    Json(todos.list())
}

#[get("/todo/<id>")]
fn get(id: u64, state: State<Mutex<Todos>>) -> Result<Json<Todo>, NotFound<()>> {
    let todos = state.lock().unwrap();
    todos.get_by_id(id).ok_or(NotFound(())).map(Json)
}

#[post("/todo", format = "json", data = "<todo>")]
fn post(todo: Json<Todo>, state: State<Mutex<Todos>>) -> Created<JsonValue> {
    let mut todos = state.lock().unwrap();
    let id = todos.add(todo.0.value);
    Created(format!("/api/todo/{}", id), Some(json!({ "id": id })))
}

#[delete("/todo/<id>")]
fn delete(id: u64, state: State<Mutex<Todos>>) {
    let mut todos = state.lock().unwrap();
    todos.delete(id);
}

#[catch(404)]
fn not_found() -> JsonValue {
    status_error("resource not found")
}

fn main() {
    rocket::ignite()
        .mount("/api", routes![list, get, post, delete])
        .register(catchers![not_found])
        .manage(Mutex::new(Todos::default()))
        .launch();
}
