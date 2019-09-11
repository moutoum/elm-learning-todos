#[derive(Serialize, Deserialize, Clone)]
pub struct Todo {
    #[serde(skip_deserializing)]
    id: u64,
    pub value: String,
}

#[derive(Default)]
pub struct Todos {
    todos: Vec<Todo>,
    index: u64,
}

impl Todos {
    pub fn list(&self) -> Vec<Todo> {
        self.todos.clone()
    }

    pub fn get_by_id(&self, id: u64) -> Option<Todo> {
        self.todos
            .iter()
            .find(|todo| todo.id == id)
            .map(|todo| todo.clone())
    }

    pub fn add(&mut self, todo_value: String) -> u64 {
        self.index += 1;
        let todo = Todo {
            id: self.index,
            value: todo_value,
        };
        self.todos.push(todo);
        self.index
    }

    pub fn delete(&mut self, id: u64) {
        self.todos.retain(|todo| todo.id != id);
    }
}
