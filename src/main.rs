use std::{path::Path, time::Duration};

use clap::Parser;
use file_hashing::{get_hash_file, get_hash_folder};
use indicatif::ProgressBar;
use md5::{Digest, Md5};

mod cli;
mod config;

fn sync() {}

fn create(path: &Path) {
    let mut algo = Md5::new();

    let hash = if path.is_file() {
        get_hash_file(path, &mut algo).unwrap()
    } else if path.is_dir() {
        let cores = num_cpus::get();
        // let progress = ProgressBar::new(1000);
        let progress = ProgressBar::new_spinner();
        progress.enable_steady_tick(Duration::from_millis(100));
        let hash = get_hash_folder(path, &mut algo, cores, |_| {
            // progress.inc(1);
        })
        .unwrap();
        progress.finish();
        hash
    } else {
        panic!("Unsupported file type.");
    };
    println!("{:?}", hash);
}

fn main() {
    let args = cli::Cli::parse();
    match args.command {
        cli::Commands::Sync => sync(),
        cli::Commands::Create { item } => create(&item),
    }
}
