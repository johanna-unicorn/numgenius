"""Math operations module."""


def add(a: float, b: float) -> float:
    """Adds two numbers."""
    return a + b


def subtract(a: float, b: float) -> float:
    """Subtracts two numbers."""
    return a - b


def multiply(x, y):
    """Multiply two numbers."""
    return x * y


def divide(a, b):
    """Divide two numbers."""
    try:
        return a / b
    except ZeroDivisionError:
        return "Division by zero is not allowed"
