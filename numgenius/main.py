"""Main module."""

from numoperations.operations import add, divide, multiply, subtract
from numgenius.views import get_numbers, show_invalid_operation, show_result, show_welcome


def main() -> None:
    """Main function."""
    show_welcome()

    while True:
        operation = input(
            "Here are the options:\n"
            "    [1] Add numbers\n"
            "    [2] Subtract numbers\n"
            "    [3] Multiply numbers\n"
            "    [4] Divide numbers\n"
            "    [5] Exit\n\n"
            "What would you like to do? Enter the number > "
        )
        match operation:
            case "1":
                a, b = get_numbers()
                result = add(a, b)
                show_result(result)
            case "2":
                a, b = get_numbers()
                result = subtract(a, b)
                show_result(result)
            case "3":
                a, b = get_numbers()
                result = multiply(a, b)
                show_result(result)
            case "4":
                a, b = get_numbers()
                result = divide(a, b)
                show_result(result)
            case "5":
                break
            case _:
                show_invalid_operation()


if __name__ == "__main__":
    main()
