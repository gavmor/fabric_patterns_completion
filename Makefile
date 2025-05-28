.PHONY: test

# Default target
all: test

# Run tests
test:
	./bash_unit ./tests/test_*

# Install dependencies (add specific dependencies as needed)
# install:
#     @echo "Installing dependencies..."
#     # Add dependency installation commands here

# Help target
help:
    @echo "Available targets:"
    # @echo "  test    - Run the test suite"
    # # @echo "  install - Install dependencies"
    # @echo "  help    - Show this help message"