use std::{
    collections::HashSet, sync::{LazyLock, RwLock}, thread::sleep, time::Duration
};

use flutter_rust_bridge::{frb, DartFnFuture};

struct AppState {
    current_num: RwLock<i32>,
    liked: RwLock<HashSet<i32>>,
}

static APP_STATE: LazyLock<AppState> = LazyLock::new(|| AppState {
    current_num: RwLock::new(0),
    liked: RwLock::new(HashSet::new()),
});

#[frb(sync)] // Synchronous mode for simplicity of the demo
pub fn add_one() {
    *APP_STATE.current_num.write().unwrap() += 1;
}

#[frb(sync)]
pub fn get_num() -> i32 {
    *APP_STATE.current_num.read().unwrap()
}

#[frb(sync)]
pub fn whether_like(num: i32) -> bool {
    APP_STATE.liked.read().unwrap().contains(&num)
}

#[frb(sync)]
pub fn add_like() {
    let num = *APP_STATE.current_num.read().unwrap();
    APP_STATE.liked.write().unwrap().insert(num);
}

#[frb(sync)]
pub fn get_all_liked() -> Vec<i32> {
    APP_STATE
        .liked
        .read()
        .unwrap()
        .iter()
        .map(|n| *n)
        .collect::<Vec<i32>>()
}

#[frb(dart_async)]
pub async fn sum_all(dart_callback: impl Fn(i32) -> DartFnFuture<i32>) {
    let sum: i32 = APP_STATE.liked.read().unwrap().iter().sum();
    sleep(Duration::from_secs(1));
    dart_callback(sum).await;
} 

#[frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
