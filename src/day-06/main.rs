use std::fs;

fn a(mut state: [usize; 9], days: i32) -> usize {
    for _ in 0..days {
        let zeroes = state[0];
        for i in 0..8 {
            state[i] = state[i + 1];
        }
        state[6] = state[6] + zeroes;
        state[8] = zeroes;
    }

    return state.iter().sum();
}

fn main() {
    let input = fs::read_to_string("./input").expect("Something went wrong reading the file");

    let mut state: [usize; 9] = [0; 9];

    for i in 0..9 {
        state[i] = input.matches(&i.to_string()).count();
    }

    println!("{}", a(state, 80));
    println!("{}", a(state, 256));
}
