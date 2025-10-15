use std::path::PathBuf;

use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct File {
    key: u64,
    dir: PathBuf,
}

impl File {
    pub fn validate(&self) {}
}

#[derive(Serialize, Deserialize)]
pub struct Remote {}

impl Remote {
    pub fn validate(&self) {}
}
