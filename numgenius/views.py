"""Views module."""


def show_welcome() -> None:
    """Prints the welcome message."""
    greeting = " Welcome to Num Genius! "
    print("\n", greeting.center(30, "·"))
    print(("·" * len(greeting)).center(30), "\n")


def show_result(result: float) -> None:
    """Prints the result."""
    print(f"|   The result is: {result}  ( ＾◡＾)っ", "\n")


def show_invalid_operation() -> None:
    """Prints an invalid operation message."""
    print("    Invalid operation. Please try again.  (҂◡_◡)", "\n")


def get_numbers() -> tuple[float, float]:
    """Prompts the user for two numbers and returns them as a tuple."""
    a = float(input("|   First number: "))
    b = float(input("|   Second number: "))
    return a, b
