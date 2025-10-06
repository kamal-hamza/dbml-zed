// Re-export the main extension module
mod dbml;

// Tests for the DBML extension
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_module_compiles() {
        // Basic compilation test
        assert!(true);
    }
}
